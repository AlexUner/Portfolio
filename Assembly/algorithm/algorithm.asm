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
		InputBoxName    db "Entering variables for the Euclidian algorithm",0
		InputBoxText	db "Enter the first variable",0,
						   "Enter the second variable",0
		MessageBoxName	db "The Euclidian algorithm",0
;#OUTPUT
		ResText			db "Euclid said that the common divisor is ",0
		ResText1		db ",",13,"and he calculated it in as many moves as ",0
;#VARIABLES
		ResString		db 255 dup(0)
		StrInteger		db 50  dup(0)
		StrInteger1		db 50  dup(0)
		Integer			dd 0
		Integer1		dd 0
		progSection		dd 0			
;#ERRORS	
		ErrCaption      db "Error",0
		InputError 		db "Enter positive numbers!!!", 13, "Re-enter?",0
		NullError		db "You can't use zero!",13, "Re-enter?",0			
			
;#########################################################################	
	.code
include   \masm32\include\str.inc
include   \masm32\include\math.inc
start:
	lea		ebx, StrInteger
	mov		byte ptr[ebx],0
	lea		edx, InputBoxText
	invoke  InputBox, edx, addr InputBoxName, addr StrInteger
	push	offset StrInteger			; -----------------
	call	chk							;
	cmp		eax, 16						;
	jnz		errInput					; numerical check
	
	m_sti	StrInteger, Integer			; ----------------
	cmp		Integer, 0					;
	jz		errNull						; zero check
	
	inc		progSection
s1:
	mov		byte ptr[ebx],0
	lea		edx, InputBoxText
	add 	edx, 26
	invoke  InputBox, edx, addr InputBoxName, addr StrInteger
	push	offset StrInteger			; -----------------
	call	chk							;
	cmp		eax, 16						;
	jnz		errInput					; numerical check
	
	m_sti	StrInteger, Integer1		; ----------------
	cmp		Integer1, 0					;
	jz		errNull						; zero check
	
	mov		progSection, 0
;#########################
	m_evc	Integer, Integer1
	m_its	Integer, StrInteger
	m_its	Integer1, StrInteger1
	m_cnc	ResString, ResText, StrInteger, ResText1, StrInteger1
	
	invoke 	MessageBox, NULL, addr ResString, addr MessageBoxName, MB_YESNO	
	cmp    	eax, IDYES
	jz     	start
	jmp    	exit	

;#########################################################################	
errInput:	; error handling
	invoke 	MessageBox, NULL, addr InputError, addr ErrCaption, MB_RETRYCANCEL + MB_ICONERROR	
	jmp    	errRet
	
errNull:
	invoke 	MessageBox, NULL, addr NullError, addr ErrCaption, MB_RETRYCANCEL + MB_ICONERROR	
	jmp    	errRet
	
errRet:								; return processing
	cmp    	EAX, 4
	jnz     exit
errSection:
	cmp		progSection, 0
	jz		start
	jmp		s1

exit:
	invoke 	ExitProcess, NULL
	
end start