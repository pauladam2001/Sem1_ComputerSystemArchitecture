bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, fopen, fclose, fread, scanf, fprintf , printf              ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
                          
extern function
                          
import fopen msvcrt.dll
import fclose msvcrt.dll
import scanf msvcrt.dll
import fprintf msvcrt.dll
import fread msvcrt.dll
import printf msvcrt.dll

;Se citeste un text din fisier si un character de la tastatura. Calculati numarul de aparitii al caracterului citit in textul dat si inlocuiti-l cu X, scriind rezultatul in alt fisier output.txt

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    file_name1 db "File1.txt", 0
    file_name2 db "output.txt", 0
    acces_mode1 db "r", 0
    acces_mode2 db "w", 0
    file_descriptor1 dd -1
    file_descriptor2 dd -1
    len equ 100
    text times len db 0
    format_char db "Introduce the character: ", 0
    format_char_2 db "%c", 0
    format_output db "The given character appears %u times. The new text is: %s", 0
    char db 0
    nrOfChar db 0
    

; our code starts here
segment code use32 class=code
    start:
        push dword acces_mode1
        push dword file_name1
        call [fopen]                ;open the file from where we read the text
        add ESP, 4*2
        mov [file_descriptor1], EAX
        
        cmp EAX, 0              ;check if the files were open correctly
        je Final
        
        push dword acces_mode2
        push dword file_name2
        call [fopen]                ;open the file where we will write the number of appearences and the new text
        add ESP, 4*2
        mov [file_descriptor2], EAX
            
        cmp EAX, 0              ;check if the files were open correctly
        je Final
        
        push dword [file_descriptor1]
        push dword len
        push dword 1                    ;read the text from the file
        push dword text
        call [fread]
        add ESP, 4*4
        
        push dword format_char
        call [printf]               
        add ESP, 4                  
        
        push dword char
        push dword format_char_2        ;read the character
        call [scanf]                    
        add ESP, 4*2                   
        
        push dword char
        push dword text
        push dword nrOfChar
        call function        ;input: the read character, the text and the variable where we will store the number of appearences, output:the new text and the nrOfChar
        add ESP, 4*3
        
        
        mov EAX, 0
        mov AL, [nrOfChar]
        
        push dword text
        push EAX    ;nrOfChar
        push dword format_output            ;print in the file the number of appearences and the new text
        push dword [file_descriptor2]
        call [fprintf]
        add ESP, 4*4
        
        push dword [file_descriptor1]
        call [fclose]                       ;close the files
        add ESP, 4
        
        push dword [file_descriptor2]
        call [fclose]                       ;close the files
        add ESP, 4
        
        Final:
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
