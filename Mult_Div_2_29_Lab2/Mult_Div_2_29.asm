bits 32

global start
extern exit
import exit msvcrt.dll


segment data use32 class=data  ; a,b,c,d - byte, e,f,g,h - word
    a DB 25
    b DB 83
    c DB 100
    d DB 10
    
    e DW 430
    f DW 335
    g DW 2222
    h DW 1350
    
    
segment code use32 class=code

start:  ; [[b*c-(e+f)]/(a+d)
    mov AL, [b] ; AL=b=83
    mul BYTE [c] ; AX=AL*c=8300

    mov BX, [e] ; BX=e=430
    add BX, [f] ; BX=BX+f=430+335=765
    
    sub AX, BX ; AX=AX-BX=8300-765=7535  // [b*c-(e+f)]
    
    mov BL, [a] ; BL=a=25
    add BL, [d] ; BL=BL+d=25+10=35  // (a+d)
    
    div BL ; AL=AX/BL, AH=AX%BL
    
    
    PUSH dword 0
    call [exit]