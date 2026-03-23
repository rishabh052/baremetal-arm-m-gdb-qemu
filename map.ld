MEMORY
{
    FLASH : ORIGIN = 0x08000000, LENGTH = 0x1FFF
    RAM : ORIGIN = 0x20000000, LENGTH = 0x4000

}

SECTIONS
{
    .text : {
        *(.vectors*)
        *(.text*)
    } > FLASH

    .data : {
        *(.data*)
        *(.buffer)
        *(.stack)
    } > RAM AT> FLASH
}

sidata = LOADADDR(.data);  /* FLASH address */
sdata  = ADDR(.data);   /* RAM start */
edata  = ADDR(.data) + SIZEOF(.data);
