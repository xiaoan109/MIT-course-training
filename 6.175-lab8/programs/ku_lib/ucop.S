	.file	1 "cop.c"
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
	.globl	getTime
	.type	 getTime,@function
getTime:
	.ent	getTime
getTime:
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, extra= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
 #APP
#	mfc0 $2, $10
	li   $2, 0xD
	_SYSCALL		# .word 0x0000000c
 #NO_APP
	j	$31
	.end	getTime
$Lfe1:
	.size	 getTime,$Lfe1-getTime
	.align	2
	.globl	getInsts
	.type	 getInsts,@function
getInsts:
	.ent	getInsts
getInsts:
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, extra= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
 #APP
#	mfc0 $2, $11
	li   $2, 0xE
	_SYSCALL		# .word 0x0000000c
 #NO_APP
	j	$31
	.end	getInsts
$Lfe2:
	.size	 getInsts,$Lfe2-getInsts
	.ident	"GCC: (GNU) egcs-2.90.29 980515 (egcs-1.0.3 release)"
