%ifndef _REVERSE_ASM_
%define _REVERSE_ASM_


MMreverse:
        .Mirror: ; with this loop we form the mirrored word
            push ECX
            mov CL, [EAX + EDI] ; CL = the last character of the word
            mov [EBX + EDX], CL ; in EBX (new_word), on position EDX (from left to right) we put CL
            pop ECX ; we pop back ECX because we need it for the loop
            inc EDX
            dec EDI
        loop .Mirror
    ret
    
%endif