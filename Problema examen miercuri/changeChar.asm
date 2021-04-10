bits 32

global changeChar

segment data use32 class=data
    c dd 0
    op dd 0
    n dd 0

segment code use32 class=code

changeChar:
            
        mov EAX, [ESP + 4] ; index
        mov [n], EAX
        mov EAX, [ESP + 8] ; op
        mov [op], EAX
        mov EAX, [ESP + 12] ; c
        mov [c], EAX
        
        cmp dword [op], '-'
        je is_minus   
        
        cmp dword [op], '&'
        je is_and
        jmp done
        
        is_minus:
                mov EAX, [n]
                sub dword [c], EAX      ; if the op is - we do what is written in the statement 
                mov EAX, [c]
                jmp done
        
        is_and:
                mov EAX, [c]
                mov EBX, [n]            ; if the op is & we do what is written in the statement 
                and EAX, EBX
                add EAX, 'a'

        done:

    ret