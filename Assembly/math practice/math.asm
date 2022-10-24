.586
.model flat, stdcall
option casemap: none
;#########################################################################
	include    \masm32\include\windows.inc
	include    \masm32\include\user32.inc
	include    \masm32\include\kernel32.inc
	include    \masm32\include\Prototypes.inc

	includelib \masm32\lib\user32.lib
	includelib \masm32\lib\kernel32.lib
	includelib \masm32\lib\InputBox.lib
;#########################################################################
	.data
		MsgBoxName    	db "MASM32 Prog",0
;#GENERAL TEXT 	
		InputBoxName    db "Ввод строки",0
		InputBoxTextFir db "Пожалуйста, введите количество итераций",0
;#OUTPUT		
		Format1         db    "Сумма ряда: ",0
		Format2			db 13,"Количество итераций: ",0
		Format3         db 13,"Хотите ввести новые данные?",0
		dot				db    ".",0
;#VARIABLES		
		FirstString   	db 50  dup (0)
		ResString   	db 255 dup (0) 
		ValueLength  	db 255 dup (0)
		mode            db 0
		cnt				dd 0
;#ERRORS	
		ErrCaption      db "Error",0
		ValueInputError db "You have not entered a value", 13, "Re-enter?",0
		DefLengthError  db "You have entered too many characters!", 13, "Re-enter?",0
			
;#########################################################################	
	.code
include   \masm32\include\str.inc
start:
	mov    	mode, 1
	invoke 	InputBox, addr InputBoxTextFir, addr InputBoxName, addr FirstString
	test   	eax, eax                 	; empty check
	jz 	   	errValueInput  				
	cmp    	eax, 50                  	; length check
	ja     	errDefLength	  			; over 50

	push	offset FirstString
	push	offset cnt
	call	StrToInt
	
	push	cnt							; counter
	inc		cnt
	
	mov		ebx, 1						; ebx - initial value of two
	push	eax							; random number
sum_beg:
	dec		cnt
	cmp		cnt, 0
	jz		sum_end
	
	add 	ebx, ebx					; ebx - degree of two / denominator
	
	mov		eax, ebx
	add		eax, eax					; Numerator eax
	dec		eax
	
	mov		edx, 0
	mov		ecx, 10000					; accuracy
	mul		ecx	
	div		ebx
	
	pop		ecx
	push	eax
	cmp		ecx, eax
	jnz		sum_beg
sum_end:
	pop 	edx	
	mov 	edx, 0
	mov 	ecx, 10000
	div		ecx
	
	push	cnt

	mov		cnt, eax
	push	offset cnt
	push	offset ValueLength
	call	IntToStr
	
	mov		cnt, edx
	push	offset cnt
	push	offset FirstString
	call	IntToStr
	
	push	offset ResString
	push	offset Format1
	push	offset ValueLength
	push	offset dot
	push	offset FirstString
	call	Concatenatio
	
	pop		eax
	pop		ecx
	sub		ecx, eax
	mov		cnt, ecx

	push	offset cnt
	push	offset FirstString
	call	IntToStr
	
	push	offset ValueLength
	push	offset ResString
	push	offset Format2
	push	offset FirstString
	push	0
	call	Concatenatio
	
	invoke 	MessageBox, NULL, addr ValueLength, addr MsgBoxName, MB_YESNO
	
	cmp    	eax, IDYES
	jz     	start
	jmp    	exit	
	
errDefLength:						; error handling
	invoke 	MessageBox, NULL, addr DefLengthError, addr ErrCaption, MB_RETRYCANCEL + MB_ICONERROR
	jmp    	errRet
	
errValueInput:
	invoke 	MessageBox, NULL, addr ValueInputError, addr ErrCaption, MB_RETRYCANCEL + MB_ICONERROR	
	jmp    	errRet

errRet:								; return processing
	cmp    	EAX, 4
	jz     	defmode
	jmp    	exit
defmode:
	cmp    	mode,1
	jz     	start
	jmp    	start

exit:
	invoke 	ExitProcess, NULL
	
end start