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

        INCLUDE ../../../include/hardware/custom.i
        INCLUDE exec.i

        GLOBAL  bootstrap_exec_lib

bootstrap_exec_lib:
        ; set up exec base
        lea.l   $40000,a6      ; where do we really want exec base?
        move.l  a6,$4.w
        move.l  a6,d0
        not.l   d0
        move.l  d0,(ChkBase,a6)

        bsr.b   set_jump_vectors
        bsr.b   initialize_lists
        bsr.b   detach
        rts

; fire up multitasking, making ourselves the currently running task
detach:
        ; allocate a entry for the task descriptor
        lea     .list,a0
        bsr.b   AllocEntry
        move.l  d0,a0

        move.l  (LN_SIZE+2,a0),a1       ; allocated memory
        lea     (1024,a1),a2            ; StackControl
        move.l  a2,usp

        move.l  a1,(TC_SPLOWER,a2)
        move.l  a2,(TC_SPUPPER,a2)
        move.l  a2,(TC_SPREG,a2)
        clr.b   (LN_PRI,a2)
        move.b  #NT_TASK,(LN_TYPE,a2)
        move.l  #.task_name,(LN_NAME,a2)

        ; clear tasks memory list
        lea.l   (TC_MEMENTRY,a2),a0
        move.l  a0,(LH_HEAD,a0)
        clr.l   (LH_TAIL,a0)
        move.l  a0,(LH_TAILPRED,a0)

        ; Add the memory list from AllocEntry
        move.l  d0,a1
        bsr.b   AddHead

        ; Add the task
        move.l  a2,(ThisTask,a6)
        sub.l   a2,a2
        move.l  a2,a3
        bsr.b   AddTask

        move.l  (ThisTask,a6),a1
        move.b  #TS_RUN,(TC_FLAGS,a1)

        ; Unlink it from the TaskReady queue
        bsr.b   Remove

        ; and fire up multitasking :-)
        and.w   #0,sr
        bsr.b   Permit
        rts

.task_name:
        dc.b    "exec.library",0
        even

.list:  blk.b   0,LH_SIZE
        dc.w    1
        dc.l    MEMF_PUBLIC | MEMF_CLEAR
        dc.l    1024 + TC_SIZE


; Initializes all ListNode structures in ExecBase
initialize_lists:
        lea.l   .table(pc),a0
.loop   move.w  (a0)+,d0
        beq.b   .end
        lea.l   (a6,d0.w),a1
        move.l  a1,(LH_HEAD,a1)
        clr.l   (LH_TAIL,a1)
        move.l  a1,(LH_TAILPRED,a1)
        move.w  (a0)+,d0
        move.b  d0,(LH_TYPE,a1)
        bra.b   .loop
.end    rts

.table  dc.w    MemList,       NT_MEMORY
        dc.w    ResourceList,  NT_RESOURCE
        dc.w    DeviceList,    NT_DEVICE
        dc.w    LibList,       NT_LIBRARY
        dc.w    PortList,      NT_MSGPORT
        dc.w    TaskReady,     NT_TASK
        dc.w    TaskWait,      NT_TASK
        dc.w    IntrList,      NT_INTERRUPT
        dc.w    SoftInts+$10*0,NT_SOFTINT
        dc.w    SoftInts+$10*1,NT_SOFTINT
        dc.w    SoftInts+$10*2,NT_SOFTINT
        dc.w    SoftInts+$10*3,NT_SOFTINT
        dc.w    SoftInts+$10*4,NT_SOFTINT
        dc.w    SemaphoreList, NT_SIGNALSEM
        dc.w    0

set_jump_vectors:
        ; generate a stubbed jump vector table
        move.w  #-906,d0
        move.w  #$4ef9,d1
.loop:  move.w  d1,(a6,d0)
        move.l  #bad_stub,2(a6,d0)
        addq.w  #6,d0
        cmp.w   #-72,d0
        ble.b   .loop

        ; we could shave of some bytes by
        ; migrating this to a relative index table
        addq.l  #2,a6
        move.l  #InitCode,-72(a6)
        move.l  #InitStruct,-78(a6)
        move.l  #MakeLibrary,-84(a6)
        move.l  #MakeFunctions,-90(a6)
        move.l  #FindResident,-96(a6)
        move.l  #InitResident,-102(a6)
        move.l  #Alert,-108(a6)
        move.l  #Debug,-114(a6)
        move.l  #Disable,-120(a6)
        move.l  #Enable,-126(a6)
        move.l  #Forbid,-132(a6)
        move.l  #Permit,-138(a6)
        move.l  #SetSR,-144(a6)
        move.l  #SuperState,-150(a6)
        move.l  #UserState,-156(a6)
        move.l  #SetIntVector,-162(a6)
        move.l  #AddIntServer,-168(a6)
        move.l  #RemIntServer,-174(a6)
        move.l  #Cause,-180(a6)
        move.l  #Allocate,-186(a6)
        move.l  #Deallocate,-192(a6)
        move.l  #AllocMem,-198(a6)
        move.l  #AllocAbs,-204(a6)
        move.l  #FreeMem,-210(a6)
        move.l  #AvailMem,-216(a6)
        move.l  #AllocEntry,-222(a6)
        move.l  #FreeEntry,-228(a6)
        move.l  #Insert,-234(a6)
        move.l  #AddHead,-240(a6)
        move.l  #AddTail,-246(a6)
        move.l  #Remove,-252(a6)
        move.l  #RemHead,-258(a6)
        move.l  #RemTail,-264(a6)
        move.l  #Enqueue,-270(a6)
        move.l  #FindName,-276(a6)
        move.l  #AddTask,-282(a6)
        move.l  #RemTask,-288(a6)
        move.l  #FindTask,-294(a6)
        move.l  #Supervisor,-30(a6)
        move.l  #SetTaskPri,-300(a6)
        move.l  #SetSignal,-306(a6)
        move.l  #SetExcept,-312(a6)
        move.l  #Wait,-318(a6)
        move.l  #Signal,-324(a6)
        move.l  #AllocSignal,-330(a6)
        move.l  #FreeSignal,-336(a6)
        move.l  #AllocTrap,-342(a6)
        move.l  #FreeTrap,-348(a6)
        move.l  #AddPort,-354(a6)
        move.l  #RemPort,-360(a6)
        move.l  #PutMsg,-366(a6)
        move.l  #GetMsg,-372(a6)
        move.l  #ReplyMsg,-378(a6)
        move.l  #WaitPort,-384(a6)
        move.l  #FindPort,-390(a6)
        move.l  #AddLibrary,-396(a6)
        move.l  #RemLibrary,-402(a6)
        move.l  #OldOpenLibrary,-408(a6)
        move.l  #CloseLibrary,-414(a6)
        move.l  #SetFunction,-420(a6)
        move.l  #SumLibrary,-426(a6)
        move.l  #AddDevice,-432(a6)
        move.l  #RemDevice,-438(a6)
        move.l  #OpenDevice,-444(a6)
        move.l  #CloseDevice,-450(a6)
        move.l  #DoIO,-456(a6)
        move.l  #SendIO,-462(a6)
        move.l  #CheckIO,-468(a6)
        move.l  #WaitIO,-474(a6)
        move.l  #AbortIO,-480(a6)
        move.l  #AddResource,-486(a6)
        move.l  #RemResource,-492(a6)
        move.l  #OpenResource,-498(a6)
        move.l  #RawDoFmt,-522(a6)
        move.l  #GetCC,-528(a6)
        move.l  #TypeOfMem,-534(a6)
        move.l  #Procure,-540(a6)
        move.l  #Vacate,-546(a6)
        move.l  #OpenLibrary,-552(a6)
        move.l  #InitSemaphore,-558(a6)
        move.l  #ObtainSemaphore,-564(a6)
        move.l  #ReleaseSemaphore,-570(a6)
        move.l  #AttemptSemaphore,-576(a6)
        move.l  #ObtainSemaphoreList,-582(a6)
        move.l  #ReleaseSemaphoreList,-588(a6)
        move.l  #FindSemaphore,-594(a6)
        move.l  #AddSemaphore,-600(a6)
        move.l  #RemSemaphore,-606(a6)
        move.l  #SumKickData,-612(a6)
        move.l  #AddMemList,-618(a6)
        move.l  #CopyMem,-624(a6)
        move.l  #CopyMemQuick,-630(a6)
        move.l  #CacheClearU,-636(a6)
        move.l  #CacheClearE,-642(a6)
        move.l  #CacheControl,-648(a6)
        move.l  #CreateIORequest,-654(a6)
        move.l  #DeleteIORequest,-660(a6)
        move.l  #CreateMsgPort,-666(a6)
        move.l  #DeleteMsgPort,-672(a6)
        move.l  #ObtainSemaphoreShared,-678(a6)
        move.l  #AllocVec,-684(a6)
        move.l  #FreeVec,-690(a6)
        move.l  #CreatePool,-696(a6)
        move.l  #DeletePool,-702(a6)
        move.l  #AllocPooled,-708(a6)
        move.l  #FreePooled,-714(a6)
        move.l  #AttemptSemaphoreShared,-720(a6)
        move.l  #ColdReboot,-726(a6)
        move.l  #StackSwap,-732(a6)
        move.l  #CachePreDMA,-762(a6)
        move.l  #CachePostDMA,-768(a6)
        move.l  #AddMemHandler,-774(a6)
        move.l  #RemMemHandler,-780(a6)
        move.l  #ObtainQuickVector,-786(a6)
        move.l  #NewMinList,-828(a6)
        move.l  #AVL_AddNode,-852(a6)
        move.l  #AVL_RemNodeByAddress,-858(a6)
        move.l  #AVL_RemNodeByKey,-864(a6)
        move.l  #AVL_FindNode,-870(a6)
        move.l  #AVL_FindPrevNodeByAddress,-876(a6)
        move.l  #AVL_FindPrevNodeByKey,-882(a6)
        move.l  #AVL_FindNextNodeByAddress,-888(a6)
        move.l  #AVL_FindNextNodeByKey,-894(a6)
        move.l  #AVL_FindFirstNode,-900(a6)
        move.l  #AVL_FindLastNode,-906(a6)
        subq.l  #2,a6
	rts

AVL_AddNode:
AVL_FindFirstNode:
AVL_FindLastNode:
AVL_FindNextNodeByAddress:
AVL_FindNextNodeByKey:
AVL_FindNode:
AVL_FindPrevNodeByAddress:
AVL_FindPrevNodeByKey:
AVL_RemNodeByAddress:
AVL_RemNodeByKey:
AbortIO:
AddDevice:
AddHead:
AddIntServer:
AddLibrary:
AddMemHandler:
AddMemList:
AddPort:
AddResource:
AddSemaphore:
AddTail:
AddTask:
Alert:
AllocAbs:
        jmp     stub

AllocEntry:
        lea     $dff000,a0
        move.w  #$ff0,d0
.loop:  move.w  d0,(COLOR+0,a0)
        bra.b   .loop

AllocMem:
AllocPooled:
AllocSignal:
AllocTrap:
AllocVec:
Allocate:
AttemptSemaphore:
AttemptSemaphoreShared:
AvailMem:
CacheClearE:
CacheClearU:
CacheControl:
CachePostDMA:
CachePreDMA:
Cause:
CheckIO:
CloseDevice:
CloseLibrary:
ColdReboot:
CopyMem:
CopyMemQuick:
CreateIORequest:
CreateMsgPort:
CreatePool:
Deallocate:
Debug:
DeleteIORequest:
DeleteMsgPort:
DeletePool:
Disable:
DoIO:
Enable:
Enqueue:
FindName:
FindPort:
FindResident:
FindSemaphore:
FindTask:
Forbid:
FreeEntry:
FreeMem:
FreePooled:
FreeSignal:
FreeTrap:
FreeVec:
GetCC:
GetMsg:
InitCode:
InitResident:
InitSemaphore:
InitStruct:
Insert:
MakeFunctions:
MakeLibrary:
NewMinList:
ObtainQuickVector:
ObtainSemaphore:
ObtainSemaphoreList:
ObtainSemaphoreShared:
        jmp     stub

OldOpenLibrary:
        moveq   #0,d0
        jsr     -552(a6)        ; OpenLibrary
        rts

OpenDevice:
        jmp     stub

OpenLibrary:
        lea     $dff000,a0
        move.w  #$f0,d0
.loop:  move.w  d0,(COLOR+0,a0)
        bra.b   .loop

OpenResource:
Permit:
Procure:
PutMsg:
RawDoFmt:
ReleaseSemaphore:
ReleaseSemaphoreList:
RemDevice:
RemHead:
RemIntServer:
RemLibrary:
RemMemHandler:
RemPort:
RemResource:
RemSemaphore:
RemTail:
RemTask:
Remove:
ReplyMsg:
SendIO:
SetExcept:
SetFunction:
SetIntVector:
SetSR:
SetSignal:
SetTaskPri:
Signal:
StackSwap:
SumKickData:
SumLibrary:
SuperState:
Supervisor:
TypeOfMem:
UserState:
Vacate:
Wait:
WaitIO:
WaitPort:

stub:
        lea     $dff000,a0
        moveq   #0,d0
.loop:  move.w  d0,(COLOR+0,a0)
        add.w   #$100,d0
        bra.b   .loop

bad_stub:
        lea     $dff000,a0
	move.w	#$f00,d0
.loop:	move.w	d0,(COLOR+0,a0)
	bra.b	.loop
