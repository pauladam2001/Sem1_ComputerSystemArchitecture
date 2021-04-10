%ifndef _CLEAR_ASM_
%define _CLEAR_ASM_


MMclear:
        .ClearTheNewWord: ; with this loop we clear the word where we will form the mirrored word of the actual one
                        mov byte [EBX + EDX], 0
                        inc EDX
        loop .ClearTheNewWord

    ret
    
%endif