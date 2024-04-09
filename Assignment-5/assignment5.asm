.386
.model flat, stdcall
.stack 4096

includelib libcmt.lib
includelib legacy_stdio_definitions.lib

extern printf:NEAR
extern scanf:NEAR

ExitProcess PROTO, dwExitCode:DWORD


.data
myList DWORD 4, 2, 4, 3, 5, 9, 2, 1, 5, 6, 8, -1
msg1 BYTE "First number: %d", 0ah, 0
msg2 BYTE "%d ", 0
msg3 BYTE 0ah, 0
msg4 BYTE "Second number: %d", 0ah, 0

.code
main PROC c
	;Code for class goes here
	
	push offset mylist
	call fun4
	add esp, 4

	push offset mylist
	call fun1
	add esp, 4

	push eax
	push offset msg1
	call printf
	add esp, 8

	push offset mylist
	call fun2
	add esp, 4

	push offset mylist
	call fun4
	add esp, 4

	push offset mylist
	call fun3
	add esp, 4

	push eax
	push offset msg4
	call printf
	add esp, 4

	INVOKE ExitProcess,0

fun1:
	push ebp
	mov ebp, esp
	
	sub esp, 4
	mov eax, 0
	mov [ebp-4], eax

	mov ecx, 0
	mov eax,[ebp+8]
	
	looptop:
		mov edx, [eax + ecx * 4]
		cmp edx, -1
		je endloop

		mov ebx, [ebp-4]
		add ebx, edx
		mov [ebp-4], ebx
		add ecx, 1
		jmp looptop

	endloop:
	
	mov eax, [ebp-4]
	mov edx, 0
	div ecx

	mov esp, ebp
	pop ebp
	ret

fun2:
	push ebp
	mov ebp, esp

	push 0
	mov eax,[ebp+8]

	
	looptop3:
		mov edx, 0
		mov [ebp-4], edx
		mov ecx, 1
		looptop2:
			
			mov ebx, ecx
			sub ebx, 1
			mov edx, [eax + ecx * 4]
			cmp edx, -1
			je endloop2
			cmp edx, [eax + ebx * 4]
			jge pastif
				push edx
				mov edx, [eax + ebx * 4]
				mov [eax + ecx * 4], edx
				pop edx
				mov [eax + ebx * 4], edx
				mov edx, 1
				mov [ebp-4], edx
			pastif:
			add ecx, 1
			jmp looptop2

		endloop2:



		mov edx, [ebp-4]
		cmp edx, 1
		je looptop3
	endloop3:

	mov esp, ebp
	pop ebp
	ret

fun3:

	push ebp
	mov ebp, esp
	
	mov ecx, 0
	mov eax,[ebp+8]
	
	looptop4:
		mov edx, [eax + ecx * 4]
		cmp edx, -1
		je endloop4
		add ecx, 1
		jmp looptop4

	endloop4:
	
	mov ebx, eax
	mov eax, ecx
	mov edx, 0
	mov ecx, 2
	div ecx
	mov ecx, eax
	mov eax, ebx
	mov eax, [eax + ecx * 4]

	mov esp, ebp
	pop ebp
	ret

fun4:
	push ebp
	mov ebp, esp
	
	mov eax,[ebp+8]
	mov ecx, 0
	
	looptop6:
		mov edx, [eax + ecx * 4]
		cmp edx, -1
		je endloop6

		push eax
		push ebx
		push ecx
		push edx

		push edx
		push offset msg2
		call printf
		add esp, 8
		
		pop edx
		pop ecx
		pop ebx
		pop eax

		add ecx, 1
		
		jmp looptop6

	endloop6:
	
	push offset msg3
	call printf
	add esp, 4

	mov esp, ebp
	pop ebp
	ret

main endp
end