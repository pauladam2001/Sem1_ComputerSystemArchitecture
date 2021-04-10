bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

extern changeChar
; declare external functions needed by our program
extern exit, printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import printf msvcrt.dll


; We will use 2 modules for this problem. The main one and the one that has the procedure 'changeChar'. The modules communicate one with another through global and extern directives. We export the 'changeChar' procedure through global and we import it in main through extern. The informations between modules are exchanged using the stack and the EAX register (return). In order to solve this problem, firstly we parse s1 and s2 simultaneously and for every character in s1 (excepting commas) we will call the procedure 'changeChar' in order to form s3. Afther that, we parse s3 and form an array of frequencies and after that we will parse that array in order to find the maximum number of appearences. In the end, we will print on the screen that maximum.


; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ;s1 db 'ana,are,mere,eu,nu,mai,am'
    ;s1 db 'ppp,ppp,mppp,pp,pp,ppp,pp'
    s1 db 'pqp,pp'
    ;s2 db '---,&--,&---,--,&-,&&&,--'
    ;s2 db '---,---,&---,--,--,---,--'
    s2 db '---,--'
    len equ $-s2
    s3 times len db 0
    index dd 0
    frecv times 25 db 0
    max db 0
    format db "%u", 0

; our code starts here
segment code use32 class=code
    start:
    
        mov ESI, s1
        mov EBX, 0
        mov ECX, len
        mov EDI, s3
        parse_s1:               ; we parse s1 and s2 simultaneously in order to form s3
                mov EAX, 0
                lodsb
                cmp AL, ','     ; if the character is a comma we let it like that
                je continue
                
                mov EDX, 0              ; here if the character is not a comma
                mov DL, [s2 + EBX]
                mov dword [index], EBX  ; put the actual index
                inc EBX
                
                push EAX    ; c         ; push the letter
                push EDX    ; op        ; push the '-' or '&' from s2
                push dword [index] ;n   ; push the index
                call changeChar
                add ESP, 4*3
                
                stosb ; in AL we will have the changed char
                jmp next
                
                continue:
                    stosb   ; in AL we will put the comma
                    inc EBX
                    
                next:
                
            loop parse_s1
        
        
        mov ESI, s3
        mov ECX, len
        parse_s3:               ; we parse s3 and form the 'frecv' array to see which letters appear in s3 and how many times each letter appears
                mov EAX, 0
                lodsb
                cmp AL, ','     ; if the char is a comma we ignore it
                je next2
                
                sub AL, 'a'                 ; we increase with 1 the position of the actual char
                add byte [frecv + EAX], 1 
                
                next2:
                
            loop parse_s3
    
        mov ESI, frecv
        mov ECX, 25
        parse_frecv:                ; we parse frecv in order to find the letter which appears a maximum number of times
                    lodsb
                    cmp byte [max], AL
                    jbe change_max      ;if the letter appears more than max times we change the max
                    jmp next3
                    
                    change_max:
                            mov byte [max], AL
                    
                    next3:
              
                loop parse_frecv
                
        mov EAX, 0
        mov AL, [max]
        push EAX            ; print the maximum number of appearences in the console
        push format
        call [printf]
        add ESP, 4*2
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
