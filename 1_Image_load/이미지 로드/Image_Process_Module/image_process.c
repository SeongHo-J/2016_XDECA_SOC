#include <linux/module.h>
#include <linux/init.h>
#include <asm/uaccess.h>
#include <asm/ioctl.h>
#include <asm/irq.h>
#include <asm/hardware.h>
#include <asm/io.h>
#include <linux/slab.h>
#include <asm/arch/dma.h>


#define IMG_MAJOR			244
#define IMG_NAME			"eagle-robot-img-proc"

#define ENABLE_IMG_IRQ		0x24401
#define DISABLE_IMG_IRQ		0x24402
#define RD_IMG_DATA			0x24403
#define DISPLAY_IMG_DATA	0x24404	
#define DISPLAY_IMG_DRAW	0x24405	
#define DISPLAY_RESOLUTION	0x24406	
#define CLEAR_SCREEN		0x24407	

#define SCREEN_640_480		0x640480
#define SCREEN_800_600		0x800600
#define SCREEN_1024_768	0x1024768

struct disp_coordinate {
	int x;
	int y;
	unsigned short *img_buf;
};

#define R_PINMUX2	(volatile unsigned int*)0xffe00018
#define R_INTEN	(volatile unsigned int*)0xffe00c0c
#define R_INTMOD	(volatile unsigned int*)0xffe00c00
#define EIRQ_ACT_LOW	0
#define EIRQ_ACT_HIGH	1
#define EIRQ_ACT_BOTH	3
#define EIRQ_TRG_Level	0
#define EIRQ_TRG_Edge	1


#define Source_Addr 0x60000000
volatile unsigned char FPGA_flag = 0;
volatile unsigned int Frame_Buffer;
static int irq_flag=0;


int ImgProc_open(struct inode *, struct file *);
int ImgProc_release(struct inode * , struct file * );
int ImgProc_ioctl(struct inode *, struct file *, unsigned int , unsigned long );

static struct file_operations imgproc_fops = {
	ioctl:	ImgProc_ioctl,
	open:	ImgProc_open,
	release:	ImgProc_release,
};

//void DelayLoop(volatile unsigned long delay_time)
//{
//	while(delay_time)
//		delay_time--;
//}

int ImgProc_open(struct inode * inode, struct file * filp) 
{
	MOD_INC_USE_COUNT;
	return 0;
}

int ImgProc_release(struct inode * inode, struct file * filp) 
{
	MOD_DEC_USE_COUNT;
	return 0;
}

static int imgproc_irq_disable(void)
{
	int ret=0;

	if(irq_flag) {
		free_irq (IRQ_EIRQ5, NULL);
		*R_INTEN &= ~(1<<IRQ_EIRQ5);
		irq_flag=0;
	}
	*(volatile unsigned int *)0xffe02014 = 0x10; // CRT PLL Disable

	return ret;
}

static void ext_irq5_1(int irq, void *dev_id, struct pt_regs *regs)
{
	if(FPGA_flag) {
		imgproc_irq_disable();
		eagle_GDMA((unsigned char *)Frame_Buffer, (unsigned char *)Source_Addr, 180*120*2);
		FPGA_flag = 0;
	}
}

static void ext_irq5_2(int irq, void *dev_id, struct pt_regs *regs)
{
	int i;
	*R_INTEN &= ~(1<<IRQ_EIRQ5);
	for(i=0; i<120; i++) {
		eagle_GDMA((unsigned short *)(Frame_Buffer+0x5a200)+(i*1024),  (unsigned short *)Source_Addr+(i*180), 360);
	}
	*R_INTEN |= (1<<IRQ_EIRQ5);
}


void EIRQ_Mode(unsigned char EIRQ_No, unsigned char Active_Mode, unsigned char Trigger_Mode)
{
	unsigned char IRQ_NUM=0;
	
	if(EIRQ_No>7) {
		printk("\nEIRQ Number is over!\n");
		return;
	}
	if(Active_Mode>3) {
		printk("\nInvalid Active Mode!\n");
		return;
	}
	if(Trigger_Mode > 1) {
		printk("\nInvalid Trigger Mode!\n");
		return;
	}
	IRQ_NUM = EIRQ_No << 1;
	
	*R_INTMOD &= ~(0x3<<IRQ_NUM);
	if(Active_Mode == EIRQ_ACT_HIGH) *R_INTMOD |= (1<<IRQ_NUM);
	else if(Active_Mode == EIRQ_ACT_BOTH) *R_INTMOD |= (3<<IRQ_NUM);
	
	IRQ_NUM = EIRQ_No + 16;
	
	if(Trigger_Mode == EIRQ_TRG_Level) *R_INTMOD &= ~(1<<IRQ_NUM);
	else if(Trigger_Mode == EIRQ_TRG_Edge) *R_INTMOD |= (1<<IRQ_NUM);
}


static int imgproc_irq_enable1(void)
{
	int ret=0;
	
	// to use EIRQ5
	*R_PINMUX2 |= (1<<27);
	*R_PINMUX2 &= ~(1<<26); //EIRQ5
	
	EIRQ_Mode(5, EIRQ_ACT_HIGH, EIRQ_TRG_Edge);
	
	ret = request_irq (IRQ_EIRQ5, &ext_irq5_1, 0, "imgproc-eirq5_1", NULL);
	if (ret != 0) {
		printk(KERN_ERR "Cannot request EIRQ5 Interrupt %d\n", IRQ_EIRQ5);
		return ret;
	}
	*R_INTEN |= (1<<IRQ_EIRQ5);
	irq_flag = 1;
	
	
	return ret;
	
}

static int imgproc_irq_enable2(void)
{
	int ret=0;
	
	// to use EIRQ5
	*R_PINMUX2 |= (1<<27);
	*R_PINMUX2 &= ~(1<<26); //EIRQ5

	EIRQ_Mode(5, EIRQ_ACT_HIGH, EIRQ_TRG_Edge);

	ret = request_irq (IRQ_EIRQ5, ext_irq5_2, 0, "imgproc-eirq5_2", NULL);
	if (ret != 0) {
		printk(KERN_ERR "Cannot request EIRQ5 Interrupt %d\n", IRQ_EIRQ5);
		return ret;
	}
	*R_INTEN |= (1<<IRQ_EIRQ5);
	irq_flag = 1;
	
	return ret;
	
}


#define R_PxOH0	((volatile unsigned int*)0xFFE0A408)
#define R_PxOL0	((volatile unsigned int*)0xFFE0A40c)
static int read_imgae_data(void)
{
	*(volatile unsigned int *)0xffe02014 = 0x10; // CRT PLL Disable
	*(volatile unsigned int *)0xffe01424 = 0x1000002;

	imgproc_irq_enable1();

	FPGA_flag = 1;
	while(FPGA_flag);

	return FPGA_flag;
}

#define WRITE_U32(addr,data) *(volatile unsigned int*)(addr) = (unsigned int)(data)
#define READ_U16(addr)	*(volatile unsigned short*)addr
#define GE_PRPR		(volatile unsigned int*)0xFFE01804UL ///< Packet Read Pointer register
#define GE_PWPR		(volatile unsigned int*)0xFFE01800UL ///< Packet Write Pointer register
#define GE_RCR		(volatile unsigned int*)0xFFE01808UL ///< Rendering Control Register

#define	GEC_RUN2D			1
#define	GEC_CANCEL2D		0

#define GEC_RENDER_BACK		(0<<4)
#define GEC_RENDER_FRONT	(1<<4)

#define	GEC_DITHERNONE		(0x0<<6)
#define	GEC_DITHER2x2		(0x1<<6)
#define	GEC_DITHER4x4		(0x2<<6)

void Display_to_Monitor(void)
{
	int i;
	// SCREENMODE_640x480	25.175Mhz
	unsigned int ModeParam[] = {0x00000000, 0x00000320, 0x00130073, 0x00A00320, 0x0000020D, 0x0007000D,0x002B020B,0x8776,1};
	volatile unsigned int *CRT_reg = (unsigned int *)0xFFE01400;

	WRITE_U32( GE_RCR,0 ); // 2D engine disable
	WRITE_U32( GE_RCR,(1<<8)|GEC_RUN2D|GEC_DITHER2x2|GEC_RENDER_BACK );
	*(volatile unsigned int*)0xFFE01424 = 0x80000;

	for (i= 0; i<7; i++) {
		CRT_reg[i] = ModeParam[i];
	}
	*(volatile unsigned int *)0xffe02014 = 0x100;
	*(volatile unsigned int *)0xffe02018 = ModeParam[i];
	i++;
	*(volatile unsigned int *)0xffe02010 = 0x011 | (ModeParam[i]<<8);

	imgproc_irq_enable2();

}



int SetScreen(int resol)
{
	int ret = -1;
	int i;
	unsigned int ModeParam[][9] = {

		// 0	SCREENMODE_320x240	OSC 8Mhz
		{0x00000000, 0x000001E0, 0x00130053, 0x00A001E0, 0x00000115, 0x0007000D,0x00250103,0x2fd3,4},
		
		// 1 480x243 not yet
		{0x00000000, 0x00000320, 0x00130073, 0x00A00320, 0x0000020D, 0x0007000D,0x002B020B,0x0,0},

		// 2	SCREENMODE_640x480	25.175Mhz
		{0x00000000, 0x00000320, 0x00130073, 0x00A00320, 0x0000020D, 0x0007000D,0x002B020B,0x8776,1},
		
		// 3  800x480   33Mhz
//		{0x00000000, 0x00000420, 0x00130073, 0x01000420, 0x0000020D, 0x0007000D,0x002B020B,0x56d7,1},
		{0x00000000, 0x00000420, 0x00130073, 0x01000420, 0x0000020D, 0x0007000D,0x002B020B,0xf47,1},
		
		// 4	SCREENMODE_800x600  OSC 40Mhz
		{0x00000000, 0x00000420, 0x002300b0, 0x01000420, 0x00000274, 0x0004000a,0x001a0272,0x4fb6,1},
		
		// 5	SCREENMODE_1024x768	OSC 66Mhz
		{0x00000000, 0x00000540, 0x002300c3, 0x01400540, 0x00000325, 0x0007000d,0x00230323,0x17db,1},

		// 6	SCREENMODE_NTSC 27Mhz
		{0x00000000, 0x000006b4, 0x002000a0, 0x011406b4, 0x0000020d, 0x0007000d,0x002b020b,0x217c,1},

		// 7	SCREENMODE_PAL	27Mhz
		{0x00000000, 0x000006c0, 0x00180098, 0x012006c0, 0x00000271, 0x00010007,0x002f026b,0x217c,1},
		
		// 8 480,272 10Mhz
		{0x00000000, 0x0000020d, 0x0002002b, 0x002d020d, 0x0000011e, 0x0002000c,0x000e011e,0x4fb6,4},
	};

	volatile unsigned int *CRT_reg = (unsigned int *)0xFFE01400;

	if(resol <= 0) return -1;
	
	WRITE_U32( GE_RCR,0 ); // 2D engine disable
	WRITE_U32( GE_RCR,(1<<8)|GEC_RUN2D|GEC_DITHER2x2|GEC_RENDER_BACK );
	*(volatile unsigned int*)0xFFE01424 = 0x80000;
	
	switch(resol) {
		case SCREEN_640_480:
			for (i= 0; i<7; i++) {
				CRT_reg[i] = ModeParam[2][i];
			}
			*(volatile unsigned int *)0xffe02014 = 0x100;
			*(volatile unsigned int *)0xffe02018 = ModeParam[2][i];
			i++;
			*(volatile unsigned int *)0xffe02010 = 0x011 | (ModeParam[2][i]<<8);
			ret = 0;
			break;
		case SCREEN_800_600:
			for (i= 0; i<7; i++) {
				CRT_reg[i] = ModeParam[4][i];
			}
			*(volatile unsigned int *)0xffe02014 = 0x100;
			*(volatile unsigned int *)0xffe02018 = ModeParam[4][i];
			i++;
			*(volatile unsigned int *)0xffe02010 = 0x011 | (ModeParam[4][i]<<8);
			ret = 0;
			break;
		case SCREEN_1024_768:
			for (i= 0; i<7; i++) {
				CRT_reg[i] = ModeParam[5][i];
			}
			*(volatile unsigned int *)0xffe02014 = 0x100;
			*(volatile unsigned int *)0xffe02018 = ModeParam[5][i];
			i++;
			*(volatile unsigned int *)0xffe02010 = 0x011 | (ModeParam[5][i]<<8);
			ret = 0;
			break;
		default:
			ret = -1;
			break;
	}

//	for(i=0; i<1024*1024; i++) *(unsigned short *)(Frame_Buffer+(i*2)) = 0;

	return ret;
}

int Draw_Image_XY(int x, int y, unsigned short *img_buffer)
{
	int start_point;
	int i;

	*R_INTEN &= ~(1<<IRQ_EIRQ5);

	start_point = (x*2) + (y*1024*2);
	
	for(i=0; i<120; i++) {
		eagle_GDMA((unsigned short *)(Frame_Buffer+start_point)+(i*1024),  (unsigned short *)img_buffer+(i*180), 360);
	}

	return 0;
	
}

int ClearScreen(void)
{
	int i;
	
	for(i=0; i<1024*1024; i++) *(unsigned short *)(Frame_Buffer+(i*2)) = 0;

	return 0;
}

int ImgProc_ioctl(struct inode *inode, struct file *filp, unsigned int cmd, unsigned long arg)
{
	int ret = 0;
	int screen = 0;

	struct disp_coordinate disp_xy;

    switch (cmd) {
	    case  RD_IMG_DATA :
			ret = read_imgae_data();
			copy_to_user((unsigned short **)arg, (unsigned short *)Frame_Buffer, 120*180*2);
//			memset((unsigned char *)Frame_Buffer, 0, 120*180*2);
			break;
			
	    case DISPLAY_IMG_DATA :
			Display_to_Monitor();
			break;
			
//	    case ENABLE_IMG_IRQ:
//			ret = imgproc_irq_enable();
//		    break;
//			
	    case DISABLE_IMG_IRQ :
			ret = imgproc_irq_disable();
		    break;

		case DISPLAY_IMG_DRAW :
			copy_from_user(&disp_xy, (struct disp_coordinate *)arg, sizeof(struct disp_coordinate));
			ret = Draw_Image_XY(disp_xy.x, disp_xy.y, disp_xy.img_buf);
			break;

		case DISPLAY_RESOLUTION :
			screen = (int)arg;
			ret = SetScreen(screen);
			break;

		case CLEAR_SCREEN :
			ret = ClearScreen();
			break;
			
	    default: 
            return -EINVAL;
    }
    return ret;
}

#define R_BNKCON3	(volatile unsigned int*)0xFFE0040c
int ImgProc_init_module(void) 
{
	int result;

	*R_BNKCON3 = 0x0000a8a5; //Bank3, Data Bus 16bit
	Frame_Buffer = *(volatile unsigned int*)0xFFE00420;
//	printk("Frame_Buffer addr = 0x%x\n", Frame_Buffer);

	result = register_chrdev(IMG_MAJOR, IMG_NAME, &imgproc_fops);

	if(result < 0) {
		printk(KERN_WARNING"image process register_chrdev failed\n");
		return result;
	}
	printk("\timage process module initialized!!\n");

	return result;
}

void ImgProc_cleanup_module(void) 
{
	unregister_chrdev(IMG_MAJOR, IMG_NAME);
	if(irq_flag) {
		free_irq (IRQ_EIRQ5, NULL);
		irq_flag=0;
	}
	*(volatile unsigned int *)0xffe02014 = 0x10; // CRT PLL Disable
}

module_init(ImgProc_init_module);
module_exit(ImgProc_cleanup_module);

MODULE_AUTHOR("OXYANG");
MODULE_DESCRIPTION("Image Process Driver for GMX1000");
MODULE_LICENSE("GPL");

