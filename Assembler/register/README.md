<h2 align="center">Create a program that will change the specified characters from lowercase to uppercase in the entered text string</h2>

Replacing must be universal and work for any, not a specific character. The resulting text string should be be displayed on the screen in a message.

The desired character and text string must be entered on the command line after certain keys (@, #, $, %). The key for the character to be searched is to be entered first, the test string key is to be entered second. 

The program should check if the character to be searched for belongs to to a set of lowercase Latin letters, otherwise the program will return an an error message. The program should also return an error message if the command line does not contain the keys or if the keys are missing a character(s). are given, but then there are no character(s)

<br>

<h2 align="center">Создать программу, которая будет в ведённой текстовой строке изменять указанные символы с нижнего регистра на верхний</h2>

Замена регистра должна быть универсальной и работать для любого, а не конкретного символа. Полученная текстовая строка должна быть выведена на экран в сообщении.

Искомый символ и текстовая строка вводятся в командной строке после определённых ключей (@, #, $, %). Причём ключ искомого символа вводится первым, а ключ тестовой строки – вторым. 

Программа должна проверять искомый символ на принадлежность набору строчных латинских букв, в противном случае выдавать сообщение об ошибке. Также программа должна выдавать сообщение об ошибке, если в командной строке не указаны ключи или ключи указаны, но далее нет символа(ов)

<br>

```
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
	alarma 	db "Invalid input!",0
	Result  db 255 dup(0)
	Format  db "New line: %s",0
	bukv db 0
	
.code
start:
		invoke GetCommandLine
		cmp 	eax, 0
		jz 	no

	mark:
		cmp byte ptr[eax],0 
		jz no              
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

		mov bl, byte ptr[eax]
		cmp bl, 122
		ja  no
		cmp bl, 97
		jb  no

	mark2:
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

		push eax

	zamena:
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

	cb:	
		pop eax

		invoke wsprintf, addr Result, addr Format, eax
		invoke MessageBox, NULL, addr Result, addr Caption, MB_OK
		invoke ExitProcess, NULL
	no:
		invoke MessageBox, NULL, addr alarma, addr Caption, MB_OK
		invoke ExitProcess, NULL
	
end start
```
