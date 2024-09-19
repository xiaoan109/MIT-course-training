.globl __exception_handler

.section .exc, "ax"
__exception_handler:
        li $2, 1
        jr $31
