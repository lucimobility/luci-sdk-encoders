MEMORY
{
    /* The last 8K of the 1M flash array is reserved (see `probe-rs chip info MCXA256`). */
    FLASH : ORIGIN = 0x00000000, LENGTH = 1016K
    RAM   : ORIGIN = 0x20000000, LENGTH = 128K
}
