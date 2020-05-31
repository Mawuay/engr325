--IP Functional Simulation Model
--VERSION_BEGIN 13.0 cbx_mgl 2013:06:12:18:04:42:SJ cbx_simgen 2013:06:12:18:03:40:SJ  VERSION_END


-- Copyright (C) 1991-2013 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- You may only use these simulation model output files for simulation
-- purposes and expressly not for synthesis or any other purposes (in which
-- event Altera disclaims all warranties of any kind).


--synopsys translate_off

--synthesis_resources = mux21 8 
 LIBRARY ieee;
 USE ieee.std_logic_1164.all;

 ENTITY  nios_system_addr_router IS 
	 PORT 
	 ( 
		 clk	:	IN  STD_LOGIC;
		 reset	:	IN  STD_LOGIC;
		 sink_data	:	IN  STD_LOGIC_VECTOR (91 DOWNTO 0);
		 sink_endofpacket	:	IN  STD_LOGIC;
		 sink_ready	:	OUT  STD_LOGIC;
		 sink_startofpacket	:	IN  STD_LOGIC;
		 sink_valid	:	IN  STD_LOGIC;
		 src_channel	:	OUT  STD_LOGIC_VECTOR (2 DOWNTO 0);
		 src_data	:	OUT  STD_LOGIC_VECTOR (91 DOWNTO 0);
		 src_endofpacket	:	OUT  STD_LOGIC;
		 src_ready	:	IN  STD_LOGIC;
		 src_startofpacket	:	OUT  STD_LOGIC;
		 src_valid	:	OUT  STD_LOGIC
	 ); 
 END nios_system_addr_router;

 ARCHITECTURE RTL OF nios_system_addr_router IS

	 ATTRIBUTE synthesis_clearbox : natural;
	 ATTRIBUTE synthesis_clearbox OF RTL : ARCHITECTURE IS 1;
	 SIGNAL	wire_nios_system_addr_router_src_channel_10m_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nios_system_addr_router_src_channel_14m_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nios_system_addr_router_src_channel_15m_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nios_system_addr_router_src_channel_16m_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nios_system_addr_router_src_channel_9m_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nios_system_addr_router_src_data_12m_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nios_system_addr_router_src_data_17m_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nios_system_addr_router_src_data_18m_dataout	:	STD_LOGIC;
	 SIGNAL  wire_w_lg_w_sink_data_range144w293w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w1w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_sink_data_range147w292w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  s_wire_nios_system_addr_router_src_channel_0_242_dataout :	STD_LOGIC;
	 SIGNAL  s_wire_nios_system_addr_router_src_channel_1_264_dataout :	STD_LOGIC;
	 SIGNAL  wire_w_sink_data_range144w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_sink_data_range147w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
 BEGIN

	wire_w_lg_w_sink_data_range144w293w(0) <= wire_w_sink_data_range144w(0) AND wire_w_lg_w_sink_data_range147w292w(0);
	wire_w1w(0) <= NOT s_wire_nios_system_addr_router_src_channel_0_242_dataout;
	wire_w_lg_w_sink_data_range147w292w(0) <= NOT wire_w_sink_data_range147w(0);
	s_wire_nios_system_addr_router_src_channel_0_242_dataout <= ((((((((NOT sink_data(49)) AND (NOT sink_data(50))) AND (NOT sink_data(51))) AND (NOT sink_data(52))) AND (NOT sink_data(53))) AND (NOT sink_data(54))) AND (NOT sink_data(55))) AND (NOT sink_data(56)));
	s_wire_nios_system_addr_router_src_channel_1_264_dataout <= ((((((((wire_w_lg_w_sink_data_range144w293w(0) AND sink_data(49)) AND (NOT sink_data(50))) AND (NOT sink_data(51))) AND (NOT sink_data(52))) AND (NOT sink_data(53))) AND (NOT sink_data(54))) AND (NOT sink_data(55))) AND (NOT sink_data(56)));
	sink_ready <= src_ready;
	src_channel <= ( wire_nios_system_addr_router_src_channel_14m_dataout & wire_nios_system_addr_router_src_channel_15m_dataout & wire_nios_system_addr_router_src_channel_16m_dataout);
	src_data <= ( sink_data(91 DOWNTO 82) & wire_nios_system_addr_router_src_data_17m_dataout & wire_nios_system_addr_router_src_data_18m_dataout & sink_data(79 DOWNTO 0));
	src_endofpacket <= sink_endofpacket;
	src_startofpacket <= sink_startofpacket;
	src_valid <= sink_valid;
	wire_w_sink_data_range144w(0) <= sink_data(47);
	wire_w_sink_data_range147w(0) <= sink_data(48);
	wire_nios_system_addr_router_src_channel_10m_dataout <= s_wire_nios_system_addr_router_src_channel_0_242_dataout AND NOT(s_wire_nios_system_addr_router_src_channel_1_264_dataout);
	wire_nios_system_addr_router_src_channel_14m_dataout <= wire_nios_system_addr_router_src_channel_9m_dataout OR sink_data(56);
	wire_nios_system_addr_router_src_channel_15m_dataout <= wire_nios_system_addr_router_src_channel_10m_dataout AND NOT(sink_data(56));
	wire_nios_system_addr_router_src_channel_16m_dataout <= s_wire_nios_system_addr_router_src_channel_1_264_dataout AND NOT(sink_data(56));
	wire_nios_system_addr_router_src_channel_9m_dataout <= wire_w1w(0) AND NOT(s_wire_nios_system_addr_router_src_channel_1_264_dataout);
	wire_nios_system_addr_router_src_data_12m_dataout <= s_wire_nios_system_addr_router_src_channel_0_242_dataout AND NOT(s_wire_nios_system_addr_router_src_channel_1_264_dataout);
	wire_nios_system_addr_router_src_data_17m_dataout <= wire_nios_system_addr_router_src_data_12m_dataout AND NOT(sink_data(56));
	wire_nios_system_addr_router_src_data_18m_dataout <= s_wire_nios_system_addr_router_src_channel_1_264_dataout AND NOT(sink_data(56));

 END RTL; --nios_system_addr_router
--synopsys translate_on
--VALID FILE
