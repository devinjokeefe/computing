;
; CS1022 Introduction to Computing II 2018/2019
; Lab 2 - Subarray
;

N	EQU	7
M	EQU	3		

	AREA	RESET, CODE, READONLY
	ENTRY

	; initialize system stack pointer (SP)
	LDR	SP, =0x40010000

	;
	; Write your program here to determine whether SMALL_A
	;   is a subarray of LARGE_A
	;
	; Store 1 in R0 if SMALL_A is a subarray and zero otherwise
	;
	
	; checkIfSubMatrix subroutine
	; Takes an index and sets R0 to 1 if it finds that the 3x3 array starting at that index equals SMALL_A
	; Parameters - R1 - i index
	;			   R2 - j index
	
	B startProgram

checkIfSubMatrix
	PUSH	{R1-R8, lr}				; save registers
	
	MOV R3, #0						; a = 0
subLoopOne							; for (int a = 0;
	CMP R3, #M						;	   a < M;
	BHS endSubLoopOne				;	   a++) {
	
	MOV R4, #0						; b = 0
subLoopTwo							; for (int b = 0;
	CMP R4, #M						;	   b < M;
	BHS endSubLoopTwo				;	   b++) {
	
	MOV R5, #12
	MUL R5, R3, R5					; i offset = a * 4
	MOV R6, R4, LSL #2				; j offset = b * 16
	ADD R5, R5, R6					; total offset = i offset + j offset
	LDR R5, [R9, R5]				; R5 = SMALL_A[a, b]
	
	ADD R6, R2, R4					; LARGE_A i index = a + i
	MOV R6, R6, LSL #2				; LARGE_A i offset = (a+i) * 4
	ADD R7, R1, R3					; LARGE_A j index = b + j
	MOV R8, #28
	MUL R7, R8, R7					; LARGE_A j offset = (b+j) * 16
	ADD R6, R6, R7					; LARGE_A total offset = LARGE_A i offset + LARGE_A j offset
	LDR R6, [R10, R6]				; R6 = LARGE_A[a+i, b+j]
	
	CMP R5, R6						; if (R5 != R6 {
	BNE notEqual					; 	GOTO end }
	
	ADD R4, R4, #1					; b++
	B subLoopTwo					; }
endSubLoopTwo

	
	ADD R3, R3, #1					; a++
	B subLoopOne					; }
endSubLoopOne
	MOV R0, #1
	
notEqual
	POP	{R1-R8, pc}					; restore registers
	
startProgram	
	LDR R9, =SMALL_A				; R9 = Address of Small array
	LDR R10, =LARGE_A				; R10 = Address of Large array
	
	MOV R1, #0						; j = 0
forOne								; for (int j = 0;
	CMP R1, #N						;	   j < N;
	BHS endForOne					;	   j++) {
	
	MOV R2, #0						; i = 0
forTwo								; for (int i = 0;
	CMP R2, #N						;	   i < N;
	BHI endForTwo					;	   i++) {
	
	BL checkIfSubMatrix				;	checkIfSubMatrix(i,j)
	CMP R0, #1
	BEQ final
	
	ADD R2, R2, #1					; i++
	B forTwo						; }
endForTwo
	
	ADD R1, R1, #1					; j++
	B forOne						; }
endForOne
	
;
; test data
;

LARGE_A	DCD	 48, 37, 15, 44,  3, 17, 26
	DCD	  2,  9, 12, 18, 14, 33, 16
	DCD	 13, 20,  1, 22,  7, 48, 21
	DCD	 27, 19, 44, 49, 44, 18, 10
	DCD	 29, 17, 22,  4, 46, 43, 41
	DCD	 37, 35, 38, 34, 16, 25,  0
	DCD	 17,  0, 48, 15, 27, 35, 11

SMALL_A	DCD	 49, 44, 18
	DCD	  4, 46, 45
	DCD	 34, 16, 25

final
	END
