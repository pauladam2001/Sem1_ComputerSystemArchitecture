bits 32

global start
extern exit
import exit msvcrt.dll


segment data use32 class=data  ; a,b,c - byte, d - word
    a DB 25
    b DB 83
    c DB 100
    d DW 11500
    
    
segment code use32 class=code

start:  ; [d-(a+b)*2]/c
    mov AL, [a] ; AL=a=25
    add AL, [b] ; AL=AL+b=25+83=108
    mov DL, 2 ; DL=2
    mul DL ; AX=AL*DL=108*2=216
    mov CX, [d] ; CX=d=11500
    sub CX, AX ; CX=CX-AX=11500-216=11284  // [d-(a+b)*2]
    
    mov AX, CX ; AX=CX=11284
    div BYTE [c] ; AL=AX/c, AH=AX%c
    
    PUSH dword 0
    call [exit]