# smipsv3_hilo.S
#
# Test mfhi, mflo, mthi, mtlo instruction.
#       

#include "smipstest.h"
        
TEST_SMIPSRAW

        .text
start:        
        
        // Tests 1 and 2
        // Very simple test with nop's to avoid hazards

        li      $10, 101
        li      $11, 33

        nop
        nop
        nop
        nop
        nop
        mthi    $10
        nop
        nop
        nop
        nop
        nop
        mfhi    $20
        nop
        nop
        nop
        nop
        nop
        mtlo    $11
        nop
        nop
        nop
        nop
        nop
        mflo    $21
        nop
        nop
        nop
        nop
        nop

        li      $2, 1
        bne     $10, $20, fail
        li      $2, 2
        bne     $11, $21, fail

        // Tests 3 and 4
        // Test with hazards

        li      $10, 302
        mthi    $10
        mfhi    $20

        li      $11, 44
        mtlo    $11
        mflo    $21

        nop
        nop
        nop
        nop
        nop

        li      $2, 3
        bne     $10, $20, fail
        li      $2, 4
        bne     $11, $21, fail

        // Tests 5 and 6
        // Test with different hazards

        li      $10, 509
        li      $11, 99

        mthi    $11
        mthi    $10
        mfhi    $20

        mtlo    $10
        mtlo    $11
        mflo    $21

        li      $2, 5
        bne     $10, $20, fail
        li      $2, 6
        bne     $11, $21, fail

        // Tests 7 and 8
        // Test with different hazards

        li      $10, 777
        li      $11, 111

        mthi    $10
        mtlo    $11

        mfhi    $20
        mflo    $21

        li      $2, 7
        bne     $10, $20, fail
        li      $2, 8
        bne     $11, $21, fail

        j       pass
        
fail:          
        mtc0    $2, $21      
1:      beq     $0, $0, 1b    

pass:      
        mtc0    $0, $21       
1:      beq     $0, $0, 1b    

