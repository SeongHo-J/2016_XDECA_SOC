#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <math.h>

#include "uart_api.h"
#include "cam_disp.h"

#define DISABLE_IMG_IRQ		0x24402
#define RD_IMG_DATA			0x24403
#define DISPLAY_IMG_DATA	0x24404
#define DISPLAY_IMG_DRAW	0x24405	
#define CLEAR_SCREEN		0x24407
#define GRAPHIC_FLIP	0x24410

int devfb;

void Delay(int delay_time)
{
	while(delay_time)
		delay_time--;
}

typedef struct __draw_raw_value {
	int InitDX;
	int InitDY;
	int EndX;
	int EndY;
	int InitSX;
	int InitSY;
	int dxSx;
	int dxSy;
	int dySx;
	int dySy;
	int imgbuf_en;
	unsigned short *imgbuf;
} DrawRaw_value;

static DrawRaw_value draw_value;

struct __shade_color {
    unsigned char r;
    unsigned char g;
    unsigned char b;
};

int draw_rotate_value(int cdx, int cdy, int ctx, int cty, float zoom, unsigned int angle)
{
	float MySin,MyCos;

	int InitDX, InitDY;
	int EndX, EndY;
	int InitSX, InitSY;
	int dxSx, dxSy;
	int dySx, dySy;
	int dx,dy;
	int x,y;
	float a;
	int cosa;
	int sina;
	int rhzoom;

	x = y = 0;
	dx = 320;
	dy = 480;

	long tx,ty;

	angle %= 360;
	a = angle*(3.1415926535f*2)/360.0f;

	MySin = (float)sin( a );
	MyCos = (float)cos( a );

	tx = (-cdx/zoom) * MyCos + (-cdy/zoom) * MySin;
	ty = (cdx/zoom) * MySin + (-cdy/zoom) * MyCos;

	if( zoom<=0 )	rhzoom = 0;
	else			rhzoom = (int)((float)(1<<9)/zoom);
	cosa = (int)(rhzoom * cos( a ));
	sina = (int)(rhzoom * sin( a ));

	if( dx<=0 || dy<=0 ) 
		return -1;

	InitDX	= x;
	InitDY	= y;
	EndX	= x+dx-1;
	EndY	= y+dy-1;

	InitSX	= (x+tx+ctx)*512;
	dxSx	= cosa;
	dxSy	= -sina;

	InitSY	= (y+ty+cty)*512;
	dySx	= sina;
	dySy	= cosa;

	draw_value.InitDX=InitDX;
	draw_value.InitDY=InitDY;
	draw_value.EndX=EndX;
	draw_value.EndY=EndY;
	draw_value.InitSX=InitSX;
	draw_value.InitSY=InitSY;
	draw_value.dxSx=dxSx;
	draw_value.dxSy=dxSy;
	draw_value.dySx=dySx;
	draw_value.dySy=dySy;
	
//	printf("InitDX=%d\n", InitDX);
//	printf("InitDY=%d\n", InitDY);
//	printf("EndX=%d\n", EndX);
//	printf("EndY=%d\n", EndY);
//	printf("InitSX=%d\n", InitSX);
//	printf("InitSY=%d\n", InitSY);
//	printf("dxSx=%d\n", dxSx);
//	printf("dxSy=%d\n", dxSy);
//	printf("dySx=%d\n", dySx);
//	printf("dySy=%d\n", dySy);

	return 0;
}

int draw_img_from_buffer(unsigned short *Buffer, int CenterX, int CenterY, float zoom, int rotate_angle)
{
	draw_rotate_value(CenterX,CenterY,90,60,zoom,rotate_angle);
	draw_value.imgbuf = Buffer;

	if( ioctl(devfb, DISPLAY_IMG_DRAW, &draw_value) ) {
		printf("Draw Image to LCD -> fail!!!\n");
		exit(1);
	}	
}

void ClearScreen(unsigned char r, unsigned char g, unsigned char b)
{
	struct __shade_color clear_shade;

	clear_shade.r = r;
	clear_shade.g = g;
	clear_shade.b = b;

	if( ioctl(devfb, CLEAR_SCREEN, &clear_shade) ) {
		printf("Clear Screen -> fail!!!\n");
		exit(1);
	}	
}

static int gFlip(void)
{
    return ioctl(devfb, GRAPHIC_FLIP, 0);
}

int ImageProcess_Open(void)
{
	int fb;
	fb=open("/mnt/f0/dev_module/imgproc", O_RDWR);
	if(fb < 0) {
		printf("/mnt/f0/dev_module/imgproc open failed!!\n");
		return -1;
	}

	devfb = fb;

	return 0;	
}

int ReadImageFromFPGA(unsigned int *addr)
{
	unsigned int buf_addr;
	
	if ( ioctl(devfb, RD_IMG_DATA, &buf_addr) ) {
		printf("ioctl RD_IMG_DATA error\n");
		return -1;
	}
	*addr = buf_addr;

	return 0;
}

int ImgDisplayToLCD(void)
{
	draw_rotate_value(160,240,90,60,2.5,90); // FPGA로부터 읽어 온 영상(180x120)의 중심점(90,60)을 기준으로하여 90도 회전하고, 2.5배 확대하여 LCD의 중심점(160,240)에 위치하도록 셋팅하는 함수 : comment by yyb[110909]
	if ( ioctl(devfb, DISPLAY_IMG_DATA, &draw_value) ) {
	    printf("ioctl DISPLAY_IMG_DATA error\n");
	    return -1;
	}

	return 0;
}

void ImgDisplayQuit(void)
{
	ioctl(devfb, DISABLE_IMG_IRQ, 0);
}

int main(int argc, char **argv)
{
	int x, y;
	char ch;
	int ret;
    unsigned char buff[5] = {0,};
	unsigned int buf_addr;
	unsigned short (*img_buf)[256];
	
	if(argc <= 1) {
		printf("Usage 1 : imgproc_test -rd     <Read Image Data>\n");
		printf("Usage 2 : imgproc_test -dp     <Display to LCD>\n");
		printf("Usage 3 : imgproc_test -dp2    <Display 2 Frame>\n");
		exit(1);
	}
	eagle_camera_off(); // 커널에서 동작되는 Camera OFF : comment by yyb[110909]
	
	//[[ molink_yyb_110909_BEGIN -- 로봇 몸체와의 통신을 위한 UART 초기화
	ret = uart_open();
	if (ret < 0) return EXIT_FAILURE;
	uart_config(UART1, 115200, 8, UART_PARNONE, 1);
	//]] molink_yyb_110909_END -- 로봇 몸체와의 통신을 위한 UART 초기화

	ret = ImageProcess_Open(); // 이미지 처리를 위한 드라이버 Open : comment by yyb[110909]
	if (ret < 0) return EXIT_FAILURE;

	Delay(0xffffff);

	if(strcmp("-rd", argv[1]) == 0) {

		ret = ReadImageFromFPGA(&buf_addr); // FPGA로부터 1Frame(180x120)의 이미지 Read : comment by yyb[110909]
		if (ret < 0) return EXIT_FAILURE;
		img_buf = (unsigned short (*)[256])buf_addr; // img_buf는 읽어 온 이미지 데이터를 배열(180x120)로 처리하기 위한  포인터 배열 변수 : comment by yyb[110909]
//		printf("\t read 1 frame imgae : addr 0x%x\n", buf_addr);


#if 0 //[[ molink_yyb_110909_BEGIN -- FPGA로부터 읽어온 데이터를 처리하는 과정에 대한 예
		for(y=0; y<120; y++) {
			for(x=0; x<180; x++) {
				sprintf((char *)buff, "%04x", img_buf[y][x]);
				uart1_buffer_write(buff, 4);
			}
		}
#endif //]] molink_yyb_110909_END -- FPGA로부터 읽어온 데이터를 처리하는 과정에 대한 예

	    printf("\t read 1 frame imgae data completely\n");
	}
	else if(strcmp("-dp", argv[1]) == 0) {
		ret = ImgDisplayToLCD(); // FPGA로 부터 읽어온 이미지를 LCD에 실시간으로  Display : comment by yyb[110909]
		if (ret < 0) return EXIT_FAILURE;
		
		printf("\nPress Enter Key to STOP the test !!!");
		
		ch = getchar();
		ImgDisplayQuit(); // LCD Display 종료 : comment by yyb[110909]
		printf("\nTest is Stopped\n");
	}
	else if(strcmp("-dp2", argv[1]) == 0) {
		ClearScreen(255, 255, 255); // LCD 화면을 백색으로 Clear : comment by yyb[110909]
		gFlip(); // 그래픽 처리된 내용을 LCD에 보여줌 : comment by yyb[110909]
		ClearScreen(255, 255, 255);
		gFlip();
		ClearScreen(255, 255, 255);
		gFlip();
		ClearScreen(255, 255, 255);
		gFlip();
		printf("Clear Screen!\n");

		ret = ReadImageFromFPGA(&buf_addr);
		if (ret < 0) return EXIT_FAILURE;

		printf("Image Load from FPGA!\n");

		draw_value.imgbuf_en = 0; // 읽어 온 데이터를 처리하지 않고 그대로 다시 LCD에 보여줄 때 설정 : comment by yyb[110909]
		ClearScreen(255, 255, 255);
		draw_img_from_buffer((unsigned short *)buf_addr, 160, 130, 1.8, 0); // buf_addr에 들어 있는 내용을 1.8배 확대하여 0도 회전하고 중심을 (160, 130)로 하여  Display : comment by yyb[110909]
//		gFlip();
		printf("1. Draw Image to LCD!\n");
//    }


		printf("\nPress Enter Key to load image again !!!");
		ch = getchar();
		
		ret = ReadImageFromFPGA(&buf_addr);
		if (ret < 0) return EXIT_FAILURE;
		img_buf = (unsigned short (*)[256])buf_addr;
		printf("Image Load from FPGA!\n");

		//////////////////////////////////////////////////////////////////
		// img_buf의 데이터에 대한 이미지 처리 과정이 이 위치에서 이루어짐 //
		//////////////////////////////////////////////////////////////////
		
		draw_value.imgbuf_en = 1; // 읽어 온 데이터를 처리하고, 처리된 데이터를 LCD에 보여줄 때 설정 : comment by yyb[110909]
		draw_img_from_buffer((unsigned short *)buf_addr, 160, 360, 1.8, 0);
		gFlip();
		printf("2. Draw Image to LCD!\n");

		printf("\nPress Enter Key to STOP the test !!!");
		ch = getchar();
		printf("\nTest is Stopped\n");
		
	}
	else {
		printf("Usage 1 : imgproc_test -rd     <Read Image Data>\n");
		printf("Usage 2 : imgproc_test -dp     <Display to LCD>\n");
		printf("Usage 3 : imgproc_test -dp2    <Display 2 Frame>\n");
		exit(-1);
	}
	
	uart_close();
	close(devfb);

	eagle_camera_on(); // 커널에서 동작되는 Camera ON : comment by yyb[110909]

	return(0);
}
