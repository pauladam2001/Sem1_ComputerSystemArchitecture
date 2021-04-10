; Read a sentence from the keyboard. For each word, obtain a new one by taking the letters in reverse order and print each new word. 
; procedura factorial este definita in fisierul MMCfactorial.asm
bits  32
global  start

extern  printf, exit, gets
import  printf msvcrt.dll
import  exit msvcrt.dll
import  gets msvcrt.dll

extern  MMmirror

; Read a sentence from the keyboard. For each word, obtain a new one by taking the letters in reverse order and print each new word. 

segment  data use32 class=data
    format_string db "Introduce the sentence: ", 0
    format db "%s", 0
    format2 db "%s", 10 ,13, 0       ; 10, 13 means a new line
    given_sentence times 100 db 0    ; here we will store the sentence that we read
    new_word times 100 db 0          ; here we will form the mirrored word

    
segment  code use32 class=code
    start:
        push dword format_string
        call [printf]               ; print the message
        add ESP, 4                  ; clear the stack
        
        push dword given_sentence
        call [gets]                    ; we use gets instead of scanf in order to read the sentence because scanf stops at the first space
        add ESP, 4*1                   ;clear the stack
    
        push dword given_sentence
        push dword new_word
        call MMmirror         ; call the function with the parameters given_sentence and new_word (no return)
        
        push 0
        call [exit]