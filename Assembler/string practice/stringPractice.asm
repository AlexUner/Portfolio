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
		Lab4Format 	 	 db "New second string: %s", 13,
							"Do you want to enter a new string?",0
		Lab3Format       db "New line: %s", 13,
							"Do you want to enter a new key?",0

		DefString   	 dd 50  dup (0)
		TmpString   	 db 50  dup (0)
		KeyString   	 db 50  dup (0)
		ValueLength  	 db 255 dup (0)
		mode			 dd 0
		bitmask			 db 0
		
		ErrCaption       db "Error",0
		ValueInputError  db "You have not entered a value", 13, "Do you want to re-enter?",0
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
	jz     lab3ret					; return check for 3 4 labs
	cmp    mode,7
	jz     lab4ret	
	
	invoke MessageBox, NULL, addr ChooseMessage, addr MsgBoxName, MB_YESNO
	mov    mode, eax				; çàïèñü ðåæèìà
	cmp    eax, 7					; âûáîð ðåæèìà ðàáîòû
	jz     lab4mode 				; ïðûãàòü åñëè ðàáîòàòü ñî ñòðîêàìè
	
lab3mode:	
	invoke InputBox, addr InputKeyBoxText, addr InputBoxName, addr KeyString
	test   eax, eax                 ; ïðîâåðêà íà ïóñòîòó
	jz 	   errKeyError
	cmp    eax, 1                   ; ïðîâåðêà íà äëèíó
	ja     errKeyError
	
	mov    ebx, offset KeyString	; ïðîâåðêà íà áóêâû
	jmp    asciicheck
lab3ret:							; óìåíüøåíèå äî ìàëåíüêîé   		    	
	mov    ebx, offset DefString	; ïîäãîòîâêà
	mov	   ch, 0
	mov    al, KeyString
	
	cmp    KeyString, 122					
    ja     lab3delit			
    cmp    KeyString, 97
    jb     lab3delit
	jmp    lab3next
lab3delit:
	add	   KeyString, 32			; make letters great again!
	mov    al, KeyString
	
lab3next:
	cmp    byte ptr [ebx],0
	jz     cb
	cmp    al, byte ptr [ebx]
	jz 	   up
	inc    ebx
	inc    ch
	jmp    lab3next
up:
	add    byte ptr [ebx], -32
	jmp    lab3next
	
cb:									; âîçâðàò "êàðåòêè"
	cmp    ch,0
	dec    ebx
	dec    ch
	jnz    cb
	
	invoke wsprintf, addr ValueLength, addr Lab3Format, ebx
	invoke MessageBox, NULL, addr ValueLength, addr MsgBoxName, MB_YESNO
	
	cmp    eax, IDYES
	jz     lab3mode
	jmp    exit						; êîíåö 3 ëàáû
	
lab4mode:
	invoke InputBox, addr InputDefBoxText, addr InputBoxName, addr KeyString
	test   eax, eax                 ; ïðîâåðêà íà ïóñòîòó
	jz 	   errValueInput
	cmp    eax, 32                  ; ïðîâåðêà íà äëèíó
	ja     errDefLength

	mov    ebx, offset KeyString	; ïðîâåðêà íà áóêâû
	jmp    asciicheck
lab4ret:	
	mov    ebx, offset DefString	; ïîäãîòîâêà ìàñêè
	mov	   ecx, 0
	mov    dl,  0
	mov    dh,  0                   ; eax  - ñ÷åò÷èê
	
lab4mask:
	inc    dh
	cmp    byte ptr[ebx],0
	jz     lab4out
	cmp    byte ptr[ebx], 90		; çàïèñü áîëüøèõ áóêâ â ìàñêó			
    ja     lab4next	
    cmp    byte ptr[ebx], 65
    jb     lab4next
	inc    ebx		
	inc    dl 						; dl - ñ÷åò÷èê áîëüøèõ áóêâ
	inc    ecx 						; çàïèñü 1 â ìàñêó
	shl    ecx, 1					; ñäâèã
	jmp    lab4mask
lab4next:
	inc	   ebx						
	shl    ecx, 1					; çàïèñü 0 â ìàñêó
	cmp	   byte ptr[ebx], 0
	jnz    lab4mask	
lab4out:
	shr    ecx, 1					; ecx - îòêàò äëÿ ñîõðàíåíèÿ ðàçìåðà è ãîòîâàÿ ìàñêà
	mov    ah, 33
	sub    ah, dh
again:
	dec    ah						; ïðîâîðîò ñòðîêè â íà÷àëî äëÿ 
	shl    ecx, 1                   ; óäîáíîé ðàáîòû
	cmp    ah, 0
	jnz    again

	
	mov    dh,  0                   ; dh  - ñ÷åò÷èê
	mov    ebx, offset KeyString    ; ebx - âòîðàÿ ñòðîêà
	mov    eax, 1b
	ror    eax, 1					; çàïèñü ñ êîíöà
lab4ans:
	inc    dh						; óâåëè÷èâàåì ñ÷åò÷èê
	cmp    byte ptr[ebx], 122		; 				
    ja     lab4skip					; ïðîïóñê áîëüøèõ áóêâ
    cmp    byte ptr[ebx], 97		;
    jb     lab4skip
	cmp    dl, 0					; êîí÷èëèñü áîëüøèå áóêâû â êëþ÷å
	jz     lab4exit					; 
	push   eax
	and    eax, ecx					; ñðàâíèâàåì ñ îñíîâíîé ìàñêîé
	cmp    eax, 0					; åñëè 0 òî íå íàø õîä
	jnz    lab4up
	cmp    eax, 0
	jz     lab4skip
lab4up:
	dec    dl
	pop    eax
	add    byte ptr[ebx], -32
	inc    ebx
	shr    eax,1
	cmp    byte ptr[ebx], 0
	jnz    lab4ans
	cmp    byte ptr[ebx], 0
	jz     lab4exit
lab4skip:
	inc    ebx
	pop    eax
	shr    eax,1
	cmp    byte ptr[ebx], 0
	jnz    lab4ans
	cmp    byte ptr[ebx], 0
	jz     lab4exit
lab4exit:							; âîçâðàò "êàðåòêè"
	cmp    dh,0
	dec    ebx
	dec    dh
	jnz    lab4exit
	
	invoke wsprintf, addr ValueLength, addr Lab4Format, ebx
	invoke MessageBox, NULL, addr ValueLength, addr MsgBoxName, MB_YESNO

	cmp    eax, IDYES
	jz     lab4mode
	jmp    exit						; êîíåö 4 ëàáû
	
errDefLength:						; îáðàáîòêà îøèáîê
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
	
errRet:								; îáðàáîòêà âîçâðàòà
	cmp    EAX, 4
	jz     defmode
	jmp    exit
defmode:
	cmp    mode,0
	jz     start
	cmp    mode,6
	jz     lab3mode
	jmp    lab4mode

exit:	
	invoke ExitProcess, NULL
	
end start











