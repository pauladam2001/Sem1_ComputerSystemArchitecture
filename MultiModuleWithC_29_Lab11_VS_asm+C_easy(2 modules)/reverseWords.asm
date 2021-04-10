bits 32

extern _printf

global _function

segment data public data use32
    format2 db "%s", 10 ,13, 0

segment code use32 public code

_function:
        push EBP
        mov EBP, ESP
        
        mov EAX, [EBP + 8] ;given sentence
        mov EBX, [EBP + 12] ;new word
 
        
        mov ESI, 0
        mov EDI, 0
        
        .ParseTheString:  ; the big loop (it stops when the sentence is parsed)

            ;call MMlength ; we find the length of the word (input: EAX (the given sentence), output: the position of the next space)
            .FindLength:  ; with this repeat we find how long the word is (we stop when we find a space or 0 (for the last word))
                cmp byte [EAX + EDI] , 20h ; 20h = ASCII of space
                je .OutOfRepeat
                cmp byte [EAX + EDI] , 0 ; 0 for last word
                je .OutOfRepeat

                inc EDI         ; if the character is not a space or 0, then we continue
            jmp .FindLength

            .OutOfRepeat:
            
            mov EDX, 0
            mov ECX, 100
            
            ;call MMclear ; we clear new_word in order to form another reversed word (input: EBX (the new word), output: EBX)
            .ClearTheNewWord: ; with this loop we clear the word where we will form the mirrored word of the actual one
                        mov byte [EBX + EDX], 0
                        inc EDX
            loop .ClearTheNewWord
            
            mov ECX, EDI
            sub ECX, ESI  ; we put in ECX the length of the word
            
            push EDI ; we need to keep EDI
            
            dec EDI ;the character before the space
            mov EDX, 0 ; with edx we parse the new_word
            
            ;call MMreverse ; we form the mirrored word (input: EBX (the new word), the length of the actual word, output: the word reversed (in EBX))
            .Mirror: ; with this loop we form the mirrored word
                push ECX
                mov CL, [EAX + EDI] ; CL = the last character of the word
                mov [EBX + EDX], CL ; in EBX (new_word), on position EDX (from left to right) we put CL
                pop ECX ; we pop back ECX because we need it for the loop
                inc EDX
                dec EDI
            loop .Mirror
            
            pushad ; we push all registers because the printf will change the values
            
            ;call MMprint ; we print the formed reversed word (input: the new word (EBX), output: displays the reversed word in the console)
            push dword EBX
            push dword format2  ; we print the word that we obtained
            call _printf
            add ESP, 4*2
                
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