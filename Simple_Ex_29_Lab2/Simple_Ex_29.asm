bits 32

global start
extern exit
import exit msvcrt.dll

segment data use32 class=data

segment code use32 class=code

start:  ; 14/6
    mov AX, 14 ; AX=14
    MOV BL, 6 ; BL=6
    DIV BL ; AL=AX/BL, AH=AX%BL
    
    PUSH dword 0
    call [exit]



    