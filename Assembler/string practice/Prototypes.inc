; InputBox Prototype
; Функция возвращает в EAX длину введённого текста
; В случае ошибки, функция возвращает 0
InputBox  PROTO   IB_SCText:DWORD,\	   ; Текст, показываемый в окне InputBox
                  IB_Caption:DWORD,\   ; Заголовок окна InputBox
                  IB_Buffer:DWORD	   ; Контейнер для введённого текста
