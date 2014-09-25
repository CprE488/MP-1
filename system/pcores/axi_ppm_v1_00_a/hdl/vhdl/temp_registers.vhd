----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:28:05 09/24/2014 
-- Design Name: 
-- Module Name:    temp_registers - Behavioral 
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

entity temp_registers is
    Port ( Clock : in  STD_LOGIC;
           Reset : in  STD_LOGIC;
           Value : in  UNSIGNED(31 downto 0);
           RegisterNumber : in  UNSIGNED(2 downto 0);
           RegisterLatch : in  STD_LOGIC;
           LatchAll : in  STD_LOGIC;
           ChannelA : out  STD_LOGIC_VECTOR(31 downto 0);
           ChannelB : out  STD_LOGIC_VECTOR(31 downto 0);
           ChannelC : out  STD_LOGIC_VECTOR(31 downto 0);
           ChannelD : out  STD_LOGIC_VECTOR(31 downto 0);
           ChannelE : out  STD_LOGIC_VECTOR(31 downto 0);
           ChannelF : out  STD_LOGIC_VECTOR(31 downto 0));
end temp_registers;

architecture Behavioral of temp_registers is
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
                if(RegisterLatch = '1') then
                    case to_integer(RegisterNumber) is
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
                        when others => null;
                    end case;
                end if;
                if(LatchAll = '1') then
                    out_a <= temp_a;
                    out_b <= temp_b;
                    out_c <= temp_c;
                    out_d <= temp_d;
                    out_e <= temp_e;
                    out_f <= temp_f;
                end if;
            end if;
        end process;

        ChannelA <= out_a;
        ChannelB <= out_b;
        ChannelC <= out_c;
        ChannelD <= out_d;
        ChannelE <= out_e;
        ChannelF <= out_f;

end Behavioral;

