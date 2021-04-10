bits 32
segment code use32 public code

global function

function:
        mov ESI, [ESP + 8] ;text
        mov ECX, [ESP + 4] ;nrOfWords
        
        mov EDI, 0
        .parseTheString:
                    cmp byte [ESI + EDI] , 20h         ;check if the actual character is a space
                    je .increaseNrOfWords
                    
                    cmp byte [ESI + EDI], 0            ;check if we are at the end of the string
                    je .increaseNrOfWords
                    
                    jmp .continuee
                    
                    .increaseNrOfWords:
                                inc byte [ECX]
                    
                    cmp byte [ESI + EDI], 0
                    je .outOfRepeat
                    
                    .continuee:
                    
                    inc EDI
                    jmp .parseTheString
        
        .outOfRepeat:
    ret