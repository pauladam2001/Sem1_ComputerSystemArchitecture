bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

extern function
; declare external functions needed by our program
extern exit, scanf, printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import scanf msvcrt.dll
import printf msvcrt.dll
                          
; Write a program that reads a doubleword N from keyboard and then it reads N dwords ([0, 65535]) form keyboard. Then it will build a new string of bytes which contains for each doubleword from the first string the sum of the even digits.
;               Ex.: N=4, 214, 68, 91, 123 => the new string: 6, 14, 0, 2

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    sir times 100 dd 0
    N dd 0
    number dd 0
    format db "%u", 0
    message db "N=", 0

; our code starts here
segment code use32 class=code
    start:
        push dword message
        call [printf]
        add ESP, 4
        
        push dword N
        push dword format
        call [scanf]
        add ESP, 4*2
        
        mov ECX, [N]
        jecxz final
        
        mov EDI, sir
        read_numbers:
                    pushad
                    push dword number
                    push dword format
                    call [scanf]
                    add ESP, 4*2
                    popad
                    
                    mov EAX, [number]
                    stosd
                    
            loop read_numbers
    
        push dword [N]
        push dword sir
        call function
        add ESP, 4*2
    
        final:
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
