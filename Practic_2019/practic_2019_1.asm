bits 32
global start        

; Sa se citeasca de la tastatura un numar n, apoi sa se citeasca mai multe cuvinte, pana cand se citeste caracterul #. Sa se scrie intr-un fisier text toate cuvintele citite care incep si se termina cu aceeasi litera si au n litere.

extern exit, scanf, fprintf, printf, fopen, fclose
import exit msvcrt.dll              
import scanf msvcrt.dll
import fprintf msvcrt.dll
import printf msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll

segment data use32 class=data
    number dd 0
    read_number_message db 'Enter n: ', 0
    read_word_message db 'Enter word: ', 0
    file_name db 'practic1.txt', 0
    access_mode db 'a', 0
    number_format db '%d', 0
    string_format db '%s', 0
    string times 100 db 0
    last_letter db 0
    length_of_word dd 0
    file_descriptor dd -1
    end_of_word dd 0
    char_format db '%c',10, 13, 0
    
segment code use32 class=code
    start:
        
        push dword access_mode
        push dword file_name
        call [fopen]
        
        cmp eax, 0
        je end_of_program
        mov [file_descriptor], eax
        
        push dword read_number_message
        call [printf]
        add esp, 4
        
        push dword number
        push dword number_format
        call [scanf]
        add esp, 4*2
        
        read_words:
            push dword read_word_message
            call [printf]
            add esp, 4
            
            push dword string
            push dword string_format
            call [scanf]
            add esp, 4*2
            
            mov esi, string
                
            ; compara cu '#' si sari la final
            cmp byte [esi], '#'
            je end_of_program
            
            
            lodsb    ; al has the first letter of the word
            
            dec esi
            
            find_last_letter:
            inc esi
            cmp byte [esi], 0
            jne find_last_letter
            
            mov ah,[esi-1]
            mov [last_letter], ah
            
            cmp al, [last_letter]
            jne clean_string
            
            mov dword[end_of_word], esi
            sub dword[end_of_word], string
            
            mov eax, [end_of_word]
            
            cmp eax, [number]
            jne clean_string
            
            push dword string
            push dword string_format
            push dword [file_descriptor]
            call [fprintf]
            add esp, 4*3
            
            push dword " "
            push dword char_format
            push dword [file_descriptor]
            call [fprintf]
            add esp, 4*3
            
            clean_string:
            mov esi, string
            mov ecx, 100
            clean_byte:
                mov byte [esi], 0
                inc esi
                loop clean_byte
            
            jmp read_words
        
        end_of_program:
        
        push dword [file_descriptor]
        call [fclose]
        add esp, 4
        
        push    dword 0      
        call    [exit]     