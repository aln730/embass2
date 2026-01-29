TTL Program Title: Lab 3 - Arithmetic Computation with Overflow
;****************************************************************
;Lab 3: Memory, Conditional Branching, and Debugging Tools
;This program computes:
; F = 3P + 2Q - 75
; G = 2P - 4Q + 63
; Result = F + G
; The program checks for byte overflow for each computation.
; Name:  Arnav Gawas
; Date:  01/29/2026
; Class: CMPE-250
; Section:  TBD
;---------------------------------------------------------------
;Keil Simulator Template for KL05
;R. W. Melton
;August 21, 2025
;****************************************************************

            THUMB
            OPT    64  ;Turn on listing macro expansions

;****************************************************************
;EQUates for multiplication shifts
MUL1    EQU 1
MUL2    EQU 1  ; multiply by 2 = shift left 1
MUL4    EQU 2  ; multiply by 4 = shift left 2

;****************************************************************
;Constants
            AREA    MyConst,DATA,READONLY
const_F     DCD 75
const_G     DCD 63
;>>>>> begin constants here <<<<<
;>>>>>   end constants here <<<<<
            ALIGN
;****************************************************************
;Variables
            AREA    MyData,DATA,READWRITE
P           DCD 0
Q           DCD 0
F           DCD 0
G           DCD 0
Result      DCD 0
;>>>>> begin variables here <<<<<
;>>>>>   end variables here <<<<<
            ALIGN
;****************************************************************
;Program
;Linker requires Reset_Handler
            AREA    MyCode,CODE,READONLY
            ENTRY
            EXPORT  Reset_Handler

Reset_Handler  PROC {}
            ; Initialize registers
            BL      RegInit

;>>>>> begin main program code <<<<<
            BL      ComputeF
            BL      ComputeG
            BL      ComputeResult
;>>>>>   end main program code <<<<<

;Stay here
            B       .
            ENDP    ;Reset_Handler
;---------------------------------------------------------------
RegInit     PROC {}
;********************************************************************
;Initializes registers R1 = P, R2 = Q from memory
;********************************************************************
            LDR     R1,=P
            LDR     R1,[R1]
            LDR     R2,=Q
            LDR     R2,[R2]
            BX      LR
            ENDP    ;RegInit
;---------------------------------------------------------------
ComputeF    PROC {}
;********************************************************************
;Computes F = 3P + 2Q - 75
;Checks for byte overflow [-128, 127] after each operation
;********************************************************************
            PUSH    {R4-R5,LR}

            ; 3P = 2P + P
            MOV     R4,R1
            LSL     R5,R1,MUL1
            ADDS    R4,R4,R5
            CMP     R4,#127
            BGT     F_Overflow
            CMP     R4,#-128
            BLT     F_Overflow

            ; 3P + 2Q
            LSL     R5,R2,MUL1
            ADDS    R4,R4,R5
            CMP     R4,#127
            BGT     F_Overflow
            CMP     R4,#-128
            BLT     F_Overflow

            ; Subtract const_F
            LDR     R5,=const_F
            LDR     R5,[R5]
            SUBS    R4,R4,R5
            CMP     R4,#127
            BGT     F_Overflow
            CMP     R4,#-128
            BLT     F_Overflow

            ; Store F
            LDR     R5,=F
            STR     R4,[R5]
            B       F_End

F_Overflow:
            LDR     R5,=F
            MOV     R4,#0
            STR     R4,[R5]

F_End:
            POP     {R4-R5,LR}
            BX      LR
            ENDP    ;ComputeF
;---------------------------------------------------------------
ComputeG    PROC {}
;********************************************************************
;Computes G = 2P - 4Q + 63
;Uses V flag to detect overflow
;********************************************************************
            PUSH    {R4-R6,LR}

            ; 2P
            LSL     R4,R1,MUL1

            ; -4Q
            LSL     R5,R2,MUL2
            SUBS    R4,R4,R5
            BVS     G_Overflow

            ; Add const_G
            LDR     R5,=const_G
            LDR     R5,[R5]
            ADDS    R4,R4,R5
            BVS     G_Overflow

            ; Store G
            LDR     R6,=G
            STR     R4,[R6]
            B       G_End

G_Overflow:
            LDR     R6,=G
            MOV     R4,#0
            STR     R4,[R6]

G_End:
            POP     {R4-R6,LR}
            BX      LR
            ENDP    ;ComputeG
;---------------------------------------------------------------
ComputeResult PROC {}
;********************************************************************
;Computes Result = F + G
;Checks for byte overflow [-128, 127]
;********************************************************************
            PUSH    {R4-R5,LR}

            LDR     R4,=F
            LDR     R4,[R4]
            LDR     R5,=G
            LDR     R5,[R5]
            ADDS    R4,R4,R5
            CMP     R4,#127
            BGT     R_Overflow
            CMP     R4,#-128
            BLT     R_Overflow

            LDR     R5,=Result
            STR     R4,[R5]
            B       R_End

R_Overflow:
            LDR     R5,=Result
            MOV     R4,#0
            STR     R4,[R5]

R_End:
            POP     {R4-R5,LR}
            BX      LR
            ENDP    ;ComputeResult
;---------------------------------------------------------------
;>>>>> begin subroutine code <<<<<
;>>>>>   end subroutine code <<<<<
            ALIGN
;****************************************************************
;Vector Table Mapped to Address 0 at Reset
;Linker requires __Vectors to be exported
            AREA    RESET, DATA, READONLY
            EXPORT  __Vectors
            EXPORT  __Vectors_End
            EXPORT  __Vectors_Size
__Vectors 
                                      ;ARM core vectors
            DCD    __initial_sp       ;00:end of stack
            DCD    Reset_Handler      ;reset vector
            SPACE  (VECTOR_TABLE_SIZE - (2 * VECTOR_SIZE))
__Vectors_End
__Vectors_Size  EQU     __Vectors_End - __Vectors
            ALIGN
;****************************************************************
;Constants
            AREA    MyConst,DATA,READONLY
;>>>>> begin constants here <<<<<
;>>>>>   end constants here <<<<<
;****************************************************************
            AREA    |.ARM.__at_0x1FFFFC00|,DATA,READWRITE,ALIGN=3
            EXPORT  __initial_sp
;Allocate system stack
            IF      :LNOT::DEF:SSTACK_SIZE
SSTACK_SIZE EQU     0x00000100
            ENDIF
Stack_Mem   SPACE   SSTACK_SIZE
__initial_sp
;****************************************************************
;Variables
            AREA    MyData,DATA,READWRITE
;>>>>> begin variables here <<<<<
;>>>>>   end variables here <<<<<
            END
