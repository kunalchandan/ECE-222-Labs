##############################################
## Name:    Lab0_Template.s  				##
## Purpose:	A Template for RISC-V Assembly	##
## Author:	Mahmoud A. Elmohr 				##
##############################################

# The main function must be initialized in that manner in order to compile properly on the board
.text
.globl	main
main:
	# Put your initializations here
	
    
    # an infinite loop, almost needed in any embedded systems code
	while_1:
		# Put your main code here
		
		j while_1		# j label is a pseudo-instruction equivalent to beq x0,x0,label
