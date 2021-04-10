bits 32
segment code use32 public code

global function

extern fprintf, fscanf
import fprintf msvcrt.dll
import fscanf msvcrt.dll

segment data use32 class=data
    numberToRead dd 0
    number_type db "%u", 0
    char_space db "%c", 0
    file_descriptor1 dd -1
    file_descriptor2 dd -1
  
function:

        mov ESI, [ESP + 4] ;stringWithNumbersInBase2
        mov EAX, [ESP + 12]
        mov EBX, [ESP + 8]
        mov [file_descriptor1], EAX
        mov [file_descriptor2], EBX
        ;mov dword [file_descriptor1], [ESP + 12]
        ;mov dword [file_descriptor2], [ESP + 8]
        

        .readNumbers:
                    
                    push dword numberToRead
                    push dword number_type
                    push dword [file_descriptor1]
                    call [fscanf]                   ;read a number from the file
                    add ESP, 4*3
                    
                    cmp EAX, -1         ;check if there are numbers in the file
                    je .outOfLoop

                    
                    mov EDX, 0
                    mov EAX, [numberToRead]
                    
                    mov EBX, 2
                    mov EDI, 0
                    .formBase2:
                            div EBX ; EAX = EDX:EAX/2, EDX = EDX:EAX%2
                            mov [ESI + EDI], EDX
                            add EDI, 1 ; the rest will be 0 or 1, a byte        ;form the number in base 2
                            mov EDX, 0
                            
                            cmp EAX, 0
                            jne .formBase2
                    sub EDI, 1
                    .printString:
                              mov EAX, 0
                              mov AL, [ESI + EDI]
                              push EAX
                              push dword number_type                            ;print the numbers in base 2 (in reverse order is the correct order)
                              push dword [file_descriptor2]
                              call [fprintf]
                              add ESP, 4*3
                              dec EDI
                              cmp EDI, 0
                              jge .printString
                    
                    push dword " "
                    push dword char_space
                    push dword [file_descriptor2]       ;print a space between numbers
                    call [fprintf]
                    add ESP, 4*3
                    
                    
                    mov EDX, 0
                    mov ECX, 25
                    .clearTheWords:
                            mov dword [ESI + EDX], 0       ;clear the variable where we store the number
                            add EDX, 4
                        loop .clearTheWords
                    
            jmp .readNumbers
            
        .outOfLoop:
   ret