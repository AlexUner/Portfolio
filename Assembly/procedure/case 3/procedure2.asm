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
		InputBoxName    db "Line entry",0
		InputBoxTextFir db "Please enter a string",0
		InputBoxTextInd db "Please enter a substring",0
;#OUTPUT		
		Format1         db "Entry index:",0
		Format2         db 13,"Re-enter?",0
;#VARIABLES		
		FirstString   	db 50  dup (0)
		SecondString   	db 50  dup (0)
		ResString   	db 255 dup (0) 
		ValueLength  	db 255 dup (0)
		mode            db 0
		cnt				dd 0
;#ERRORS	
		ErrCaption      db "Error",0
		ValueInputError db "You have not entered a value", 13, "Re-enter?",0
		DefLengthError  db "You have entered too many characters!", 13, "Re-enter?",0
		DefIndexError  	db "You have gone too far!", 13, "Re-enter?",0	
		DefCountError  	db "You want too much!", 13, "Re-enter?",0			
			
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
	mov		ebx, eax
s2:
	mov    	mode, 2
	invoke 	InputBox, addr InputBoxTextInd, addr InputBoxName, addr SecondString
	test   	eax, eax                 	
	jz 	   	errValueInput  				
	cmp    	eax, ebx                  	
	ja     	errCountError	  			
	
	push	offset SecondString
	push	offset FirstString
	call	strpos
	
	mov		cnt, eax
	push	offset cnt
	push	offset ValueLength 	
	call	IntToStr

	push	offset ResString
	push	offset Format1
	push	offset ValueLength
	push	offset Format2
	push	0
	call	Concatenatio
	
	invoke 	MessageBox, NULL, addr ResString, addr MsgBoxName, MB_YESNO
	mov		mode, 1
	
	cmp    	eax, IDYES
	jz     	start
	jmp    	exit	
	
errDefLength:						; error handling
	invoke 	MessageBox, NULL, addr DefLengthError, addr ErrCaption, MB_RETRYCANCEL + MB_ICONERROR
	jmp    	errRet
	
errIndexInput:
	invoke 	MessageBox, NULL, addr DefIndexError, addr ErrCaption, MB_RETRYCANCEL + MB_ICONERROR	
	jmp    	errRet
	
errValueInput:
	invoke 	MessageBox, NULL, addr ValueInputError, addr ErrCaption, MB_RETRYCANCEL + MB_ICONERROR	
	jmp    	errRet
	
errCountError:
	invoke 	MessageBox, NULL, addr DefCountError, addr ErrCaption, MB_RETRYCANCEL + MB_ICONERROR	
	jmp    	errRet

errRet:								; return processing
	cmp    	EAX, 4
	jz     	defmode
	jmp    	exit
defmode:
	cmp    	mode,1
	jz     	start
	cmp    	mode,2
	jz     	s2
	jmp    	start

exit:
	invoke 	ExitProcess, NULL
	
end start
