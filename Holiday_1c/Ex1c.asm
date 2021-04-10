bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, fopen, fclose, fscanf, fprintf                ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
                          
import fopen msvcrt.dll
import fclose msvcrt.dll
import fscanf msvcrt.dll
import fprintf msvcrt.dll

;Se citeste din fisier un sir de numere. Sa se scrie sirul de numere in baza doi intr-un alt fisier.

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    file_name1 db "File1.txt", 0
    file_name2 db "File2.txt", 0
    acces_mode1 db "r", 0
    acces_mode2 db "a", 0
    file_descriptor1 dd -1
    file_descriptor2 dd -1
    numberToRead dd 0
    number_type db "%u", 0
    char_space db "%c", 0
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
        
        readNumbers:
                    push dword numberToRead
                    push dword number_type
                    push dword [file_descriptor1]
                    call [fscanf]                   ;read a number from the file
                    add ESP, 4*3
                    
                    cmp EAX, -1         ;check if there are numbers in the file
                    je outOfLoop
                    
                    mov EDX, 0
                    mov EAX, [numberToRead]
                    
                    mov EBX, 2
                    mov EDI, 0
                    formBase2:
                            div EBX ; EAX = EDX:EAX/2, EDX = EDX:EAX%2
                            mov [stringWithNumbersInBase2 + EDI], EDX
                            add EDI, 1 ; the rest will be 0 or 1, a byte        ;form the number in base 2
                            mov EDX, 0
                            
                            cmp EAX, 0
                            jne formBase2
                    sub EDI, 1
                    printString:
                              mov EAX, 0
                              mov AL, [stringWithNumbersInBase2 + EDI]
                              push EAX
                              push dword number_type                            ;print the numbers in base 2 (in reverse order is the correct order)
                              push dword [file_descriptor2]
                              call [fprintf]
                              add ESP, 4*3
                              dec EDI
                              cmp EDI, 0
                              jge printString
                    
                    push dword " "
                    push dword char_space
                    push dword [file_descriptor2]       ;print a space between numbers
                    call [fprintf]
                    add ESP, 4*3
                    
                    
                    mov EDX, 0
                    mov ECX, 25
                    clearTheWords:
                            mov dword [stringWithNumbersInBase2 + EDX], 0       ;clear the variable where we store the number
                            add EDX, 4
                        loop clearTheWords
                    
            jmp readNumbers
            
        outOfLoop:
        
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
