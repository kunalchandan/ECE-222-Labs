.section .init

_reset:
  j _start
  j isr
 
.globl _start
_start:
  la gp, _gp
  la sp, _end_of_memory

  la t0, isr
  csrw mtvec, t0

  jal main

1:
  j 1b
  
.weak isr
isr:
	nop 
	mret