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
--   Reset                        -- reset all registers
--   Value                        -- value to store in the temp registers
--   RegNum                       -- register to store value in      
--   Latch                        -- latch the current Value in the Register temp register
--   LatchAll                     -- latch all temp registers into the main register file
--   ChannelA                     -- output to the Channel A register
--   ChannelB                     -- output to the Channel B register
--   ChannelC                     -- output to the Channel C register
--   ChannelD                     -- output to the Channel D register
--   ChannelE                     -- output to the Channel E register
--   ChannelF                     -- output to the Channel F register
------------------------------------------------------------------------------

entity temp_registers is
    port
    (
        Clock                       : in std_logic;
        Reset                       : in std_logic;
        Value                       : in unsigned(31 downto 0);
        RegNum                      : in unsigned(7 downto 0);
        Latch                       : in std_logic;             
        LatchAll                    : in std_logic;
        ChannelA                    : out std_logic_vector(31 downto 0);
        ChannelB                    : out std_logic_vector(31 downto 0);
        ChannelC                    : out std_logic_vector(31 downto 0);
        ChannelD                    : out std_logic_vector(31 downto 0);
        ChannelE                    : out std_logic_vector(31 downto 0);
        ChannelF                    : out std_logic_vector(31 downto 0)
    );

    attribute SIGIS of Clock        : signal is "CLK";
end entity temp_registers;


architecture IMP of temp_registers is
    signal temp_a                   : std_logic_vector(31 downto 0);
    signal temp_b                   : std_logic_vector(31 downto 0);
    signal temp_c                   : std_logic_vector(31 downto 0);
    signal temp_d                   : std_logic_vector(31 downto 0);
    signal temp_e                   : std_logic_vector(31 downto 0);
    signal temp_f                   : std_logic_vector(31 downto 0);
    signal out_a                    : std_logic_vector(31 downto 0);
    signal out_b                    : std_logic_vector(31 downto 0);
    signal out_c                    : std_logic_vector(31 downto 0);
    signal out_d                    : std_logic_vector(31 downto 0);
    signal out_e                    : std_logic_vector(31 downto 0);
    signal out_f                    : std_logic_vector(31 downto 0);
    
    begin
        temp_registers_proc: process(Clock, Reset)
        begin
            if(Reset = '1') then
                temp_a <= (others => '0');
                temp_b <= (others => '0');
                temp_c <= (others => '0');
                temp_d <= (others => '0');
                temp_e <= (others => '0');
                temp_f <= (others => '0');
                out_a <= (others => '0');
                out_b <= (others => '0');
                out_c <= (others => '0');
                out_d <= (others => '0');
                out_e <= (others => '0');
                out_f <= (others => '0');
            elsif(rising_edge(Clock)) then
                if(Latch = '1') then
                    case RegNum is
                        when 0 =>
                            temp_a <= std_logic_vector(Value);
                        when 1 =>
                            temp_b <= std_logic_vector(Value);
                        when 2 =>
                            temp_c <= std_logic_vector(Value);
                        when 3 =>
                            temp_d <= std_logic_vector(Value);
                        when 4 =>
                            temp_e <= std_logic_vector(Value);
                        when 5 =>
                            temp_f <= std_logic_vector(Value);
                        when others =>
                    end case;
                end if
                if(LatchAll = '1') then
                    out_a = temp_a;
                    out_b = temp_b;
                    out_c = temp_c;
                    out_d = temp_d;
                    out_e = temp_e;
                    out_f = temp_f;
                end if 
            end if
        end process

        ChannelA <= out_a;
        ChannelB <= out_b;
        ChannelC <= out_c;
        ChannelD <= out_d;
        ChannelE <= out_e;
        ChannelF <= out_f;

end IMP

