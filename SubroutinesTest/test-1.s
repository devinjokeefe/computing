;
; CS1022 Introduction to Computing II 2019/2020
; eTest Group 3 Q1
;

	AREA	globals, DATA, READWRITE

arrA	SPACE	1024
arrB	SPACE	1024


	AREA	RESET, CODE, READONLY
	ENTRY

	; initialise the system stack pointer
	LDR	SP, =0x40010000

	;
	; initialise arrays by copying from ROM to RAM
	;

	LDR	R0, =arrA	; destination in RAM
	LDR	R1, =initA	; source in ROM
	LDR	R4, =sizeA
	LDR	R2, [R4]	; size of arrA
	BL	copy_arr

	LDR	R0, =arrB	; destination in RAM
	LDR	R1, =initB	; source in ROM
	LDR	R4, =sizeB
	LDR	R2, [R4]	; size of arrB
	BL	copy_arr

	;
	; Your program to test your subroutine goes here
	;
	
	LDR R0, =arrA	; R0 = Start address of array A
	LDR	R4, =sizeA
	LDR	R1, [R4]	; R1 = Size of arrA
	LDR R2, =arrB	; R2 = Start address of array B
	LDR R4, =sizeB
	LDR R3, [R4]	; R3 = Size of arrB
	
	BL	difference	; difference (arrA, sizeA, arrB, sizeB)

STOP	B	STOP

;
; Initial data
;
sizeA	DCD	10				; test array size
initA	DCD	6, 2, 7, 9, 1, 3, 2, 6, 9, 1	; test array elements

sizeB	DCD	4				; test array size
initB	DCD	2, 7, 5, 3			; test array elements



;
; Your subroutine goes here
;

; difference subroutine
; Removes an element from some given arrayA if it is also in arrayB
; Parameters:
;	R0 - start address of array A 
;	R1 - number of elements in array A
;	R2 - start address of array B
;	R3 - number of elements in array B
; Return Value:
;	none
difference
	PUSH {R4-R11, lr}

	MOV R4, R0					; R4 = arrA
	MOV R5, R1					; R5 = sizeA
	MOV R6, R2					; R6 = arrB
	MOV R7, R3					; R7 = sizeB
	
	MOV R8, #0					; int i = 0
forOne							; for (int i = 0;
	CMP R8, R7					;	   i < sizeB
	BHS endForOne				;	   i ++) {
	
	MOV R9, #0					; int j = 0
forTwo							; for (int j = 0;
	CMP R9, R5					;	   j < sizeA;
	BHS endForTwo				;	   j ++) {
		
	LDR R10, [R4, R9, LSL #2]	; R10 = arrA[j]
	LDR R11, [R6, R8, LSL #2]	; R11 = arrB[i]
	CMP R10, R11
	BNE notEqual				; if (arrA[j] == arrB[i]) {
	PUSH {R0-R2}				; 	Save Registers R0-R2
	MOV R0, R4					;	R0 = arrA start address
	MOV R1, R9					;	R1 = j
	MOV R2, R5					;	R2 = sizeA
	BL	remove					;	remove(arrA, j, sizeA)
	POP {R0-R2}					;	Restore Registers R0-R2
	
	SUB R5, R5, #1				;	sizeA = sizeA - 1

notEqual						; }
	ADD R9, R9, #1				; j ++
	B forTwo					; }
endForTwo
	
	ADD R8, R8, #1				; i ++
	B forOne					; }
endForOne

	POP {R4-R11, pc}

; remove subroutine
; Removes an element from an array of word size values
; Parameters:
;   R0 - start address of array
;   R1 - index of element to remove
;   R2 - number of elements in the array
; Return Value:
;   none
remove
	PUSH	{R4-R6}

	ADD	R4, R1, #1
whRemove
	CMP	R4, R2
	BHS	eWhRemove
	LDR	R5, [R0, R4, LSL #2]
	SUB	R6, R4, #1
	STR	R5, [R0, R6, LSL #2]
	ADD	R4, R4, #1
	B	whRemove
eWhRemove
	POP	{R4-R6}
	BX	LR



; copy_arr subroutine
; Copies an array of words in memory
; Parameters:
;   R0 - destination address
;   R1 - source address
;   R2 - number of words to copy
; Return Value:
;   none
copy_arr
	PUSH	{R4-R5}
	LDR	R4, =0
wh_copy_arr
	CMP	R4, R2
	BHS	ewh_copy_arr
	LDR	R5, [R1, R4, LSL #2]
	STR	R5, [R0, R4, LSL #2]
	ADD	R4, R4, #1
	B	wh_copy_arr
ewh_copy_arr
	POP	{R4-R5}
	BX	LR

	END
