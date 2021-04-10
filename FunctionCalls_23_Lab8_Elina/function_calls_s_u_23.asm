bits 32
global start        


extern exit, printf, scanf                   
import exit msvcrt.dll    
import printf msvcrt.dll
import scanf msvcrt.dll

                          
segment data use32 class=data

    n dd 0
    input_message db "n=",0
    input_formator db "%x",0
    output_message db "The signed representation of n is %d",10,0
    output_second_message db "The unsigned representation of n is %u", 0
    
segment code use32 class code

start:
        ;Read a hexadecimal number with 2 digits from the keyboard. Display the number in base 10, in both interpretations: as an unsigned number and as an signed number (on 8 bits).
        
        push dword input_message        ;printf(input_message)
        call[printf]    
        add esp, 4*1                    ; clean-up the stack
        
        push dword n                    ;scanf(input_format,n)
        push dword input_formator
        call[scanf]
        add esp, 4*2                    ; clean-up the stack
        
        mov AL, byte[n]     ; we need to extract only 8 bits from the doubleword n 
        cbw 
        cwde                ; we need to convert AL to EAX because 'push' on stack 
                            ; works only with values on 32 bits
        
        push dword EAX                  ;printf(output_message,n)
        push dword output_message
        call[printf]
        add esp, 4*2                    ; clean-up the stack
        
        push dword [n]                  ;printf(output_message,n)
        push dword output_second_message
        call[printf]
        add esp, 4*2                    ; clean-up the stack

        ; exit(0)
        push dword 0      ; push on stack the parameter for exit
        call [exit]       ; call exit to terminate the programme