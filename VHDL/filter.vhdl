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
-- Definition of Generics:
--   C_NUM_BITS                   -- Number of bits to use for the shift register
--
-- Definition of Ports:
--   Clock                        -- clock signal
--   Reset                        -- reset register
--   DataIn                       -- serial input data
--   DataOut                      -- filtered output data
------------------------------------------------------------------------------

entity filter is
    generic
    (
        C_NUM_REG                   : integer              := 32
    );
    port
    (
        Clock                       : in std_logic;
        Reset                       : in std_logic;
        DataIn                      : in std_logic;
        DataOut                     : out std_logic
    );

    attribute SIGIS of Clock        : signal is "CLK";
end entity filter;


architecture IMP of filter is
    signal shift_value              : std_logic_vector(C_NUM_BITS-1 downto 0);
    signal out_sig                  : std_logic
    
    
    begin
        -- Test if all the bits in the given vector are 1's
        function all_ones(slv : in std_logic_vector) return std_logic is
            variable res_v : std_logic := '1';  -- Null slv vector will also return '1'
            begin
                for i in slv'range loop
                    res_v := res_v and slv(i);
                end loop;
            return res_v;
        end function;
        
        -- Test if all bits in the given vector are 0's
        function all_zeros(slv : in std_logic_vector) return std_logic is
            variable res_v : std_logic := '0';  -- Null slv vector will also return '1'
            begin
                for i in slv'range loop
                    res_v := res_v or slv(i);
                end loop;
                return not res_v;
        end function;
        
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
    
end IMP

