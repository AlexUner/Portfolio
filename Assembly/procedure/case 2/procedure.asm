.586
.model flat, stdcall
option casemap: none
;###################################################################INCLUDE
	include    \masm32\include\windows.inc
	include    \masm32\include\user32.inc
	include    \masm32\include\kernel32.inc
	include    \masm32\include\Prototypes.inc

	includelib \masm32\lib\user32.lib
	includelib \masm32\lib\kernel32.lib
	includelib \masm32\lib\InputBox.lib
;#####################################################################DATA
	.data
		MsgBoxName    	db "MASM32 Prog",0
		
		InputBoxName    db "Line entry",0
		InputChoose     db "Enter a number not exceeding 65k",0
		InputChoose1    db "Enter adder",0
		Formats         db "Sum output: %s",   13, "Enter new data?",0

		ResString		db 255 dup(0)
		DefString		db 50 dup(0)
		DefInt			dd 0
		DefInt2			dd 0

;#####################################################################DATA
	.code
include		\masm32\include\str.inc
;#####################################################################CODE	
start:
	invoke	InputBox, addr InputChoose, addr InputBoxName, addr DefString
	
	push	offset DefString
	push	offset DefInt
	call	StrToInt
	
	invoke	InputBox, addr InputChoose1, addr InputBoxName, addr DefString
	
	push	offset DefString
	push	offset DefInt2
	call	StrToInt
	
	mov		eax, DefInt
	add 	eax, DefInt2
	mov		DefInt, eax
	
	push	offset DefInt
	push	offset DefString
	call	IntToStr	
	
	invoke wsprintf, addr ResString, addr Formats, addr DefString
	invoke MessageBox, NULL, addr ResString, addr MsgBoxName, MB_YESNO
	
	cmp    	eax, IDYES
	jz     	start
	invoke ExitProcess, NULL
	
end start
