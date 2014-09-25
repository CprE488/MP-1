--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:57:06 09/24/2014
-- Design Name:   
-- Module Name:   /home/vens/classes/Fall2014/cpre488/labs/mp1/MP-1/system/pcores/axi_ppm_v1_00_a/hdl/vhdl/tb_generate_ppm.vhd
-- Project Name:  axi_ppm
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: generate_ppm
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
 
ENTITY tb_generate_ppm IS
END tb_generate_ppm;
 
ARCHITECTURE behavior OF tb_generate_ppm IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT generate_ppm
    PORT(
         Clock : IN  std_logic;
         Reset : IN  std_logic;
         TopReached : IN  std_logic;
         FrameOver : IN  std_logic;
         FrameCountReset : OUT  std_logic;
         FrameCountEnable : OUT  std_logic;
         CountReset : OUT  std_logic;
         CountEnable : OUT  std_logic;
         RegisterNumber : OUT  UNSIGNED(2 downto 0);
         State : OUT  std_logic_vector(31 downto 0);
         PpmOutput : OUT  std_logic
        );
    END COMPONENT;
    
    COMPONENT counter
    PORT(
         Clock : IN  std_logic;
         Reset : IN  std_logic;
         Enable : IN  std_logic;
         Top : IN  unsigned(31 downto 0);
         Count : OUT  unsigned(31 downto 0);
         TopReached : OUT  std_logic
        );
    END COMPONENT;

    COMPONENT read_registers
          PORT(Clock : in  STD_LOGIC;
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
          END COMPONENT;

   --Inputs
   signal Clock : std_logic := '0';
   signal Reset : std_logic := '1';
   signal TopReached : std_logic := '0';
   signal FrameOver : std_logic := '0';

 	--Outputs
   signal FrameCountReset : std_logic;
   signal FrameCountEnable : std_logic;
   signal CountReset : std_logic;
   signal CountEnable : std_logic;
   signal RegisterNumber : unsigned(2 downto 0);
   signal State : std_logic_vector(31 downto 0);
   signal PpmOut : std_logic;
    
    signal RegisterValue : unsigned(31 downto 0);
    signal FrameLengthConst : unsigned(31 downto 0);
    signal IdleLength :  STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal ChannelA :  STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal ChannelB :  STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
           signal ChannelC :  STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
           signal ChannelD :  STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
           signal ChannelE :  STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
           signal ChannelF :  STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    
    signal dummy1 : std_logic_vector(31 downto 0);
    signal dummy2 : std_logic_vector(31 downto 0);
   -- Clock period definitions
   constant Clock_period : time := 10 ns;
 
BEGIN
    
	-- Instantiate the Unit Under Test (UUT)
   uut: generate_ppm PORT MAP (
          Clock => Clock,
          Reset => Reset,
          TopReached => TopReached,
          FrameOver => FrameOver,
          FrameCountReset => FrameCountReset,
          FrameCountEnable => FrameCountEnable,
          CountReset => CountReset,
          CountEnable => CountEnable,
          RegisterNumber => RegisterNumber,
          State => State,
          PpmOutput => PpmOut
        );

    counter3: counter PORT MAP (
          Clock => Clock,
          Reset => FrameCountReset,
          Enable => FrameCountEnable,
          Top => FrameLengthConst,
          Count => open,
          TopReached => FrameOver
    );
    
    counter2: counter PORT MAP (
          Clock => Clock,
          Reset => CountReset,
          Enable => CountEnable,
          Top => RegisterValue,
          Count => open,
          TopReached => TopReached
    );

    read_reg: read_registers PORT MAP(
                  Clock => Clock,
                  Reset => Reset,
                  RegisterNumber => RegisterNumber,
                  IdleLength => IdleLength,
                  ChannelA => ChannelA,
                  ChannelB => ChannelB,
                  ChannelC => ChannelC,
                  ChannelD => ChannelD,
                  ChannelE => ChannelE,
                  ChannelF => ChannelF,
                  Value => RegisterValue
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
      FrameLengthConst <= to_unsigned(2000000 ,32);
      ChannelA <= x"00030D40";
      ChannelB <= x"0003D090";
      ChannelC <= x"00030D40";
      ChannelD <= x"000186A0";
      ChannelE <= x"00030D40";
      ChannelF <= x"00030D40";
      IdleLength <= x"00000FA0";
      Reset <= '0';

      -- insert stimulus here 

      wait;
   end process;

END;
