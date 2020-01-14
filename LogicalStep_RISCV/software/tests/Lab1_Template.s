##################################################
## Name:    Lab1_Template.s                     ##
## Purpose:	A Template for flashing LED         ##
## Author:	Mahmoud A. Elmohr                   ##
##################################################

# The main function must be initialized in that manner in order to compile properly on the board
.text
.globl	main
main:
	lui s1, 0x7FF60 ## Stores the most 20 sig bits as argument 0x7FF60
    addi s2, zero, 0xFF ## Stores the 8 least sig bits as 0xFF
    sw s2, 0(s1) ## store 0xFF into s2 least sig bits so that it turns on
    ## s3 is counter
	## Comes from 25MHz divided by 4 beacuse .5 second on .5 second off and 2 instructions in main loop
    li s4, 0x5F5E10
    li s5, 0x55
	
    TOGGLE:
    	## TOGGLE LEDS
    	xori s5, s5, 0xFF
        ## LOAD into LEDS
    	sw s5, 0(s1)
        ## RESET COUNTER
        li s3, 0
        j while_0

    while_0:
    	addi s3, s3, 1
        
        BNE s3, s4, while_0
        BEQ s3, s4, TOGGLE