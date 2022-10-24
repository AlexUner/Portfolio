chk proc chkline:dword
	pusha
	
	mov		eax, 0	
	mov		edx, chkline
chk_emptystr:
	cmp		byte ptr[edx], 0
	jnz		chk_alphabet
	mov		ebx, 1
	or		eax, ebx
	jmp		chk_endAlphabet
	
chk_alphabet:
	mov		cl,	byte ptr[edx]
	cmp		cl, 0
	jz		chk_endAlphabet
	cmp		cl, 32
	jz		chk_space
	cmp		cl, 97
	jae		chk_lil_a
	cmp		cl,	65
	jae		chk_A
	cmp		cl,	48
	jae		chk_N
	jmp		chk_alphabet

chk_N:
	cmp		cl,	57
	jnle	chk_skip
	mov		ebx, 16
	or		eax, ebx
	jmp		chk_skip

chk_lil_a:
	cmp		cl,	122
	jnle	chk_skip
	mov		ebx, 10
	or		eax, ebx
	jmp		chk_skip
	
chk_A:
	cmp		cl,	90
	jnle	chk_skip
	mov		ebx, 6
	or		eax, ebx
	jmp		chk_skip
	
chk_space:
	mov		ebx, 32
	or		eax, ebx
	jmp		chk_skip
	
chk_skip:
	inc		edx
	jmp		chk_alphabet
	
chk_endAlphabet:
	mov		chkline, eax
	popa
	mov		eax, chkline
	ret
chk endp
;#####################################################################
strpos proc mainline:dword, outline:dword
	pusha
	
	mov		eax, 0				; al - substring counter
	mov		edx, 0				; dh - string counter
	mov		ebx, mainline		; ЕВХ string
	mov		ecx, outline		; ЕСХ substring
	push	ecx					
	
strpos_beg:
	mov		dl, byte ptr[ebx]
	cmp		dl, byte ptr[ecx]	; letter comparison
	jz		strpos_inc			; selection of a solution
	jmp		strpos_dec
	
strpos_inc:
	inc		al					; matched letter
	inc		ecx					; the next letter of the substring
	jmp		strpos_skip			; string counter++
	
strpos_dec:
	cmp		al, 0				; mismatched at all
	jz		strpos_skip			
	
strpos_dec_part2:
	pop		ecx
	push	ecx					; mismatched in the middle
	mov		al, 0				; words, re-checking
	jmp		strpos_beg			; the first letter
	
strpos_skip:
	inc		ebx					; next letter of the string		
	inc		dh					; string counter++
strpos_chek:
	cmp		byte ptr[ebx], 0
	jz		strpos_chek2		; end of line, but what about substr
	cmp		byte ptr[ecx], 0
	jz		strposGoodEnd		; if you run out of substr, that's a good thing
	jmp		strpos_beg

strpos_chek2:
	cmp		byte ptr[ecx], 0	; ended substr + str = gg
	jz		strposGoodEnd
	
strposBadEnd:
	mov		outline, -1
	jmp		strpos_exit
	
strposGoodEnd:
	sub		dh, al
	mov		al, dh
	inc		al
	dec		eax
	mov		outline, eax
	
strpos_exit:
	pop		ecx
	popa
	mov		eax, outline
	ret
strpos endp
;#####################################################################
m_sstr macro mainline, index, count, outline 
	push	offset outline
	push	count
	push	index
	push	offset mainline
	call	sub_str
endm
;#####################################################################
sub_str proc mainline:dword, index:dword, count:dword, outline:dword
	pusha
	
	mov		eax, outline
	mov		ebx, mainline
	mov		ecx, index
	mov		edx, count
ror_:
	cmp		byte ptr[ebx], 0
	jz		metout
	cmp		ecx, 0
	jz		submet
	dec		ecx					
	inc		ebx
	jmp		ror_
	
submet:
	cmp		byte ptr[ebx],0
	jz		metout
	cmp		edx, 0
	jz		metout
	mov		cl,	byte ptr[ebx]
	mov		byte ptr[eax], cl
	inc		eax
	inc		ebx
	dec		edx
	jmp		submet
	
metout:	
	inc		eax
	mov		byte ptr[eax], 0	
	popa
	ret
sub_str endp
;#####################################################################
m_its macro num, str_ 
	push	offset num
	push	offset str_
	call	IntToStr
endm
;#####################################################################
IntToStr proc str_:dword, num:dword
	pusha	
	
	mov		ebx, num
	mov		eax, dword ptr[ebx]		; take the number in the numerator
	mov		ebx, 0
	mov 	ecx, 0					; zeroing
	mov 	edx, 0
	
met:
	inc		bl						; character count
	mov		ecx, 10					; denominator 10
	div		ecx						; divide
	push 	edx						; on the stack remainder
	mov		edx, 0					; clear the axdx pair
	cmp		eax, 0
	jnz		met
	
	mov		edx, str_
strMov:

	dec		bl
	pop 	eax
	add		eax, 48
	mov		byte ptr[edx], al
	inc		edx
	cmp		bl, 0
	jnz		strMov
	
	mov		byte ptr[edx], 0
	
	popa
	ret
IntToStr endp
;#####################################################################
m_sti macro  str_, num
	push	offset str_
	push	offset num
	call	StrToInt
endm
;#####################################################################
StrToInt proc num:dword, str_:dword 
	pusha	
	
	mov		eax, num
	mov		dword ptr[eax], 0		; clear the variable
	mov		eax, 0
	
	mov		ecx, str_
smet:
	mov		ebx, 0
	mov		bl, byte ptr[ecx]
	inc		ecx
	cmp		bl, 0
	jz		smetEnd
	
	sub		bl, 48
	pusha
;#########
	mov		ecx, num
	mov		eax, dword ptr[ecx]
	add		eax, ebx
	mov		ebx, 10
	mul		ebx
	mov		ebx, num
	mov		dword ptr[ebx], eax 
;#########
	popa
	jmp		smet
	
smetEnd:
	mov		ecx, num
	mov		eax, dword ptr[ecx]
	mov		edx, 0
	mov		ecx, 10
	div		ecx
	mov		ecx, num
	mov		dword ptr[ecx], eax
	
	popa
	ret
StrToInt endp
;#####################################################################
m_cnc	macro outarg, arg1, arg2, arg3, arg4
	push	offset outarg
	push	offset arg1
	push	offset arg2
	push	offset arg3
	push	offset arg4
	call	Concatenatio
endm
;#####################################################################
Concatenatio proc arg4:dword, arg3:dword, arg2:dword, arg1:dword, outarg:dword
	pusha							; <<
	
	mov    	eax, 0					; eax - character counter
	mov    	edx, outarg				; edx - summary line
	mov    	ebx, arg1				; ebx - variable string
	mov    	ecx, 0					; ecx - row counter
	push   	ecx						; <-
	
f_begin:
	cmp    	ebx, 0
	jz     	f_skip
f_start:
	mov    	cl, byte ptr[ebx]
	mov    	byte ptr[edx], cl 
	inc    	eax
	inc    	ebx
	inc    	edx
	cmp    	byte ptr[ebx],0
	jz     	f_skip
	jmp    	f_start
f_skip:
	pop    	ecx 					; ->
	inc    	ecx
	push   	ecx 					; <- 0 1 2 3
	
	mov    	ebx, arg2
	cmp	   	ecx, 1	
	jz     	f_begin
	
	mov    	ebx, arg3
	cmp	   	ecx, 2	
	jz     	f_begin
	
	mov    	ebx, arg4
	cmp	   	ecx, 3	
	jz     	f_begin
f_out:	
	pop    	ecx						; ->
	mov    	byte ptr[edx],0
	mov    	arg1, eax
	
	popa							; >>
	mov	   	eax, arg1	    
	ret
Concatenatio endp
;#####################################################################
