;****************************************************************
; TTL Program Title: Lab 3 - Compute F, G, Result
; Descriptive comment: Computes F = 3P+2Q-75, G = 2P-4Q+63, Result=F+G
; Name:  Arnav Gawas
; Date:  Jan 29, 2026
; Class: CMPE-250
; Section: 01, M/W 10:00-11:15
;****************************************************************

            THUMB
            OPT    64  ; Turn on macro expansion in listing

;---------------------------------------------------------------
; Constants (ROM)
;---------------------------------------------------------------
            AREA    MyConst,DATA,READONLY
const_F      DCD 75
const_G      DCD 63

; Multiplication shifts
MUL2    EQU 1
MUL3    EQU 1
MUL4    EQU 2

;---------------------------------------------------------------
; Variables (RAM)
;---------------------------------------------------------------
            AREA    MyData,DATA,READWRITE
P           DCD 0
Q           DCD 0
F           DCD 0
G           DCD 0
Result      DCD 0

;---------------------------------------------------------------
; Main Code
;---------------------------------------------------------------
            AREA    MyCode,CODE,READONLY
            ENTRY
            EXPORT  Reset_Handler

Reset_Handler PROC
;---------------------------------------------------------------
; Initialize registers
            BL      RegInit

;---------------------------------------------------------------
; Load P and Q into R1 and R2
            LDR     R1,=P
            LDR     R1,[R1]       ; R1 = P
            LDR     R2,=Q
            LDR     R2,[R2]       ; R2 = Q

;---------------------------------------------------------------
; Compute F = 3P + 2Q - 75
; 3P = (P<<1)+P
            MOV     R3,R1
            ADD     R3,R3,R3      ; 2P
            ADD     R3,R3,R1      ; 3P

; 2Q = Q<<1
            MOV     R4,R2
            ADD     R4,R4,R4      ; 2Q

; F = 3P + 2Q
            ADD     R5,R3,R4

; F = F - 75
            LDR     R6,=const_F
            LDR     R6,[R6]
            SUB     R5,R5,R6

; Store F
            LDR     R7,=F
            STR     R5,[R7]

;---------------------------------------------------------------
; Compute G = 2P - 4Q + 63
; 2P = P<<1
            MOV     R3,R1
            ADD     R3,R3,R3      ; 2P

; 4Q = Q<<2
            MOV     R4,R2
            ADD     R4,R4,R4      ; 2Q
            ADD     R4,R4,R4      ; 4Q

; 2P - 4Q
            RSBS    R4,R4,#0      ; Negate 4Q
            ADD     R5,R3,R4      ; 2P - 4Q

; +63
            LDR     R6,=const_G
            LDR     R6,[R6]
            ADD     R5,R5,R6      ; G = 2P - 4Q + 63

; Store G
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
; End program: loop here
            B       .

            ENDP

;---------------------------------------------------------------
RegInit PROC
; Optional register initialization (template)
            PUSH    {LR}
            ; initialize registers if desired
            POP     {PC}
            ENDP

            END
