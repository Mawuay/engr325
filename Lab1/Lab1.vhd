LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY Lab1 IS

PORT (
	CLOCK_50 	: IN STD_LOGIC;
	GPIO_0		: OUT STD_LOGIC_VECTOR (0 DOWNTO 0);
	KEY 		: IN STD_LOGIC_VECTOR (0 DOWNTO 0);
	UART_RXD 	: IN STD_LOGIC;
	UART_TXD 	: OUT STD_LOGIC;
	LCD_DATA	: INOUT STD_LOGIC_VECTOR (7 DOWNTO 0);
	LCD_ON 		: OUT STD_LOGIC;
	LCD_BLON 	: OUT STD_LOGIC;
	LCD_EN 		: OUT STD_LOGIC;
	LCD_RS 		: OUT STD_LOGIC;
	LCD_RW 		: OUT STD_LOGIC
);
END Lab1;

ARCHITECTURE Lab1_rtl OF Lab1 IS
    component nios_system is
        port (
            clk_clk       : in    std_logic                    := 'X';             -- clk
            reset_reset_n : in    std_logic                    := 'X';             -- reset_n
            rs232_RXD     : in    std_logic                    := 'X';             -- RXD
            rs232_TXD     : out   std_logic;                                       -- TXD
            lcd_DATA      : inout std_logic_vector(7 downto 0) := (others => 'X'); -- DATA
            lcd_ON        : out   std_logic;                                       -- ON
            lcd_BLON      : out   std_logic;                                       -- BLON
            lcd_EN        : out   std_logic;                                       -- EN
            lcd_RS        : out   std_logic;                                       -- RS
            lcd_RW        : out   std_logic                                        -- RW
        );
    end component nios_system;
	 
	 component ClockDividerCircuit is 
		port (
			 Clock  		: in std_logic;
			 Reset_n  	: in std_logic;
			 ClockOut	: out std_logic
		);
	end component ClockDividerCircuit;
BEGIN
   -- mapping the nios_system
	 u0 : component nios_system
        port map (
            clk_clk       => CLOCK_50,      --   clk.clk
            reset_reset_n => KEY(0), 		  -- reset.reset_n
            rs232_RXD     => UART_RXD,      -- rs232.RXD
            rs232_TXD     => UART_TXD,      --      .TXD
            lcd_DATA      => LCD_DATA(7 DOWNTO 0),      --   lcd.DATA
            lcd_ON        => LCD_ON,        --      .ON
            lcd_BLON      => LCD_BLON,      --      .BLON
            lcd_EN        => LCD_EN,        --      .EN
            lcd_RS        => LCD_RS,        --      .RS
            lcd_RW        => LCD_RW         --      .RW
        );
		  
	-- mapping the clock divider circuit
	 ClkDiv : component ClockDividerCircuit
			port map (
				Clock 		=> CLOCK_50,
				Reset_n		=> KEY(0),
				ClockOut		=> GPIO_0(0)
			);
	
END Lab1_rtl;



