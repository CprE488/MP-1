----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:19:06 09/23/2014 
-- Design Name: 
-- Module Name:    filter - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity filter is
    generic
    (
        C_NUM_BITS                   : integer              := 32
    );
    Port ( Clock : in  STD_LOGIC;
           Reset : in  STD_LOGIC;
           DataIn : in  STD_LOGIC;
           DataOut : out  STD_LOGIC);
end filter;   

architecture Behavioral of filter is
    signal shift_value              : std_logic_vector(C_NUM_BITS-1 downto 0);
    signal out_sig                  : std_logic;
    
    
    
  -- Test if all the bits in the given vector are 1's
  function all_ones (slv : std_logic_vector) return std_logic is
        variable res_v : std_logic := '1';  -- Null slv vector will also return '1'
        begin
             for i in slv'range loop
                  res_v := res_v and slv(i);
             end loop; 
        return res_v;
  end function;
  
  -- Test if all bits in the given vector are 0's
  function all_zeros (slv : in std_logic_vector) return std_logic is
        variable res_v : std_logic := '0';  -- Null slv vector will also return '1'
        begin
             for i in slv'range loop
                  res_v := res_v or slv(i);
             end loop;
             return not res_v;
  end function;
        
	begin
        -- Turn output LOW if we have recieved C_NUM_BITS 0's and HIGH if we have recieved C_NUM_BITS 1's
        filter_proc: process(Clock, Reset, DataIn)
        begin
            if(Reset = '1') then
                shift_value(C_NUM_BITS-1 downto 0) <= (others => '0');
                out_sig <= '0';
            elsif(rising_edge(Clock)) then
                shift_value <= shift_value(C_NUM_BITS-2 downto 0) & DataIn;
                if(all_ones(shift_value) = '1') then
                    out_sig <= '1';
                elsif(all_zeros(shift_value) = '1') then
                    out_sig <= '0';
                else
                    out_sig <= out_sig;
                end if;
            end if;
       end process;
       
       -- Assign output to the DataOut port
       DataOut <= out_sig;
end Behavioral;

