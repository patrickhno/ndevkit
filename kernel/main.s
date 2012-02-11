; Copyright (c) 2012 Patrick Hanevold.
;
; Permission is hereby granted, free of charge, to any person obtaining
; a copy of this software and associated documentation files (the
; "Software"), to deal in the Software without restriction, including
; without limitation the rights to use, copy, modify, merge, publish,
; distribute, sublicense, and/or sell copies of the Software, and to
; permit persons to whom the Software is furnished to do so, subject to
; the following conditions:
;
; The above copyright notice and this permission notice shall be
; included in all copies or substantial portions of the Software.
;
; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
; EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
; MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
; NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
; LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
; OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
; WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

VERSION = 46
REVISION= 10

        INCLUDE ../include/hardware/custom.i

        GLOBAL  rom_start

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
	dc.b	"NatAmi ROM Operating System and Libraries\n"
        dc.b	"Copyright (c) 2012 Patrick Hanevold\n"

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
        move.w  #$7fff,(INTENA,a0)
        move.w  #$7fff,(INTREQ,a0)
        move.w  #$7fff,(DMACON,a0)

        ; set up stack
        lea.l   $50000,sp

        jsr     bootstrap_exec_lib(pc)

        ; call the OldOpenLibrary stub, should give a really green screen
        jsr     -408(a6)

        ; -- never reached --

        lea.l   $dff000,a0
        moveq   #1,d0
.loop:
        move.w  d0,(COLOR+0,a0)
        addq.w  #1,d0
        and.w   #$f,d0
        bra.b   .loop
