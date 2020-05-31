-----------------------------------------------------------------------------
-- FILE: ClockDividerCircuit.vhd
--   This file contains VHDL that implements a clock divider
-- DESCRIPTION:
--   A simple counter is used to divide a clock freq by 10.
-- COURSE: 		Engineering 325 - Fall 2019
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY ClockDividerCircuit IS
  PORT (
	Clock : IN std_logic;
	Reset_n : IN std_logic;
	ClockOut : OUT std_logic
  );
END ClockDividerCircuit;

-----------------------------------------------------------------------------
-- ARCHITECTURE: behav
-- This architecture is implemented with behavioral VHDL
-----------------------------------------------------------------------------
ARCHITECTURE behav OF ClockDividerCircuit IS
  signal Count : std_logic_vector(2 downto 0);  -- 0 to 4 counter
  signal ClkOutSig : std_logic;
  
BEGIN
  ClockOut <= ClkOutSig;
  
  
-----------------------------------------------------------------------------
-- process 
-- takes the 50 MHz clock and divides it by a factor of 10 to provide a 5 MHz 
-- clock in addition to the 50 MHz system clock.
-----------------------------------------------------------------------------
  
  PROCESS (Clock, Reset_n)
  Begin 
		if (Reset_n = '0')then 
			Count <= "000";
			ClkOutSig <= '0';
			
		elsif (Clock'EVENT AND Clock = '1') then
			 Count <= Count + "001";
			 if (Count = "100" )then 
					 Count <= "000";
					 if ( ClkOutSig = '1' ) then 
								ClkOutSig <= '0';
				  	elsif (ClkOutSig = '0') then
							  ClkOutSig <= '1';
					 end if;
					
		   end if;
		   
		 end if; 
		

  end process;
 
end architecture;
