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
		
		InputBoxName    db "Ââîä ñòðîêè",0
		InputDefBoxText db "Ïîæàëóéñòà, ââåäèòå ÑÒÐÎÊÓ íå áîëåå 255 ñèìâîëîâ äëèíîé!",0
		InputKeyBoxText db "Ïîæàëóéñòà, ââåäèòå ÊËÞ× äëèíîé â 3 ñèìâîëà!",0
		Format          db "Âûâåäåíû ñèìâîëû: %s",13,"Õîòèòå ââåñòè íîâûå äàííûå?",0
		
		DefString   	db 255 dup (0)
		KeyString   	db 50  dup (0)
		ValueLength  	db 255 dup (0)
		mode			db 0
		
		ErrCaption      db "Îøèáêà",0
		ValueInputError db "Âû íå ââåëè çíà÷åíèÿ", 13, "Ïîâòîðèòü ââîä?",0
		DefLengthError  db "Âû ââåëè áîëüøå 255 ñèìâîëîâ!",0
		KeyLengthError  db "Êëþ÷ äîëæåí ñîñòîÿòü èç 3 ìàëåíüêèõ áóêâ!",0		
		DefNumberError  db "Â ââåäåííîé ñòðîêå ïðèñóòñòâóþò íåäîïóñòèìûå ñèìâîëû.", 13, "Ïîâòîðèòü ââîä?",0
		
;#########################################################################	
	.code
include   \masm32\include\outofletters.inc

start:
	invoke InputBox, addr InputDefBoxText, addr InputBoxName, addr DefString
	test   eax, eax                 ; ïðîâåðêà íà ïóñòîòó
	jz 	   errValueInput  			; íå ââåäåíî
	cmp    eax, 255                 ; ïðîâåðêà íà äëèíó
	ja     errDefLength	  			; áîëüøå 255
	mov    ebx, offset DefString 	; EBX - ââåäåííàÿ ñòðîêà
	
asciicheck:               			; ïðîâåðêà ñèìâîëîâ - íå áóêâ
	mov    al, byte ptr[ebx] 		; AL ïîñèìâîëüíî ïðèíèìàåò çíà÷åíèÿ èç 					   
min:								; ââåäåííîé ñòðîêè è ïðîâåðÿåò íà áóêâû
	cmp    al, 122					
    ja     max			
    cmp    al, 97
    jb     max
	jmp    endminmax
max:
	cmp    al, 32					; ïðîáåë (èñêëþ÷åíèå)
	jz     endminmax
	cmp    al, 90					
    ja     errNumberError			
    cmp    al, 65
    jb     errNumberError
endminmax:	
	inc    ebx
	cmp    byte ptr[ebx], 0
    jnz    asciicheck				; êîíåö ïðîâåðêè
	
	mov    mode, 1					; ïåðåêëþ÷àòåëü - âòîðàÿ ñåêöèÿ ïðîãðàììû

key:
	invoke InputBox, addr InputKeyBoxText, addr InputBoxName, addr KeyString
	test   eax, eax                 ; ïðîâåðêà íà ïóñòîòó
	jz 	   errValueInput  			; íå ââåäåíî
	cmp    eax, 3                   ; ïðîâåðêà íà äëèíó
	jnz    errKeyLength	  			; áîëüøå 255
	mov    ebx, offset KeyString 	; EBX - ââåäåííàÿ ñòðîê

key_asciicheck:               		; ïðîâåðêà ñèìâîëîâ - íå áóêâ
	mov    al, byte ptr[ebx] 		; AL ïîñèìâîëüíî ïðèíèìàåò çíà÷åíèÿ èç 					   
key_min:							; ââåäåííîé ñòðîêè è ïðîâåðÿåò íà áóêâû
	cmp    al, 122					
    ja     errKeyLength			
    cmp    al, 97
    jb     errKeyLength
	jmp    key_endminmax
key_endminmax:	
	inc    ebx
	cmp    byte ptr[ebx], 0
    jnz    key_asciicheck			; êîíåö ïðîâåðêè
	
	mov    eax, offset KeyString
	
	push   eax						; 4 àðãóìåíò - 1 áóêâà
	inc    eax
	push   eax						; 3 àðãóìåíò - 2 áóêâà
	inc    eax
	push   eax						; 2 àðãóìåíò - 3 áóêâà
	push   offset DefString         ; 1 àðãóìåíò - ñòðîêà
	
	call   outOfLetters
	
	invoke wsprintf, addr ValueLength, addr Format, eax
	invoke MessageBox, NULL, addr ValueLength, addr MsgBoxName, MB_YESNO
	
	cmp    eax, IDYES
	mov    mode, 0
	jz     start
	jmp    exit	
	
errDefLength:						; îáðàáîòêà îøèáîê
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

errRet:								; îáðàáîòêà âîçâðàòà
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











