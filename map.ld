MEMORY
{
    FLASH : ORIGIN = 0x08000000, LENGTH = 0x1FFF
    RAM : ORIGIN = 0x20000000, LENGTH = 0x1000

}

SECTIONS
{
    .text : {
        *(.vectors*)
        *(.text*)
    } > FLASH

    .data : {
        *(.data*)
        *(.stack)
    } > FLASH AT RAM
}
