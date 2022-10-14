.586
.model flat, stdcall
option casemap: none

include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc

includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib

.data
	Caption db "MASM32 Prog 1",0
	alarma 	db "Некорректный ввод!",0
	Result  db 255 dup(0)
	Format  db "Новая строка: %s",0
	bukv db 0
	
.code
start:
	invoke GetCommandLine
	cmp    eax, 0
	jz no
	
	mark:	; по сути связка марки и аргумента которые повторяются 2жды
		cmp byte ptr[eax],0 ;марка чистит пробелы до знака
		jz no               ;аргумент после
		cmp byte ptr[eax],21h
		jz argument
		inc eax
		jmp mark
		
	argument:
		inc eax
		cmp byte ptr[eax],0
		jz no
		cmp byte ptr[eax],20h
		jz argument	
		
	mov bl, byte ptr[eax] ; запись в символ и проверка на букивки
	cmp bl, 122
    ja  no
    cmp bl, 97
    jb  no
		
	mark2: ; вторая итерация на фразу
		cmp byte ptr[eax],0
		jz no
		cmp byte ptr[eax],21h
		jz argument2
		inc eax
		jmp mark2	
	
	argument2:
		inc eax
		cmp byte ptr[eax],0
		jz no
		cmp byte ptr[eax],20h
		jz argument2

		;mov bh, 0
		push eax
		
	zamena:	; замена букв
		cmp byte ptr [eax],0
		jz cb
		cmp byte ptr[eax], bl
		jz up
		inc eax
		;inc bh
		jmp zamena
	up:	
		add byte ptr[eax], -32
		jmp zamena
		
	cb:	; возврат "каретки"
		;cmp bh,0
		;dec eax
		;dec bh
		;jnz cb
		pop eax
		
	invoke wsprintf, addr Result, addr Format, eax
	invoke MessageBox, NULL, addr Result, addr Caption, MB_OK
	invoke ExitProcess, NULL
	no:
		invoke MessageBox, NULL, addr alarma, addr Caption, MB_OK
		invoke ExitProcess, NULL
	
end start