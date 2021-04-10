bits 32

global function

extern printf
import printf msvcrt.dll

segment data use32 class=data
    sum_string times 100 db 0
    sum_string_length db 0
    sum dd 0
    format db "%u", 0
    char_space db "%c", 0

segment code use32 class=code

function:
        mov ESI, [ESP + 4]
        mov ECX, [ESP + 8]
        
        mov EDI, sum_string
        
        parse_string:
                    lodsd
                    mov EDX, 0
                    mov EBX, 10
                    compute_sum:
                                div EBX
                                
                                test EDX, 1h
                                jp is_even
                                jmp not_even
                                
                                is_even:
                                        add dword [sum], EDX
                                
                                not_even:
                                
                                mov EDX, 0
                                cmp EAX, 0
                                jne compute_sum
                    
                    mov AL, [sum]
                    stosb
                    add byte [sum_string_length], 1
                    mov dword [sum], 0
                    
            loop parse_string
    
        mov ESI, sum_string
        mov ECX, [sum_string_length]
        print_sums:
                push ECX
                mov EAX, 0
                lodsb
                push EAX
                push dword format
                call [printf]
                add ESP, 4*2
                
                push dword " "
                push dword char_space
                call [printf]
                add ESP, 4*2
                pop ECX
                
            loop print_sums
    
    ret