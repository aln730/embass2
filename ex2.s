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
            OPT    64  ; Turn on listing macro expansions

;****************************************************************
;EQUates for multiplication shifts
MUL2    EQU  1  ; multiply by 2 = shift left 1
MUL3    EQU  1  ; multiply by 3 = 2*val + val
MUL4    EQU  2  ; multiply by 4 = shift left 2

;****************************************************************
;Constants
            AREA    MyConst, DATA, READONLY
const_F     DCD 75
const_G     DCD 63
            ALIGN

;****************************************************************
;Variables
            AREA    MyData, DATA, READWRITE
P           DCD 0
Q           DCD 0
F           DCD 0
G           DCD 0
Result      DCD 0
            ALIGN

;****************************************************************
;Program
            AREA    MyCode,CODE,READONLY
            ENTRY
            EXPORT  Reset_Handler

Reset_Handler  PROC
            BL      RegInit          ; Initialize registers
            BL      ComputeF         ; Compute F = 3P + 2Q - 75
            BL      ComputeG         ; Compute G = 2P - 4Q + 63
            BL      ComputeResult    ; Result = F + G
            B       .                ; Infinite loop to end program
            ENDP

;---------------------------------------------------------------
RegInit     PROC
; Initialize P and Q registers (R1, R2) from memory
            LDR     R1, =P
            LDR     R1, [R1]        ; Load P
            LDR     R2, =Q
            LDR     R2, [R2]        ; Load Q
            BX      LR
            ENDP

;---------------------------------------------------------------
ComputeF    PROC
; F = 3P + 2Q - 75
; Overflow check after each operation (byte)
            PUSH    {R4-R5, LR}

            ; 3P = 2P + P
            MOV     R4, R1          ; R4 = P
            LSL     R5, R1, MUL1    ; R5 = P*2
            ADDS    R4, R4, R5      ; R4 = 3P
            ; Check byte overflow
            CMP     R4, #127
            BGT     F_Overflow
            CMP     R4, #-128
            BLT     F_Overflow

            ; 3P + 2Q
            LSL     R5, R2, MUL1    ; 2Q
            ADDS    R4, R4, R5
            CMP     R4, #127
            BGT     F_Overflow
            CMP     R4, #-128
            BLT     F_Overflow

            ; Subtract const_F = 75
            LDR     R5, =const_F
            LDR     R5, [R5]
            SUBS    R4, R4, R5
            CMP     R4, #127
            BGT     F_Overflow
            CMP     R4, #-128
            BLT     F_Overflow

            ; Store result F
            LDR     R5, =F
            STR     R4, [R5]
            B       F_End

F_Overflow:
            LDR     R5, =F
            MOV     R4, #0
            STR     R4, [R5]

F_End:
            POP     {R4-R5, LR}
            BX      LR
            ENDP

;---------------------------------------------------------------
ComputeG    PROC
; G = 2P - 4Q + 63
; Overflow check using V flag
            PUSH    {R4-R5, LR}

            ; Shift P and Q to most significant byte
            MOV     R4, R1
            LSL     R4, R4, #24     ; 2P in MSB will use addition method
            LSL     R5, R2, #24     ; 4Q in MSB

            ; 2P = P shifted + P
            LSL     R6, R1, MUL1    ; 2P
            MOV     R4, R6

            ; -4Q = - (Q*4) = subtract 4Q
            LSL     R6, R2, MUL2    ; 4Q
            SUBS    R4, R4, R6      ; R4 = 2P -4Q
            ; Check V flag for overflow
            BVS     G_Overflow

            ; Add const_G
            LDR     R6, =const_G
            LDR     R6, [R6]
            ADDS    R4, R4, R6
            BVS     G_Overflow

            ; Store result G
            LDR     R5, =G
            STR     R4, [R5]
            B       G_End

G_Overflow:
            LDR     R5, =G
            MOV     R4, #0
            STR     R4, [R5]

G_End:
            POP     {R4-R5, LR}
            BX      LR
            ENDP

;---------------------------------------------------------------
ComputeResult PROC
; Result = F + G
            PUSH    {R4-R5, LR}
            LDR     R4, =F
            LDR     R4, [R4]
            LDR     R5, =G
            LDR     R5, [R5]
            ADDS    R4, R4, R5      ; R4 = F + G
            ; Check simple byte overflow
            CMP     R4, #127
            BGT     R_Overflow
            CMP     R4, #-128
            BLT     R_Overflow

            LDR     R5, =Result
            STR     R4, [R5]
            B       R_End

R_Overflow:
            LDR     R5, =Result
            MOV     R4, #0
            STR     R4, [R5]

R_End:
            POP     {R4-R5, LR}
            BX      LR
            ENDP

            END
