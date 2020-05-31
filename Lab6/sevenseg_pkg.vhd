-----------------------------------------------------------------------------
-- FILE: sevenseg_pkg
--   This file contains VHDL that provides useful functions for working with
--   7-segment displays.
-- DESCRIPTION:
--   This package declares and implements functions for converting a 4-bit 
--   binary value into the appropriate signals for displaying that hex 
--   value on a seven segment display.  It is assumed that the displays have
--   segments that are lit when a logic 0 is applied and unlit for a logic 1.
-- COURSE: 		Engineering 304 - Spring 2019
-- DESIGN TOOL: 	Quartus 
-- SIMULATION TOOL:	Quartus + Modelsim
-----------------------------------------------------------------------------
-- MODIFICATION HISTORY:  
--
-- Revision 1.0  3/15/16  2:00 PM  Prof. Brouwer
-- File as supplied by the professor.
-----------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-----------------------------------------------------------------------------
-- Declare the functions first in the declarative section
-----------------------------------------------------------------------------
PACKAGE SevenSeg_pkg IS
	function  convert_to_7seg(number : std_logic_vector(3 downto 0))
        return std_logic_vector;
END;

-----------------------------------------------------------------------------
-- The body provides the actual VHDL to implement the declared function.
-----------------------------------------------------------------------------
PACKAGE BODY SevenSeg_pkg IS
	function  convert_to_7seg (number : std_logic_vector(3 downto 0)) 
	        return std_logic_vector IS
		variable seven_seg : std_logic_vector(6 downto 0);
	BEGIN
	  -- Use a case statement to cover all of the 16 possible input 
    -- combinations and the appropriate display patterns.   A '0' turns
	  -- on the segment and a '1' turns it off.  The left-most bit is the 
    -- center segment ('g').  Moving left to right corresponds to the 
    -- upper-left segment followed by the remaining segments in a
    -- counter-clockwise rotation around the display (g-f-e-d-c-b-a).
		CASE number IS
			WHEN "0000" => seven_seg := "1000000";  -- 0 = 0x40
			WHEN "0001" => seven_seg := "1111001";  -- 1 = 0x79
			WHEN "0010" => seven_seg := "0100100";  -- 2 = 0x24
			WHEN "0011" => seven_seg := "0110000";  -- 3 = 0x30
			WHEN "0100" => seven_seg := "0011001";  -- 4 = 0x19
			WHEN "0101" => seven_seg := "0010010";  -- 5 = 0x12
			WHEN "0110" => seven_seg := "0000010";  -- 6 = 0x02
			WHEN "0111" => seven_seg := "1111000";  -- 7 = 0x78
			WHEN "1000" => seven_seg := "0000000";  -- 8 = 0x00
			WHEN "1001" => seven_seg := "0010000";  -- 9 = 0x10
			WHEN "1010" => seven_seg := "0001000";  -- a = 0x08
			WHEN "1011" => seven_seg := "0000011";  -- b = 0x03
			WHEN "1100" => seven_seg := "0100111";  -- c = 0x27
			WHEN "1101" => seven_seg := "0100001";  -- d = 0x21
			WHEN "1110" => seven_seg := "0000110";  -- e = 0x06
			WHEN "1111" => seven_seg := "0001110";  -- f = 0x0e
			WHEN OTHERS => seven_seg := "1111111";  -- ? = 0x7f
		END CASE;
		-- return the value of the seven_seg variable.
		return seven_seg;
	END;
END;
