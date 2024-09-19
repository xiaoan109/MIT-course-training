.globl start
start:
        li $2, 1
        jal main
        mtc0 $2, $21
end:    j end
