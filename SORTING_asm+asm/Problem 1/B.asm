bits 32

global B

segment  data use32 public code

B:

;ESP - return address
;ESP + 4 - [counter]
;ESP + 8 - numbers
;ESP + 12 - sorted_numbers

    mov DX, 1
    while_:
        cmp DX, 0  ; if DX=0 then it means that there was no change in the last parse of the                
        je the_end ; string, so we exit the loop because the string is sorted ascending
        mov ESI, [ESP + 8]  ; prepare the parsing of string "numbers"; set the starting offset in ESI
        mov DX, 0  ; initialize DX
        mov ECX, [ESP + 4]
        sub ECX, 1  ; parse string "numbers" in a loop with len-1 iterations
        cld
        repeat_:
            mov EAX, dword[ESI] ; EAX = numbers[i]
            cmp EAX, dword[ESI + 4] ; We compare numbers[i] with numbers[i + 1]
            jle next ; We use jle because we want to do signed comparison
            
                     ; If numbers[i] <= numbers[i + 1] we move to the next iteration
                     ;Otherwise we interchange numbers[i] with numbers[i + 1] in the following three instructions
                     
            mov EBX, dword[ESI + 4]
            mov dword[ESI], EBX
            mov dword[ESI + 4], EAX
            mov DX, 1
            next:
            add ESI, 4 ; We move to the next dword in the string "numbers"
            loop repeat_ ; We resume repeat_ if we didn't reach the end of the stirng "numbers"
            jmp while_  ; Otherwise we resume the while_ cycle
    the_end:
        ret