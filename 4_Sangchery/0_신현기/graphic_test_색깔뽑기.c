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

	int white = 0;
	int cnt1 = 0, cnt2 = 0;//각 stage별로 cnt1, cnt2 ... 변수 추가 예정
	int stage = 0;

	int motion2 = 0;

	float r = 0, g = 0, b = 0;
	float max = 0.0f, min = 0.0f;
	float hf = 0.0f, sf = 0.0f, vf = 0.0f;
	//	float point_h = 0.0f, point_s = 0.0f, point_v = 0.0f; //중앙점의 hsv값
	float delta;
	char input;
	int ret;
	int b_loop = 0;
	int sum_left = 0, sum_right = 0;
	int sum_i = 0, sum_j = 0;
	int sw = 0;
	
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

	float Mask[9] = { 0 };
	float Mask1[9] = { 0 };//마스크하기 위한 변수
	int index1 = 0, index2 = 0, index3 = 0;

	init_console();
	ret = uart_open();
	
	if (ret < 0) return EXIT_FAILURE;

	uart_config(UART1, 57600, 8, UART_PARNONE, 1);

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


		while (1)
		{

			//input = getchar();
			/*
			if (input == 'a'){
			printf("enter the min value\n");
			printf("now hum_min: %d, hue_max: %d, sat_min: %d\n", hue_min, hue_max, sat_min);
			//scanf("%d %d %d", &hue_min, &hue_max, &sat_min);
			printf("press the 'b' button to break loop\n"); // 코드 추가
			}


			if (input == 'b'){
			b_loop = 0;
			break;
			}
			*/
			GOUP:
			read_fpga_video_data(fpga_videodata);


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

			/*///////////////////마스크 추가///////////////////////////
			printf("mask start\n"); // 외곽선추출
			int n = 1;

			Mask[0] = -1.0f; Mask[1] = -1.0f; Mask[2] = -1.0f;
			Mask[3] = -1.0f; Mask[4] = 8.0f; Mask[5] = -1.0f;
			Mask[6] = -1.0f; Mask[7] = -1.0f; Mask[8] = -1.0f;

			Mask1[0] = 1.0f; Mask1[1] = 1.0f; Mask1[2] = 1.0f;
			Mask1[3] = 0.0f; Mask1[4] = 0.0f; Mask1[5] = 0.0f;
			Mask1[6] = -1.0f; Mask1[7] = -1.0f; Mask1[8] = -1.0f;

			for (i = n; i < 120 - n; i++){
				index1 = i * 180;
				for (j = n; j < 180 - n; j++){
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
					*(lcd + i * 180 + j) = sum1;
				}
			}
			printf("mask end\n");

			////////////////////////////////////////////////////////*/


			for (i = 0; i < 120; i++)
			{

				for (j = 0; j < 180; j++){

					*(lcd + i * 180 + j) = *(fpga_videodata + i * 180 + j);

					if (((int)*(red + i * 180 + j) >17) && ((int)*(green + i * 180 + j) >17) && ((int)*(blue + i * 180 + j) > 17) && ((int)*(v_compare + i * 180 + j) > 17))
						*(xxx + i * 180 + j) = 1;//흰색을표시

					else if (((int)*(red + i * 180 + j) < 10) && ((int)*(green + i * 180 + j) < 10) && ((int)*(blue + i * 180 + j) < 10) && ((int)*(v_compare + i * 180 + j) < 10))
						*(xxx + i * 180 + j) = 2;//검정을표시

					else if (((int)*(red + i * 180 + j) > 15) && ((int)*(green + i * 180 + j) < 15) && ((int)*(blue + i * 180 + j) < 15) && ((((int)*(hue_joon + i * 180 + j) > 300)) || ((int)*(hue_joon + i * 180 + j) < 60)))
						*(xxx + i * 180 + j) = 3;//빨강을표시

					else if (((int)*(red + i * 180 + j) > 18) && ((int)*(green + i * 180 + j) > 18) && ((int)*(blue + i * 180 + j) < 15) && ((int)*(v_compare + i * 180 + j) > 15) && ((int)*(hue_joon + i * 180 + j) > 50) && ((int)*(hue_joon + i * 180 + j) < 80))
						*(xxx + i * 180 + j) = 4;//노랑을표시

					else if (((int)*(red + i * 180 + j) < 15) && ((int)*(green + i * 180 + j) > 15) && ((int)*(blue + i * 180 + j) < 15) && ((int)*(hue_joon + i * 180 + j) > 80) && ((int)*(hue_joon + i * 180 + j) < 120))
						*(xxx + i * 180 + j) = 5;//초록을표시

					else if ((*(red + i * 180 + j) < *(blue + i * 180 + j)) && (*(green + i * 180 + j) < *(blue + i * 180 + j)) && ((int)*(hue_joon + i * 180 + j) > 180) && ((int)*(hue_joon + i * 180 + j) < 250) && *(satur_tmp + i * 180 + j) > 30)
						*(xxx + i * 180 + j) = 6;//파랑을표시

					else
						*(xxx + i * 180 + j) = 7;//나머지

					////////////////////값뽑을때 쓰는 코드/////////////////////
					if (i == 60)
					{
					*(lcd + i * 180 + j) = 0x7000;//lcd에 가로줄 빨간줄 표시코드
					if (j == 90)
					{
					printf("hue: %.1f  sat: %.1f v_: %.1f\n", *(hue_joon + i * 180 + j), *(s_temp + i * 180 + j), *(v_compare + i * 180 + j));
					printf("red : %d, green : %d, blue : %d\n", (int)*(red + i * 180 + j), (int)*(green + i * 180 + j), (int)*(blue + i * 180 + j));
					}

					}
					if (j == 90)
					*(lcd + i * 180 + j) = 0x7000;//lcd에 세로줄 빨간줄 표시코드
					///////////////////////////////////////////////////////////
				}

			}
			switch (sw)
			{
			case 1:
				sw = 0;
				//goto stage1;
			case 2:
				sw = 0;
				//goto outline;
			default:
				break;
			}
			//검정파랑뽑기
			/*
			for (i = 0; i < 120; i++)
				for (j = 0; j < 180; j++)
				{
					if (*(xxx + i * 180 + j) == 6)
						*(lcd + i * 180 + j) = 0x7000;
					if (*(xxx + i * 180 + j) == 2)
						*(lcd + i * 180 + j) = 0x000f;
				}

				*/

			/*
			int aver = 0;
			int cnt1 = 0;
			int sum2 = 0;
			int sum3 = 0;
			for (i = 40; i < 80; i++)
			{
				for (j = 30; j < 150; j++)
				{

					if (*(xxx + 180 * i + j) == 6)//파란색 발견하면 cnt1증가 가로축j의 합을 sum2에 저장
					{
						cnt1++;
						sum2 = sum2 + j;
						*(lcd + i * 180 + j) = 0x7000;
					}

				}

				if (cnt1 > 40)// 가로줄 하나에 cnt1가 40 이상이면 cnt1값과 sum2값을 다른 변수에 합하면서 저장
				{
					aver = aver + cnt1;
					sum3 = sum3 + sum2;
					cnt1 = 0;
					sum2 = 0;
					for (k = -10; k < 10;k++)
						for(l=-10;l<10;l++)
							*(lcd + (i+k) * 180 + (l+j)) = 0xffff;
				}
				else //아니면 sum2, cnt1초기화
				{
					sum2 = 0;
					cnt1 = 0;
				}
			}
			sum3 = sum3 / (aver + 1);
			printf("aver : %d  sum3 : %d\n", aver, sum3);*/
			/*
			for (i = 0; i < 120; i++)
			{
			for (j = 0; j < 180; j++){

			if ((*(xxx + 180 * i + j) + *(xxx + 180 * i + j - 1)) == 3) *(lcd + i * 180 + j) = 0x7000;
			else if ((*(xxx + 180 * i + j) + *(xxx + 180 * (i - 1) + j)) == 3) *(lcd + i * 180 + j) = 0x7000;
			else if ((*(xxx + 180 * i + j) + *(xxx + 180 * (i - 1) + j - 1)) == 3) *(lcd + i * 180 + j) = 0x7000;

			else *(lcd + i * 180 + j) = 0;
			}
			}*/
			/*/////////////////////////////외곽선 추출 코드///////////////////////////////
			sum_left = 0;
			sum_right = 0;
			white = 0;
			printf("face right\n");
			Send_Command(0x04, 0xfb);
			Send_Command(0x04, 0xfb);//오른쪽보기
			//DelayLoop(80000000);
			sw = 2;
			goto GOUP;
		outline:
			printf("read\n");
			for (j = 5; j < 175; j++)
			{
				for (i = 116; i >= 60; i--)
				{
					if (*(xxx + 180 * i + j) == 1)
					{
						if (j < 90)
							sum_left++;
						else
							sum_right++;
						*(lcd + 180 * i + j) = 0x000f;
					}
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
			/*			
			for (j = 0; j < 180; j++)
			{
				for (i = 119; i >= 0; i--)
				{
					if (*(xxx + i * 180 + j) == 1)
					{
						*(lcd + i * 180 + j) = 0x7000;
						if (j < 90)
							sum_left++;
						else
							sum_right++;

						if (*(xxx + 180 * i + j) == 2)
							break;
					}
				}
			}

			printf("sum_left : %d  sum_right : %d\n", sum_left, sum_right);

			if (sum_left > sum_right + 500)
			{
				printf("turn right\n");
				//Send_Command(0x08, 0xf7);
				//Send_Command(0x08, 0xf7);//오른쪽돌기
				//DelayLoop(50000000);
			}
			else if (sum_right>sum_left + 500)
			{
				printf("turn left\n");
				//Send_Command(0x07, 0xf8);
				//Send_Command(0x07, 0xf8);//왼쪽돌기
				//DelayLoop(50000000);
			}
			white = sum_left + sum_right;
			printf("white : %d\n", white);
			if (white > 3000)
			{
				printf("go left\n");
				//Send_Command(0x05, 0xfa)
				//Send_Command(0x05, 0xfa); // 왼쪽으로 한걸음
				//DelayLoop(50000000);
			}
			else if (white < 1000)
			{
				printf("go right\n");
				//Send_Command(0x06, 0xf9);
				//Send_Command(0x06, 0xf9); // 오른쪽으로 한걸음
				//DelayLoop(50000000);
			}

			Send_Command(0x01, 0xfe);//정면보기
			//DelayLoop(50000000);
			printf("yes\n");


			///////////////////////////////////////////////////////////////////////////////*/

			//stage1
			//앞만 보고 가다가 파란 픽셀이 화면에 많이 잡히면 stop
			//고개를 숙이고 파란 픽셀의 평균값을 확인 후 좌우로 이동
			//고개를 숙인 채로 가운데값을 찾으면 앞으로 다시 이동

			if (stage == 1)
			{
				cnt1 = 0;
				for (i = 0; i < 120; i++)
					for (j = 0; j < 180; j++)
						if (*(xxx + 180 * i + j) == 6)//파란색일 때 
						{
							cnt1++;
							*(lcd + i * 180 + j) = 0xFFFF;
						}

				printf("%d\n", cnt1);

				//cnt1값이 커지면 멈추고 외곽선을 이용해서 몸의 평형으로 맞춤
				//그리고 고개를 숙임
				for (i = 60; i < 120; i++)
					for (j = 0; j < 180; j++)
					{
						if (*(xxx + 180 * i + j) == 6)
						{
							sum_j = sum_j + j;
							cnt1++;
							*(lcd + i * 180 + j) = 0xFFFF;
						}
					}

				sum_j = sum_j / (cnt1 + 1);
				printf("%d", sum_j);

				if (sum_j > 120)//오른쪽에 파란픽셀이 많을 때
				{
					printf("right\n");
					Send_Command(0x06, 0xf9);//오른쪽으로 한걸음
					DelayLoop(200000);
				}
				else if (sum_j < 60)//왼쪽에 파란픽셀이 많을 때
				{
					printf("left\n");
					Send_Command(0x05, 0xfa);//왼쪽으로 한걸음
					DelayLoop(200000);
				}
				else
				{
					printf("center\n");
					Send_Command(0x02, 0xfd);//중앙이면 걷기
				}


				printf("success\n");
				stage = 2;
			}
			
			///////////////////
			//stage2
			/////////////////////////////  ***i값 나중에 추가!***
			if (stage == 2)
			{
				cnt2 = 0;
				for (i = 0; i < 120; i++)
				{
					for (j = 0; j < 180; j++)
					{
						if (((*(xxx + i * 180 + j) - *(xxx + i * 180 + j + 1)) == 2) && *(xxx + i * 180 + j) == 4)
						{
							cnt2++;
							*(lcd + 180 * i + j) = 0x7000;
						}
						else
							*(lcd + 180 * i + j) = 0x0000;
					}
				}
				printf("%d\n", cnt2);
				if (cnt2 > 60)
					motion2 = 1;//멈춰

				if (motion2 == 1)
				{
					if (cnt2 < 60)
						motion2 = 2;//가

				}

				if (motion2 == 1)
				{
					printf("STOP!!!!!!!!!!!!!!\n");
					//	Send_Command(0x04, 0xfb);
					//	DelayLoop(1000000);
				}

				else if (motion2 == 2 || motion2 == 0)
				{
					printf("GOGOGOGOGO!!!!!!!!!!!\n");
					//	Send_Command(0x03, 0xfc);
					//	DelayLoop(200000);
				}
			}

		
			///////////////////////////////////////////////////////////////
			//printf("Full < Expension(x2.66), Rotate(90) > (320 x 480)\n");
			//draw_img_from_buffer(lcd, 320, 0, 0, 0, 2.67, 90);
			draw_img_from_buffer(fpga_videodata, 0, 18, 0, 0, 1.77, 0);
			draw_img_from_buffer(lcd, 0, 250, 0, 0, 1.77, 0);
			flip();
		}

	}


	free(fpga_videodata);
	free(lcd);
	free(hue_joon);
	free(satur_tmp);
	free(v_compare);
	free(s_temp);
	free(red);
	free(green);
	free(blue);
	free(rgb);
	uart_close();
	if (bmpsurf != 0)
		release_surface(bmpsurf);
	close_graphic();

	return 0;
}


















