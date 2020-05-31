#include <io.h>
#include "busbridgehal.h"

int main() {
	unsigned int SRAMbase;									// SRAM base address
	unsigned int mem_point;									// memory fill pointer and fill variable
	unsigned int mem_fill;						
	
	SRAMbase = getBaseAddr("/dev/SRAM");					// get base address of bridge devices
	
	
// code that exercises the off-chip SRAM
	writeBusIO(4, SRAMbase, 0x00, 0x87654321);				// write a word to the first address of the SRAM
	writeBusIO(2, SRAMbase, 0x04, 0x5a78);
	writeBusIO(1, SRAMbase, 0x06, 0x3c);
	writeBusIO(1, SRAMbase, 0x07, 0x1f);
	
// add commands to read back the memory using readBusIO() function
	readBusIO(1, SRAMbase, 0x00);
	readBusIO(1, SRAMbase, 0x01);
	readBusIO(2, SRAMbase, 0x02);
	readBusIO(4, SRAMbase, 0x04);
	
}
