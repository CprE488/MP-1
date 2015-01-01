-- TestBench Template 

  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

  ENTITY tb_user_logic IS
  END tb_user_logic;

  ARCHITECTURE behavior OF tb_user_logic IS 

  -- Component Declaration
          COMPONENT user_logic
            generic
  (
    -- ADD USER GENERICS BELOW THIS LINE ---------------
    --USER generics added here
    -- ADD USER GENERICS ABOVE THIS LINE ---------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol parameters, do not add to or delete
    C_NUM_REG                      : integer              := 32;
    C_SLV_DWIDTH                   : integer              := 32
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );
          PORT(
    -- ADD USER PORTS BELOW THIS LINE ------------------
    PpmIn                           : in std_logic;
    PpmOut                          : out std_logic;
    -- ADD USER PORTS ABOVE THIS LINE ------------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol ports, do not add to or delete
    Bus2IP_Clk                     : in  std_logic;
    Bus2IP_Resetn                  : in  std_logic;
    Bus2IP_Data                    : in  std_logic_vector(32-1 downto 0);
    Bus2IP_BE                      : in  std_logic_vector(32/8-1 downto 0);
    Bus2IP_RdCE                    : in  std_logic_vector(32-1 downto 0);
    Bus2IP_WrCE                    : in  std_logic_vector(32-1 downto 0);
    IP2Bus_Data                    : out std_logic_vector(32-1 downto 0);
    IP2Bus_RdAck                   : out std_logic;
    IP2Bus_WrAck                   : out std_logic;
    IP2Bus_Error                   : out std_logic
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );
          END COMPONENT;

          SIGNAL PpmIn :  std_logic := '0';
          SIGNAL PpmOut :  std_logic;
          SIGNAL Bus2IP_Clk                     : std_logic;
    SIGNAL Bus2IP_Resetn                  :   std_logic := '0';
    SIGNAL Bus2IP_Data                    :   std_logic_vector(32-1 downto 0) := (others => '0');
    SIGNAL Bus2IP_BE                      :   std_logic_vector(32/8-1 downto 0) := (others => '0');
    SIGNAL Bus2IP_RdCE                    :   std_logic_vector(32-1 downto 0) := (others => '0');
    SIGNAL Bus2IP_WrCE                    :   std_logic_vector(32-1 downto 0) := (others => '0');
    SIGNAL IP2Bus_Data                    :  std_logic_vector(32-1 downto 0) := (others => '0');
    SIGNAL IP2Bus_RdAck                   :  std_logic;
    SIGNAL IP2Bus_WrAck                   :  std_logic;
    SIGNAL IP2Bus_Error                   :  std_logic;
          
    -- Clock period definitions
   constant Clock_period : time := 10 ns;      

  BEGIN

  -- Component Instantiation
          uut: user_logic PORT MAP(
                  PpmIn => PpmIn,
                  PpmOut => PpmOut,
                  Bus2IP_Clk => Bus2IP_Clk,
                  Bus2IP_Resetn => Bus2IP_Resetn,
                  Bus2IP_Data => Bus2IP_Data,
                  Bus2IP_BE => Bus2IP_BE,
                  Bus2IP_RdCE => Bus2IP_RdCE,
                  Bus2IP_WrCE => Bus2IP_WrCE,
                  IP2Bus_Data => IP2Bus_Data,
                  IP2Bus_RdAck => IP2Bus_RdAck,
                  IP2Bus_WrAck => IP2Bus_WrAck,
                  IP2Bus_Error => IP2Bus_Error
          );
          
   -- Clock process definitions
   Clock_process :process
   begin
		Bus2IP_Clk <= '0';
		wait for Clock_period/2;
		Bus2IP_Clk <= '1';
		wait for Clock_period/2;
   end process;

   Ppm_process: process
   begin
            PpmIn <= '1';
        wait for 2 ms;
            PpmIn <= '0';
        wait for 500 us;
            PpmIn <= '1';
        wait for 1500 us;
            PpmIn <= '0';
        wait for 500 us;
            PpmIn <= '1';
        wait for 2500 us;
            PpmIn <= '0';
        wait for 500 us;
            PpmIn <= '1';
        wait for 2500 us;
            PpmIn <= '0';
        wait for 500 us;
            PpmIn <= '1';
        wait for 2500 us;
            PpmIn <= '0';
        wait for 500 us;
            PpmIn <= '1';
        wait for 13000 us;
            PpmIn <= '0';
        wait for 500 us;
   end process;

  --  Test Bench Statements
     tb : PROCESS
     BEGIN
        wait for 100 ns; -- wait until global set/reset completes
            Bus2IP_Resetn <= '1';
            Bus2IP_WrCE <= "10000000000000000000000000000000";
            Bus2IP_Data <= "00000000000000000000000000000001";--(others => '0');
            Bus2IP_BE <= "1111";
        wait for Clock_period;
            Bus2IP_WrCE <= "00000000000000000000000000000000";
            
            
            
        
        -- Add user defined stimulus here

        wait; -- will wait forever
     END PROCESS tb;
  --  End Test Bench 

  END;
