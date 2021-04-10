bits 32 ; assembling for the 32 bits architecture

;Sa se citeasca de la tastatura cifre pana la intalnirea caracterului '$'. Sa se scrie intr-un fisier numarul cel mai mic posibil format din exact trei cifre pare din cele citite de la tastatura.

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, scanf, fprintf, fopen, fclose, printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import scanf msvcrt.dll
import fprintf msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import printf msvcrt.dll

; our data is declared here (the variables needed by our program)
segment data use32 class=data
        message db "Introduce a digit: ", 10, 13, 0
        file_name db "File1.txt", 0
        access_mode db "a", 0
        format db "%c", 0
        file_desc dd -1
        array_of_digits times 100 db 0
        length_of_array db 0
        digit db 0
        counter db 0
        

; our code starts here
segment code use32 class=code
    start:
        
        mov ESI, array_of_digits
        read_digits:
                    push dword message
                    call [printf]
                    add ESP, 4
        
                    push dword digit
                    push dword format
                    call [scanf]
                    add ESP, 4*2
                    
                    cmp byte [digit], '$'
                    je done
                    
                    
                    mov AL, [digit]
                    ;mov byte [array_of_digits + length_of_array], AL
                    mov byte [ESI], AL
                    inc ESI
                    add byte [length_of_array], 1
                    
                    mov byte [digit], 0
                    
                    push dword digit
                    push dword format   ;nu stiu ce are scanf-ul
                    call [scanf]
                    
                    jmp read_digits
        
        done:
        
        mov DX, 1
        whilee:
                cmp DX, 0
                je endd
                mov ESI, array_of_digits
                mov DX, 0
                mov ECX, 0
                mov CL, [length_of_array]
                sub ECX, 1
                cld
                repeatt:
                        mov AL, byte [ESI]
                        cmp AL, byte [ESI + 1]
                        jbe next
                        
                        mov BL, byte [ESI + 1]
                        mov byte [ESI], BL
                        mov byte [ESI + 1], AL
                        mov DX, 1
                        
                        next:
                            add ESI, 1
                            loop repeatt
                            
                            cmp byte [ESI], 0
                            je endd
                            
                            jmp whilee
                        
        endd:
        
        push dword access_mode
        push dword file_name
        call [fopen]
        add ESP, 4*2
        
        mov [file_desc], EAX
        cmp EAX, 0
        je Final
        
        mov EBX, 0
        print_3_even_digits:
                        test byte [array_of_digits + EBX], 01h
                        jp printing
                        jmp nextt
                        
                        printing:
                                add byte [counter], 1
                                push dword [array_of_digits + EBX]
                                push dword format
                                push dword [file_desc]
                                call [fprintf]
                                add ESP, 4*3
                                
                        nextt:
                            add EBX, 1
                        
                        cmp byte [counter], 3
                        jb print_3_even_digits
    
        push dword [file_desc]
        call [fclose]
        add ESP, 4
    
        Final:
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
