bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, fopen, fclose               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
                          
extern function
                          
import fopen msvcrt.dll
import fclose msvcrt.dll

;Se citeste din fisier un sir de numere. Sa se scrie sirul de numere in baza doi intr-un alt fisier.

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    file_name1 db "File1.txt", 0
    file_name2 db "File2.txt", 0
    acces_mode1 db "r", 0
    acces_mode2 db "a", 0
    file_descriptor1 dd -1
    file_descriptor2 dd -1
    stringWithNumbersInBase2 times 100 db 0

; our code starts here
segment code use32 class=code
    start:
        push dword acces_mode1
        push dword file_name1
        call [fopen]              ;open the file from where we read the numbers
        add ESP, 4*2
        mov [file_descriptor1], EAX
        
        push dword acces_mode2
        push dword file_name2
        call [fopen]              ;open the file where we will write the numbers in base 2
        add ESP, 4*2
        mov [file_descriptor2], EAX
        
        cmp EAX, 0      ;check if the files were open correctly
        je Final
        
        
        push dword [file_descriptor1]
        push dword [file_descriptor2]
        push dword stringWithNumbersInBase2
        call function           ;input: the 2 file descriptors and the string where we will form the numbers in base 2, output:-
        add ESP, 4*3
        
        
        push dword [file_descriptor1]
        call [fclose]                       ;close file1
        add ESP, 4
        
        push dword [file_descriptor2]
        call [fclose]                       ;close file2
        add ESP, 4
                    
        Final:
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
