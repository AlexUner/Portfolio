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
		
		InputBoxName    db "Ввод строки",0
		InputDefBoxText db "Пожалуйста, введите СТРОКУ не более 255 символов длиной!",0
		InputKeyBoxText db "Пожалуйста, введите КЛЮЧ длиной в 3 символа!",0
		Format          db "Выведены символы: %s",13,"Хотите ввести новые данные?",0
		
		DefString   	db 255 dup (0)
		KeyString   	db 50  dup (0)
		ValueLength  	db 255 dup (0)
		mode			db 0
		
		ErrCaption      db "Ошибка",0
		ValueInputError db "Вы не ввели значения", 13, "Повторить ввод?",0
		DefLengthError  db "Вы ввели больше 255 символов!",0
		KeyLengthError  db "Ключ должен состоять из 3 маленьких букв!",0		
		DefNumberError  db "В введенной строке присутствуют недопустимые символы.", 13, "Повторить ввод?",0
		
;#########################################################################	
	.code
include   \masm32\include\outofletters.inc

start:
	invoke InputBox, addr InputDefBoxText, addr InputBoxName, addr DefString
	test   eax, eax                 ; проверка на пустоту
	jz 	   errValueInput  			; не введено
	cmp    eax, 255                 ; проверка на длину
	ja     errDefLength	  			; больше 255
	mov    ebx, offset DefString 	; EBX - введенная строка
	
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
	
	mov    mode, 1					; переключатель - вторая секция программы

key:
	invoke InputBox, addr InputKeyBoxText, addr InputBoxName, addr KeyString
	test   eax, eax                 ; проверка на пустоту
	jz 	   errValueInput  			; не введено
	cmp    eax, 3                   ; проверка на длину
	jnz    errKeyLength	  			; больше 255
	mov    ebx, offset KeyString 	; EBX - введенная строк

key_asciicheck:               		; проверка символов - не букв
	mov    al, byte ptr[ebx] 		; AL посимвольно принимает значения из 					   
key_min:							; введенной строки и проверяет на буквы
	cmp    al, 122					
    ja     errKeyLength			
    cmp    al, 97
    jb     errKeyLength
	jmp    key_endminmax
key_endminmax:	
	inc    ebx
	cmp    byte ptr[ebx], 0
    jnz    key_asciicheck			; конец проверки
	
	mov    eax, offset KeyString
	
	push   eax						; 4 аргумент - 1 буква
	inc    eax
	push   eax						; 3 аргумент - 2 буква
	inc    eax
	push   eax						; 2 аргумент - 3 буква
	push   offset DefString         ; 1 аргумент - строка
	
	call   outOfLetters
	
	invoke wsprintf, addr ValueLength, addr Format, eax
	invoke MessageBox, NULL, addr ValueLength, addr MsgBoxName, MB_YESNO
	
	cmp    eax, IDYES
	mov    mode, 0
	jz     start
	jmp    exit	
	
errDefLength:						; обработка ошибок
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

errRet:								; обработка возврата
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











