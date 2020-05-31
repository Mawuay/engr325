#include "altera_up_avalon_character_lcd.h"
#include "altera_up_avalon_rs232.h"

int main(void)
{
	alt_up_character_lcd_dev * char_lcd_dev;
	alt_up_rs232_dev* serial;
	
	// open the Character LCD port
	char_lcd_dev = alt_up_character_lcd_open_dev ("/dev/LCD");

	/* Initialize the character display */
	alt_up_character_lcd_init (char_lcd_dev);
	
	/*Open the Serial connection */
	serial = alt_up_rs232_open_dev ("/dev/Serial");

	/* Write "Test" in the first row */
	alt_up_character_lcd_string(char_lcd_dev, "Test\n");
	
	/* Write data to the RS232 UART core*/
/* 	alt_u8 data[] = "Test\0";
	int alt_up_rs232_write_data(alt_up_rs232_dev *rs232, alt_u8 data); */
	
	
	
}