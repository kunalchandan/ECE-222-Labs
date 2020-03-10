##################################################
## Name:    Lab4_Template.s  					##
## Purpose:	Interrupt Handling			 		##
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
	li s0, 0					# Initializes s0 to be 0
	li s1, 0x7ff60000 			# assigns s1 with the LED base address (Could be replaced with lui s1, 0x7ff60)
	li s2, 0x7ff70000 			# assigns s2 with the push buttons base address (Could be replaced with lui s2, 0x7ff70)
	#li a0, 100					# 10 seconds

	# Enabling Interrupts from core side
	csrrsi zero, mstatus, 0x08 	#enable global interrupt
	csrrsi zero, 0x7C0, 0x02 	#enable push button interrupt line from core side	
	
	# Enable a specific push button interrupt from the PIO side (Check Appendix B)
	# Address = offset (2*4) + s2 where address is Interruptmask
	
	# Write your functional code here
	FLASH:
		li a0, 5
		jal LED_ON
		jal DELAY
		li a0, 5
		jal LED_OFF
		jal DELAY
	j FLASH
		
	
# End of main function		




# Subroutines						
DELAY:
	# Save the return address to the stack
	addi sp, sp, -0x4
	sw ra, 0(sp)
	# t0 is the counter for inner loop, t1 is the counter for outer loop (a0)
	add t0, zero, zero
	add t1, zero, zero
	# The number of times we need to do outer loop
	add t2, a0, zero
	# The number of times we need to do inner loop (clock cycles for which we count (0.1s))
	li s3, 0x1312D0


	# Multiply by the number a0 * 0.1s by running 0.1s a0 times
	DELAY_OUTER_LOOP:
		# t0 is the counter
		add t0, zero, zero
		# This delays for 0.1 seconds
		DELAY_LOOP:
			addi t0, t0, 0x1 			# increment DELAY_LOOP iterator
			bne t0, s3, DELAY_LOOP 		# if t0 != s3 then DELAY_LOOP
		addi t1, t1, 0x1				# increment DELAY_OUTER_LOOP iterator

		# TODO generate random number here
		# Since t0-3 is being used in GENERATE_TIME/RANDOM_NUM, we store the value of the counters before calling.
		addi sp, sp, -8
		sw t1, 0(sp)
		sw t2, 4(sp)
		jal GENERATE_TIME				# Returns a0 = [50s, 250s]
		lw t1, 0(sp)
		lw t2, 4(sp)
		addi sp, sp, 8

		# Store the random time into s0
		add s0, a0, zero

		bne t1, t2, DELAY_OUTER_LOOP; 	# if t1 != t2 then DELAY_OUTER_LOOP
	
	lw ra, 0(sp)
	addi sp, sp, 0x4
	jr ra



LED_OFF:
	## LOAD into LEDS
	sw x0, 0(s1)
	# Jump and link: link to nothing, return to caller 
	jr ra

LED_ON:
	addi t0, zero, 0xFF
	## LOAD into LEDS
	sw t0, 0(s1)
	# Jump and link: link to nothing, return to caller 
	jr ra

# Generates a time T = 0.003a0 + 50 where a0 is a number from 1-2^16 - 1 given by RANDOM_NUM
GENERATE_TIME:
	# Save the return address to the stack
	addi sp, sp, -4
	sw ra, 0(sp)

	# Sets a0 (x in y=mx+b) to a number [1, 2^16-1
	jal RANDOM_NUM

	# 0.0030518 ~= (1/2^8 - 1/2^10 + 1/2^13)
	srli t0, a0, 8
	srli t1, a0, 10
	srli t2, a0, 13

	sub a0, t0, t1 
	add a0, a0, t3

	# At this point we have 0.003X, we add the intercept and return in a0
	addi a0, a0, 50

	# Pop off the stack and return
	lw ra, 0(sp)
	addi sp, sp, 4
	jr ra


RANDOM_NUM:
	# This is a provided pseudo-random number generator no need to modify it, just call it using JAL (the random number is saved at a0)
	addi sp, sp, -4				# push ra to the stack
	sw ra, 0(sp)

	la gp, SEED				# load the address pointing to the last random number	
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
#	li t1, 0x400
#	and t3, t0, t1				# mask bit 11 from the seed
	andi t3, t0, 0x400			# mask bit 11 from the seed using immediate value that is 12-bit or less
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


# Interrupt Service Routine
.text
.globl	isr
isr:
	# De-bouncing (Due to the bouncing of mechanical switches, we need to de-bounce it to avoid entering the ISR many times for the same button press)
	li t1, 2000000
	debounce:
		addi t1, t1, -1
		bne t1, zero, debounce
		
	# Generate a number from 50 t0 255 and put it in S0	(You shouldn't call the RANDOM_NUM here, you should have called it in the main already and saved it in some register, you just need to make it fit the 50-255 requirement and save it to s0)
	

	#Clear push button interrupt PIO side to acknowledge handling the interrupt

	
	# Wait until store takes place and read by the PIO
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	
	mret					#return from interrupt

