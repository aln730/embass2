;>>>>> begin main program code <<<<<

            ; Load P and Q
            LDR     R1, =P
            LDR     R1, [R1]        ; R1 = P
            LDR     R2, =Q
            LDR     R2, [R2]        ; R2 = Q

;---------------------------------------------------------------
; IF (P >= 0) THEN F = 3P + 2Q - 75 ELSE F = 0
            CMP     R1, #0
            BLT     F_ELSE

; ---- THEN ----
            MOV     R3, R1          ; R3 = P
            ADD     R3, R3, R3      ; 2P
            ADD     R3, R3, R1      ; 3P

            MOV     R4, R2          ; R4 = Q
            ADD     R4, R4, R4      ; 2Q

            ADD     R3, R3, R4      ; 3P + 2Q

            LDR     R6, =CONST_75
            LDR     R6, [R6]
            SUB     R3, R3, R6      ; -75

            MOV     R5, R3
            B       F_STORE

F_ELSE
            MOVS    R5, #0

F_STORE
            LDR     R7, =F
            STR     R5, [R7]

;---------------------------------------------------------------
; IF (Q >= 0) THEN G = 2P - 4Q + 63 ELSE G = 0
            CMP     R2, #0
            BLT     G_ELSE

; ---- THEN ----
            MOV     R3, R1
            ADD     R3, R3, R3      ; 2P

            MOV     R4, R2
            ADD     R4, R4, R4      ; 2Q
            ADD     R4, R4, R4      ; 4Q
            RSBS    R4, R4, #0      ; -4Q

            ADD     R3, R3, R4      ; 2P - 4Q

            LDR     R6, =CONST_63
            LDR     R6, [R6]
            ADD     R3, R3, R6      ; +63

            MOV     R5, R3
            B       G_STORE

G_ELSE
            MOVS    R5, #0

G_STORE
            LDR     R7, =G
            STR     R5, [R7]

;---------------------------------------------------------------
; Result = F + G
            LDR     R3, =F
            LDR     R3, [R3]
            LDR     R4, =G
            LDR     R4, [R4]

            ADD     R3, R3, R4      ; Result

            LDR     R7, =Result
            STR     R3, [R7]

;>>>>>   end main program code <<<<<
