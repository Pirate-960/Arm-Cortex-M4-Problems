	INCLUDE core_cm4_constants.s		
    INCLUDE stm32l476xx_constants.s      
		
	AREA myData, DATA, READWRITE ; data section

input DCB 0xB3 ; 8 bit data input
zMem SPACE 4	; reserving zeroed memory in data to store the expanded data 
	

	AREA P3, CODE 
	EXPORT __main 
	ALIGN 
	ENTRY 

__main PROC 
	
	LDR r0, =input
	MOV r1, #0
	LDRB r1, [r0] ; load input data to a register
	LDR r2, =zMem
	
	MOV r3, #0 ; 13-bit extended
	
	; extract bits and store inside r3
	
	; bit 7 to 12
	MOV r4, r1, LSR #7
	ORR r3, r3, r4, LSL #12
	; bit 6 to 11
	MOV r4, r1, LSR #6
	AND r4, r4, #1 ; mask LSB
	ORR r3, r3, r4, LSL #11
	; bit 5 to 10
	MOV r4, r1, LSR #5
	AND r4, r4, #1 ; mask LSB
	ORR r3, r3, r4, LSL #10
	; bit 4 to 9
	MOV r4, r1, LSR #4
	AND r4, r4, #1 ; mask LSB
	ORR r3, r3, r4, LSL #9
	; bit 3 to 7
	MOV r4, r1, LSR #3
	AND r4, r4, #1 ; mask LSB
	ORR r3, r3, r4, LSL #7
	; bit 2 to 6
	MOV r4, r1, LSR #2
	AND r4, r4, #1 ; mask LSB
	ORR r3, r3, r4, LSL #6
	; bit 1 to 5
	MOV r4, r1, LSR #1
	AND r4, r4, #1 ; mask LSB
	ORR r3, r3, r4, LSL #5
	; bit 0 to 3
	MOV r4, r1
	AND r4, r4, #1 ; mask LSB
	ORR r3, r3, r4, LSL #3
	
	; masked parity reg to check correspnding bits
	LDR r4, =0x0AA8 ; p1
	LDR r5, =0x0CC8 ; p2
	LDR r6, =0x10E0 ; p4
	LDR r7, =0x1E00 ; p8
	LDR r8, =0x1FFE ; p0 
	
	AND r4, r3, r4 ; its for checking p1
	AND r5, r3, r5 ; p2
	AND r6, r3, r6 ; P4
	AND r7, r3, r7 ; p8
	AND r8, r3, r8 ; p0
	
	MOV r9, #0 ; to use in xor to check even parity
parity1
	ANDS r10, r4, #1
	EOR r9, r9, r10 
	LSR r4, r4, #1
	CMP r4, #0 ; check if checked all bits
	BNE parity1
	; if data contain odd number r9 is 1 and store one into p1 (bit 1)
	ORR r3, r3, r9, LSL #1
	
	
	; next parity check for p2
	MOV r9, #0 ; to use in xor to check even parity
parity2
	ANDS r10, r5, #1
	EOR r9, r9, r10 
	LSR r5, r5, #1
	CMP r5, #0 ; check if checked all bits
	BNE parity2
	; if data contain odd number r9 is 1 and store one into p1 (bit 1)
	ORR r3, r3, r9, LSL #2
	
; next parity check for p2
	MOV r9, #0 ; to use in xor to check even parity
parity4
	ANDS r10, r6, #1
	EOR r9, r9, r10 
	LSR r6, r6, #1
	CMP r6, #0 ; check if checked all bits
	BNE parity4
	; if data contain odd number r9 is 1 and store one into p1 (bit 1)
	ORR r3, r3, r9, LSL #4
	

; next parity check for p2
	MOV r9, #0 ; to use in xor to check even parity
parity8
	ANDS r10, r7, #1
	EOR r9, r9, r10 
	LSR r7, r7, #1
	CMP r7, #0 ; check if checked all bits
	BNE parity8
	; if data contain odd number r9 is 1 and store one into p1 (bit 1)
	ORR r3, r3, r9, LSL #8
	
	
; next parity check for p2
	MOV r9, #0 ; to use in xor to check even parity
parity0
	ANDS r10, r8, #1
	EOR r9, r9, r10 
	LSR r8, r8, #1
	CMP r8, #0 ; check if checked all bits
	BNE parity0
	; if data contain odd number r9 is 1 and store one into p1 (bit 1)
	ORR r3, r3, r9, LSL #0
	
	; store expanded data 13 bit
	STR r3, [r2]
	
stop B stop
	ENDP
	END