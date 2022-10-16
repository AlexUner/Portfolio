.586
.model flat, stdcall
option casemap: none

include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc

includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib

.data
	Caption db "MASM32 Prog",0
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
