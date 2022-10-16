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
		Format1         db "The symbols are displayed:",0
		Format2         db 13,"Character count: %lu",13,"Do you want to enter new data?",0
		
		FirstString   	db 50  dup (0)
		SecondString   	db 50  dup (0)
		ThirdString   	db 50  dup (0)
		FourthString   	db 50  dup (0)
		ResString   	db 255 dup (0)
		ValueLength  	db 255 dup (0)
		mode            db 0
		
		ErrCaption      db "Error",0
		ValueInputError db "You have not entered values", 13, "Do you want to re-enter?",0
		DefLengthError  db "Âû ââåëè áîëüøå 50 ñèìâîëîâ!", 13, "Ïîâòîðèòü ââîä?",0		
		
;#########################################################################	
	.code
include   \masm32\include\str.inc

start:
	mov    mode, 1
	invoke InputBox, addr InputDefBoxText, addr InputBoxName, addr FirstString
	test   eax, eax                 ; ïðîâåðêà íà ïóñòîòó
	jz 	   errValueInput  			; íå ââåäåíî
	cmp    eax, 50                  ; ïðîâåðêà íà äëèíó
	ja     errDefLength	  			; áîëüøå 50
s2:
	mov    mode, 2
	invoke InputBox, addr InputDefBoxText, addr InputBoxName, addr SecondString
	test   eax, eax                 ; ïðîâåðêà íà ïóñòîòó
	jz 	   errValueInput  			; íå ââåäåíî
	cmp    eax, 50                  ; ïðîâåðêà íà äëèíó
	ja     errDefLength	  			; áîëüøå 50
s3:	
	mov    mode, 3
	invoke InputBox, addr InputDefBoxText, addr InputBoxName, addr ThirdString
	cmp    eax, 50                  ; ïðîâåðêà íà äëèíó
	ja     errDefLength	  			; áîëüøå 50
s4:
	mov    mode, 4
	invoke InputBox, addr InputDefBoxText, addr InputBoxName, addr FourthString
	cmp    eax, 50                  ; ïðîâåðêà íà äëèíó
	ja     errDefLength	  			; áîëüøå 50
	
	push   offset ResString			; 5 àðãóìåíò ðåçóëüòèðóþùèé
	push   offset FirstString       ; 1 àðãóìåíò
	push   offset SecondString		; 2 àðãóìåíò
	push   offset ThirdString		; 3 àðãóìåíò
	push   offset FourthString		; 4 àðãóìåíò
	call   Concatenatio
	
	push   eax
	
	push   offset ValueLength
	push   offset Format1
	push   offset ResString			; ñîáèðàåì âûâîä
	push   offset Format2
	push   0
	call   Concatenatio
	
	pop    eax
	
	invoke wsprintf, addr ResString, addr ValueLength, eax
	invoke MessageBox, NULL, addr ResString, addr MsgBoxName, MB_YESNO
	
	cmp    eax, IDYES
	jz     start
	jmp    exit	
	
errDefLength:						; îáðàáîòêà îøèáîê
	invoke MessageBox, NULL, addr DefLengthError, addr ErrCaption, MB_RETRYCANCEL + MB_ICONERROR
	jmp    errRet
	
errValueInput:
	invoke MessageBox, NULL, addr ValueInputError, addr ErrCaption, MB_RETRYCANCEL + MB_ICONERROR	
	jmp    errRet

errRet:								; îáðàáîòêà âîçâðàòà
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











