bits 32

global function

extern printf 
import printf msvcrt.dll

segment data use32 class=data
    copy_of_nr dd 0
    degree db 0
    max_degree db 0
    sem db 0
    format db "%u", 0
    char_space db "%c", 0
    nr_in_base_2 times 100 db 0
    
segment code use32 class=code

function:
        mov ESI, [ESP + 4]
        mov EDI, [ESP + 8]
        mov ECX, [ESP + 12]
        
        cld
        parse_init_string:
                      push ECX
                      lodsd
                      mov [copy_of_nr], EAX
                      check_degree:
                                   shl EAX, 1
                                   jc inc_degree
                                   
                                   jmp check_if_3
                                   
                                   inc_degree:
                                            add byte [degree], 1
                                            mov byte [sem], 1
                                   
                                   check_if_3:
                                            cmp byte [degree], 3
                                            je increase_max_degree
                                            
                                            jb not_3
                                            
                                            increase_max_degree:
                                                            add byte [max_degree], 1
                                                            mov byte [degree], 0
                                                            
                                            not_3:
                                                cmp byte [sem], 1
                                                je continue
                                                
                                                make_it_zero:   ;if the carry was 0
                                                            mov byte [degree], 0
                                                
                                                continue:
                                                    mov byte [sem], 0
                                   
                                   cmp EAX, 0
                                   jne check_degree
                       
                       cmp byte [max_degree], 2
                       jae append_nr
                       
                       jmp next
                       
                       append_nr:
                                mov EAX, [copy_of_nr]
                                stosd
                                mov byte [max_degree], 0
                                
                                push dword [copy_of_nr]
                                push dword format
                                call [printf]
                                add ESP, 4*2
                       
                       next:
                       
                       lodsd
                       pop ECX
                       
        loop parse_init_string
        
        mov ESI, [ESP + 8]
        mov EDX, 0
        
        print_base_2:
        
        lodsd
        ;mov EAX, [EDI]
        ;add EDI, 4
        cmp EAX, 0
        je final
        
        mov EBX, 2
        
        mov ECX, 0
        
        formBase2:
                div EBX
                mov [nr_in_base_2 + ECX], EDX
                add ECX, 1
                mov EDX, 0
                
                cmp EAX, 0
                jne formBase2
        sub ECX, 1
        printString:
                    push ECX
                    mov EAX, 0
                    mov AL, [nr_in_base_2 + ECX]
                    push EAX
                    push dword format
                    call [printf]
                    add ESP, 4*2
                    pop ECX
                    dec ECX
                    cmp ECX, 0
                    jge printString
                    
        push dword " "
        push dword char_space
        call [printf]
        add ESP, 4*2
        
        mov EDX, 0
        mov ECX, 25
        clearWord:
                mov dword [nr_in_base_2 + EDX], 0
                add EDX, 4
                loop clearWord
        
        mov EDX, 0
        jmp print_base_2
        
        final:
        
    ret