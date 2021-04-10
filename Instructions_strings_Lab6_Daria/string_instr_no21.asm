bits 32
;Being given a string of words, obtain the string (of bytes) of the digits in base 10 of each word from this string.
global start
; Solutia: voi parcurge sirul in ordine inversa si voi lua de fiecare data ultima cifra din fiecare cuvant, apoi rastorn sirul 

extern exit
import exit msvcrt.dll


segment data use32 class=data
    sir dw 12345, 20778, 4596
    len_sir equ $-sir
    destination resb 100
    zece dw 10

segment code use32 class=code
    start:
    
        cld
        
        mov ECX, len_sir/2  ; the number of words
        mov ESI, sir+len_sir-2 ; 
        mov EDI, destination
        
        jecxz EndOfProgram
        
        ; parse the string from beginning to end
        big_loop:
        
            std      ; set the carry to 1
            LODSW    ; load a word from the source string into AX (ESI:= ESI - 2)
           
            cmp AX, 0  ; if the word is 0, we jump to the next word
            jz next_word
            
            take_digits:         ; if not, we parse it and take all its digits from end to beginning
                
            cld                  ; clear the carry
            mov DX, 0            
            div word[zece]       ; DX = DX:AX % 10    ; divide the number by ten and the remainder (the last digit of the number) will be in DX
            
            mov BX, AX           ; save the result of dx:ax/zece   ; the rest of the number is saved temporarily in BX
            
            mov AL, DL           ; AL takes the remainder of the division
            
            STOSB                ; and stores in in the destination string (EDI:= EDI + 2)
            
            mov AX, BX           ; move the rest of the number back into AX
        
            cmp AX, 0            ; if the number is not yet 0, we still have digits and do the loop again.
            jg take_digits
    
            next_word:           ; if it is zero, we jump to the next word
    
    
        loop big_loop
        
        
        ;we now reverse the destination string, in order to have the digits in the correct order
        mov ESI, sir+len_sir     ; the start of the destination string
        dec EDI                  ; the end of the destination string
        cmp ESI, EDI             ; while the index of the start is smaller than the index of the end,
        ja EndOfProgram          
        
        reverse:                 ; while the index of the start is smaller than the index of the end,
                                 ; we swap the bytes on at the start offset and the end offset
        mov AL, [edi]            ; save the element at the end offset
        movsb                    ; the byte at the end takes the value of the byte from the start
        dec esi                  ; we decrement esi because the instrunction above incremented both esi and edi by one, but we still have work to do
        sub edi, 2               ; at this offset
        mov [esi], AL            ; put in esi the copy of the element from the end offset
        inc esi                  ; move to the next byte
       
        cmp esi, edi             ; compare the start and the end offsets and do the loop again if we still haven't reached the middle
        
        jb reverse
        
        
        EndOfProgram:
        push dword 0
        call [exit]