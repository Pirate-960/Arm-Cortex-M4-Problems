    INCLUDE core_cm4_constants.s    
    INCLUDE stm32l476xx_constants.s      

    AREA P1, CODE
    EXPORT __main
    ALIGN
    ENTRY

__main PROC
; Setting Up Registers (Local Variables)
; r0 = total (total sum of all terms)
; r1 = num1 (first input, e.g., 45)
; r2 = num2 (second input, number of terms, e.g., 3)
; r3 = multiplyFactor (used to shift digits)
; r4 = sum (new term to be added to total)
; r5 = loop counter (i)
; r6 = temp (for digit counting in num1)
; r7 = constant 10 (used for digit calculations)

    ; Initialize variables
    MOV r0, #0       ; total = 0
    MOV r1, #45      ; num1 = 45
    MOV r2, #3       ; num2 = 3
    MOV r4, #0       ; sum = 0
    MOV r5, #1       ; multiplyFactor = 1
    MOV r7, #10      ; constant 10 for multiplication/division
    MOV r6, r1       ; temp = num1 (to calculate multiplyFactor)

    ; Calculate multiplyFactor based on the number of digits in num1
L1
    CMP r6, #0             ; Compare temp with 0
    BEQ L2                 ; If temp == 0, exit loop
    MUL r5, r5, r7         ; multiplyFactor *= 10
    UDIV r6, r6, r7        ; temp /= 10
    B L1                   ; Repeat loop

L2
    MOV r3, #0             ; Initialize loop counter i = 0

L3
    CMP r3, r2             ; Check if i < num2
    BGE stop               ; If i >= num2, stop the loop

    ; Shift sum by multiplyFactor and add num1
    ;MUL r4, r4, r5         ; sum = sum * multiplyFactor
    ;ADD r4, r4, r1         ; sum += num1
	MLA r4, r4, r5, r1
	
    ; Add sum to total
    ADD r0, r0, r4         ; total += sum

    ; Increment loop counter
    ADD r3, r3, #1         ; i++
    B L3                   ; Repeat loop

stop
    B stop                 ; Infinite loop to end program

    ENDP
    END
