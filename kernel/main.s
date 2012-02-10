
VERSION = 46
REVISION= 10

rom_start:
        dc.w	$1111
.start:
        dc.w    $4ef9
        dc.l    $f80000+(rom_init-.start)

        dc.w	$0000
        dc.w	$ffff
        dc.w	VERSION
        dc.w	REVISION
        dc.w	VERSION
        dc.w	REVISION
        dc.w	$ffff
        dc.w	$ffff
	dc.b	"Amiga ROM Operating System and Libraries"
        dc.b	"Copyright @ 2012 Patrick Hanevold"

        align 4
rom_magic_reset:
        reset
        nop

rom_init:
        ; wait for reset to finish
        lea     $f80000,a0
        move.l  #524288/4,d0
        moveq   #0,d1
.0:     add.l   (a0)+,d1
        bcc.s   .1
        addq.l  #1,d1
.1:     subq.l  #1,d0
        bne.s   .0

        ; leds off
        moveq   #0,d0
        move.b  d0,$bfe001
        moveq   #$3,d0
        move.b  d0,$bfe201

        ; party time
boot:
        lea.l   $dff000,a0
        move.w  #$7fff,$9a(a0)
        move.w  #$7fff,$9c(a0)
        move.w  #$7fff,$96(a0)
        moveq   #1,d0
.loop:
        move.w  d0,$180(a0)
        addq.w  #1,d0
        bra.b   .loop
