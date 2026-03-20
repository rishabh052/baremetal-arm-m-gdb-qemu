.section .vectors
vector_table:
    .word 0x20000100
    .word reset_handler
    .org 0x3c
    .word systick_handler
    .zero 400

.section .stack
stack_1:
.word 0x10
.word 0x11
.word 0x12
.word 0x13
.word 0x14
.word 0x15
.word 0x16
.word 0x17
.word 0x18
.word 0x19
.word 0x1A
.word 0x1B
.word 0x1c
.word 0x309
main_1
.word 0x01000000

stack_2:
.word 0x20
.word 0x21
.word 0x22
.word 0x23
.word 0x24
.word 0x25
.word 0x26
.word 0x27
.word 0x28
.word 0x29
.word 0x2A
.word 0x2B
.word 0x1c
.word 0x309
main_2
.word 0x01000000


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
    //add r5,r5,#1
    push {r4-r7}
    mov r0,r8
    mov r1,r9
    mov r2,r10
    mov r3,r11
    push {r0-r3}

    b main_1
    mov sp, @stack_1

    pop {r0-r3}
    mov r8,r0
    mov r9,r1
    mov r10,r2
    mov r11,r3
    pop {r4-r7}


    bx lr

.section .text
    .align 2
    .type main_1, %function
main_1:
    add r0,r0,#1
    bl .

.section .text
    .align 2
    .type main_2, %function
main_2:
    add r1,r1,#1
    bl .
