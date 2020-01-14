##################################################
## Name:    Lab3_Template.s  					##
## Purpose:	Reaction Time Measurement	 		##
## Author:	Mahmoud A. Elmohr 					##
##################################################

# Start of the data section
.data			
.align 4						# To make sure we start with 4 bytes aligned address (Not important for this one)
SEED:
	.word 0x1234				# Put any non zero seed
	
# The main function must be initialized in that manner in order to compile properly on the board
.text
.globl	main
main:
	# Put your initializations here
	li s1, 0x7ff60000 			# assigns s1 with the LED base address (Could be replaced with lui s1, 0x7ff60)
	li s2, 0x7ff70000 			# assigns s2 with the push buttons base address (Could be replaced with lui s2, 0x7ff70)

	
	
	
	# Write your code here
	
	
	
	
	
	
# End of main function		
		







# Subroutines			
DELAY:
	# Insert your code here to make a delay of a0 * 0.1 ms
	
	jr ra



DISPLAY_NUM:
	# Insert your code here to display the 32 bits in a0 on the LEDs byte by byte (Least isgnificant byte first) with 2 seconds delay for each byte and 5 seconds for the last
	
	jr ra



RANDOM_NUM:
	# This is a provided pseudorandom number generator no need to modify it, just call it using JAL (the random number is saved at a0)
	addi sp, sp, -4				# push ra to the stack
	sw ra, 0(sp)
	la gp, SEED				# load address of the random number in memory
	
	lw t0, 0(gp)				# load the seed or the last previously generated number from the data memory to t0
	li t1, 0x8000
	and t2, t0, t1				# mask bit 16 from the seed
	li t1, 0x2000
	and t3, t0, t1				# mask bit 14 from the seed
	slli t3, t3, 2				# allign bit 14 to be at the position of bit 16
	xor t2, t2, t3				# xor bit 14 with bit 16
	li t1, 0x1000		
	and t3, t0, t1				# mask bit 13 from the seed
	slli t3, t3, 3				# allign bit 13 to be at the position of bit 16
	xor t2, t2, t3				# xor bit 13 with bit 14 and bit 16
	andi t3, t0, 0x400				# mask bit 11 from the seed
	slli t3, t3, 5				# allign bit 14 to be at the position of bit 16
	xor t2, t2, t3				# xor bit 11 with bit 13, bit 14 and bit 16
	srli t2, t2, 15				# shift the xoe result to the right to be the LSB
	slli t0, t0, 1				# shift the seed to the left by 1
	or t0, t0, t2				# add the XOR result to the shifted seed 
	li t1, 0xFFFF				
	and t0, t0, t1				# clean the upper 16 bits to stay 0
	sw t0, 0(gp)				# store the generated number to the data memory to be the new seed
	mv a0, t0					# copy t0 to a0 as a0 is always the return value of any function
	
	lw ra, 0(sp)				# pop ra from the stack
	addi sp, sp, 4
	jr ra

