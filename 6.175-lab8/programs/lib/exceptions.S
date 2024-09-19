.globl __exception_handler
// The current assembler doesn't allow eret, so we have to make it look like data instead
#define MY_ERET .long 0x80000000

#define _ERET .word 0x42000018
#define _SYSCALL .word 0x0000000c
#define _TLBWR .word 0x42000006

#include "emu_multiply.S"

.set noat
.section .exc, "ax"
__exception_handler:
	mfc0 $26, $13
	srl $26, 2
	andi $26, $26, 0x1f	# cause
	li $27, 0x0008		# syscall code
	beq $26, $27, syscallhandler

	li $27, 0x0004		# adel code
	beq $26, $27, adelhandler
	
	li $27, 0x0005		# ades code
	beq $26, $27, adeshandler

	li $27, 0x000a		# ri code
	beq $26, $27, rihandler

	li $27, 0x0010		# tlbl code
	beq $26, $27, tlbhandler
	
	li $27, 0x0012		# tlbw code
	beq $26, $27, tlbhandler

	li $27, 0xDEADC0DE	# unsupported exception, terminate
	mtc0 $27, $21

waittodie:
	j waittodie
	nop
	nop
	nop
	nop

rihandler:
	mfc0 $26, $14		# get EPC 
	lw $26, 0($26)		# fetch EPC instruction
	li $27, 0xfc00ffff	# opcode mask for MULT
	and $26, $26, $27	 
	li $27, 0x00000018	# opcode pattern for MULT
	beq $26, $27, emumult

	li $27, 0x00000019	# opcode pattern for MULTU
	beq $26, $27, emumult

	li $27, 0xDEADC0DE	# unsupported exception, terminate
	mtc0 $27, $21
	j waittodie
	nop
	nop
	nop

emumult:
	la $26, kstack
	# no self-modfiying code, doing this the hard way 
	sw $0, 0x0($26)
	sw $1, 0x4($26)
	sw $2, 0x8($26)
	sw $3, 0xc($26)
	sw $4, 0x10($26)
	sw $5, 0x14($26)
	sw $6, 0x18($26)
	sw $7, 0x1c($26)
	sw $8, 0x20($26)
	sw $9, 0x24($26)
	sw $10, 0x28($26)
	sw $11, 0x2c($26)
	sw $12, 0x30($26)
	sw $13, 0x34($26)
	sw $14, 0x38($26)
	sw $15, 0x3c($26)
	sw $16, 0x40($26)
	sw $17, 0x44($26)
	sw $18, 0x48($26)
	sw $19, 0x4c($26)
	sw $20, 0x50($26)
	sw $21, 0x54($26)
	sw $22, 0x58($26)
	sw $23, 0x5c($26)
	sw $24, 0x60($26)
	sw $25, 0x64($26)
	sw $0, 0x68($26)
	sw $0, 0x6c($26)
	sw $28, 0x70($26)
	sw $29, 0x74($26)
	sw $30, 0x78($26)
	sw $31, 0x7c($26)
	
	mfc0 $26, $14		# get EPC 
	lw $26, 0($26)		# fetch EPC instruction
	
	srl $4, $26, 14
	li $27, 0x7c
	and $4, $4, $27		# $4="rt"*4
	la $27, kstack
	addu $4, $4, $27
	lw $4, 0($4)		

	srl $5, $26, 19
	li $27, 0x7c
	and $5, $5, $27		# $4="rs"*4
	la $27, kstack
	addu $5, $5, $27
	lw $5, 0($5)

	li $27, 0xfc00ffff	# opcode mask for MULT
	and $26, $26, $27
	li $27, 0x00000018	# opcode pattern for MULT
	beq $26, $27, dosigned

	jal emu_umultiply	
	j donemult
	
dosigned:
	jal emu_smultiply	
	
donemult:	
	mthi $2		
	mtlo $3

	la $26, kstack
#	lw $0, 0x0($26)
	lw $1, 0x4($26)		# assembler temporary
	lw $2, 0x8($26)		# return value
	lw $3, 0xc($26)
	lw $4, 0x10($26)	# arguments
	lw $5, 0x14($26)
	lw $6, 0x18($26)
	lw $7, 0x1c($26)
	lw $8, 0x20($26)	# temporaries
	lw $9, 0x24($26)
	lw $10, 0x28($26)
	lw $11, 0x2c($26)
	lw $12, 0x30($26)
	lw $13, 0x34($26)
	lw $14, 0x38($26)
	lw $15, 0x3c($26)
#	lw $16, 0x40($26)	# saved temporaries
#	lw $17, 0x44($26)
#	lw $18, 0x48($26)
#	lw $19, 0x4c($26)
#	lw $20, 0x50($26)
#	lw $21, 0x54($26)
#	lw $22, 0x58($26)
#	lw $23, 0x5c($26)
	lw $24, 0x60($26)	# temporaries
	lw $25, 0x64($26)
#	lw $0, 0x68($26)
#	lw $0, 0x6c($26)
#	lw $28, 0x70($26)	# global pointer
#	lw $29, 0x74($26)	# stack pointer
#	lw $30, 0x78($26)	# frame pointer
	lw $31, 0x7c($26)	# return address

	mfc0 $26, $14		# get EPC
	addiu $26, $26, 4	# increment by 4
	mtc0 $26, $14		# return to EPC+4 (skip emulated mult)
	_ERET 			# .word 0x42000018
	nop
	nop
	nop
	nop
	

tlbhandler:
	mfc0 $26, $8		# get badvaddr
	srl  $26, $26, 8
	mtlo $26
	nop
	_TLBWR
	nop
	_ERET 			# .word 0x42000018
	nop
	nop
	nop
	nop

adelhandler:
	la $26, kstack
	sw $30, 0($26)
	sw $31, 4($26)
	
	mfc0 $26, $14
	lw $26, 0($26)
	srl $26, $26, 16
	li $27, 0x1f
	and $26, $26, $27

	mfc0 $27, $8
	li $30, 0x7fffffff
	and $27, $27, $30

	li $30, 2
	beq $26, $30, LW02
	li $30, 3
	beq $26, $30, LW03
	li $30, 4
	beq $26, $30, LW04
	li $30, 5
	beq $26, $30, LW05
	li $30, 6
	beq $26, $30, LW06
	li $30, 7
	beq $26, $30, LW07
	li $30, 8
	beq $26, $30, LW08
	li $30, 9
	beq $26, $30, LW09

retfromadel:
	la $31, kstack
	lw $30, 0($31)
	lw $31, 4($31)
	mfc0 $26, $14
	addiu $26, $26, 4
	mtc0 $26, $14
	_ERET 			# .word 0x42000018
	nop
	nop
	nop
	nop

LW02:	lw $2, 0($27)
	j retfromadel
LW03:	lw $3, 0($27)
	j retfromadel
LW04:	lw $4, 0($27)
	j retfromadel
LW05:	lw $5, 0($27)
	j retfromadel
LW06:	lw $6, 0($27)
	j retfromadel
LW07:	lw $7, 0($27)
	j retfromadel
LW08:	lw $8, 0($27)
	j retfromadel
LW09:	lw $9, 0($27)
	j retfromadel


adeshandler:
	la $26, kstack
	sw $30, 0($26)
	sw $31, 4($26)
	
	mfc0 $26, $14
	lw $26, 0($26)
	srl $26, $26, 16
	li $27, 0x1f
	and $26, $26, $27

	mfc0 $27, $8
	li $30, 0x7fffffff
	and $27, $27, $30

	li $30, 2
	beq $26, $30, SW02
	li $30, 3
	beq $26, $30, SW03
	li $30, 4
	beq $26, $30, SW04
	li $30, 5
	beq $26, $30, SW05
	li $30, 6
	beq $26, $30, SW06
	li $30, 7
	beq $26, $30, SW07
	li $30, 8
	beq $26, $30, SW08
	li $30, 9
	beq $26, $30, SW09

retfromades:
	la $31, kstack
	lw $30, 0($31)
	lw $31, 4($31)
	mfc0 $26, $14
	addiu $26, $26, 4
	mtc0 $26, $14
	_ERET 			# .word 0x42000018
	nop
	nop
	nop
	nop

SW02:	sw $2, 0($27)
	j retfromades
SW03:	sw $3, 0($27)
	j retfromades
SW04:	sw $4, 0($27)
	j retfromades
SW05:	sw $5, 0($27)
	j retfromades
SW06:	sw $6, 0($27)
	j retfromades
SW07:	sw $7, 0($27)
	j retfromades
SW08:	sw $8, 0($27)
	j retfromades
SW09:	sw $9, 0($27)
	j retfromades
	
	
syscallhandler:	
	li $26, 0xA
	beq $2, $26, testdone

	li $26, 0xB
	beq $2, $26, mtc018

	li $26, 0xC
	beq $2, $26, mtc019

	li $26, 0xD
	beq $2, $26, mfc010

	li $26, 0xE
	beq $2, $26, mfc011

	li $26, 0x20
	beq $2, $26, storing

	li $26, 0x21
	beq $2, $26, recalling

retfrmsyscall:
	mfc0 $26, $14
	addiu $26, $26, 4
	mtc0 $26, $14
	_ERET 			# .word 0x42000018
	
storing:
	la $26, where
	sw $4, 0($26)
	j retfrmsyscall

recalling:	
	la $26, where
	lw $2, 0($26)
	j retfrmsyscall

mtc018:
	mtc0 $4, $18
	j retfrmsyscall
	
mtc019:
	mtc0 $4, $19
	j retfrmsyscall
	
mfc010:
	mfc0 $2, $10
	j retfrmsyscall

mfc011:
	mfc0 $2, $11
	j retfrmsyscall
	
testdone:
	mtc0 $4, $21		# end simulation with $a0
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
spinhere:
	j spinhere


#	li $2, 1
#        MY_ERET


where:	.word 0
kstack:	
	.word 0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0,0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0,0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0,0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0,0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0,0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0,0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0,0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0,0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0,0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0,0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0,0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0,0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0,0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0,0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0,0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0,0, 0, 0, 0

	.word 0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0,0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0,0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0,0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0,0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0,0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0,0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0,0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0,0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0,0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0,0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0,0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0,0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0,0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0,0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0,0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0,0, 0, 0, 0

