bits 32 


global start        


extern exit               
import exit msvcrt.dll    
                          


segment data use32 class=data
    a dw 1001110100110101b
    b dw 0001110001110100b
    c dd 0
    


segment code use32 class=code

;Given the words A and B, compute the doubleword C as follows:

;the bits 0-3 of C are the same as the bits 5-8 of B
;the bits 4-10 of C are the invert of the bits 0-6 of B
;the bits 11-18 of C have the value 1
;the bits 19-31 of C are the same as the bits 3-15 of B

    start:
       
    ;the bits 0-3 of C are the same as the bits 5-8 of B
    
        mov AX, 0000000111100000b      ;create a mask for bits 5-8
        and AX, [b]                    ;copy bits 5-8 of B into AX
        ror AX, 5                      ;bring the bits to positions 0-3
    
        or word[c], AX                 ;copy the bits 0-3 of AX onto the low word of C 
 
 
    ;the bits 4-10 of C are the invert of the bits 0-6 of B
    
        mov AX,  [b]                   ;copy b in AX
        not AX                         ;invert all bits of AX
        and AX, 0000000001111111b      ;create a mask  for bits 0-6 of AX and isolate them
        
        rol AX, 4                      ;rotate to left in order to bring the isolated bits to positions 4-10
        or word[c], AX                ;copy the bits 4-10 of AX to the low word of C
        
        
    ;the bits 11-18 of C have the value 1
        
        mov AX, 0000000011111111b      ; the first 8 bits of AX are set to 1
        
        mov DX, 0                      ;AX is converted into EAX
        push DX
        push AX
        pop EAX
        
        rol EAX, 11                    ;bring the '1' bits to positions 11-18 in EAX
        
        or [c], EAX                    ;copy these '1' bits onto the bits 11-18 of c
        
        
    ;the bits 19-31 of C are the same as the bits 3-15 of B
    
        mov AX, [b]
        and AX, 1111111111111000b      ;isolate bits 3-15 of B in AX
        
        or word[c+2], AX               ;copy the bits 3-15 of AX to the high word of C
        
        
        
        push    dword 0      
        call    [exit]
