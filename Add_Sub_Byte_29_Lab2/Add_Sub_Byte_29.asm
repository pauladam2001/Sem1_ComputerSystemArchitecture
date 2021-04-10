bits 32

global start
extern exit
import exit msvcrt.dll


segment data use32 class=data  ; a,b,c,d - byte
    a DB 8
    b DB 12
    c DB 9
    d DB 15
    
    
segment code use32 class=code

start:  ; (b+c)+(a+b-d)
    mov AL, [b] ; AL=b=12
    mov BL, [c] ; BL=c=9
    add AL, BL ; AL=AL+BL=12+9=21
    
    mov CL, [a] ; CL=a=8
    add CL, [b] ; CL=CL+b=8+12=20
    sub CL, [d] ; CL=CL-d=20-15=5
    
    add AL, CL ; AL=AL+CL=21+5=26
    
    
    PUSH dword 0
    call [exit]


