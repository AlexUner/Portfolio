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
		InputBoxText	db "Variable n",0
		MessageBoxName	db "Formula",0
		MessageBoxText	db " (2n)",13,"------ + m!",13,"(n-1)!",0
;#OUTPUT		
		lb				db    "{ (2 * ", 0
		mexp			db	  ") / (",  0
		blb				db    " - 1)! }",0
		bexp			db	  " + ",  0
		brb				db	  "! = ", 	  0
		dot				db    ".",    0
;#VARIABLES	
		DopString2   	db 255 dup (0)	
		DopString   	db 255 dup (0)
		ResString   	db 255 dup (0) 
		InputValue  	db 255 dup (0)
		ost   			db 5   dup (0)
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
include   \masm32\include\math.inc
start:
	invoke 	MessageBox, NULL, addr MessageBoxText, addr MessageBoxName, MB_OK
s:
	invoke  InputBox, addr InputBoxText, addr InputBoxName, ADDR InputValue
	
	push	offset InputValue			; -----------------
	call	chk							;
	cmp		eax, 16						;
	jnz		errInput					; numerical check
	
	push	offset InputValue			; ------------
	push	offset integer				;
	call	StrToInt					;
	cmp		integer, 12					;
	ja		errCountError				; number size
		
	mov		eax, offset InputBoxText	; ------------
	dec 	byte ptr[eax+11]			; 
	inc		mode						; letter substitution
	
	mov		eax, offset InputValue		; ---------------------------------
	mov		byte ptr[eax], 0			; zeroing the variable to check
s_ret:
	cmp		mode, 1
	jnz		s_out
s1:
	mov		ebx, integer				; ebx - n
	jmp		s
s_out:
	mov		ecx, integer				; ecx - m
	
	mov		mode, 0						; ----------------
	mov		eax, offset InputBoxText	;
	add 	byte ptr[eax+11],2			; value return
	
	cmp		ebx, 1						; denominator error
	jle		errNull
;#####################################################################SKIP	
	mov		integer, ebx
	m_its	integer, InputValue
	
	mov		integer, ecx
	m_its	integer, DopString
	
	m_cnc 	ResString, lb, InputValue, mexp, InputValue ; { (2*n)/(n
	m_cnc	InputValue, ResString, blb, bexp, DopString ; { (2*n)/(n|-1)! } + m
	m_cnc 	ResString,InputValue,brb, 0, 0				; { (2 * n) / (n - 1)! } + m|! =
;#####################################################################SKIP
	
	push	ecx
	
	mov		edx, 0						; -------------------
	mov		eax, ebx					;
	mov		ecx, 20000					; *10 000
	mul		ecx							; form the numerator
	
	mov		ecx, offset integer			; ---------------------
	dec		ebx							;
	mov		dword ptr[ecx], ebx			;
	m_fact	integer					;
	mov		ebx, dword ptr[ecx]			; form the denominator
	
	div		ebx							; eax - first expression
	mov		edx, 0
	mov		ebx, 10000
	div		ebx	
	
	pop		ecx
	mov		ebx, offset integer
	mov		dword ptr[ebx], ecx
	m_fact	integer
	mov		ecx, dword ptr[ebx]
	add		ecx, eax
	
	mov		integer, ecx
	m_its	integer, DopString
	
	add		edx, 10000
	mov		integer, edx
	m_its	integer, ost
	m_sstr  ost, 1, 4, DopString2
	m_cnc	InputValue, ResString, DopString, dot, DopString2
	
	invoke 	MessageBox, NULL, addr InputValue, addr MessageBoxName, MB_YESNO	
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