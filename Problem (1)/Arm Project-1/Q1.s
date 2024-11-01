    INCLUDE core_cm4_constants.s	
    INCLUDE stm32l476xx_constants.s      
		

	AREA P1, CODE
	EXPORT __main
	ALIGN
	ENTRY

__main PROC
; Setting Up Registers (Local Variables)
; r0 = total
; r1 = num1 (first input)
; r2 = num2 (second input - number of terms)
; r3 = multiplyFactor (for digit count)
; r4 = sum (new term)
; r5 = loop counter
; r6 = temp (for digit counting)
	
	; Initialize variables
	MOV r0, #0	; Total = 0
	MOV r1, #45	; First Number = 45
	MOV r2, #3	; Second Number = 3
	MOV r3, #0	; Loop Counter - i = 0
	MOV r4, #0	; Sum -> Terms Accmulator = 0
	MOV r5, #1	; multiplyFactor = 1
	MOV r7, #10 ; constant value 10 for multiplication and division
	
	MOV r6, r1	; Temp = Num 1
	
	; multiplyFactor Calculation using No. Of Digits in (num1)
L1
    CMP r6, r7         ; Check if r6 < 10
    BLT digitCountDone ; If r6 < 10, we are done
    MUL r3, r3, r7     ; multiplyFactor *= 10
    SDIV r6, r6, r7    ; Divide temp by 10
    B L1

L2
L3 

	; sum = sum * 10 + a
	; total = total + sum
	CMP r2, r3
	BEQ stop ; if b equals counter branch to stop execution
	
	MLA r4, r4, r5, r1; multiply with accumulate
	ADD r0, r0, r4
	
	ADD r3, r3, #1
	B L3
	
	
stop B stop
	ENDP
	END