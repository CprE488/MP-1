----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:14:50 09/23/2014 
-- Design Name: 
-- Module Name:    counter - Behavioral 
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

entity counter is
    Port ( Clock : in  STD_LOGIC;
           Reset : in  STD_LOGIC;
           Enable : in  STD_LOGIC;
           Top : in  UNSIGNED(31 downto 0);
           Count : out  UNSIGNED(31 downto 0);
           TopReached : out  STD_LOGIC);
end counter;

architecture Behavioral of counter is
    signal timer_count              : unsigned(31 downto 0);
    signal top_signal               : std_logic;
    begin
        counter_proc: process(Clock, Reset)
        begin
            if(Reset = '1') then
                timer_count <= (others => '0');
                top_signal <= '0';
            elsif(rising_edge(Clock)) then
                if(Enable = '1') then
                    timer_count <= timer_count + 1;
                end if;
                if(timer_count >= Top) then
                    top_signal <= '1';
                else
                    top_signal <= '0';
                end if;
            end if;
       end process;
       
       Count <= timer_count;
       TopReached <= top_signal;
end Behavioral;

