/********************************************************************/
/* Name:   		Lab 3 Part C											*/
/* Course:  	ENGR 325											*/
/* Revision:	1.0, September 2019									*/
/********************************************************************/

.include "nios_macros.s"

/* Define reset vector address */
.equ RESET_VECTOR, 0x00

/* ".text" indicates the beginning of the code section 				*/
.text
.org RESET_VECTOR 	/* Place the main routine at the reset address 	*/
.global _start  	/* export the label _start to the outside world */
_start: 			/* Program start location must be identified 	*/

/***************************MAIN*************************************/

MAIN_PROG_INIT:					/* Initialize registers				*/
    movia 	r16,	0x180000	/* Base address of SRAM				*/
    movia 	r8,		0x87654321
    movia 	r9,		0x5a78
    movia 	r10,	0x3c
    movia 	r11,	0x1f
    mov 	r12,	r0
    mov 	r13,	r0
    mov 	r14,	r0
    mov 	r15,	r0

MAIN_PROG:
    stw		r8, 	0(r16)		/* Four stores						*/
    sth		r9, 	4(r16)
    stb		r10, 	6(r16)
    stb		r11, 	7(r16)
    
	ldbu	r12, 	0(r16)		/* Four loads to verify				*/
    ldbu	r13, 	1(r16)
    ldhu	r14, 	2(r16) 
    ldw 	r15, 	4(r16)

PROG_END:  						/* end of program code goes here	*/
	br PROG_END  				/* wait for a break					*/
