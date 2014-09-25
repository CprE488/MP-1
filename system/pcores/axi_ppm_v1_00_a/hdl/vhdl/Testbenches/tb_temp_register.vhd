--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:34:21 09/24/2014
-- Design Name:   
-- Module Name:   /home/vens/classes/Fall2014/cpre488/labs/mp1/MP-1/system/pcores/axi_ppm_v1_00_a/hdl/vhdl/Testbenches/tb_temp_register.vhd
-- Project Name:  axi_ppm
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: temp_registers
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
 
ENTITY tb_temp_register IS
END tb_temp_register;
 
ARCHITECTURE behavior OF tb_temp_register IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT temp_registers
    PORT(
         Clock : IN  std_logic;
         Reset : IN  std_logic;
         Value : IN  unsigned(31 downto 0);
         RegisterNumber : IN  unsigned(2 downto 0);
         RegisterLatch : IN  std_logic;
         LatchAll : IN  std_logic;
         ChannelA : OUT  std_logic_vector(31 downto 0);
         ChannelB : OUT  std_logic_vector(31 downto 0);
         ChannelC : OUT  std_logic_vector(31 downto 0);
         ChannelD : OUT  std_logic_vector(31 downto 0);
         ChannelE : OUT  std_logic_vector(31 downto 0);
         ChannelF : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Clock : std_logic := '0';
   signal Reset : std_logic := '1';
   signal Value : unsigned(31 downto 0) := (others => '0');
   signal RegisterNumber : unsigned(2 downto 0) := (others => '0');
   signal RegisterLatch : std_logic := '0';
   signal LatchAll : std_logic := '0';

 	--Outputs
   signal ChannelA : std_logic_vector(31 downto 0);
   signal ChannelB : std_logic_vector(31 downto 0);
   signal ChannelC : std_logic_vector(31 downto 0);
   signal ChannelD : std_logic_vector(31 downto 0);
   signal ChannelE : std_logic_vector(31 downto 0);
   signal ChannelF : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant Clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: temp_registers PORT MAP (
          Clock => Clock,
          Reset => Reset,
          Value => Value,
          RegisterNumber => RegisterNumber,
          RegisterLatch => RegisterLatch,
          LatchAll => LatchAll,
          ChannelA => ChannelA,
          ChannelB => ChannelB,
          ChannelC => ChannelC,
          ChannelD => ChannelD,
          ChannelE => ChannelE,
          ChannelF => ChannelF
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
        Value <= to_unsigned(42, 32);
        RegisterNumber <= to_unsigned(0, 3);
      wait for Clock_period*10;
        RegisterLatch <= '1';      
      wait for Clock_period;      
        RegisterLatch <= '0';        
      wait for Clock_period;

        Value <= to_unsigned(23, 32);
        RegisterNumber <= to_unsigned(1, 3);
      wait for Clock_period*10;
        RegisterLatch <= '1';      
      wait for Clock_period;      
        RegisterLatch <= '0';        
      wait for Clock_period;

        Value <= to_unsigned(17, 32);
        RegisterNumber <= to_unsigned(2, 3);
      wait for Clock_period*10;
        RegisterLatch <= '1';      
      wait for Clock_period;      
        RegisterLatch <= '0';        
      wait for Clock_period;

        Value <= to_unsigned(18473, 32);
        RegisterNumber <= to_unsigned(3, 3);
      wait for Clock_period*10;
        RegisterLatch <= '1';      
      wait for Clock_period;      
        RegisterLatch <= '0';        
      wait for Clock_period;

        Value <= to_unsigned(283928, 32);
        RegisterNumber <= to_unsigned(4, 3);
      wait for Clock_period*10;
        RegisterLatch <= '1';      
      wait for Clock_period;      
        RegisterLatch <= '0';        
      wait for Clock_period;

        Value <= to_unsigned(2843, 32);
        RegisterNumber <= to_unsigned(5, 3);
      wait for Clock_period*10;
        RegisterLatch <= '1';      
      wait for Clock_period;      
        RegisterLatch <= '0';        
      wait for Clock_period;

      wait for Clock_period*10;
        LatchAll <= '1';      
      wait for Clock_period;      
        LatchAll <= '0';        
      -- insert stimulus here 

      wait;
   end process;
 
END;
