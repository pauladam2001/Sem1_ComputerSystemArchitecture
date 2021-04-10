bits 32

global convert_to_hexa

convert_to_hexa:
        
        mov ebx, [esp+4]     ; the translation table used for XLAT, having all the hexa digits
        mov edi, [esp+8]     ; the destination string, to which we append our hexa characters
        mov edx, [esp+12]    ; the initial number that we have to convert
        
        mov ecx, 8           ; since the number is on 32 bits, we have 8 nibbles on which we will perform quick conversion
        convert_nibble:
            ;isolate the first 4 bits of the number at the end of AL

            mov eax, [edx]   ; the number is now in eax
            shr eax, 28      ; the bits in eax are shifted to the right so that the nibble that we are interested in will be the lowest of AL
              
            ;convert the number in AL to its corresponding hexa digit
            xlat                 
            
            ;save the obtained hexa digit in the final string
            stosb            
            
            ;delete the first 4 bits from the number
            shl dword [edx], 4 
        
        loop convert_nibble
        
        ret 3
    
    
