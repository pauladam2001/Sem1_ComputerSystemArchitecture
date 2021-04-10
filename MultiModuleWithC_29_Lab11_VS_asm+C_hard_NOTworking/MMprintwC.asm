bits 32                         
segment code use32 public code

extern _printf
global MMprint



segment data public data use32
    format2 db "%s", 10 ,13, 0 

MMprint:
        ;push EBP
        ;mov EBP, ESP

        push dword EBX
        push dword format2  ; we print the word that we obtained
        call _printf
        add ESP, 4*2
        
        ;mov ESP, EBP
        ;pop EBP
        
    ret