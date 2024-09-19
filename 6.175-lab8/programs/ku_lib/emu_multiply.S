	.file	1 "emu_multiply.c"
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

gcc2_compiled.:
__gnu_compiled_c:
	.text
	.align	2
	.globl	emu_smultiply
	.type	 emu_smultiply,@function
emu_smultiply:
	.ent	emu_smultiply
emu_smultiply:
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, extra= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
	move	$3,$0
	move	$9,$3
	move	$8,$3
	li	$10,-2147483648			# 0x80000000
	li	$12,31			# 0x0000001f
$L5:
	and	$11,$3,$10
	and	$6,$4,$10
	bne	$8,$12,$L6
	subu	$4,$0,$4
	move	$6,$0
	beq	$4,$10,$L6
	and	$6,$4,$10
$L6:
	andi	$2,$5,0x0001
	beq	$2,$0,$L9
	addu	$7,$3,$4
	xor	$2,$3,$6
	and	$2,$2,$10
	beq	$2,$0,$L10
	and	$11,$7,$10
$L10:
	move	$3,$7
$L9:
	srl	$9,$9,1
	andi	$2,$3,0x0001
	beq	$2,$0,$L11
	or	$9,$9,$10
$L11:
	srl	$3,$3,1
	or	$3,$3,$11
	srl	$5,$5,1
	addu	$8,$8,1
	slt	$2,$8,32
	bne	$2,$0,$L5
	move	$5,$3
	move	$4,$0
	move	$3,$9
	move	$2,$4
	sll	$4,$5,0
	move	$5,$0
	or	$2,$4,$2
	or	$3,$5,$3
	j	$31
	.end	emu_smultiply
$Lfe1:
	.size	 emu_smultiply,$Lfe1-emu_smultiply
	.align	2
	.globl	emu_umultiply
	.type	 emu_umultiply,@function
emu_umultiply:
	.ent	emu_umultiply
emu_umultiply:
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, extra= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
	move	$3,$0
	move	$8,$3
	li	$9,-2147483648			# 0x80000000
	li	$10,31			# 0x0000001f
$L17:
	move	$6,$0
	andi	$2,$5,0x0001
	beq	$2,$0,$L18
	addu	$7,$3,$4
	and	$2,$3,$4
	and	$2,$2,$9
	beq	$2,$0,$L19
	li	$6,-2147483648			# 0x80000000
	j	$L20
$L19:
	xor	$2,$3,$4
	and	$2,$2,$9
	beq	$2,$0,$L20
	and	$2,$7,$9
	xor	$6,$2,$9
$L20:
	move	$3,$7
$L18:
	srl	$8,$8,1
	andi	$2,$3,0x0001
	beq	$2,$0,$L22
	or	$8,$8,$9
$L22:
	srl	$3,$3,1
	or	$3,$3,$6
	srl	$5,$5,1
	addu	$10,$10,-1
	bgez	$10,$L17
	move	$5,$3
	move	$4,$0
	move	$3,$8
	move	$2,$4
	sll	$4,$5,0
	move	$5,$0
	or	$2,$4,$2
	or	$3,$5,$3
	j	$31
	.end	emu_umultiply
$Lfe2:
	.size	 emu_umultiply,$Lfe2-emu_umultiply
	.ident	"GCC: (GNU) egcs-2.90.29 980515 (egcs-1.0.3 release)"
