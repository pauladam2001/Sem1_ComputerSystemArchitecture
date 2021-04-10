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

segment data use32 class=data    ;!!!Works only for a=315, m=8, n=4
    
    firstBitsToBeIsolated dd 0
    powersOf2 dw 1
    a dd 0 ; a word
    m dd 0 ; m byte
    n dd 0 ; n byte
    bits_number_a times 16 db 0  ; a word has maximum 16 bits
    binary_number dw 0000000000000000b
    message1 db "a=", 0
    message2 db "m=", 0
    message3 db "n=", 0
    format db "%d", 0
    format2 db "The number represented by the isolated bits in base 16 is %x", 0

; our code starts here
segment code use32 class=code
    start:
        
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
    
        mov AX, [a] ; we move in AX the word a
        mov BL, 2 ; we will divide by 2 to convert AX (a) from base 10 to base 2
        mov EDI, bits_number_a + 15 ; we need to put the result in inverse order when converting to base 2
        STD ; set direction flag to 1 so we can go in inverse order 
        
        Convert_to_base_2:
                        div BL ; AL = AX/BL, AH = AX%BL
                        
                        mov CL, AL ; we need to keep AL
                        mov CH, 0 ; CX <- CL
                        
                        mov AL, AH ; we move AH into AL so we can use STOSB
                        stosb ; store AL into the byte from the address <ES:EDI>, dec EDI
                        
                        mov AX, CX ; so we can divide by BL and have the results in AL and AH 
                        
                        cmp AX, 0 ; if AX is not 0 then we have to continue the divisions
                        jne Convert_to_base_2
                 
        mov EBX, 0
        mov EBX, 15
        sub EBX, [n]
        mov [firstBitsToBeIsolated], EBX
        mov ESI, bits_number_a + 11    ; we start from the n bit and go to the right until the m bit
        STD
        
        mov ECX, 0 ; in ECX we compute the final result
                 
        Isolate_the_bits:  ; and transform them in a number in base 10
                        lodsb
                        mul byte [powersOf2] ; AX = AL*powersOf2
                        add CX, AX
                        
                        mov AX, [powersOf2]
                        mov BX, 2            ; powersOf2 = powersOf2 * 2
                        mul BX
                        mov [powersOf2], AX
                        
                        cmp ESI, bits_number_a + 7 ;m-1
                        jae Isolate_the_bits                 ; we stop when we reached bit m
                        
                        
                        
        push ECX
        push dword format2
        call [printf]
        add ESP, 4*2
        
        Final:
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
