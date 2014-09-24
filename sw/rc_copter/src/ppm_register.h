/**
 * @file        ppm_register_h
 * @author      Jeramie Vens
 * @author      Adam Sunderman
 * @date        09/18/14 - Created
 * @brief       Map register names to phyisical memory locations.
 */

#ifndef PPM_REGISTER_H
#define PPM_REGISTER_H

/// The base address of the PPM_AXI registers
#define PPM_REGISTER_ADDRESS 0x40000000

/// Register layout for the PPM_AXI module
struct PPM_REGISTER_STRUCT
{
    union {
        unsigned int Control;                       ///< R/W The control register for the PPM module             
        struct PPM_CONTROL_STRUCT
        {
            unsigned SoftwareRelayMode      : 1;    ///< R/W When HIGH the PPM is in software mode. When LOW the PPM is in hardware passthrough mode.
            unsigned Synced                 : 1;    ///< R/O Goes HIGH when the PPM is locked onto a PPM signal
            unsigned Reset                  : 1;    ///< R/W Setting HIGH causes the PPM to reset
            unsigned captureFrameReady		: 1;	///< R/W Setting HIGH signifies frame ready, reset by software to signify frame read
            unsigned generateFrameReady		: 1;	///< R/W Setting HIGH signifies hardware ready to have frame written, software will clear after passing frame
            unsigned dummy1                 : 27;   ///< Fill the rest of the struct with dummy data
        } ControlBits;
    };
    unsigned int CaptureCount;                      ///< R/O The current number of captured frames from the PPM
    unsigned int CaptureFsmState;                   ///< R/O The state of the capture FSM
    unsigned int GenerateFsmState;                  ///< R/O The state of the generate FSM
    unsigned int CaptureSyncLength;                 ///< R/W The minimum number of pulses to count as a sync pulse
    unsigned int GenerateIdleLength;                ///< R/W The number of pulses to wait between channels
    unsigned int GenerateFrameLength;               ///< R/W The number of pulses to make each frame
    unsigned int dummy1;                            ///<     Filler
    unsigned int dummy2;                            ///<     Filler
    unsigned int dummy3;                            ///<     Filler
    unsigned int CaptureChannelA;                   ///< R/O The captured value from Channel A
    unsigned int CaptureChannelB;                   ///< R/O The captured value from Channel B
    unsigned int CaptureChannelC;                   ///< R/O The captured value from Channel C
    unsigned int CaptureChannelD;                   ///< R/O The captured value from Channel D
    unsigned int CaptureChannelE;                   ///< R/O The captured value from Channel E
    unsigned int CaptureChannelF;                   ///< R/O The captured value from Channel F
    unsigned int dummy4;                            ///<     Filler
    unsigned int dummy5;                            ///<     Filler
    unsigned int dummy6;                            ///<     Filler
    unsigned int dummy7;                            ///<     Filler
    unsigned int GenerateChannelA;                  ///< R/W The value to generate for Channel A
    unsigned int GenerateChannelB;                  ///< R/W The value to generate for Channel B
    unsigned int GenerateChannelC;                  ///< R/W The value to generate for Channel C
    unsigned int GenerateChannelD;                  ///< R/W The value to generate for Channel D
    unsigned int GenerateChannelE;                  ///< R/W The value to generate for Channel E
    unsigned int GenerateChannelF;                  ///< R/W The value to generate for Channel F
    unsigned int dummy8;                            ///<     Filler
    unsigned int dummy9;                            ///<     Filler
    unsigned int dummy10;                           ///<     Filler
    unsigned int dummy11;                           ///<     Filler
    unsigned int dummy12;                           ///<     Filler
    unsigned int dummy13;                           ///<     Filler
};

/// The PPM_AXI registers
volatile struct PPM_REGISTER_STRUCT * const PpmAxi = (struct PPM_REGISTER_STRUCT *) PPM_REGISTER_ADDRESS;

#endif

