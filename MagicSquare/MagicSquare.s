;
; CS1022 Introduction to Computing II 2018/2019
; Magic Square
;

	AREA	RESET, CODE, READONLY
	ENTRY

	; initialize system stack pointer (SP)
	LDR	SP, =0x40010000

	;
	; test your subroutine here
	;
	
	LDR	R0, =arr1			; R0 = address of arr1
	LDR	R4, =size1			; R4 = address of size1
	LDR	R1, [R4]			; R1 = size1
	BL isMagic				; isMagic (address, size)

	LDR	R0, =arr2			; R0 = address of arr2
	LDR	R4, =size2			; R4 = address of size2
	LDR	R1, [R4]			; R1 = size1
	BL isMagic				; isMagic (address, size)
	
	LDR	R0, =arr3			; R0 = address of arr3
	LDR	R4, =size3			; R4 = address of size3
	LDR	R1, [R4]			; R1 = size1
	BL isMagic				; isMagic (address, size)
	
	LDR	R0, =arr4			; R0 = address of arr4
	LDR	R4, =size4			; R4 = address of size4
	LDR	R1, [R4]			; R1 = size1
	BL isMagic				; isMagic (address, size)
	
stop	B	stop


;
; write your subroutine here
;

; checkMagic
; checks if the columns or rows of the square 2D array all add up, depending on the argument
; parameters : 
;	R0 - Hexadecimal address of the first entry of the 2D array.
;	R1 - Dimension size of the 2D array. 
;   R2 - Boolean - 0 if we are checking rows. 1 if we are checking columns.
; returns : 
;	R0 - Boolean - Is compatible so far with being a magic square
;	R1 - Integer - If compatible, the number which the rows/columns add up to. If not compatible, returns 0.

checkMagic
	PUSH {R2-R11, lr}

	CMP R2, #0				; if (rows) {
	BEQ rows				;   rows() }
	B cols					; else { cols() }
	
rows
	MOV R4, #4				; i multiplier = 4
	MOV R5,	R1, LSL #2		; j multiplier = N * 4
	B initVars

cols
	MOV R4, R1, LSL #2		; i multiplier = N * 4
	MOV R5,	#4				; j multiplier = 4

initVars
	MOV R2, #0				; j = 0
	MOV R3, #0				; i = 0

	MOV R8, #0				; curCounter = 0
	MOV R9, #0				; prevCounter = 0
	MOV R10, R1, LSL #2		; j multiplier = N * 4
	MOV R11, #1				; isFirstCheck = true

	
forOne						; Check rows
	CMP R2, R1				; while (j < n)
	BHS	endForOne			; {
	MOV R3, #0				; i = 0
	MOV R8, #0				; counter = 0
	
forTwo
	CMP R3, R1				; foreach (column)
	BHS endForTwo				; {

	MUL R6, R5, R2			; i offset = i * i multiplier
	MUL R7, R4, R3			; j offset = j * j multiplier

	ADD R6, R6, R7			; offset = i index + j index
	LDR R6, [R0, R6]		; val = memory[initAddress + offset]
	ADD R8, R8, R6			; counter += val
	ADD R3, R3, #1
	B forTwo
endForTwo	

	CMP R11, #1				; if (firstRow)
	BNE checkIfTrue			; {
	MOV R11, #0				;   firstRow = false
	MOV R9, R8				;	prevCounter = curCounter
	
checkIfTrue
	CMP R8, R9				; if (curCounter != prevCounter) {
	BNE notMagic			;	isMagic = false }
	MOV R9, R8				; else { prevCounter = curCounter }
	
	ADD R2, R2, #1			; j ++
	B forOne				; }

notMagic					; if (notMagic) {
	MOV R0, #0				;	R0 = false
	MOV R1, #0				;	R1 = 0
	B endCheckMagic				; }

endForOne					; else {
	MOV R0, #1				;	R0 = true
	MOV R1, R8				;	R1 = counter
							; }
endCheckMagic

	POP {R2-R11, pc}

; checkDiagonals
; checks if the diagonals of a square 2D array are equal
; parameters :
;	R0 - Hexadecimal address of the first entry of the 2D array.
;	R1 - Dimension size of the 2D array.  
; return :
;	R0 - Boolean - Is compatible so far with being a magic square
;	R1 - Integer - If compatible, the number which the diagonals add up to. If not compatible, returns 0.

checkDiagonals
	PUSH {R2-R9, lr}

	MOV R2, #0				; i = 0
	MOV R3, #4				; i multiplier = 4
	MOV R4, R1, LSL #2		; j multiplier = N * 4
	MOV R7, #0				; counterOne = 0
	
rightLoop

	CMP R2, R1				; while (i < N) 
	BHS endRightLoop		; {
	
	MUL R5, R2, R3			; i offset = i * i multiplier
	MUL R6, R2, R4			; j offset = j * j multiplier
	ADD R5, R5, R6			; offset = i index + j index
	LDR R5, [R0, R5]		; val = memory[initAddress + offset]
	
	ADD R7, R5, R7			; counterOne += val
	ADD R2, R2, #1			; i ++
	B rightLoop				; }

endRightLoop

	MOV R2, R1				; i = N
	SUB R2, R2, #1			; i = N - 1
	MOV R8, #0				; j = 0
	MOV R9, #0				; counterTwo = 0
	
leftLoop

	CMP R2, R1				; while (i > 0) [if (R2 > N), it has fallen below zero due to 2's complement]
	BHS endLeftLoop			; {
	
	MUL R5, R2, R3			; i offset = i * i multiplier
	MUL R6, R8, R4			; j offset = j * j multiplier
	ADD R5, R5, R6			; offset = i index + j index
	LDR R5, [R0, R5]		; val = memory[initAddress + offset]
	
	ADD R9, R5, R9			; counterTwo += val
	SUB R2, R2, #1			; i --
	ADD R8, R8, #1			; j ++
	B leftLoop				; }

endLeftLoop

	CMP R7, R9				; if (counterOne != counterTwo) {
	BNE notEqual			;	notEqual () }
	MOV R0, #1				; else { R0 = true
	MOV R1, R9				;		 R1 = counter
	B endDiagonals			; }
	
notEqual					; function notEqual () {
	MOV R0, #0				;	R0 = false
	MOV R1, #0				;	R1 = 0 }
	
endDiagonals				; }
	POP {R2-R9, pc}

; isMagic
; checks if a square 2D array is a magic square.
; parameters :
;	R0 - Hexadecimal address of the first entry of the 2D array.
;	R1 - Dimension size of the 2D array.  
; return :
;	R0 - Boolean - Is compatible so far with being a magic square

isMagic
	PUSH {R1-R11, lr}

	MOV R4, R0				; Load parameter 1 to R4
	MOV R5, R1				; Load parameter 2 to R5

	MOV R2, #0				; checkRows = true
	BL	checkMagic			; checkMagic (rows)
	CMP R0, #0				; if (!checkMagic(rows)) {
	BEQ magicFalse			;	magicFalse () }
	MOV R6, R1				; else { R6 = rowsCounter }
	
	MOV R0, R4				; Load parameter 1
	MOV R1, R5				; Load parameter 2
	MOV R2, #1				; checkCols = true
	BL	checkMagic			; checkMagic (cols)
	CMP R0, #0				; if (!checkMagic(cols)) {
	BEQ magicFalse			;	magicFalse () }
	MOV R7, R1				; else { R7 = colsCounter }
	
	MOV R0, R4				; Load parameter 1
	MOV R1, R5				; Load parameter 2
	BL checkDiagonals		; checkDiagonals ()
	CMP R0, #0				; if (!checkDiagonals) {
	BEQ magicFalse			;	magicFalse () }
	MOV R8, R1				; else { R8 = diagsCounter }
	
	CMP R6, R7				; if (rowsCounter != colsCounter) {
	BNE magicFalse			;	magicFalse() }
	CMP R7, R8				; else if (colsCounter != diagsCounter) {
	BNE magicFalse			;	magicFalse() }
	MOV R0, #1				; else { isMagic = true }
	B	endIsMagic
		
magicFalse					; function magicFalse () {
	MOV R0, #0				;	isMagic = false }

endIsMagic
	POP {R1-R11, pc}

size1	DCD	3		; a 3x3 array
arr1	DCD	2,7,6		; the array
	DCD	9,5,1
	DCD	4,3,8
		
size2	DCD	3		; a 4x4 array
arr2	DCD	2,7,6,12	; the array
	DCD	9,5,1,8
	DCD	4,3,8,9
	DCD 1,3,3,6
		
size3	DCD	5		; a 5x5 array
arr3	DCD	17,24,1,8,15	; the array
	DCD	23,5,7,14,16
	DCD	4,6,13,20,22
	DCD 10,12,19,21,3
	DCD 11,18,25,2,9

size4	DCD	2		; a 2x2 array
arr4	DCD	2,1		; the array
	DCD	2,2

	END
