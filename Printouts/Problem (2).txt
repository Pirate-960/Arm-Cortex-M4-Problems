	INCLUDE core_cm4_constants.s        ; Include Cortex-M4 constants
    INCLUDE stm32l476xx_constants.s   ; Include STM32L476 specific constants
		
;==================================================================
; DATA SECTION
;==================================================================
    AREA myData, DATA, READWRITE    

; Memory Layout of 3x3 Matrix (36 bytes total):
; Word Address:  +0   +4   +8   +12  +16  +20  +24  +28  +32
; Matrix Data:   [1]  [2]  [3]  [1]  [2]  [3]  [1]  [2]  [3]
; Matrix View:   Row0[1   2   3]
;                Row1[1   2   3]
;                Row2[1   2   3]
Matrix DCD 1,2,3,1,2,3,1,2,3         ; Source matrix in row-major order

; Reserved memory for result (36 bytes):
; Will store the matrix after column swap
; Expected result for swapping cols 1&2:
; [1   3   2]
; [1   3   2]
; [1   3   2]
zMem   SPACE 36                      ; Destination matrix space

;==================================================================
; CODE SECTION
;==================================================================
    AREA P2, CODE 
    EXPORT __main 
    ALIGN 
    ENTRY 

__main PROC 
    ;------------------------------------------------------------------
    ; Initialize Column Indices and Matrix Addresses
    ;------------------------------------------------------------------
    ; Specify which columns to swap (0-based indexing)
    MOV r0, #1                      ; r0 = col1 = 1 (second column)
                                   ; Elements at positions: [0,1], [1,1], [2,1]
    
    MOV r1, #2                      ; r1 = col2 = 2 (third column)
                                   ; Elements at positions: [0,2], [1,2], [2,2]
    
    ; Load base addresses of matrices
    LDR r2, =Matrix                 ; r2 = start address of source matrix
                                   ; Contains original data: 1,2,3,1,2,3,1,2,3
    
    LDR r3, =zMem                   ; r3 = start address of destination matrix
                                   ; Will contain swapped columns
    
    ; Setup initial indices and counters
    MOV r4, r0                      ; r4 = working copy of col1 index
                                   ; Used for address calculations
    
    MOV r5, r1                      ; r5 = working copy of col2 index
                                   ; Used for address calculations
    
    MOV r6, #0                      ; r6 = row counter (i), counts 0 to 2
                                   ; Tracks current row being processed
    
    MOV r8, #3                      ; r8 = matrix width (3 columns)
                                   ; Used for row offset calculations
    
    ;------------------------------------------------------------------
    ; Calculate Remaining Column Index
    ;------------------------------------------------------------------
    ; Find index of column that isn't being swapped
    ADD r11, r0, r1                 ; r11 = sum of swap columns (1 + 2 = 3)
    SUB r11, r8, r11               ; r11 = 3 - 3 = 0 (remaining column index)
                                   ; This is the column that stays in place
    
    ;------------------------------------------------------------------
    ; Main Processing Loop
    ;------------------------------------------------------------------
loop
    ; Check if we've processed all rows
    CMP r6, #3                      ; Compare row counter with matrix height
    BEQ stop                        ; If r6 == 3, all rows processed, exit
    
    ;------------------------------------------------------------------
    ; Calculate Element Addresses for Current Row
    ;------------------------------------------------------------------
    ; Step 1: Calculate row offset
    MOV r7, r6                      ; r7 = current row number
    MUL r7, r7, r8                  ; r7 = row * 3 (offset to start of current row)
                                   ; First iteration: 0 * 3 = 0
                                   ; Second iteration: 1 * 3 = 3
                                   ; Third iteration: 2 * 3 = 6
    
    ; Step 2: Calculate first column element offset
    ADD r4, r7, r0                  ; r4 = (row * 3) + col1
                                   ; First iteration: 0 + 1 = 1
                                   ; Second iteration: 3 + 1 = 4
                                   ; Third iteration: 6 + 1 = 7
    LSL r4, r4, #2                  ; r4 *= 4 (convert to byte offset)
                                   ; Multiply by 4 because each word is 4 bytes
    
    ; Step 3: Calculate second column element offset
    ADD r5, r7, r1                  ; r5 = (row * 3) + col2
    LSL r5, r5, #2                  ; r5 *= 4 (convert to byte offset)
    
    ; Step 4: Calculate remaining column element offset
    ADD r12, r7, r11                ; r12 = (row * 3) + remaining_col
    LSL r12, r12, #2                ; r12 *= 4 (convert to byte offset)
    
    ;------------------------------------------------------------------
    ; Perform Column Swap for Current Row
    ;------------------------------------------------------------------
    ; Load elements from source matrix
    LDR r9, [r2, r4]                ; r9 = element from first column to swap
                                   ; First iteration: value at Matrix[0,1] = 2
    
    LDR r10, [r2, r5]               ; r10 = element from second column to swap
                                   ; First iteration: value at Matrix[0,2] = 3
    
    ; Store swapped elements in destination matrix
    STR r10, [r3, r4]               ; Store second col element in first col position
                                   ; First iteration: zMem[0,1] = 3
    
    STR r9, [r3, r5]                ; Store first col element in second col position
                                   ; First iteration: zMem[0,2] = 2
    
    ; Copy unchanged column element
    LDR r9, [r2, r12]               ; Load element from remaining column
                                   ; First iteration: value at Matrix[0,0] = 1
    
    STR r9, [r3, r12]               ; Store remaining column element
                                   ; First iteration: zMem[0,0] = 1
    
    ; Move to next row
    ADD r6, r6, #1                  ; Increment row counter
    B loop                          ; Continue to next row
    
    ;------------------------------------------------------------------
    ; Program Completion
    ;------------------------------------------------------------------
stop B stop                         ; Infinite loop at program end

    ENDP
    END

;==================================================================
; REGISTER MAP AND USAGE
;==================================================================
; r0  = First column index to swap (constant: 1)
; r1  = Second column index to swap (constant: 2)
; r2  = Source matrix base address (constant)
; r3  = Destination matrix base address (constant)
; r4  = Current first column element byte offset (changes each iteration)
; r5  = Current second column element byte offset (changes each iteration)
; r6  = Row counter (0 to 2)
; r7  = Temporary row offset calculation
; r8  = Number of columns (constant: 3)
; r9  = Temporary element storage for swapping
; r10 = Temporary element storage for swapping
; r11 = Remaining column index (constant: 0)
; r12 = Current remaining column element byte offset (changes each iteration)

;==================================================================
; MEMORY ACCESS PATTERN (First Iteration)
;==================================================================
; Source Matrix (r2):          Destination Matrix (r3):
; Offset  Value   Access       Offset  Value   Access
; +0      1      Read         +0      1      Write
; +4      2      Read         +4      3      Write
; +8      3      Read         +8      2      Write

;==================================================================
; ITERATION BREAKDOWN
;==================================================================
; Iteration 1 (Row 0):
;   - Process elements: [0,0]=1, [0,1]=2, [0,2]=3
;   - Result: [0,0]=1, [0,1]=3, [0,2]=2
;
; Iteration 2 (Row 1):
;   - Process elements: [1,0]=1, [1,1]=2, [1,2]=3
;   - Result: [1,0]=1, [1,1]=3, [1,2]=2
;
; Iteration 3 (Row 2):
;   - Process elements: [2,0]=1, [2,1]=2, [2,2]=3
;   - Result: [2,0]=1, [2,1]=3, [2,2]=2

;==================================================================
; ADDRESS CALCULATION EXAMPLE
;==================================================================
; For element at position [1,1] (row=1, col=1):
; 1. Row offset = row * columns = 1 * 3 = 3
; 2. Element offset = (row offset + col) = (3 + 1) = 4
; 3. Byte offset = element offset * 4 = 4 * 4 = 16
; Therefore, element [1,1] is at byte offset 16 from matrix start