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
	
	mov		eax, 0				; al - счетчик подстроки
	mov		edx, 0				; dh - счетчик строки
	mov		ebx, mainline		; ЕВХ строка
	mov		ecx, outline		; ЕСХ подстрока
	push	ecx					
	
strpos_beg:
	mov		dl, byte ptr[ebx]
	cmp		dl, byte ptr[ecx]	; сравнение букв
	jz		strpos_inc			; выбор решения
	jmp		strpos_dec
	
strpos_inc:
	inc		al					; совпала буква
	inc		ecx					; следующая буква подстроки
	jmp		strpos_skip			; счетчик строки++
	
strpos_dec:
	cmp		al, 0				; несовпала вообще
	jz		strpos_skip			
	
strpos_dec_part2:
	pop		ecx
	push	ecx					; несовпала на середине
	mov		al, 0				; слова, повтор проверки
	jmp		strpos_beg			; первой буквы
	
strpos_skip:
	inc		ebx					; некст буква строки		
	inc		dh					; счетчик строки++
strpos_chek:
	cmp		byte ptr[ebx], 0
	jz		strpos_chek2		; конец строки, но что с substr
	cmp		byte ptr[ecx], 0
	jz		strposGoodEnd		; если кончилась substr, то это хорошо
	jmp		strpos_beg

strpos_chek2:
	cmp		byte ptr[ecx], 0	; кончилась substr + str = gg
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
	mov		eax, dword ptr[ebx]		; берем число в числитель
	mov		ebx, 0
	mov 	ecx, 0					; обнуление
	mov 	edx, 0
	
met:
	inc		bl						; счетчик символов
	mov		ecx, 10					; знаменатель 10
	div		ecx						; делим
	push 	edx						; в стек остаток
	mov		edx, 0					; чистим пару axdx
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
	mov		dword ptr[eax], 0		; очищаем переменную
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
	
	mov    	eax, 0					; eax - счетчик символов
	mov    	edx, outarg				; edx - итоговая строка
	mov    	ebx, arg1				; ebx - переменная строка
	mov    	ecx, 0					; ecx - счетчик строк
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