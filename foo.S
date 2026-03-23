.global main_1
.global main_2

.thumb
.syntax unified

.word sdata
.word edata
.word sidata

.section .buffer
.zero 100

.section .stack
stack_1:
.word 0x10
.word 0x11
.word 0x12
.word 0x13
.word 0x1c
.word 0x309
.word main_1
.word 0x01000000
.word 0x14
.word 0x15
.word 0x16
.word 0x17
.word 0x18
.word 0x19
.word 0x1A
.word 0x1B

.zero 100

stack_2:
.word 0x20
.word 0x21
.word 0x22
.word 0x23
.word 0x1c
.word 0x309
.word main_2
.word 0x01000000
.word 0x24
.word 0x25
.word 0x26
.word 0x27
.word 0x28
.word 0x29
.word 0x2A
.word 0x2B

.zero 100

stack_locs:
.zero 10

reset_init:
.zero 1






.section .vectors
vector_table:
    .word 0x20001000
    .word reset_handler
    .org 0x0c
    .word hardfault_handler
    .org 0x3c
    .word systick_handler
    .zero 400


    .section .text
    .align 2
    .type hardfault_handler, %function
hardfault_handler:
    bl .


    .section .text
    .align 2
    .type reset_handler, %function

reset_handler:

    ldr r1, =sdata //ram start address
    ldr r2, =edata //ram start address
    ldr r0, =sidata //flash start address
    copy_data_loop:
    cmp r1,r2
    bge copy_loop_end

    ldr r3,[r0] //reads value from location r0, and copies it into r3. if no brackets are used flash address will get copied into r3, instead of ram address
    str r3,[r1] //reads value from r3, and copies it into location pointed by r1
    add r1,#4
    add r0,#4
    b copy_data_loop
    copy_loop_end:


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

    //[address]
    //no brackets means value
    ldr r0,=stack_1
    ldr r1,=stack_locs
    str r0,[r1] //stores address of stack_1 at location pointed by r1
    ldr r0,=stack_2
    str r0,[r1,#4]

    ldr r0, =stack_1
    msr psp,r0 //psp is loaded with stack address of task1, and rtos will start from systick handler

    ldr r4,=reset_init
    mov r5,#0x01
    str r5,[r4]

    bl .

.section .text
    .align 2
    .type systick_handler, %function
systick_handler:

    ldr r4,=reset_init
    ldr r5,[r4]
    cmp r5,#0x01
    beq reset_regs
    b systick_restore

    reset_regs:
    ldr r4,=reset_init
    mov r5,#0x00
    str r5,[r4]

    mov r4,#0 //clearing all stack frame registers, so that msp remains clean for further usage by systick
    mov r5,#0
    mov r6,#0
    mov r7,#0
    mov r8,#0
    mov r9,#0
    mov r10,#0
    mov r11,#0
    b reset_done

    systick_restore:
    pop {r4-r11}
    reset_done:
    //PUSH one register - SP decremented first, then value stored
    //POP one register - Value loaded first, then SP incremented
    //task -> systick - value is pushed in stack
    //systick -> task - value is popped from stack

    cmp lr,#0xfffffffd //compare link register with EXC_RETURN from thread mode. if equal start the rtos, else load the lr with thread mode and return.
    beq rtos_start
    b rtos_end

    rtos_start:
    add r4,r4,#1
    cmp r4,#100 //100 count task
    bge timer_task
    b timer_end


    timer_task:
    mov r4,#0 //reset the timer counter

    mrs r5,psp
    ldr r6,=stack_locs
    str r5,[r6,r7] //once rtos is started, read the current psp value and store it in the stack_locs using the previous state variable


    add r8,r8,#0x04 //r8 is the state variable, used to rotate between tasks

    cmp r8,#0x04  //rotate the r8 state variable
    ble skip
    mov r8,#0
    skip:

    ldr r5,=stack_locs
    ldr r6, [r5,r8]
    msr psp,r6

    mov r7,r8       //r7 stores the previous value of state variable




    rtos_end:
    ldr lr, =0xfffffffd //start the rtos
    timer_end:

    push {r4-r11}
    bx lr

.section .text
    .align 2
.type main_1, %function
main_1:
    //pop {r4-r11}
    b main_1_body

.section .text
    .align 2
.type main_1_body, %function
main_1_body:
    mrs r5,msp
    add r0,r0,#1
    b main_1_body

.section .text
    .align 2
.type main_2, %function
main_2:
    b main_2_body

.section .text
    .align 2
.type main_2_body, %function
main_2_body:
    add r1,r1,#1
    b main_2_body