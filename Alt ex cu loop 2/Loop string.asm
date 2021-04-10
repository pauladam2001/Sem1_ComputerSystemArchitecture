bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data ; sirul 1,2,3,4 in 1,1,2,2,3,3,4,4
    S db 1,2,3,4
    l equ $-S
    D times l*2 db 0
    

; our code starts here
segment code use32 class=code
    start:
            mov ECX, l
            jecxz Final
            mov ESI, 0
            mov EBX, 0
            
            my_Loop:
                    mov AL, [S+ESI]
                    
                    mov [D+EBX], AL
                    inc EBX
                    mov [D+EBX], AL
                    inc EBX
                    
                    inc ESI
                    
            loop my_Loop
            
            Final:
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
