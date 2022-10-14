<h2 align="center">Create a programme that works with strings</h2>

A text string is entered on the command line after certain keys (@, #, $, %). For an input string, implement a count of the number of its characters (analogous to LENGTH() in Delphi or STRLEN() in C++).
Output the calculated number of characters of the entered string in a formatted message: "Number of characters: *", where * is the number of characters. If no string or key is entered, print an error message.

<br>

<h2 align="center">Создать программу, работающую со строками</h2>

Текстовая строка вводится в командной строке после определённых ключей (@, #, $, %). Для введенной строки реализовать подсчёт количества её символов (аналог LENGTH() в Delphi или STRLEN() в С++). 
Вычисленное количество символов введённой строки вывести на экран в сообщении в форматированном виде: «Количество символов: *», где * – число символов. Если строка или ключ не введены, то вывести сообщение об ошибке

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
	Format  db "Number of characters: %lu",0
	
.code
start:
	invoke GetCommandLine
	cmp    eax, 0
	jz no
	
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
	
	mov cx, 0
cr:
	inc cx
	inc eax
	cmp byte ptr[eax],0
	jnz cr
	
	invoke wsprintf, addr Result, addr Format, cx
	invoke MessageBox, NULL, addr Result, addr Caption, MB_OK
	invoke ExitProcess, NULL
no:
	invoke MessageBox, NULL, addr alarma, addr Caption, MB_OK
	invoke ExitProcess, NULL
	
end start
```
