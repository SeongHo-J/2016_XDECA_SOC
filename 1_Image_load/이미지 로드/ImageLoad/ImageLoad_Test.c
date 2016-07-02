#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/ioctl.h>

#include "uart_api.h"

#define SAA7111_RD_REGS 0x1017001
#define SAA7111_WR_REGS 0x1017002

//#define ENABLE_IMG_IRQ		0x24401
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

struct saa7111_data_info  {
    int addr;
    unsigned char *buf;
    int len;
};

volatile unsigned short bf[120][180];


void Delay(int delay_time)
{
	while(delay_time)
		delay_time--;
}


int main(int argc, char **argv)
{
	char ch;
	int ret;
	int decfd1, decfd2;
	volatile int  x, y;
//	int img_addr=0;
	struct saa7111_data_info video_dec;
	struct disp_coordinate disp_xy;

    unsigned char buff[5] = {0,};
// 	RGB(565) Setting
	unsigned char RGB565_Buff[0x18] = { 
							0x00,	//sub_addr00 : chip version
							0x00,	//sub_addr01 : not used
							0xc0,	//sub_addr02
							0x23,	//sub_addr03
							0x00,	//sub_addr04
							0x00,	//sub_addr05
							0xde,	//sub_addr06
							0xdc,	//sub_addr07
							0x40,	//sub_addr08
							0x01,	//sub_addr09
							0x80,	//sub_addr0a
							0x47,	//sub_addr0b
 							0x40,	//sub_addr0c
							0x00,	//sub_addr0d
							0x01,	//sub_addr0e
							0x00,	//sub_addr0f
							0x00,	//sub_addr10
							0x0c,	//sub_addr11
							0x01,	//sub_addr12
							0x00,	//sub_addr13
							0x00,	//sub_addr14
							0x00,	//sub_addr15
							0x00,	//sub_addr16
							0x00	//sub_addr17
						};

	if(argc <= 1) {
		printf("Usage 1 : imgproc_test -rd     <Read Image Data>\n");
		printf("Usage 2 : imgproc_test -dp     <Display to Monitor>\n");
		printf("Usage 3 : imgproc_test -xy     [x coordinate] [y coordinate]\n");
		exit(1);
	}
	
	ret = uart_open();
	if (ret < 0) return EXIT_FAILURE;
	
	uart_config(UART1, 115200, 8, UART_PARNONE, 1);
	

	decfd1 = open("/dev/saa7111", O_RDWR);
	if(decfd1 < 0) {
		fprintf(stderr, "/dev/saa7111 open failed!!\n");
		exit(1);
	}
	
	video_dec.addr = 0x2;
	video_dec.buf = RGB565_Buff;
	video_dec.len = sizeof(RGB565_Buff) - 2;

	if ( ioctl(decfd1, SAA7111_WR_REGS, &video_dec) ) {
		fprintf(stderr, "ioctl write error\n");
		exit(1);
	}
	printf("Video Output : <RGB565 Format> Complete!\n");
	close(decfd1);
	
	decfd2 = open("/dev/imgproc", O_RDWR);
	if(decfd2 < 0) {
		printf("/dev/imgproc open failed!!\n");
		exit(1);
	}
	Delay(0xffffff);
	
	if(strcmp("-rd", argv[1]) == 0) {
//		if ( ioctl(decfd2, RD_IMG_DATA, buff) ) {
		if ( ioctl(decfd2, RD_IMG_DATA, &bf) ) {
			printf("ioctl RD_IMG_DATA error\n");
			exit(1);
		}
//		memcpy(&img_addr, buff, 4);
//		printf("img_addr=0x%x\n", img_addr);

		for(y=0; y<120; y++) {
			for(x=0; x<180; x++) {
//				sprintf((char *)buff, "%04x", *(unsigned short *)(img_addr+(y*360)+(x*2)));
				sprintf((char *)buff, "%04x", bf[y][x]);
				uart1_buffer_write(buff, 4);
//				printf("%s", buff);
//				Delay(10000);
			}
		}
	    printf("\t read 1 frame imgae data completely\n");
	}
	else if(strcmp("-dp", argv[1]) == 0) {
		if ( ioctl(decfd2, DISPLAY_IMG_DATA, 0) ) {
		    printf("ioctl DISPLAY_IMG_DATA error\n");
		    exit(1);
		}
		printf("\nPress Enter Key to STOP the test !!!");
		ch = getchar();
		ioctl(decfd2, DISABLE_IMG_IRQ, 0);
		printf("\nTest is Stopped\n");
	}
	else if(strcmp("-xy", argv[1]) == 0) {
		if(argc < 4) {
			printf("Usage  : imgproc_test -xy [x coordinate] [y coordinate]\n");
			exit(1);
		}

		if ( ioctl(decfd2, RD_IMG_DATA, &bf) ) {
			printf("ioctl RD_IMG_DATA error\n");
			exit(1);
		}
//		Delay(1000);
		printf("Image Load from FPGA!\n");
		
		if ( ioctl(decfd2, DISPLAY_RESOLUTION, SCREEN_640_480) ) {
			printf("Resolution set fail!!!\n");
			exit(1);
		}
		printf("Resolution set complete!\n");
		
		if ( ioctl(decfd2, CLEAR_SCREEN, 0) ) {
			printf("Clear Screen fail!!!\n");
			exit(1);
		}
		printf("Clear Screen!\n");
		
		disp_xy.x = atoi(argv[2]);
		disp_xy.y = atoi(argv[3]);
		disp_xy.img_buf = (unsigned short *)&bf[0][0];

		if( ioctl(decfd2, DISPLAY_IMG_DRAW, &disp_xy) ) {
			printf("Draw Image to Monitor -> fail!!!\n");
			exit(1);
		}
		printf("1. Draw Image to Monitor!\n");

		printf("\nPress Enter Key to load image again !!!");
		ch = getchar();

		if ( ioctl(decfd2, RD_IMG_DATA, &bf) ) {
			printf("ioctl RD_IMG_DATA error\n");
			exit(1);
		}
		printf("Image Load from FPGA!\n");
		
		if ( ioctl(decfd2, DISPLAY_RESOLUTION, SCREEN_640_480) ) {
			printf("Resolution set fail!!!\n");
			exit(1);
		}
		printf("Resolution set complete!\n");

		disp_xy.x = atoi(argv[2])+180;
		disp_xy.y = atoi(argv[3]);
		disp_xy.img_buf = (unsigned short *)&bf[0][0];

		if( ioctl(decfd2, DISPLAY_IMG_DRAW, &disp_xy) ) {
			printf("Draw Image to Monitor -> fail!!!\n");
			exit(1);
		}
		printf("2. Draw Image to Monitor!\n");
		
	}
	else {
		printf("Usage 1 : imgproc_test -rd     <Read Image Data>\n");
		printf("Usage 2 : saa7111_test -dp  <Display to Monitor>\n");
		printf("Usage 3 : imgproc_test -xy     [x coordinate] [y coordinate]\n");
		exit(-1);
	}
	
	uart_close();
	close(decfd2);

	return(0);
}
