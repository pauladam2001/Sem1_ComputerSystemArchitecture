bits  32
global  start

extern exit, fopen, fclose, fscanf, printf

import  exit msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import fscanf msvcrt.dll
import printf msvcrt.dll

extern B


segment  data use32 public data

    file_name db "input.txt", 0
    access_mode db "r", 0
    file_descriptor dd -1
    numberToRead dd 0
    number_type db "%d"
    counter dd 0
    format_print db "%d  ", 0
    numbers times 100 dd 0
    sorted_number dd 0
    
segment  code use32 public code
    start:
        ; call fopen() to create the file
        ; fopen() will return a file descriptor in the EAX or 0 in case of error
        ; eax = fopen(file_name, access_mode)
        
        push dword access_mode
        push dword file_name
        call [fopen]
        add ESP, 4*2
        
        mov dword[file_descriptor], EAX
        
        cmp EAX, 0
        je final
        
        cld
        mov EDI, numbers
        readNumbers:
            ;EAX = fscanf(file_descriptor, number_type, numberToRead)
            push dword numberToRead ; read the text from file usinf fscanf()
            push dword number_type
            push dword [file_descriptor]
            call [fscanf]
            add ESP, 4*3 ; clean-up the stack
            
            add dword[counter], 1
            mov ESI, numberToRead
            movsd
            
            cmp EAX, -1
            jne readNumbers
           
            
        sub dword[counter], 1
        
        push dword numbers
        push dword[counter]
        call B
        add ESP, 4*2
        
        mov ECX, dword[counter]
        mov ESI, numbers
        cld
        for_every_number:
        ;printf(format_print, numbers)
            lodsd
            mov [sorted_number], EAX
            pushad
            push dword [sorted_number]
            push dword format_print
            call [printf]
            add ESP, 4*2
            popad
            loop for_every_number
        
        ;fclose(file_descriptor)
        push dword[file_descriptor]
        call [fclose]
        add ESP, 4*1
        
        final:
        
        push    dword 0
        call    [exit]
            