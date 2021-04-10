bits 32

global function

extern printf
import printf msvcrt.dll

segment data use32 class=data
    nr_in_base2 times 100 db 0
    format db "%u", 0
    char_space db "%c", 0
    string times 100 db 0

segment code use32 class=code

function:
        mov ESI, [ESP + 12]
        mov EDI, [ESP + 8]
        mov ECX, [ESP + 16]
        
        cld
        parse_sir1:
                lodsb
                lodsb
                cmp AL, 0
                jl store_byte
                jmp continue
                
                store_byte:
                        stosb
                
                continue:
                lodsw
                
                loop parse_sir1
                
        mov EDI, [ESP + 8]
        mov EDX, 0
        
        print_base2:
                mov EAX, 0
                lodsb
                cmp EAX, 0
                je final
                
                mov EBX, 2
                mov ECX, 0
                
                form_base2:
                        div EBX
                        mov [nr_in_base2 + ECX], EDX
                        add ECX, 1
                        mov EDX, 0
                        
                        cmp EAX, 0
                        jne form_base2
                sub ECX, 1
                print_nr:
                        push ECX
                        mov EAX, 0
                        mov AL, [nr_in_base2 + ECX]
                        push EAX
                        push dword format
                        call [printf]
                        add ESP, 4*2
                        pop ECX
                        dec ECX
                        cmp ECX, 0
                        jge print_nr
                
                push dword " "
                push dword char_space
                call [printf]
                add ESP, 4*2
                
                mov EDX, 0
                mov ECX, 25
                clearWord:
                        mov dword [nr_in_base2 + EDX], 0
                        add EDX, 4
                        loop clearWord
                
                mov EDX, 0
                jmp print_base2
            
        mov ESI, [ESP + 8]
        mov EDI, [ESP + 4]
        
        mov ECX, 0
        
        final:
        
        ;parse_sir2:
         ;       mov EAX, 0
          ;      lodsb
           ;     cmp EAX, 0
            ;    je done
             ;   mov EDX, 0
              ;  mov byte [string + ECX], '-'
               ; inc ECX
                ;
                ;mov EBX, 10
                ;decompose:
                ;        div EBX
                 ;       
                  ;      add EBX, '0'
                   ;     mov [string + ECX], EBX
                    ;    
                     ;   mov EDX, 0
                      ;  cmp EAX, 0
                       ; jne decompose
           ;     jmp parse_sir2
       
      ;  done:
       ;     push dword [ESP + 4]
        ;    call [printf]
         ;   add ESP, 4
        
    ret