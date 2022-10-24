; InputBox Prototype
; The function returns the length of the entered text in EAX
; If there is an error, the function returns 0
InputBox  PROTO   IB_SCText:DWORD,\	   ; Text displayed in the InputBox window
                  IB_Caption:DWORD,\   ; InputBox window header
                  IB_Buffer:DWORD	   ; Container for entered text
