%ifndef _LENGTH_ASM_
%define _LENGTH_ASM_


MMlength:
        .FindLength:  ; with this repeat we find how long the word is (we stop when we find a space or 0 (for the last word))
            cmp byte [EAX + EDI] , 20h ; 20h = ASCII of space
            je .OutOfRepeat
            cmp byte [EAX + EDI] , 0 ; 0 for last word
            je .OutOfRepeat

            inc EDI         ; if the character is not a space or 0, then we continue
        jmp .FindLength

        .OutOfRepeat:
    ret 
    
%endif