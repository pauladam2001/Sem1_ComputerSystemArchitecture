bits 32

global B

segment data use32 class=data

    sum_of_bits2 dd 0
    destination times 4 db 0
    max_number dd 0 
    max_position dd 0
    
segment code use32 class=code

B:
; ESP - return address
; ESP + 4 - given_string
; ESP + 8 - destination_string
; ESP + 12 - length
    
    mov ESI, [ESP + 4]
    mov EDI, [ESP + 8]
    mov ECX, [ESP + 12]
    cld
    for_every_doubleword:
        push ECX
        mov ECX, 4
        cld
        find_maximum_byte:
            lodsb
            cmp AL, [max_number]
            jb not_found_larger
                mov [max_number], AL
                mov [max_position], ECX
                
            not_found_larger:
            loop find_maximum_byte
         
        pop ECX
        
        mov AL, [max_position]
        stosb
        mov EBX, 0
        mov EBX, [max_number]
        
        add [sum_of_bits2], EBX
        
        mov dword[max_position], 0
        mov byte[max_number], 0
        
    loop for_every_doubleword
    
    mov EAX, [sum_of_bits2]
    ret