#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <getopt.h>
#include <fcntl.h>
#include <unistd.h>

#include "uart_api.h"
#include "robot_protocol.h"


void Logo(void)
{
  	printf("\n\n");
  	printf("            *****************************************\n");
  	printf("              Welcome to Eagle Robot Platform Board \n");
  	printf("            *****************************************\n"); 
}

void PrintBannerRobot(void)
{
	printf("\n");
	printf("================================================================\n");
	printf("              <<<< Robot Body TEST Selection >>>>               \n");
	printf("----------------------------------------------------------------\n");
	printf("   1. Hello            -[a]   |  3. One Forward walk -[c] \n");
	printf("   2. Half Forward walk    -[b]   |  4. Two Forward walk   -[d] \n");
	printf("----------------------------------------------------------------\n");
	printf("   19. Quit            -[z]         \n");
	printf("================================================================\n");
	
}


int TestItemSelectRobot(void)
{
   char Item;
 	
	while(1) {
 		PrintBannerRobot();
		printf("\nSelected Test Item :  ");
 		Item = getchar();
		putchar(Item);

		switch(Item) {
			case 'a' : case 'A' : Hello();				break;
			case 'b' : case 'B' : h_Forward_walk();		break;
			case 'c' : case 'C' : o_Forward_walk();		break;
			case 'd' : case 'D' : t_Forward_walk();			break;
			case 'z' : case 'Z' : return 0;
			default : printf("\nNo Test Item Selected");	break;
		}
	}
	return 0;
}

#include <termios.h>
static struct termios inittio, newtio;

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
	int ret;

	init_console();

	ret = uart_open();
	if (ret < 0) return EXIT_FAILURE;

	uart_config(UART1, 9600, 8, UART_PARNONE, 1);

	Logo();
	TestItemSelectRobot();

	uart_close();

	return 0;
}


