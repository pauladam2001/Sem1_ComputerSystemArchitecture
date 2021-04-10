bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, fopen, fread, fclose, fscanf, fprintf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

import fopen msvcrt.dll
import fread msvcrt.dll
import fclose msvcrt.dll
import fscanf msvcrt.dll
import fprintf msvcrt.dll
                          
; our data is declared here (the variables needed by our program)

; A text file is given. The text file contains numbers (in base 10) separated by spaces. Read the content of the file, determine the maximum number (from the numbers that have been read) and write the result at the end of file.

segment data use32 class=data
    
    file_name db "File.txt", 0
    access_mode db "a+", 0              ; we open the file for both reading and writing (appending)
    file_descriptor dd -1
    numberToRead dd 0
    number_type db "%d", 0    ; signed decimal numbers
    char_space db "%c", 0
    maximum_number dd 0

; our code starts here
segment code use32 class=code
    start:
        
        push dword access_mode  ; call fopen() ; EAX = fopen(file_name, access_mode)
        push dword file_name
        call [fopen]
        add ESP, 4*2 ; clean-up the stack
        
        mov [file_descriptor], EAX ; store the file descriptor returned by fopen
        
        cmp EAX, 0 ; check if fopen() has successfully created the file (EAX!=0)
        je Final
        
        readNumbers:
                push dword numberToRead  ; read the text from file using fscanf() ; EAX = fscanf(file_descriptor, number_type, number)
                push dword number_type
                push dword [file_descriptor]
                call [fscanf]
                add ESP, 4*3 ; clean-up the stack
                
                mov EBX, [numberToRead] ; so we can compare it with the actual maximum
                cmp EBX, [maximum_number]
                ja change_max ; if the read number is bigger than maximum we change the maximum
                jmp continue
                
                change_max:
                           mov [maximum_number], EBX
                           
                continue:
                
                cmp EAX, -1 ; check if we can still call fscanf() (there still are elements in the file) ; if EAX = -1 it means that all the elements were read
                jne readNumbers
        
        
        push dword " "
        push dword char_space            ; append a space before we append the maximum number
        push dword [file_descriptor]
        call [fprintf]
        add ESP, 4*3
        
        push dword [maximum_number] ; append the biggest number to  file using fprintf() ; fprintf(maximum_number, number_type, file_descriptor)
        push dword number_type
        push dword [file_descriptor]
        call [fprintf]
        add ESP, 4*3 ; clean-up the stack
        
        
        push dword [file_descriptor] ; call fclose() to close the file ; fclose(file_descriptor)
        call [fclose]
        add ESP, 4*1 ; clean-up the stack
        
        
        Final:
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
