.section .vectors
vector_table:
    .word 0xABC0
    .word reset_handler
    .zero 400

    .section .text
    .align 1
    .type reset_handler, %function
reset_handler:
    mov r1, #0x1
    mov r2, #0x2
    add r3, r1, r2
    bl .
/Users/piyush/Movies/obs/ARM-M - Baremetal Assembly/3. Assembly Programs/3.1 Booting the Processor and First Assembly Program/map.ld