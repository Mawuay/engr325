LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY Lab4 IS
PORT (
		CLOCK_50 				: IN STD_LOGIC;
		KEY						: IN STD_LOGIC_VECTOR(0 DOWNTO 0);
		SRAM_ADDR				: OUT STD_LOGIC_VECTOR(17 DOWNTO 0);
		SRAM_DQ					: INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		SRAM_WE_N				: OUT STD_LOGIC;
		SRAM_OE_N				: OUT STD_LOGIC;
		SRAM_UB_N				: OUT STD_LOGIC;
		SRAM_LB_N				: OUT STD_LOGIC;
		SRAM_CE_N				: OUT STD_LOGIC;
		ACK						: OUT STD_LOGIC;
		BUS_EN					: OUT STD_LOGIC
);
END Lab4;

		

ARCHITECTURE Lab4_rtl OF Lab4 IS 	
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
		
		Bridge_read_data_sig <= SRAM_DQ;
		

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


	IRQ_sig 		<= '0';
	ACK			<= ACK_sig;
	BUS_EN		<= Bridge_bus_enable_sig;


END Lab4_rtl;