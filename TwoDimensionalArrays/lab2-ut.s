;
; CS1022 Introduction to Computing II 2018/2019
; Lab 2 - Upper Triangular
;

N	EQU	4		

	AREA	RESET, CODE, READONLY
	ENTRY

	; initialize system stack pointer (SP)
	LDR	SP, =0x40010000

	;
	; write your program here to determine whether ARR_A
	;   (below) is a matrix in Upper Triangular form.
	;
	; Store 1 in R0 if the matrix is in Upper Triangular form
	;   and zero otherwise.
	;

	LDR R1, =ARR_A
	LDR R2, =N
	SUB R2, R2, #1		; R2 = N-1
	LDR R0, =1			; R0 = 0
	
	MOV R3, #0			; int i = 0
forOne					; for (int i = 0;
	CMP R3, R2			;	   i < N-1;
	BHS endForOne		;	   i++) {
								   
	MOV R4, #0			; int j = 0
forTwo					; for (int j = 0;
	CMP R4, R2			;	   j < N-1;
	BHS endForTwo		;	   j++) {
	CMP R3, R4			;	if (i == j) 
	BNE notEqual		; 	  {
	
	MOV R5, R3, LSL #2	;	i offset = i * 4
	
	ADD R7, R4, #1		;	R7 = j+1				
	MOV R6, R7, LSL #4	;	j offset = (j+1) * 16
	
	ADD R6, R5, R6		;	ij offset = i offset + j offset
	LDR R6, [R1, R6]	;	R6 = A[i,j+1]
	CMP R6, #0			; 	if (A[i, j+1] != 0)
	BEQ notEqual		;	  {
	MOV R0, #0			;		isUpperTriangular = false; 
						;	  }
	
notEqual
	ADD R4, R4, #1		; j++
	B	forTwo
	
endForTwo				; }

	ADD R3, R3, #1		; i++
	B forOne
endForOne				; }

STOP	B	STOP

;
; test data
;

ARR_A	DCD	 1,  4,  3,  7
	DCD	 0,  90,  12,  3
	DCD	 0,  0, 0, 12
	DCD	 0,  0,  0, 16

	END
