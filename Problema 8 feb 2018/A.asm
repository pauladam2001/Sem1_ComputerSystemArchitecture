bits 32

global start

;A string of doublewords is given ( defined in module a.asm). Build the string of byte ranks
;that have the maximum value from each doubleword (considering them unsigned) by calling a 
;procedure from module b.asm. This procedure should also compute the sum of these bytes.
;Next, in the main module (a.asm) print this string of bytes on the screen (unsigned) and also print
;the sum of these bytes(signed).

;Example: If the string of doublewords is:
;sir dd 1234A678h, 12345678h, 1AC3B47Dh, FEDC9876h
;the bytes of max value are respectively A6h, 78h, C3h, FEh,
;the corresponding string of bytes ranks being "3421",
;and the sum of these bytes being -33.

extern B
extern exit, printf

import printf msvcrt.dll
import exit msvcrt.dll

segment data use32 class=data

    given_string dd 1234A678h, 12345678h, 1AC3B47Dh, 0FEDC9876h
    len equ ($-given_string)/4
    destination_string times len db 0
    destination dd 0
    sum_of_bytes dd 0
    format db "%d", 0
    format2 db " ", 10, 13, 0
    copy dd 0
    

segment code use32 class=code
start:

    push dword len
    push dword destination_string
    push dword given_string
    call B
    add ESP, 4*3
    
    mov [sum_of_bytes], EAX
    
    mov ECX, 0
    for_every_byte:
        mov AL, [destination_string + ECX]
        push ECX
        mov [destination], AL
        push dword [destination]
        push dword format
        call [printf]
        add ESP, 4*2
        pop ECX
        inc ECX
        cmp ECX, len
        jne for_every_byte
    
    push dword format2
    call [printf]
    add ESP, 4*1
    
    mov AL, byte[sum_of_bytes]
    cbw
    cwde
    
    push dword EAX
    push dword format
    call [printf]
    add ESP, 4*2
    
    push dword 0
    call [exit]