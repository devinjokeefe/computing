;
; CS1022 Introduction to Computing II 2019/2020
; Lab 1B - Bubble Sort
;

N	EQU	10

	AREA	globals, DATA, READWRITE

; N word-size values

SORTED	SPACE	N*4		; N words (4 bytes each)


	AREA	RESET, CODE, READONLY
	ENTRY


	;
	; copy the test data into RAM
	;

	LDR	R4, =SORTED
	LDR	R5, =UNSORT
	LDR	R6, =0
whInit	
	CMP	R6, #N
	BHS	eWhInit
	LDR	R7, [R5, R6, LSL #2]
	STR	R7, [R4, R6, LSL #2]
	ADD	R6, R6, #1
	B	whInit
eWhInit

	LDR	R4, =SORTED
	LDR	R5, =UNSORT
	
	BL	sort

	;
	; your sort subroutine goes here
	;

sort

do								; do {
	MOV R8, #0					; swapped = false
	MOV R9, #1					; i = 1					
for
	CMP R9, #N					; for (int i = 1; i < N; i++)
	BHS endfor					; {
	SUB R7, R9, #1				;	R7 = i - 1
	LDR R10, [R4, R7, LSL #2]	;	R2 = array[i-1]
	LDR R11, [R4, R9, LSL #2]	; 	R3 = array[i]
	CMP R10, R11					;	if (array[i-1] > array[i])
	BLS ifend					;	{
	LDR R6, [R4, R7, LSL #2]	;		tmpswap = array[i-1]
	STR R11, [R4, R7, LSL #2]	;		array[i-1] = array[i]
	STR R6, [R4, R9, LSL #2]	;		array[i] = tmpswap
	MOV R8, #1					;		swapped = true
ifend							; 	}
	ADD R9, R9, #1
	B for
endfor							; }
	CMP R8, #1					; while (swapped)
	BEQ do
	BX	lr

UNSORT	DCD	1,5,3,9,4,8,0,1,7,6

	END
