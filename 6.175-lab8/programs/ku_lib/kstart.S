.globl start

#TEST_SMIPSRAW

#define _ERET .word 0x42000018
#define _SYSCALL .word 0x0000000c

        .text
start:        
        addiu $26, $0, 0xc  # set status
        mtc0 $26, $12
        la $26, ustart      # set epc
        mtc0 $26, $14
        _ERET               # .word 0x42000018
        
        #should not get here
        li $26, 0xDEADC0DE
        mtc0 $26, $21
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop


ustart:
        li $2, 1
        jal main
#        mtc0 $2, $21
        addiu $4, $2, 0
        li $2, 0xA  # fake exit syscall (0xA) 
        _SYSCALL    # .word 0x0000000c

end:    j end
