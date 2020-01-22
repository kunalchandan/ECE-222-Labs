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
	.ascii "BIRDS"				# Put the 5 Letters here instead of ABCDE
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
	li s1, 0x7ff60	 			# assigns s1 with the LED base address (Could be replaced with lui s1, 0x7ff60)
	li s2, 0x01					# assigns s2 with the value 1 to be used to turn the LED on
	la s3, InputLUT				# assigns s3 with the InputLUT base address
	la s4, MorseLUT				# assigns s4 with the MorseLUT base address

	# Let x1 = return address (ra)
	# Let x2 = stack pointer (sp)
	# Let a0 = holds argument for Delay 
	#sw zero, 0(s1)				# Turn the LED off
	jal LED_ON

    ResetLUT:
		mv s5, s3				# assigns s5 to the address of the first byte  in the InputLUT

	NextChar:
		lbu a0, 0(s5)				# loads one byte from the InputLUT
		addi s5, s5, 1				# increases the index for the InputLUT (For future loads)
		bne a0, zero, ProcessChar	# if char is not NULL, jumps to ProcessChar
		# If we reached the end of the 5 letters, we start again
		li a0, 4 					# delay 4 extra spaces (7 total) between words to terminate
		jal DELAY				
		j ResetLUT					# start again

	ProcessChar:
		jal CHAR2MORSE				# convert ASCII to Morse pattern in a0	

	RemoveZeros:
		# Write your code here to remove trailling zeroes until you reach a one
		lw t0, 0(a0)
		add t1, zero, zero

		REMOVE_LOOP:
			srl t0, t0, 1
			# Mask the shifted value with a zero
			andi t1, t0, 0x1
			beq t1, zero, REMOVE_LOOP
		# store shifted value into a0 
		add a0, t0, zero
		
	
	Shift_and_display:
		# Write your code here to peel off one bit at a time and turn the light on or off as necessary
		add t0, a0, zero
		add t1, zero, 0x1
	
		# AND mask and LSB
		and t2, t1, t0

		la t3, LED_ON
		bne t2, zero, _ENDIF
		# if the LSB = 1
		la t3, LED_OFF
		_ENDIF:
		
		jalr ra, t3, 0

		# Delay after the LED has been turned on or off
		jal DELAY
	
		# Test if all bits are shifted
		# If we're not done then loop back to Shift_and_display to shift the next bit
		srl t0, t0, 1
		bne t0, zero, Shift_and_display
		
		# If we're done then branch back to get the next characte
		j NextChar
# End of main function




# Subroutines
LED_OFF:
	## OFF Signal
	li s6, 0x00
	## LOAD into LEDS
	sw s6, 0(s1)
	# Jump and link: link to nothing, return to caller 
	jr ra
	
	
LED_ON:
	## ON Signal 
	li s6, 0xFF
	## LOAD into LEDS
	sw s6, 0(s1)
	# Jump and link: link to nothing, return to caller 
	jr ra


DELAY:
	# t0 is the counter
	addi t0, zero, 0
	# The number of times we need to loop 
	addi t1, zero, 0
	# set the number of clock cycles for which we count
	li t2, 0x5F5E10
	# the number of times we need to loop to get the delay time (multiply)
	add t3, zero, zero

	# if argument is zero, return
	# beq zero, a0, 0(ra) # if zero == a0 then 

	# Multiply by the number a0 * 500ms
	DELAY_MUL_LOOP:
		add t1, t1, t2 # t1 = t1 + t2
		addi t3, t3, 0x1
		bne a0, t3, DELAY_MUL_LOOP

	DELAY_LOOP:
		addi t0, t0, 1 # t0 = t0 + 1
		bne t0, t1, DELAY_LOOP # if t0 == t1 then DELAY_LOOP
	
	jr ra


CHAR2MORSE:
	# Insert your code here to convert the ASCII code to an index and lookup the Morse pattern in the Lookup Table
	# a0 = MorseLUT[4 * a0]
	add t0, zero, zero
	lw t0, 0(a0) # t0 contains 16 bits from ASCII or 2 bytes
	addi t0, t0, -0x41 #
	slli t0, t0, 2

	# Get address in LUT
	add t0, t0, s4
	
	lw a0, 0(t0)
	jr ra
