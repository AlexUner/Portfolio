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
		
		InputBoxName     db "���� ������",0
		InputDefBoxText  db "����������, ������� ������ �� ����� 32 �������� ������!",0
		InputKeyBoxText  db "����������, ������� ����",0
		ChooseMessage    db "�������:", 13, "1. ��,   ��� ������ � ������", 13,
							"2. ���, ��� ������ �� ������ �������",0
		MessageTemplate  db "���������� �������� � �������� ������: %s",0
		Lab4Format 	 	 db "����� ������ ������: %s", 13,
							"������ ������ ����� ������?",0
		Lab3Format       db "����� ������: %s", 13,
							"������ ������ ����� ����?",0

		DefString   	 dd 50  dup (0)
		TmpString   	 db 50  dup (0)
		KeyString   	 db 50  dup (0)
		ValueLength  	 db 255 dup (0)
		mode			 dd 0
		bitmask			 db 0
		
		ErrCaption       db "������",0
		ValueInputError  db "�� �� ����� ��������", 13, "��������� ����?",0
		DefLengthError   db "�� ����� ������ 32 ��������!",0 ;��� 4 ���� � 2 �������
		DefNumberError   db "� ��������� ������ ������������ ������������ �������.", 13, 
	                        "��������� ����?",0
		KeyError         db "���� ������ �������� �� 1 �����!",0
;#########################################################################	
	.code
start:
	invoke InputBox, addr InputDefBoxText, addr InputBoxName, addr DefString
	test   eax, eax                 ; �������� �� �������
	jz 	   errValueInput  			; �� �������
	cmp    eax, 32                  ; �������� �� �����
	ja     errDefLength	  			; ������ 32
	mov    ebx, offset DefString 	; EBX - ��������� �����
	
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
	
	cmp    mode,6
	jz     lab3ret					; ������� �������� ��� 3 4 ����
	cmp    mode,7
	jz     lab4ret	
	
	invoke MessageBox, NULL, addr ChooseMessage, addr MsgBoxName, MB_YESNO
	mov    mode, eax				; ������ ������
	cmp    eax, 7					; ����� ������ ������
	jz     lab4mode 				; ������� ���� �������� �� ��������
	
lab3mode:	
	invoke InputBox, addr InputKeyBoxText, addr InputBoxName, addr KeyString
	test   eax, eax                 ; �������� �� �������
	jz 	   errKeyError
	cmp    eax, 1                   ; �������� �� �����
	ja     errKeyError
	
	mov    ebx, offset KeyString	; �������� �� �����
	jmp    asciicheck
lab3ret:							; ���������� �� ���������   		    	
	mov    ebx, offset DefString	; ����������
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
	
cb:									; ������� "�������"
	cmp    ch,0
	dec    ebx
	dec    ch
	jnz    cb
	
	invoke wsprintf, addr ValueLength, addr Lab3Format, ebx
	invoke MessageBox, NULL, addr ValueLength, addr MsgBoxName, MB_YESNO
	
	cmp    eax, IDYES
	jz     lab3mode
	jmp    exit						; ����� 3 ����
	
lab4mode:
	invoke InputBox, addr InputDefBoxText, addr InputBoxName, addr KeyString
	test   eax, eax                 ; �������� �� �������
	jz 	   errValueInput
	cmp    eax, 32                  ; �������� �� �����
	ja     errDefLength

	mov    ebx, offset KeyString	; �������� �� �����
	jmp    asciicheck
lab4ret:	
	mov    ebx, offset DefString	; ���������� �����
	mov	   ecx, 0
	mov    dl,  0
	mov    dh,  0                   ; eax  - �������
	
lab4mask:
	inc    dh
	cmp    byte ptr[ebx],0
	jz     lab4out
	cmp    byte ptr[ebx], 90		; ������ ������� ���� � �����			
    ja     lab4next	
    cmp    byte ptr[ebx], 65
    jb     lab4next
	inc    ebx		
	inc    dl 						; dl - ������� ������� ����
	inc    ecx 						; ������ 1 � �����
	shl    ecx, 1					; �����
	jmp    lab4mask
lab4next:
	inc	   ebx						
	shl    ecx, 1					; ������ 0 � �����
	cmp	   byte ptr[ebx], 0
	jnz    lab4mask	
lab4out:
	shr    ecx, 1					; ecx - ����� ��� ���������� ������� � ������� �����
	mov    ah, 33
	sub    ah, dh
again:
	dec    ah						; �������� ������ � ������ ��� 
	shl    ecx, 1                   ; ������� ������
	cmp    ah, 0
	jnz    again

	
	mov    dh,  0                   ; dh  - �������
	mov    ebx, offset KeyString    ; ebx - ������ ������
	mov    eax, 1b
	ror    eax, 1					; ������ � �����
lab4ans:
	inc    dh						; ����������� �������
	cmp    byte ptr[ebx], 122		; 				
    ja     lab4skip					; ������� ������� ����
    cmp    byte ptr[ebx], 97		;
    jb     lab4skip
	cmp    dl, 0					; ��������� ������� ����� � �����
	jz     lab4exit					; 
	push   eax
	and    eax, ecx					; ���������� � �������� ������
	cmp    eax, 0					; ���� 0 �� �� ��� ���
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
lab4exit:							; ������� "�������"
	cmp    dh,0
	dec    ebx
	dec    dh
	jnz    lab4exit
	
	invoke wsprintf, addr ValueLength, addr Lab4Format, ebx
	invoke MessageBox, NULL, addr ValueLength, addr MsgBoxName, MB_YESNO

	cmp    eax, IDYES
	jz     lab4mode
	jmp    exit						; ����� 4 ����
	
errDefLength:						; ��������� ������
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
	
errRet:								; ��������� ��������
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











