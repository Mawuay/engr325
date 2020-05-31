/* this will guard against including this file multiple times during compilation */
#ifndef _busbridgehal_h
#define _busbridgehal_h

/* declare function prototypes of the functions found in the busbridgehal_h.c file */
int getBaseAddr(char *name);

unsigned int readBusIO(int size, unsigned int base, int b_offset);

int writeBusIO(int size, unsigned int base, int b_offset, int data);

#endif
