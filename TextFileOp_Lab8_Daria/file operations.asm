bits 32 
; A file name and a text (defined in the data segment) are given. The text contains lowercase letters, digits and spaces. Replace all the digits on ;odd positions with the character ‘X’. Create the file with the given name and write the generated text to file.

global start        


extern exit, fopen, fprintf, fread, fclose               
import exit msvcrt.dll   
import fopen msvcrt.dll
import fprintf msvcrt.dll
import fread msvcrt.dll
import fclose msvcrt.dll

segment data use32 class=data
    file_name db 'my_file.txt', 0
    access_mode db 'w', 0
    text_of_file db 'Ana2 are 23 de mere', 0
    length_of_text equ $-text_of_file
    file_descriptor dd -1
    position db 0
    
segment code use32 class=code
    start:
      
        ; change the text
        mov ecx, length_of_text
        mov esi, text_of_file
        
        jecxz end_of_program
        
        change_digits:
        
        cmp byte[esi], '0'
        jb next_charcter
        
        cmp byte[esi],  '9'
        ja next_charcter
        
        test byte[position], 01h
        jp next_charcter
        
        mov byte[esi], 'X'
        
        next_charcter:
        inc byte[position]
        inc esi
        loop change_digits
        
        
        ; create the file
        push dword access_mode
        push dword file_name
        call [fopen]
        
        add esp, 4*2
        mov [file_descriptor], eax
        
        cmp eax, 0
        je end_of_program
        
        ; print the text to the file
        push dword text_of_file
        push dword [file_descriptor]
        call [fprintf]
        
        add esp, 4*2
        
        ;close the file
        push dword [file_descriptor]
        call [fclose]
        
        add esp, 4
        
        end_of_program:
        push    dword 0      
        call    [exit]       
