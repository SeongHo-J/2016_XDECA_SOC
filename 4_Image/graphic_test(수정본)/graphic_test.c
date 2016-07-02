#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <getopt.h>
#include <fcntl.h>
#include <unistd.h>
#include <termios.h>
#include <sys/ioctl.h>
#include <math.h>

#include "amazon2_sdk.h"
#include "graphic_api.h"

#include "uart_api.h"
#include "robot_protocol.h"




#define AMAZON2_GRAPHIC_VERSION		"v0.5"

static struct termios inittio, newtio;

int open_graphic(void); 
void close_graphic(void);


static int __uart_dev = -1;


void DelayLoop(int delay_time)
{
	while(delay_time)
		delay_time--;
}

void Send_Command(unsigned char Ldata, unsigned char Ldata1)
{
	unsigned char Command_Buffer[6] = {0,};

	Command_Buffer[0] = START_CODE;	// Start Byte -> 0xff
	Command_Buffer[1] = START_CODE1; // Start Byte1 -> 0x55
    Command_Buffer[2] = Ldata;
	Command_Buffer[3] = Ldata1;
	Command_Buffer[4] = Hdata;  // 0x00
	Command_Buffer[5] = Hdata1; // 0xff

	uart1_buffer_write(Command_Buffer, 6);
}

int uart_open (void)
{
    int handle;

    if ((handle = open(UART_DEV_NAME, O_RDWR)) < 0) {
        printf("Open Error %s\n", UART_DEV_NAME);
        return -1;
    }

    __uart_dev = handle;

    return 0;
}

void uart_close (void)
{
    close(__uart_dev);
}

int uart_config(int ch, int baud, int bits, int parity, int stops)
{
    struct uart_config uart_conf;

    uart_conf.uart_ch = ch;
    uart_conf.baud = baud;
    uart_conf.bits = bits;
    uart_conf.parity = parity;
    uart_conf.stops = stops;

    return ioctl(__uart_dev, UART_SET_CONFIG, &uart_conf);
}

int uart_tx_buf_full(int ch)
{
    return ioctl(__uart_dev, UART_TXBUF_FULL, ch);
}

int uart_write(int ch, unsigned char *ubuf, int size)
{
    struct uart_data uart_d;

    uart_d.uart_ch = ch;
    uart_d.buf_size = size;
    uart_d.uart_buf = ubuf;

    return ioctl(__uart_dev, UART_DATA_WRITE, &uart_d);
}

int uart_rx_level(int ch)
{
    return ioctl(__uart_dev, UART_RXBUF_LEVEL, ch);
}

int uart_read(int ch, unsigned char *ubuf, int size)
{
    struct uart_data uart_d;

    uart_d.uart_ch = ch;
    uart_d.buf_size = size;
    uart_d.uart_buf = ubuf;

    return ioctl(__uart_dev, UART_DATA_READ, &uart_d);
}

void uart1_buffer_write(unsigned char *buf, int size)
{
	int ret;
	
	while(uart_tx_buf_full(UART1) == 1);
	ret = uart_write(UART1, buf, size);
	if(ret<0) {
		printf("Maybe UART Buffer is Full!\n");
	}	
}

void uart1_buffer_read(unsigned char *buf, int size)
{
	int rx_len=0;
	int rx_cnt=0;

	while(1) {
		rx_cnt += rx_len;
		rx_len = uart_rx_level(UART1);
		uart_read(UART1, &buf[rx_cnt], rx_len);
		if(rx_cnt + rx_len >= size) break;
	}	
}


void init_console(void)
{
    tcgetattr(0, &inittio);
    newtio = inittio;
    newtio.c_lflag &= ~ICANON;
    newtio.c_lflag &= ~ECHO;
    newtio.c_lflag &= ~ISIG;
    newtio.c_cc[VMIN] = 1;
    newtio.c_cc[VTIME] = 0;

    cfsetispeed(&newtio, B115200);

    tcsetattr(0, TCSANOW, &newtio);
}

int main(void)
{
	int i=0,j=0,k=0, l=0,cnt=0, line=0;
	int state_1=0;
	float r=0,g=0,b=0;
	float max=0.0f, min=0.0f;
	float hf=0.0f,sf=0.0f,vf=0.0f;
	float point_h=0.0f, point_s=0.0f, point_v=0.0f; //중앙점의 hsv값
	float delta;
	char input;
	int hue_min=45, hue_max=70, sat_min=2;
	unsigned char tmpchar;
	int ret;
	int b_loop = 0;

	SURFACE* bmpsurf	= 0;
	U16* fpga_videodata = (U16*)malloc(180 * 120 * 2);
	U16* lcd			= (U16*)malloc(180 * 120 * 2);
	float* hue_joon		= (float*)malloc(180 * 120 * 2);
	float* satur_tmp		= (float*)malloc(180 * 120 * 2);
	float* v_compare		= (float*)malloc(180 * 120 * 2);
	float* s_temp		= (float*)malloc(180 * 120 * 2);

	float Mask[9] = { 0 };//마스크하기 위한 변수
	int index1 = 0, index2 = 0, index3 = 0;
	

	init_console();

	ret = uart_open();
	if (ret < 0) return EXIT_FAILURE;

	uart_config(UART1, 57600, 8, UART_PARNONE, 1);

	if (open_graphic() < 0) {
		return -1;
	}

//	printf("press the 'x' button to off display\n");	// 코드 추가
//	printf("press the 'z' button to on display\n");		// 코드 추가
	scanf("%c", &input);

	if (input == 'x')
	{
		b_loop = 1;
		printf("press the 'a' button to enter values\n"); // 코드 추가
	}
	if (input == 'z') // 코드 추가
		direct_camera_display_on();

	while(b_loop)
	{
//		direct_camera_display_off();
		
		while(1)
		{
			/*
			input = getchar();
			if(input=='a'){
				printf("enter the min value\n");
				printf("now hum_min: %d, hue_max: %d, sat_min: %d\n",hue_min, hue_max, sat_min);
				scanf("%d %d %d", &hue_min, &hue_max, &sat_min);
				printf("press the 'b' button to break loop\n"); // 코드 추가
			}

		
			if(input=='b'){
				b_loop=0;
				break;
			}*/
			read_fpga_video_data(fpga_videodata);

			printf("3\n");

			line=0;

			printf("4\n");

			for(i=0;i<180*120/1.5;i++)
			{
				//printf("5");
				//*(g+i) = *(fpga_videodata+i);
				b = (float)((*(fpga_videodata+i))&31);
				g = (float)(((*(fpga_videodata+i))>>6)&31);
				r = (float)(((*(fpga_videodata+i))>>11)&31);
				//printf("6");
				/*	if(i == 180* 60+90)
					printf("%f %f %f \n",r, g, b);*/
				if (r>g)
					if (r>b)
					{
						max = r;
						min = g>b? b:g;
					}
					else
					{
						max = b;
						min = g;
					}
				else
					if (g>b)
					{
						max = g;
						min = r>b? b:r;
					}
					else
					{
						max = b;
						min = r;
					}
				
				//printf("7");
				delta = max - min; 
				vf = (r+g+b)/3.0f;						// 명도(V) = max(r,g,b)
				sf = (max != 0.0F) ? delta/max : 0.0F;	// 채도(S)을 계산, S=0이면 R=G=B=0
				
				if (sf == 0.0f)
					hf = 0.0f; 
				else
				{
				    // 색상(H)를 구한다.
					if(r == max) hf = (g - b) / delta;     // 색상이 Yello와 Magenta사이 
					else if( g == max) hf = 2.0F + (b - r) / delta; // 색상이 Cyan와 Yello사이 
					else if( b == max) hf = 4.0F + (r - g) / delta; // 색상이 Magenta와 Cyan사이
				}
				hf *= 57.295F;
				//printf("8");
				if(hf < 0.0F) hf += 360.0F;           // 색상값을 각도로 바꾼다.
				*(hue_joon+i) = hf;		//0 ~ 360
				sf = sf*100;
				*(satur_tmp+i) = sf;	//0 ~ 32
				*(v_compare+i) = vf;	//0 ~ 31
				*(s_temp+i) = *(satur_tmp+i);

				//*(h_compare+i) = *(s+i);
				
				
				/*if(i==180*60+90) //정가운데의 hsi값
				{
					//printf("r: %f, g: %f, b: %f, sat: %f\n",r,g,b,sf);
					point_h=*(hue_joon+i);
					point_s=*(satur_tmp+i);
					point_v=*(v_compare+i);
				}*/

				//printf("9\n");
				
			}

			/////////////////////선명하게 하기 마스크 추가///////////////////////////
			printf("mask start\n");
			int n = 1;
			//int x = 0;
			Mask[0] = 0.0f; Mask[1] = -1.0f; Mask[2] = 0.0f;//Y마스크
			Mask[3] = -1.0f; Mask[4] = 5.0f; Mask[5] = -1.0f;
			Mask[6] = 0.0f; Mask[7] = -1.0f; Mask[8] = 0.0f;


//			Mask2[0] = -1.0f; Mask2[1] = 0.0f; Mask2[2] = 1.0f;//X마스크
//			Mask2[3] = -1.0f; Mask2[4] = 0.0f; Mask2[5] = 1.0f;
//			Mask2[6] = -1.0f; Mask2[7] = 0.0f; Mask2[8] = 1.0f;


			for (i = n; i < 120 - n; i++){
				index1 = i*180;
				for (j = n; j < 180 - n; j++){
					float sum1 = 0.0f;
					//float sum2 = 0.0f;

					for (k = -n; k <= n; k++){
						index2 = (i + k)*180;
						index3 = (k + n)*3;
						for (l = -n; l <= n; l++){
							sum1 += v_compare[index2 + (j + l)] * Mask[index3 + l + n];
							//sum2 += v_compare[index2 + (j + l)] * Mask2[index3 + l + n];
						}
					}

					//if (sum1>20)
						*(lcd + i * 180 + j) = sum1;
					//else
					//	*(lcd + i * 180 + j) = *(fpga_videodata + i * 180 + j);
				}
			}
			printf("mask end\n");

			//////////////////////////////////////////////////////////
			cnt=0;

			//printf("10\n");

			for(i=0;i<120;i++)
			{
				cnt=0;
				for(j=0;j<180;j++){
					//tmpchar = (char)(*(v+i)*255.0f); tmpchar+(tmpchar<<6)+(tmpchar<<11);
					//if( ( 45.0f < *(h+i) < 75.0f ) && ( 12.0f < *(s+i)  ) && ( 7.0f < *(v+i) < 23.0f ))
					//노란색if((60.0f < *(h+i)) && (*(h+i) < 75.0f) && ( 20.0f < *(s+i)  ) )
					//파란색 if(220.0f < (*(h+i) ) && (*(h+i) < 260.0f) && ( 10.0f < *(s+i)  ) )
					/* 
					if((hue_min < (int)(*(hue_joon+i*180+j))) && ((int)(*(hue_joon+i*180+j)) < hue_max) && ( sat_min < (int)(*(satur_tmp+i*180+j) )) )
					{
						*(lcd+i*180+j) = 0x700f;
						cnt++;
					}
					*/
				/////////////////////////////////////파란색->초록색바꾸기	
					/*
					if ((170 < (int)(*(hue_joon + i * 180 + j))) && ((int)(*(hue_joon + i * 180 + j)) < 240) && (sat_min < (int)(*(satur_tmp + i * 180 + j))))
					{
						*(lcd + i * 180 + j) = 0x07E0;
					} // 코드 추가
					else
						*(lcd+i*180+j) = *(fpga_videodata+i*180+j);

						*/

					if(i==60)
					{
						*(lcd+i*180+j) = 0x7000;//lcd에 가로줄 빨간줄 표시코드
						if(j==90)
							printf("hue: %.1f  sat: %.1f v_: %.1f\n", *(hue_joon+i*180+j), *(s_temp+i*180+j), *(v_compare+i*180+j));
					}
					if(j==90)
						*(lcd+i*180+j) = 0x7000;//lcd에 세로줄 빨간줄 표시코드

				}
				if(cnt > 40) line++;
			}
			if(line>=20){
				printf("barricade\n");
				state_1 = 1;
			}
			else{
				if(state_1==1){
					printf("state_1 pass\n");
					Send_Command(0x01, 0xfe);
					state_1=0;
				}
			}
			//printf("%f \n",*(h+180*60+90));
			//printf("%f %f %f \n",r, g, b);



			//printf("Full < Expension(x2.66), Rotate(90) > (320 x 480)\n");
			//printf("%d\n", cnt);
			//draw_img_from_buffer(lcd, 320, 0, 0, 0, 2.67, 90);
			draw_img_from_buffer(fpga_videodata, 0, 18, 0, 0, 1.77, 0);
			draw_img_from_buffer(lcd, 0, 250, 0, 0, 1.77, 0);
			flip();
		}
	}



	//TestItemSelectRobot();

	free(fpga_videodata);
	free(lcd);
	free(hue_joon);
	free(satur_tmp);
	free(v_compare);
	free(s_temp);
	uart_close();
	if (bmpsurf != 0)
		release_surface(bmpsurf);
	close_graphic();

	return 0;
}
