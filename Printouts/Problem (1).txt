    INCLUDE core_cm4_constants.s	
    INCLUDE stm32l476xx_constants.s      
		
	AREA myData, DATA, READWRITE ;define data section

input DCD 45,3 ; argumments a and n
	
	
	AREA P1, CODE 
	EXPORT __main 
	ALIGN 
	ENTRY 

__main PROC 

	MOV r0, #0 ; total
	;r1 = input = a 
	;r2 = input = b 
	LDR r1, = input ; load addr of input
	LDR r1, [r1]
	LDR r2, =input+4
	LDR r2, [r2]
	
	; r3 = loop counter
	MOV r3, #0
	; r4 = new sum
	MOV r4, #0
	; r5 = multiplication factor
	MOV r5, #1
	; copy a to r6 for digit count
	MOV r6, r1
	MOV r7, #10 ; temp reg to multiply and divide
	
count_digits
	CMP r6, #0
	BEQ loop ; no mmore digits left begin main loop
	MUL r5, r5, r7 ; multp factor increased
	UDIV r6, r6, r7
	B count_digits
	
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