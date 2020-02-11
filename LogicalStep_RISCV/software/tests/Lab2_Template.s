##################################################
## Name:    Lab2_Template.s  					##
## Purpose:	Morse Code Transmitter		 		##
## Author:	Mahmoud A. Elmohr 					##
##################################################

# Start of the data section
.data			
.align 4						# To make sure we start with 4 bytes aligned address (Not important for this one)
InputLUT:						
	# Use the following line only with the board
	.ascii "SOS"				# Put the 5 Letters here instead of ABCDE
	# Note: the memory is initialized to zero so as long as there are not 4*n characters there will be at least one zero (NULL) after the last character
	
	# Use the following 2 lines only on Venus simulator
	#.asciiz "ABCDE"			# Put the 5 Letters here instead of ABCDE	
	#.asciiz "X"				# Leave it as it is. It's used to make sure we are 4 bytes aligned  (as Venus doesn't have the .align directive)

.align 4						# To make sure we start with 4 bytes aligned address (This one is Important)
MorseLUT:
	.word 0xE800	# A
	.word 0xAB80	# B
	.word 0xBAE0	# C
	.word 0xAE00	# D
	.word 0x8000	# E
	.word 0xBA80	# F
	.word 0xBB80	# G
	.word 0xAA00	# H
	.word 0xA000	# I
	.word 0xEEE8	# J
	.word 0xEB80	# K
	.word 0xAE80	# L
	.word 0xEE00	# M
	.word 0xB800	# N
	.word 0xEEE0	# O
	.word 0xBBA0	# P
	.word 0xEBB8	# Q
	.word 0xBA00	# R
	.word 0xA800	# S
	.word 0xE000	# T
	.word 0xEA00	# U
	.word 0xEA80	# V
	.word 0xEE80	# W
	.word 0xEAE0	# X
	.word 0xEEB8	# Y
	.word 0xAEE0	# Z



# The main function must be initialized in that manner in order to compile properly on the board
.text
.globl	main
main:
	# Put your initializations here
	lui s1, 0x7ff60	 			# assigns s1 with the LED base address (Could be replaced with lui s1, 0x7ff60)
	li s2, 0x01					# assigns s2 with the value 1 to be used to turn the LED on
	la s3, InputLUT				# assigns s3 with the InputLUT base address
	la s4, MorseLUT				# assigns s4 with the MorseLUT base address

	# Let x1 = return address (ra)
	# Let x2 = stack pointer (sp)
	# Let a0 = holds argument for Delay 


    ResetLUT:
		mv s5, s3				# assigns s5 to the address of the first byte  in the InputLUT

	NextChar:
		lbu a0, 0(s5)				# loads one byte from the InputLUT
		addi s5, s5, 1				# increases the index for the InputLUT (For future loads)
		bne a0, zero, ProcessChar	# if char is not NULL, jumps to ProcessChar
		# If we reached the end of the 5 letters, we start again
		jal LED_OFF
		li a0, 4 					# delay 4 extra spaces (7 total) between words to terminate
		jal DELAY				
		j ResetLUT					# start again

	ProcessChar:
		jal CHAR2MORSE				# convert ASCII to Morse pattern in a0	

	RemoveZeros:
		# Write your code here to remove trailling zeroes until you reach a one
		addi t0, a0, 0
		add t1, zero, zero
		li t3, 1

		REMOVE_LOOP:
			srli t0, t0, 0x1
			# Mask the shifted value with a 1 
			and t1, t0, t3
			# If it is zero, do it again
			bne t1, t3, REMOVE_LOOP
		# store shifted value into s11 
		# This is the morse code version of the char
		add s11, t0, zero
		
	
	Shift_and_display:
		# Write your code here to peel off one bit at a time and turn the light on or off as necessary
		add t0, s11, zero
		# Make mask
		li t1, 1
	
		# AND mask and LSB
		and t2, t1, t0

		la t3, LED_ON
		bne t2, zero, _ENDIF
		# if the LSB = 1
		la t3, LED_OFF
		_ENDIF:
		
		jalr ra, 0(t3)
		
		# Set delay time to 500ms
		addi a0, zero, 0x1
		# Delay after the LED has been turned on or off
		jal DELAY
	
		# Test if all bits are shifted
		# If we're not done then loop back to Shift_and_display to shift the next bit
		srli s11, s11, 1
		add t0, zero, s11
		bne t0, zero, Shift_and_display

		jal LED_OFF
		addi a0, zero, 0x3
		jal DELAY

		# If we're done then branch back to get the next character
		j NextChar
# End of main function




# Subroutines
LED_OFF:
	## OFF Signal
	addi s2, zero, 0x00
	## LOAD into LEDS
	sw s2, 0(s1)
	# Jump and link: link to nothing, return to caller 
	jr ra
	
	
LED_ON:
	## ON Signal 
	addi s2, zero, 0x01
	## LOAD into LEDS
	sw s2, 0(s1)
	# Jump and link: link to nothing, return to caller 
	jr ra


DELAY:
	# t0 is the counter
	add t0, zero, zero
	# The number of times we need to loop 
	add t1, zero, zero
	# set the number of clock cycles for which we count
	li t2, 0x5F5E10
	# the number of times we need to loop to get the delay time (multiply)
	add t3, zero, zero

	mul t1, a0, t2
	# # Multiply by the number a0 * 500ms

	DELAY_LOOP:
		addi t0, t0, 0x1 # t0 = t0 + 1
		bne t0, t1, DELAY_LOOP # if t0 == t1 then DELAY_LOOP
	
	jr ra


CHAR2MORSE:
	# Insert your code here to convert the ASCII code to an index and lookup the Morse pattern in the Lookup Table
	# a0 = MorseLUT[4 * a0]
	add t0, a0, zero # t0 contains 16 bits from ASCII or 2 bytes
	addi t0, t0, -0x41 # convert to offset from 0
	slli t0, t0, 2 # convert to byte addressable

	# Get address in LUT
	add t0, t0, s4
	
	lw a0, 0(t0)
	jr ra
