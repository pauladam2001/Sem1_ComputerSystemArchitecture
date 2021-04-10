bits 32

global B

segment data use32 class=data

    counter dd 0
    sum_of_bits dd 0
segment code use32 class=code

B:

; ESP - return address
; ESP + 4 - destination_string
; ESP + 8 - length
    mov ESI, [ESP + 4]
    mov ECX, [ESP + 8]
    cld
    for_every_word:
        mov dword[counter], 0
        lodsw
        push ECX
        mov ECX, 16
        for_every_byte:
            shl AX, 1
            jnc continue
            inc dword[counter]
            continue:
            loop for_every_byte
        pop ECX
        mov EDX, dword[counter]
        add [sum_of_bits], EDX
    loop for_every_word
    mov EAX, [sum_of_bits]
    ret