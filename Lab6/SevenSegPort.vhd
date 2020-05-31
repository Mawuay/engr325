-- Daniel Ackuaku
-- Date: 10/12/2019 

Library ieee;
USE ieee.std_logic_1164.all;

-- Explanation of the entity and what it does... 
-- (don't make these lines too long to avoid word wrapping)
Entity SevenSegPort is
  Port (
    Clock 	: IN std_logic;  -- fill in with descriptions of each port
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
End Entity SevenSegPort;

Architecture Display OF SevenSegPort IS
  -- This area is used to define types and any internal signals
  -- Fill_In as necessary to define signals like "Result", etc
  -- Defining the signals for input, output and timing control of the progamme 
  Signal Register1 	: std_logic_vector(31 downto 0);	-- input register 
  Signal Register2 	: std_logic_vector(31 downto 0); -- input reigster 


  
Begin
-------------------------------------------------
-- Selct statement for the registers
-------------------------------------------------
		
Process (Selct, Register1, Register2) is
Begin
	Case Selct IS 
		When '0' =>
			HDig7 <= Register1(31 downto 28) ; 
			HDig6 <= Register1(27 downto 24) ; 
			HDig5 <= Register1(23 downto 20) ; 
			HDig4 <= Register1(19 downto 16) ; 
			HDig3 <= Register1(15 downto 12) ; 
			HDig2 <= Register1(11 downto 8) ; 
			HDig1 <= Register1(7 downto 4) ; 
			HDig0 <= Register1(3 downto 0) ; 
			
	
		
			
		When '1' => 
			HDig7 <= Register2(31 downto 28) ; 
			HDig6 <= Register2(27 downto 24) ; 
			HDig5 <= Register2(23 downto 20) ; 
			HDig4 <= Register2(19 downto 16) ; 
			HDig3 <= Register2(15 downto 12) ; 
			HDig2 <= Register2(11 downto 8) ; 
			HDig1 <= Register2(7 downto 4) ; 
			HDig0 <= Register2(3 downto 0) ; 
			
		
	

		End Case;
End Process;


--CE-N


-----------------------------------------------------------------------------
-- process 
-- reading the input into register1
-----------------------------------------------------------------------------
process (Clock, Reset_n) is
begin
		if ( Reset_n = '0') then  -- if reset is pushed 
			 Register1 <= "00000000000000000000000000000000"; -- set register1 to 0
			 Register2 <= "00000000000000000000000000000000"; -- set register1 to 0
			
		elsif (Clock'EVENT AND Clock = '1' ) then
			if (CE_N = '0' AND R_Wn = '0') then -- when CE_N is asserted low
				-- wirte to the lower bits of Register1&2
				if (ByteEn(0) = '1')then
						if ( ADDR = "000" )then
							Register1(7 downto 0) <= WRData(7 downto 0);
						elsif ( ADDR = "010" )then
							Register1(23 downto 16) <= WRData(7 downto 0);
						elsif ( ADDR = "100" )then
							Register2(7 downto 0) <= WRData(7 downto 0);
						elsif ( ADDR = "110" )then
							Register2(23 downto 16) <= WRData(7 downto 0);
						end if;
				end if;		
						
				-- wirte to the upper bits of Register1&2		
				if (ByteEn(1) = '1')then 
						if ( ADDR = "000" )then
							Register1(15 downto 8) <= WRData(15 downto 8);
						elsif ( ADDR = "010" )then
							Register1(31 downto 24) <= WRData(15 downto 8);
						elsif ( ADDR = "100" )then
							Register2(15 downto 8) <= WRData(15 downto 8);
						elsif ( ADDR = "110" )then
							Register2(31 downto 24) <= WRData(15 downto 8);
						end if;
				end if;
			end if;
		end if;
end process;





-- assert read for Register 1 independently of the clock.

		RDData(15 downto 0) <= Register1(15 downto 0) when ( R_Wn = '1' AND (ADDR = "000") )else
		Register1(31 downto 16) when ( R_Wn = '1' AND (ADDR = "010") ) else 
		Register2(15 downto 0) when  ( R_Wn = '1' AND (ADDR = "100" )) else 
		Register2(31 downto 16) when ( R_Wn = '1' AND (ADDR = "110")) else (others => '0');
				

End Display;
