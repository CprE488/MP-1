------------------------------------------------------------------------------
-- user_logic.vhd - entity/architecture pair
------------------------------------------------------------------------------
--
-- ***************************************************************************
-- ** Copyright (c) 1995-2012 Xilinx, Inc.  All rights reserved.            **
-- **                                                                       **
-- ** Xilinx, Inc.                                                          **
-- ** XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"         **
-- ** AS A COURTESY TO YOU, SOLELY FOR USE IN DEVELOPING PROGRAMS AND       **
-- ** SOLUTIONS FOR XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE,        **
-- ** OR INFORMATION AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,        **
-- ** APPLICATION OR STANDARD, XILINX IS MAKING NO REPRESENTATION           **
-- ** THAT THIS IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,     **
-- ** AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE      **
-- ** FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY              **
-- ** WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE               **
-- ** IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR        **
-- ** REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF       **
-- ** INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS       **
-- ** FOR A PARTICULAR PURPOSE.                                             **
-- **                                                                       **
-- ***************************************************************************
--
------------------------------------------------------------------------------
-- Filename:          user_logic.vhd
-- Version:           1.00.a
-- Description:       User logic.
-- Date:              Wed Sep 17 15:16:20 2014 (by Create and Import Peripheral Wizard)
-- VHDL Standard:     VHDL'93
------------------------------------------------------------------------------
-- Naming Conventions:
--   active low signals:                    "*_n"
--   clock signals:                         "clk", "clk_div#", "clk_#x"
--   reset signals:                         "rst", "rst_n"
--   generics:                              "C_*"
--   user defined types:                    "*_TYPE"
--   state machine next state:              "*_ns"
--   state machine current state:           "*_cs"
--   combinatorial signals:                 "*_com"
--   pipelined or register delay signals:   "*_d#"
--   counter signals:                       "*cnt*"
--   clock enable signals:                  "*_ce"
--   internal version of output port:       "*_i"
--   device pins:                           "*_pin"
--   ports:                                 "- Names begin with Uppercase"
--   processes:                             "*_PROCESS"
--   component instantiations:              "<ENTITY_>I_<#|FUNC>"
------------------------------------------------------------------------------

-- DO NOT EDIT BELOW THIS LINE --------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library proc_common_v3_00_a;
use proc_common_v3_00_a.proc_common_pkg.all;

-- DO NOT EDIT ABOVE THIS LINE --------------------

--USER libraries added here

------------------------------------------------------------------------------
-- Entity section
------------------------------------------------------------------------------
-- Definition of Generics:
--   C_NUM_REG                    -- Number of software accessible registers
--   C_SLV_DWIDTH                 -- Slave interface data bus width
--
-- Definition of Ports:
--   Bus2IP_Clk                   -- Bus to IP clock
--   Bus2IP_Resetn                -- Bus to IP reset
--   Bus2IP_Data                  -- Bus to IP data bus
--   Bus2IP_BE                    -- Bus to IP byte enables
--   Bus2IP_RdCE                  -- Bus to IP read chip enable
--   Bus2IP_WrCE                  -- Bus to IP write chip enable
--   IP2Bus_Data                  -- IP to Bus data bus
--   IP2Bus_RdAck                 -- IP to Bus read transfer acknowledgement
--   IP2Bus_WrAck                 -- IP to Bus write transfer acknowledgement
--   IP2Bus_Error                 -- IP to Bus error response
------------------------------------------------------------------------------

entity user_logic is
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
  port
  (
    -- ADD USER PORTS BELOW THIS LINE ------------------
    --USER ports added here
    -- ADD USER PORTS ABOVE THIS LINE ------------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol ports, do not add to or delete
    Bus2IP_Clk                     : in  std_logic;
    Bus2IP_Resetn                  : in  std_logic;
    Bus2IP_Data                    : in  std_logic_vector(C_SLV_DWIDTH-1 downto 0);
    Bus2IP_BE                      : in  std_logic_vector(C_SLV_DWIDTH/8-1 downto 0);
    Bus2IP_RdCE                    : in  std_logic_vector(C_NUM_REG-1 downto 0);
    Bus2IP_WrCE                    : in  std_logic_vector(C_NUM_REG-1 downto 0);
    IP2Bus_Data                    : out std_logic_vector(C_SLV_DWIDTH-1 downto 0);
    IP2Bus_RdAck                   : out std_logic;
    IP2Bus_WrAck                   : out std_logic;
    IP2Bus_Error                   : out std_logic
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );

  attribute MAX_FANOUT : string;
  attribute SIGIS : string;

  attribute SIGIS of Bus2IP_Clk    : signal is "CLK";
  attribute SIGIS of Bus2IP_Resetn : signal is "RST";

end entity user_logic;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture IMP of user_logic is

  --USER signal declarations added here, as needed for user logic

  ------------------------------------------
  -- Signals for user logic slave model s/w accessible register example
  ------------------------------------------
  signal reg_control                    : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal reg_capture_count              : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal reg_capture_fsm_state          : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal reg_generage_fsm_state         : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal reg_capture_sync_length        : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal reg_generate_idle_length       : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal reg_generate_frame_length      : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_reg7                       : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_reg8                       : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_reg9                       : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal reg_capture_a                  : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal reg_capture_b                  : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal reg_capture_c                  : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal reg_capture_d                  : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal reg_capture_e                  : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal reg_capture_f                  : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_reg16                      : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_reg17                      : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_reg18                      : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_reg19                      : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal reg_generate_a                 : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal reg_generate_b                 : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal reg_generate_c                 : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal reg_generate_d                 : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal reg_generate_e                 : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal reg_generate_f                 : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_reg26                      : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_reg27                      : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_reg28                      : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_reg29                      : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_reg30                      : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_reg31                      : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_reg_write_sel              : std_logic_vector(31 downto 0);
  signal slv_reg_read_sel               : std_logic_vector(31 downto 0);
  signal slv_ip2bus_data                : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_read_ack                   : std_logic;
  signal slv_write_ack                  : std_logic;

  type gen_state_type is 					  (RESET, SYNC, SYNC_MISS, SYNC_WAIT, IDLE_SYNC, 
														PULSE_A, SAVE_A, IDLE_A, PULSE_B, SAVE_B, IDLE_B,
														PULSE_C, SAVE_C, IDLE_C, PULSE_D, SAVE_D, IDLE_D,
														PULSE_E, SAVE_E, IDLE_E, PULSE_F, SAVE_F, IDLE_F, INC_COUNTER);
  signal gen_count								 : std_logic_vector(31 downto 0);
  signal sync_caught							 : std_logic;
  signal idle_caught							 : std_logic;
  signal count_reset							 : std_logic;
  signal latch_register						 : std_logic;
  signal count_en								 : std_logic;
  signal gen_ps, gen_ns						 : gen_state_type;									
begin

	gen_sync_proc: process(Bus2IP_Clk, gen_ns)
	begin
		if (Bus2IP_resetn = '0') then gen_ps <= RESET;
		elsif (rising_edge(Bus2IP_Clk)) then gen_ps <= gen_ns;
		end if;
	end process gen_sync_proc;
	
	gen_counter: process(Bus2IP_Clk, count_en, count_reset)
	begin
		if(count_reset = 1) then gen_count <= 0; idle_caught <= 0; sync_caught <= 0;
		elsif(rising_edge(Bus2IP_Clk) and count_en = 1) then 
			gen_count <= gen_count + 1;
			if(gen_count > 100) then idle_caught <= 1; --TODO make registers
			end if
			if(gen_count > 1000000) then sync_caught <= 1; --TODO make registers
			end if
		end if
	end process gen_counter;
	
	gen_comb_proc: process(gen_ps, PPM_input, sync_caught, idle_caught)
	begin
		count_en <= 0;
		latch_register <= 0;
		count_reset <= 0;
		case gen_ps is
			when RESET =>
				count_en <= 0;
				if (PPM_input = 0) then gen_ns <= RESET; count_reset <= 0; latch_register <= 0;
				else gen_ns <= SYNC; count_reset <= 1; latch_register <= 0;
				end if
				
			when SYNC =>
				count_en <= 1;
				if (PPM_input = 1 and sync_caught = 0) then gen_ns <= SYNC; count_reset <= 0; latch_register <= 0;
				elsif(PPM_input = 0 and sync_caught = 0) then gen_ns <= SYNC_MISS; count_reset <= 1; latch_register <= 0;
				else gen_ns <= SYNC_WAIT; count_reset <= 1; latch_register <= 0;
			
			when SYNC_MISS =>
				count_en <= 0;
				if(PPM_input = 0) then gen_ns <= SYNC_MISS; count_reset <= 0; latch_register <= 0;
				else gen_ns <= SYNC; count_reset <= 1; latch_register <= 0;
			
			when SYNC_WAIT =>
				count_en <= 0;
				if(PPM_input = 1) then gen_ns <= SYNC_WAIT; count_reset <= 0; latch_register <= 0;
				else gen_ns <= IDLE_SYNC; count_reset <= 0; latch_register <= 0;
			
			when IDLE_SYNC =>
				count_en <= 0;
				if(PPM_input = 0) then gen_ns <= IDLE_SYNC; count_reset <= 0; latch_register <= 0;
				else gen_ns <= PULSE_A; count_reset <= 1; latch_register <= 0;
			
			when PULSE_A =>
				count_en <= 1;
				if(PPM_input = 1) then gen_ns <= PULSE_A; count_reset <= 0; latch_register <= 0;
				else gen_ns <= SAVE_A; count_reset <= 0; latch_register <= 1;
			
			when SAVE_A =>
				count_en <= 0;
				gen_ns <= IDLE_A; count_reset <= 1; latch_register <= 0;
			
			when IDLE_A =>
				count_en <= 1;
				if(PPM_input = 0 or idle_caught = 0) then gen_ns <= IDLE_A; count_reset <= 0; latch_register <= 0;
				else gen_ns <= PULSE_B; count_reset <= 1; latch_register <= 0;
			
			when PULSE_B =>
				count_en <= 1;
				if(PPM_input = 1) then gen_ns <= PULSE_B; count_reset <= 0; latch_register <= 0;
				else gen_ns <= SAVE_B; count_reset <= 0; latch_register <= 1;
			
			when SAVE_B =>
				count_en <= 0;
				gen_ns <= IDLE_B; count_reset <= 1; latch_register <= 0;
			
			when IDLE_B =>
				count_en <= 1;
				if(PPM_input = 0 or idle_caught = 0) then gen_ns <= IDLE_B; count_reset <= 0; latch_register <= 0;
				else gen_ns <= PULSE_C; count_reset <= 1; latch_register <= 0;
			
			when PULSE_C =>
				count_en <= 1;
				if(PPM_input = 1) then gen_ns <= PULSE_C; count_reset <= 0; latch_register <= 0;
				else gen_ns <= SAVE_C; count_reset <= 0; latch_register <= 1;
			
			when SAVE_C =>
				count_en <= 0;
				gen_ns <= IDLE_C; count_reset <= 1; latch_register <= 0;
			
			when IDLE_C =>
				count_en <= 1;
				if(PPM_input = 0 or idle_caught = 0) then gen_ns <= IDLE_C; count_reset <= 0; latch_register <= 0;
				else gen_ns <= PULSE_D; count_reset <= 1; latch_register <= 0;
			
			when PULSE_D =>
				count_en <= 1;
				if(PPM_input = 1) then gen_ns <= PULSE_D; count_reset <= 0; latch_register <= 0;
				else gen_ns <= SAVE_D; count_reset <= 0; latch_register <= 1;
			
			when SAVE_D =>
				count_en <= 0;
				gen_ns <= IDLE_D; count_reset <= 1; latch_register <= 0;
			
			when IDLE_D =>
				count_en <= 1;
				if(PPM_input = 0 or idle_caught = 0) then gen_ns <= IDLE_D; count_reset <= 0; latch_register <= 0;
				else gen_ns <= PULSE_E; count_reset <= 1; latch_register <= 0;
			
			when PULSE_E =>
				count_en <= 1;
				if(PPM_input = 1) then gen_ns <= PULSE_E; count_reset <= 0; latch_register <= 0;
				else gen_ns <= SAVE_E; count_reset <= 0; latch_register <= 1;
			
			when SAVE_E =>
				count_en <= 0;
				gen_ns <= IDLE_E; count_reset <= 1; latch_register <= 0;
			
			when IDLE_E =>
				count_en <= 1;
				if(PPM_input = 0 or idle_caught = 0) then gen_ns <= IDLE_E; count_reset <= 0; latch_register <= 0;
				else gen_ns <= PULSE_F; count_reset <= 1; latch_register <= 0;
			
			when PULSE_F =>
				count_en <= 1;
				if(PPM_input = 1) then gen_ns <= PULSE_F; count_reset <= 0; latch_register <= 0;
				else gen_ns <= SAVE_F; count_reset <= 0; latch_register <= 1;
			
			when SAVE_F =>
				count_en <= 0;
				gen_ns <= IDLE_F; count_reset <= 1; latch_register <= 0;
			
			when IDLE_F =>
				count_en <= 1;
				if(PPM_input = 0 or idle_caught = 0) then gen_ns <= IDLE_F; count_reset <= 0; latch_register <= 0;
				else gen_ns <= SYNC; count_reset <= 1; latch_register <= 0;
				
			when others =>
				count_en <= 0;
				latch_register <= 0;
				count_reset <= 0;
				gen_ns <= RESET;
		end case;
	end process gen_comb_proc;
	
  --USER logic implementation added here

  ------------------------------------------
  -- Example code to read/write user logic slave model s/w accessible registers
  -- 
  -- Note:
  -- The example code presented here is to show you one way of reading/writing
  -- software accessible registers implemented in the user logic slave model.
  -- Each bit of the Bus2IP_WrCE/Bus2IP_RdCE signals is configured to correspond
  -- to one software accessible register by the top level template. For example,
  -- if you have four 32 bit software accessible registers in the user logic,
  -- you are basically operating on the following memory mapped registers:
  -- 
  --    Bus2IP_WrCE/Bus2IP_RdCE   Memory Mapped Register
  --                     "1000"   C_BASEADDR + 0x0
  --                     "0100"   C_BASEADDR + 0x4
  --                     "0010"   C_BASEADDR + 0x8
  --                     "0001"   C_BASEADDR + 0xC
  -- 
  ------------------------------------------
  slv_reg_write_sel <= Bus2IP_WrCE(31 downto 0);
  slv_reg_read_sel  <= Bus2IP_RdCE(31 downto 0);
  slv_write_ack     <= Bus2IP_WrCE(0) or Bus2IP_WrCE(1) or Bus2IP_WrCE(2) or Bus2IP_WrCE(3) or Bus2IP_WrCE(4) or Bus2IP_WrCE(5) or Bus2IP_WrCE(6) or Bus2IP_WrCE(7) or Bus2IP_WrCE(8) or Bus2IP_WrCE(9) or Bus2IP_WrCE(10) or Bus2IP_WrCE(11) or Bus2IP_WrCE(12) or Bus2IP_WrCE(13) or Bus2IP_WrCE(14) or Bus2IP_WrCE(15) or Bus2IP_WrCE(16) or Bus2IP_WrCE(17) or Bus2IP_WrCE(18) or Bus2IP_WrCE(19) or Bus2IP_WrCE(20) or Bus2IP_WrCE(21) or Bus2IP_WrCE(22) or Bus2IP_WrCE(23) or Bus2IP_WrCE(24) or Bus2IP_WrCE(25) or Bus2IP_WrCE(26) or Bus2IP_WrCE(27) or Bus2IP_WrCE(28) or Bus2IP_WrCE(29) or Bus2IP_WrCE(30) or Bus2IP_WrCE(31);
  slv_read_ack      <= Bus2IP_RdCE(0) or Bus2IP_RdCE(1) or Bus2IP_RdCE(2) or Bus2IP_RdCE(3) or Bus2IP_RdCE(4) or Bus2IP_RdCE(5) or Bus2IP_RdCE(6) or Bus2IP_RdCE(7) or Bus2IP_RdCE(8) or Bus2IP_RdCE(9) or Bus2IP_RdCE(10) or Bus2IP_RdCE(11) or Bus2IP_RdCE(12) or Bus2IP_RdCE(13) or Bus2IP_RdCE(14) or Bus2IP_RdCE(15) or Bus2IP_RdCE(16) or Bus2IP_RdCE(17) or Bus2IP_RdCE(18) or Bus2IP_RdCE(19) or Bus2IP_RdCE(20) or Bus2IP_RdCE(21) or Bus2IP_RdCE(22) or Bus2IP_RdCE(23) or Bus2IP_RdCE(24) or Bus2IP_RdCE(25) or Bus2IP_RdCE(26) or Bus2IP_RdCE(27) or Bus2IP_RdCE(28) or Bus2IP_RdCE(29) or Bus2IP_RdCE(30) or Bus2IP_RdCE(31);

  -- implement slave model software accessible register(s)
  SLAVE_REG_WRITE_PROC : process( Bus2IP_Clk ) is
  begin

    if Bus2IP_Clk'event and Bus2IP_Clk = '1' then
      if Bus2IP_Resetn = '0' then
        reg_control <= (others => '0');
        reg_capture_count <= (others => '0');
        reg_capture_fsm_state <= (others => '0');
        reg_generage_fsm_state <= (others => '0');
        reg_capture_sync_length <= (others => '0');
        reg_generate_idle_length <= (others => '0');
        reg_generate_frame_length <= (others => '0');
        slv_reg7 <= (others => '0');
        slv_reg8 <= (others => '0');
        slv_reg9 <= (others => '0');
        reg_capture_a <= (others => '0');
        reg_capture_b <= (others => '0');
        reg_capture_c <= (others => '0');
        reg_capture_d <= (others => '0');
        reg_capture_e <= (others => '0');
        reg_capture_f <= (others => '0');
        slv_reg16 <= (others => '0');
        slv_reg17 <= (others => '0');
        slv_reg18 <= (others => '0');
        slv_reg19 <= (others => '0');
        reg_generate_a <= (others => '0');
        reg_generate_b <= (others => '0');
        reg_generate_c <= (others => '0');
        reg_generate_d <= (others => '0');
        reg_generate_e <= (others => '0');
        reg_generate_f <= (others => '0');
        slv_reg26 <= (others => '0');
        slv_reg27 <= (others => '0');
        slv_reg28 <= (others => '0');
        slv_reg29 <= (others => '0');
        slv_reg30 <= (others => '0');
        slv_reg31 <= (others => '0');
      else
        case slv_reg_write_sel is
          when "10000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                reg_control(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "01000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                reg_capture_count(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "00100000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                reg_capture_fsm_state(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "00010000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                reg_generage_fsm_state(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "00001000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                reg_capture_sync_length(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "00000100000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                reg_generate_idle_length(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "00000010000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                reg_generate_frame_length(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "00000001000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg7(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "00000000100000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg8(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "00000000010000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg9(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "00000000001000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                reg_capture_a(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "00000000000100000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                reg_capture_b(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "00000000000010000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                reg_capture_c(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "00000000000001000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                reg_capture_d(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "00000000000000100000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                reg_capture_e(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "00000000000000010000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                reg_capture_f(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "00000000000000001000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg16(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "00000000000000000100000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg17(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "00000000000000000010000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg18(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "00000000000000000001000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg19(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "00000000000000000000100000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                reg_generate_a(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "00000000000000000000010000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                reg_generate_b(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "00000000000000000000001000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                reg_generate_c(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "00000000000000000000000100000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                reg_generate_d(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "00000000000000000000000010000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                reg_generate_e(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "00000000000000000000000001000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                reg_generate_f(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "00000000000000000000000000100000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg26(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "00000000000000000000000000010000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg27(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "00000000000000000000000000001000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg28(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "00000000000000000000000000000100" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg29(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "00000000000000000000000000000010" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg30(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "00000000000000000000000000000001" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg31(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when others => null;
        end case;
      end if;
    end if;

  end process SLAVE_REG_WRITE_PROC;

  -- implement slave model software accessible register(s) read mux
  SLAVE_REG_READ_PROC : process( slv_reg_read_sel, reg_control, reg_capture_count, reg_capture_fsm_state, reg_generage_fsm_state, reg_capture_sync_length, reg_generate_idle_length, reg_generate_frame_length, slv_reg7, slv_reg8, slv_reg9, reg_capture_a, reg_capture_b, reg_capture_c, reg_capture_d, reg_capture_e, reg_capture_f, slv_reg16, slv_reg17, slv_reg18, slv_reg19, reg_generate_a, reg_generate_b, reg_generate_c, reg_generate_d, reg_generate_e, reg_generate_f, slv_reg26, slv_reg27, slv_reg28, slv_reg29, slv_reg30, slv_reg31 ) is
  begin

    case slv_reg_read_sel is
      when "10000000000000000000000000000000" => slv_ip2bus_data <= reg_control;
      when "01000000000000000000000000000000" => slv_ip2bus_data <= reg_capture_count;
      when "00100000000000000000000000000000" => slv_ip2bus_data <= reg_capture_fsm_state;
      when "00010000000000000000000000000000" => slv_ip2bus_data <= reg_generage_fsm_state;
      when "00001000000000000000000000000000" => slv_ip2bus_data <= reg_capture_sync_length;
      when "00000100000000000000000000000000" => slv_ip2bus_data <= reg_generate_idle_length;
      when "00000010000000000000000000000000" => slv_ip2bus_data <= reg_generate_frame_length;
      when "00000001000000000000000000000000" => slv_ip2bus_data <= slv_reg7;
      when "00000000100000000000000000000000" => slv_ip2bus_data <= slv_reg8;
      when "00000000010000000000000000000000" => slv_ip2bus_data <= slv_reg9;
      when "00000000001000000000000000000000" => slv_ip2bus_data <= reg_capture_a;
      when "00000000000100000000000000000000" => slv_ip2bus_data <= reg_capture_b;
      when "00000000000010000000000000000000" => slv_ip2bus_data <= reg_capture_c;
      when "00000000000001000000000000000000" => slv_ip2bus_data <= reg_capture_d;
      when "00000000000000100000000000000000" => slv_ip2bus_data <= reg_capture_e;
      when "00000000000000010000000000000000" => slv_ip2bus_data <= reg_capture_f;
      when "00000000000000001000000000000000" => slv_ip2bus_data <= slv_reg16;
      when "00000000000000000100000000000000" => slv_ip2bus_data <= slv_reg17;
      when "00000000000000000010000000000000" => slv_ip2bus_data <= slv_reg18;
      when "00000000000000000001000000000000" => slv_ip2bus_data <= slv_reg19;
      when "00000000000000000000100000000000" => slv_ip2bus_data <= reg_generate_a;
      when "00000000000000000000010000000000" => slv_ip2bus_data <= reg_generate_b;
      when "00000000000000000000001000000000" => slv_ip2bus_data <= reg_generate_c;
      when "00000000000000000000000100000000" => slv_ip2bus_data <= reg_generate_d;
      when "00000000000000000000000010000000" => slv_ip2bus_data <= reg_generate_e;
      when "00000000000000000000000001000000" => slv_ip2bus_data <= reg_generate_f;
      when "00000000000000000000000000100000" => slv_ip2bus_data <= slv_reg26;
      when "00000000000000000000000000010000" => slv_ip2bus_data <= slv_reg27;
      when "00000000000000000000000000001000" => slv_ip2bus_data <= slv_reg28;
      when "00000000000000000000000000000100" => slv_ip2bus_data <= slv_reg29;
      when "00000000000000000000000000000010" => slv_ip2bus_data <= slv_reg30;
      when "00000000000000000000000000000001" => slv_ip2bus_data <= slv_reg31;
      when others => slv_ip2bus_data <= (others => '0');
    end case;

  end process SLAVE_REG_READ_PROC;

  ------------------------------------------
  -- Example code to drive IP to Bus signals
  ------------------------------------------
  IP2Bus_Data  <= slv_ip2bus_data when slv_read_ack = '1' else
                  (others => '0');

  IP2Bus_WrAck <= slv_write_ack;
  IP2Bus_RdAck <= slv_read_ack;
  IP2Bus_Error <= '0';

end IMP;
