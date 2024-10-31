    INCLUDE core_cm4_constants.s	
    INCLUDE stm32l476xx_constants.s      
		

	AREA P1, CODE 
	EXPORT __main 
	ALIGN 
	ENTRY 

__main PROC 

	MOV r0, #0 ; total
	;r1 = input = a 
	;r2 = input = b 
	MOV r1, #3 
	MOV r2, #5 
	
	; r3 = loop counter
	MOV r3, #0
	; r4 = new sum
	MOV r4, #0
	; r5 = 10 imm value for multiplication
	MOV r5, #10
	
loop 

	; sum = sum * 10 + a
	; total = total + sum
	CMP r2, r3
	BEQ stop ; if b equals counter branch to stop execution
	
	MLA r4, r4, r5, r1; multiply with accumulate
	ADD r0, r0, r4
	
	ADD r3, r3, #1
	B loop
	
	
stop B stop
	ENDP
	END