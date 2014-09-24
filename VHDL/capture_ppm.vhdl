-- DO NOT EDIT BELOW THIS LINE --------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library proc_common_v3_00_a;
use proc_common_v3_00_a.proc_common_pkg.all;

-- DO NOT EDIT ABOVE THIS LINE --------------------

------------------------------------------------------------------------------
-- Entity section
------------------------------------------------------------------------------
-- Definition of Ports:
--   Clock                        -- clock signal
--   Reset                        -- reset fsm
--   Ppm                          -- the input ppm signal to decode
--   Sync                         -- true if sync has been detected
--   CountReset                   -- reset the counter
--   CountEnable                  -- enable the counter
--   FrameFinished                -- raised when all 6 channels have been captured
--   Synced                       -- raised when we have synced on the singnal
--   State                        -- current state of the FSM
--   RegNum                       -- register to write count value to
--   RegLatch                     -- signal to latch register value
------------------------------------------------------------------------------

entity capture_ppm is
    port
    (
        Clock                       : in std_logic;
        Reset                       : in std_logic;
        Ppm                         : in std_logic;
        Sync                        : in std_logic;
        CountReset                  : out std_logic;
        CountEnable                 : out std_logic;
        FrameFinished               : out std_logic;
        --Synced                      : out std_logic;
        State                       : out std_logic_vector(31 downto 0);
        RegNum                      : out unsigned(7 downto 0);
        RegLatch                    : out std_logic
    );

    attribute SIGIS of Clock        : signal is "CLK";
end entity capture_ppm;



architecture IMP of capture_ppm is
    type state_type is              (RESET, SYNC, SYNC_MISS, SYNC_WAIT, IDLE_SYNC, 
									PULSE_A, SAVE_A, IDLE_A, PULSE_B, SAVE_B, IDLE_B,
									PULSE_C, SAVE_C, IDLE_C, PULSE_D, SAVE_D, IDLE_D,
									PULSE_E, SAVE_E, IDLE_E, PULSE_F, SAVE_F, IDLE_F);

    signal PS, NS                   : state_type;
    
    begin
        sync_proc: process(Clock, Reset, NS)
        begin
            if (Reset = '1') then PS <= RESET;
            elsif (rising_edge(Clock)) then PS <= NS;
            end if
        end sync_proc;

        comb_proc: process(PS, Ppm, Sync)
        begin
            CountReset <= '0';
            CountEnable <= '0';
            FrameFinished <= '0';
            RegNum <= 0;
            RegLatch <= '0';
            State <= x"00000000"
            case PS is
                when RESET =>
                    CountEnable <= '0';
                    RegNum <= 0;
                    State <= x"00000000"
                    if (Ppm = '0') then
                        NS <= RESET;  
                        CountReset <= '0'; 
                        RegLatch <= '0';
                        FrameFinished <= '0';
				    else                                    
				        NS <= SYNC;   
				        CountReset <= '1'; 
				        RegLatch <= '0';
				        FrameFinished <= '0';
				    end if
				when SYNC =>
				    CountEnable <= '1';
				    RegNum <= 0;
                    State <= x"00000001"
				    if (Sync = '1') then
                        NS <= SYNC_WAIT;  
                        CountReset <= '1'; 
                        RegLatch <= '0';
                        FrameFinished <= '0';
                    elsif (Ppm = '1') then
                        NS <= SYNC;  
                        CountReset <= '0'; 
                        RegLatch <= '0';
                        FrameFinished <= '0';
                    else
                        NS <= SYNC_MISS;  
                        CountReset <= '1'; 
                        RegLatch <= '0';
                        FrameFinished <= '0';
                    end if
				when SYNC_MISS =>
				    CountEnable <= '0';
				    RegNum <= 0;
                    State <= x"00000002"
				    if (Ppm = '0') then
                        NS <= SYNC_MISS;  
                        CountReset <= '0'; 
                        RegLatch <= '0';
                        FrameFinished <= '0';
                    else
                        NS <= SYNC;  
                        CountReset <= '1'; 
                        RegLatch <= '0';
                        FrameFinished <= '0';
                    end if
                when SYNC_WAIT =>
                    CountEnable <= '0';
                    RegNum <= 0;
                    State <= x"00000003"
                    if (Ppm = '1') then
                        NS <= SYNC_WAIT;  
                        CountReset <= '0'; 
                        RegLatch <= '0';
                        FrameFinished <= '0';
                    else
                        NS <= IDLE_SYNC;  
                        CountReset <= '0'; 
                        RegLatch <= '0';
                        FrameFinished <= '0';
                    end if
                when IDLE_SYNC =>
                    CountEnable <= '0';
                    RegNum <= 0;
                    State <= x"00000004"
                    if (Ppm = '0') then
                        NS <= IDLE_SYNC;  
                        CountReset <= '0'; 
                        RegLatch <= '0';
                        FrameFinished <= '0';
				    else
                        NS <= PULSE_A;  
                        CountReset <= '1'; 
                        RegLatch <= '0';
                        FrameFinished <= '0';
                    end if
                    
            -- Pulse A
                when PULSE_A =>
                    CountEnable <= '1';
                    RegNum <= 0;
                    State <= x"00000005"
                    if (Sync = '1') then
                        NS <= SYNC_WAIT;  
                        CountReset <= '1'; 
                        RegLatch <= '0';
                        FrameFinished <= '0';
                    elsif (Ppm = '1') then
                        NS <= PULSE_A;  
                        CountReset <= '0'; 
                        RegLatch <= '0';
                        FrameFinished <= '0';
                    else
                        NS <= SAVE_A;  
                        CountReset <= '0'; 
                        RegLatch <= '1';
                        FrameFinished <= '0';
                    end if
                when SAVE_A =>
                    CountEnable <= '0';
                    RegNum <= 0;
                    State <= x"00000006"
                    NS <= IDLE_A;  
                    CountReset <= '1'; 
                    RegLatch <= '0';
                    FrameFinished <= '0';
                when IDLE_A =>
                    CountEnable <= '0';
                    RegNum <= 0;
                    if (Ppm = '0') then
                        NS <= IDLE_A;  
                        CountReset <= '0'; 
                        RegLatch <= '0';
                        FrameFinished <= '0';
                    else
                        NS <= PULSE_B;  
                        CountReset <= '1'; 
                        RegLatch <= '0';
                        FrameFinished <= '0';
                    end if
            
            -- Pulse B
                when PULSE_B =>
                    CountEnable <= '1';
                    RegNum <= 1;
                    State <= x"00000007"
                    if (Sync = '1') then
                        NS <= SYNC_WAIT;  
                        CountReset <= '1'; 
                        RegLatch <= '0';
                        FrameFinished <= '0';
                    elsif (Ppm = '1') then
                        NS <= PULSE_B;  
                        CountReset <= '0'; 
                        RegLatch <= '0';
                        FrameFinished <= '0';
                    else
                        NS <= SAVE_B;  
                        CountReset <= '0'; 
                        RegLatch <= '1';
                        FrameFinished <= '0';
                    end if
                when SAVE_B =>
                    CountEnable <= '0';
                    RegNum <= 1;
                    State <= x"00000008"
                    NS <= IDLE_B;  
                    CountReset <= '1'; 
                    RegLatch <= '0';
                    FrameFinished <= '0';
                when IDLE_B =>
                    CountEnable <= '0';
                    RegNum <= 1;
                    State <= x"00000009"
                    if (Ppm = '0') then
                        NS <= IDLE_B;  
                        CountReset <= '0'; 
                        RegLatch <= '0';
                        FrameFinished <= '0';
                    else
                        NS <= PULSE_C;  
                        CountReset <= '1'; 
                        RegLatch <= '0';
                        FrameFinished <= '0';
                    end if
            
            -- Pulse C
                when PULSE_C =>
                    CountEnable <= '1';
                    RegNum <= 2;
                    State <= x"0000000A"
                    if (Sync = '1') then
                        NS <= SYNC_WAIT;  
                        CountReset <= '1'; 
                        RegLatch <= '0';
                        FrameFinished <= '0';
                    elsif (Ppm = '1') then
                        NS <= PULSE_C;  
                        CountReset <= '0'; 
                        RegLatch <= '0';
                        FrameFinished <= '0';
                    else
                        NS <= SAVE_C;  
                        CountReset <= '0'; 
                        RegLatch <= '1';
                        FrameFinished <= '0';
                    end if
                when SAVE_C =>
                    CountEnable <= '0';
                    RegNum <= 2;
                    State <= x"0000000B"
                    NS <= IDLE_C;  
                    CountReset <= '1'; 
                    RegLatch <= '0';
                    FrameFinished <= '0';
                when IDLE_C =>
                    CountEnable <= '0';
                    RegNum <= 2;
                    State <= x"0000000C"
                    if (Ppm = '0') then
                        NS <= IDLE_C;  
                        CountReset <= '0'; 
                        RegLatch <= '0';
                        FrameFinished <= '0';
                    else
                        NS <= PULSE_D;  
                        CountReset <= '1'; 
                        RegLatch <= '0';
                        FrameFinished <= '0';
                    end if
            
            -- Pulse D
                when PULSE_D =>
                    CountEnable <= '1';
                    RegNum <= 3;
                    State <= x"0000000D"
                    if (Sync = '1') then
                        NS <= SYNC_WAIT;  
                        CountReset <= '1'; 
                        RegLatch <= '0';
                        FrameFinished <= '0';
                    elsif (Ppm = '1') then
                        NS <= PULSE_D;  
                        CountReset <= '0'; 
                        RegLatch <= '0';
                        FrameFinished <= '0';
                    else
                        NS <= SAVE_D;  
                        CountReset <= '0'; 
                        RegLatch <= '1';
                        FrameFinished <= '0';
                    end if
                when SAVE_D =>
                    CountEnable <= '0';
                    RegNum <= 3;
                    State <= x"0000000E"
                    NS <= IDLE_D;  
                    CountReset <= '1'; 
                    RegLatch <= '0';
                    FrameFinished <= '0';
                when IDLE_D =>
                    CountEnable <= '0';
                    RegNum <= 3;
                    State <= x"0000000F"
                    if (Ppm = '0') then
                        NS <= IDLE_D;  
                        CountReset <= '0'; 
                        RegLatch <= '0';
                        FrameFinished <= '0';
                    else
                        NS <= PULSE_E;  
                        CountReset <= '1'; 
                        RegLatch <= '0';
                        FrameFinished <= '0';
                    end if
            
            -- Pulse E
                when PULSE_E =>
                    CountEnable <= '1';
                    RegNum <= 4;
                    State <= x"00000010"
                    if (Sync = '1') then
                        NS <= SYNC_WAIT;  
                        CountReset <= '1'; 
                        RegLatch <= '0';
                        FrameFinished <= '0';
                    elsif (Ppm = '1') then
                        NS <= PULSE_E;  
                        CountReset <= '0'; 
                        RegLatch <= '0';
                        FrameFinished <= '0';
                    else
                        NS <= SAVE_E;  
                        CountReset <= '0'; 
                        RegLatch <= '1';
                        FrameFinished <= '0';
                    end if
                when SAVE_E =>
                    CountEnable <= '0';
                    RegNum <= 4;
                    State <= x"00000011"
                    NS <= IDLE_E;  
                    CountReset <= '1'; 
                    RegLatch <= '0';
                    FrameFinished <= '0';
                when IDLE_E =>
                    CountEnable <= '0';
                    RegNum <= 4;
                    State <= x"00000012"
                    if (Ppm = '0') then
                        NS <= IDLE_E;  
                        CountReset <= '0'; 
                        RegLatch <= '0';
                        FrameFinished <= '0';
                    else
                        NS <= PULSE_F;  
                        CountReset <= '1'; 
                        RegLatch <= '0';
                        FrameFinished <= '0';
                    end if
            
            -- Pulse F
                when PULSE_F =>
                    CountEnable <= '1';
                    RegNum <= 5;
                    State <= x"00000013"
                    if (Sync = '1') then
                        NS <= SYNC_WAIT;  
                        CountReset <= '1'; 
                        RegLatch <= '0';
                        FrameFinished <= '0';
                    elsif (Ppm = '1') then
                        NS <= PULSE_F;  
                        CountReset <= '0'; 
                        RegLatch <= '0';
                        FrameFinished <= '0';
                    else
                        NS <= SAVE_F;  
                        CountReset <= '0'; 
                        RegLatch <= '1';
                        FrameFinished <= '0';
                    end if
                when SAVE_F =>
                    CountEnable <= '0';
                    RegNum <= 5;
                    State <= x"00000014"
                    NS <= IDLE_F;  
                    CountReset <= '1'; 
                    RegLatch <= '0';
                    FrameFinished <= '1';
                when IDLE_F =>
                    CountEnable <= '0';
                    RegNum <= 5;
                    State <= x"00000015"
                    if (Ppm = '0') then
                        NS <= IDLE_F;  
                        CountReset <= '0'; 
                        RegLatch <= '0';
                        FrameFinished <= '0';
                    else
                        NS <= PULSE_F;  
                        CountReset <= '1'; 
                        RegLatch <= '0';
                        FrameFinished <= '0';
                    end if

                when others =>
                    CountEnable <= '0';
                    RegNum <= 0;
                    NS <= RESET;  
                    CountReset <= '0'; 
                    RegLatch <= '0';
                    FrameFinished <= '0';
                    
            end case;
        end process comb_proc;

end IMP
