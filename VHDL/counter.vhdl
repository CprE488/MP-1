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
--   Reset                        -- reset count
--   Enable                       -- enable the counters count
--   Top                          -- top value to raise TopReached on
--   Count                        -- the current count value
--   TopReached                   -- raised when the counter is at or above Top value
------------------------------------------------------------------------------

entity counter is
    port
    (
        Clock                       : in std_logic;
        Reset                       : in std_logic;
        Enable                      : in std_logic;
        Top                         : in unsigned(31 downto 0);
        Count                       : out unsigned(31 downto 0);
        TopReached                  : out std_logic
    );

    attribute SIGIS of Clock        : signal is "CLK";
end entity counter;



architecture IMP of counter is
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
                end if
                if(timer_count >= Top) then
                    top_signal <= '1';
                else
                    top_signal <= '0';
                end if
            end if
       end process
       
       Count <= timer_count;
       TopReached <= top_signal;

end IMP

