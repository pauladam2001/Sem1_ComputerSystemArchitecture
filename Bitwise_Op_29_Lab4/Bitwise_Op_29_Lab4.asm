bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
                          
;Given the doublewords A and B, obtain the quadword C as follows:
;the bits 0-7 of C are the same as the bits 21-28 of A
;the bits 8-15 of C are the same as the bits 23-30 of B complemented
;the bits 16-21 of C have the value 101010
;the bits 22-31 of C have the value 0
;the bits 32-42 of C are the same as the bits 21-31 of B
;the bits 43-55 of C are the same as the bits 1-13 of A
;the bits 56-63 of C are the same as the bits 24-31 of the result A XOR 0ABh

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    A dd 11010011010110001100100110011011b
    B dd 01001000101101011001000110110110b
    C resq 1

; our code starts here
segment code use32 class=code   ; the result will be stored in EDX:EBX
    start:
        ;handle EBX
        
        mov EBX, 0 ; we compute the result in EDX:EBX
        
        mov EAX, [A]
        and EAX, 00011111111000000000000000000000b ; we isolate bits 21-28 of A
        
        mov CL, 21 ; the number of 0s at the end of EAX
        ror EAX, CL ; we rotate 21 position to right
        or EBX, EAX ; the bits 0-7 of C are the same as the bits 21-28 of A
        
        mov EAX, [B]
        not EAX ; B complemented
        
        and EAX, 01111111100000000000000000000000b ; we isolate bits 23-30 of B complemented
        
        mov CL, 16 ; to be positioned at bits 8-15
        ror EAX, CL ; we rotate 16 position to right
        or EBX, EAX ; the bits 8-15 of C are the same as the bits 23-30 of B complemented
        
        or EBX, 00000000001010100000000000000000b ; the bits 16-21 of C have the value 101010
        
        or EBX, 00000000000000000000000000000000b ; the bits 22-31 of C have the value 0
        
               
        ;handle EDX
        
        mov EDX, 0 ; we compute the result in EDX:EBX
        
        mov EAX, [B]
        and EAX, 11111111111000000000000000000000b ; we isoalte bits 21-31 of B
        
        mov  CL, 21 ; the number of 0s at the end of EAX
        ror EAX, CL ; we rotate 21 position to right
        or EDX, EAX ; ;the bits 32-42 of C are the same as the bits 21-31 of B
        
        mov EAX, [A]
        and EAX, 00000000000000000011111111111110b ; we isolate bits 1-13 of A
        
        mov CL, 11 ; to be positioned at bits 43-55 (bits 11-33 in EDX)
        rol EAX, CL ; we rotate 11 position to left
        or EDX, EAX ; the bits 43-55 of C are the same as the bits 1-13 of A
        
        mov EAX, [A]
        ;0ABh = 00000000000000000000000010101011b
        ;xor EAX, 00000000000000000000000010101011b ; ECX = A xor 0ABh
        xor EAX, 0ABh
        and EAX, 11111111000000000000000000000000b ; we isolate bits 24-31 of A xor 0ABh
        
        or EDX, EAX ;the bits 56-63 of C are the same as the bits 24-31 of the result A XOR 0ABh
        
        mov [C], EBX
        mov [C+4], EDX     ;we move the result from EDX:EBX to C
      
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
