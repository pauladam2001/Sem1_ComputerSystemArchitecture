bits 32 ; assembling for the 32 bits architecture

; Se da in segmentul de date numele unui fisier text (care contine litere, cifre si alte caractere). Sa se determine si sa se afiseze cifra cu valoarea cea mai mica din fisier.
; The name of a text file (that contains letters, digits and other characters) is given in the data segment. Find and print the smallest digit from the file.

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, fopen, fclose, fread, printf               
import exit msvcrt.dll  
import fopen msvcrt.dll  
import fclose msvcrt.dll 
import fread msvcrt.dll 
import printf msvcrt.dll 

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    file_name db "File1.txt", 0
    access_mode db "r", 0
    file_desc dd -1
    len equ 100
    text times len db 0
    minim db 10
    format db "%u", 0
    printing_message db "The smallest digit from the file is: ", 0
    text_length dd 0
    

; our code starts here
segment code use32 class=code
    start:
        push dword access_mode
        push dword file_name        ; opening the file
        call [fopen]
        add ESP, 4*2                ; clean-up the stack
        
        mov [file_desc], EAX
        cmp EAX, 0                  ; check if the file was open correctly
        je Final
        
        read_the_file:
                    push dword [file_desc]
                    push dword len
                    push dword 1                ; read maximum 100 characters from the file
                    push dword text
                    call [fread]
                    add ESP, 4*4                ; clean-up the stack
                    
                    mov [text_length], EAX
                    
                    cmp EAX, 0                  ; checking if there still are characters to read from the file
                    je done
                    
                    mov EBX, 0
                    parse_string:
                                mov AL, byte [text + EBX]       ; AL = the byte from position [text + EBX]
                                inc EBX
                                
                                cmp AL, '0'         ; compare AL with 0 
                                jb not_digit
                                
                                cmp AL, '9'         ; compare AL with 9
                                ja not_digit
                                
                                sub AL, 30h         ; here if it is a digit; substract the ASCII code of 0 to have the number instead of a string
                                cmp AL, [minim]     ; compare to the minimum digit until now
                                jb change_min
                                jmp not_digit
                                
                                change_min:
                                        mov byte [minim], AL    ; changing the minimum
                                                               
                                not_digit:
                                    cmp EBX, [text_length]      ; checking if we parsed the string
                                    jne parse_string
                    
                    jmp read_the_file
                    
                    
        done:
        
        push dword printing_message         ; printing a message
        call [printf]
        add ESP, 4                          ; clean-up the stack
        
        mov EAX, 0
        mov AL, [minim]                     ; converting minim (which is defined as a byte) into a doubleword (in EAX) so that we can push it to the stack
        
        push EAX
        push dword format                   ; priting the smallest digit from the file
        call [printf]
        add ESP, 4*2                        ; clean-up the stack
        
        push dword [file_desc]              ; closing the file
        call [fclose]
        add ESP, 4                          ; clean-up the stack
        
        
        Final:
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
