bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data ; A byte string S is given. Build the string D whose elements represent the sum of each two consecutive bytes of S.
                              ; S: 1, 2, 3, 4, 5, 6    ;      D: 3, 5, 7, 9, 11

       S db 1, 2, 3, 4, 5, 6
       l equ $-S ; compute the length of the string in l
       D times l-1 db 0 ; reserve l-1 bytes for the destination string and initialize it  # D will always have len(S)-1

; our code starts here
segment code use32 class=code
    start:
        
        mov ECX, l - 1 ; we put the length l-1 in ECX in order to make the loop
        mov ESI, 0
        jecxz Final ; Jump to Final if ECX register is 0
        
        My_Loop:                
                mov AL, [S + ESI]
                add AL, [S + ESI + 1] ; AL = the sum of two consecutive bytes of S
                
                mov [D + ESI], AL ; the current position of D = AL
                
                inc ESI
                
        loop My_Loop
        
        Final:
      
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
