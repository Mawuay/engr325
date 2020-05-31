#include <io.h>
#include "busbridgehal.h"

int main() {
	unsigned int SRAMbase;									// SRAM base address
	unsigned int OnChipRAMbase;
	unsigned int mem_point;									// memory fill pointer and fill variable
	unsigned int mem_fill;						
	
	OnChipRAMbase = 0x100200;

	
// code that exercises the off-chip SRAM
	writeBusIO(4, OnChipRAMbase, 0x00, 0x87654321);				// write a word to the first address of the SRAM
	writeBusIO(2, OnChipRAMbase, 0x04, 0x5a78);
	writeBusIO(1, OnChipRAMbase, 0x06, 0x3c);
	writeBusIO(1, OnChipRAMbase, 0x07, 0x1f);
	
// add commands to read back the memory using readBusIO() function
	readBusIO(1, OnChipRAMbase, 0x00);
	readBusIO(1, OnChipRAMbase, 0x01);
	readBusIO(2, OnChipRAMbase, 0x02);
	readBusIO(4, OnChipRAMbase, 0x04);
	
/* 
	int sub = 999;
	mem_fill=200000;
	mem_point=0x00;


//
	while( mem_point <= 512){
		writeBusIO(4, OnChipRAMbase, mem_point, mem_fill);
		mem_fill = mem_fill-sub;
		mem_point += 0x04;
	}

 	SRAMbase = 0x1c0000;
	int readPointer = 0x00;
	int i = 0;
	int read;

	while (readPointer < 512){
		read = readBusIO(4, OnChipRAMbase, readPointer);
		writeBusIO(4, SRAMbase, readPointer, read);
		readPointer += 0x04;
	}
	return 0; 
 */
	
}
