bits 32

global start
extern exit
import exit msvcrt.dll


segment data use32 class=data  ; a,b,c,d - word
    a DW 152
    b DW 130
    c DW 220
    d DW 355
    
    
segment code use32 class=code

start:  ; (d-a)+(b+b+c)
    mov AX, [d] ; AX=d=355
    sub AX, [a] ; AX=AX-a=355-152=203
    
    mov BX, [b] ; BX=b=130
    add BX, [b] ; BX=BX+b=130+130=260
    add BX, [c] ; BX=BX+c=260+220=480
    
    add AX, BX ; AX=AX+BX=203+480=683
    
    PUSH dword 0
    call [exit]