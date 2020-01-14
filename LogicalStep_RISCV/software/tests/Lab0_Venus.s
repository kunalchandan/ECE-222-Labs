######################################
## Name:    Lab0_Venus.s  			##
## Purpose:	Reviewing RISC-V ISA	##
## Author:	Mahmoud A. Elmohr 		##
######################################

# The main function must be initialized in that manner in order to compile properly on the board
# this file introduces pseudo-instructions and an alternative naming of registers x0-x31

.text
.globl	main
main:
	# assigning the address 0x10000004 (which is in data memory section) to s0 register
	lui s0, 0x10000 	# assigns the most 20 significant bits of s0 to be 0x10000
    addi s0,s0, 0x004 	# assigns the least 12 significant bits of s0 to be 0x004
    # assigning the value 0x12345678 to s1 register
    li s1, 0x12345678	# a pseudo-instruction that translates to two consecutive instructions (lui, addi) as previously done for s0 – note the immediate value is a full 32-bits
    
    sw s1, 0(s0)		# stores the content of s1 (0x12345678) to the memory address that resides in s0 + 0 (0x10000004 + 0 = 0x10000004)
    sw s1, 4(s0)		# stores the content of s1 (0x12345678) to the memory address that resides in s0 + 4 (0x10000004 + 4 = 0x10000008)
    
    addi s2, zero, 5	# assigns the value 5 to s2 register - note zero is equivalent to x0
    addi s3, s2, 3		# adds the value in s2 register to the value 3 and assign the result in s3 register (s3=8)
    
    # swapping s2 with s3
    addi t0, s2, 0		# assigns the value in s2 register to t0 register
    mv s2, s3			# a pseudo-instruction that translates to addi s2, s3, 0 (assigns the value in s3 register to s2 register)
    mv s3, t0			# assigns the value in t0 register to s3 register
    
    # an infinite loop, almost needed in any embedded systems code
	while_1:
		NOP
		j while_1		# j label is another pseudo-instruction equivalent to beq x0,x0,label

# Note: the beq instruction is Branch if EQual, if x0 equals x0 then it will jump to the address "label"
#  and since x0 is always 0 - beq x0, x0 is the same as a branch always or jump
