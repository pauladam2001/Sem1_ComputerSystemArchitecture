bits 32                         
segment code use32 public code
global _MMmirror

extern MMclear, MMprint, MMreverse, MMlength


_MMmirror:
        push EBP
        mov EBP, ESP
        
        mov EAX, [EBP + 8] ;given sentence
        mov EBX, [EBP + 12] ;new word
 
        
        mov ESI, 0
        mov EDI, 0
        
        .ParseTheString:  ; the big loop (it stops when the sentence is parsed)

            call MMlength ; we find the length of the word (input: EAX (the given sentence), output: the position of the next space)
            
            mov EDX, 0
            mov ECX, 100
            
            call MMclear ; we clear new_word in order to form another reversed word (input: EBX (the new word), output: EBX)
            
            mov ECX, EDI
            sub ECX, ESI  ; we put in ECX the length of the word
            
            push EDI ; we need to keep EDI
            
            dec EDI ;the character before the space
            mov EDX, 0 ; with edx we parse the new_word
            
            call MMreverse ; we form the mirrored word (input: EBX (the new word), the length of the actual word, output: the word reversed (in EBX))
            
            pushad ; we push all registers because the printf will change the values
            
            call MMprint ; we print the formed reversed word (input: the new word (EBX), output: displays the reversed word in the console)
            
            popad ; we pop all the values of registers from the stack
            
            pop EDI ; we get back the value of EDI from the stack
            
            cmp byte [EAX + EDI], 0 ; we check if we have parsed the whole sentence
            je .finish
            
            mov ESI, EDI
            inc ESI ; next word, after space ; if we are not at the end of the sentence we continue searching words
            add EDI, 1
            jmp .ParseTheString
            
        .finish:
        
        mov ESP, EBP
        pop EBP
    
	ret