; Program Description:
; Author:
; Date:

.386
.model flat,stdcall
.stack 4096
ExitProcess PROTO, dwExitCode:DWORD

include irvine32.inc

.data
; declare variables here
mySTR byte 'Hello\World', 0
LEN equ $ - mySTR
STR1 byte 5 DUP(?), 0
STR2 byte 5 DUP(?), 0
SYM byte '\'
NewLine byte 0ah, 0dh
.code
main PROC
 ; write your code here
 mov cl, SYM
 mov esi, offset mySTR
 mov edi, offset STR1
 xor ebx, ebx
 xor edx, edx
 LOOP1:
	mov al, [esi + ebx]
	cmp al, cl
	JNE Cont
	;mov al, 0
	;mov [edi + edx], al
	mov edi, offset STR2
	xor edx, edx
	add ebx, 1
	jmp LOOP1
	Cont:
		mov [edi + edx], al
		add edx, 1
		add ebx, 1
		cmp ebx, LEN
		JL LOOP1
;mov al, 0
;mov [edi + edx], al
xor edx, edx
mov edx, offset STR1
xor eax, eax
mov ah, 09h
lea edx, mySTR
call writestring
lea edx, NewLine
call writestring
lea edx, STR1
call writestring
lea edx, NewLine
call writestring
lea edx, STR2
call writestring
 INVOKE ExitProcess,0
main ENDP

; (insert additional procedures here)
END main