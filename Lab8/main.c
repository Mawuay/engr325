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
#define AUTO 1
#define MANUAL 0

/* Declare a global variable to hold the edge capture value. */
volatile alt_32 p_Edge_Capture;
volatile alt_u64 Counter = 0;

static void HandleButtonInterrupts(void* context, alt_u32 id) 
{
	/* cast the context pointer to an integer pointer. */
	volatile alt_32* p_Edge_Capture_Ptr = (volatile alt_32*) context;

	/*
	 * Read the edge capture register on the button PIO.
	 * Store value.
	 */

	*p_Edge_Capture_Ptr = IORD_ALTERA_AVALON_PIO_EDGE_CAP(KEY_BASE);
	/* Write to the edge capture register to reset it. */
	IOWR_ALTERA_AVALON_PIO_EDGE_CAP(KEY_BASE, 0x0);
	/* reset interrupt capability for the Button PIO. */
	IOWR_ALTERA_AVALON_PIO_IRQ_MASK(KEY_BASE, 0xf);
}

/* Initialize the button_pio. */
static void InitKeyPio() 
{
	/* Recast the p_Edge_Capture pointer to match the alt_irq_register() function prototype. */
	void* p_Edge_Capture_Ptr = (void*) &p_Edge_Capture;
	/* Enable all 4 button interrupts. */
	IOWR_ALTERA_AVALON_PIO_IRQ_MASK(KEY_BASE, 0xf);
	/* Reset the edge capture register. */
	IOWR_ALTERA_AVALON_PIO_EDGE_CAP(KEY_BASE, 0x0);
	/* Register the ISR. */
	alt_irq_register(KEY_IRQ, p_Edge_Capture_Ptr, HandleButtonInterrupts);
}

/* Initialises the timeer and sets the period to 100us */
static void TimerInit() 
{
	IOWR(TIMER_0_BASE, ALTERA_AVALON_TIMER_PERIODL_REG, 0x1388);
	IOWR(TIMER_0_BASE, ALTERA_AVALON_TIMER_PERIODH_REG, 0x0);
	alt_avalon_timer_sc_init(TIMER_0_BASE, TIMER_0_IRQ_INTERRUPT_CONTROLLER_ID,
			TIMER_0_IRQ, TIMER_0_FREQ);
}

/* Updates the display every 100ms */
static void RefreshDisplay(alt_8 mode, alt_up_character_lcd_dev * char_lcd_dev, alt_8 duty_cycle) 
{
	alt_u8 first_row[15] = "\0";
	alt_u8 second_row[15] = "\0";
	alt_u8 operating_mode[7] = "\0";
	alt_u8 number[3] = "";

	strcpy(first_row, "");
	strcat(first_row, "Dutycycle = ");
	number[2] = '0' + (duty_cycle / 1) % 10;
	number[1] = '0' + (duty_cycle / 10) % 10;

	if (duty_cycle >= 100) 
	{
		number[0] = '1';
	} else
	{
		number[0] = ' ';
	}
	strcat(first_row, number);
	strcat(first_row, "%");

	// Output to the LCDS
	alt_up_character_lcd_init(char_lcd_dev);
	alt_up_character_lcd_string(char_lcd_dev, first_row);
	alt_up_character_lcd_set_cursor_pos(char_lcd_dev, 0, 1);

	if (mode == AUTO)
	{
		strcpy(operating_mode, "Auto");
		strcpy(second_row, "");
		strcat(second_row, "Mode = ");
		strcat(second_row, operating_mode);
	}
	else if (mode == MANUAL)
	{
		strcpy(operating_mode, "Manual");
		strcpy(second_row, "");
		strcat(second_row, "Mode = ");
		strcat(second_row, operating_mode);
	}
	alt_up_character_lcd_string(char_lcd_dev, second_row);
	alt_up_character_lcd_cursor_blink_on(char_lcd_dev);
}

/* Flashes the HEX displays in response to the dutyCycle */
static void PwmFunction(alt_8 duty_cycle, alt_up_parallel_port_dev * hexL) 
{
	//Flashing the HEX displays
	if ((alt_nticks() % 100) < duty_cycle) {
		alt_up_parallel_port_write_data(hexL, 0xffffffff);
	}
	else
	{
		alt_up_parallel_port_write_data(hexL, 0x00000000);
	}
}

int main(void)
{
	//Declaration of constants and variables
	TimerInit();
	InitKeyPio();
	volatile alt_8 duty_cycle = 0; // The dutycyle did not update untill it was made volatile.
	alt_8 mode = AUTO;
	alt_8 uptick = 1;

	// declaration of global vairables for the LCD, Timer and Key ports.
	alt_up_parallel_port_dev * hexL;
	hexL = alt_up_parallel_port_open_dev("/dev/SevenSeg30");
	alt_up_character_lcd_dev * char_lcd_dev;
	char_lcd_dev = alt_up_character_lcd_open_dev("/dev/LCD");

	while (1)
	{
		PwmFunction(duty_cycle, hexL);

		/* Interupt Service routine for the KEY1 press */
		if (p_Edge_Capture & KEY1_MASK)
		{
			if (mode == AUTO)
			{
				mode = MANUAL;
			} else if (mode == MANUAL)
			{
				mode = AUTO;
			}
			p_Edge_Capture = 0;
		}
		// Condition that determines counting up or down
		if (duty_cycle == 100)
		{
			uptick = 0;
		}
		else if (duty_cycle == 0)
		{
			uptick = 1;
		}

		if ((Counter - alt_nticks()) <= 0)
		{
			if (mode == AUTO)
			{
				if (uptick == 1)
				{
					duty_cycle++;
				}
				else if (uptick == 0)
				{
					duty_cycle -= 2;
				}
			}
			// Calls for the LCD to be updated
			RefreshDisplay(mode, char_lcd_dev, duty_cycle); 
			Counter = alt_nticks() + 1000;
		}

		if (mode == MANUAL)
		{
			/* Interupt Service routine for the KEY2 press */
			if (p_Edge_Capture & KEY2_MASK)
			{
				//Increasing the duty_cycle value 
				if (duty_cycle <= 5)
				{
					duty_cycle = 0;

				}
				else
				{
					duty_cycle -= 5;
					p_Edge_Capture = 0;
				}
			}
			/* Interupt Service routine for the KEY3 press */
			else if (p_Edge_Capture & KEY3_MASK)
			{
				//Decreasing the duty_cycle value
				if (duty_cycle >= 95)
				{
					duty_cycle = 100;
				}
				else
				{
					duty_cycle += 5;
					p_Edge_Capture = 0;
				}
			}
		}
	}

	return 0;

}
