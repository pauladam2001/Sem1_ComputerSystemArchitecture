bits 32

;Write a program that reads a text file that contains sentences (sentences are separated by '!') and writes in a different file only the sentence of even index (0, 2, ...). The name of the 2 files are given in the data segment.bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, fopen, fclose, fprintf, fread, printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import fopen msvcrt.dll
import fclose msvcrt.dll
import fprintf msvcrt.dll
import printf msvcrt.dll
import fread msvcrt.dll

; our data is declared here (the variables needed by our program)
segment data use32 class=data
        file_name1 db "File1.txt", 0
        file_name2 db "File2.txt", 0
        access_mode1 db "r", 0
        access_mode2 db "a", 0
        file_desc1 dd -1
        file_desc2 dd -1
        len equ 100
        text times len db 0
        counter db 0
        sentence times len db 0
        typee db "%s", 10, 13, 0
    

; our code starts here
segment code use32 class=code
    start:
        push dword access_mode1
        push dword file_name1
        call [fopen]
        add ESP, 4*2
        
        mov [file_desc1], EAX
        cmp EAX, 0
        je Final
        
        push dword access_mode2
        push dword file_name2
        call [fopen]
        add ESP, 4*2
        
        mov [file_desc2], EAX
        cmp EAX, 0
        je Final
        
        read_sentences:
                    push dword [file_desc1]
                    push dword len
                    push dword 1
                    push dword text
                    call [fread]
                    add ESP, 4*4
                    
                    cmp EAX, 0
                    je done
                    
                    ;cmp byte [counter], 0
                    
                    mov ESI, text
                    mov EDI, sentence
                    parse_sentences:
                                    lodsb
                                    cmp AL, '!'
                                    je do_we_print
                                    
                                    stosb
                                    
                                    jmp parse_sentences
                                    
                    do_we_print:
                                test byte [counter], 01h
                                jp printing
                                
                                jmp continue
                                
                                printing:
                                        push dword sentence
                                        push dword typee
                                        push dword [file_desc2]
                                        call [fprintf]
                                        add ESP, 4*3
                    
                    continue:
                            add byte [counter], 1
                            ;inc ESI
                    
                    mov EDX, 0
                    mov ECX, 25
                    clearSentence:
                            mov dword [sentence + EDX], 0
                            add EDX, 4
                    loop clearSentence
                    
                    mov EDI, sentence
                    
                    cmp byte [ESI], 0
                    jne parse_sentences
                    
                    
                    jmp read_sentences
        
        done:
        
        push dword [file_desc1]
        call [fclose]
        add ESP, 4
        
        push dword [file_desc2]
        call [fclose]
        add ESP, 4
                    
        Final:
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
