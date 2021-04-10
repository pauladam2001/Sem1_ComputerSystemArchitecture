bits 32
segment code use32 public code

global function


function:
        mov ECX, [ESP+ 12] ;char
        mov ESI, [ESP + 8] ;text
        mov EDX, [ESP + 4] ;nrOfChar
        
        mov EDI, 0
        .parseTheString:
                    cmp byte [ESI + EDI] , 0 ; the string is parsed
                    je .outOfRepeat
                    
                    mov AL, byte [ESI + EDI]
                    cmp AL, [ECX]
                    jne .continuee
                    
                    inc byte [EDX]             ;if the actual character is equal with the one read from the keyboard
                    mov byte [ESI + EDI], 'X'
                    
                    .continuee:
                    inc EDI
                    jmp .parseTheString
        
        .outOfRepeat:
    ret