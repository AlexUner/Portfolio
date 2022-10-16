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
		MsgBoxName    	 db "MASM32 Prog",0
		
		InputBoxName     db "Line entry",0
		InputDefBoxText  db "Please enter a STRING no longer than 32 characters!",0
		InputKeyBoxText  db "Please enter the KEY",0
		ChooseMessage    db "Press:", 13, "1. Yes, for key operation", 13,
							"2. No, to work with the second string",0
		MessageTemplate  db "Number of characters in entered string: %s",0
		Lab2Format 	 	 db "New second string: %s", 13,
							"Enter a new string?",0
		Lab1Format       db "New line: %s", 13,
							"Enter a new key?",0

		DefString   	 db 50  dup (0)
		TmpString   	 db 50  dup (0)
		KeyString   	 db 50  dup (0)
		ValueLength  	 db 255 dup (0)
		mode			 dd 0
		bitmask			 db 0
		
		ErrCaption       db "Error",0
		ValueInputError  db "You have not entered a value", 13, "Re-enter?",0
		DefLengthError   db "You have entered more than 32 characters!",0
		DefNumberError   db "There are invalid characters in the entered string.", 13, 
	                        "Repeat input?",0
		KeyError         db "Key must consist of 1 letter!",0
;#########################################################################	
	.code
start:
	invoke InputBox, addr InputDefBoxText, addr InputBoxName, addr DefString
	test   eax, eax                 ; empty check
	jz 	   errValueInput  			
	cmp    eax, 32                  ; length check
	ja     errDefLength	  			
	mov    ebx, offset DefString 	; EBX - entered string
	
asciicheck:               			; character check - not letters
	mov    al, byte ptr[ebx] 		; AL accepts values from the entered					   
min:								; string as characters and checks for letters
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
    jnz    asciicheck				; end of check
	
	cmp    mode,6
	jz     lab1ret					; return check for 3 4 labs
	cmp    mode,7
	jz     lab2ret	
	
	invoke MessageBox, NULL, addr ChooseMessage, addr MsgBoxName, MB_YESNO
	mov    mode, eax				; mode recording
	cmp    eax, 7					; selection of operating mode
	jz     lab2mode 				; jump if working with strings
	
lab1mode:	
	invoke InputBox, addr InputKeyBoxText, addr InputBoxName, addr KeyString
	test   eax, eax                 ; empty check
	jz 	   errKeyError
	cmp    eax, 1                   ; length check
	ja     errKeyError
	
	mov    ebx, offset KeyString	; character check
	jmp    asciicheck
lab1ret:							; reduction to a small  		    	
	mov    ebx, offset DefString	; prepare
	mov	   ch, 0
	mov    al, KeyString
	
	cmp    KeyString, 122					
    ja     lab1delit			
    cmp    KeyString, 97
    jb     lab1delit
	jmp    lab1next
lab1delit:
	add	   KeyString, 32			; make letters great again!
	mov    al, KeyString
	
lab1next:
	cmp    byte ptr [ebx],0
	jz     cb
	cmp    al, byte ptr [ebx]
	jz 	   up
	inc    ebx
	inc    ch
	jmp    lab1next
up:
	add    byte ptr [ebx], -32
	jmp    lab1next
	
cb:									; return "carriage"
	cmp    ch,0
	dec    ebx
	dec    ch
	jnz    cb
	
	invoke wsprintf, addr ValueLength, addr Lab1Format, ebx
	invoke MessageBox, NULL, addr ValueLength, addr MsgBoxName, MB_YESNO
	
	cmp    eax, IDYES
	jz     lab1mode
	jmp    exit						; end of first practice
	
lab2mode:
	invoke InputBox, addr InputDefBoxText, addr InputBoxName, addr KeyString
	test   eax, eax                 ; empty check
	jz 	   errValueInput
	cmp    eax, 32                  ; length check
	ja     errDefLength

	mov    ebx, offset KeyString	; character check
	jmp    asciicheck
lab2ret:	
	mov    ebx, offset DefString	; mask preparation
	mov	   ecx, 0
	mov    dl,  0
	mov    dh,  0                   ; eax - counter
	
lab2mask:
	cmp    byte ptr[ebx],0
	jz     lab4out
	inc    dh
	cmp    byte ptr[ebx], 90		; writing uppercase letters into a mask			
    ja     lab2next	
    cmp    byte ptr[ebx], 65
    jb     lab2next
	inc    ebx		
	inc    dl 						; dl - capital letter counter
	inc    ecx 						; Write 1 to the mask
	shl    ecx, 1					; shift
	jmp    lab2mask
lab2next:
	inc	   ebx						
	shl    ecx, 1					; Write 0 to the mask
	cmp	   byte ptr[ebx], 0
	jnz    lab2mask	
lab2out:
	shr    ecx, 1					; ecx - backup to save size and ready mask
	mov    ah, 32
	sub    ah, dh
again:
	dec    ah						; turning the string to the
	shl    ecx, 1                   ; beginning for easy operation
	cmp    ah, 0
	jnz    again

	
	mov    ebx, offset KeyString    ; ebx - second line
	push   ebx
	mov    eax, 1b        			; eax - mask for comparison
	ror    eax, 1					; write from the end
	
lab2ans:
	cmp	   byte ptr[ebx], 0			; end of line
	jz     lab2exit	
	cmp    dl, 0					; the end of capital letters in the key (mask)
	jz     lab2exit
	
	push   eax
	and    eax, ecx					; comparison of masks
	cmp    eax, 0
	pop    eax
	jnz    lab2up					; if matched
	inc    ebx
	shr    eax, 1 
	jmp    lab2ans	
lab2up:
	shr    eax, 1
	dec    dl
	cmp    byte ptr[ebx], 32		; space (exception)
	jz     lab2skip
	cmp    byte ptr[ebx], 122
	ja     lab2skip					; if a capital letter in the second line
    cmp    byte ptr[ebx], 97
    jb     lab2skip
	sub    byte ptr[ebx], 32
	inc    ebx
	jmp    lab2ans
lab2skip:
	inc    ebx
	jmp    lab2ans
lab2exit:
	pop    ebx
	
	invoke wsprintf, addr ValueLength, addr Lab2Format, ebx
	invoke MessageBox, NULL, addr ValueLength, addr MsgBoxName, MB_YESNO

	cmp    eax, IDYES
	jz     lab2mode
	jmp    exit						; end of second practice
	
errDefLength:						; error handling
	invoke MessageBox, NULL, addr DefLengthError, addr ErrCaption, MB_RETRYCANCEL + MB_ICONERROR
	jmp    errRet
	
errValueInput:
	invoke MessageBox, NULL, addr ValueInputError, addr ErrCaption, MB_RETRYCANCEL + MB_ICONERROR	
	jmp    errRet

errNumberError:
	invoke MessageBox, NULL, addr DefNumberError, addr ErrCaption, MB_RETRYCANCEL + MB_ICONERROR	
	jmp    errRet
	
errKeyError:
	invoke MessageBox, NULL, addr KeyError, addr ErrCaption, MB_RETRYCANCEL + MB_ICONERROR	
	jmp    errRet
	
errRet:								; return processing
	cmp    EAX, 4
	jz     defmode
	jmp    exit
defmode:
	cmp    mode,0
	jz     start
	cmp    mode,6
	jz     lab1mode
	jmp    lab2mode

exit:	
	invoke ExitProcess, NULL
	
end start
