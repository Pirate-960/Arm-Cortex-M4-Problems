    INCLUDE core_cm4_constants.s    
    INCLUDE stm32l476xx_constants.s      

    AREA P3, CODE
    EXPORT __main
    ALIGN
    ENTRY

__main PROC


stop
    B stop                 ; Infinite loop to end program

    ENDP
    END