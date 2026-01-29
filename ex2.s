;****************************************************************
; TTL Program: Compute F, G, Result
; Computes:
;   F = 3P + 2Q - 75
;   G = 2P - 4Q + 63
;   Result = F + G
; Name:  <Your Name Here>
; Date:  <Date Completed Here>
; Class: CMPE-250
; Section: <Lab Section, Day, Time>
; Keil Simulator Template for KL05
;****************************************************************

            THUMB
            OPT    64  ; Turn on listing macro expansions

;---------------------------------------------------------------
; EQUates
BYTE_MASK       EQU 0xFF
NIBBLE_MASK     EQU 0x0F
BYTE_BITS       EQU 8
NIBBLE_BITS     EQU 4
WORD_SIZE       EQU 4
HALFWORD_SIZE   EQU 2
HALFWORD_MASK   EQU 0xFFFF
RET_ADDR_T_MASK EQU 1

VECTOR_TABLE_SIZE EQU 0xC0
VECTOR_SIZE       EQU 4

CONTROL_SPSEL_MASK  EQU 2
CONTROL_SPSEL_SHIFT EQU 1
CONTROL_nPRIV_MASK  EQU 1
CONTROL_nPRIV_SHIFT EQU 0

PRIMASK_PM_MASK   EQU 1
PRIMASK_PM_SHIFT  EQU 0

APSR_N_MASK      EQU 0x80000000
APSR_Z_MASK      EQU 0x40000000
APSR_C_MASK      EQU 0x20000000
APSR_V_MASK      EQU 0x10000000

EPSR_T_MASK      EQU 0x01000000
IPSR_EXCEPTION_MASK EQU 0x3F

SSTACK_SIZE      EQU 0x100

;---------------------------------------------------------------
; Constants
            AREA    MyConst, DATA, READONLY
const_F     DCD 75
const_G     DCD 63

;---------------------------------------------------------------
; Variables
            AREA    MyData, DATA, READWRITE
P           DCD 0
Q           DCD 0
F           DCD 0
G           DCD 0
Result      DCD 0

;---------------------------------------------------------------
; Program Code
            AREA    MyCode, CODE, READONLY
            ENTRY
            EXPORT  Reset_Handler

Reset_Handler PROC
;---------------------------------------------------------------
; Initialize registers
            BL      RegInit

;---------------------------------------------------------------
; Load P and Q
            LDR     R1,=P
            LDR     R1,[R1]       ; R1 = P
            LDR     R2,=Q
            LDR     R2,[R2]       ; R2 = Q

;---------------------------------------------------------------
; Compute F = 3P + 2Q - 75
            MOV     R3,R1
            ADD     R3,R3,R3      ; 2P
            ADD     R3,R3,R1      ; 3P

            MOV     R4,R2
            ADD     R4,R4,R4      ; 2Q

            ADD     R5,R3,R4      ; 3P + 2Q

            LDR     R6,=const_F
            LDR     R6,[R6]
            SUB     R5,R5,R6      ; F = 3P + 2Q - 75

            LDR     R7,=F
            STR     R5,[R7]

;---------------------------------------------------------------
; Compute G = 2P - 4Q + 63
            MOV     R3,R1
            ADD     R3,R3,R3      ; 2P

            MOV     R4,R2
            ADD     R4,R4,R4      ; 2Q
            ADD     R4,R4,R4      ; 4Q

            RSBS    R4,R4,#0      ; Negate 4Q
            ADD     R5,R3,R4      ; 2P - 4Q

            LDR     R6,=const_G
            LDR     R6,[R6]
            ADD     R5,R5,R6      ; G = 2P - 4Q + 63

            LDR     R7,=G
            STR     R5,[R7]

;---------------------------------------------------------------
; Compute Result = F + G
            LDR     R3,=F
            LDR     R3,[R3]
            LDR     R4,=G
            LDR     R4,[R4]
            ADD     R5,R3,R4
            LDR     R7,=Result
            STR     R5,[R7]

;---------------------------------------------------------------
; End program: infinite loop
            B       .

            ENDP

;---------------------------------------------------------------
; Register Initialization
RegInit PROC
; Initialize registers R1–R12 and R14 with pattern 0x11111111
            PUSH    {LR}

            LDR     R1,=0x11111111
            MOV     R2,R1
            MOV     R3,R1
            MOV     R4,R1
            MOV     R5,R1
            MOV     R6,R1
            MOV     R7,R1
            MOV     R8,R1
            MOV     R9,R1
            MOV     R10,R1
            MOV     R11,R1
            MOV     R12,R1
            MOV     R14,R1

            LDR     R0,=0x05250821     ; Set R0 as needed
            POP     {PC}
            ENDP

;---------------------------------------------------------------
; Vector Table
            AREA    RESET, DATA, READONLY
            EXPORT  __Vectors
            EXPORT  __Vectors_End
            EXPORT  __Vectors_Size
__Vectors
            DCD    __initial_sp
            DCD    Reset_Handler
            SPACE  (VECTOR_TABLE_SIZE - 2*VECTOR_SIZE)
__Vectors_End
__Vectors_Size  EQU __Vectors_End - __Vectors

;---------------------------------------------------------------
; System Stack
            AREA    |.ARM.__at_0x1FFFFC00|, DATA, READWRITE, ALIGN=3
            EXPORT  __initial_sp
Stack_Mem   SPACE   SSTACK_SIZE
__initial_sp

            END
