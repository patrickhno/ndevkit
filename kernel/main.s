
.text
	.globl	_start
	.align	4

rom_start:
	.word	0x1111

_start:
	movw	#0x7fff,0xdff09a
	movw	#0x7fff,0xdff09c

	movl	#1,%d2
.loop:	movl	#16807, %d0
	mulsl	(%d2), %d1:%d0
	lsll	#1, %d0
	roxll	#2, %d1
	addl	%d1, %d0
	moveql	#1, %d1
	addxl	%d1, %d0
	lsrl	#1, %d0
	movl	%d0,%d2

	movw	%d0,0xdff0180
	braw	.loop

