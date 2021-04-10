bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, fopen, fclose, scanf, fprintf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import fopen msvcrt.dll
import fclose msvcrt.dll
import scanf msvcrt.dll
import fprintf msvcrt.dll
                          
;A file name is given (defined in the data segment). Create a file with the given name, then read numbers from the keyboard and write only the numbers divisible by 7 to file, until the value '0' is read from the keyboard.

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    file_name db "File1.txt", 0
    acces_mode db "a", 0
    file_descriptor dd -1
    number dd 0
    typee db "%u", 0
    char_space db "%c", 0
    

; our code starts here
segment code use32 class=code
    start:
    
        push dword acces_mode
        push dword file_name
        call [fopen]
        add ESP, 4*2
        
        mov [file_descriptor], EAX
        
        cmp EAX, 0
        je Final
        
        mov EBX, 7
        
        read_numbers:
                    push dword number
                    push dword typee
                    call [scanf]
                    add ESP, 4*2
                    
                    cmp dword [number], 0
                    je Final
                    
                    mov EAX, [number]
                    mov EDX, 0
                    div EBX  ; edx = edx:eax % ebx
                    
                    cmp EDX, 0
                    je write_string
                    jmp next
                    
                    write_string:
                                push dword [number]
                                push dword typee
                                push dword [file_descriptor]
                                call [fprintf]
                                add ESP, 4*3
                                
                                push dword " "
                                push dword char_space
                                push dword [file_descriptor]
                                call [fprintf]
                                add ESP, 4*3
                    
                    next:
                    
                    jmp read_numbers
                    
        
        push dword [file_descriptor]
        call [fclose]
        add ESP, 4
        
        
        Final:
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
