	INCLUDE core_cm4_constants.s        ; Include Cortex-M4 constants
    INCLUDE stm32l476xx_constants.s   ; Include STM32L476 specific constants
		
    AREA myData, DATA, READWRITE      ; Define data section for read/write data
    
; Input values: a = 45, n = 3
; This forms the series: 45 + 4545 + 454545
; Where each term adds the original number (45) to right of previous term
input DCD 45,3                        ; Arguments: a=45 (first number), n=3 (number of terms)
	
	
    AREA P1, CODE                     ; Code section begins
    EXPORT __main                     ; Make __main visible to linker
    ALIGN                            ; Ensure aligned memory access
    ENTRY                            ; Mark entry point

__main PROC 
    ; Initialize registers
    MOV r0, #0                       ; r0 = running total (accumulator)
    
    ; Load input values
    LDR r1, =input                   ; r1 = load address of first input (a)
    LDR r1, [r1]                     ; r1 = 45 (value of a)
    LDR r2, =input+4                 ; r2 = load address of second input (n)
    LDR r2, [r2]                     ; r2 = 3 (value of n)
    
    ; Initialize loop variables
    MOV r3, #0                       ; r3 = loop counter (0 to n-1)
    MOV r4, #0                       ; r4 = current term in series
    MOV r5, #1                       ; r5 = multiplication factor (will be 10^digits)
    MOV r6, r1                       ; r6 = copy of a for digit counting
    MOV r7, #10                      ; r7 = constant 10 for multiplication/division

; Count digits in input number 'a'
; For a=45, this loop will set r5 = 100 (10^2)
count_digits
    CMP r6, #0                       ; Check if we've processed all digits
    BEQ loop                         ; If no more digits, start main loop
    MUL r5, r5, r7                   ; r5 = r5 * 10 (build up multiplication factor)
    UDIV r6, r6, r7                  ; r6 = r6 / 10 (remove rightmost digit)
    B count_digits                   ; Continue counting digits

; Main processing loop
; For input 45,3 generates: 45 + 4545 + 454545
loop 
    CMP r2, r3                       ; Compare n (r2) with counter (r3)
    BEQ stop                         ; If n == counter, we're done
    
    ; Calculate next term and add to total
    MLA r4, r4, r5, r1              ; r4 = (r4 * r5) + r1
                                    ; First iteration: r4 = 0*100 + 45 = 45
                                    ; Second iteration: r4 = 45*100 + 45 = 4545
                                    ; Third iteration: r4 = 4545*100 + 45 = 454545
    
    ADD r0, r0, r4                  ; Add current term to running total
    
    ADD r3, r3, #1                  ; Increment counter
    B loop                          ; Continue loop
	
; Infinite loop at end of program	
stop B stop                         ; Program complete, loop indefinitely
    ENDP
    END

; Register contents for input (45,3):
; ------------------------------------
; r0 = Running total (Final value: 459135)
; r1 = Input value a (45)
; r2 = Input value n (3)
; r3 = Loop counter (0 to 2)
; r4 = Current term being calculated
; r5 = Multiplication factor (100 for input 45)
; r6 = Temporary for digit counting
; r7 = Constant value 10
;
; Series generated: 45 + 4545 + 454545 = 459135