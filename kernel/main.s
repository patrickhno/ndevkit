
VERSION = 46
REVISION= 10

.text
        .globl  _start
        .align  4

rom_start:
        .word   0x1111
.start:
        .word   0x4ef9
        .long   0xf80000+(rom_init-.start)

        .word 0x0000
        .word 0xffff
        .word VERSION
        .word REVISION
        .word VERSION
        .word REVISION
        .word 0xffff
        .word 0xffff
        .asciz "Amiga ROM Operating System and Libraries"
        .asciz "Copyright @ 2012 Patrick Hanevold"

        .align 4
        .org   0xd0
        .global rom_magic_reset
rom_magic_reset:
        reset
        nop

rom_init:
        /* wait for reset to finish */
        lea     0x00f80000,%a0
        move.l  #524288/4,%d0
        moveq   #0,%d1
.0:     add.l   (%a0)+,%d1
        bcc.s   .1
        addq.l  #1,%d1
.1:     subq.l  #1,%d0
        bne.s   .0

        /* leds off */
        moveq   #0,%d0
        move.b  %d0,0xbfe001
        moveq   #0x3,%d0
        move.b  %d0,0xbfe201

        /* party time */
boot:
        lea.l   0xdff000,%a0
        move.w  #0x7fff,0x9a(%a0)
        move.w  #0x7fff,0x9c(%a0)
        move.w  #0x7fff,0x96(%a0)
        moveq   #1,%d0
.loop:
        move.w  %d0,0x180(%a0)
        addq.w  #1,%d0
        bra.b   .loop
