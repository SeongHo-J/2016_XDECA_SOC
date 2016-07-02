/************************************************************************
  Title     : Robot Body Protocol Source File
  File name : robot_protocol.c    

  Author    : adc inc. (oxyang@adc.co.kr)
  History
		+ v0.0  2007/2/14
		+ v1.0  2008/8/6
************************************************************************/
#include <stdio.h>
#include <string.h>
#include "robot_protocol.h"
#include "uart_api.h"
//////////////////////////////////////////////////// Protocol Test

void DelayLoop(int delay_time)
{
	while(delay_time)
		delay_time--;
}

void Send_Command(unsigned char command)
{
	int i;
	unsigned char Command_Buffer[1] = {0,};

	Command_Buffer[0] = command;	// Command Byte
	 	for(i=0; i<1; i++) printf("0x%x ",Command_Buffer[i]);

	uart1_buffer_write(Command_Buffer, 1);
}

#define ERROR 0
#define OK	1

/* Command Function */
void Hello()
{
	Send_Command(1);
		
	DelayLoop(15000000);		// 3second delay
	printf("\nHello Ok!\n");
}

void h_Forward_walk()
{
	Send_Command(2);

	DelayLoop(1000000);
	printf("\nHalf Forward walk Ok!\n");
}
void o_Forward_walk()
{
	Send_Command(3);

	DelayLoop(1000000);
	printf("\nOne Forward walk Ok!\n");
}

void t_Forward_walk()
{
	Send_Command(4);

	DelayLoop(1000000);
	printf("\nTwo Forward walk Ok!\n");
}
