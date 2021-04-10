bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)

segment data use32 class=data   ; a - byte, b - word, c - double word, d - qword  - Signed representation
    a db 125
    b dw 110
    c dd 230
    d dq 800

; our code starts here
segment code use32 class=code
    start:  ; (a+a)-(b+b)-(c+d)+(d+d)
        mov AL, [a]
        add AL, [a] ; AL = a+a
        
        mov BX, [b]
        add BX, [b] ; BX = b+b
        
        cbw ; AL -> AX
        sub AX, BX ; AX = (a+a)-(b+b) 
        mov BX, AX ; BX = (a+a)-(b+b)
        
        mov EAX, [c]
        cdq
        add EAX, dword[d]
        adc EDX, dword[d+4] ; EDX:EAX = c+d
        
        mov ECX, EDX
        mov DX, BX ; DX = (a+a)-(b+b)
        mov EBX, EAX ; ECX:EBX = EDX:EAX = c+d
        
        mov AX, DX ; AX = (a+a)-(b+b)
        cwde
        cdq ; EDX:EAX = AX = (a+a)-(b+b)
        
        sub EAX, EBX
        sbb EDX, ECX ; EDX:EAX = (a+a)-(b+b)-(c+d)
        
        add EAX, dword[d]
        adc EDX, dword[d+4]
        
        add EAX, dword[d]
        adc EDX, dword[d+4] ; EDX:EAX = (a+a)-(b+b)-(c+d)+(d+d)
        
        
        
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
