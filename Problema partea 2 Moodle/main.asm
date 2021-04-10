bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

extern function
; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
                          
; A string of doublewords is given. Write a program in assembly language which builds 2 strings as follows:
; i) A string of bytes sir2 taking from each doubleword the higher byte of the lower word and if this one is strictly negative it will be put in the destination string. In the end, the elements of sir2 will be printed in base 2.
;           Ex.: sir1 dd 1245AB36h, 23456789h, 1212F1EEh
;           The string of the higher bytes of the lower words will be ABh, 67h, F1h. From these, only ABh and F1h are strictly negative, so sir2 db Abh, F1h and on the screen 1010 1011 1111 0001 will be printed.
; ii) The string sir3 representing the string there will be printed on the screen when printing the elements of sir2 in base is required.
;           Ex.: for the above sir2 we will have sir3 db "-85", "-15"

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    sir1 dd 1245AB36h, 23456789h, 1212F1EEh
    len equ ($ - sir1)/4
    sir2 times 100 db 0
    sir3 times 100 db 0
    ;tabel db "-127", "-126", "-125", "-124", "-123", "-122" etc. ... ; xlat pentru ii) ???

; our code starts here
segment code use32 class=code
    start:
        push dword len
        push dword sir1
        push dword sir2
        push dword sir3
        call function
        add ESP, 4*4
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
