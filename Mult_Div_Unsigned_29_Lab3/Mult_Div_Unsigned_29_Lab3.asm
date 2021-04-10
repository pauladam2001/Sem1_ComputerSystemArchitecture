bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)

segment data use32 class=data   ; a, b, c - byte, d - doubleword, x - qword - Unsigned representation
    a db 150
    b db 100
    c db 9
    d dd 20
    x dq 8

; our code starts here
segment code use32 class=code
    start:  ; (a+b)/(c-2)-d+2-x
        mov AL, [a]
        add AL, [b] ; AL = (a+b)
        mov AH, 0 ; AL -> AX
        
        mov CL, [c]
        sub CL, 2  ; CL = (c-2)
        
        div CL ; AL = AX/CL, AH = AX%CL ; AL = (a+b)/(c-2)
        
        mov AH, 0 ; AL -> AX
        mov DX, 0 ; AX -> DX:AX
        sub AX, word[d]
        sbb DX, word[d+2] ; DX:AX = (a+b)/(c-2)-d
        
        push DX
        push AX
        pop EAX ; EAX = DX:AX
        add EAX, 2 ; EAX = (a+b)/(c-2)-d+2
        
        mov EDX, 0 ; EAX -> EDX:EAX
        sub EAX, dword[x]
        sbb EDX, dword[x+4] ; (a+b)/(c-2)-d+2-x
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
