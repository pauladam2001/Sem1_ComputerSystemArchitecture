bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
     a DB 6
     b DB 8
     c DB 3
     d DB 2
     e DW 1
     x DQ 12

; our code starts here
segment code use32 class=code ; (a*b-2*c*d)/(c-e)+x/a
    start:
    
        mov AL, byte [a] ; AL <- a
        mul byte [b] ; AX <- AL*b   ; AX = a*b
        
        mov BX, AX ; BX <- AX = a*b
        
        mov AL, [c]
        mul byte [d]  ; AX = c*d
        
        mov CL, 2
        mov CH, 0 ; CX = 2
         
        mul CX ; DX:AX = AX*CX = c*d*2
        
        push DX
        push AX
        pop EDX ; EDX = c*d*2
        
        mov AX, BX ; AX = a*b
        mov EBX, 0
        mov BX, AX ; EBX = a*b
     
        sub EBX, EDX ; EBX = (a*b-2*c*d)
        
        mov CL, [c]
        mov CH, 0 ; CX = c
        
        sub CX, word [e] ; CX = c-e
        
        push EBX
        pop AX
        pop DX  ; DX:AX = EBX
        
        div CX ; AX = DX:AX/CX = (a*b-2*c*d)/(c-e)
        
        mov BX, AX ; BX = (a*b-2*c*d)/(c-e)
        
        mov CL, [a]
        mov CH, 0 ; CX = a
        
        mov AX, CX
        mov ECX, 0
        mov CX, AX ; ECX = a
        
        mov EAX, dword [x]
        mov EDX, dword [x+4] ; EDX:EAX = x
        
        div ECX ; EAX = EDX:EAX/ECX = x/a
        
        mov CX, BX ; CX = (a*b-2*c*d)/(c-e)
        mov EBX, 0
        mov BX, CX ; EBX = (a*b-2*c*d)/(c-e)
        
        add EBX, EAX ; EBX = (a*b-2*c*d)/(c-e)+x/a
                    
         
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
