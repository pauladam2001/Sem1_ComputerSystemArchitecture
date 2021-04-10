bits 32
segment code use32 public code

global _function

_function:
        push EBP
        mov EBP, ESP
        
        mov ESI, [EBP + 8] ;text
        
        mov EDI, 0
        mov ECX, 0
        .parseTheString:
                    cmp byte [ESI + EDI] , 20h         ;check if the actual character is a space
                    je .increaseNrOfWords
                    
                    cmp byte [ESI + EDI], 0            ;check if we are at the end of the string
                    je .increaseNrOfWords
                    
                    jmp .continuee
                    
                    .increaseNrOfWords:
                                inc ECX
                    
                    cmp byte [ESI + EDI], 0
                    je .outOfRepeat
                    
                    .continuee:
                    
                    inc EDI
                    jmp .parseTheString
        
        .outOfRepeat:
        
        mov ESP, EBP
        pop EBP
        
        mov EAX, ECX
    ret