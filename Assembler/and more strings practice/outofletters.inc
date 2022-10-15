outOfLetters proc arg1:dword, arg2:dword, arg3:dword, arg4:dword
	pushad
	
	mov   ebx, arg1         	; ebx - string
	mov   ecx, arg4				; dl  - 1 letter
	mov   dl,  byte ptr[ecx]
	mov   ecx, arg3				; dh  - 2 letter edx
	mov   dh,  byte ptr[ecx]
	mov   ecx, arg2				; cl  - 3 letter ecx
	mov   cl,  byte ptr[ecx]
	
addmetka:
	cmp   byte ptr[ebx], 0
	jz    addout
	cmp   byte ptr[ebx], dl
	jz    addlet
	cmp   byte ptr[ebx], dh
	jz    addlet
	cmp   byte ptr[ebx], cl
	jz    addlet
	inc   ebx
	jmp   addmetka
addlet:
	mov   ch, byte ptr[ebx]
	mov   byte ptr[eax], ch
	inc   eax
	inc   ebx
	jmp   addmetka
addout:	
	mov   byte ptr[eax],0

	popad
	ret
outOfLetters endp