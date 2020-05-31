#include "altera_up_avalon_character_lcd.h"
#include "altera_up_avalon_rs232.h"
#include <unistd.h>
#include <stdio.h> 


int main(void)
{
	// declaration of global vairables for the LCD and Serial
	alt_up_character_lcd_dev * char_lcd_dev;
	alt_up_rs232_dev* Serial;
	
	// open the Character LCD port
	char_lcd_dev = alt_up_character_lcd_open_dev ("/dev/LCD");

	/* Initialize the character display */
	alt_up_character_lcd_init (char_lcd_dev);
	
	/* Write "Username :" in the first row */
	alt_up_character_lcd_string(char_lcd_dev, "Enter login :");
	
	/* Write "the DE2 board" in the second row */
	char dummy[] = "\0";					// temporailiy houses characters that make up username 
	char username[] = "Daniel\0";			// hardcoded username
	char user_input[16]; 
	alt_up_character_lcd_set_cursor_pos(char_lcd_dev, 0, 1);
	//alt_up_character_lcd_string(char_lcd_dev, dummy);
	
	/* Open the Serial connection */
	Serial = alt_up_rs232_open_dev ("/dev/Serial");
	
	/* Declaraiotion of variables needed to read and write data to LCD and PuTTy */
	alt_u8 rs232_r_data;  					// character array in memory to house read data
	alt_u8 *rs232_r_ptr = &rs232_r_data;	// pointer to address of read character array 
	alt_u8 rs232_w_data1;					// character array in memory to house write data
	alt_u8 *rs232_w_ptr = &rs232_w_data1;	// pointer to address if write character array
	alt_u8 rs232_w_data2;					// character array in memory to house write data
	alt_u8 *rs232_w_ptr2 = &rs232_w_data2;	// pointer to address if write character array
	alt_u8 *parity_error;					// parity_error pointer for read funciton
	
	
	
	char *usernamePtr = dummy; 

	/*  The while loop runs continually checking keypresses to determine if a valid keystroke 
		has been entered.
		detects the user neme , waits for the enter keypress to end loop.
		*/
	while (1){
		int i = 0;
		if (alt_up_rs232_read_data( Serial, rs232_r_ptr, parity_error) == 0) { // if a read was successfull
			dummy[0] = rs232_r_data;
			rs232_w_data1 = rs232_r_data;			// data written to PuTTy
			alt_up_rs232_write_data(Serial, rs232_w_data1); // output char in rs232_w_data to PuTTy
			alt_up_character_lcd_string(char_lcd_dev , dummy);
			user_input[0] = dummy[0];
			i++;
			
			dummy[0] = "\0";
		}
		
		if (rs232_r_data == '\r') {
			i = 0;
			break;
		}
		
	}
	//while (1) {
	int x_left_shift_offset = -2;
	alt_up_character_lcd_init (char_lcd_dev);  // clears the display
	alt_up_character_lcd_string(char_lcd_dev , "Login received \0");
	alt_up_character_lcd_set_cursor_pos(char_lcd_dev, 0, 1);
	alt_up_character_lcd_string(char_lcd_dev , user_input[0]);
	
	//sleep(2);
	//alt_up_character_lcd_shift_display(char_lcd_dev, x_left_shift_offset); // shift LCD display to the left
	
	//}
}
