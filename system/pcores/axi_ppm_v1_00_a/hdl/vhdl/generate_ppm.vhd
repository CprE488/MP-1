----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:24:13 09/24/2014 
-- Design Name: 
-- Module Name:    generate_ppm - Behavioral 
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

entity generate_ppm is
    Port ( Clock : in  STD_LOGIC;
           Reset : in  STD_LOGIC;
           TopReached : in  STD_LOGIC;
           FrameOver : in  STD_LOGIC;
           FrameCountReset : out  STD_LOGIC;
           FrameCountEnable : out  STD_LOGIC;
           CountReset : out  STD_LOGIC;
           CountEnable : out  STD_LOGIC;
           RegisterNumber : out  UNSIGNED(2 downto 0);
           State : out  STD_LOGIC_VECTOR(31 downto 0);
           PpmOutput : out  STD_LOGIC);
end generate_ppm;

architecture Behavioral of generate_ppm is
    type state_type is  (RESET_STATE, IDLE_SYNC, PULSE_A, IDLE_A,
                        PULSE_B, IDLE_B, PULSE_C, IDLE_C,
                        PULSE_D, IDLE_D, PULSE_E, IDLE_E,
                        PULSE_F, IDLE_F, SYNC);
    
    signal PS, NS       : state_type;
    signal CountResetTmp : std_logic;
    signal FrameCountResetTmp : std_logic;
    
begin
    sync_proc: process(Clock, Reset, NS)
    begin
        if (Reset = '1') then PS<= RESET_STATE;
        elsif (rising_edge(Clock)) then 
            PS <= NS;
            CountReset <= CountResetTmp;
            FrameCountReset <= FrameCountResetTmp;
        end if;
    end process sync_proc;
    
    comb_proc: process(PS, TopReached, FrameOver)
    begin
        CountEnable <= '0';
        FrameCountEnable <= '0';
        RegisterNumber <= to_unsigned(0, 3);
        PpmOutput <= '0';
        State <= x"00000000";
        case PS is
            when RESET_STATE =>
                CountEnable <= '0';
                FrameCountEnable <= '0';
                RegisterNumber <= to_unsigned(0, 3);
                PpmOutput <= '0';
                State <= x"00000000";
                NS <= IDLE_SYNC;
                CountResetTmp <= '1';
                FrameCountResetTmp <= '1';
            
            when IDLE_SYNC =>
                CountEnable <= '1';
                FrameCountEnable <= '1';
                RegisterNumber <= to_unsigned(6, 3);
                PpmOutput <= '0';
                State <= x"00000001";
                if (TopReached = '0') then
                    NS <= IDLE_SYNC;
                    CountResetTmp <= '0';
                    FrameCountResetTmp <= '0';
                else
                    NS <= PULSE_A;
                    CountResetTmp <= '1';
                    FrameCountResetTmp <= '0';
                end if;
                    
            when PULSE_A =>
                CountEnable <= '1';
                FrameCountEnable <= '1';
                RegisterNumber <= to_unsigned(0, 3);
                PpmOutput <= '1';
                State <= x"00000002";
                if (TopReached = '0') then
                    NS <= PULSE_A;
                    CountResetTmp <= '0';
                    FrameCountResetTmp <= '0';
                else
                    NS <= IDLE_A;
                    CountResetTmp <= '1';
                    FrameCountResetTmp <= '0';
                end if;
                
            when IDLE_A =>
                CountEnable <= '1';
                FrameCountEnable <= '1';
                RegisterNumber <= to_unsigned(6, 3);
                PpmOutput <= '0';
                State <= x"00000003";
                if (TopReached = '0') then
                    NS <= IDLE_A;
                    CountResetTmp <= '0';
                    FrameCountResetTmp <= '0';
                else
                    NS <= PULSE_B;
                    CountResetTmp <= '1';
                    FrameCountResetTmp <= '0';
                end if;
                
            when PULSE_B=>
                CountEnable <= '1';
                FrameCountEnable <= '1';
                RegisterNumber <= to_unsigned(1, 3);
                PpmOutput <= '1';
                State <= x"00000004";
                if (TopReached = '0') then
                    NS <= PULSE_B;
                    CountResetTmp <= '0';
                    FrameCountResetTmp <= '0';
                else
                    NS <= IDLE_B;
                    CountResetTmp <= '1';
                    FrameCountResetTmp <= '0';
                end if;
                
            when IDLE_B =>
                CountEnable <= '1';
                FrameCountEnable <= '1';
                RegisterNumber <= to_unsigned(6, 3);
                PpmOutput <= '0';
                State <= x"00000005";
                if (TopReached = '0') then
                    NS <= IDLE_B;
                    CountResetTmp <= '0';
                    FrameCountResetTmp <= '0';
                else
                    NS <= PULSE_C;
                    CountResetTmp <= '1';
                    FrameCountResetTmp <= '0';
                end if;
    --
            when PULSE_C =>
                CountEnable <= '1';
                FrameCountEnable <= '1';
                RegisterNumber <= to_unsigned(2, 3);
                PpmOutput <= '1';
                State <= x"00000006";
                if (TopReached = '0') then
                    NS <= PULSE_C;
                    CountResetTmp <= '0';
                    FrameCountResetTmp <= '0';
                else
                    NS <= IDLE_C;
                    CountResetTmp <= '1';
                    FrameCountResetTmp <= '0';
                end if;
                
            when IDLE_C =>
                CountEnable <= '1';
                FrameCountEnable <= '1';
                RegisterNumber <= to_unsigned(6, 3);
                PpmOutput <= '0';
                State <= x"00000007";
                if (TopReached = '0') then
                    NS <= IDLE_C;
                    CountResetTmp <= '0';
                    FrameCountResetTmp <= '0';
                else
                    NS <= PULSE_D;
                    CountResetTmp <= '1';
                    FrameCountResetTmp <= '0';
                end if;
                
            when PULSE_D =>
                CountEnable <= '1';
                FrameCountEnable <= '1';
                RegisterNumber <= to_unsigned(3, 3);
                PpmOutput <= '1';      
                State <= x"00000008";          
                if (TopReached = '0') then
                    NS <= PULSE_D;
                    CountResetTmp <= '0';
                    FrameCountResetTmp <= '0';
                else
                    NS <= IDLE_D;
                    CountResetTmp <= '1';
                    FrameCountResetTmp <= '0';
                end if;
                
            when IDLE_D =>
                CountEnable <= '1';
                FrameCountEnable <= '1';
                RegisterNumber <= to_unsigned(6, 3);
                PpmOutput <= '0';
                State <= x"00000009";
                if (TopReached = '0') then
                    NS <= IDLE_D;
                    CountResetTmp <= '0';
                    FrameCountResetTmp <= '0';
                else
                    NS <= PULSE_E;
                    CountResetTmp <= '1';
                    FrameCountResetTmp <= '0';
                end if;
                
            when PULSE_E =>
                CountEnable <= '1';
                FrameCountEnable <= '1';
                RegisterNumber <= to_unsigned(4, 3);
                PpmOutput <= '1';
                State <= x"0000000A";
                if (TopReached = '0') then
                    NS <= PULSE_E;
                    CountResetTmp <= '0';
                    FrameCountResetTmp <= '0';
                else
                    NS <= IDLE_E;
                    CountResetTmp <= '1';
                    FrameCountResetTmp <= '0';
                end if;
                
            when IDLE_E =>
                CountEnable <= '1';
                FrameCountEnable <= '1';
                RegisterNumber <= to_unsigned(6, 3);
                PpmOutput <= '0';
                State <= x"0000000B";
                if (TopReached = '0') then
                    NS <= IDLE_E;
                    CountResetTmp <= '0';
                    FrameCountResetTmp <= '0';
                else
                    NS <= PULSE_F;
                    CountResetTmp <= '1';
                    FrameCountResetTmp <= '0';
                end if;
                
            when PULSE_F =>
                CountEnable <= '1';
                FrameCountEnable <= '1';
                RegisterNumber <= to_unsigned(5, 3);
                PpmOutput <= '1';
                State <= x"0000000C";
                if (TopReached = '0') then
                    NS <= PULSE_F;
                    CountResetTmp <= '0';
                    FrameCountResetTmp <= '0';
                else
                    NS <= IDLE_F;
                    CountResetTmp <= '1';
                    FrameCountResetTmp <= '0';
                end if;
                
            when IDLE_F =>
                CountEnable <= '1';
                FrameCountEnable <= '1';
                RegisterNumber <= to_unsigned(6, 3);
                PpmOutput <= '0';
                State <= x"0000000D";
                if (TopReached = '0') then
                    NS <= IDLE_F;
                    CountResetTmp <= '0';
                    FrameCountResetTmp <= '0';
                else
                    NS <= SYNC;
                    CountResetTmp <= '1';
                    FrameCountResetTmp <= '0';
                end if;
                
            when SYNC =>
                CountEnable <= '0';
                FrameCountEnable <= '1';
                RegisterNumber <= to_unsigned(0, 3);
                PpmOutput <= '1';
                State <= x"0000000E";
                if (FrameOver = '0') then
                    NS <= SYNC;
                    CountResetTmp <= '0';
                    FrameCountResetTmp <= '0';
                else 
                    NS <= IDLE_SYNC;
                    CountResetTmp <= '1';
                    FrameCountResetTmp <= '1';
                end if;
            when others => 
                NS <= RESET_STATE;
        end case;
    end process comb_proc;

end Behavioral;

