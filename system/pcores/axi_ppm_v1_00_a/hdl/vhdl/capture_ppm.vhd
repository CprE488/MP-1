----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:55:40 09/24/2014 
-- Design Name: 
-- Module Name:    capture_ppm - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity capture_ppm is
    Port ( Clock : in  STD_LOGIC;
           Reset : in  STD_LOGIC;
           Ppm : in  STD_LOGIC;
           Sync : in  STD_LOGIC;
           CountReset : out  STD_LOGIC;
           CountEnable : out  STD_LOGIC;
           FrameFinished : out  STD_LOGIC;
           State : out  STD_LOGIC_VECTOR(31 downto 0);
           RegisterNumber : out  UNSIGNED(2 downto 0);
           RegisterLatch : out  STD_LOGIC);
end capture_ppm;

architecture Behavioral of capture_ppm is
    type state_type is              (RESET_STATE, SYNC_STATE, SYNC_MISS, SYNC_WAIT, IDLE_SYNC, 
									PULSE_A, SAVE_A, IDLE_A, PULSE_B, SAVE_B, IDLE_B,
									PULSE_C, SAVE_C, IDLE_C, PULSE_D, SAVE_D, IDLE_D,
									PULSE_E, SAVE_E, IDLE_E, PULSE_F, SAVE_F, IDLE_F);

    signal PS, NS                   : state_type;
    signal CountResetTmp        : std_logic;
begin
sync_proc: process(Clock, Reset, NS)
        begin
            if (Reset = '1') then PS <= RESET_STATE;
                CountReset <= '0';
            elsif (rising_edge(Clock)) then 
                PS <= NS;
                CountReset <= CountResetTmp;
            end if; 
        end process sync_proc; 

        comb_proc: process(PS, Ppm, Sync)
        begin
            CountResetTmp  <= '0';
            CountEnable <= '0';
            FrameFinished <= '0';
            RegisterNumber <= to_unsigned(0, 3);
            RegisterLatch <= '0';
            State <= x"00000000";
            case PS is
                when RESET_STATE =>
                    CountEnable <= '0';
                    RegisterNumber <= to_unsigned(0, 3);
                    State <= x"00000000";
                    if (Ppm = '0') then
                        NS <= RESET_STATE;  
                        CountResetTmp  <= '0'; 
                        RegisterLatch <= '0';
                        FrameFinished <= '0';
				    else                                    
				        NS <= SYNC_STATE;   
				        CountResetTmp  <= '1'; 
				        RegisterLatch <= '0';
				        FrameFinished <= '0';
				    end if;
				when SYNC_STATE =>
				    CountEnable <= '1';
				    RegisterNumber <= to_unsigned(0, 3);
                    State <= x"00000001";
				    if (Sync = '1') then
                        NS <= SYNC_WAIT;  
                        CountResetTmp  <= '1'; 
                        RegisterLatch <= '0';
                        FrameFinished <= '0';
                    elsif (Ppm = '1') then
                        NS <= SYNC_STATE;  
                        CountResetTmp  <= '0'; 
                        RegisterLatch <= '0';
                        FrameFinished <= '0';
                    else
                        NS <= SYNC_MISS;  
                        CountResetTmp  <= '1'; 
                        RegisterLatch <= '0';
                        FrameFinished <= '0';
                    end if;
				when SYNC_MISS =>
				    CountEnable <= '0';
				    RegisterNumber <= to_unsigned(0, 3);
                    State <= x"00000002";
				    if (Ppm = '0') then
                        NS <= SYNC_MISS;  
                        CountResetTmp  <= '0'; 
                        RegisterLatch <= '0';
                        FrameFinished <= '0';
                    else
                        NS <= SYNC_STATE;  
                        CountResetTmp  <= '1'; 
                        RegisterLatch <= '0';
                        FrameFinished <= '0';
                    end if;
                when SYNC_WAIT =>
                    CountEnable <= '0';
                    RegisterNumber <= to_unsigned(0, 3);
                    State <= x"00000003";
                    if (Ppm = '1') then
                        NS <= SYNC_WAIT;  
                        CountResetTmp  <= '0'; 
                        RegisterLatch <= '0';
                        FrameFinished <= '0';
                    else
                        NS <= IDLE_SYNC;  
                        CountResetTmp  <= '0'; 
                        RegisterLatch <= '0';
                        FrameFinished <= '0';
                    end if;
                when IDLE_SYNC =>
                    CountEnable <= '0';
                    RegisterNumber <= to_unsigned(0, 3);
                    State <= x"00000004";
                    if (Ppm = '0') then
                        NS <= IDLE_SYNC;  
                        CountResetTmp  <= '0'; 
                        RegisterLatch <= '0';
                        FrameFinished <= '0';
				    else
                        NS <= PULSE_A;  
                        CountResetTmp  <= '1'; 
                        RegisterLatch <= '0';
                        FrameFinished <= '0';
                    end if;
                    
            -- Pulse A
                when PULSE_A =>
                    CountEnable <= '1';
                    RegisterNumber <= to_unsigned(0, 3);
                    State <= x"00000005";
                    if (Sync = '1') then
                        NS <= SYNC_WAIT;  
                        CountResetTmp  <= '1'; 
                        RegisterLatch <= '0';
                        FrameFinished <= '0';
                    elsif (Ppm = '1') then
                        NS <= PULSE_A;  
                        CountResetTmp  <= '0'; 
                        RegisterLatch <= '0';
                        FrameFinished <= '0';
                    else
                        NS <= SAVE_A;  
                        CountResetTmp  <= '0'; 
                        RegisterLatch <= '1';
                        FrameFinished <= '0';
                    end if;
                when SAVE_A =>
                    CountEnable <= '0';
                    RegisterNumber <= to_unsigned(0, 3);
                    State <= x"00000006";
                    NS <= IDLE_A;  
                    CountResetTmp  <= '1'; 
                    RegisterLatch <= '0';
                    FrameFinished <= '0';
                when IDLE_A =>
                    CountEnable <= '0';
                    RegisterNumber <= to_unsigned(0, 3);
                    if (Ppm = '0') then
                        NS <= IDLE_A;  
                        CountResetTmp  <= '0'; 
                        RegisterLatch <= '0';
                        FrameFinished <= '0';
                    else
                        NS <= PULSE_B;  
                        CountResetTmp  <= '1'; 
                        RegisterLatch <= '0';
                        FrameFinished <= '0';
                    end if;
            
            -- Pulse B
                when PULSE_B =>
                    CountEnable <= '1';
                    RegisterNumber <= to_unsigned(1, 3);
                    State <= x"00000007";
                    if (Sync = '1') then
                        NS <= SYNC_WAIT;  
                        CountResetTmp  <= '1'; 
                        RegisterLatch <= '0';
                        FrameFinished <= '0';
                    elsif (Ppm = '1') then
                        NS <= PULSE_B;  
                        CountResetTmp  <= '0'; 
                        RegisterLatch <= '0';
                        FrameFinished <= '0';
                    else
                        NS <= SAVE_B;  
                        CountResetTmp  <= '0'; 
                        RegisterLatch <= '1';
                        FrameFinished <= '0';
                    end if;
                when SAVE_B =>
                    CountEnable <= '0';
                    RegisterNumber <= to_unsigned(1, 3);
                    State <= x"00000008";
                    NS <= IDLE_B;  
                    CountResetTmp  <= '1'; 
                    RegisterLatch <= '0';
                    FrameFinished <= '0';
                when IDLE_B =>
                    CountEnable <= '0';
                    RegisterNumber <= to_unsigned(1, 3);
                    State <= x"00000009";
                    if (Ppm = '0') then
                        NS <= IDLE_B;  
                        CountResetTmp  <= '0'; 
                        RegisterLatch <= '0';
                        FrameFinished <= '0';
                    else
                        NS <= PULSE_C;  
                        CountResetTmp  <= '1'; 
                        RegisterLatch <= '0';
                        FrameFinished <= '0';
                    end if;
            
            -- Pulse C
                when PULSE_C =>
                    CountEnable <= '1';
                    RegisterNumber <= to_unsigned(2, 3);
                    State <= x"0000000A";
                    if (Sync = '1') then
                        NS <= SYNC_WAIT;  
                        CountResetTmp  <= '1'; 
                        RegisterLatch <= '0';
                        FrameFinished <= '0';
                    elsif (Ppm = '1') then
                        NS <= PULSE_C;  
                        CountResetTmp  <= '0'; 
                        RegisterLatch <= '0';
                        FrameFinished <= '0';
                    else
                        NS <= SAVE_C;  
                        CountResetTmp  <= '0'; 
                        RegisterLatch <= '1';
                        FrameFinished <= '0';
                    end if;
                when SAVE_C =>
                    CountEnable <= '0';
                    RegisterNumber <= to_unsigned(2, 3);
                    State <= x"0000000B";
                    NS <= IDLE_C;  
                    CountResetTmp  <= '1'; 
                    RegisterLatch <= '0';
                    FrameFinished <= '0';
                when IDLE_C =>
                    CountEnable <= '0';
                    RegisterNumber <= to_unsigned(2, 3);
                    State <= x"0000000C";
                    if (Ppm = '0') then
                        NS <= IDLE_C;  
                        CountResetTmp  <= '0'; 
                        RegisterLatch <= '0';
                        FrameFinished <= '0';
                    else
                        NS <= PULSE_D;  
                        CountResetTmp  <= '1'; 
                        RegisterLatch <= '0';
                        FrameFinished <= '0';
                    end if;
            
            -- Pulse D
                when PULSE_D =>
                    CountEnable <= '1';
                    RegisterNumber <= to_unsigned(3, 3);
                    State <= x"0000000D";
                    if (Sync = '1') then
                        NS <= SYNC_WAIT;  
                        CountResetTmp  <= '1'; 
                        RegisterLatch <= '0';
                        FrameFinished <= '0';
                    elsif (Ppm = '1') then
                        NS <= PULSE_D;  
                        CountResetTmp  <= '0'; 
                        RegisterLatch <= '0';
                        FrameFinished <= '0';
                    else
                        NS <= SAVE_D;  
                        CountResetTmp  <= '0'; 
                        RegisterLatch <= '1';
                        FrameFinished <= '0';
                    end if;
                when SAVE_D =>
                    CountEnable <= '0';
                    RegisterNumber <= to_unsigned(3, 3);
                    State <= x"0000000E";
                    NS <= IDLE_D;  
                    CountResetTmp  <= '1'; 
                    RegisterLatch <= '0';
                    FrameFinished <= '0';
                when IDLE_D =>
                    CountEnable <= '0';
                    RegisterNumber <= to_unsigned(3, 3);
                    State <= x"0000000F";
                    if (Ppm = '0') then
                        NS <= IDLE_D;  
                        CountResetTmp  <= '0'; 
                        RegisterLatch <= '0';
                        FrameFinished <= '0';
                    else
                        NS <= PULSE_E;  
                        CountResetTmp  <= '1'; 
                        RegisterLatch <= '0';
                        FrameFinished <= '0';
                    end if;
            
            -- Pulse E
                when PULSE_E =>
                    CountEnable <= '1';
                    RegisterNumber <= to_unsigned(4, 3);
                    State <= x"00000010";
                    if (Sync = '1') then
                        NS <= SYNC_WAIT;  
                        CountResetTmp  <= '1'; 
                        RegisterLatch <= '0';
                        FrameFinished <= '0';
                    elsif (Ppm = '1') then
                        NS <= PULSE_E;  
                        CountResetTmp  <= '0'; 
                        RegisterLatch <= '0';
                        FrameFinished <= '0';
                    else
                        NS <= SAVE_E;  
                        CountResetTmp  <= '0'; 
                        RegisterLatch <= '1';
                        FrameFinished <= '0';
                    end if;
                when SAVE_E =>
                    CountEnable <= '0';
                    RegisterNumber <= to_unsigned(4, 3);
                    State <= x"00000011";
                    NS <= IDLE_E;  
                    CountResetTmp  <= '1'; 
                    RegisterLatch <= '0';
                    FrameFinished <= '0';
                when IDLE_E =>
                    CountEnable <= '0';
                    RegisterNumber <= to_unsigned(4, 3);
                    State <= x"00000012";
                    if (Ppm = '0') then
                        NS <= IDLE_E;  
                        CountResetTmp  <= '0'; 
                        RegisterLatch <= '0';
                        FrameFinished <= '0';
                    else
                        NS <= PULSE_F;  
                        CountResetTmp  <= '1'; 
                        RegisterLatch <= '0';
                        FrameFinished <= '0';
                    end if;
            
            -- Pulse F
                when PULSE_F =>
                    CountEnable <= '1';
                    RegisterNumber <= to_unsigned(5, 3);
                    State <= x"00000013";
                    if (Sync = '1') then
                        NS <= SYNC_WAIT;  
                        CountResetTmp  <= '1'; 
                        RegisterLatch <= '0';
                        FrameFinished <= '0';
                    elsif (Ppm = '1') then
                        NS <= PULSE_F;  
                        CountResetTmp  <= '0'; 
                        RegisterLatch <= '0';
                        FrameFinished <= '0';
                    else
                        NS <= SAVE_F;  
                        CountResetTmp  <= '0'; 
                        RegisterLatch <= '1';
                        FrameFinished <= '0';
                    end if;
                when SAVE_F =>
                    CountEnable <= '0';
                    RegisterNumber <= to_unsigned(5, 3);
                    State <= x"00000014";
                    NS <= IDLE_F;  
                    CountResetTmp  <= '1'; 
                    RegisterLatch <= '0';
                    FrameFinished <= '1';
                when IDLE_F =>
                    CountEnable <= '0';
                    RegisterNumber <= to_unsigned(5, 3);
                    State <= x"00000015";
                    if (Ppm = '0') then
                        NS <= IDLE_F;  
                        CountResetTmp  <= '0'; 
                        RegisterLatch <= '0';
                        FrameFinished <= '0';
                    else
                        NS <= PULSE_F;  
                        CountResetTmp  <= '1'; 
                        RegisterLatch <= '0';
                        FrameFinished <= '0';
                    end if;

                when others =>
                    CountEnable <= '0';
                    RegisterNumber <= to_unsigned(0, 3);
                    NS <= RESET_STATE;  
                    CountResetTmp  <= '0'; 
                    RegisterLatch <= '0';
                    FrameFinished <= '0';
                    
            end case;
        end process comb_proc;


end Behavioral;

