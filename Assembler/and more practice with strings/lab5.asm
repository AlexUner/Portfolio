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
		
		InputBoxName    db "���� ������",0
		InputDefBoxText db "����������, ������� ������ �� ����� 255 �������� ������!",0
		InputKeyBoxText db "����������, ������� ���� ������ � 3 �������!",0
		Format          db "�������� �������: %s",13,"������ ������ ����� ������?",0
		
		DefString   	db 255 dup (0)
		KeyString   	db 50  dup (0)
		ValueLength  	db 255 dup (0)
		mode			db 0
		
		ErrCaption      db "������",0
		ValueInputError db "�� �� ����� ��������", 13, "��������� ����?",0
		DefLengthError  db "�� ����� ������ 255 ��������!",0
		KeyLengthError  db "���� ������ �������� �� 3 ��������� ����!",0		
		DefNumberError  db "� ��������� ������ ������������ ������������ �������.", 13, "��������� ����?",0
		
;#########################################################################	
	.code
include   \masm32\include\outofletters.inc

start:
	invoke InputBox, addr InputDefBoxText, addr InputBoxName, addr DefString
	test   eax, eax                 ; �������� �� �������
	jz 	   errValueInput  			; �� �������
	cmp    eax, 255                 ; �������� �� �����
	ja     errDefLength	  			; ������ 255
	mov    ebx, offset DefString 	; EBX - ��������� ������
	
asciicheck:               			; �������� �������� - �� ����
	mov    al, byte ptr[ebx] 		; AL ����������� ��������� �������� �� 					   
min:								; ��������� ������ � ��������� �� �����
	cmp    al, 122					
    ja     max			
    cmp    al, 97
    jb     max
	jmp    endminmax
max:
	cmp    al, 32					; ������ (����������)
	jz     endminmax
	cmp    al, 90					
    ja     errNumberError			
    cmp    al, 65
    jb     errNumberError
endminmax:	
	inc    ebx
	cmp    byte ptr[ebx], 0
    jnz    asciicheck				; ����� ��������
	
	mov    mode, 1					; ������������� - ������ ������ ���������

key:
	invoke InputBox, addr InputKeyBoxText, addr InputBoxName, addr KeyString
	test   eax, eax                 ; �������� �� �������
	jz 	   errValueInput  			; �� �������
	cmp    eax, 3                   ; �������� �� �����
	jnz    errKeyLength	  			; ������ 255
	mov    ebx, offset KeyString 	; EBX - ��������� �����

key_asciicheck:               		; �������� �������� - �� ����
	mov    al, byte ptr[ebx] 		; AL ����������� ��������� �������� �� 					   
key_min:							; ��������� ������ � ��������� �� �����
	cmp    al, 122					
    ja     errKeyLength			
    cmp    al, 97
    jb     errKeyLength
	jmp    key_endminmax
key_endminmax:	
	inc    ebx
	cmp    byte ptr[ebx], 0
    jnz    key_asciicheck			; ����� ��������
	
	mov    eax, offset KeyString
	
	push   eax						; 4 �������� - 1 �����
	inc    eax
	push   eax						; 3 �������� - 2 �����
	inc    eax
	push   eax						; 2 �������� - 3 �����
	push   offset DefString         ; 1 �������� - ������
	
	call   outOfLetters
	
	invoke wsprintf, addr ValueLength, addr Format, eax
	invoke MessageBox, NULL, addr ValueLength, addr MsgBoxName, MB_YESNO
	
	cmp    eax, IDYES
	mov    mode, 0
	jz     start
	jmp    exit	
	
errDefLength:						; ��������� ������
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

errRet:								; ��������� ��������
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











