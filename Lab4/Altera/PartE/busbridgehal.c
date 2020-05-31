#include "busbridgehal.h"
#include "io.h"
#include "string.h"

/* Description comments */
int getBaseAddr(char *name)
{
	if (strcmp(name, "/dev/SRAM") == 0){
		return (unsigned int) 0x00180000;	// return the SRAM base address
	}
	else return -1;
}

/* Description comments */
unsigned int readBusIO(int size, unsigned int base, int b_offset)
{
	unsigned int value = 0;
	if (size == 4) {
		value = IORD_32DIRECT(base, b_offset);
	}
	else if (size == 2) {
		value = IORD_16DIRECT(base, b_offset);
	}
	else if (size == 1) {
		value = IORD_8DIRECT(base, b_offset);
	}
	return value;	

}


/* Description comments */
int writeBusIO(int size, unsigned int base, int b_offset, int data)
{
	if (size == 4) {
		IOWR_32DIRECT(base, b_offset, data);
		return 0;
	}
	else if (size == 2) {
		IOWR_16DIRECT(base, b_offset, data);
		return 0;
	}
	else if (size == 1) {
		IOWR_8DIRECT(base, b_offset, data);
		return 0;
	}
	else
		return 1;			// return 1 if invalid size
}

