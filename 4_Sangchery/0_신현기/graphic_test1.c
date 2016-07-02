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
	while (delay_time)
		delay_time--;
}


void Send_Command(unsigned char Ldata, unsigned char Ldata1)
{
	unsigned char Command_Buffer[6] = { 0, };

	Command_Buffer[0] = START_CODE;	// Start Byte -> 0xff
	Command_Buffer[1] = START_CODE1; // Start Byte1 -> 0x55
	Command_Buffer[2] = Ldata;
	Command_Buffer[3] = Ldata1;
	Command_Buffer[4] = Hdata;  // 0x00
	Command_Buffer[5] = Hdata1; // 0xff

	uart1_buffer_write(Command_Buffer, 6);
}

int uart_open(void)
{
	int handle;

	if ((handle = open(UART_DEV_NAME, O_RDWR)) < 0) {
		printf("Open Error %s\n", UART_DEV_NAME);
		return -1;
	}

	__uart_dev = handle;

	return 0;
}

void uart_close(void)
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

	while (uart_tx_buf_full(UART1) == 1);
	ret = uart_write(UART1, buf, size);
	if (ret < 0) {
		printf("Maybe UART Buffer is Full!\n");
	}
}

void uart1_buffer_read(unsigned char *buf, int size)
{
	int rx_len = 0;
	int rx_cnt = 0;

	while (1) {
		rx_cnt += rx_len;
		rx_len = uart_rx_level(UART1);
		uart_read(UART1, &buf[rx_cnt], rx_len);
		if (rx_cnt + rx_len >= size) break;
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
	int i = 0, j = 0, k = 0, l = 0, line = 0;
	int state_1 = 0;
	float r = 0, g = 0, b = 0;
	float max = 0.0f, min = 0.0f;
	float hf = 0.0f, sf = 0.0f, vf = 0.0f;
	//	float point_h = 0.0f, point_s = 0.0f, point_v = 0.0f; //중앙점의 hsv값
	float delta, degree = 0;
	char input;
	int hue_min = 45, hue_max = 70, sat_min = 2;
	unsigned char tmpchar;
	int ret;
	int b_loop = 0;
	int exer = 0;
	int stage = 0;
	int cnt_mask = 0;
	int x = 0, y = 0;
	//외곽선
	int r_sum_left = 0, r_sum_right = 0;
	int l_sum_left = 0, l_sum_right = 0;
	int r_sum = 0, l_sum = 0;
	int cnt0 = 0;
	int motion1 = 0;
	float first_x = 0, first_y = 0, second_x = 0, second_y = 0, outline_x = 0, outline_y = 0;
	int firstx = 0, firsty = 0, secondx = 0, secondy = 0;
	int result = 0;
	//st1
	int cnt = 0, cnt1 = 0, sum1 = 0, sum2 = 0, sum3 = 0, sw = 0;
	//st2
	int motion2 = 0, cnt2 = 0;
	//st3
	int cnt3 = 0, motion3 = 0;
	//st4
	int cnt4 = 0, motion4 = 0, st4_av_i = 0, st4_sum_i = 0, cnt4_b_w = 0;
	int st4_left = 0, st4_right = 0, green4_l = 0, green4_r = 0;
	//st5
	//st6
	int cnt6 = 0, motion6 = 0, st6_sum_i = 0, st6_av_i = 0;
	//st7
	int cnt7 = 0, motion7 = 0;



	SURFACE* bmpsurf = 0;
	U16* fpga_videodata = (U16*)malloc(180 * 120 * 2);
	U16* lcd = (U16*)malloc(180 * 120 * 2);
	U16* gray = (U16*)malloc(180 * 120 * 2);

	float* hue_joon = (float*)malloc(180 * 120 * 4);
	float* satur_tmp = (float*)malloc(180 * 120 * 4);
	float* v_compare = (float*)malloc(180 * 120 * 4);
	float* s_temp = (float*)malloc(180 * 120 * 4);
	int* rgb = (int*)malloc(180 * 120 * 4);
	float* red = (float*)malloc(180 * 120 * 4);
	float* green = (float*)malloc(180 * 120 * 4);
	float* blue = (float*)malloc(180 * 120 * 4);
	int* xxx = (int*)malloc(180 * 120 * 4);
	int* out_i = (int*)malloc(180 * 120 * 4);
	int* out_j = (int*)malloc(180 * 120 * 4);
	int* st4_green = (int*)malloc(180 * 120 * 4);
	int* st6_red = (int*)malloc(180 * 120 * 4);



	float Mask[9] = { 0 };
	float Mask1[9] = { 0 };//마스크하기 위한 변수
	int index1 = 0, index2 = 0, index3 = 0;


	init_console();

	ret = uart_open();
	if (ret < 0) return EXIT_FAILURE;

	uart_config(UART1, 9600, 8, UART_PARNONE, 1);

	if (open_graphic() < 0) {
		return -1;
	}

	printf("press the 'x' button to off display\n");   // 코드 추가
	printf("press the 'z' button to on display\n");      // 코드 추가
	scanf("%c", &input);

	if (input == 'x')
	{
		b_loop = 1;
		printf("press the 'a' button to enter values\n"); // 코드 추가
	}
	if (input == 'z') // 코드 추가
		direct_camera_display_on();

	while (b_loop)
	{
		direct_camera_display_off();
		int motion_count = 0;
		while (1)//모션테스트
		{
			motion_count++;
			printf("%d\n", motion_count);
			Send_Command(0x03, 0xfc);
			Send_Command(0x03, 0xfc);
			Send_Command(0x03, 0xfc);
			DelayLoop(100000000);
		}

		while (1)
		{

		GOUP:
			read_fpga_video_data(fpga_videodata);
			Send_Command(0x04, 0xfb);
			Send_Command(0x04, 0xfb);
			Send_Command(0x04, 0xfb);
			DelayLoop(40000000);
			for (i = 0; i < 180 * 120; i++)
			{

				b = ((*(fpga_videodata + i)) & 31);
				g = (((*(fpga_videodata + i)) >> 6) & 31);
				r = (((*(fpga_videodata + i)) >> 11) & 31);

				*(rgb + i) = b + g + r; //rgb값의 합

				int graay = (int)(b + g + r) / 3;
				int gray1 = (graay << 11);
				int gray2 = (graay << 6);
				*(gray + i) = gray1 + gray2 + graay; // 그레이하는과정

				*(red + i) = r;
				*(green + i) = g;
				*(blue + i) = b;



				if (r > g)
					if (r > b)
					{
						max = r;
						min = g > b ? b : g;
					}
					else
					{
						max = b;
						min = g;
					}
				else
					if (g > b)
					{
						max = g;
						min = r > b ? b : r;
					}
					else
					{
						max = b;
						min = r;
					}

				delta = max - min;
				vf = (r + g + b) / 3.0f;                  // 명도(V) = max(r,g,b)
				sf = (max != 0.0F) ? delta / max : 0.0F;   // 채도(S)을 계산, S=0이면 R=G=B=0

				if (sf == 0.0f)
					hf = 0.0f;
				else
				{
					// 색상(H)를 구한다.
					if (r == max) hf = (g - b) / delta;     // 색상이 Yello와 Magenta사이 
					else if (g == max) hf = 2.0F + (b - r) / delta; // 색상이 Cyan와 Yello사이 
					else if (b == max) hf = 4.0F + (r - g) / delta; // 색상이 Magenta와 Cyan사이
				}
				hf *= 57.295F;
				if (hf < 0.0F) hf += 360.0F;           // 색상값을 각도로 바꾼다.
				*(hue_joon + i) = hf;      //0 ~ 360
				sf = sf * 100;
				*(satur_tmp + i) = sf;   //0 ~ 32
				*(v_compare + i) = vf;   //0 ~ 31
				*(s_temp + i) = *(satur_tmp + i);

			}

			//마스크
			///////////////////마스크 추가///////////////////////////
			//printf("mask start\n"); // 외곽선추출
			int n = 1;
			r_sum_right = 0;
			r_sum_left = 0;
			Mask[0] = -1.0f; Mask[1] = -1.0f; Mask[2] = -1.0f;
			Mask[3] = 0.0f; Mask[4] = 0.0f; Mask[5] = 0.0f;
			Mask[6] = 1.0f; Mask[7] = 1.0f; Mask[8] = 1.0f;

			//Mask1[0] = -1.0f; Mask1[1] = 0.0f; Mask1[2] = 1.0f;
			//Mask1[3] = -1.0f; Mask1[4] = 0.0f; Mask1[5] = 1.0f;
			//Mask1[6] = -1.0f; Mask1[7] = 0.0f; Mask1[8] = 1.0f;
			cnt_mask = 0;
			for (j = 88 - n; j > n; j--){
				//index1 = i * 180;
				for (i = 120 - n; i > n; i--){
					float sum1 = 0.0f;
					float sum2 = 0.0f;

					for (k = -n; k <= n; k++){
						index2 = (i + k) * 180;
						index3 = (k + n) * 3;
						for (l = -n; l <= n; l++){
							sum1 += gray[index2 + (j + l)] * Mask[index3 + l + n];
							//sum2 += gray[index2 + (j + l)] * Mask1[index3 + l + n];
						}
					}
					//*(lcd + i * 180 + j) = *(fpga_videodata + i * 180 + j);
					
					if (sum1 > 65530){
						*(lcd + i * 180 + j) = 0xffff;
						break;
					}
					
					else{
						*(lcd + i * 180 + j) = 0x0000;
						if (j >= 44)
							r_sum_right++;
						else
							r_sum_left++;
					}
				}
			}
			printf("sum : %d  right : %d  left : %d\n", r_sum_right+r_sum_left, r_sum_right, r_sum_left);
			//printf("mask end\n");
			draw_img_from_buffer(fpga_videodata, 0, 18, 0, 0, 1.77, 0);
			draw_img_from_buffer(lcd, 0, 250, 0, 0, 1.77, 0);
			flip();
			/////////////////////////////////////////////////////////
			

			for (i = 0; i < 120; i++)
			{

				for (j = 0; j < 180; j++){

					*(lcd + i * 180 + j) = *(fpga_videodata + i * 180 + j);


					if (((int)*(red + i * 180 + j) >20) && ((int)*(green + i * 180 + j) >20) && ((int)*(blue + i * 180 + j) > 20) && ((int)*(v_compare + i * 180 + j) > 25))
						*(xxx + i * 180 + j) = 1;//흰색을표시

					else if (((int)*(red + i * 180 + j) < 10) && ((int)*(green + i * 180 + j) < 10) && ((int)*(blue + i * 180 + j) < 10) && ((int)*(v_compare + i * 180 + j) < 10))
						*(xxx + i * 180 + j) = 2;//검정을표시

					else if (((int)*(red + i * 180 + j) > 15) && ((int)*(green + i * 180 + j) < 15) && ((int)*(blue + i * 180 + j) < 15) && ((((int)*(hue_joon + i * 180 + j) > 300)) || ((int)*(hue_joon + i * 180 + j) < 60)))
						*(xxx + i * 180 + j) = 3;//빨강을표시
					else if ((*(green + i * 180 + j) < *(red + i * 180 + j)) && (*(blue + i * 180 + j) < *(red + i * 180 + j)) && (((int)*(hue_joon + i * 180 + j) > 300) || ((int)*(hue_joon + i * 180 + j) < 60)))
						*(xxx + i * 180 + j) = 3;//빨강을표시

					else if (((int)*(red + i * 180 + j) > 18) && ((int)*(green + i * 180 + j) > 18) && ((int)*(blue + i * 180 + j) < 15) && ((int)*(v_compare + i * 180 + j) > 15) && ((int)*(hue_joon + i * 180 + j) > 50) && ((int)*(hue_joon + i * 180 + j) < 80))
						*(xxx + i * 180 + j) = 4;//노랑을표시

					else if (((int)*(red + i * 180 + j) < 15) && ((int)*(green + i * 180 + j) > 15) && ((int)*(blue + i * 180 + j) < 15) && ((int)*(hue_joon + i * 180 + j) > 80) && ((int)*(hue_joon + i * 180 + j) < 150))
						*(xxx + i * 180 + j) = 5;//초록을표시
					else if ((*(red + i * 180 + j) < *(green + i * 180 + j)) && (*(blue + i * 180 + j) < *(green + i * 180 + j)) && ((int)*(hue_joon + i * 180 + j) > 80) && ((int)*(hue_joon + i * 180 + j) < 150))
						*(xxx + i * 180 + j) = 5;//초록을표시

					else if ((*(red + i * 180 + j) < *(blue + i * 180 + j)) && (*(green + i * 180 + j) < *(blue + i * 180 + j)) && ((int)*(hue_joon + i * 180 + j) > 180) && ((int)*(hue_joon + i * 180 + j) < 250) && *(satur_tmp + i * 180 + j) > 30)
						*(xxx + i * 180 + j) = 6;//파랑을표시

					else
						*(xxx + i * 180 + j) = 7;//나머지

				}


			}
			/*/색깔뽑기
			for (i = 80; i < 120; i++)
				for (j = 0; j < 180; j++)
					*(lcd + i * 180 + j) = 0;

			
			for (i = 0; i < 120; i++)
			for (j = 0; j < 180; j++)
			{

				if (*(xxx + i * 180 + j) == 5)
				{
					if ((*(xxx + 180 * i + j) + *(xxx + 180 * i + j - 1) == 7)
						|| (*(xxx + 180 * i + j) + *(xxx + 180 * (i - 1) + j) == 7)
						|| (*(xxx + 180 * i + j) + *(xxx + 180 * (i - 1) + j - 1) == 7))
						*(lcd + i * 180 + j) = 0xf000;
				}
				else if (*(xxx + i * 180 + j) == 2)
					*(lcd + i * 180 + j) = 0x000f;
			
			}

			draw_img_from_buffer(fpga_videodata, 0, 18, 0, 0, 1.77, 0);
			draw_img_from_buffer(lcd, 0, 250, 0, 0, 1.77, 0);
			flip();
			//////////////////////////////////////////////////////////////////////*/

			
			switch (sw)
			{
			case 1:
			sw = 0;
			goto stage1;
			default :
				break;
			}
			
			/*
			for (i = 0; i < 120; i++)
			{
			for (j = 0; j < 180; j++){

			if ((*(xxx + 180 * i + j) + *(xxx + 180 * i + j - 1) == 3)
			|| (*(xxx + 180 * i + j) + *(xxx + 180 * (i - 1) + j) == 3)
			|| (*(xxx + 180 * i + j) + *(xxx + 180 * (i - 1) + j - 1) == 3)) *(lcd + i * 180 + j) = 0x000f;
			// 흰색과 검정 경계면일경우를 얘기함

			else if (*(xxx + 180 * i + j) == 1) *(lcd + i * 180 + j) = 0xf000;
			else if (*(xxx + 180 * i + j) == 2) *(lcd + i * 180 + j) = 0x0000;

			}
			}
			draw_img_from_buffer(fpga_videodata, 0, 18, 0, 0, 1.77, 0);
			draw_img_from_buffer(lcd, 0, 250, 0, 0, 1.77, 0);
			flip();
			*/

			//외곽선
			/*//////////////////////외곽선(로봇중앙맞추기)///////////////////////

			result = 0;
			cnt0 = 0;
			int r_b_w_i = 0, l_b_w_i = 0;

			for (j = 5; j < 175; j++)
			{
				for (i = 116; i >= 60; i--)
				{
					if (*(xxx + 180 * i + j) == 1) *(lcd + 180 * i + j) = 0x000f;
					if ((*(xxx + 180 * i + j) + *(xxx + 180 * i + j - 1) == 3)
						|| (*(xxx + 180 * i + j) + *(xxx + 180 * (i - 1) + j) == 3)
						|| (*(xxx + 180 * i + j) + *(xxx + 180 * (i - 1) + j - 1) == 3))
					{
						*(lcd + 180 * i + j) = 0xf000;
						break;
					}
					if (*(xxx + 180 * i + j) == 2)
						break;


				}
			}
			draw_img_from_buffer(fpga_videodata, 0, 18, 0, 0, 1.77, 0);
			draw_img_from_buffer(lcd, 0, 250, 0, 0, 1.77, 0);
			flip();


			if (motion1 == 0)//준비단계
			{
				printf("motion1=%d", motion1);
				printf("Ready\n");
				r_sum_left = 0, r_sum_right = 0;
				l_sum_left = 0, l_sum_right = 0;
				r_sum = 0, l_sum = 0;


				motion1 = 1;//오

				goto GOUP;
			}

			else if (motion1 == 1)//오른쪽고개돌리기
			{
				printf("motion1=%d", motion1);
				printf("face right!\n");
				r_sum_left = 0, r_sum_right = 0;
				l_sum_left = 0, l_sum_right = 0;
				r_sum = 0, l_sum = 0;
				r_b_w_i = 0, l_b_w_i = 0;
				cnt0 = 0;
				Send_Command(0x04, 0xfb);
				DelayLoop(80000000);

				motion1 = 2;
				goto GOUP;
			}

			else if (motion1 == 2)//오른쪽에서 영상처리
			{
				printf("motion1=%d", motion1);
				printf("right screen\n");
				Send_Command(0x04, 0xfb);
				DelayLoop(80000000);
				for (j = 5; j < 175; j++)
				{
					for (i = 116; i >= 60; i--)
					{
						if (*(xxx + 180 * i + j) == 1)
						{
							if (j < 90)
								r_sum_left++;
							else
								r_sum_right++;

							if ((*(xxx + 180 * i + j) + *(xxx + 180 * i + j - 1) == 3)
								|| (*(xxx + 180 * i + j) + *(xxx + 180 * (i - 1) + j) == 3)
								|| (*(xxx + 180 * i + j) + *(xxx + 180 * (i - 1) + j - 1) == 3))
							{
								r_b_w_i += i;
								cnt0++;
								break;


							}

						}
						else if (*(xxx + 180 * i + j) == 2)
							break;

					}
				}



				r_sum = r_sum_left + r_sum_right;
				printf("r_sum=%d\n", r_sum);
				printf("r_b_w_i=%d\n", r_b_w_i / cnt0);
				motion1 = 3;
				goto GOUP;
			}

			else if (motion1 == 3)//고개왼쪽
			{
				printf("motion1=%d", motion1);
				printf("face left!\n");
				Send_Command(0x03, 0xfc);
				DelayLoop(80000000);

				motion1 = 4;
				goto GOUP;
			}

			else if (motion1 == 4)//왼쪽에서 영상처리
			{
				printf("motion1=%d", motion1);
				printf("left screen\n");
				Send_Command(0x03, 0xfc);
				DelayLoop(80000000);
				for (j = 5; j < 175; j++)
				{
					for (i = 118; i >= 60; i--)
					{
						if (*(xxx + 180 * i + j) == 1)
						{
							if (j < 90)
								l_sum_left++;
							else
								l_sum_right++;

							if ((*(xxx + 180 * i + j) + *(xxx + 180 * i + j - 1) == 3)
								|| (*(xxx + 180 * i + j) + *(xxx + 180 * (i - 1) + j) == 3)
								|| (*(xxx + 180 * i + j) + *(xxx + 180 * (i - 1) + j - 1) == 3))
							{
								l_b_w_i += i;
								cnt0++;
								break;

							}

						}

						else if (*(xxx + 180 * i + j) == 2)
							break;


					}
				}



				l_sum = l_sum_left + l_sum_right;
				printf("l_sum=%d\n", l_sum);
				printf("l_b_w_i=%d\n", l_b_w_i / cnt0);

				motion1 = 5;
				goto GOUP;
			}

			else if (motion1 == 5)//거리 비교
			{
				printf("motion1=%d", motion1);
				printf("distance\n");
				Send_Command(0x01, 0xfe);
				DelayLoop(80000000);
				if (l_sum > r_sum + 1000) // 왼쪽으로 한걸음 가야할듯
				{
					motion1 = 6;
					goto GOUP;
				}
				else if (r_sum > l_sum + 1000) // 오른쪽으로 한걸음 가야할듯
				{
					motion1 = 7;
					goto GOUP;
				}
				else // 평행비교로 가야대
				{
					motion1 = 8;
					goto GOUP;
				}
			}

			else if (motion1 == 6)//왼쪽한걸음동작
			{
				printf("motion1=%d", motion1);
				printf("Go left!\n");
				Send_Command(0x05, 0xfa);
				DelayLoop(80000000);

				motion1 = 1;
				goto GOUP;
			}

			else if (motion1 == 7)//오른쪽한걸음동작
			{
				printf("motion1=%d", motion1);
				printf("Go Right!\n");
				Send_Command(0x06, 0xf9);
				DelayLoop(80000000);

				motion1 = 1;
				goto GOUP;
			}

			else if (motion1 == 8) //오른쪽평행비교하자~
			{
				r_sum_left = 0, r_sum_right = 0;
				l_sum_left = 0, l_sum_right = 0;

				printf("motion1=%d", motion1);
				printf("Second,face right!\n");
				Send_Command(0x04, 0xfb);
				DelayLoop(80000000);

				motion1 = 9;
				goto GOUP;
			}

			else if (motion1 == 9)//오른쪽 영상비교
			{

				printf("motion1=%d", motion1);
				printf("Second,right screen\n");
				Send_Command(0x04, 0xfb);
				DelayLoop(80000000);
				for (j = 5; j < 175; j++)
				{
					for (i = 116; i >= 60; i--)
					{
						if (*(xxx + 180 * i + j) == 1)
						{
							if (j < 90)
								r_sum_left++;
							else
								r_sum_right++;

							if ((*(xxx + 180 * i + j) + *(xxx + 180 * i + j - 1) == 3)
								|| (*(xxx + 180 * i + j) + *(xxx + 180 * (i - 1) + j) == 3)
								|| (*(xxx + 180 * i + j) + *(xxx + 180 * (i - 1) + j - 1) == 3))
							{
								break;

							}



						}
						else if (*(xxx + 180 * i + j) == 2)
							break;
					}
				}
				printf("r_sum_left=%d\n", r_sum_left);
				printf("r_sum_right=%d\n", r_sum_right);

				motion1 = 10;
				goto GOUP;
			}

			else if (motion1 == 10)//평행비교
			{
				printf("motion1=%d", motion1);
				printf("Center\n");
				Send_Command(0x04, 0xfb);
				DelayLoop(80000000);
				if (r_sum_right > r_sum_left + 750) // 왼쪽으로 돌아야함
				{
					motion1 = 11;
					goto GOUP;
				}
				else if (r_sum_left > r_sum_right + 750) // 오른쪽으로 돌아야함
				{
					motion1 = 12;
					goto GOUP;
				}
				else // 이제 가자
				{
					motion1 = 13;
					goto GOUP;
				}
			}

			else if (motion1 == 11)//왼쪽으로 20도
			{
				printf("motion1=%d", motion1);
				printf("Turn Left!\n");
				Send_Command(0x09, 0xf6);
				DelayLoop(80000000);

				motion1 = 8;
				goto GOUP;
			}

			else if (motion1 == 12)//오른쪽으로 20도
			{
				printf("motion1=%d", motion1);
				printf("Turn right!\n");
				Send_Command(0x0a, 0xf5);
				DelayLoop(80000000);

				motion1 = 8;
				goto GOUP;
			}

			else if (motion1 == 13)
			{
				printf("motion1=%d", motion1);
				printf("GOGO!!\n");
				Send_Command(0x02, 0xfd);
				DelayLoop(80000000);
				motion1 = 0;
				goto GOUP;
			}




			///////////////////////////////////////////////////////////////*/
			

//stage1
//////////////////// 1번째 장애물 /////////////////////////////
//앞만 보고 가다가 파란 픽셀이 화면에 많이 잡히면 stop
if (stage == 1)
{
	int aver = 0;
	cnt1 = 0;
	sum1 = 0;
	sum2 = 0;
	Send_Command(0x0c, 0xf3);
	Send_Command(0x0c, 0xf3);
	DelayLoop(50000000);

	for (i = 60; i < 120; i++)
		for (j = 30; j < 150; j++)
			if (*(xxx + 180 * i + j) == 6)//파란색일 때
			{
				sum1 = sum1 + j;
				cnt1++;
				*(lcd + i * 180 + j) = 0xFFFF;
			}
	draw_img_from_buffer(fpga_videodata, 0, 18, 0, 0, 1.77, 0);
	draw_img_from_buffer(lcd, 0, 250, 0, 0, 1.77, 0);
	flip();
	sum1 = sum1 / (cnt1 + 1);
	printf("sum1 : %d\n", sum1);
	printf("cnt1 : %d\n", cnt1);

	//cnt1값이 커지면 멈추고 외곽선을 이용해서 몸의 평형으로 맞춤
	//그리고 고개를 올림
	if (cnt1 > 1000)
	{
		Send_Command(0x01, 0xfe);
		DelayLoop(50000000);
		printf("up start\n");
		Send_Command(0x0d, 0xf2);//고개들기
		Send_Command(0x0d, 0xf2);
		DelayLoop(50000000);
		printf("up end\n");
		sw = 1;
		goto GOUP;
	stage1:
		printf("stage1\n");

		aver = 0;
		cnt1 = 0;
		sum2 = 0;
		sum3 = 0;
		for (i = 0; i < 120; i++)
		{

			for (j = 0; j < 180; j++)
			{

				if (*(xxx + 180 * i + j) == 6)//파란색 발견하면 cnt1증가 가로축j의 합을 sum2에 저장
				{

					cnt1++;
					sum2 = sum2 + j;
				}

			}

			if (cnt1 > 40)// 가로줄 하나에 cnt1가 40 이상이면 cnt1값과 sum2값을 다른 변수에 합하면서 저장
			{
				aver = aver + cnt1;
				sum3 = sum3 + sum2;
				cnt1 = 0;
				sum2 = 0;
			}
			else //아니면 sum2, cnt1초기화
			{
				sum2 = 0;
				cnt1 = 0;
			}
		}

		sum3 = sum3 / (aver + 1);
		//printf("sum1 : %d sum2 : %d\n", sum1,sum2);
		printf("aver : %d  sum3 : %d\n", aver, sum3);

		if (sum3 >= 80 && sum3 < 200)
		{
			printf("right\n");
			Send_Command(0x06, 0xf9);//오른쪽으로 한걸음
			Send_Command(0x06, 0xf9);
			DelayLoop(50000000);
			Send_Command(0x06, 0xf9);
			Send_Command(0x06, 0xf9);
			DelayLoop(50000000);
			Send_Command(0x06, 0xf9);
			Send_Command(0x06, 0xf9);
			DelayLoop(50000000);
			cnt++;
		}

		else if (sum3 > 0 && sum3 < 80)//왼쪽에 파란픽셀이 많을 때
		{
			printf("left\n");
			Send_Command(0x05, 0xfa);//왼쪽으로 한걸음
			Send_Command(0x05, 0xfa);
			DelayLoop(50000000);
			Send_Command(0x05, 0xfa);
			Send_Command(0x05, 0xfa);
			DelayLoop(50000000);
			Send_Command(0x05, 0xfa);
			Send_Command(0x05, 0xfa);
			DelayLoop(50000000);
			cnt++;
		}

		else if (sum3 == 0)
		{
			printf("again\n");
			Send_Command(0x06, 0xf9);
			Send_Command(0x06, 0xf9);
			DelayLoop(50000000);
			Send_Command(0x0d, 0xf2);//고개들기
			Send_Command(0x0d, 0xf2);
			DelayLoop(50000000);
			sw = 1;
			goto GOUP;
		}


		if (cnt == 2)
		{
			printf("yes\n");
			stage = 2;
			goto GOUP;
		}
	}
	cnt2 = 0;

	for (i = 20; i < 100; i++)
	{
		for (j = 0; j < 180; j++)
		{
			if ((((*(xxx + i * 180 + j) + *(xxx + i * 180 + j + 1)) == 6) && *(xxx + i * 180 + j) == 4)
				|| (((*(xxx + i * 180 + j) + *(xxx + i * 180 + j - 1)) == 6) && *(xxx + i * 180 + j) == 4))
			{
				cnt2++;
				*(lcd + 180 * i + j) = 0x7000;
			}
			else
				*(lcd + 180 * i + j) = 0x0000;
		}
	}
	if (cnt2 > 50){
		printf("yes\n");
		stage = 2;
		
		goto GOUP;

	}

}


///////////////////////////////////////////////////////////////

			//stage2
//////////////////// 2번째 장애물 ///////////////////////////// ***i값 나중에 추가!***
			else if (stage == 2)
			{
				cnt2 = 0;
				for (i = 20; i < 100; i++)
				{
					for (j = 0; j < 180; j++)
					{
						if ((((*(xxx + i * 180 + j) + *(xxx + i * 180 + j + 1)) == 6) && *(xxx + i * 180 + j) == 4)
							|| (((*(xxx + i * 180 + j) + *(xxx + i * 180 + j - 1)) == 6) && *(xxx + i * 180 + j) == 4))
						{
							cnt2++;
							*(lcd + 180 * i + j) = 0x7000;
						}
						else
							*(lcd + 180 * i + j) = 0x0000;
					}
				}
				draw_img_from_buffer(fpga_videodata, 0, 18, 0, 0, 1.77, 0);
				draw_img_from_buffer(lcd, 0, 250, 0, 0, 1.77, 0);
				flip();



				if (motion2 == 0)
				{
					printf("slow go1!\n");
					Send_Command(0x0c, 0xf3);
					Send_Command(0x0c, 0xf3);
					Send_Command(0x0c, 0xf3);
					DelayLoop(20000000);
					printf("slow go2!\n");
					Send_Command(0x0c, 0xf3);
					Send_Command(0x0c, 0xf3);
					Send_Command(0x0c, 0xf3);
					DelayLoop(20000000);
					printf("slow go3!\n");
					Send_Command(0x0c, 0xf3);
					Send_Command(0x0c, 0xf3);
					Send_Command(0x0c, 0xf3);
					DelayLoop(20000000);

					motion2 = 1;
					goto GOUP;
				}

				else if (motion2 == 1)
				{
					printf("STOP and Wait\n");
					Send_Command(0x01, 0xfe);
					Send_Command(0x01, 0xfe);
					Send_Command(0x01, 0xfe);
					DelayLoop(10000000);
					if (cnt2 > 50)
						motion2 = 2;//멈춰
				}

				else if (motion2 == 2)
				{
					printf("STOP!!!!!!!!!!!!!!\n");
					Send_Command(0x01, 0xfe);
					Send_Command(0x01, 0xfe);
					Send_Command(0x01, 0xfe);
					DelayLoop(10000000);
					if (cnt2 < 30)
						motion2 = 3;//가
					goto GOUP;
				}

				else if (motion2 == 3)
				{
					printf("GOGOGOGOGO!!!!!!!!!!!\n");
					Send_Command(0x02, 0xfd);
					Send_Command(0x02, 0xfd);
					Send_Command(0x02, 0xfd);
					DelayLoop(20000000);
					stage = 3;
					goto GOUP;
				}
			}

			///////////////////////////////////////////////////////////////


			//stge3
			/////////////////////// 3번째 장애물 /////////////////////////////
			else if (stage == 3)
			{
				cnt3 = 0;

				for (i = 90; i < 120; i++)
				{
					for (j = 20; j < 160; j++)
					{

						if (*(xxx + 180 * i + j) == 6)//파랑일 경우
						{
							*(lcd + 180 * i + j) = 0xf000;

							cnt3++;
						}


					}
				}
				draw_img_from_buffer(fpga_videodata, 0, 18, 0, 0, 1.77, 0);
				draw_img_from_buffer(lcd, 0, 250, 0, 0, 1.77, 0);
				flip();

				printf("cnt3=%d\n", cnt3);

				if (cnt3 > 300)
				{
					printf("Command, 10 walk\n");

					motion3 = 1;
				}

				if (motion3 == 0)
				{
					printf("slow go!\n");
					Send_Command(0x0c, 0xf3);
					Send_Command(0x0c, 0xf3);
					Send_Command(0x0c, 0xf3);
					DelayLoop(100000000);
					goto GOUP;
				}
				else if (motion3 == 1)
				{
					printf("10walk\n");
					Send_Command(0x0b, 0xf4);
					Send_Command(0x0b, 0xf4);
					Send_Command(0x0b, 0xf4);
					DelayLoop(250000000);

					motion3 = 2;
					goto GOUP;
				}
				else if (motion3 == 2)
				{

					printf("10walk,one more\n");
					Send_Command(0x0b, 0xf4);
					Send_Command(0x0b, 0xf4);
					Send_Command(0x0b, 0xf4);
					DelayLoop(250000000);
					motion3 = 3;
					goto GOUP;
				}

				else if (motion3 == 3)
				{
					printf("jump\n");
					Send_Command(0x10, 0xef);
					Send_Command(0x10, 0xef);
					Send_Command(0x10, 0xef);
					DelayLoop(500000000);
					motion3 = 4;
					goto GOUP;
				}
				else if (motion3 == 4)
				{
					printf("GO,and turn!\n");
					Send_Command(0x02, 0xfd);
					Send_Command(0x02, 0xfd);
					Send_Command(0x02, 0xfd);
					DelayLoop(120000000);
					printf("Turn1\n");
					Send_Command(0x07, 0xf8);
					Send_Command(0x07, 0xf8);
					Send_Command(0x07, 0xf8);
					DelayLoop(100000000);
					printf("Turn2\n");
					Send_Command(0x07, 0xf8);
					Send_Command(0x07, 0xf8);
					Send_Command(0x07, 0xf8);
					DelayLoop(100000000);
					printf("Turn3\n");
					Send_Command(0x07, 0xf8);
					Send_Command(0x07, 0xf8);
					Send_Command(0x07, 0xf8);
					DelayLoop(100000000);
					printf("Turn4\n");
					Send_Command(0x07, 0xf8);
					Send_Command(0x07, 0xf8);
					Send_Command(0x07, 0xf8);
					DelayLoop(100000000);
					printf("Clear!\n");
					stage = 4;
					goto GOUP;
				}
			}




			/////////////////////////////////////////////////////////////////

			//stage4
			/*/////////////////////// 4번째 장애물 /////////////////////////////
						//걸어오고있다.
						else if (stage == 4)
						{
						cnt4 = 0, cnt4_b_w = 0;
						st4_av_i = 0, st4_sum_i = 0;
						green4_l = 0, green4_r = 0;
						st4_left = 0, st4_right = 0;



						for (i = 0; i < 120; i++)
						{
						for (j = 40; j < 140; j++)
						{
						if (*(xxx + 180 * i + j) == 5)
						{
						if ((*(xxx + 180 * i + j) + *(xxx + 180 * i + j + 1) == 7)
						|| (*(xxx + 180 * i + j) + *(xxx + 180 * (i + 1) + j) == 7)
						|| (*(xxx + 180 * i + j) + *(xxx + 180 * (i + 1) + j + 1) == 7))//초검일 경우
						{
						*(lcd + 180 * i + j) = 0x000f;
						*(st4_green + cnt4) = i;
						cnt4++;

						}
						else
						*(lcd + 180 * i + j) = 0xffff;
						}
						}
						}

						for (i = 60; i < 120; i++)
						{
						for (j = 40; j < 140; j++)
						{
						if (*(xxx + 180 * i + j) == 2)
						{
						if ((*(xxx + 180 * i + j) + *(xxx + 180 * i + j - 1) == 3)
						|| (*(xxx + 180 * i + j) + *(xxx + 180 * (i - 1) + j) == 3)
						|| (*(xxx + 180 * i + j) + *(xxx + 180 * (i - 1) + j - 1) == 3))//흰검일 경우//내려갈거
						{
						*(lcd + 180 * i + j) = 0xf000;
						cnt4_b_w++;
						}
						}
						}
						}




						draw_img_from_buffer(fpga_videodata, 0, 18, 0, 0, 1.77, 0);
						draw_img_from_buffer(lcd, 0, 250, 0, 0, 1.77, 0);
						flip();

						for (i = 0; i < cnt4; i++)
						{
						st4_sum_i += *(st4_green + i);
						}

						st4_av_i = st4_sum_i / cnt4;

						printf("st4_av_i=%d\n", st4_av_i);
						printf("cnt4=%d\n", cnt4);
						printf("cnt4_b_w=%d\n", cnt4_b_w);
						printf("motion4=%d\n", motion4);

						if (motion4 == 0)
						{
						if (st4_av_i >65 && cnt4 > 5)
						{
						printf("command up!\n");
						Send_Command(0x0b, 0xf4);
						Send_Command(0x0b, 0xf4);
						Send_Command(0x0b, 0xf4);// 고개숙이고 총총걸음 10걸음짜리 행동으로 따로넣어야할듯
						DelayLoop(250000000);

						printf("Walk End!\n");

						//총총걸음 한 10걸음? 하다가 계단오르기!!!!! 로직으로
						motion4 = 1;
						goto GOUP;

						}
						else
						{
						Send_Command(0x0c, 0xf3);
						Send_Command(0x0c, 0xf3);
						Send_Command(0x0c, 0xf3);
						DelayLoop(50000000);
						printf("no!\n");
						goto GOUP;
						}
						}

						else if (motion4 == 1)
						{
						printf("up\n");
						Send_Command(0x0e, 0xf1);
						Send_Command(0x0e, 0xf1);
						Send_Command(0x0e, 0xf1);//오르기
						DelayLoop(250000000);
						motion4 = 2;
						goto GOUP;
						}

						else if (motion4 == 2)//올라간상태 총총걸음
						{
						for (i = 0; i < 120; i++) // 초록색에서 균형잡기
						{
						for (j = 0; j < 180; j++)
						{
						if (*(xxx + 180 * i + j) == 5)
						{
						if (j < 90)
						st4_left++;
						else
						st4_right++;
						}
						}
						}

						for (i = 0; i < 120; i++)
						{
						for (j = 0; j < 10; j++)
						{
						if (*(xxx + 180 * i + j) == 5)
						green4_l++;
						}
						}

						for (i = 0; i < 120; i++)
						{
						for (j = 110; j < 120; j++)
						{
						if (*(xxx + 180 * i + j) == 5)
						green4_r++;
						}
						}

						printf("up clear!\n");
						printf("st4_left=%d\n", st4_left);
						printf("st4_right=%d\n", st4_right);
						printf("cnt4_b_w=%d\n", cnt4_b_w);

						if (st4_left > st4_right + 2000)
						{
						printf("go left\n");
						Send_Command(0x05, 0xfa);
						Send_Command(0x05, 0xfa);
						Send_Command(0x05, 0xfa);
						DelayLoop(50000000);

						goto GOUP;
						}
						else if (st4_right > st4_left + 2000)
						{
						printf("go right\n");
						Send_Command(0x06, 0xf9);
						Send_Command(0x06, 0xf9);
						Send_Command(0x06, 0xf9);
						DelayLoop(50000000);


						goto GOUP;
						}
						else
						{
						if (green4_l > green4_r+500)
						{
						printf("turn left\n");
						Send_Command(0x09, 0xf6);
						Send_Command(0x09, 0xf6);
						Send_Command(0x09, 0xf6);
						DelayLoop(100000000);
						goto GOUP;
						}

						else if (green4_r > green4_l+500)
						{
						printf("turn right\n");
						Send_Command(0x0a, 0xf5);
						Send_Command(0x0a, 0xf5);
						Send_Command(0x0a, 0xf5);
						DelayLoop(100000000);
						goto GOUP;
						}
						else
						{
						printf("center!\n");
						Send_Command(0x12, 0xed);
						Send_Command(0x12, 0xed);
						Send_Command(0x12, 0xed);//바닥보고 총총걸음(이건 한~두걸음씩)
						DelayLoop(50000000);

						if (cnt4_b_w > 50)
						{
						motion4 = 3;
						goto GOUP;
						}
						goto GOUP;
						}
						}



						}



						else if (motion4 == 3)
						{
						printf("Command Down!\n");
						printf("one\n");
						Send_Command(0x0b, 0xf4);
						Send_Command(0x0b, 0xf4);
						Send_Command(0x0b, 0xf4);// 고개숙이고 총총걸음 10걸음짜리 행동으로 따로넣어야할듯
						DelayLoop(250000000);
						printf("two\n");
						Send_Command(0x0c, 0xf3);
						Send_Command(0x0c, 0xf3);
						Send_Command(0x0c, 0xf3);//바닥보고 총총걸음(이건 한~두걸음씩)
						DelayLoop(75000000);
						printf("three\n");
						Send_Command(0x0c, 0xf3);
						Send_Command(0x0c, 0xf3);
						Send_Command(0x0c, 0xf3);//바닥보고 총총걸음(이건 한~두걸음씩)
						DelayLoop(75000000);



						printf("Down!\n");
						Send_Command(0x0f, 0xf0);
						Send_Command(0x0f, 0xf0);
						Send_Command(0x0f, 0xf0);//내리기
						DelayLoop(250000000);
						printf("Stage Clear!!\n");
						motion4 = 4;
						goto GOUP;
						}

						else if (motion4 == 4)
						{
						for (i = 0; i < 4; i++)
						{
						printf("Dance~!~!~!~!!~!\n");
						Send_Command(0x05, 0xfa);
						Send_Command(0x05, 0xfa);
						Send_Command(0x05, 0xfa);
						DelayLoop(70000000);
						Send_Command(0x06, 0xf9);
						Send_Command(0x06, 0xf9);
						Send_Command(0x06, 0xf9);
						DelayLoop(70000000);
						}
						motion4 = 5;
						goto GOUP;
						}
						else
						{
						printf("Sleep\n");
						Send_Command(0x01, 0xfe);
						DelayLoop(10000000);
						}

						}
						//////////////////////////////////////////////////////////
						*/

			//stage5
			/*///////////////////////5번째 장애물///////////////////////

			/////////////////////////////////////////////////////////*/

			//stage6
			/*////////////////////// 6번째 장애물 //////////////////////
			if (stage == 6)
			{

				cnt6 = 0, st6_sum_i = 0, st6_av_i = 0;

				for (i = 0; i < 120; i++)
				{
					for (j = 20; j < 160; j++)
					{
						if (*(xxx + 180 * i + j) == 3)
						{
							if ((*(xxx + 180 * i + j) + *(xxx + 180 * i + j + 1) == 4)
								|| (*(xxx + 180 * i + j) + *(xxx + 180 * (i + 1) + j) == 4)
								|| (*(xxx + 180 * i + j) + *(xxx + 180 * (i + 1) + j + 1) == 4)
								|| (*(xxx + 180 * i + j) + *(xxx + 180 * i + j - 1) == 4)
								|| (*(xxx + 180 * i + j) + *(xxx + 180 * (i - 1) + j) == 4)
								|| (*(xxx + 180 * i + j) + *(xxx + 180 * (i - 1) + j - 1) == 4))//흰빨일 경우
							{
								*(lcd + 180 * i + j) = 0x000f;
								*(st6_red + cnt6) = i;
								cnt6++;

							}
							else
								*(lcd + 180 * i + j) = 0xffff;
						}
					}
				}
				draw_img_from_buffer(fpga_videodata, 0, 18, 0, 0, 1.77, 0);
				draw_img_from_buffer(lcd, 0, 250, 0, 0, 1.77, 0);
				flip();

				for (i = 0; i < cnt6; i++)
				{
					st6_sum_i += *(st6_red + i);
				}

				st6_av_i = st6_sum_i / cnt6;

				printf("cnt6=%d\n", cnt6);
				printf("st6_av_i=%d\n", st6_av_i);


				if (motion6 == 0)
				{
					if (st6_av_i >85 && cnt6 > 100)
					{
						printf("command up!\n");
						Send_Command(0x0b, 0xf4);
						Send_Command(0x0b, 0xf4);
						Send_Command(0x0b, 0xf4);// 고개숙이고 총총걸음 10걸음짜리 행동으로 따로넣어야할듯
						DelayLoop(250000000);

						printf("Walk End!\n");

						//총총걸음 한 10걸음? 하다가 계단오르기!!!!! 로직으로
						motion6 = 1;
						goto GOUP;

					}
					else
					{
						Send_Command(0x0c, 0xf3);
						Send_Command(0x0c, 0xf3);
						Send_Command(0x0c, 0xf3);
						DelayLoop(50000000);
						printf("no!\n");
						goto GOUP;
					}
				}

				else if (motion6 == 1)
				{
					printf("up\n");
					Send_Command(0x13, 0xec);
					Send_Command(0x13, 0xec);
					Send_Command(0x13, 0xec);//오르기
					DelayLoop(250000000);
					motion6 = 2;
					goto GOUP;
				}

				else if (motion6 == 2)
				{
					printf("GoDown!\n");
					Send_Command(0x14, 0xeb);
					Send_Command(0x14, 0xeb);
					Send_Command(0x14, 0xeb);
					DelayLoop(250000000);
					motion6 = 3;
					goto GOUP;
				}

				else if (motion6 == 3)
				{
					printf("GoDown!\n");
					Send_Command(0x14, 0xeb);
					Send_Command(0x14, 0xeb);
					Send_Command(0x14, 0xeb);
					DelayLoop(250000000);
					motion6 = 4;
					goto GOUP;
				}

				else if (motion6 == 4)
				{
					printf("Stand!\n");
					Send_Command(0x01, 0xfe);
					Send_Command(0x01, 0xfe);
					Send_Command(0x01, 0xfe);
					DelayLoop(10000000);
					stage = 7;
					goto GOUP;
				}



			}

			/////////////////////////////////////////////////////////*/

			//stage7
			/*////////////////////////////////////////////////////////
			else if (stage == 7)
			{

				cnt7 = 0;
				for (i = 20; i < 100; i++)
				{
					for (j = 0; j < 180; j++)
					{
						if ((((*(xxx + i * 180 + j) + *(xxx + (i - 1) * 180 + j)) == 6) && *(xxx + i * 180 + j) == 4)
							|| (((*(xxx + i * 180 + j) + *(xxx + (i + 1) * 180 + j)) == 6) && *(xxx + i * 180 + j) == 4))
						{
							cnt7++;
							*(lcd + 180 * i + j) = 0x7000;
						}
						else
							*(lcd + 180 * i + j) = 0x0000;
					}
				}
				draw_img_from_buffer(fpga_videodata, 0, 18, 0, 0, 1.77, 0);
				draw_img_from_buffer(lcd, 0, 250, 0, 0, 1.77, 0);
				flip();



				if (motion7 == 0)
				{
					printf("slow go1!\n");
					Send_Command(0x0c, 0xf3);
					Send_Command(0x0c, 0xf3);
					Send_Command(0x0c, 0xf3);
					DelayLoop(20000000);
					printf("slow go2!\n");
					Send_Command(0x0c, 0xf3);
					Send_Command(0x0c, 0xf3);
					Send_Command(0x0c, 0xf3);
					DelayLoop(20000000);
					printf("slow go3!\n");
					Send_Command(0x0c, 0xf3);
					Send_Command(0x0c, 0xf3);
					Send_Command(0x0c, 0xf3);
					DelayLoop(20000000);
					printf("slow go4!\n");
					Send_Command(0x0c, 0xf3);
					Send_Command(0x0c, 0xf3);
					Send_Command(0x0c, 0xf3);
					DelayLoop(20000000);
					printf("slow go5!\n");
					Send_Command(0x0c, 0xf3);
					Send_Command(0x0c, 0xf3);
					Send_Command(0x0c, 0xf3);
					DelayLoop(20000000);

					motion7 == 1;
					goto GOUP;
				}

				else if (motion7 == 1)
				{
					printf("STOP and Wait\n");
					Send_Command(0x01, 0xfe);
					Send_Command(0x01, 0xfe);
					Send_Command(0x01, 0xfe);
					DelayLoop(10000000);
					if (cnt7 > 50)
						motion7 = 2;//멈춰
				}

				else if (motion2 == 2)
				{
					printf("STOP!!!!!!!!!!!!!!\n");
					Send_Command(0x01, 0xfe);
					Send_Command(0x01, 0xfe);
					Send_Command(0x01, 0xfe);
					DelayLoop(10000000);
					if (cnt7 < 50)
						motion7 = 3;//가
					goto GOUP;
				}

				else if (motion7 == 3)
				{
					printf("GOGOGOGOGO!!!!!!!!!!!\n");
					Send_Command(0x02, 0xfd);
					Send_Command(0x02, 0xfd);
					Send_Command(0x02, 0xfd);
					DelayLoop(20000000);
					Send_Command(0x02, 0xfd);
					Send_Command(0x02, 0xfd);
					Send_Command(0x02, 0xfd);
					DelayLoop(20000000);
					Send_Command(0x02, 0xfd);
					Send_Command(0x02, 0xfd);
					Send_Command(0x02, 0xfd);
					DelayLoop(20000000);
					Send_Command(0x02, 0xfd);
					Send_Command(0x02, 0xfd);
					Send_Command(0x02, 0xfd);
					DelayLoop(20000000);
					stage = 8;
					goto GOUP;
				}
			}
			//////////////////////////////////////////////////*/


			//printf("Full < Expension(x2.66), Rotate(90) > (320 x 480)\n");

			//draw_img_from_buffer(lcd, 320, 0, 0, 0, 2.67, 90);

		}

	}

	//TestItemSelectRobot();

	free(fpga_videodata);
	free(lcd);
	free(hue_joon);
	free(satur_tmp);
	free(v_compare);
	free(s_temp);
	free(xxx);
	free(red);
	free(green);
	free(blue);

	uart_close();
	if (bmpsurf != 0)
		release_surface(bmpsurf);
	close_graphic();

	return 0;
}