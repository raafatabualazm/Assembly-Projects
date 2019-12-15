.386
.model flat,stdcall
.stack 4096
ExitProcess PROTO, dwExitCode:DWORD

include irvine32.inc

.data
v0 DWORD ?
ZERO1 BYTE 0
v1 DWORD ?
ZERO2 BYTE 0
key0 DWORD 12
key1 DWORD 34
key2 DWORD 56
key3 DWORD 78
delta DWORD 9E3779B9H
sum DWORD 0
v0l4 DWORD 0
v1l4 DWORD 0
v0r5 DWORD 0
v1r5 DWORD 0
v0ps DWORD 0
v1ps DWORD 0
MAX = 9
stringIn BYTE MAX+1 DUP(?)
stringEnc BYTE MAX+1 DUP(?)
stringDec BYTE MAX+1 DUP(?)
NewLine byte 0ah, 0dh
.code
main PROC
lea edx, stringIn
MOV ecx, MAX
call ReadString
call WriteString
lea ecx, stringIn
mov eax, DWORD PTR[ecx]
mov v0, eax
mov eax, DWORD PTR[ecx + 4]
mov v1, eax
lea edx, newline
call WriteString



push eax
push ebx
push ecx
push edx
push esi
push edi
call encrypt
pop edi
pop esi
pop edx
pop ecx
pop ebx
pop eax

lea edx, stringEnc
mov eax, v0
mov ebx, v1
mov DWORD PTR[edx], eax
mov DWORD PTR[edx + 4], ebx
call WriteString
lea edx, newline
call WriteString



push eax
push ebx
push ecx
push edx
push esi
push edi
call decrypt
pop edi
pop esi
pop edx
pop ecx
pop ebx
pop eax

lea edx, stringDec
mov eax, v0
mov ebx, v1
mov DWORD PTR[edx], eax
mov DWORD PTR[edx + 4], ebx
call WriteString
lea edx, newline
call WriteString
lea edx, newline
call WriteString


INVOKE ExitProcess,0
main ENDP

encrypt PROC
xor eax, eax
xor ebx, ebx
xor ecx, ecx
xor edx, edx
xor esi, esi
xor edi, edi
mov ecx, 32
LOOP1:
;sum+= delta
mov eax, sum
ADD eax, delta
mov sum, eax
; (v1 << 4) + k0
mov eax, v1
SAL eax, 4
ADD eax, key0
mov v1l4, eax 
; (v1 + sum)
mov eax, v1
ADD eax, sum
mov v1ps, eax
; (v1 >> 5) + k1
mov eax, v1
SHR eax, 5
add eax, key1
mov v1r5, eax
;((v1 << 4) + k0) ^ (v1 + sum) ^ ((v1 >> 5) + k1)
mov eax, v1l4
xor eax, v1ps
xor eax, v1r5
; v0 += ((v1 << 4) + k0) ^ (v1 + sum) ^ ((v1 >> 5) + k1)
ADD v0, eax
; (v0 << 4) + k2
mov eax, v0
SAL eax, 4
ADD eax, key2
mov v0l4, eax 
; (v0 + sum)
mov eax, v0
ADD eax, sum
mov v0ps, eax
; (v0 >> 5) + k3
mov eax, v0
SHR eax, 5
add eax, key3
mov v0r5, eax
; ((v0 << 4) + k2) ^ (v0 + sum) ^ ((v0 >> 5) + k3)
mov eax, v0l4
xor eax, v0ps
xor eax, v0r5
; v1 += ((v0 << 4) + k2) ^ (v0 + sum) ^ ((v0 >> 5) + k3)
ADD v1, eax

dec ecx
cmp ecx, 0
JG LOOP1
ret
encrypt ENDP

decrypt PROC
xor eax, eax
xor ebx, ebx
xor ecx, ecx
xor edx, edx
xor esi, esi
xor edi, edi
mov ecx, 32
LOOP2:
; (v0 << 4) + k2
mov eax, v0
SAL eax, 4
ADD eax, key2
mov v0l4, eax 
; (v0 + sum)
mov eax, v0
ADD eax, sum
mov v0ps, eax
; (v0 >> 5) + k3
mov eax, v0
SHR eax, 5
ADD eax, key3
mov v0r5, eax
; ((v0 << 4) + k2) ^ (v0 + sum) ^ ((v0 >> 5) + k3)
mov eax, v0l4
xor eax, v0ps
xor eax, v0r5
; v1 -= ((v0 << 4) + k2) ^ (v0 + sum) ^ ((v0 >> 5) + k3)
SUB v1, eax

; (v1 << 4) + k0
mov eax, v1
SAL eax, 4
ADD eax, key0
mov v1l4, eax 
; (v1 + sum)
mov eax, v1
ADD eax, sum
mov v1ps, eax
; (v1 >> 5) + k1
mov eax, v1
SHR eax, 5
ADD eax, key1
mov v1r5, eax
; ((v1 << 4) + k0) ^ (v1 + sum) ^ ((v1 >> 5) + k1)
mov eax, v1l4
xor eax, v1ps
xor eax, v1r5
; v0 -= ((v1 << 4) + k0) ^ (v1 + sum) ^ ((v1 >> 5) + k1)
SUB v0, eax
; sum -= delta
mov eax, sum
SUB eax, delta
mov sum, eax

dec ecx
cmp ecx, 0
JG LOOP2
ret
decrypt ENDP
END main