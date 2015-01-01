--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:29:38 09/23/2014
-- Design Name:   
-- Module Name:   /home/vens/classes/Fall2014/cpre488/labs/mp1/MP-1/system/pcores/axi_ppm_v1_00_a/hdl/vhdl/Testbenches/tb_counter.vhd
-- Project Name:  axi_ppm
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: counter
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;
 
ENTITY tb_counter IS
END tb_counter;
 
ARCHITECTURE behavior OF tb_counter IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT vens_counter
    PORT(
         Clock : IN  std_logic;
         Reset : IN  std_logic;
         Enable : IN  std_logic;
         Top : IN  unsigned(31 downto 0);
         Count : OUT  unsigned(31 downto 0);
         TopReached : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Clock : std_logic := '0';
   signal Reset : std_logic := '0';
   signal Enable : std_logic := '0';
   signal Top : unsigned(31 downto 0) := (others => '0');

 	--Outputs
   signal Count : unsigned(31 downto 0);
   signal TopReached : std_logic;

   -- Clock period definitions
   constant Clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: vens_counter PORT MAP (
          Clock => Clock,
          Reset => Reset,
          Enable => Enable,
          Top => Top,
          Count => Count,
          TopReached => TopReached
        );

   -- Clock process definitions
   Clock_process :process
   begin
		Clock <= '0';
		wait for Clock_period/2;
		Clock <= '1';
		wait for Clock_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      Reset <= '1';      
      wait for 100 ns;	
      Reset <= '0';

      wait for 100 ns;
      Top <= to_unsigned(50, 32);
      Enable <= '1';

      wait for 600 ns;
      Enable <= '0';

      wait for 100 ns;
      Top <= to_unsigned(1000, 32);

      wait for 100 ns;
      Enable <= '1';

      wait for 100 ns;
      Reset <= '1';

      wait for 100 ns;
      Reset <= '0';

      wait for 100 ns;
      Top <= to_unsigned(10, 32);

      wait for 100 ns;
      Enable <= '0';

      wait;
   end process;

END;
