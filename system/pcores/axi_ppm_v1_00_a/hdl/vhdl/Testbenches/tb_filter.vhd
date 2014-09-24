--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:37:30 09/23/2014
-- Design Name:   
-- Module Name:   /home/vens/classes/Fall2014/cpre488/labs/mp1/MP-1/system/pcores/axi_ppm_v1_00_a/hdl/vhdl/Testbenches/tb_filter.vhd
-- Project Name:  axi_ppm
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: filter
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
--USE ieee.numeric_std.ALL;
 
ENTITY tb_filter IS
END tb_filter;
 
ARCHITECTURE behavior OF tb_filter IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT filter
    PORT(
         Clock : IN  std_logic;
         Reset : IN  std_logic;
         DataIn : IN  std_logic;
         DataOut : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Clock : std_logic := '0';
   signal Reset : std_logic := '1';
   signal DataIn : std_logic := '0';

 	--Outputs
   signal DataOut : std_logic;

   -- Clock period definitions
   constant Clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: filter PORT MAP (
          Clock => Clock,
          Reset => Reset,
          DataIn => DataIn,
          DataOut => DataOut
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
      wait for 100 ns;	
      Reset <= '0';
      
      DataIn <= '1';
      wait for Clock_period*50;
      assert (DataOut = '1') report "DataOut != 1" severity error;

      DataIn <= '0';
      wait for Clock_period*50;
      assert (DataOut = '0') report "DataOut != 0" severity error;

      DataIn <= '1';
      wait for Clock_period*10;
      assert (DataOut = '0') report "Changed too soon" severity error;

      DataIn <= '0';
      wait for Clock_period*10;
      assert (DataOut = '0') report "Not a clue what happend" severity error;

      DataIn <= '1';
      wait for Clock_period*50;
      assert (DataOut = '1') report "Didn't go high" severity error;

      DataIn <= '0';
      wait for Clock_period*2;
      assert (DataOut = '1') report "Changed on noise" severity error;

      wait for Clock_period*48;
      assert (DataOut = '0') report "Didn't go high" severity error;

      wait;
   end process;

END;
