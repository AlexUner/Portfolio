m_fact macro num
	push 	offset num	
	call	fact
endm
;#####################################################################
fact proc num:dword
	pusha
	
	mov		edx, 0
	mov		ecx, num
	mov		eax, dword ptr[ecx]
	mov		ebx, eax
	dec		ebx
	
fact_met:
	cmp		ebx,0
	jz		fact_end
	mul		ebx
	dec		ebx
	jmp		fact_met
fact_end:
	
	mov		dword ptr[ecx], eax
	
	popa
	ret
fact endp
;#####################################################################
m_evc macro num1, num2
	push 	offset num2
	push 	offset num1	
	call	evc
endm
;#####################################################################
evc proc num1:dword, num2:dword
	pusha
	
	mov		eax, num1
	mov		ebx, dword ptr[eax]	; ebx - less
	mov		ecx, num2
	mov		eax, dword ptr[ecx] ; eax - more
	mov 	edx, 0
	mov		ecx, 0 ;;;;;;;;;;;;;;;;;;;;;;;;
		
evc_cmp:
	cmp		eax, ebx
	ja		evc_bebt
	xchg	eax, ebx
evc_bebt:
	inc		ecx
	div		ebx
	cmp		edx, 0
	jz		evc_end
	mov		eax, ebx
	mov		ebx, edx
	mov		edx, 0
	jmp		evc_cmp	
evc_end:
	mov		eax, num1
	mov		dword ptr[eax], ebx 
	mov		eax, num2				;;;;;;;;;;;;;;;;;;;
	mov		dword ptr[eax], ecx 	;;;;;;;;;;;;;;;;;;;
	
	popa
	ret
evc endp




