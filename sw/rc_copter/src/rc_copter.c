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
#define PLAYBACK_FRAME_SKIP 0           //not implemented yet

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
    unsigned int channelA;
    unsigned int channelB;
    unsigned int channelC;
    unsigned int channelD;
    unsigned int channelE;
    unsigned int channelF;
}frame;

/*global variables*/

softwareMode mode;
frame playbackBuffer[PLAYBACK_NUM_FRAMES];

/*end global variables*/

/*prototypes*/

//initializes registers
void init();

//checks buttons and switches and changes mode accordingly
//returns -1 if kill button is pressed
int checkInputs();

//performs necessary logic when consuming captured frame
frame consumeCaptureFrame(int* recordIndex);

//performs necessary logic when generating generate frame
void generateFrame(frame currentFrame, int* playbackIndex, int* recordIndex);

//sets the mode to hardware relay mode (will turn software relay mode off)
void setHardwareRelayMode();

//sets the mode to software relay mode (will turn hardware relay mode off)
void setSoftwareRelayMode();

//prints out changes to capture and generate fsm states
void fsmCheck();

//prints all six channels of given frame via uart printf
void printFrame(frame pf);

/*end prototypes*/

/*when testing without xsdk import define numbers for base addresses*/
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
    //index for recording into playback buffer
    int recordIndex = 0;

    //index for our location in the global playback buffer
    int playbackIndex = 0;

    //structure to store the current captured frame
    frame currentFrame;

	//init board
    init_platform();

    //init hardware registers
    init();

    //infinite control loop
    while(1)
    {
        //check buttons and switches and adjust mode accordingly
        if(checkInputs())
        {
            //if check inputs returns -1 break out of control loop and exit program
            break;
        }

    	//check for capture frame to be consumed
    	if(PpmAxi->ControlBits.captureFrameReady)
    	{
    		//function that handles all necessary logic (for each mode) for received frame
    		currentFrame = consumeCaptureFrame(&recordIndex);
    	}

    	//check if hardware is ready for a new frame
        if(PpmAxi->ControlBits.generateFrameReady)
        {
            //function that handles all logic for interacting with the generateFrame registers
            generateFrame(currentFrame, &playbackIndex, &recordIndex);
        }

        //if in software debug mode, print out changes to finite state machines
        if(mode.SoftwareDebugMode)
        {
            fsmCheck();
        }
    }

    return 0;
}

//initializes registers
void init()
{
	//initialize our hardware registers
    /*TODO*/
}

//checks buttons and switches and changes mode accordingly
//returns -1 if kill button is pressed
int checkInputs()
{
    //variables to store button and switch states
    uint32_t btns, sw;

    //get state of buttons and switches
    btns = Xil_In32(XPAR_BTNS_5BITS_BASEADDR);
    sw = Xil_In32(XPAR_SWS_8BITS_BASEADDR);

    //if center button is clicked, kill application
    if(btns & BTNC)
    {
        if(mode.softwareDebugMode)
            printf("BTNC has been pressed, exiting program.\n");

        return -1;
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

    return 0;
}

//performs necessary logic when consuming captured frame
frame consumeFrame(int* recordIndex)
{
    //variables to store button and switch states
    uint32_t btns, sw;

    //get state of buttons and switches
    btns = Xil_In32(XPAR_BTNS_5BITS_BASEADDR);
    sw = Xil_In32(XPAR_SWS_8BITS_BASEADDR);

    //create and fill frame
    frame currentFrame;
    currentFrame.channelA = PpmAxi.CaptureChannelA;
    currentFrame.channelB = PpmAxi.CaptureChannelB;
    currentFrame.channelC = PpmAxi.CaptureChannelC;
    currentFrame.channelD = PpmAxi.CaptureChannelD;
    currentFrame.channelE = PpmAxi.CaptureChannelE;
    currentFrame.channelF = PpmAxi.CaptureChannelF;

    //if in software debug mode, print frame
    if(mode.SoftwareDebugMode)
    {
        printFrame(currentFrame);
    }

    //if in software record mode handle recording/rewinding based off of button input
    if(mode.softwareRecordMode)
    {
        //if btnd is clicked, record
        if(btns & BTND)
        {
            if(*recordIndex > PLAYBACK_NUM_FRAMES)
            {
                *recordIndex--;

                if(mode.SoftwareDebugMode)
                {
                    printf("recording has reached end of allocated memory, setting to last recordable index, please rewind\n");
                }
            }

            playbackBuffer[*recordIndex++] = frame;
        }

        //if btnu is clicked, rewind recording
        if(btns & BTNU)
        {
            if(*recordIndex < 1)
            {
                *recordIndex = 1;

                if(mode.SoftwareDebugMode)
                {
                    printf("rewind has reached beginning of allocated memory.\n");
                }
            }
            *recordIndex--;
        }
    }

    return currentFrame;
}

//performs necessary logic when generating generate frame
void generateFrame(frame currentFrame, int* playbackIndex, int* recordIndex)
{
    //variables to store button and switch states
    uint32_t btns, sw;

    //get state of buttons and switches
    btns = Xil_In32(XPAR_BTNS_5BITS_BASEADDR);
    sw = Xil_In32(XPAR_SWS_8BITS_BASEADDR);

    frame frameToGenerate;

    //if we are in software play mode, check inputs to see if we should
    //play our buffer
    if(mode.SoftwarePlayMode)
    {
        //if btnr is pressed, than play the playback buffer
        if(btns & BTNR)
        {
            //if we are outside of play bounds, set play to last frame
            if(*recordIndex < *playbackIndex)
            {
                *playbackIndex = *recordIndex;
                if(mode.SoftwareDebugMode)
                {
                    printf("playback outside of recording, rewinding to last recorded frame.\n");
                }
            }

            frameToGenerate = playbackBuffer[*playbackIndex++];
        }

        //if btnl is pressed, then rewind the playback index
        if(btns & BTNL)
        {
            //if we are outside of play bounds, reset to play first frame
            if(*playbackIndex < 1)
            {
                *playbackIndex = 1;
                if(mode.SoftwareDebugMode)
                {
                    printf("rewinding playback has reached the beginning of allocated memory.\n");
                }
            }

            *playbackIndex--;
        }
    }

    //else, pass along the captured frame
    else
    {
        frameToGenerate = currentFrame;
    }

    //if in filter mode, evaluate frame for stability
    if(mode.softwareFilterMode)
    {
        /*TODO*/
    }

    //write frameToGenerate to frame buffer
    PpmAxi->GenerateChannelA = frameToGenerate->channelA;
    PpmAxi->GenerateChannelB = frameToGenerate->channelB;
    PpmAxi->GenerateChannelC = frameToGenerate->channelC;
    PpmAxi->GenerateChannelD = frameToGenerate->channelD;
    PpmAxi->GenerateChannelE = frameToGenerate->channelE;
    PpmAxi->GenerateChannelF = frameToGenerate->channelF;
}

//sets the mode to hardware relay mode (will turn software relay mode off)
void setHardwareRelayMode()
{
	mode.relayMode = 0;

	//set hardware features
	PpmAxi->ControlBits.SoftwareRelayMode = 0;
}

//sets the mode to software relay mode (will turn hardware relay mode off)
void setSoftwareRelayMode()
{
	mode.relayMode = 1;

	//set hardware features
	PpmAxi->ControlBits.SoftwareRelayMode = 1;
}

//prints out changes to capture and generate fsm states
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

//prints all six channels of given frame via uart printf
void printFrame(frame pf)
{
	printf("Captured Frame: %d %d %d %d %d %d\n", 	pf->channelA,
													pf->channelB,
													pf->channelC,
													pf->channelD,
													pf->channelE,
													pf->channelF);
}
