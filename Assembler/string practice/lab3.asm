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
		
		InputBoxName     db "Ввод строки",0
		InputDefBoxText  db "Пожалуйста, введите СТРОКУ не более 32 символов длиной!",0
		InputKeyBoxText  db "Пожалуйста, введите КЛЮЧ",0
		ChooseMessage    db "Нажмите:", 13, "1. Да,   для работы с ключем", 13,
							"2. Нет, для работы со второй строкой",0
		MessageTemplate  db "Количество символов в введённой строке: %s",0
		Lab4Format 	 	 db "Новая вторая строка: %s", 13,
							"Хотите ввести новую строку?",0
		Lab3Format       db "Новая строка: %s", 13,
							"Хотите ввести новый ключ?",0

		DefString   	 dd 50  dup (0)
		TmpString   	 db 50  dup (0)
		KeyString   	 db 50  dup (0)
		ValueLength  	 db 255 dup (0)
		mode			 dd 0
		bitmask			 db 0
		
		ErrCaption       db "Ошибка",0
		ValueInputError  db "Вы не ввели значения", 13, "Повторить ввод?",0
		DefLengthError   db "Вы ввели больше 32 символов!",0 ;для 4 лабы в 2 случаях
		DefNumberError   db "В введенной строке присутствуют недопустимые символы.", 13, 
	                        "Повторить ввод?",0
		KeyError         db "Ключ должен состоять из 1 буквы!",0
;#########################################################################	
	.code
start:
	invoke InputBox, addr InputDefBoxText, addr InputBoxName, addr DefString
	test   eax, eax                 ; проверка на пустоту
	jz 	   errValueInput  			; не введено
	cmp    eax, 32                  ; проверка на длину
	ja     errDefLength	  			; больше 32
	mov    ebx, offset DefString 	; EBX - введенная строк
	
asciicheck:               			; проверка символов - не букв
	mov    al, byte ptr[ebx] 		; AL посимвольно принимает значения из 					   
min:								; введенной строки и проверяет на буквы
	cmp    al, 122					
    ja     max			
    cmp    al, 97
    jb     max
	jmp    endminmax
max:
	cmp    al, 32					; пробел (исключение)
	jz     endminmax
	cmp    al, 90					
    ja     errNumberError			
    cmp    al, 65
    jb     errNumberError
endminmax:	
	inc    ebx
	cmp    byte ptr[ebx], 0
    jnz    asciicheck				; конец проверки
	
	cmp    mode,6
	jz     lab3ret					; возврат проверки для 3 4 лабы
	cmp    mode,7
	jz     lab4ret	
	
	invoke MessageBox, NULL, addr ChooseMessage, addr MsgBoxName, MB_YESNO
	mov    mode, eax				; запись режима
	cmp    eax, 7					; выбор режима работы
	jz     lab4mode 				; прыгать если работать со строками
	
lab3mode:	
	invoke InputBox, addr InputKeyBoxText, addr InputBoxName, addr KeyString
	test   eax, eax                 ; проверка на пустоту
	jz 	   errKeyError
	cmp    eax, 1                   ; проверка на длину
	ja     errKeyError
	
	mov    ebx, offset KeyString	; проверка на буквы
	jmp    asciicheck
lab3ret:							; уменьшение до маленькой   		    	
	mov    ebx, offset DefString	; подготовка
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
	
cb:									; возврат "каретки"
	cmp    ch,0
	dec    ebx
	dec    ch
	jnz    cb
	
	invoke wsprintf, addr ValueLength, addr Lab3Format, ebx
	invoke MessageBox, NULL, addr ValueLength, addr MsgBoxName, MB_YESNO
	
	cmp    eax, IDYES
	jz     lab3mode
	jmp    exit						; конец 3 лабы
	
lab4mode:
	invoke InputBox, addr InputDefBoxText, addr InputBoxName, addr KeyString
	test   eax, eax                 ; проверка на пустоту
	jz 	   errValueInput
	cmp    eax, 32                  ; проверка на длину
	ja     errDefLength

	mov    ebx, offset KeyString	; проверка на буквы
	jmp    asciicheck
lab4ret:	
	mov    ebx, offset DefString	; подготовка маски
	mov	   ecx, 0
	mov    dl,  0
	mov    dh,  0                   ; eax  - счетчик
	
lab4mask:
	inc    dh
	cmp    byte ptr[ebx],0
	jz     lab4out
	cmp    byte ptr[ebx], 90		; запись больших букв в маску			
    ja     lab4next	
    cmp    byte ptr[ebx], 65
    jb     lab4next
	inc    ebx		
	inc    dl 						; dl - счетчик больших букв
	inc    ecx 						; запись 1 в маску
	shl    ecx, 1					; сдвиг
	jmp    lab4mask
lab4next:
	inc	   ebx						
	shl    ecx, 1					; запись 0 в маску
	cmp	   byte ptr[ebx], 0
	jnz    lab4mask	
lab4out:
	shr    ecx, 1					; ecx - откат для сохранения размера и готовая маска
	mov    ah, 33
	sub    ah, dh
again:
	dec    ah						; проворот строки в начало для 
	shl    ecx, 1                   ; удобной работы
	cmp    ah, 0
	jnz    again

	
	mov    dh,  0                   ; dh  - счетчик
	mov    ebx, offset KeyString    ; ebx - вторая строка
	mov    eax, 1b
	ror    eax, 1					; запись с конца
lab4ans:
	inc    dh						; увеличиваем счетчик
	cmp    byte ptr[ebx], 122		; 				
    ja     lab4skip					; пропуск больших букв
    cmp    byte ptr[ebx], 97		;
    jb     lab4skip
	cmp    dl, 0					; кончились большие буквы в ключе
	jz     lab4exit					; 
	push   eax
	and    eax, ecx					; сравниваем с основной маской
	cmp    eax, 0					; если 0 то не наш ход
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
lab4exit:							; возврат "каретки"
	cmp    dh,0
	dec    ebx
	dec    dh
	jnz    lab4exit
	
	invoke wsprintf, addr ValueLength, addr Lab4Format, ebx
	invoke MessageBox, NULL, addr ValueLength, addr MsgBoxName, MB_YESNO

	cmp    eax, IDYES
	jz     lab4mode
	jmp    exit						; конец 4 лабы
	
errDefLength:						; обработка ошибок
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
	
errRet:								; обработка возврата
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











