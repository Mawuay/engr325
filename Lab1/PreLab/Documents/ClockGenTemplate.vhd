-----------------------------------------------------------------------------
-- FILE: ClockGen.vhd
--   This file contains VHDL that implements a clock divider
-- DESCRIPTION:
--   A simple counter is used to divide a clock freq by 10.
-- COURSE: 		Engineering 325 - Fall 2019
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY ClockGen IS
  PORT (
	Clock : IN std_logic;
	Reset_n : IN std_logic;
	ClockOut : OUT std_logic
  );
END ClockGen;

-----------------------------------------------------------------------------
-- ARCHITECTURE: behav
-- This architecture is implemented with behavioral VHDL
-----------------------------------------------------------------------------
ARCHITECTURE behav OF ClockGen IS
  signal Count : std_logic_vector(2 downto 0);  -- 0 to 4 counter
  signal ClkOutSig : std_logic;
BEGIN
  ClockOut <= ClkOutSig;
  
  PROCESS (
  
  end process;
end architecture;
