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

uint8   MACRO
\1      SET     OFFSET
OFFSET  SET     OFFSET+1
        ENDM

int8    MACRO
\1      SET     OFFSET
OFFSET  SET     OFFSET+1
        ENDM

uint16  MACRO
\1      SET     OFFSET
OFFSET  SET     OFFSET+2
        ENDM

int16   MACRO
\1      SET     OFFSET
OFFSET  SET     OFFSET+2
        ENDM

int32   MACRO
\1      SET     OFFSET
OFFSET  SET     OFFSET+4
        ENDM

uint32  MACRO
\1      SET     OFFSET
OFFSET  SET     OFFSET+4
        ENDM

ptr     MACRO
\1      SET     OFFSET
OFFSET  SET     OFFSET+4
        ENDM

struct  MACRO
\1      SET     OFFSET
OFFSET  SET     OFFSET+\2
        ENDM

label   MACRO
\1      SET     OFFSET
        ENDM

OFFSET = 0

; Node types

NT_UNKNOWN      = 0
NT_TASK         = 1
NT_INTERRUPT    = 2
NT_DEVICE       = 3
NT_MSGPORT      = 4
NT_MESSAGE      = 5
NT_FREEMSG      = 6
NT_REPLYMSG     = 7
NT_RESOURCE     = 8
NT_LIBRARY      = 9
NT_MEMORY       = 10
NT_SOFTINT      = 11
NT_FONT         = 12
NT_PROCESS      = 13
NT_SEMAPHORE    = 14
NT_SIGNALSEM    = 15
NT_BOOTNODE     = 16
NT_KICKMEM      = 17
NT_GRAPHICS     = 18
NT_DEATHMESSAGE = 19
NT_USER         = 254
NT_EXTENDED     = 255

; Struct SoftwareInterruptHeader
        uint16  SH_PAD
        label   SH_SIZE

OFFSET set 0

; Struct InterruptVector
        ptr     IV_DATA
        ptr     IV_CODE
        ptr     IV_NODE
        label   IV_SIZE

OFFSET set 0

; Struct ListHeader
        ptr     LH_HEAD         ; $00
        ptr     LH_TAIL         ; $04
        ptr     LH_TAILPRED     ; $08
        uint8   LH_TYPE         ; $0c
        uint8   LH_pad
        label   LH_SIZE         ; $0e

OFFSET set 0

; Struct ListNode
        ptr     LN_SUCC         ; $00
        ptr     LN_PRED         ; $04
        uint8   LN_TYPE         ; $08
        int8    LN_PRI          ; $09
        ptr     LN_NAME         ; $0a
        label   LN_SIZE         ; $0e

; Struct Library,LN_SIZE
        uint8   LIB_FLAGS       ; $0e
        uint8   LIB_pad         ; $0f
        uint16  LIB_NEGSIZE     ; $10
        uint16  LIB_POSSIZE     ; $12
        uint16  LIB_VERSION     ; $14
        uint16  LIB_REVISION    ; $16
        ptr     LIB_IDSTRING    ; $18
        uint32  LIB_SUM         ; $1a
        uint16  LIB_OPENCNT     ; $20
        label   LIB_SIZE        ; $22

; Struct ExecBase
        uint16  SoftVer         ; $22
        int16   LowMemChkSum    ; $24
        uint32  ChkBase         ; $26  complete
        ptr     ColdCapture     ; $2a
        ptr     CoolCapture     ; $2e
        ptr     WarmCapture     ; $32
        ptr     SysStkUpper     ; $36
        ptr     SysStkLower     ; $3a
        uint32  MaxLocMem       ; $3e
        ptr     DebugEntry      ; $42
        ptr     DebugData       ; $46
        ptr     AlertData       ; $4a
        ptr     MaxExtMem       ; $4e
        int16   ChkSum          ; $52

        label   IntVects        ; $54
        struct  IVTBE,IV_SIZE   ; $54
        struct  IVDSKBLK,IV_SIZE; $60
        struct  IVSOFTINT,IV_SIZE;$6c
        struct  IVPORTS,IV_SIZE ; $78
        struct  IVCOPER,IV_SIZE ; $84
        struct  IVVERTB,IV_SIZE ; $90
        struct  IVBLIT,IV_SIZE  ; $9c
        struct  IVAUD0,IV_SIZE  ; $a8
        struct  IVAUD1,IV_SIZE  ; $b4
        struct  IVAUD2,IV_SIZE  ; $c0
        struct  IVAUD3,IV_SIZE  ; $cc
        struct  IVRBF,IV_SIZE   ; $d8
        struct  IVDSKSYNC,IV_SIZE;$e4
        struct  IVEXTER,IV_SIZE ; $f0
        struct  IVINTEN,IV_SIZE ; $fc
        struct  IVNMI,IV_SIZE   ; $108

        ptr     ThisTask        ; $114  complete
        uint32  IdleCount       ; $118
        uint32  DispCount       ; $11c
        uint16  Quantum         ; $120
        uint16  Elapsed         ; $122
        uint16  SysFlags        ; $124
        uint8   IDNestCnt       ; $126
        uint8   TDNestCnt       ; $127
        uint16  AttnFlags       ; $128
        uint16  AttnResched     ; $12a
        ptr     ResModules      ; $12c
        ptr     TaskTrapCode    ; $130
        ptr     TaskExceptCode  ; $134
        ptr     TaskExitCode    ; $138
        uint32  TaskSigAlloc    ; $13c
        uint16  TaskTrapAlloc   ; $140

        struct  MemList,LH_SIZE        ; $142   initialized
        struct  ResourceList,LH_SIZE   ; $150   initialized
        struct  DeviceList,LH_SIZE     ; $15e   initialized
        struct  IntrList,LH_SIZE       ; $16c   initialized
        struct  LibList,LH_SIZE        ; $17a   initialized
        struct  PortList,LH_SIZE       ; $188   initialized
        struct  TaskReady,LH_SIZE      ; $196   initialized
        struct  TaskWait,LH_SIZE       ; $1a4   initialized
        struct  SoftInts,SH_SIZE*5     ; $1b2   initialized

OFFSET set $214

        struct  SemaphoreList,LH_SIZE  ; $214

OFFSET set LN_SIZE

; Struct TaskControl
        uint8   TC_FLAGS
        uint8   TC_STATE
        int8    TC_IDNESTCNT
        int8    TC_TDNESTCNT
        uint32  TC_SIGALLOC
        uint32  TC_SIGWAIT
        uint32  TC_SIGRECVD
        uint32  TC_SIGEXCEPT
        ptr     TC_ETask
        ptr     TC_EXCEPTDATA
        ptr     TC_EXCEPTCODE
        ptr     TC_TRAPDATA
        ptr     TC_TRAPCODE
        ptr     TC_SPREG
        ptr     TC_SPLOWER
        ptr     TC_SPUPPER
        ptr     TC_SWITCH
        ptr     TC_LAUNCH
        struct  TC_MEMENTRY,LH_SIZE
        ptr     TC_Userdata
        label   TC_SIZE

; Task States:

TS_INVALID  = 0
TS_ADDED    = 1
TS_RUN      = 2
TS_READY    = 3
TS_WAIT     = 4
TS_EXCEPT   = 5
TS_REMOVED  = 6

; Memory
MEMF_ANY        = 0
MEMF_PUBLIC     = (1<<0)
MEMF_CHIP       = (1<<1)
MEMF_FAST       = (1<<2)
MEMF_LOCAL      = (1<<8)
MEMF_24BITDMA   = (1<<9)
MEMF_KICK       = (1<<10)
MEMF_CLEAR      = (1<<16)
MEMF_LARGEST    = (1<<17)
MEMF_REVERSE    = (1<<18)
MEMF_TOTAL      = (1<<19)
MEMF_NO_EXPUNGE = (1<<31)


