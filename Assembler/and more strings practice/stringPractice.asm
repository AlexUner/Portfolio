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
		InputDefBoxText db "Please enter a STRING no longer than 255 characters!",0
		InputKeyBoxText db "Please enter a KEY 3 characters long!",0
		Format          db "Characters displayed: %s",13,"Enter new data?",0
		
		DefString   	db 255 dup (0)
		KeyString   	db 50  dup (0)
		ValueLength  	db 255 dup (0)
		mode			db 0
		
		ErrCaption      db "Error",0
		ValueInputError db "You have not entered values", 13, "Re-enter?",0
		DefLengthError  db "You have entered more than 255 characters!",0
		KeyLengthError  db "The key must be 3 lowercase letters!",0		
		DefNumberError  db "There are invalid characters in the entered string.", 13, "Re-enter?",0
		
;#########################################################################	
	.code
include   \masm32\include\outofletters.inc

start:
	invoke InputBox, addr InputDefBoxText, addr InputBoxName, addr DefString
	test   eax, eax                 ; empty check
	jz 	   errValueInput  			
	cmp    eax, 255                 ; length check
	ja     errDefLength	  			
	mov    ebx, offset DefString 	; EBX - entered string
	
asciicheck:               			; character check - not letters
	mov    al, byte ptr[ebx] 		; AL character-by-character takes values from 					   
min:								; the entered string and checks for letters
	cmp    al, 122					
    ja     max			
    cmp    al, 97
    jb     max
	jmp    endminmax
max:
	cmp    al, 32					; space (exception)
	jz     endminmax
	cmp    al, 90					
    ja     errNumberError			
    cmp    al, 65
    jb     errNumberError
endminmax:	
	inc    ebx
	cmp    byte ptr[ebx], 0
    jnz    asciicheck				; check end
	
	mov    mode, 1					; switch - second section of the programme

key:
	invoke InputBox, addr InputKeyBoxText, addr InputBoxName, addr KeyString
	test   eax, eax                 ; empty check
	jz 	   errValueInput  			
	cmp    eax, 3                   ; length check
	jnz    errKeyLength	  			
	mov    ebx, offset KeyString 	; EBX - entered string

key_asciicheck:               		; character check - not letters
	mov    al, byte ptr[ebx] 		; AL character-by-character takes values from 	 					   
key_min:							; the entered string and checks for letters
	cmp    al, 122					
    ja     errKeyLength			
    cmp    al, 97
    jb     errKeyLength
	jmp    key_endminmax
key_endminmax:	
	inc    ebx
	cmp    byte ptr[ebx], 0
    jnz    key_asciicheck			; check end
	
	mov    eax, offset KeyString
	
	push   eax						; 4 argument - 1 letter
	inc    eax
	push   eax						; 3 argument - 2 letter
	inc    eax
	push   eax						; 2 argument - 3 letter
	push   offset DefString         ; 1 argument - string
	
	call   outOfLetters
	
	invoke wsprintf, addr ValueLength, addr Format, eax
	invoke MessageBox, NULL, addr ValueLength, addr MsgBoxName, MB_YESNO
	
	cmp    eax, IDYES
	mov    mode, 0
	jz     start
	jmp    exit	
	
errDefLength:						; error handling
	invoke MessageBox, NULL, addr DefLengthError, addr ErrCaption, MB_RETRYCANCEL + MB_ICONERROR
	jmp    errRet

errKeyLength:
	invoke MessageBox, NULL, addr KeyLengthError, addr ErrCaption, MB_RETRYCANCEL + MB_ICONERROR
	jmp    errRet
	
errValueInput:
	invoke MessageBox, NULL, addr ValueInputError, addr ErrCaption, MB_RETRYCANCEL + MB_ICONERROR	
	jmp    errRet
	
errNumberError:
	invoke MessageBox, NULL, addr DefNumberError, addr ErrCaption, MB_RETRYCANCEL + MB_ICONERROR	
	jmp    errRet

errRet:								; return processing
	cmp    EAX, 4
	jz     defmode
	jmp    exit
defmode:
	cmp    mode, 0
	jz     start
	jmp    key

exit:
	invoke ExitProcess, NULL
	
end start
