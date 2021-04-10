bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)

; Given an array A of doublewords, build two arrays of bytes:  
; - array B1 contains as elements the higher part of the higher words from A
; - array B2 contains as elements the lower part of the lower words from A

segment data use32 class=data
    A dd 512, 1010, 2010, 789
    lengthA equ $-A ; compute the length of the string A
    B1 times lengthA db 0 ; reserve lengthA bytes for B1 and initialize it
    B2 times lengthA db 0 ; reserve lengthA bytes for B1 and initialize it

; our code starts here
segment code use32 class=code
    start:
        mov ESI, A ; in DS:ESI we will store the FAR address of the string A
        mov EDI, B2 ; in ES:EDI we will store the FAR address of the string B2
        mov EBX, 0 ; we will parse string B1 also
        mov ECX, lengthA ; we will parse the elements of the string in a loop with lengthA iterations
        jecxz Final
        
        my_Loop:
                lodsd ; the double word from the address DS:ESI (A) is loaded in EAX
                push EAX
                mov EAX, 0 ; clean EAX because we will pop into AX
                pop DX ; the high word of EAX
                pop AX ; the low word of EAX
                
                mov [B1 + EBX], DH ; we put in the current position of B1 the higher part of the higher word
                stosb ; store AL (the lower part of the lower word) into the byte from the address ES:EDI (B2)
                
                inc EBX
                
        loop my_Loop
        
        
        Final:
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
