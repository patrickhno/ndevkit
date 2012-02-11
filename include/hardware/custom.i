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

BLTDDAT     equ   $000
DMACONR     equ   $002
VPOSR	    equ   $004
VHPOSR	    equ   $006
DSKDATR     equ   $008
JOY0DAT     equ   $00a
JOY1DAT     equ   $00c
CLXDAT	    equ   $00e
ADKCONR     equ   $010
POT0DAT     equ   $012
POT1DAT     equ   $014
POTINP	    equ   $016
SERDATR     equ   $018
DSKBYTR     equ   $01a
INTENAR     equ   $01c
INTREQR     equ   $01e
DSKPT	    equ   $020
DSKLEN	    equ   $024
DSKDAT	    equ   $026
REFPTR	    equ   $028
VPOSW	    equ   $02a
VHPOSW	    equ   $02c
COPCON	    equ   $02e
SERDAT	    equ   $030
SERPER	    equ   $032
POTGO	    equ   $034
JOYTEST     equ   $036
STREQU	    equ   $038
STRVBL	    equ   $03a
STRHOR	    equ   $03c
STRLONG     equ   $03e
BLTCON0     equ   $040
BLTCON1     equ   $042
BLTAFWM     equ   $044
BLTALWM     equ   $046
BLTCPT	    equ   $048
BLTBPT	    equ   $04c
BLTAPT	    equ   $050
BLTDPT	    equ   $054
BLTSIZE     equ   $058
BLTCON0L    equ   $05b
BLTSIZV     equ   $05c
BLTSIZH     equ   $05e
BLTCMOD     equ   $060
BLTBMOD     equ   $062
BLTAMOD     equ   $064
BLTDMOD     equ   $066
BLTCDAT     equ   $070
BLTBDAT     equ   $072
BLTADAT     equ   $074
DENISEID    equ   $07c
DSKSYNC     equ   $07e
COP1LC	    equ   $080
COP2LC	    equ   $084
COPJMP1     equ   $088
COPJMP2     equ   $08a
COPINS	    equ   $08c
DIWSTRT     equ   $08e
DIWSTOP     equ   $090
DDFSTRT     equ   $092
DDFSTOP     equ   $094
DMACON	    equ   $096
CLXCON	    equ   $098
INTENA	    equ   $09a
INTREQ	    equ   $09c
ADKCON	    equ   $09e

AUD	    	equ   $0a0
AUD0	    equ   $0a0
AUD1	    equ   $0b0
AUD2	    equ   $0c0
AUD3	    equ   $0d0

AC_PTR	    equ   $00
AC_LEN	    equ   $04
AC_PER	    equ   $06
AC_VOL	    equ   $08
AC_DAT	    equ   $0a
AC_SIZEOF   equ   $10

BPLPT	    equ   $0e0

BPLCON0     equ   $100
BPLCON1     equ   $102
BPLCON2     equ   $104
BPLCON3     equ   $106
BPL1MOD     equ   $108
BPL2MOD     equ   $10a
BPLCON4     equ   $10c
CLXCON2     equ   $10e

BPLDAT	    equ   $110

SPRPT	    equ   $120

SPR	    	equ   $140

SD_POS	    equ   $00
SD_CTL	    equ   $02
SD_DATA    	equ   $04
SD_DATAB    equ   $06
SD_SIZEOF   equ   $08

COLOR	    equ   $180

HTOTAL	    equ   $1c0
HSSTOP	    equ   $1c2
HBSTRT	    equ   $1c4
HBSTOP	    equ   $1c6
VTOTAL	    equ   $1c8
VSSTOP	    equ   $1ca
VBSTRT	    equ   $1cc
VBSTOP	    equ   $1ce
SPRHSTRT    equ   $1d0
SPRHSTOP    equ   $1d2
BPLHSTRT    equ   $1d4
BPLHSTOP    equ   $1d6
HHPOSW	    equ   $1d8
HHPOSR	    equ   $1da
BEAMCON0    equ   $1dc
HSSTRT	    equ   $1de
VSSTRT	    equ   $1e0
HCENTER     equ   $1e2
DIWHIGH     equ   $1e4
FMODE	    equ   $1fc
