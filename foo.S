.section .vectors
vector_table:
    .word 0x20001000
    .word reset_handler
    .org 0x3c
    .word systick_handler
    .zero 400

    .section .text
    .align 2
    .type reset_handler, %function
reset_handler:
    .equ syst_csr, 0xE000E010
    .equ syst_rvr, 0xE000E014
    .equ syst_cvr, 0xE000E018
    .equ timer_value, 0x000fffff

    ldr r1, =syst_csr
    ldr r2, =syst_rvr
    ldr r3, =syst_cvr
    ldr r4, =timer_value

    str r4,[r2]
    mov r4,#0
    str r4,[r3]
    mov r4,#7
    str r4,[r1]
    bl .

     .section .text
    .align 2
    .type systick_handler, %function
systick_handler:
    add r5,r5,#1
