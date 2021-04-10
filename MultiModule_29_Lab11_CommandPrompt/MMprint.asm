bits 32                         
segment code use32 public code
global MMprint

extern printf
import printf msvcrt.dll


segment data public data use32
    format2 db "%s", 10 ,13, 0 

MMprint:
        push dword EBX
        push dword format2  ; we print the word that we obtained
        call [printf]
        add ESP, 4*2
    ret