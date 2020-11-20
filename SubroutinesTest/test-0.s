;
; CS1022 Introduction to Computing II 2019/2020
; eTest Group 3 Q1
;

N	EQU	9


	AREA	globals, DATA, READWRITE

array	SPACE	1024


	AREA	RESET, CODE, READONLY
	ENTRY

	; initialise the system stack pointer
	LDR	SP, =0x40010000


	LDR	R4, =array
	LDR	R5, =N	

	;
	; Your program goes here
	; (i.e. your translation of the pseudocode provided
	;
	
	MOV R0, #0						; int i = 0
forOne								; for (int i = 0;
	CMP R0, R5						;	   i < N;
	BHS endForOne					;	   i ++) {
	
	MOV R1, #0						; int j = 0
forTwo								; for (int j = 0;
	CMP R1, R5						;	   j < N;
	BHS endForTwo					;	   j ++) {
	
	MOV R2, R5, LSL #2				;	temp = N*4
	MUL R2, R0, R2					;	y offset = i*N*4
	MOV R3, R1, LSL #2				;	x offset = j*4
	ADD R2, R2, R3					;	total offset = x offset + y offset
	
	CMP R0, R1
	BLS elseFunc					; if (i > j) {
	STR R0, [R4, R2]				;	array[i, j] = i
	B	endIfStmnt					; }
	
elseFunc							; else {
	STR R1, [R4, R2]				;	array[i, j] = j }
	
endIfStmnt
	ADD R1, R1, #1					; j ++
	B forTwo						; }
endForTwo
	
	ADD R0, R0, #1					; i ++
	B forOne						; }
endForOne

STOP	B	STOP


	END
