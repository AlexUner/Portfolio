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
		InputBoxName    db "Variable entry",0
		InputBoxText	db "Variable a",0
		MessageBoxName	db "Formula",0
		MessageBoxText	db "(a^2 + b^2)",13,"---------------",13,"   (c - d^2)",0
;#OUTPUT		
		Format1         db    "The sum of the series: ",0
		Format2         db 13,"Хотите ввести новые данные?",0
		lb				db    "(",      0
		mexp			db	  "^2 + ",  0
		blb				db    "^2) / (",0
		bexp			db	  " - ",    0
		brb				db	  ")^2 = ", 0
		dot				db    ".",      0
;#VARIABLES		
		DopString   	db 255 dup (0)
		DopString2   	db 255 dup (0)
		ResString   	db 255 dup (0) 
		InputValue  	db 255 dup (0)
		mode            db 0
		integer			dd 0
;#ERRORS	
		ErrCaption      db "Error",0
		InputError 		db "Enter positive numbers!!!", 13, "Re-enter?",0
		NullError		db "Zero in the denominator happened",13, "Re-enter?",0
		CountError  	db "You want too much!", 13, "Re-enter?",0			
			
;#########################################################################	
	.code
include   \masm32\include\str.inc
start:
	invoke 	MessageBox, NULL, addr MessageBoxText, addr MessageBoxName, MB_OK
s:
	invoke  InputBox, addr InputBoxText, addr InputBoxName, ADDR InputValue
	
	push	offset InputValue
	call	chk
	cmp		eax, 16
	jnz		errInput
	
	push	offset InputValue
	push	offset integer
	call	StrToInt
	cmp		integer, 7530h
	ja		errCountError
	
	mov		eax, offset InputBoxText
	inc 	byte ptr[eax+11]
	inc		mode
	
	mov		eax, offset InputValue
	mov		byte ptr[eax], 0
s_ret:
	cmp		mode, 1
	jz		s1
	cmp		mode, 2
	jz		s2
	cmp		mode, 3
	jz		s3
	jmp		s_out
s1:
	push	integer
	jmp		s
s2:
	mov		ebx, integer
	jmp		s
s3:
	mov		ecx, integer
	jmp		s
s_out:
	mov		mode, 0
	mov		edx, integer
	mov		eax, offset InputBoxText
	sub 	byte ptr[eax+11],4
	pop		eax
	
	cmp		ecx, edx
	jz		errNull
	
	push	eax
;#####################################################################SKIP	
	mov		integer, eax
	push	offset integer
	push	offset InputValue
	call	IntToStr
	
	mov		integer, ebx
	push	offset integer
	push	offset DopString
	call	IntToStr
	
	push	offset ResString
	push	offset lb			; (
	push	offset InputValue	; a
	push	offset mexp			; ^2 + 
	push	offset DopString	; b
	call 	Concatenatio
	
	mov		integer, ecx
	push	offset integer
	push	offset InputValue
	call	IntToStr
	
	mov		integer, edx
	push	offset integer
	push	offset DopString2
	call	IntToStr
	
	push	offset DopString	
	push	offset ResString	; (a^2 + b
	push	offset blb			; ^2) / (
	push	offset InputValue	; c
	push	offset bexp			;  - 
	call	Concatenatio
	
	push	offset ResString
	push	offset DopString	; (a^2 + b^2) / (c - 
	push	offset DopString2	; d
	push	offset brb			; )^2 = 
	push	0
	call	Concatenatio
;#####################################################################SKIP	
	pop		eax
	push	edx
	
	mul		eax
	push	eax
	mov		eax, ebx
	mul		ebx
	pop		ebx
	add 	ebx, eax			; ebx - numerator
	
	pop		edx
	
	cmp		ecx, edx
	ja		plus	
minus:
	sub		edx, ecx
	mov		eax, edx
	jmp		next
plus:
	sub		ecx, edx
	mov		eax, ecx
next:
	mul		eax	
	
	xchg 	eax, ebx			; eax - numerator, ebx
	
	mov		ecx, 10000
	mul		ecx
	
	mov		edx,0
	div		ebx	
	
	mov		edx,0
	mov		ebx, 10000
	div		ebx
	
	mov		integer, eax
	push	offset integer
	push	offset InputValue
	call	IntToStr
	
	mov		integer, edx
	push	offset integer
	push	offset DopString
	call	IntToStr
	
	push	offset DopString2
	push	offset ResString
	push	offset InputValue
	push	offset dot
	push	offset DopString
	call 	Concatenatio
	
	invoke 	MessageBox, NULL, addr DopString2, addr MessageBoxName, MB_YESNO	
	cmp    	eax, IDYES
	jz     	start
	jmp    	exit	

;#########################################################################	
errInput:	; error handling
	invoke 	MessageBox, NULL, addr InputError, addr ErrCaption, MB_RETRYCANCEL + MB_ICONERROR	
	jmp    	errRet
	
errCountError:
	invoke 	MessageBox, NULL, addr CountError, addr ErrCaption, MB_RETRYCANCEL + MB_ICONERROR	
	jmp    	errRet
	
errNull:
	invoke 	MessageBox, NULL, addr NullError, addr ErrCaption, MB_RETRYCANCEL + MB_ICONERROR	
	jmp    	errRet
	
errRet:								; return processing
	cmp    	EAX, 4
	jz     	s

exit:
	invoke 	ExitProcess, NULL
	
end start