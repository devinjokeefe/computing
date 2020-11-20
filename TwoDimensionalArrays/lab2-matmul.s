;
; CS1022 Introduction to Computing II 2018/2019
; Lab 2 - Matrix Multiplication
;

N	EQU	4		

	AREA	globals, DATA, READWRITE

; result array
ARR_R	SPACE	N*N*4		; N*N words (4 bytes each)


	AREA	RESET, CODE, READONLY
	ENTRY

	; initialize system stack pointer (SP)
	LDR	SP, =0x40010000

	;
	; write your matrix multiplication program here
	;
	
	LDR R4, =ARR_A
	LDR R5, =ARR_B
	LDR R6, =ARR_R
	
	MOV R0, #0					; i = 0
forOne							; for (int i = 0;
	CMP R0, #N					;	   i < N;
	BGE endForOne				;	   i++) {
	
	MOV R1, #0					; j = 0
forTwo							; for (int j = 0;
	CMP R1, #N					;	   j < N;
	BGE endForTwo				;	   j++) {
	MOV R3, #0					;	r = 0
	
	MOV R2, #0					; k = 0
forThree						; for (int k = 0;
	CMP R2, #N					;	   k < N;
	BGE endForThree				;	   k++) {
	
	MOV R7, #16					;	R7 = 16
	MUL R7, R0, R7				;	i offset = (i) * 16
	
	MOV R8, #4					;	R8 = 4
	MUL R8, R2, R8				;	k offset = (k) * 4				
	
	ADD R7, R7, R8				;	ik offset = i + k
	LDR R9, [R4, R7]			;	R9 = A[i,k]
	
	MOV R7, #16					;	R7 = 16
	MUL R7, R2, R7				;	k offset = (k) * 16
	
	MOV R8, #4					;	R8 = 4
	MUL R8, R1, R8				;	j offset = (j) * 4				
	
	ADD R7, R7, R8				;	kj offset = k + j
	LDR R10, [R5, R7]			;	R10 = B[k, j]
	
	MUL R7, R9, R10				; 	R7 = A[i,k] * B[k, j]
	ADD R3, R3, R7				;	r = r + (A[i,k] * B[k, j])

	ADD R2, R2, #1				; k++
	B forThree					; }
endForThree

	MOV R7, #16					;	R7 = 16
	MUL R7, R0, R7				;	i offset = (i) * 16
	
	MOV R8, #4					;	R8 = 4
	MUL R8, R1, R8				;	j offset = (j) * 4				
	
	ADD R7, R7, R8				;	ij offset = i + j
	STR R3, [R6, R7]			;	R[i, j] = r

	ADD R1, R1, #1				; j++
	B forTwo					; }
endForTwo

	ADD R0, R0, #1				; i++
	B forOne					; }
endForOne
	

STOP	B	STOP


;
; test data
;

ARR_A	DCD	 1,  2,  3,  4
	DCD	 5,  6,  7,  8
	DCD	 9, 10, 11, 12
	DCD	13, 14, 15, 16

ARR_B	DCD	 1,  2,  3,  4
	DCD	 5,  6,  7,  8
	DCD	 9, 10, 11, 12
	DCD	13, 14, 15, 16

	END
