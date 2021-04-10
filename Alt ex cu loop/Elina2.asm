bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data ; A byte string S is given. Obtain in the string D the set of the elements of S.
                              ; S: 1, 4, 2, 4, 8, 2, 1, 1  ;  D: 1, 4, 2, 8

        S db 1, 4, 2, 4, 8, 2, 1, 1
        l equ $-S ; compute the length of the string in l
        D times l db 0 ; reserve l bytes for the destination string and initialize it

; our code starts here
segment code use32 class=code
    start:
        
        mov ECX, l ; we put the length l in ECX in order to make the loop for S
        mov ESI, 0 ; the index for MyS_Loop
        jecxz Final ; Jump to Final if ECX register is 0
        
        MyS_Loop:                
                mov AL, [S + ESI]           
                
                mov EDX, ECX ; to know where we are in MyS_Loop after we finish with MyD_Loop
                
                mov ECX, ESI ; the actual length of D
                mov EBX, 0 ; the index for MyD_Loop
                jecxz First_Element ; Jump to First_Element if ECX register is 0
                
                MyD_Loop:
                        cmp AL, byte[D + EBX] ; verify if the element already exists in D
                        je Already_In_D
                        
                        inc EBX
                        
                loop MyD_Loop
                
                First_Element: ; first element will always be appended to D
                
                mov ECX, EDX ; to know where we are in MyS_Loop after we finished with MyD_Loop
                mov [D + ESI], AL ; the current position of D = AL //??? we don't need the current position, but the first free position, how???
                
                Already_In_D: ; if the element is already in D we don't append it to D
                mov ECX, EDX ; to know where we are in MyS_Loop after we finished with MyD_Loop 

                inc ESI
                
        loop MyS_Loop
        
        Final:
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
