-- TestBench Template 

  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

  ENTITY testbench IS
  END testbench;

  ARCHITECTURE behavior OF testbench IS 

  -- Component Declaration
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

           signal Clock :  STD_LOGIC := '0';
           signal Reset : STD_LOGIC := '1';
           signal RegisterNumber :  UNSIGNED(2 downto 0) := (others => '0');
           signal IdleLength :  STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
           signal ChannelA :  STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
           signal ChannelB :  STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
           signal ChannelC :  STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
           signal ChannelD :  STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
           signal ChannelE :  STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
           signal ChannelF :  STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
           signal Value :  UNSIGNED(31 downto 0);
          
-- Clock period definitions
   constant Clock_period : time := 10 ns;
 
  BEGIN
  -- Component Instantiation
          uut: read_registers PORT MAP(
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
                  Value => Value
          );
          
 -- Clock process definitions
   Clock_process :process
   begin
		Clock <= '0';
		wait for Clock_period/2;
		Clock <= '1';
		wait for Clock_period/2;
   end process;

  --  Test Bench Statements
     tb : PROCESS
     BEGIN
        Reset <= '1';
        wait for 100 ns; -- wait until global set/reset completes
        IdleLength <= X"000000A0";
        ChannelA <=   X"12345678";
        ChannelB <=   X"87654321";
        ChannelC <=   X"11111111";
        ChannelD <=   X"42424242";
        ChannelE <=   X"ABCDEFAB";
        ChannelF <=   X"BADBEEF1";
        Reset <= '0';
        
        RegisterNumber <= to_unsigned(0, 3);
        wait for 100 ns;
        assert (Value = unsigned(ChannelA)) report "Error" severity error;
        
        RegisterNumber <= to_unsigned(1, 3);
        wait for 100 ns;
        assert (Value = unsigned(ChannelB)) report "Error" severity error;
        
        RegisterNumber <= to_unsigned(6, 3);
        wait for 100 ns;
        assert (Value = unsigned(IdleLength)) report "Error" severity error;
        
        RegisterNumber <= to_unsigned(2, 3);
        wait for 100 ns;
        assert (Value = unsigned(ChannelC)) report "Error" severity error;
        
        RegisterNumber <= to_unsigned(3, 3);
        wait for 100 ns;
        assert (Value = unsigned(ChannelD)) report "Error" severity error;
        
        RegisterNumber <= to_unsigned(6, 3);
        wait for 100 ns;
        assert (Value = unsigned(IdleLength)) report "Error" severity error;
        
        RegisterNumber <= to_unsigned(4, 3);
        wait for 100 ns;
        assert (Value = unsigned(ChannelE)) report "Error" severity error;
        
        RegisterNumber <= to_unsigned(5, 3);
        wait for 100 ns;
        assert (Value = unsigned(ChannelF)) report "Error" severity error;
        
        RegisterNumber <= to_unsigned(6, 3);
        wait for 100 ns;
        assert (Value = unsigned(IdleLength)) report "Error" severity error;
        
        RegisterNumber <= to_unsigned(0, 3);
        wait for 100 ns;
        assert (Value = unsigned(ChannelA)) report "Error" severity error;
        
        -- Add user defined stimulus here

        wait; -- will wait forever
     END PROCESS tb;
  --  End Test Bench 

  END;
