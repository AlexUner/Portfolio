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
		
		InputBoxName    db "Line entry",0
		InputDefBoxText db "Please enter a STRING no longer than 50 characters!",0
		Format1         db "The symbols are displayed:",0
		Format2         db 13,"Character count: %lu",13,"Enter new data?",0
		
		FirstString   	db 50  dup (0)
		SecondString   	db 50  dup (0)
		ThirdString   	db 50  dup (0)
		FourthString   	db 50  dup (0)
		ResString   	db 255 dup (0)
		ValueLength  	db 255 dup (0)
		mode            db 0
		
		ErrCaption      db "Error",0
		ValueInputError db "You have not entered values!", 13, "Re-enter?",0
		DefLengthError  db "You have entered more than 50 characters!", 13, "Re-enter?",0		
		
;#########################################################################	
	.code
include   \masm32\include\str.inc

start:
	mov    mode, 1
	invoke InputBox, addr InputDefBoxText, addr InputBoxName, addr FirstString
	test   eax, eax                 ; empty check
	jz 	   errValueInput  			; not entered
	cmp    eax, 50                  ; length check
	ja     errDefLength	  			; over 50
s2:
	mov    mode, 2
	invoke InputBox, addr InputDefBoxText, addr InputBoxName, addr SecondString
	test   eax, eax                 
	jz 	   errValueInput  			
	cmp    eax, 50                  
	ja     errDefLength	  			
s3:	
	mov    mode, 3
	invoke InputBox, addr InputDefBoxText, addr InputBoxName, addr ThirdString
	cmp    eax, 50                  
	ja     errDefLength	  			
s4:
	mov    mode, 4
	invoke InputBox, addr InputDefBoxText, addr InputBoxName, addr FourthString
	cmp    eax, 50                  
	ja     errDefLength	  			
	
	push   offset ResString			; 5 argument resultant
	push   offset FirstString       ; 1 argument
	push   offset SecondString		; 2 argument
	push   offset ThirdString		; 3 argument
	push   offset FourthString		; 4 argument
	call   Concatenatio
	
	push   eax
	
	push   offset ValueLength
	push   offset Format1
	push   offset ResString			; putting together the output
	push   offset Format2
	push   0
	call   Concatenatio
	
	pop    eax
	
	invoke wsprintf, addr ResString, addr ValueLength, eax
	invoke MessageBox, NULL, addr ResString, addr MsgBoxName, MB_YESNO
	
	cmp    eax, IDYES
	jz     start
	jmp    exit	
	
errDefLength:						; error handling
	invoke MessageBox, NULL, addr DefLengthError, addr ErrCaption, MB_RETRYCANCEL + MB_ICONERROR
	jmp    errRet
	
errValueInput:
	invoke MessageBox, NULL, addr ValueInputError, addr ErrCaption, MB_RETRYCANCEL + MB_ICONERROR	
	jmp    errRet

errRet:								; return processing
	cmp    EAX, 4
	jz     defmode
	jmp    exit
defmode:
	cmp    mode,1
	jz     start
	cmp    mode,2
	jz     s2
	cmp    mode,3
	jz     s3
	cmp    mode,4
	jz     s4

exit:
	invoke ExitProcess, NULL
	
end start
