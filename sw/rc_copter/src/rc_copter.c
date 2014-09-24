/*
 * Copyright (c) 2009-2012 Xilinx, Inc.  All rights reserved.
 *
 * Xilinx, Inc.
 * XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS" AS A
 * COURTESY TO YOU.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
 * ONE POSSIBLE   IMPLEMENTATION OF THIS FEATURE, APPLICATION OR
 * STANDARD, XILINX IS MAKING NO REPRESENTATION THAT THIS IMPLEMENTATION
 * IS FREE FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE RESPONSIBLE
 * FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE FOR YOUR IMPLEMENTATION.
 * XILINX EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH RESPECT TO
 * THE ADEQUACY OF THE IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO
 * ANY WARRANTIES OR REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
 * FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.
 *
 */

/*
 * rc_copter.c: file that manages the different control modes for the quad copter
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include <inttypes.h>
#include "ppm_register.h"
#include "platform.h"
#include "xil_types.h"
#include "xparameters.h"
#include "xil_io.h"

#define TESTING

/*optimization definitions*/
#define PLAYBACK_NUM_FRAMES 10000
#define PLAYBACK_FRAME_SKIP 0

/*button and switch definitions*/
#define SW0 0x80
#define SW1 0x00
#define SW2 0x00
#define SW3 0x00
#define SW4 0x00

#define BTNU 0x10
#define BTNR 0x08
#define BTNC 0x06
#define BTNL 0x04
#define BTND 0x02

//structure for maintaining the different modes of operation
typedef struct MODE_STRUCT
{
	unsigned relayMode				: 1;		//hardware/software relay mode (1 for software relay mode and 0 for hardware relay mode)
	unsigned softwareDebugMode		: 1;		//1 for software debug mode and 0 for no software debug mode (printed over uart)
	unsigned softwareRecordMode		: 1;		//1 for software record mode and 0 for no software record mode
	unsigned softwarePlayMode		: 1;		//1 for software play mode and 0 for no software play mode
	unsigned softwareFilterMode		: 1;		//1 for software filter mode and 0 for no software filter mode
} softwareMode;

//frame structure
typedef struct FRAME_STRUCT
{

}frame;

/*global variables*/

softwareMode mode;
frame playbackBuffer[PLAYBACK_NUM_FRAMES];

/*end global variables*/

/*prototypes*/

//sets the mode to hardware relay mode (will turn software relay mode off)
void setHardwareRelayMode();

//sets the mode to software relay mode (will turn hardware relay mode off)
void setSoftwareRelayMode();

//prints out changes to capture and generate fsm states
void fsmCheck();

/*end prototypes*/
#ifdef TESTING
#ifndef XPAR_BTNS_5BITS_BASEADDR
#define XPAR_BTNS_5BITS_BASEADDR 42
#endif
#ifndef XPAR_SWS_8BITS_BASEADDR
#define XPAR_SWS_8BITS_BASEADDR 27
#endif
#endif


int main()
{
	//variables to store button and switch states
	uint32_t btns, sw;

	//init board
    init_platform();

    //init hardware registers
    init();

    //infinite control loop
    while(1)
    {
    	//get state of buttons and switches
    	btns = Xil_In32(XPAR_BTNS_5BITS_BASEADDR);
    	sw = Xil_In32(XPAR_SWS_8BITS_BASEADDR);

    	//if center button is clicked, kill application
    	if(btns & BTNC)
    	{
    	    if(mode.softwareDebugMode)
    	    	printf("BTNC has been pressed, exiting program.\n");

    		break;
    	}

    	//set relay mode based off of switch 0
    	if(sw & SW0)
    	{
    		if(mode.softwareDebugMode)
    			printf("Entering software relay mode.\n");

    		setSoftwareRelayMode();
    	}
    	else
    	{
    		if(mode.softwareDebugMode)
    			printf("Entering hardware relay mode.\n");

    		setHardwareRelayMode();
    	}

    	//set debug mode based off of switch 1
    	if(sw & SW1)
    	{
    		if(!mode.softwareDebugMode)
    			printf("Entering software debug mode.\n");

    		mode.softwareDebugMode = 1;
    	}
    	else
    	{
    		mode.softwareDebugMode = 0;
    	}

    	//set record mode based off of switch 2
    	if(sw & SW2)
    	{
    		if(mode.softwareDebugMode && !mode.softwareRecordMode)
    			printf("Entering software record mode.\n");

    		mode.softwareRecordMode = 1;
    	}
    	else
    	{
    		if(mode.softwareDebugMode && mode.softwareRecordMode)
    			printf("Exiting software record mode.\n");

    		mode.softwareRecordMode = 0;
    	}

    	//set play mode based off of switch 3
    	if(sw & SW3)
    	{
    		if(mode.softwareDebugMode && !mode.softwarePlayMode)
    			printf("Entering software play mode.\n");

    		mode.softwarePlayMode = 1;
    	}
    	else
    	{
    		if(mode.softwareDebugMode && mode.softwarePlayMode)
    			printf("Exiting software play mode.\n");

    		mode.softwarePlayMode = 0;
    	}

    	//set filter mode based off of switch 4
    	if(sw & SW4)
    	{
    		if(mode.softwareDebugMode && !mode.softwareFilterMode)
    			printf("Entering software filter mode.\n");

    		mode.softwareFilterMode = 1;
    	}
    	else
    	{
    		if(mode.softwareDebugMode && mode.softwareFilterMode)
    			printf("Exiting software filter mode.\n");

    		mode.softwareFilterMode = 0;
    	}

    	//check for capture frame to be consumed
    	if(PpmAxi->ControlBits.captureFrameReady)
    	{
    		//function that handles all necessary logic (for each mode) for received frame
    		//consumeCaptureFrame();
    	}

    	//check for generate frame to be consumed (in debug mode only)
    	if(PpmAxi->ControlBits.generateFrameReady && mode.softwareFilterMode)
    	{

    	}
    }

    return 0;
}

void init()
{
	//initialize our hardware registers
}

void setHardwareRelayMode()
{
	mode.relayMode = 0;

	//set hardware features
	PpmAxi->ControlBits.SoftwareRelayMode = 0;
}

void setSoftwareRelayMode()
{
	mode.relayMode = 1;

	//set hardware features
	PpmAxi->ControlBits.SoftwareRelayMode = 1;
}

void consumeFrame()
{

}

void fsmCheck()
{
	static unsigned int prevCaptureFsm = 0, prevGenerateFsm = 0;

	if(PpmAxi->CaptureFsmState != prevCaptureFsm)
	{
		printf("Capture FSM State changed: %d\n", PpmAxi->CaptureFsmState);
		prevCaptureFsm = PpmAxi->CaptureFsmState;
	}

	if(PpmAxi->GenerateFsmState != prevGenerateFsm)
	{
		printf("Generate FSM State changed: %d\n", PpmAxi->GenerateFsmState);
		prevGenerateFsm = PpmAxi->GenerateFsmState;
	}
}

void printFrame()
{
	if(PpmAxi->ControlBits.captureFrameReady)
	{
		printf("Captured Frame: %d %d %d %d %d %d\n", 	PpmAxi->CaptureChannelA,
														PpmAxi->CaptureChannelB,
														PpmAxi->CaptureChannelC,
														PpmAxi->CaptureChannelD,
														PpmAxi->CaptureChannelE,
														PpmAxi->CaptureChannelF);
	}
}