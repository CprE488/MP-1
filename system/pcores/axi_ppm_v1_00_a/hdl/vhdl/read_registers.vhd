----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:15:01 09/24/2014 
-- Design Name: 
-- Module Name:    read_registers - Behavioral 
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

entity read_registers is
    Port ( Clock : in  STD_LOGIC;
           Reset : in STD_LOGIC;
           RegisterNumber : in  UNSIGNED(2 downto 0);
           IdleLength : in  STD_LOGIC_VECTOR(31 downto 0);
           ChannelA : in  STD_LOGIC_VECTOR(31 downto 0);
           ChannelB : in  STD_LOGIC_VECTOR(31 downto 0);
           ChannelC : in  STD_LOGIC_VECTOR(31 downto 0);
           ChannelD : in  STD_LOGIC_VECTOR(31 downto 0);
           ChannelE : in  STD_LOGIC_VECTOR(31 downto 0);
           ChannelF : in  STD_LOGIC_VECTOR(31 downto 0);
           Value : out  UNSIGNED(31 downto 0));
end read_registers;

architecture Behavioral of read_registers is
    signal out_value : std_logic_vector(31 downto 0);
    begin
        read_registers_proc: process(Clock, Reset)
        begin
            if(Reset = '1') then
                out_value(31 downto 0) <= (others => '0');
            elsif(rising_edge(Clock)) then
                case to_integer(RegisterNumber) is
                    when 6 =>
                        out_value <= IdleLength;
                    when 0 =>
                        out_value <= ChannelA;
                    when 1 =>
                        out_value <= ChannelB;
                    when 2 =>
                        out_value <= ChannelC;
                    when 3 =>
                        out_value <= ChannelD;
                    when 4 =>
                        out_value <= ChannelE;
                    when 5 =>
                        out_value <= ChannelF;
                    when others =>
                        out_value <= (others => '0');
                end case;
            end if;
        end process; 
        
        Value <= unsigned(out_value);
end Behavioral;

