bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, printf, scanf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import printf msvcrt.dll
import scanf msvcrt.dll

; our data is declared here (the variables needed by our program)

;Read three numbers a, m and n (a: word, 0 <= m, n <= 15, m > n) from the keyboard. Isolate the bits m-n of a and display the integer represented by those bits in base 16

segment data use32 class=data  
    
    a dd 0 ; a word
    m dd 0 ; m byte
    n dd 0 ; n byte
    message1 db "a=", 0
    message2 db "m=", 0
    message3 db "n=", 0
    format db "%d", 0
    format2 db "The number represented by the isolated bits in base 16 is %x", 0

; our code starts here
segment code use32 class=code
    start:                      ;SAU puteam sa le citim pe toate deodata cu scanf dar nu mai puteam sa afisam a=, m=, n=
        
        push dword message1
        call [printf]
        add ESP, 4*1
                                        ; reading number a from keyboard
        push dword a
        push dword format
        call [scanf]
        add ESP, 4*2
        
        
        push dword message2
        call [printf]
        add ESP, 4*1
                                        ; reading number m from keyboard
        push dword m
        push dword format
        call [scanf]
        add ESP, 4*2
        
        
        push dword message3
        call [printf]
        add ESP, 4*1
                                        ; reading number n from keyboard
        push dword n
        push dword format
        call [scanf]
        add ESP, 4*2
    
    
        mov AL, [m]
        mov BL, [n]
        cmp AL, BL
        jbe Final ; if m<=n jump to Final, because in the problem statement it says that m>n
        cmp AL, 15
        ja Final ; if m>15 jump to Final, because in the problem statement it says that m<=15
        cmp BL, 0
        jb Final ; if n<0 jump to Final, because in the problem statement it says that n>=0
             
       
        mov CL, [m] ; for the shift operations we always use CL
        sub CL, [n]
        
        mov EBX, 0 
        mov BX, 1000000000000000b
        sar BX, CL ; number of 1 bits = number of bits from n to m, so we use shift arithmetic right m-n positions(where the left bits are filled with the sign bit (1 here))
        
        mov CL, 15
        sub CL, [m] ; we will shift to right 15-m positions so the 1 bits will be on positions m-n (the rest will be 0)
        shr BX, CL
        
        mov EAX, 0
        mov AX, [a]
        and AX, BX ; we isolate the bits m-n of a
        
        mov CL, [n]
        shr AX, CL ; we shift to right with n positions so the bits m-n will be the first bits from right to left and the others will be 0 (in order to display the correct number)
                        
                        
        push EAX
        push dword format2  ; print the number represented by the isolated m-n bits in base 16
        call [printf]
        add ESP, 4*2
        
        Final:
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
