.386
.model flat,stdcall
.stack 4096
ExitProcess PROTO, dwExitCode:DWORD
atoi PROTO C strptr:DWORD

include irvine32.inc

.data
MAX = 100
stringIn BYTE MAX+1 DUP(?), 0
string1 BYTE MAX+1 DUP(?), 0
string2 BYTE MAX+1 DUP(?), 0
SYM_ADD BYTE '+'
SYM_SUB BYTE '-'
SYM_MUL BYTE '*'
SYM_DIV BYTE '/'
CURR_SYM_ADD BYTE '+'
CURR_SYM_MUL BYTE '*'
RES_ADD DWORD 0
RES_MUL DWORD 1
PARSE_RES DWORD 0
Iterator1 BYTE 0
Iterator2 BYTE 0
.code
main PROC
lea edx, stringIn
mov ecx, MAX+1
call ReadString
call splitByAdd	
mov eax, RES_ADD
call writeint
INVOKE ExitProcess,0
main ENDP

splitByMul PROC
MOV RES_MUL, 1
xor esi, esi
xor edi, edi
xor ebx, ebx
xor ecx, ecx
lea edx, string2
LOOP1:
	mov bl, [string1 + esi]
	CMP bl, 0
	JE End_Cont
	cmp bl, SYM_MUL
	JE MUL_Cont
	cmp bl, SYM_DIV
	JE DIV_Cont
	mov [string2 + edi], bl
	inc ecx
	Inc_lbl: inc esi
	inc edi
	JMP LOOP1
	
	MUL_Cont:
	lea edx, string2
	call ParseInteger32
	cmp CURR_SYM_MUL, '*'
	JE MUL_RES
	MOV PARSE_RES, EAX
	MOV EAX, RES_MUL
	mov edx, 0
	IDIV PARSE_RES
	MOV RES_MUL, EAX
	JMP Cont_MUL
	MUL_RES:
	IMUL EAX, RES_MUL
	MOV RES_MUL, EAX
	Cont_MUL:
	MOV CURR_SYM_MUL, '*'
	MOV edi, -1
	mov ecx, 0
	push eax
	call resetstring2
	pop eax
	JMP Inc_lbl
	DIV_Cont:
	lea edx, string2
	call ParseInteger32
	cmp CURR_SYM_MUL, '*'
	JE MUL_RES2
	MOV PARSE_RES, EAX
	MOV EAX, RES_MUL
	MOV edx, 0
	IDIV PARSE_RES
	MOV RES_MUL, EAX
	JMP Cont_DIV
	MUL_RES2:
	IMUL EAX, RES_MUL
	MOV RES_MUL, EAX
	Cont_DIV:
	MOV CURR_SYM_MUL, '/'
	MOV edi, -1
	mov ecx, 0
	push eax
	call resetstring2
	pop eax
	JMP Inc_lbl
	
	End_Cont:
	lea edx, string2
	call ParseInteger32
	cmp CURR_SYM_MUL, '*'
	JE MUL_RES3
	MOV PARSE_RES, EAX
	MOV EAX, RES_MUL
	mov edx, 0
	IDIV PARSE_RES
	MOV RES_MUL, EAX
	JMP Cont_F
	MUL_RES3:
	IMUL EAX, RES_MUL
	MOV RES_MUL, EAX
	Cont_F:
	MOV CURR_SYM_MUL, '*'
	push eax
	call resetstring2
	pop eax
	ret
splitByMul ENDP

splitByAdd PROC
xor esi, esi
xor edi, edi
LOOP1:
	mov cl, [edx + esi]
	CMP cl, 0
	JE End_Cont
	cmp cl, SYM_ADD
	JE ADD_Cont
	cmp cl, SYM_SUB
	JE SUB_Cont
	mov [string1 + edi], cl
	Inc_lbl: inc esi
	inc edi
	JMP LOOP1
	
	ADD_Cont:
	push esi
	push edi
	push edx
	push ecx
	call splitByMul
	pop ecx
	pop edx
	pop edi
	pop esi
	cmp CURR_SYM_ADD, '+'
	JE ADD_RES
	MOV EAX, RES_MUL
	SUB RES_ADD, EAX
	JMP Cont_ADD
	ADD_RES:
	MOV EAX, RES_MUL
	ADD RES_ADD, EAX
	Cont_ADD:
	MOV CURR_SYM_ADD, '+'
	MOV edi, -1
	push eax
	call resetstring1
	pop eax
	JMP Inc_lbl
	SUB_Cont:
	push esi
	push edi
	push edx
	push ecx
	call splitByMul
	pop ecx
	pop edx
	pop edi
	pop esi
	cmp CURR_SYM_ADD, '+'
	JE ADD_RES2
	MOV EAX, RES_MUL
	SUB RES_ADD, EAX
	JMP Cont_SUB
	ADD_RES2:
	MOV EAX, RES_MUL
	ADD RES_ADD, EAX
	Cont_SUB:
	MOV CURR_SYM_ADD, '-'
	MOV edi, -1
	push eax
	call resetstring1
	pop eax
	JMP Inc_lbl
	
	End_Cont:
	push esi
	push edi
	push edx
	push ecx
	call splitByMul
	pop ecx
	pop edx
	pop edi
	pop esi
	cmp CURR_SYM_ADD, '+'
	JE ADD_RES3
	MOV EAX, RES_MUL
	SUB RES_ADD, EAX
	JMP Cont_F2
	ADD_RES3:
	MOV EAX, RES_MUL
	ADD RES_ADD, EAX
	Cont_F2:
	MOV CURR_SYM_ADD, '+'
	push eax
	call resetstring1
	pop eax
	ret
splitByAdd ENDP	

resetstring1 PROC
mov eax, 0
LOOP1: cmp eax, MAX+1
JG Finish
MOV [string1 + eax], 0
inc eax
JMP LOOP1
Finish:
ret
resetstring1 ENDP

resetstring2 PROC
mov eax, 0
LOOP1: cmp eax, MAX+1
JG Finish
MOV [string2 + eax], 0
inc eax
JMP LOOP1
Finish:
ret
resetstring2 ENDP
END main