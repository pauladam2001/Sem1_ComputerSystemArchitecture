bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)

segment data use32 class=data   ; a - byte, b - word, c - double word, d - qword  - Unsigned representation
    a db 245
    b dw 110
    c dd 230
    d dq 800

; our code starts here
segment code use32 class=code
    start:   ; d+c-b+(a-c)
        mov AL, [a]
        mov AH, 0 ;unsigned conversion from al to ax
        mov DX, 0 ;unsigned conversion from ax to dx:ax
        mov BX, word[c+2]  ; BX:CX = c                  ;push DX
        mov CX, word[c]                                 ;push AX                ;<- ANOTHER WAY
        sub AX, CX                                      ;pop EBX
        sbb DX, BX ; DX:AX = (a-c)                      ;add EBX, dword[c]  ; EBX = (a-c)
        push DX
        push AX
        pop EBX ; EBX = (a-c)
        
        mov ECX, dword[c]
        mov AX, [b]
        mov DX, 0 ;AX -> DX:AX
        push DX
        push AX
        pop EDX
        sub ECX, EDX ; EDX = c-b
        
        add EBX, ECX ; EBX = c-b+(a-c)
        
        mov EAX, EBX ; EAX = c-b+(a-c)
        mov EDX, 0 ; EAX -> EDX:EAX
        add EAX, dword[d]
        adc EDX, dword[d+4] ; EDX:EAX = d+c-b+(a-c) 
        
       
        
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
