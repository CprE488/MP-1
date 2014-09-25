--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:56:24 09/24/2014
-- Design Name:   
-- Module Name:   /home/vens/classes/Fall2014/cpre488/labs/mp1/MP-1/system/pcores/axi_ppm_v1_00_a/hdl/vhdl/Testbenches/tb_capture_ppm.vhd
-- Project Name:  axi_ppm
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: capture_ppm
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
 
ENTITY tb_capture_ppm IS
END tb_capture_ppm;
 
ARCHITECTURE behavior OF tb_capture_ppm IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT capture_ppm
    PORT(
         Clock : IN  std_logic;
         Reset : IN  std_logic;
         Ppm : IN  std_logic;
         Sync : IN  std_logic;
         CountReset : OUT  std_logic;
         CountEnable : OUT  std_logic;
         FrameFinished : OUT  std_logic;
         State : OUT  std_logic_vector(31 downto 0);
         RegisterNumber : OUT  std_logic_vector(2 downto 0);
         RegisterLatch : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Clock : std_logic := '0';
   signal Reset : std_logic := '0';
   signal Ppm : std_logic := '0';
   signal Sync : std_logic := '0';

 	--Outputs
   signal CountReset : std_logic;
   signal CountEnable : std_logic;
   signal FrameFinished : std_logic;
   signal State : std_logic_vector(31 downto 0);
   signal RegisterNumber : std_logic_vector(2 downto 0);
   signal RegisterLatch : std_logic;

   -- Clock period definitions
   constant Clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: capture_ppm PORT MAP (
          Clock => Clock,
          Reset => Reset,
          Ppm => Ppm,
          Sync => Sync,
          CountReset => CountReset,
          CountEnable => CountEnable,
          FrameFinished => FrameFinished,
          State => State,
          RegisterNumber => RegisterNumber,
          RegisterLatch => RegisterLatch
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

      wait for Clock_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
