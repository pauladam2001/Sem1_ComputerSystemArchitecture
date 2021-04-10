bits 32
global start        

;It is given a number in base 2 represented on 32 bits. Write to the console the number in base 16. (use the quick conversion)


extern exit, printf
              
import exit msvcrt.dll   
import printf msvcrt.dll

extern convert_to_hexa

                          
segment data use32 class=data
   number dd 1101_0011_1001_1100_1101_0101_1111_0001b
   printing_format db "The number in hexa is %s", 0
   hexa_digits db '0','1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' 
   hexa_number resb 8
   
segment code use32 class=code
    start:
    
        ;convert the binary number into a string of hexa digits
        push dword number
        push dword hexa_number
        push dword hexa_digits
        call convert_to_hexa
        
        ; print the number in base 16 on the console
        push dword hexa_number
        push dword printing_format
        call [printf]
        add esp, 4*2
        
        
        end_of_program:
        push    dword 0    
        call    [exit]   
