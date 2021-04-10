bits 32

global start

extern exit, printf
extern A
extern B
;A string of doublewords is given. From each of these doublewords
;form a new word by taking the higher byte of the higher word and the higher byte of the lower word.
;All these new obtained words will be stored in a word string. Then compute the number
;of bits of value 1 from the new formed word string and print on the screen in base 10.

;Example: If the string of doublewords is: sir dd 1234A678h, 12785634h, 1A4D3C28h, then
;the string of words containing the higher byte of the higher word and the higher byte of the lower
;word for each doublewords is: 12A6h, 1256h, 1A3Ch and the number of bits 1 from all the words
;of the string is: 6 + 6 + 7 = 19. The number 19 will be printed on the screen.

import exit msvcrt.dll  
import printf msvcrt.dll

segment data use32 class=data
    given_string dd 1234A678h, 12785634h, 1A4D3C28h
    len equ ($-given_string)/4
    destination_string times len dw 0
    sum_bits dd 0
    format db "%d", 0
segment code use32 class=code    
    start:
   
    push dword len
    push dword destination_string
    push dword given_string
    call A ; In this module we are creating the new words
    add ESP, 4*3
    
    push dword len
    push dword destination_string
    call B
    add ESP, 4*2
    
    mov [sum_bits], EAX
    
    push dword [sum_bits]
    push dword format
    call [printf]
    add ESP, 4*2
    
    push dword 0
    call [exit]
    