.386					;architecture
.model flat,stdcall		;"memory model"... indicates how functions get called
.stack 4096				;stack size -> 4k of memory

includelib libcmt.lib						;these two libraries give us basic I/O Functions
includelib legacy_stdio_definitions.lib

extern printf:NEAR		;tells the linker that printf is in one of the includelibs
extern scanf:NEAR		;tells the linker that scanf is in one of the includelibs

ExitProcess PROTO, dwExitCode:DWORD			;makes sure we have the ExitProcess
											;function so we can terminate the program

.data
myList DWORD 4, 2, 4, 3, 5, 9, 2, 1, 5, 6, 8, -1	;declares an array using DWORD values
msg1 BYTE "First number: %d", 0ah, 0				;declares 4 different BYTE strings
msg2 BYTE "%d ", 0
msg3 BYTE 0ah, 0
msg4 BYTE "Second number: %d", 0ah, 0

.code
main PROC c
	;Code for class goes here
	
	push offset mylist		;pushes the offset of mylist onto the stack
	call fun4				;(prints each element of myList until it encounter -1, then prints msg3)
	add esp, 4				;adjusts the stack pointer 4 bytes

	push offset mylist		;pushes the offset of mylist onto the stack
	call fun1				;(calculates the average of the elements in myList)
	add esp, 4				;adjusts the stack pointer 4 bytes

	push eax				;pushes eax onto the stack
	push offset msg1		;pushes the offset of msg1 onto the stack
	call printf				;calls printf
	add esp, 8				;adjusts the stack pointer 8 bytes

	push offset mylist		;pushes the offset of mylist onto the stack
	call fun2				;(sorts mylist by using a bubble sort algorithm)
	add esp, 4				;adjusts the stack pointer 4 bytes

	push offset mylist		;pushes the offset of mylist onto the stack
	call fun4				;(prints each element of mylist until it encounter -1, then prints msg3)
	add esp, 4				;adjusts the stack pointer 4 bytes

	push offset mylist		;pushes the offset of mylist onto the stack
	call fun3				;(calculates the midpoint of mylist)
	add esp, 4				;adjusts the stack pointer 4 bytes

	push eax				;pushes eax onto the stack
	push offset msg4		;pushes the offset of msg4 onto the stack
	call printf				;calls printf
	add esp, 4				;adjusts the stack pointer 4 bytes

	INVOKE ExitProcess,0	;terminates the program

fun1:
	push ebp							;pushes ebp onto the stack
	mov ebp, esp						;moves the stack pointer (esp) into ebp
	
	sub esp, 4							;subtracts 4 from the stack pointer
	mov eax, 0							;clears eax
	mov [ebp-4], eax					;sets

	mov ecx, 0							;initializes loop counter (ecx) to 0
	mov eax,[ebp+8]						;loads offset of mylist into eax
	
	looptop:
		mov edx, [eax + ecx * 4]        ;calculates the offset of the array
		cmp edx, -1					    ;ends the loop if edx = -1
		je endloop

		mov ebx, [ebp-4]				;loads the current sum into ebx
		add ebx, edx					;adds the current element into ebx
		mov [ebp-4], ebx				;stores the total in ebp-4
		add ecx, 1						;increments loop counter
		jmp looptop

	endloop:
	
	mov eax, [ebp-4]					;stores the accumulated sum in eax
	mov edx, 0							;resets edx to 0
	div ecx								;calculates the average of the elements in mylist

	mov esp, ebp					;restores the stack pointer, pops the base pointer
	pop ebp
	ret								;returns function

fun2:
	push ebp							;pushes ebp onto the stack
	mov ebp, esp						;moves the stack pointer (esp) into ebp

	push 0								;pushes 0 onto the stack
	mov eax,[ebp+8]						;moves address of mylist array into eax

	
	looptop3:
		mov edx, 0						;clears edx
		mov [ebp-4], edx				;initializes ebp-4 to 0
		mov ecx, 1						;initializes the loop counter to 1
		looptop2:
			
			mov ebx, ecx				;sets ebx to previous index
			sub ebx, 1
			mov edx, [eax + ecx * 4]	;loads the current and previous array elements into edx
			cmp edx, -1					;checks if the current element is -1
			je endloop2
			cmp edx, [eax + ebx * 4]	;checks if the current element is greater than or equal to the previous element
			jge pastif					;If element is smaller than previous element
				push edx					;pushes edx onto the stack
				mov edx, [eax + ebx * 4]	;swaps the current and previous element
				mov [eax + ecx * 4], edx
				pop edx						;pops edx off the stack
				mov [eax + ebx * 4], edx
				mov edx, 1					;sets edx to 1
				mov [ebp-4], edx
			pastif:
			add ecx, 1						;sets ecx to 1
			jmp looptop2

		endloop2:



		mov edx, [ebp-4]				;if ebp-4 is 1, then go through the loop again
		cmp edx, 1						;basically if a swap occurs, then go back
		je looptop3
	endloop3:

	mov esp, ebp					;restores the stack pointer, pops the base pointer
	pop ebp
	ret								;returns function

fun3:

	push ebp						;pushes ebp onto the stack
	mov ebp, esp					;moves the stack pointer (esp) into ebp
	
	mov ecx, 0						;initializes the loop counter (ecx) to 0
	mov eax,[ebp+8]					;moves address of mylist array into eax
	
	looptop4:						
		mov edx, [eax + ecx * 4]	;calculates the offset of the array
		cmp edx, -1					;ends the loop if edx = -1
		je endloop4
		add ecx, 1					;otherwise increments the loop counter
		jmp looptop4				

	endloop4:
	
	mov ebx, eax					;moves the address of the array into ebx
	mov eax, ecx					;moves the loop counter (ecx) into eax
	mov edx, 0						;clears edx
	mov ecx, 2						;sets ecx to 2.
	div ecx							;divides the value in eax by the value in ecx. The quotient will be stored in eax, and the remainder will be stored in edx.
	mov ecx, eax					;moves the quotient (the calculated midpoint) from eax into ecx.
	mov eax, ebx					;restores the original address of the array into eax.
	mov eax, [eax + ecx * 4]		;calculates the address of the element at the midpoint (ecx) of the array and load its value into eax.

	mov esp, ebp					;restores the stack pointer, pops the base pointer
	pop ebp
	ret								;returns function

fun4:
	push ebp						;pushes ebp onto the stack
	mov ebp, esp					;moves the stack pointer (esp) into ebp
	
	mov eax,[ebp+8]					;moves address of mylist array into eax
	mov ecx, 0						;initializes the loop counter (ecx) to 0
	
	looptop6:
		mov edx, [eax + ecx * 4]	;calculates the offset of the array
		cmp edx, -1					;ends the loop if edx = -1
		je endloop6

		push eax					;pushes the registers onto the stack
		push ebx
		push ecx
		push edx

		push edx					;pushing the arguments of printf onto the stack
		push offset msg2
		call printf					;prints msg2 and edx
		add esp, 8					;readjusts the stack pointer
		
		pop edx						;pops the registers off of the stack
		pop ecx
		pop ebx
		pop eax

		add ecx, 1					;increments the loop counter
		
		jmp looptop6

	endloop6:
	
	push offset msg3				;pushes the arguments of printf onto the stack
	call printf						;prints msg3
	add esp, 4						;readjusts the stack pointer

	mov esp, ebp					;restores the stack pointer, pops the base pointer
	pop ebp
	ret								;returns function

main endp
end