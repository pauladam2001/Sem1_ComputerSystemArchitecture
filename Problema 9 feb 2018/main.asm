bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

extern function
; declare external functions needed by our program
extern exit, printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import printf msvcrt.dll

; A string of quadwords is defined in the data segment. The degree of an element is defined as being the number of "111" distinct sequences from its binary representation (ex.: 111111b has the degree 2). It is required to build as a result a string which will contain the inferior doublewords that have the degree at least 2 from each qword. Print on the screen in base 2 the elements of the resulted string. Explain and justify the algorithm and its implementation and comment accordingly the source code.
; Example: If the given string is sir dq 1110111b, 100000000h, 0ABCD0002E7FCh, 5
;          The resulted string is rez dd 1110111b, 0002E7FCh
;          On the screen will be printed 1110111 101110011111111100

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    sir dq 1110111b, 100000000h, 0ABCD0002E7FCh, 5
    ;sir dq 1110111b
    len equ ($ - sir)/8
    rez times len dd 0
    

; our code starts here
segment code use32 class=code
    start:
        push dword len
        push dword rez
        push dword sir
        call function
        add ESP, 4*3
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
