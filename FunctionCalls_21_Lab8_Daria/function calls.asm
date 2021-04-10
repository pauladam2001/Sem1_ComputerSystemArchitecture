bits 32 

global start        
;Read two words a and b in base 10 from the keyboard. Determine the doubleword c such that the low word of c is given by the sum of the a and b and the ;high word of c is given by the difference between a and b. Display the result in base 16 Example:
;a = 574, b = 136
;c = 01B602C6h

extern exit, scanf, printf               
import exit msvcrt.dll    
import printf msvcrt.dll     
import scanf msvcrt.dll     
                         
segment data use32 class=data
    a dd 0
    b dd 0
    c dd 0
    reading_message db "Enter number: ", 0 
    format db "%d", 0
    printing_message db "The number c is %x in hexa", 0

segment code use32 class=code
    start:
        
        ; read a
        
        push dword reading_message
        call [printf]
        add esp, 4
        
        push dword a
        push dword format
        call [scanf]
        add esp, 4*2
        
        ;read b
        
        push dword reading_message
        call [printf]
        add esp, 4
        
        push dword b
        push dword format
        call [scanf]
        add esp, 4*2
        
        ; the low word of c has the sum a+b
        mov eax, [a]
        add eax, [b]
        
        mov word[c], AX
        
        ; the high word of c ha sthe sum a-b
        mov eax, [a]
        sub eax, [b]
        
        mov word[c+2], AX
        
        ;print c in hexa
        push dword [c]
        push dword printing_message
        call [printf]
        add esp, 4*2
          
        push    dword 0      
        call    [exit]      