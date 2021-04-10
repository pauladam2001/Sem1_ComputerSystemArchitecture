bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, fopen, fclose, fprintf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
                          
import fopen msvcrt.dll
import fclose msvcrt.dll
import fprintf msvcrt.dll

;A file name and a text (defined in the data segment) are given. The text contains lowercase letters, uppercase letters, digits and special characters. Transform all the uppercase letters from the given text in lowercase. Create a file with the given name and write the generated text to file.
                          
; our data is declared here (the variables needed by our program)
segment data use32 class=data
        file_name db "File1.txt", 0
        acces_mode db "w", 0
        file_descriptor dd -1
        text db "aM!faCut Excercitiul asta peNtrU cA m-AM simtit prost cand am vazUt-O PE DariA cat LucreAza. 24324A3242", 0
        len equ $-text
        typee db "%s", 0

; our code starts here
segment code use32 class=code
    start:
        mov ESI, text
        cld
        mov ECX, len
        jecxz Final
        
        my_loop:
                lodsb
                cmp AL, 65
                jb not_upper_letter
                cmp AL, 90
                ja not_upper_letter
                
                add AL, 'a'-'A'
                mov byte [ESI - 1], AL

                not_upper_letter:
                
        loop my_loop
        
        push dword acces_mode
        push dword file_name
        call [fopen]
        add ESP, 4*2
        
        mov [file_descriptor], EAX
        
        cmp EAX, 0
        je Final
        
        push dword text
        push dword typee
        push dword [file_descriptor]
        call [fprintf]
        add ESP, 4*3
        
        push dword [file_descriptor]
        call [fclose]
        add ESP, 4
        
        
        Final:
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
