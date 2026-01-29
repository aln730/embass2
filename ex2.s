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
            MOVS    R3, R1          ; R3 = P
            ADDS    R3, R3, R3      ; 2P
            ADDS    R3, R3, R1      ; 3P

            MOVS    R4, R2          ; R4 = Q
            ADDS    R4, R4, R4      ; 2Q

            ADDS    R3, R3, R4      ; 3P + 2Q
            SUBS    R3, R3, #75     ; -75

            MOVS    R5, R3
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
            MOVS    R3, R1
            ADDS    R3, R3, R3      ; 2P

            MOVS    R4, R2
            ADDS    R4, R4, R4      ; 2Q
            ADDS    R4, R4, R4      ; 4Q
            RSBS    R4, R4, #0      ; -4Q

            ADDS    R3, R3, R4
            ADDS    R3, R3, #63     ; +63

            MOVS    R5, R3
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
            ADDS    R3, R3, R4

            LDR     R7, =Result
            STR     R3, [R7]

;>>>>>   end main program code <<<<<
