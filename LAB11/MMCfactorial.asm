bits 32                         

global MMCfactorial

MMCfactorial:


	mov eax, 1
	mov ecx, [esp + 4]
	
	.repet: 
		mul ecx
	loop .repet
    
   
    
	ret 4 ; 4 reprezinta numarul de octeti ce trebuie eliberati de pe stiva (parametrul pasat procedurii)