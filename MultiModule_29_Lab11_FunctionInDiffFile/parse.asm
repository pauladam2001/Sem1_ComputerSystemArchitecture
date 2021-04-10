; we need to avoid multiple inclusion of this file
%ifndef _PARSE_ASM_ ; if _PARSE_ASM_ is not defined
%define _PARSE_ASM_ ; then we define it

%include "length.asm"
%include "clear.asm"
%include "reverse.asm"
%include "print.asm"

; procedure definition
MMmirror:
        mov EBX, [ESP + 4]  ; the new_word
        mov EAX, [ESP + 8]  ; the given_sentence
 
        
        mov ESI, 0
        mov EDI, 0
        
        .ParseTheString:  ; the big loop (it stops when the sentence is parsed)

            call MMlength ; we find the length of the word
            
            mov EDX, 0
            mov ECX, 100
            
            call MMclear ; we clear new_word in order to form another reversed word
            
            mov ECX, EDI
            sub ECX, ESI  ; we put in ECX the length of the word
            
            push EDI ; we need to keep EDI
            
            dec EDI ;the character before the space
            mov EDX, 0 ; with edx we parse the new_word
            
            call MMreverse ; we form the mirrored word
            
            pushad ; we push all registers because the printf will change the values
            
            call MMprint ; we print the formed reversed word
            
            popad ; we pop all the values of registers from the stack
            
            pop EDI ; we get back the value of EDI from the stack
            
            cmp byte [EAX + EDI], 0 ; we check if we have parsed the whole sentence
            je .finish
            
            mov ESI, EDI
            inc ESI ; next word, after space ; if we are not at the end of the sentence we continue searching words
            add EDI, 1
            jmp .ParseTheString
            
        .finish:
    
	ret 8 ; 4 reprezinta numarul de octeti ce trebuie eliberati de pe stiva (parametrul pasat procedurii)
    
%endif