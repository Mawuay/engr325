#include <io.h>
#include "busbridgehal.h"

int main() {
	unsigned int SRAMbase;									// SRAM base address
	unsigned int OnChipRAMbase;
	unsigned int mem_point;									// memory fill pointer and fill variable
	unsigned int mem_fill;	
	unsigned int SevenSegBase;	
	
	OnChipRAMbase = 0x100200;
	SevenSegBase = 0x100000;
/* 	
// code that exercises the off-chip SRAM
	writeBusIO(4, SevenSegBase, 0x00, 0x87654321);				// write a word to the first address of the SRAM
	writeBusIO(2, SevenSegBase, 0x04, 0x5a78);
	writeBusIO(1, SevenSegBase, 0x06, 0x3c);
	writeBusIO(1, SevenSegBase, 0x07, 0x1f);
	
// add commands to read back the memory using readBusIO() function
	readBusIO(1, SevenSegBase, 0x00);
	readBusIO(1, SevenSegBase, 0x01);
	readBusIO(2, SevenSegBase, 0x02);
	readBusIO(4, SevenSegBase, 0x04); */
	

	int sub = 999;
	mem_fill=200000;
	mem_point=0x00;

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
	
	unsigned int HEXplus3 = 0x0;
	unsigned int HEXplus6 = 0x0;
	unsigned int HEXplus7 = 0x0;
	unsigned int HEXsuba = 0x0;
	unsigned int y = 0;
	
	while(1){
		writeBusIO(1, SevenSegBase, 0x00, HEXplus3);
		writeBusIO(1, SevenSegBase, 0x01, HEXplus6);
		writeBusIO(1, SevenSegBase, 0x02, HEXplus7);
		writeBusIO(1, SevenSegBase, 0x03, HEXsuba);
		HEXplus3 += 0x03;
		HEXplus6 += 0x06;
		HEXplus7 += 0x07;
		HEXsuba	-=0x0a;
		
		for (y = 0; y  < 1500000 ; y++) {
				asm("nop;nop;nop;");
			}

	}
	
	return 0; 

	
}
