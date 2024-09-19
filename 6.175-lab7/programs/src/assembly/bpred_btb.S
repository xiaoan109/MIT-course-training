#*****************************************************************************
# bpred_bht.S
#-----------------------------------------------------------------------------
# branch prediction micro benchmark
# A btb will improve the prediction of the jumps and branches in this program

#include "smipstest.h"
#include "test_macros.h"
                
TEST_SMIPSRAW

        .text
start:

        // Cycle count register
        mfc0 $28, $10

        // Return register
        li $30, 0

        // Start test
        // i = 100
        li $8, 100
        // count = 0
        li $11, 0

loopstart:
        j hop1
        addiu $11, $11, 1 // count ++
hop10:  j hop11
        addiu $11, $11, 1 // count ++
hop1:   j hop2
        addiu $11, $11, 1 // count ++
hop11:  j hop12
        addiu $11, $11, 1 // count ++
hop2:   j hop3
        addiu $11, $11, 1 // count ++
hop12:  j hop13
        addiu $11, $11, 1 // count ++
hop3:   j hop4
        addiu $11, $11, 1 // count ++
hop13:  j hop14
        addiu $11, $11, 1 // count ++
hop4:   j hop5
        addiu $11, $11, 1 // count ++
hop14:  j hop15
        addiu $11, $11, 1 // count ++
hop5:   j hop6
        addiu $11, $11, 1 // count ++
hop15:  j hop16
        addiu $11, $11, 1 // count ++
hop6:   j hop7
        addiu $11, $11, 1 // count ++
hop16:  j hop17
        addiu $11, $11, 1 // count ++
hop7:   j hop8
        addiu $11, $11, 1 // count ++
hop17:  j hop18
        addiu $11, $11, 1 // count ++
hop8:   j hop9
        addiu $11, $11, 1 // count ++
hop18:  j hop19
        addiu $11, $11, 1 // count ++
hop9:   j hop10
        addiu $11, $11, 1 // count ++
hop19:  j hop20
        addiu $11, $11, 1 // count ++

        // i = i - 1
hop20:  addiu $8, $8, -1

        // if (i != 0) goto loopstart
        bne $8, $0, loopstart


        // set $30 to count if count != 0
        beq $11, $0, success
        addiu $30, $11, 0

success:

        // Get cycle count
        mfc0 $29, $10

        // Do cycle subtraction
        // $29 = $29 - $28
        subu $29, $29, $28

        // Write cycle count as integer
        mtc0 $29, $18

        // Write new line (0x0A) as character
        li $29, 10
        mtc0 $29, $19

        // Finish with code from register $30
        mtc0 $30, $21

        // Loop forever
end:    beq $0, $0, end
