bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, fopen, fclose, fread, scanf, printf              ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
                          
extern function
                          
import fopen msvcrt.dll
import fclose msvcrt.dll
import scanf msvcrt.dll
import fread msvcrt.dll
import printf msvcrt.dll

;Se citeste un text din fisier. Calculati numarul de cuvinte din fisier.

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    file_name1 db "File1.txt", 0
    acces_mode1 db "r", 0
    file_descriptor1 dd -1
    len equ 100
    text times len db 0
    char db 0
    nrOfWords db 0
    format db "%u", 0
    

; our code starts here
segment code use32 class=code
    start:
        push dword acces_mode1
        push dword file_name1
        call [fopen]                    ;open the file from where we read the text
        add ESP, 4*2
        mov [file_descriptor1], EAX
        
        cmp EAX, 0              ;check if the file was open correctly
        je Final
        
        read_all_words:
                push dword [file_descriptor1]
                push dword len
                push dword 1                ;read the text from the file
                push dword text
                call [fread]
                add ESP, 4*4
                
                cmp EAX, 0
                je done
        
                push dword text
                push dword nrOfWords
                call function           ;input: the text and the variable where we will store the number of words, output:the number of words
                add ESP, 4*2
                
                jmp read_all_words
        
        done:
        
        mov EAX, 0
        mov AL, [nrOfWords]
        
        push EAX ;nrOfWords
        push dword format       ;print the number of words
        call [printf]
        add ESP, 4*2
        
        push dword [file_descriptor1]
        call [fclose]                   ;close the file
        add ESP, 4  
        
        Final:
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program