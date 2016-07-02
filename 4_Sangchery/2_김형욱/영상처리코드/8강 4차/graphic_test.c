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
	SURFACE* bmpsurf = 0;
	U16* fpga_videodata = (U16*)malloc(180 * 120 * 2);
	U16* lcd = (U16*)malloc(180 * 120 * 2);
	U16* gray = (U16*)malloc(180 * 120 * 2);

	float* hue_joon = (float*)malloc(180 * 120 * 4);
	float* satur_tmp = (float*)malloc(180 * 120 * 4);
	float* v_compare = (float*)malloc(180 * 120 * 4);

	float* red = (float*)malloc(180 * 120 * 4);
	float* green = (float*)malloc(180 * 120 * 4);
	float* blue = (float*)malloc(180 * 120 * 4);

	int* xxx = (int*)malloc(180 * 120 * 4);
	int* out_i = (int*)malloc(180 * 120 * 4);
	int* out_j = (int*)malloc(180 * 120 * 4);
	int* st4_green = (int*)malloc(180 * 120 * 4);
	int* st6_red = (int*)malloc(180 * 120 * 4);
	int* blue_cnt = (int*)malloc(180 * 120 * 4);
	int* hole_j = (int*)malloc(180 * 120 * 4);
	int* ball_i = (int*)malloc(180 * 120 * 4);
	int* ball_j = (int*)malloc(180 * 120 * 4);

	int i = 0, j = 0, k = 0, l = 0;
	float r = 0, g = 0, b = 0;
	float max = 0.0f, min = 0.0f;
	float hf = 0.0f, sf = 0.0f, vf = 0.0f;
	int ret, delta;
	char input;
	int b_loop = 0;
	int stage = 1;

	//외곽선
	int first_out = 0;
	int r_sum_left = 0, r_sum_right = 0;
	int l_sum_left = 0, l_sum_right = 0;
	int r_sum = 0, l_sum = 0;
	int cnt0 = 0;
	int motion1 = 0;
	int firstx = 0, firsty = 0, secondx = 0, secondy = 0;
	int result = 0;
	double degree = 0;
	int go = 0;

	int red_out = 0;
	//외곽선 욱이버전 추가필요한 변수
	int i_left = 0, i_right = 0, i_cen = 0, motion = 0;
	//파란장애물
	int cnt = 0, cnt1 = 0;
	int cnt_st1 = 0;
	int motion0 = 0;
	int stop = 0;
	int blue_up = 0, blue_right = 0, blue_left = 0, blue_center = 0;
	int no_find = 0;
	//바리케이트
	int motion2 = 0, cnt2 = 0;
	//허들
	int cnt3 = 0, motion3 = 0;
	int cnt_st3 = 0;
	int st3_right = 0, st3_left = 0;
	//초록계단
	int cnt4 = 0, motion4 = 0, st4_av_i = 0, st4_sum_i = 0, cnt4_b_w = 0, cnt4_green = 0;
	int st4_left = 0, st4_right = 0, green4_l = 0, green4_r = 0, cnt_st4 = 0;
	int plus_b = 0;
	float first_x = 0, first_y = 0, second_x = 0, second_y = 0, outline_x = 0, outline_y = 0;
	//골프공
	int motion5 = 0;
	int cnt_ball = 0, cnt_hole = 0;
	int hole_i_top = 0, hole_i_bot = 0, hole_j_left = 0, hole_j_right = 0;
	int ball_i_top = 0, ball_i_bot = 0, ball_j_left = 0, ball_j_right = 0;
	int hole_i_cen = 0, hole_j_cen = 0;
	int ball_i_cen = 0, ball_j_cen = 0;
	int cnt_2 = 0;
	//빨간계단
	int cnt6 = 0, motion6 = 0, st6_sum_i = 0, st6_av_i = 0;
	int red6_l = 0, red6_r = 0, cnt6_red = 0, cnt_st6 = 0;
	int st6_left = 0, st6_right = 0;
	//바리케이트2
	int cnt7 = 0, motion7 = 0;
	//노란함정
	//st8
	int cnt8 = 0, cnt8_1 = 0, cnt8_2 = 0, motion8 = 0, cnt8_3 = 0, cnt8_4 = 0;
	int st8_turn = 0, outst8 = 0;


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


		while (1)
		{

			DelayLoop(10000000);

		OUT_st8:
			if (outst8 == 1)
			{
				int i_st8 = 0;
				cnt = 0;
				int n = 1;

				read_fpga_video_data(fpga_videodata);
				for (i = 0; i < 180 * 120; i++)
				{
					b = ((*(fpga_videodata + i)) & 31);
					g = (((*(fpga_videodata + i)) >> 6) & 31);
					r = (((*(fpga_videodata + i)) >> 11) & 31);

					int graay = (int)(b + g + r) / 3;
					int gray1 = (graay << 11);
					int gray2 = (graay << 6);
					*(gray + i) = gray1 + gray2 + graay; // 그레이하는과정

					*(lcd + i) = *(fpga_videodata + i);
				}

				if (motion == 0)//준비단계
				{
					printf("Ready\n");
					Send_Command(0x27, 0xd8);
					Send_Command(0x27, 0xd8);
					Send_Command(0x27, 0xd8);
					DelayLoop(17000000);

					motion = 1;//

					goto OUT_st8;
				}

				else if (motion == 1)
				{
					Mask[0] = -1.0f; Mask[1] = -1.0f; Mask[2] = -1.0f;
					Mask[3] = 0.0f; Mask[4] = 0.0f; Mask[5] = 0.0f;
					Mask[6] = 1.0f; Mask[7] = 1.0f; Mask[8] = 1.0f;

					for (i = 120 - n; i > n; i--){
						index1 = i * 180;
						for (j = 90 - n; j > n; j--){
							float sum1 = 0.0f;

							for (k = -n; k <= n; k++)
							{
								index2 = (i + k) * 180;
								index3 = (k + n) * 3;
								for (l = -n; l <= n; l++)
									sum1 += gray[index2 + (j + l)] * Mask[index3 + l + n];
							}

							if (sum1 > 65530)
								*(lcd + i * 180 + j) = 0xffff;

							else
								*(lcd + i * 180 + j) = 0x0000;

						}
					}

					draw_img_from_buffer(fpga_videodata, 0, 18, 0, 0, 1.77, 0);
					draw_img_from_buffer(lcd, 0, 250, 0, 0, 1.77, 0);
					flip();
					/////////////////////////////////////////////////////////

					for (i = 117; i >= 0; i--)
					{
						if (*(lcd + 180 * i + 87) == 0xffff)
						{
							i_st8 = i;
							break;
						}
					}

					printf("i_st8=%d\n", i_st8);

					if (i_st8 <=82)
					{
						printf("go right\n");
						Send_Command(0x35, 0xca);
						Send_Command(0x35, 0xca);
						Send_Command(0x35, 0xca);
						DelayLoop(35000000);
					}
					else if (i_st8 >= 90)
					{
						printf("go left\n");
						Send_Command(0x34, 0xcb);
						Send_Command(0x34, 0xcb);
						Send_Command(0x34, 0xcb);
						DelayLoop(35000000);
					}
					else
					{
						Send_Command(0x01, 0xfe);
						Send_Command(0x01, 0xfe);
						Send_Command(0x01, 0xfe);
						DelayLoop(20000000);

						motion = 0;
						goto GOUP;
					}

					goto OUT_st8;
				}
			}

		OUTLINE:
			if (first_out == 1)//제일처음에 한번 무시하기위해서
			{


				//외곽선 욱이ver.
				i_left = 0, i_right = 0, i_cen = 0;
				cnt = 0;
				int n = 1;

				read_fpga_video_data(fpga_videodata);
				for (i = 0; i < 180 * 120; i++)
				{
					b = ((*(fpga_videodata + i)) & 31);
					g = (((*(fpga_videodata + i)) >> 6) & 31);
					r = (((*(fpga_videodata + i)) >> 11) & 31);

					int graay = (int)(b + g + r) / 3;
					int gray1 = (graay << 11);
					int gray2 = (graay << 6);
					*(gray + i) = gray1 + gray2 + graay; // 그레이하는과정

					*(lcd + i) = *(fpga_videodata + i);
				}

				if (motion == 0)//준비단계
				{
					printf("Ready\n");
					Send_Command(0x27, 0xd8);
					Send_Command(0x27, 0xd8);
					Send_Command(0x27, 0xd8);
					DelayLoop(17000000);

					motion = 1;//

					goto OUTLINE;
				}

				else if (motion == 1)
				{
					Mask[0] = -1.0f; Mask[1] = -1.0f; Mask[2] = -1.0f;
					Mask[3] = 0.0f; Mask[4] = 0.0f; Mask[5] = 0.0f;
					Mask[6] = 1.0f; Mask[7] = 1.0f; Mask[8] = 1.0f;

					for (i = 120 - n; i > n; i--){
						index1 = i * 180;
						for (j = 90 - n; j > n; j--){
							float sum1 = 0.0f;

							for (k = -n; k <= n; k++)
							{
								index2 = (i + k) * 180;
								index3 = (k + n) * 3;
								for (l = -n; l <= n; l++)
									sum1 += gray[index2 + (j + l)] * Mask[index3 + l + n];
							}

							if (sum1 > 65530)
								*(lcd + i * 180 + j) = 0xffff;

							else
								*(lcd + i * 180 + j) = 0x0000;

						}
					}

					draw_img_from_buffer(fpga_videodata, 0, 18, 0, 0, 1.77, 0);
					draw_img_from_buffer(lcd, 0, 250, 0, 0, 1.77, 0);
					flip();
					/////////////////////////////////////////////////////////

					for (i = 117; i >= 0; i--)
					{
						if (*(lcd + 180 * i + 45) == 0xffff)
						{
							i_left = i;
							break;
						}
					}


					for (i = 117; i >= 0; i--)
					{
						if (*(lcd + 180 * i + 75) == 0xffff)
						{
							i_right = i;
							break;
						}
					}

					for (i = 117; i >= 0; i--)
					{
						if (*(lcd + 180 * i + 85) == 0xffff)
						{
							i_cen = i;
							break;
						}
					}
					

					printf("i_left=%d\n", i_left);
					printf("i_right=%d\n", i_right);
					printf("i_cen=%d\n", i_cen);
					printf("i_cen=%d\n", i_cen);

					if (i_left - i_right > 6)
					{
						printf("left turn\n");
						Send_Command(0x3a, 0xc5);//왼쪽턴
						Send_Command(0x3a, 0xc5);//왼쪽턴
						Send_Command(0x3a, 0xc5);//왼쪽턴
						DelayLoop(47000000);
					}
					else if (i_left - i_right <= 6 && i_left - i_right >= 3)
					{
						printf("left turn\n");
						Send_Command(0x39, 0xc6);//왼쪽턴
						Send_Command(0x39, 0xc6);//왼쪽턴
						Send_Command(0x39, 0xc6);//왼쪽턴
						DelayLoop(37000000);
					}

					else if (i_right - i_left > 6)
					{
						printf("right turn\n");
						Send_Command(0x3c, 0xc3);//오른쪽턴
						Send_Command(0x3c, 0xc3);//오른쪽턴
						Send_Command(0x3c, 0xc3);//오른쪽턴
						DelayLoop(47000000);
					}

					else if (i_right - i_left <= 6 && i_right - i_left >= 3)
					{
						printf("right turn\n");
						Send_Command(0x3b, 0xc4);//오른쪽턴
						Send_Command(0x3b, 0xc4);//오른쪽턴
						Send_Command(0x3b, 0xc4);//오른쪽턴
						DelayLoop(37000000);
					}
					else
						cnt++;

					if (i_cen <= 81)
					{
						printf("go right\n");
						Send_Command(0x38, 0xc7);//오른쪽한걸음
						Send_Command(0x38, 0xc7);//오른쪽한걸음
						Send_Command(0x38, 0xc7);//오른쪽한걸음
						DelayLoop(43000000);
					}
					else if (i_cen >= 89)
					{
						printf("go left\n");
						Send_Command(0x37, 0xc8);//왼쪽한걸음
						Send_Command(0x37, 0xc8);//왼쪽한걸음
						Send_Command(0x37, 0xc8);//왼쪽한걸음
						DelayLoop(43000000);
					}
					else
						cnt++;

					if (cnt == 2)
					{
						motion = 2;
						goto OUTLINE;
					}
					else
					{
						motion = 1;
						goto OUTLINE;
					}

				}

				else if (motion == 2)
				{
					printf("gogo\n\n");
					Send_Command(0x01, 0xfe);
					Send_Command(0x01, 0xfe);
					Send_Command(0x01, 0xfe);
					DelayLoop(20000000);
					motion = 0;
					goto GOUP;
					//goto OUTLINE;
				}
			}



			////////////////////////////////////////////////////////////////

		GOUP:

			read_fpga_video_data(fpga_videodata);

			for (i = 0; i < 180 * 120; i++)
			{

				b = ((*(fpga_videodata + i)) & 31);
				g = (((*(fpga_videodata + i)) >> 6) & 31);
				r = (((*(fpga_videodata + i)) >> 11) & 31);

				*(red + i) = r;
				*(green + i) = g;
				*(blue + i) = b;


				int graay = (int)(b + g + r) / 3;
				int gray1 = (graay << 11);
				int gray2 = (graay << 6);
				*(gray + i) = gray1 + gray2 + graay; // 그레이하는과정


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

			}

			for (i = 0; i < 120; i++)
				for (j = 0; j < 180; j++)
					*(lcd + i * 180 + j) = *(fpga_videodata + i * 180 + j);
			//*(lcd + i * 180 + j) = *(gray + i * 180 + j);
			//if (j == 90 && i == 60){
			//	printf("%d\n", *(gray + i * 180 + j));
			//	*(lcd + i * 180 + j) = 0x000f;
			//}
			//if ((int)*(gray + i * 180 + j)>25000 && (int)*(gray + i * 180 + j)<32000)
			//	*(lcd + i * 180 + j) = 0x0000;
			//}
			//draw_img_from_buffer(fpga_videodata, 0, 18, 0, 0, 1.77, 0);
			//draw_img_from_buffer(lcd, 0, 250, 0, 0, 1.77, 0);
			//flip();

			//goto GOUP;
			/*///////////////////////////색깔 조건
			if (((int)*(red + i * 180 + j) >20) && ((int)*(green + i * 180 + j) >20) && ((int)*(blue + i * 180 + j) > 20) && ((int)*(v_compare + i * 180 + j) > 22))
			*(xxx + i * 180 + j) = 1;//흰색을표시

			else if (((int)*(red + i * 180 + j) < 10) && ((int)*(green + i * 180 + j) < 10) && ((int)*(blue + i * 180 + j) < 10) && ((int)*(v_compare + i * 180 + j) < 10))
			*(xxx + i * 180 + j) = 2;//검정을표시

			else if (((int)*(red + i * 180 + j) > 15) && ((int)*(green + i * 180 + j) < 15) && ((int)*(blue + i * 180 + j) < 15) && ((((int)*(hue_joon + i * 180 + j) > 300)) || ((int)*(hue_joon + i * 180 + j) < 60)))
			*(xxx + i * 180 + j) = 3;//빨강을표시
			else if ((*(green + i * 180 + j) < *(red + i * 180 + j)) && (*(blue + i * 180 + j) < *(red + i * 180 + j)) && (((int)*(hue_joon + i * 180 + j) > 300) || ((int)*(hue_joon + i * 180 + j) < 60)))
			*(xxx + i * 180 + j) = 3;//빨강을표시

			else if (((int)*(red + i * 180 + j) > 18) && ((int)*(green + i * 180 + j) > 18) && ((int)*(blue + i * 180 + j) < 15) && ((int)*(v_compare + i * 180 + j) > 15) && ((int)*(hue_joon + i * 180 + j) > 40) && ((int)*(hue_joon + i * 180 + j) < 90))
			*(xxx + i * 180 + j) = 4;//노랑을표시

			else if (((int)*(red + i * 180 + j) < 15) && ((int)*(green + i * 180 + j) > 15) && ((int)*(blue + i * 180 + j) < 15) && ((int)*(hue_joon + i * 180 + j) > 80) && ((int)*(hue_joon + i * 180 + j) < 150))
			*(xxx + i * 180 + j) = 5;//초록을표시
			else if ((*(red + i * 180 + j) < *(green + i * 180 + j)) && (*(blue + i * 180 + j) < *(green + i * 180 + j)) && ((int)*(hue_joon + i * 180 + j) > 80) && ((int)*(hue_joon + i * 180 + j) < 150))
			*(xxx + i * 180 + j) = 5;//초록을표시

			else if ((*(red + i * 180 + j) < *(blue + i * 180 + j)) && (*(green + i * 180 + j) < *(blue + i * 180 + j)) && ((int)*(hue_joon + i * 180 + j) > 180) && ((int)*(hue_joon + i * 180 + j) < 250) && *(satur_tmp + i * 180 + j) > 30 && ((int)*(v_compare + i * 180 + j) < 20))
			*(xxx + i * 180 + j) = 6;//파랑을표시

			else
			*(xxx + i * 180 + j) = 7;//나머지
			*/

			///////////////////// 1번째 장애물 ///////////////////////////// 
			if (stage == 1)
			{
				//첫번째 바리케이트
				printf("stage=%d\n", stage);
				cnt2 = 0;
				for (i = 60; i < 100; i++)
				{
					for (j = 40; j < 120; j++)
					{
						*(lcd + 180 * i + j) = 0x0000;
						//검정
						if (((int)*(red + i * 180 + j) < 10) && ((int)*(green + i * 180 + j) < 10) && ((int)*(blue + i * 180 + j) < 10) && ((int)*(v_compare + i * 180 + j) < 10))
						{
							cnt2++;
							*(lcd + 180 * i + j) = 0xf000;
						}

					}
				}
				draw_img_from_buffer(fpga_videodata, 0, 18, 0, 0, 1.77, 0);
				draw_img_from_buffer(lcd, 0, 250, 0, 0, 1.77, 0);
				flip();

				printf("cnt2=%d\n", cnt2);


				if (motion2 == 0)
				{
					printf("STOP and Wait\n");
					Send_Command(0x01, 0xfe);
					Send_Command(0x01, 0xfe);
					Send_Command(0x01, 0xfe);
					DelayLoop(10000000);
					if (cnt2 > 300)
						motion2 = 2;//멈춰
					goto GOUP;
				}

				else if (motion2 == 2)
				{
					printf("STOP!!!!!!!!!!!!!!\n");
					Send_Command(0x01, 0xfe);
					Send_Command(0x01, 0xfe);
					Send_Command(0x01, 0xfe);
					DelayLoop(10000000);
					if (cnt2 < 200)
						motion2 = 3;//가
					goto GOUP;
				}

				else if (motion2 == 3)
				{
					printf("GOGOGOGOGO!!!!!!!!!!!\n");

					Send_Command(0x03, 0xfc);
					Send_Command(0x03, 0xfc);
					Send_Command(0x03, 0xfc);
					DelayLoop(160000000);
					Send_Command(0x03, 0xfc);
					Send_Command(0x03, 0xfc);
					Send_Command(0x03, 0xfc);
					DelayLoop(150000000);
					printf("done\n");
					stage = 2;
					first_out = 1;
					goto OUTLINE;

				}
				
			}

			///////////////////////////////////////////////////////////////


			/////////////////////// 2번째 장애물 //////////////////////
			else if (stage == 2)
			{
				first_out = 1;
				//빨간 계단 장애물
			
				if (motion6 == 0)
				{
					printf("Eureka!!\n");
					
					Send_Command(0x0b, 0xf4);
					Send_Command(0x0b, 0xf4);
					Send_Command(0x0b, 0xf4);
					DelayLoop(110000000);
					

					motion6 = 1;
					outst8 = 1;
					goto OUT_st8;
				}

				else if (motion6 == 1)
				{//덤블링
					printf("up stairs\n");
					Send_Command(0x26, 0xd9);
					Send_Command(0x26, 0xd9);
					Send_Command(0x26, 0xd9);
					DelayLoop(230000000);
					motion6 = 2;
					goto GOUP;
				}

				else if (motion6 == 2){
					//내려가기 덤블링
					
					printf("down stairs\n");
					Send_Command(0x28, 0xd7);
					Send_Command(0x28, 0xd7);
					Send_Command(0x28, 0xd7);
					DelayLoop(230000000);





					stage++;
					goto OUTLINE;
				}

			}

			//////////////////////////////////////////////////////////


			/////////////////////// 3번째 장애물 /////////////////////////////
			else if (stage == 3)
			{
				//비비기
				printf("Bibigi\n");

				Send_Command(0x0b, 0xf4);
				Send_Command(0x0b, 0xf4);
				Send_Command(0x0b, 0xf4);
				DelayLoop(90000000);
				Send_Command(0x0b, 0xf4);
				Send_Command(0x0b, 0xf4);
				Send_Command(0x0b, 0xf4);
				DelayLoop(90000000);

				Send_Command(0x0b, 0xf4);
				Send_Command(0x0b, 0xf4);
				Send_Command(0x0b, 0xf4);
				DelayLoop(90000000);

				

				//허들넘기
				printf("Huddle\n");
				Send_Command(0x29, 0xd6);
				Send_Command(0x29, 0xd6);
				Send_Command(0x29, 0xd6);
				DelayLoop(160000000);

				//왼쪽45 turn
				printf("Turn left 45\n");
				Send_Command(0x17, 0xe8);
				Send_Command(0x17, 0xe8);
				Send_Command(0x17, 0xe8);
				DelayLoop(30000000);
				Send_Command(0x17, 0xe8);
				Send_Command(0x17, 0xe8);
				Send_Command(0x17, 0xe8);
				DelayLoop(30000000);
				
				stage++;
				goto OUTLINE;
			}

			/////////////////////////////////////////////////////////////////
			
			///////////////////// 4번째,7번째 장애물 /////////////////////////////
			else if (stage == 4)
			{
			
				/*
				printf("go left\n");
				Send_Command(0x1b, 0xe4);
				Send_Command(0x1b, 0xe4);
				Send_Command(0x1b, 0xe4);
				DelayLoop(50000000);

				printf("go right\n");
				Send_Command(0x19, 0xe6);
				Send_Command(0x19, 0xe6);
				Send_Command(0x19, 0xe6);
				DelayLoop(50000000);
				*/

				Send_Command(0x45, 0xba);
				Send_Command(0x45, 0xba);
				Send_Command(0x45, 0xba);
				DelayLoop(160000000);
			
				
				stage++;
				goto OUTLINE;

			}

			///////////////////////////////////////////////////////////////

			/////////////////////// 5번째 장애물 /////////////////////////////
			//걸어오고있다.
			else if (stage == 5)
			{
				first_out = 1;
				for (i = 0; i < 120; i++)
					for (j = 0; j < 180; j++){
						if (((int)*(red + i * 180 + j) >20) && ((int)*(green + i * 180 + j) >20) && ((int)*(blue + i * 180 + j) > 20)
							&& ((int)*(v_compare + i * 180 + j) > 22))
							*(xxx + i * 180 + j) = 1;//흰색을표시

						else if (((int)*(red + i * 180 + j) < 10) && ((int)*(green + i * 180 + j) < 10) && ((int)*(blue + i * 180 + j) < 10)
							&& ((int)*(v_compare + i * 180 + j) < 10))
							*(xxx + i * 180 + j) = 2;//검정을표시

						else if ((*(red + i * 180 + j) < *(green + i * 180 + j)) && (*(blue + i * 180 + j) < *(green + i * 180 + j))
							&& ((int)*(hue_joon + i * 180 + j) > 120) && ((int)*(hue_joon + i * 180 + j) < 170))
							*(xxx + i * 180 + j) = 5;//초록을표시
						else
							*(xxx + i * 180 + j) = 3;
					}

				//초록계단 장애물
				cnt4_green = 0, cnt_st4 = 0;
				cnt4 = 0, cnt4_b_w = 0;
				st4_av_i = 0, st4_sum_i = 0;
				green4_l = 0, green4_r = 0;
				st4_left = 0, st4_right = 0;
				
			
				if (motion4 == 0)
				{
					for (i = 0; i < 120; i++)
						for (j = 0; j < 180; j++){
							*(lcd + 180 * i + j) = 0x0000;
							if (*(xxx + 180 * i + j) == 5)
							{
								*(lcd + 180 * i + j) = 0x000f;
								//*(st4_green + cnt4) = i;
								st4_sum_i += i;
								cnt4++;
							}
						}
					draw_img_from_buffer(fpga_videodata, 0, 18, 0, 0, 1.77, 0);
					draw_img_from_buffer(lcd, 0, 250, 0, 0, 1.77, 0);
					flip();

					//for (i = 0; i < cnt4; i++)
					//st4_sum_i += *(st4_green + i);

					st4_av_i = st4_sum_i / (cnt4 + 1);

					printf("st4_av_i=%d\n", st4_av_i);
					printf("cnt_st4=%d cnt4=%d\n", cnt_st4, cnt4);

					if (st4_av_i > 55 && cnt4 > 5)
					{
						printf("Eureka!!\n");
						Send_Command(0x0b, 0xf4);
						Send_Command(0x0b, 0xf4);
						Send_Command(0x0b, 0xf4);
						DelayLoop(90000000);
						Send_Command(0x0b, 0xf4);
						Send_Command(0x0b, 0xf4);
						Send_Command(0x0b, 0xf4);
						DelayLoop(90000000);


						//총총걸음 한 10걸음? 하다가 계단오르기!!!!! 로직으로
						motion4 = 1;
						goto GOUP;
					}

					else
					{
						Send_Command(0x0a, 0xf5);
						Send_Command(0x0a, 0xf5);
						Send_Command(0x0a, 0xf5);
						DelayLoop(42000000);
						printf("no!\n");

						goto GOUP;
					}
				}


				else if (motion4 == 1) // 올라가기 직전에 평행맞추기
				{
					for (i = 60; i < 110; i++) // 초록색에서 균형잡기
						for (j = 0; j < 180; j++)
							if (*(xxx + 180 * i + j) == 5)
							{
								*(lcd + 180 * i + j) = 0xf000;
								if (j < 87)
									st4_left++;
								else
									st4_right++;
							}

					draw_img_from_buffer(fpga_videodata, 0, 18, 0, 0, 1.77, 0);
					draw_img_from_buffer(lcd, 0, 250, 0, 0, 1.77, 0);
					flip();
					printf("left : %d right : %d\n", st4_left, st4_right);
					if (st4_left > st4_right + 600)
					{
						Send_Command(0x1a, 0xe5);
						Send_Command(0x1a, 0xe5);
						Send_Command(0x1a, 0xe5);
						DelayLoop(20000000);
						motion4 = 1;
						goto GOUP;
					}
					else if (st4_right > st4_left + 600)
					{
						Send_Command(0x18, 0xe7);
						Send_Command(0x18, 0xe7);
						Send_Command(0x18, 0xe7);
						DelayLoop(20000000);
						motion4 = 1;
						goto GOUP;
					}
					else
					{
						motion4 = 2;
						goto GOUP;
					}
				}

				else if (motion4 == 2)
				{
					Send_Command(0x0b, 0xf4);
					Send_Command(0x0b, 0xf4);
					Send_Command(0x0b, 0xf4);
					DelayLoop(100000000);
					printf("up stairs\n");
					Send_Command(0x2a, 0xd5);
					Send_Command(0x2a, 0xd5);
					Send_Command(0x2a, 0xd5);//오르기
					DelayLoop(170000000);

					Send_Command(0x04, 0xfb);
					Send_Command(0x04, 0xfb);
					Send_Command(0x04, 0xfb);
					DelayLoop(110000000);



					motion4 = 3;
					goto GOUP;
				}

				else if (motion4 == 3)//올라간상태 총총걸음
				{

					for (i = 0; i < 60; i++)
						for (j = 10; j < 170; j++)
							if (*(xxx + 180 * i + j) == 5)
								cnt4_green++;

					if (cnt4_green < 800)
					{
						motion4 = 4;
						goto GOUP;
					}

					for (i = 0; i < 120; i++)
						for (j = 0; j < 180; j++){
							*(lcd + 180 * i + j) = 0x0000;
							if (*(xxx + 180 * i + j) == 5)
							{
								*(lcd + 180 * i + j) = 0x000f;
								
							}
						}
					draw_img_from_buffer(fpga_videodata, 0, 18, 0, 0, 1.77, 0);
					draw_img_from_buffer(lcd, 0, 250, 0, 0, 1.77, 0);
					flip();
					int st4_cen = 0, st4_up = 0, st4_down = 0;
					int green_cnt = 0;

					for (j = 90; j >= 0; j--)
					{
						if (*(lcd + 180 * 60 + j) != 0x000f)
						{
							st4_cen = j;
							st4_down = j;
							break;
						}
					}

					for (j = 90; j >= 0; j--)
					{
						if (*(lcd + 180 * 45 + j) != 0x000f)
						{
							st4_up = j;
							break;
						}
					}

					if (st4_cen < 32)//왼쪽 바꿀때 37
					{
						Send_Command(0x25, 0xda);
						Send_Command(0x25, 0xda);
						Send_Command(0x25, 0xda);
						DelayLoop(31000000);
					}
					else if (st4_cen > 44)//오른쪽 바꿀때 51
					{
						Send_Command(0x23, 0xdc);
						Send_Command(0x23, 0xdc);
						Send_Command(0x23, 0xdc);
						DelayLoop(31000000);
					}
					else
						green_cnt++;

					if (st4_up - st4_down >= 2)
					{
						Send_Command(0x1c, 0xe3);
						Send_Command(0x1c, 0xe3);
						Send_Command(0x1c, 0xe3);
						DelayLoop(22000000);
					}
					else if (st4_down - st4_up >= 2)
					{
						Send_Command(0x1f, 0xe0);
						Send_Command(0x1f, 0xe0);
						Send_Command(0x1f, 0xe0);
						DelayLoop(22000000);
					}
					else
						green_cnt++;

					if (green_cnt == 2)
					{
						Send_Command(0x0b, 0xf4);
						Send_Command(0x0b, 0xf4);
						Send_Command(0x0b, 0xf4);
						DelayLoop(90000000);
						Send_Command(0x02, 0xfd);
						Send_Command(0x02, 0xfd);
						Send_Command(0x02, 0xfd);
						DelayLoop(30000000);

						goto GOUP;
					}
					else
						goto GOUP;


				}
				else if (motion4 == 4)
				{//마지막 계단 내려가기 전에 평행맞추기

					if (plus_b == 0)
					{
						Send_Command(0x0b, 0xf4);
						Send_Command(0x0b, 0xf4);
						Send_Command(0x0b, 0xf4);
						DelayLoop(90000000);
						Send_Command(0x02, 0xfd);
						Send_Command(0x02, 0xfd);
						Send_Command(0x02, 0xfd);
						DelayLoop(30000000);

						plus_b++;
						goto GOUP;
					}
					for (i = 0; i < 70; i++)
						for (j = 10; j < 170; j++)
							if (*(xxx + 180 * i + j) == 5)
								cnt4_green++;

					cnt_st4 = 0;
					int st4_l = 0, st4_r = 0;
					for (i = 0; i < 60; i++)
						for (j = 40; j < 140; j++)
							if (*(xxx + 180 * i + j) == 2)
								cnt_st4++;

					if (cnt_st4 < 120)
					{
						motion4 = 5;
						goto GOUP;
					}

					if (cnt4_green < 50)
					{
						for (j = 69; j < 111; j++)
						for (i = 60; i >0; i--)
							if (*(xxx + 180 * i + j) == 2)
									if ((*(xxx + 180 * i + j) + *(xxx + 180 * (i - 1) + j + 1) == 3)
										|| (*(xxx + 180 * i + j) + *(xxx + 180 * (i - 1) + j) == 3)
										|| (*(xxx + 180 * i + j) + *(xxx + 180 * (i - 1) + j - 1) == 3))
									{
										
										
										*(lcd + 180 * i + j) = 0xf000;
										break;

									}
						draw_img_from_buffer(fpga_videodata, 0, 18, 0, 0, 1.77, 0);
						draw_img_from_buffer(lcd, 0, 250, 0, 0, 1.77, 0);
						flip();

						for (i = 60; i > 0; i--)
						{
							if (*(lcd + 180 * i + 75) == 0xf000)
							{
								st4_l = i;
								break;
							}	
						}

						for (i = 60; i > 0; i--)
						{
							if (*(lcd + 180 * i + 105) == 0xf000)
							{
								st4_r = i;
								break;
							}
						}

						if (st4_l - st4_r >= 3)
						{
							Send_Command(0x1f, 0xe0);
							Send_Command(0x1f, 0xe0);
							Send_Command(0x1f, 0xe0);
							DelayLoop(40000000);
						}
						else if (st4_r - st4_l >= 3)
						{

							Send_Command(0x1c, 0xe3);
							Send_Command(0x1c, 0xe3);
							Send_Command(0x1c, 0xe3);
							DelayLoop(40000000);

						}
						else
						{
							Send_Command(0x41, 0xbe);
							Send_Command(0x41, 0xbe);
							Send_Command(0x41, 0xbe);
							DelayLoop(50000000);

						}

						
					}
					else
					{
						Send_Command(0x41, 0xbe);
						Send_Command(0x41, 0xbe);
						Send_Command(0x41, 0xbe);
						DelayLoop(50000000);

					}
					goto GOUP;
				}

				else if (motion4 == 5)
				{
					cnt_st4 = 0;
					for (i = 0; i < 60; i++)
						for (j = 40; j < 140; j++)
							if (*(xxx + 180 * i + j) == 2)
								cnt_st4++;

					printf("black : %d\n", cnt_st4);

					if (cnt_st4 < 200){
						printf("Down stairs\n");
						DelayLoop(50000000);
						Send_Command(0x2b, 0xd4);
						Send_Command(0x2b, 0xd4);
						Send_Command(0x2b, 0xd4);//내리기
						DelayLoop(240000000);

						printf("Stage Clear!!\n");
						Send_Command(0x0d, 0xf2);
						Send_Command(0x0d, 0xf2);
						Send_Command(0x0d, 0xf2);
						DelayLoop(200000000);//달리기

						stage = 15;
						goto OUTLINE;
					}

					else{
						Send_Command(0x41, 0xbe);
						Send_Command(0x41, 0xbe);
						Send_Command(0x41, 0xbe);
						DelayLoop(50000000);

						goto GOUP;
					}

				}

			}
			//////////////////////////////////////////////////////////

			else if (stage == 15)
			{
				
				printf("go left\n");
				Send_Command(0x1b, 0xe4);
				Send_Command(0x1b, 0xe4);
				Send_Command(0x1b, 0xe4);
				DelayLoop(50000000);
				/*
				printf("go right\n");
				Send_Command(0x19, 0xe6);
				Send_Command(0x19, 0xe6);
				Send_Command(0x19, 0xe6);
				DelayLoop(50000000);
				*/

				stage = 6;
				goto GOUP;
			}

			////////////////////////6번째 장애물///////////////////////
			else if (stage == 6)
			{
				if (cnt_2 == 3)
				{
					motion5 = 6;
					cnt_2++;
				}
				//골프공
				for (i = 0; i < 120; i++)
				{
					for (j = 0; j < 180; j++)
					{
						//*(lcd + i * 180 + j) = *(fpga_videodata + i * 180 + j);

						if (((int)*(red + i * 180 + j)>25) && ((int)*(blue + i * 180 + j) <= 15) && (((int)*(hue_joon + i * 180 + j) > 300) || ((int)*(hue_joon + i * 180 + j) < 60)) && (int)*(satur_tmp + i*180+j)>80)
							*(xxx + i * 180 + j) = 1;//공을표시

						else if (((int)*(blue + i * 180 + j) > 20) && ((int)*(red + i * 180 + j) < 15) && ((int)*(green + i * 180 + j) < 15) && ((int)*(hue_joon + i * 180 + j) > 190) && ((int)*(hue_joon + i * 180 + j) < 250) && (*(v_compare + i * 180 + j) > 5))
							*(xxx + i * 180 + j) = 2;//구멍표시
						else
							*(xxx + i * 180 + j) = 3;//다른거
					}
				}

				int cnt5 = 0;
				for (i = 20; i < 90; i++)
				{
					for (j = 0; j < 180; j++)
					{
						
						if (*(xxx + i * 180 + j) == 2)
						{
							*(lcd + i * 180 + j) = 0x000f;
							cnt5++;
						}
						else
							*(lcd + i * 180 + j) = 0xffff;
					}
					*(blue_cnt + i) = cnt5;
					cnt5 = 0;
				}

				for (i = 0; i < 120; i++)
				{
					for (j = 0; j < 180; j++)
					{
						if (*(xxx + i * 180 + j) == 1)
						{
							*(lcd + i * 180 + j) = 0xf000;
						}
					}
				}

				int bluecnt = 0, blue_i = 0;
				for (i = 0; i < 120; i++)
				{
					if (*(blue_cnt + i) > bluecnt)
					{
						bluecnt = *(blue_cnt + i);
						blue_i = i;
					}
				}

				printf("many blue=%d\n", blue_i);

				int cntblue = 0;
				for (j = 0; j < 180; j++)
				{
					if (*(lcd + blue_i * 180 + j) == 0x000f)
					{
						*(hole_j + cntblue) = j;
						cntblue++;
					}
				}

				hole_j_left = 180, hole_j_right = 0;

				for (j = 0; j < cntblue; j++)
				{
					if (*(hole_j + j) < hole_j_left)
						hole_j_left = *(hole_j + j);

					if (*(hole_j + j) > hole_j_right)
						hole_j_right = *(hole_j + j);
				}


				cnt_ball = 0;

				for (i = 0; i < 120; i++)
				{
					for (j = 0; j < 180; j++)
					{
						if (*(lcd + i * 180 + j) == 0xf000)
						{
							*(ball_i + cnt_ball) = i;
							*(ball_j + cnt_ball) = j;
							cnt_ball++;
						}

					}
				}

				ball_i_top = 120, ball_i_bot = 0, ball_j_left = 180, ball_j_right = 0;



				for (i = 0; i < cnt_ball; i++)
				{
					if (*(ball_i + i) < ball_i_top)
						ball_i_top = *(ball_i + i);

					if (*(ball_j + i) < ball_j_left)
						ball_j_left = *(ball_j + i);

					if (*(ball_i + i) > ball_i_bot)
						ball_i_bot = *(ball_i + i);

					if (*(ball_j + i) > ball_j_right)
						ball_j_right = *(ball_j + i);

				}



				printf("hole_j_left=%d  ", hole_j_left);
				printf("hole_j_right=%d\n", hole_j_right);


				hole_j_cen = (hole_j_left + hole_j_right) / 2;
				ball_i_cen = (ball_i_top + ball_i_bot) / 2, ball_j_cen = (ball_j_left + ball_j_right) / 2;

				printf("hole cen=%d  ", hole_j_cen);
				printf("ball cen=(%d,%d)\n\n", ball_i_cen, ball_j_cen);

				for (i = 0; i < 120; i++)
				{
					*(lcd + 180 * i + hole_j_cen) = 0x0000;
				}

				*(lcd + (ball_i_cen - 1) * 180 + (ball_j_cen)) = 0x0000;
				*(lcd + (ball_i_cen)* 180 + (ball_j_cen)) = 0x0000;
				*(lcd + (ball_i_cen + 1) * 180 + (ball_j_cen)) = 0x0000;
				*(lcd + (ball_i_cen)* 180 + (ball_j_cen - 1)) = 0x0000;
				*(lcd + (ball_i_cen)* 180 + (ball_j_cen)) = 0x0000;
				*(lcd + (ball_i_cen)* 180 + (ball_j_cen + 1)) = 0x0000;

				draw_img_from_buffer(fpga_videodata, 0, 18, 0, 0, 1.77, 0);
				draw_img_from_buffer(lcd, 0, 250, 0, 0, 1.77, 0);
				flip();

				if (motion5 == 0)
				{
					printf("find ball\n");
					if (ball_i_cen < 100)
					{
						Send_Command(0x0a, 0xf5);
						Send_Command(0x0a, 0xf5);
						Send_Command(0x0a, 0xf5);
						DelayLoop(32000000);
					}
					else
					{
						Send_Command(0x3d, 0xc2);
						Send_Command(0x3d, 0xc2);
						Send_Command(0x3d, 0xc2);
						DelayLoop(30000000);
						motion5 = 1;
					}

					goto GOUP;
				}

				else if (motion5 == 1)
				{
					if (ball_i_cen < 100)
					{
						Send_Command(0x40, 0xbf);
						Send_Command(0x40, 0xbf);
						Send_Command(0x40, 0xbf);
						DelayLoop(32000000);
					}
					else
					{
						if (ball_j_cen < 69 )
						{
							printf("go left\n");
							Send_Command(0x3e, 0xc1);
							Send_Command(0x3e, 0xc1);
							Send_Command(0x3e, 0xc1);
							DelayLoop(30000000);
						}

						else if (ball_j_cen > 80)
						{
							printf("go right\n");
							Send_Command(0x3f, 0xc0);
							Send_Command(0x3f, 0xc0);
							Send_Command(0x3f, 0xc0);
							DelayLoop(30000000);
						}
						else
						{
							Send_Command(0x02, 0xfd);
							Send_Command(0x02, 0xfd);
							Send_Command(0x02, 0xfd);
							DelayLoop(30000000);
							motion5 = 3;
						}
						goto GOUP;
						
					}
					goto GOUP;
				}
				/*
				else if (motion5 == 2)
				{
					if (hole_j_cen < 78)
					{
						printf("turn left\n");
						Send_Command(0x15, 0xea);
						Send_Command(0x15, 0xea);
						Send_Command(0x15, 0xea);
						DelayLoop(40000000);
					}
					else if (hole_j_cen > 86)
					{
						printf("turn right\n");
						Send_Command(0x12, 0xed);
						Send_Command(0x12, 0xed);
						Send_Command(0x12, 0xed);
						DelayLoop(40000000);

					}
					else
					{
						motion5 = 3;
						Send_Command(0x02, 0xfd);
						Send_Command(0x02, 0xfd);
						Send_Command(0x02, 0xfd);
						DelayLoop(30000000);
					}
					goto GOUP;
				}
				*/

				else if (motion5 == 3)
				{
					printf("find ball!!\n");
					if (ball_i_cen < 38)
					{/*
						Send_Command(0x08, 0xf7);
						Send_Command(0x08, 0xf7);
						Send_Command(0x08, 0xf7);
						DelayLoop(43000000);
						*/
						Send_Command(0x42, 0xbd);
						Send_Command(0x42, 0xbd);
						Send_Command(0x42, 0xbd);
						DelayLoop(26000000);
					}

					else
					{
						motion5 = 4;
						Send_Command(0x01, 0xfe);
						Send_Command(0x01, 0xfe);
						Send_Command(0x01, 0xfe);
						DelayLoop(40000000);
					}
					goto GOUP;
				}

				else if (motion5 == 4)
				{
					if (hole_j_cen < 80)
					{
						printf("turn left\n");
						Send_Command(0x15, 0xea);
						Send_Command(0x15, 0xea);
						Send_Command(0x15, 0xea);
						DelayLoop(40000000);
					}
					else if (hole_j_cen > 87)
					{
						printf("turn right\n");
						Send_Command(0x12, 0xed);
						Send_Command(0x12, 0xed);
						Send_Command(0x12, 0xed);
						DelayLoop(40000000);

					}
					else
					{
						motion5 = 5;
						Send_Command(0x02, 0xfd);
						Send_Command(0x02, 0xfd);
						Send_Command(0x02, 0xfd);
						DelayLoop(30000000);
					}
					goto GOUP;
				}

				else if (motion5 == 5)
				{
					int ball_cnt = 0;
					for (i = 0; i < 120; i++)
						for (j = 0; j < 180; j++)
						{
							if (*(xxx + 180 * i + j) == 1)
								ball_cnt++;
						}

					if (ball_cnt < 15)
					{
						motion5 = 7;
						goto GOUP;
					}

					if (ball_i_cen < 38)
					{
						Send_Command(0x42, 0xbd);
						Send_Command(0x42, 0xbd);
						Send_Command(0x42, 0xbd);
						DelayLoop(26000000);
						goto GOUP;
					}
					printf("find ball center\n");
					if (ball_j_cen < 65 && ball_j_cen >= 40)
					{
						printf("go left\n");
						Send_Command(0x30, 0xcf);
						Send_Command(0x30, 0xcf);
						Send_Command(0x30, 0xcf);
						DelayLoop(60000000);
					}
					else if (ball_j_cen < 40)
					{
						Send_Command(0x24, 0xdb);
						Send_Command(0x24, 0xdb);
						Send_Command(0x24, 0xdb);
						DelayLoop(40000000);
					}
					else if (ball_j_cen > 70 && ball_j_cen <= 95)
					{
						printf("go right\n");
						Send_Command(0x2f, 0xd0);
						Send_Command(0x2f, 0xd0);
						Send_Command(0x2f, 0xd0);
						DelayLoop(60000000);
					}
					else if (ball_j_cen > 95)
					{
						printf("go right\n");
						Send_Command(0x22, 0xdd);
						Send_Command(0x22, 0xdd);
						Send_Command(0x22, 0xdd);
						DelayLoop(40000000);
					}
					else
					{
						Send_Command(0x01, 0xfe);
						Send_Command(0x01, 0xfe);
						Send_Command(0x01, 0xfe);
						DelayLoop(10000000);
						motion5 = 4;
						cnt_2++;
					}

					goto GOUP;
				}

				

				else if (motion5 == 6)
				{
					
						printf("kick\n");
						Send_Command(0x2c, 0xd3);
						Send_Command(0x2c, 0xd3);
						Send_Command(0x2c, 0xd3);
						DelayLoop(100000000);
						motion5 = 7;
					
					goto GOUP;
				}

				

				else if (motion5 == 7)
				{
					printf("Turn1\n");
					Send_Command(0x0a, 0xf5);
					Send_Command(0x0a, 0xf5);
					Send_Command(0x0a, 0xf5);
					DelayLoop(32000000);
					Send_Command(0x0a, 0xf5);
					Send_Command(0x0a, 0xf5);
					Send_Command(0x0a, 0xf5);
					DelayLoop(32000000);
					Send_Command(0x17, 0xe8);
					Send_Command(0x17, 0xe8);
					Send_Command(0x17, 0xe8);
					DelayLoop(30000000);
					Send_Command(0x17, 0xe8);
					Send_Command(0x17, 0xe8);
					Send_Command(0x17, 0xe8);
					DelayLoop(30000000);
					Send_Command(0x04, 0xfb);
					Send_Command(0x04, 0xfb);
					Send_Command(0x04, 0xfb);
					DelayLoop(110000000);

					stage++;
					goto OUTLINE;
				}
			}
			//////////////////////////////////////////////////////////

		   else if (stage == 7)
		   {

			   /*
			   printf("go left\n");
			   Send_Command(0x1b, 0xe4);
			   Send_Command(0x1b, 0xe4);
			   Send_Command(0x1b, 0xe4);
			   DelayLoop(50000000);

			   printf("go right\n");
			   Send_Command(0x19, 0xe6);
			   Send_Command(0x19, 0xe6);
			   Send_Command(0x19, 0xe6);
			   DelayLoop(50000000);
			   */

			   Send_Command(0x0d, 0xf2);
			   Send_Command(0x0d, 0xf2);
			   Send_Command(0x0d, 0xf2);
			   DelayLoop(200000000);
			 
			   stage++;
			   goto OUTLINE;


		   }

			///////////////////////////////////////////////////////////////////

			

			//////////////////////////8번재 장애물//////////////////////////
			else if (stage == 8)
			{
				//노란함정
				//printf("stage 8 start!\n");
				for (i = 0; i < 120; i++)
					for (j = 0; j < 180; j++)
					{
						if (((int)*(red + i * 180 + j) >20) && ((int)*(green + i * 180 + j) >20) && ((int)*(blue + i * 180 + j) > 20)
							&& ((int)*(v_compare + i * 180 + j) > 22))
							*(xxx + i * 180 + j) = 1;//흰색을표시

						else if (((int)*(red + i * 180 + j) < 10) && ((int)*(green + i * 180 + j) < 10) && ((int)*(blue + i * 180 + j) < 10)
							&& ((int)*(v_compare + i * 180 + j) < 10))
							*(xxx + i * 180 + j) = 2;//검정을표시


						else if ((*(red + i * 180 + j) < *(blue + i * 180 + j)) && (*(green + i * 180 + j) < *(blue + i * 180 + j))
							&& ((int)*(hue_joon + i * 180 + j) > 180) && ((int)*(hue_joon + i * 180 + j) < 250) && *(satur_tmp + i * 180 + j) > 30 && ((int)*(v_compare + i * 180 + j) < 20))
							*(xxx + i * 180 + j) = 6;//파랑을표시

						else
							*(xxx + i * 180 + j) = 7;//나머지
					}
				cnt8_3 = 0, cnt8_4 = 0;


				/*
				for (j = 30; j < 140; j++)
				{
					*(lcd + 180 * 70 + j) = 0xf000;
					*(lcd + 180 * 90 + j) = 0xf000;
				}

				for (i = 70; i < 90; i++)
				{
					*(lcd + 180 * i + 85) = 0x000f;
				}
				*/
				draw_img_from_buffer(fpga_videodata, 0, 18, 0, 0, 1.77, 0);
				draw_img_from_buffer(lcd, 0, 250, 0, 0, 1.77, 0);
				flip();

				if (motion8 == 0)
				{
					printf("go up!\n");

				
					Send_Command(0x0b, 0xf4);
					Send_Command(0x0b, 0xf4);
					Send_Command(0x0b, 0xf4);
					DelayLoop(90000000);

					

					Send_Command(0x0b, 0xf4); //오르기 전 계단과 평행 맞추기
					Send_Command(0x0b, 0xf4);
					Send_Command(0x0b, 0xf4);
					DelayLoop(90000000);

					Send_Command(0x0b, 0xf4); //오르기 전 계단과 평행 맞추기
					Send_Command(0x0b, 0xf4);
					Send_Command(0x0b, 0xf4);
					DelayLoop(90000000);


					motion8 = 2;
					outst8 = 1;
					goto OUT_st8;
				}

				else if (motion8 == 1)
				{
					/*
					for (i = 89; i > 84; i--)
					{
						for (j = 26; j < 83; j++)
						{
							if (*(xxx + i * 180 + j) == 2 || *(xxx + i * 180 + j) == 6)
							{
								cnt8_3++;
								//*(lcd + 180 * i + j) = 0xf000;
							}
						}

						for (j = 83; j < 158; j++)
						{
							{
								if (*(xxx + i * 180 + j) == 2 || *(xxx + i * 180 + j) == 6)
								{
									cnt8_4++;
									//*(lcd + 180 * i + j) = 0x000f;
								}
							}
						}
					}

					
					draw_img_from_buffer(fpga_videodata, 0, 18, 0, 0, 1.77, 0);
					draw_img_from_buffer(lcd, 0, 250, 0, 0, 1.77, 0);
					flip();
					

					printf("left black=%d\n", cnt8_3);
					printf("right black=%d\n\n", cnt8_4);
					
					if (cnt8_3 - cnt8_4>35)
					{
						Send_Command(0x34, 0xcb);
						Send_Command(0x34, 0xcb);
						Send_Command(0x34, 0xcb);
						DelayLoop(35000000);
					}
					else if (cnt8_4 - cnt8_3 > 35)
					{
						Send_Command(0x35, 0xca);
						Send_Command(0x35, 0xca);
						Send_Command(0x35, 0xca);
						DelayLoop(35000000);
					}

					else
					{
						motion8 = 2;
					}
					
					*/

					goto GOUP;

				}

				else if (motion8 == 2)
				{
					Send_Command(0x0b, 0xf4);
					Send_Command(0x0b, 0xf4);
					Send_Command(0x0b, 0xf4);
					DelayLoop(90000000);
					Send_Command(0x0b, 0xf4);
					Send_Command(0x0b, 0xf4);
					Send_Command(0x0b, 0xf4);
					DelayLoop(90000000);
					Send_Command(0x2a, 0xd5); //오르기
					Send_Command(0x2a, 0xd5);
					Send_Command(0x2a, 0xd5);
					DelayLoop(190000000);
					

					motion8 = 3;
					goto GOUP;
				}
				else if (motion8 == 3)
				{
					for (i = 0; i < 120; i++)
					{
						*(lcd + 180 * i + 77) = 0xf000;
						*(lcd + 180 * i + 97) = 0xf000;
					}

					i_left = 0, i_right = 0, i_cen = 0;
					cnt = 0;
					int n = 1;

					Mask[0] = -1.0f; Mask[1] = -1.0f; Mask[2] = -1.0f;
					Mask[3] = 0.0f; Mask[4] = 0.0f; Mask[5] = 0.0f;
					Mask[6] = 1.0f; Mask[7] = 1.0f; Mask[8] = 1.0f;

					for (i = 120 - n; i > n; i--){
						index1 = i * 180;
						for (j = 180 - n; j > n; j--){
							float sum1 = 0.0f;

							for (k = -n; k <= n; k++)
							{
								index2 = (i + k) * 180;
								index3 = (k + n) * 3;
								for (l = -n; l <= n; l++)
									sum1 += gray[index2 + (j + l)] * Mask[index3 + l + n];
							}

							if (sum1 > 65530)
								*(lcd + i * 180 + j) = 0xffff;

							else
								*(lcd + i * 180 + j) = 0x0000;

						}
					}
					draw_img_from_buffer(fpga_videodata, 0, 18, 0, 0, 1.77, 0);
					draw_img_from_buffer(lcd, 0, 250, 0, 0, 1.77, 0);
					flip();
					/////////////////////////////////////////////////////////

					for (i = 120; i >= 0; i--)
					{
						if (*(lcd + 180 * i + 77) == 0xffff)
						{
							i_left = i;
							break;
						}
					}


					for (i = 120; i >= 0; i--)
					{
						if (*(lcd + 180 * i + 97) == 0xffff)
						{
							i_right = i;
							break;
						}
					}
					printf("i_left=%d\n", i_left);
					printf("i_right=%d\n\n", i_right);
					
					if (i_left - i_right >= 2)
					{
						printf("left turn\n");
						Send_Command(0x15, 0xea);//왼쪽턴
						Send_Command(0x15, 0xea);//왼쪽턴
						Send_Command(0x15, 0xea);//왼쪽턴
						DelayLoop(22000000);
					}

					

					else if (i_right - i_left >= 2)
					{
						printf("right turn\n");
						Send_Command(0x12, 0xed);//오른쪽턴
						Send_Command(0x12, 0xed);//오른쪽턴
						Send_Command(0x12, 0xed);//오른쪽턴
						DelayLoop(22000000);
					}
					else
					{
						motion8 = 4;
					}
					goto GOUP;


				}

				else if (motion8 == 4)

				{
					Send_Command(0x36, 0xc9);
					Send_Command(0x36, 0xc9);
					Send_Command(0x36, 0xc9);
					DelayLoop(175000000);
					Send_Command(0x33, 0xcc);
					Send_Command(0x33, 0xcc);
					Send_Command(0x33, 0xcc);
					DelayLoop(200000000);

					stage=9;
					goto OUTLINE;
				}



			}



			/////////////////////////////////////////////////////////////

			////////////////////////9번째장애물/////////////////////////////////
			else if (stage == 9)
			{
				//첫번째 바리케이트
				printf("stage=%d\n", stage);
				cnt2 = 0;
				for (i = 25; i < 50; i++)
				{
					for (j = 60; j < 120; j++)
					{
						*(lcd + 180 * i + j) = 0x0000;
						//검정
						if (((int)*(red + i * 180 + j) < 10) && ((int)*(green + i * 180 + j) < 10) && ((int)*(blue + i * 180 + j) < 10) && ((int)*(v_compare + i * 180 + j) < 10))
						{
							cnt2++;
							*(lcd + 180 * i + j) = 0xf000;
						}

					}
				}
				draw_img_from_buffer(fpga_videodata, 0, 18, 0, 0, 1.77, 0);
				draw_img_from_buffer(lcd, 0, 250, 0, 0, 1.77, 0);
				flip();

				printf("cnt2=%d\n", cnt2);

			

				if (motion7 == 0)
				{
					Send_Command(0x03, 0xfc);
					Send_Command(0x03, 0xfc);
					Send_Command(0x03, 0xfc);
					DelayLoop(150000000);
					
					motion7 = 1;
					goto GOUP;
				}

				else if (motion7 == 1)
				{
					printf("STOP and Wait\n");
					Send_Command(0x01, 0xfe);
					Send_Command(0x01, 0xfe);
					Send_Command(0x01, 0xfe);
					DelayLoop(10000000);
					if (cnt2 > 250)
						motion7 = 2;//멈춰
					goto GOUP;
				}

				else if (motion7 == 2)
				{
					printf("STOP!!!!!!!!!!!!!!\n");
					Send_Command(0x01, 0xfe);
					Send_Command(0x01, 0xfe);
					Send_Command(0x01, 0xfe);
					DelayLoop(10000000);
					if (cnt2 < 250)
						motion7 = 3;//가
					goto GOUP;
				}

				else if (motion7 == 3)
				{
					printf("GOGOGOGOGO!!!!!!!!!!!\n");

					Send_Command(0x0d, 0xf2);
					Send_Command(0x0d, 0xf2);
					Send_Command(0x0d, 0xf2);
					DelayLoop(160000000);
					Send_Command(0x0d, 0xf2);
					Send_Command(0x0d, 0xf2);
					Send_Command(0x0d, 0xf2);
					DelayLoop(160000000);
					printf("done\n");
					

				}
			}
			


		}

	}

	free(fpga_videodata);
	free(lcd);

	free(hue_joon);
	free(satur_tmp);
	free(v_compare);

	free(red);
	free(green);
	free(blue);

	free(xxx);
	free(out_i);
	free(out_j);
	free(st4_green);
	free(st6_red);
	free(blue_cnt);
	free(hole_j);
	free(ball_i);
	free(ball_j);
	uart_close();
	if (bmpsurf != 0)
		release_surface(bmpsurf);
	close_graphic();

	return 0;
}
