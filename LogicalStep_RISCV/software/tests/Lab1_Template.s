##################################################
## Name:    Lab1_Template.s  					##
## Purpose:	A Template for flashing LED 		##
## Author:	Mahmoud A. Elmohr 					##
##################################################

# The main function must be initialized in that manner in order to compile properly on the board
.text
.globl	main
main:
	# Put your initializations here
	lui s1, 0x7ff60 			# assigns s1 with the LED base address (Could be replaced with lui s1, 0x7ff60)
	addi s2, zero, 0x55			# assigns s2 with the 0x55 which will be later loaded to the LED to turn it on (0101 0101 lights)
	sw s2, 0(s1)				# storing s2 value to the LED base address to turn the LED on (you can delete this line along side with the prevuos one if you want, just for illustration on how to turn on and off the LED) 
	#li s3, 11					# sets the counter max, you need to change that number to make the 500ms delay
	addi s3, zero, 0xAA			# (1010 1010 lights)
	sw s3, 0(s1)
    # an infinite loop, almost needed in any embedded systems code
	while_1:
		# You might write some code here
		#
		
		
		
		
		# You might write some code here 
		# Also you might write another delay routine if using the long flowchart given in the lab manual
		
		
		j while_1				# j label is a pseudo-instruction equivalent to beq x0,x0,label
