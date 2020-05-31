#include "altera_up_avalon_character_lcd.h"
#include "altera_avalon_timer_regs.h"
#include "altera_up_avalon_parallel_port.h"
#include "altera_up_avalon_parallel_port_regs.h"
#include "altera_avalon_timer.h"
#include <stdio.h>
#include "sys/alt_timestamp.h"
#include "alt_types.h"
#include "system.h"
#include "altera_avalon_pio_regs.h"
#include "alt_types.h"
#include "sys/alt_irq.h"


#define KEY3_MASK 0x08  //obaitned from memeory tab in altera by pressing keys
#define KEY2_MASK 0x04
#define KEY1_MASK 0x02


/* Declare a global variable to hold the edge capture value. */
volatile int edge_capture;



static void handle_button_interrupts(void* context, alt_u32 id) {
		
	/* cast the context pointer to an integer pointer. */
	volatile int* edge_capture_ptr = (volatile int*) context;

	/*
	* Read the edge capture register on the button PIO.
	* Store value.
	*/

	*edge_capture_ptr = IORD_ALTERA_AVALON_PIO_EDGE_CAP(KEY_BASE);
	/* Write to the edge capture register to reset it. */
	IOWR_ALTERA_AVALON_PIO_EDGE_CAP(KEY_BASE, 0x0);
	/* reset interrupt capability for the Button PIO. */
	IOWR_ALTERA_AVALON_PIO_IRQ_MASK(KEY_BASE, 0xf);
}




/* Initialize the button_pio. */
static void init_KEY_pio() {
	/* Recast the edge_capture pointer to match the alt_irq_register() function prototype. */
	void* edge_capture_ptr = (void*) &edge_capture;
	/* Enable all 4 button interrupts. */
	IOWR_ALTERA_AVALON_PIO_IRQ_MASK(KEY_BASE, 0xf);
	/* Reset the edge capture register. */
	IOWR_ALTERA_AVALON_PIO_EDGE_CAP(KEY_BASE, 0x0);
	/* Register the ISR. */
	alt_irq_register( KEY_IRQ,edge_capture_ptr,handle_button_interrupts );
}


static void timerInit() {
	alt_avalon_timer_sc_init (TIMER_0_BASE,  TIMER_0_IRQ_INTERRUPT_CONTROLLER_ID, 
                                      TIMER_0_IRQ, TIMER_0_FREQ);
}




int main(void)
{
	//Declaration of constants and variables
	timerInit();
	init_KEY_pio();
	int flashCount;
	int y;
	int hexOn;
	char time[8];
	char copyTime[8] = "\0";
	unsigned long ticks  = 0; 
	unsigned long resetTicks = 0;
	
	// declaration of global vairables for the LCD, Timer and Key ports.
	alt_up_parallel_port_dev * hexL;
	alt_up_parallel_port_dev * hexH;
	hexL = alt_up_parallel_port_open_dev ("/dev/SevenSeg30");
	hexH = alt_up_parallel_port_open_dev ("/dev/SevenSeg74");
	alt_up_character_lcd_dev * char_lcd_dev;
	char_lcd_dev = alt_up_character_lcd_open_dev ("/dev/LCD");
	
	while (1) {
		
		// 1 sec = 100 ticks; 1 min = 6000 ticks; 10 mins = 60000 ticks
		ticks = (alt_nticks() - resetTicks)/1; 
		copyTime[7] = '\0';
		time[7] = '\0';
		time[6] = '0'+((ticks / 10) % 10);
		time[5] = '.' ;
		time[4] = '0'+((ticks / 100 ) % 10);
		time[3] = '0'+((ticks / 1000 ) % 6);
		time[2] = ':';
		time[1] = '0'+((ticks / 6000 ) % 10);
		time[0] = '0'+((ticks / 60000 ) % 10);
				
	
		for ( y = 0; y  < 150000 ; y++) {
				asm("nop;nop;nop;");
		} 
	
		alt_up_character_lcd_init (char_lcd_dev); 
		alt_up_character_lcd_string(char_lcd_dev, time);
		alt_up_character_lcd_set_cursor_pos(char_lcd_dev, 0, 1); 
		alt_up_character_lcd_string(char_lcd_dev, copyTime);
		alt_up_character_lcd_cursor_blink_on(char_lcd_dev);
	
	/* Interupt Service routine for the KEY presses */
		if (edge_capture & KEY1_MASK) {
			//Reseting the timer
			resetTicks = alt_nticks();
			ticks = 0;
			copyTime[0] =  0;
			edge_capture = 0;
		}
		else if (edge_capture & KEY2_MASK) { 
			//Duplicating the time on the second line
			strcpy(copyTime, time);
			edge_capture = 0;
		}
		else if (edge_capture & KEY3_MASK){
			//flash three times
			flashCount = alt_nticks() + 300;
			edge_capture = 0;
	
		}
		

		//Flashing the HEX displays
		if (flashCount >= alt_nticks()) {
			if ((flashCount - alt_nticks()) % 100 > 50){
				if (hexOn == 1) {
					alt_up_parallel_port_write_data(hexL, 0xffffffff);
					alt_up_parallel_port_write_data(hexH, 0xffffffff);
					hexOn = 0;
				}
			}
			else {
				if (hexOn == 0){
					alt_up_parallel_port_write_data(hexL, 0x00000000);
					alt_up_parallel_port_write_data(hexH, 0x00000000);
					hexOn = 1;
				}
			}
		}
			
	}
	
	
	return 0;

}
