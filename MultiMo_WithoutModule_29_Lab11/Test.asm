bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, printf, scanf, gets               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import printf msvcrt.dll
import scanf msvcrt.dll
import gets msvcrt.dll


; Read a sentence from the keyboard. For each word, obtain a new one by taking the letters in reverse order and print each new word. 


; our data is declared here (the variables needed by our program)
segment data use32 class=data
    format_string db "Introduce the sentence: ", 0
    format db "%s", 0
    format2 db "%s", 10 ,13, 0       ; 10, 13 means a new line
    given_sentence times 100 db 0    ; here we will store the sentence that we read
    new_word times 100 db 0          ; here we will form the mirrored word

; our code starts here
segment code use32 class=code
    start:
        push dword format_string
        call [printf]               ; print the message
        add ESP, 4                  ; clear the stack
        
        push dword given_sentence
        call [gets]                    ; we use gets instead of scanf in order to read the sentence because scanf stops at the first space
        add ESP, 4*1                   ;clear the stack

        
        mov ESI, 0
        mov EDI, 0
        
        ParseTheString:  ; the big loop (it stops when the sentence is parsed)
        
            FindLength:  ; with this repeat we find how long the word is (we stop when we find a space or 0 (for the last word))
                    cmp byte [given_sentence + EDI] , 20h ; 20h = ASCII of space
                    je OutOfRepeat
                    cmp byte [given_sentence + EDI] , 0 ; 0 for last word
                    je OutOfRepeat
                    
                    inc EDI         ; if the character is not a space, then we continue
                    jmp FindLength
            
            OutOfRepeat:
            
            mov EBX, 0
            mov ECX, 100
            ClearTheNewWord: ; with this loop we clear the word where we will form the mirrored word of the actual one
                            mov byte [new_word + EBX], 0
                            inc EBX
            loop ClearTheNewWord
            
            mov EBX, EDI
            sub EBX, ESI
            mov ECX, EBX  ; we put in ECX the length of the word without modifying ESI and EDI
            
            mov EBX, EDI ; we need to keep EDI
            
            dec EDI ;the character before the space
            mov EDX, 0 ; with edx we parse the new_word
            
            Mirror: ; with this loop we form the mirrored word
                   mov AL, [given_sentence + EDI]
                   mov [new_word + EDX], AL
                   inc EDX
                   dec EDI
            loop Mirror
            
            push dword new_word
            push dword format2  ; we print the word that we obtained
            call [printf]
            add ESP, 4*2
            
            mov EDI, EBX
            cmp byte [given_sentence + EDI], 0 ; we check if we have parsed the whole sentence
            je finish
            
            mov ESI, EDI
            inc ESI ; next word, after space ; if we are not at the end of the sentence we continue searching words
            add EDI, 1
            jmp ParseTheString
            
        finish:
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
