bits 32                         
segment code use32 public code
global MMclear

MMclear:
        ;push EBP
        ;mov EBP, ESP

        .ClearTheNewWord: ; with this loop we clear the word where we will form the mirrored word of the actual one
                        mov byte [EBX + EDX], 0
                        inc EDX
        loop .ClearTheNewWord
        
        ;mov ESP, EBP
        ;pop EBP

    ret