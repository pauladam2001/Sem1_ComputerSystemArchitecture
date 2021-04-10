%ifndef _PRINT_ASM_
%define _PRINT_ASM_


extern printf
import printf msvcrt.dll


MMprint:
        push dword EBX
        push dword format2  ; we print the word that we obtained
        call [printf]
        add ESP, 4*2
    ret
    
%endif