	.file	1 "print.c"
	.version	"01.01"
 # GNU C version egcs-2.90.29 980515 (egcs-1.0.3 release) (smips) compiled by GNU C version 3.2.1.
 # options passed:  -G -O2
 # options enabled:  -fdefer-pop -fomit-frame-pointer -fcse-follow-jumps
 # -fcse-skip-blocks -fexpensive-optimizations -fthread-jumps
 # -fstrength-reduce -fpeephole -fforce-mem -ffunction-cse -finline
 # -fkeep-static-consts -fcaller-saves -fpcc-struct-return
 # -frerun-cse-after-loop -frerun-loop-opt -fschedule-insns
 # -fschedule-insns2 -fcommon -fverbose-asm -fgnu-linker -fregmove
 # -falias-check -fargument-alias -mgas -meb -mcpu=R4000

#define _SYSCALL .word 0x0000000c

gcc2_compiled.:
__gnu_compiled_c:
	.text
	.align	2
	.globl	printInt
	.type	 printInt,@function
printInt:
	.ent	printInt
printInt:
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, extra= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
 #APP
#	mtc0 $4, $18
	li   $2, 0xB		# fake mtc0 18 syscall
	_SYSCALL		# .word 0x0000000c
 #NO_APP
	j	$31
	.end	printInt
$Lfe1:
	.size	 printInt,$Lfe1-printInt
	.align	2
	.globl	printChar
	.type	 printChar,@function
printChar:
	.ent	printChar
printChar:
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, extra= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
 #APP
#	mtc0 $4, $19
	li   $2, 0xC		# fake mtc0 19 syscall
	_SYSCALL		# .word 0x0000000c
 #NO_APP
	j	$31
	.end	printChar
$Lfe2:
	.size	 printChar,$Lfe2-printChar
	.align	2
	.globl	printStr
	.type	 printStr,@function
printStr:
	.ent	printStr
printStr:
	.frame	$sp,32,$31		# vars= 0, regs= 4/0, args= 16, extra= 0
	.mask	0x80070000,-4
	.fmask	0x00000000,0
	subu	$sp,$sp,32
	sw	$16,16($sp)
	move	$16,$4
	sw	$18,24($sp)
	li	$18,24			# 0x00000018
	sw	$17,20($sp)
	li	$17,255			# 0x000000ff
	sw	$31,28($sp)
$L6:
	lw	$2,0($16)
	andi	$3,$16,0x0003
	sll	$3,$3,3
	subu	$3,$18,$3
	sll	$4,$17,$3
	and	$2,$2,$4
	srl	$4,$2,$3
	beq	$4,$0,$L5
	jal	printChar
	addu	$16,$16,1
	j	$L6
$L5:
	lw	$31,28($sp)
	lw	$18,24($sp)
	lw	$17,20($sp)
	lw	$16,16($sp)
	#nop
	addu	$sp,$sp,32
	j	$31
	.end	printStr
$Lfe3:
	.size	 printStr,$Lfe3-printStr
	.ident	"GCC: (GNU) egcs-2.90.29 980515 (egcs-1.0.3 release)"
