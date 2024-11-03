    INCLUDE core_cm4_constants.s		
    INCLUDE stm32l476xx_constants.s      
		
	AREA myData, DATA, READWRITE ;data section

Matrix DCD 1,2,3,1,2,3,1,2,3 ;row major each is a word for integer so total 36 bytes
zMem   SPACE 36	;reserving zeroed memory in data to store the modified matrix
	

	AREA P2, CODE 
	EXPORT __main 
	ALIGN 
	ENTRY 

__main PROC 

	; input which columns to swap in 3x3 matrix
	MOV r0, #1 ; col1 = 2
	MOV r1, #2 ; col2 = 1
	
	LDR r2, =Matrix ; get matrix address
	LDR r3, =zMem
	
	; get indices 
	MOV r4, r0 ; get col 1 first element index in the matrix (j1)
	MOV r5, r1 ; get col 2 first element index in the matrix (j2)
	
	MOV r6, #0 ; row counter (i)
	
	MOV r8, #3 ; to multiply later for next element address
	
	; remainin column
	ADD r11, r0, r1
	SUB r11, r8, r11
	
	; loop until no rows left
loop
	CMP r6, #3
	BEQ stop ; if processed all rows exit
	; copy current row to get next element in each column
	MOV r7, r6
	; ( i*columns + j1) * 4
	MUL r7, r7, r8 ; row * 3
	ADD r4, r7, r0
	; got address of i element in first column 
	LSL r4, r4, #2
	
	ADD r5, r7, r1
	; address of i element in second column
	LSL r5, r5, #2
	
	; address of remaining column to copy
	ADD r12, r7, r11
	LSL r12, r12, #2
	
	; load elements to swap
	LDR r9, [r2, r4]
	LDR r10, [r2, r5]
	
	STR r10, [r3, r4] ; now swap by storing to location of other column's element
	STR r9, [r3, r5] 
	
	LDR r9, [r2, r12] ; store remaining element
	STR r9, [r3, r12]
	
	ADD r6, r6, #1
	B loop
	
stop B stop
	ENDP
	END
