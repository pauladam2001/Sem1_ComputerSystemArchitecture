bits 32

global A

segment data use32 class=data
    destination dw 0

segment code use32 class=code


A:

; ESP - return address
; ESP + 4 - initial string
; ESP + 8 - destination string
; ESP + 12 - length

    mov ESI, [ESP + 4]
    mov EDI, [ESP + 8]
    mov ECX, [ESP + 12]
    cld
    for_every_double_word:
        lodsb
        lodsb
        stosb
        lodsb
        lodsb
        stosb
    loop for_every_double_word
    
    ret