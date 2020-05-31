LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.SevenSeg_pkg.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY Lab6 IS
PORT (
		CLOCK_50 				: IN STD_LOGIC;
		SW							: IN STD_LOGIC_VECTOR(0 DOWNTO 0);
		KEY						: IN STD_LOGIC_VECTOR(0 DOWNTO 0);
		SRAM_ADDR				: OUT STD_LOGIC_VECTOR(17 DOWNTO 0);
		SRAM_DQ					: INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		SRAM_WE_N				: OUT STD_LOGIC;
		SRAM_OE_N				: OUT STD_LOGIC;
		SRAM_UB_N				: OUT STD_LOGIC;
		SRAM_LB_N				: OUT STD_LOGIC;
		SRAM_CE_N				: OUT STD_LOGIC;
		HEX0						: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		HEX1						: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		HEX2						: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		HEX3						: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		HEX4						: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		HEX5						: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		HEX6						: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		HEX7						: OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
);
END Lab6;

		

ARCHITECTURE Lab6_rtl OF Lab6 IS 	
-------------------------------------------------------------------------
-- Signal definitions
-------------------------------------------------------------------------
	type State_type IS (S1,S2,S3,S4);
	signal y_present, y_next : State_type;

	Signal		ACK_sig 						:  STD_LOGIC;
	Signal		IRQ_sig						:  STD_LOGIC;
	Signal		Bridge_address_sig		:	STD_LOGIC_VECTOR(19 DOWNTO 0);
	Signal		Bridge_bus_enable_sig	:	STD_LOGIC;
	Signal		Bridge_byte_enable_sig	:	STD_LOGIC_VECTOR(1 DOWNTO 0);
	Signal		Bridge_rw_sig				:	STD_LOGIC;
	Signal 		Bridge_write_data_sig	:	STD_LOGIC_VECTOR(15 DOWNTO 0);
	Signal 		Bridge_read_data_sig		:	STD_LOGIC_VECTOR(15 DOWNTO 0);
	Signal 		q_signal						:	STD_LOGIC_VECTOR(15 DOWNTO 0);
	Signal		wren_signal					:	STD_LOGIC;
	Signal		wren_check					:	STD_LOGIC;
	Signal		ChipEn_signal				:	STD_LOGIC;
	Signal		ChipEn_check				:	STD_LOGIC;
	Signal		RDData_signal				:	STD_LOGIC_VECTOR(15 DOWNTO 0);
	Signal		Intermediate_signal		:	STD_LOGIC_VECTOR(15 DOWNTO 0);
	Signal		HDig7_signal				:	STD_LOGIC_VECTOR(3 DOWNTO 0);
	Signal		HDig6_signal				:	STD_LOGIC_VECTOR(3 DOWNTO 0);
	Signal		HDig5_signal				:	STD_LOGIC_VECTOR(3 DOWNTO 0);
	Signal		HDig4_signal				:	STD_LOGIC_VECTOR(3 DOWNTO 0);
	Signal		HDig3_signal				:	STD_LOGIC_VECTOR(3 DOWNTO 0);
	Signal		HDig2_signal				:	STD_LOGIC_VECTOR(3 DOWNTO 0);
	Signal		HDig1_signal				:	STD_LOGIC_VECTOR(3 DOWNTO 0);
	Signal		HDig0_signal				:	STD_LOGIC_VECTOR(3 DOWNTO 0);
	
	
	component nios_system is
        port (
            clk_clk            : in  std_logic       := 'X';             					-- clk
            reset_reset_n      : in  std_logic       := 'X';             					-- reset_n
            bridge_acknowledge : in  std_logic       := 'X';             					-- acknowledge
            bridge_irq         : in  std_logic       := 'X';            				   -- irq
            bridge_address     : out std_logic_vector(19 downto 0);      					-- address
            bridge_bus_enable  : out std_logic;                          					-- bus_enable
            bridge_byte_enable : out std_logic_vector(1 downto 0);       					-- byte_enable
            bridge_rw          : out std_logic;                          					-- rw
            bridge_write_data  : out std_logic_vector(15 downto 0);      					-- write_data
            bridge_read_data   : in  std_logic_vector(15 downto 0) := (others => 'X')  -- read_data
        );
    end component nios_system;
	 
	 
	 component OnChipRAM
		PORT(
			address		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			byteena		: IN STD_LOGIC_VECTOR (1 DOWNTO 0) :=  (OTHERS => '1');
			clock			: IN STD_LOGIC  := '1';
			data			: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			wren			: IN STD_LOGIC ;
			q				: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
		);
	end component;
	

	component SevenSegPort is 
	   Port (
			 Clock 	: IN std_logic;  
			 Reset_n : IN std_logic;
			 Selct 	: IN std_logic;
			 CE_n 	: IN std_logic;
			 R_Wn 	: IN std_logic;
			 ADDR 	: IN std_logic_vector(2 downto 0);
			 ByteEn 	: IN std_logic_vector(1 downto 0);
			 WRData 	: IN std_logic_vector(15 downto 0);
			 RDData 	: OUT std_logic_vector(15 downto 0);
			 HDig7 	: OUT std_logic_vector(3 downto 0);
			 HDig6 	: OUT std_logic_vector(3 downto 0);
			 HDig5 	: OUT std_logic_vector(3 downto 0);
			 HDig4 	: OUT std_logic_vector(3 downto 0);
			 HDig3 	: OUT std_logic_vector(3 downto 0);
			 HDig2 	: OUT std_logic_vector(3 downto 0);
			 HDig1 	: OUT std_logic_vector(3 downto 0);
			 HDig0 	: OUT std_logic_vector(3 downto 0)
		);
	end component SevenSegPort;
	
BEGIN

-------------------------------------------------------------------------
-- Signal assigingments
-------------------------------------------------------------------------
		SRAM_ADDR 	<= Bridge_address_sig(18 downto 1);
		SRAM_WE_N 	<= Bridge_rw_sig;
		SRAM_OE_N 	<= not Bridge_rw_sig;				
		SRAM_UB_N 	<= not Bridge_byte_enable_sig(1);				
		SRAM_LB_N 	<= not Bridge_byte_enable_sig(0);			
		SRAM_CE_N 	<= not (Bridge_bus_enable_sig AND Bridge_address_sig(19)) ;
		wren_signal <= ( (NOT Bridge_rw_sig) AND wren_check);
		wren_check	<= '1' when (Bridge_address_sig(19 downto 9) = "0000000001" AND Bridge_bus_enable_sig = '1') else '0';

		
-- tri-state buffer for write data -- 19 downto-- 0000000001
		SRAM_DQ	<= Bridge_write_data_sig when Bridge_rw_sig = '0' else (others =>'Z'); --"ZZZZZZZZZZZZZZZZ";


    u0 : component nios_system
        port map (
            clk_clk            => CLOCK_50,           			--   		clk.clk
            reset_reset_n      => KEY(0),      						--  		reset.reset_n
            bridge_acknowledge => ACK_sig, 							-- 		bridge.acknowledge
            bridge_irq         => IRQ_sig,      					--       .irq
            bridge_address     => Bridge_address_sig,     		--       .address
            bridge_bus_enable  => Bridge_bus_enable_sig,  		--       .bus_enable
            bridge_byte_enable => Bridge_byte_enable_sig, 		--       .byte_enable
            bridge_rw          => Bridge_rw_sig,          		--       .rw
            bridge_write_data  => Bridge_write_data_sig,  		--       .write_data
            bridge_read_data   => Bridge_read_data_sig    		--       .read_data
        );
		  
		  
		  
		OnChipRAM_inst : OnChipRAM 
			PORT MAP (
				address	=> Bridge_address_sig(8 downto 1),
				byteena	=> Bridge_byte_enable_sig,
				clock	 	=> CLOCK_50,
				data	 	=> Bridge_write_data_sig,
				wren	 	=> wren_signal,
				q	 		=> q_signal
	);
	
	
	
	SevenSegPort_inst : component SevenSegPort 
	   port map (
			 Clock 	=> CLOCK_50,
			 Reset_n =>	KEY(0),
			 Selct 	=>	SW(0),
			 CE_n 	=>	ChipEn_signal,
			 R_Wn 	=>	Bridge_rw_sig,
			 ADDR 	=>	Bridge_address_sig(2 downto 0),
			 ByteEn 	=>	Bridge_byte_enable_sig,
			 WRData 	=>	Bridge_write_data_sig,
			 RDData 	=>	RDData_signal,
			 HDig7 	=>	HDig7_signal,
			 HDig6 	=>	HDig6_signal,
			 HDig5 	=>	HDig5_signal,
			 HDig4 	=>	HDig4_signal,
			 HDig3 	=>	HDig3_signal,
			 HDig2 	=>	HDig2_signal,
			 HDig1 	=>	HDig1_signal,
			 HDig0 	=>	HDig0_signal
		);

	
----------------------------------------------------------------------------
-- MUX for the Read data conditions 
-- between the SRAM_DQ and the onChipRam q_signal
----------------------------------------------------------------------------			
		Intermediate_signal <= SRAM_DQ when (Bridge_bus_enable_sig NAND Bridge_address_sig(19)) = '0' else q_signal;
		
----------------------------------------------------------------------------
-- MUX2 for the Read data conditions 
-- the result of MUX1 and the SevenSegPort RDData_signal
----------------------------------------------------------------------------	
		Bridge_read_data_sig <= Intermediate_signal when ChipEn_signal = '1' else RDData_signal;
-----------------------------------------------------------------------------
-- State machine process for the acknowledge 
-----------------------------------------------------------------------------
process (Bridge_bus_enable_sig, y_present) is
BEGIN
	CASE y_present IS 
		WHEN S1 =>		--State1
			if (Bridge_bus_enable_sig = '1') then
				ACK_sig <= '0';
				y_next <= S2;
			else 
				ACK_sig <= '0';
				y_next <= S1;
			end if;
		
		WHEN S2 =>		--State2
			ACK_sig <= '0';
			y_next <= S3;

		WHEN S3 =>		--State3
			ACK_sig <= '1';
			y_next <= S4;
			
		WHEN S4 =>	--State4
			ACK_sig <= '0';
			y_next <= S1;  			

		END CASE;
end process;

process (CLOCK_50, KEY(0))
	BEGIN
		if (KEY(0) = '0') then
			y_present <= S1;
		elsif (CLOCK_50' EVENT AND CLOCK_50 = '1') then
			y_present <= y_next;
		end if;
end process;

-----------------------------------------------------------
-- SevenSegPort CE_N_signal definition.
----------------------------------------------------------- 
	ChipEn_signal <= Bridge_bus_enable_sig NAND ChipEn_check;
	ChipEn_check <= '1' when (Bridge_address_sig(19 downto 5) = "0000000000000000" AND Bridge_address_sig(0) = '0') else '0';
	
------------------------------------------------------------	
	IRQ_sig 		<= '0';
	
------------------------------------------------------------
-- Converting the register vlaues to SevenSeg 
-- Hex display digits
------------------------------------------------------------
	HEX7 <= convert_to_7seg(HDig7_signal);
	HEX6 <= convert_to_7seg(HDig6_signal);
	HEX5 <= convert_to_7seg(HDig5_signal);
	HEX4 <= convert_to_7seg(HDig4_signal);
	HEX3 <= convert_to_7seg(HDig3_signal);
	HEX2 <= convert_to_7seg(HDig2_signal);
	HEX1 <= convert_to_7seg(HDig1_signal);
	HEX0 <= convert_to_7seg(HDig0_signal);

END Lab6_rtl;