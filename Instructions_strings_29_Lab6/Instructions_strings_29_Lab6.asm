bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
                          
                          
;Two strings of bytes A and B are given. Parse the shortest string of those two and build a third string C as follows:
;up to the lenght of the shortest string C contains the largest element of the same rank from the two strings
;then, up to the length of the longest string C will be filled with 1 and 0, alternatively.


; our data is declared here (the variables needed by our program)
segment data use32 class=data
    A db 25, 230, 8, 15
    lengthA equ $-A ; compute the length of the string A in lengthA
    B db 220, 46, 163, 6, 29, 130
    lengthB equ $-B ; compute the length of the string B in lengthB
    C times lengthA+lengthB db 0 ; reserve lengthA+lengthB bytes for the destination string and initialize it

; our code starts here
segment code use32 class=code
    start:
        
        mov EAX, lengthA ; we put the length of A in EAX
        mov EBX, lengthB ; we put the length of B in EBX
        
        cmp EAX, EBX ; we compare the lengths to establish which string is shorter
        jb short_string_A ; if A is shorter 
        jae short_string_B ; if B is shorter
        
        short_string_A: ; if A is the shorter string
        
        mov ESI, A ; in DS:ESI we will store the FAR address of the string "A"
        mov EDI, C ; in ES:EDI we will store the FAR address of the string "C"
        cld ; parse the string from left to right(DF=0)
        mov ECX, lengthA ; we will parse the elements of the string in a loop with lengthA iterations
        mov EBX, 0 ; so we can parse string B also
        
        loop_A_short:
                lodsb ; the byte from the address DS:ESI (A) is loaded in AL
                mov DL, [B+EBX] ; in DL we have the byte from the current position of B
                cmp AL, DL ; we compare AL with DL to establish which element is larger
                ja introduce_elem_A ; if AL is larger
                
                ; here if AL<the current element in B ; we need to introduce DL in C, so we move DL in AL then call STOSB
                mov AL, DL
                stosb ; store AL into the byte from the address ES:EDI (in C)
                jmp next_element_loop_A_short ; used to jump over introduce_elem_A
                
                introduce_elem_A:
                       stosb ; store AL into the byte from the address ES:EDI (current position of C)
                
                next_element_loop_A_short:
                
                inc EBX ; increment the current position of B
                
        loop loop_A_short
        
        mov ECX, lengthB ; C has lengthB positions unfilled (because lengthB>lengthA in the actual case)
        mov AL, 1 ; the unfilled positions are filled with 1 and 0, alternatively
        loop_B:
                stosb ; store AL into the byte from the address ES:EDI (in C)
                cmp AL, 1 ; check if AL=1 or AL=0
                jne AL_is_0_B ; if AL=0 
                
                ; here if AL=1
                mov AL, 0
                jmp next_iteration_loop_B ; used to jump over AL_is_0
                
                AL_is_0_B:
                    mov AL, 1
                
                next_iteration_loop_B:
          
        loop loop_B
        
        jmp Final
        
        short_string_B: ; if B is the shorter string, same instructions as in short_string_A, but B=A and A=B
        
        mov ESI, B ; in DS:ESI we will store the FAR address of the string "B"
        mov EDI, C ; in ES:EDI we will store the FAR address of the string "C"
        cld ; parse the string from left to right(DF=0)
        mov ECX, lengthB ; we will parse the elements of the string in a loop with lengthB iterations
        mov EBX, 0 ; so we can parse string A also
        
        loop_B_short:
                lodsb ; the byte from the address DS:ESI (B) is loaded in AL
                mov DL, [A+EBX] ; in DL we have the byte from the current position of A
                cmp AL, DL ; we compare AL with DL to establish which element is larger
                ja introduce_elem_B ; if AL is larger
                
                ; here if AL<the current element in B ; we need to introduce DL in C, so we move DL in AL then call STOSB
                mov AL, DL
                stosb ; store AL into the byte from the address ES:EDI (in C)
                jmp next_element_loop_B_short ; used to jump over introduce_elem_B
                
                introduce_elem_B:
                       stosb ; store AL into the byte from the address ES:EDI (current position of C)
                
                next_element_loop_B_short:
                
                inc EBX ; increment the current position of A
                
        loop loop_B_short
        
        mov ECX, lengthA ; C has lengthA positions unfilled (because lengthA>lengthB in the actual case)
        mov AL, 1 ; the unfilled positions are filled with 1 and 0, alternatively
        loop_A:
                stosb ; store AL into the byte from the address ES:EDI (in C)
                cmp AL, 1 ; check if AL=1 or AL=0
                jne AL_is_0_A ; if AL=0 
                
                ; here if AL=1
                mov AL, 0
                jmp next_iteration_loop_A ; used to jump over AL_is_0
                
                AL_is_0_A:
                    mov AL, 1
                
                next_iteration_loop_A:
          
        loop loop_A        
    
        Final:
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
