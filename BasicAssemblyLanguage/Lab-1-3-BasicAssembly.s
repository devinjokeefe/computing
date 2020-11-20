;
; CSU11021 Introduction to Computing I 2019/2020
; Basic ARM Assembly Language
;

	AREA	RESET, CODE, READONLY
	ENTRY

; Write your solution for all parts (i) to (iv) below.

; Tip: Right-click on any instruction and select 'Run to cursor' to
; "fast forward" the processor to that instruction.

; (i) 3x+y

	LDR	R1, =2	; x = 2
	LDR	R2, =3	; y = 3

	MOV	R3, #3		; R3 = 3
	MUL	R1, R3, R1	; R1 = 3x
	ADD	R0, R1, R2	; R0 = 3x + y


; (ii) 3x^2+5x

	LDR	R1, =2	; x = 2
	
	MOV	R0, #5		; Temporarily set R0 = 5
	MUL	R2, R1, R1	; R2 = x^2
	MUL	R1, R0, R1	; R1 = 5x
	MOV	R0, #3		; Temporarily set R0 = 3
	MUL	R2, R0, R2	; R2 = 3x^2
	ADD	R0, R1, R2	; R0 = 3x^2 + 5x


; (iii) 2x^2+6xy+3y^2

	LDR	R1, =2	; x = 2
	LDR	R2, =3	; y = 3
	
	MUL	R3, R1, R1	; R3 = x^2
	MOV	R0, #2		; Temporarily set R0 = 2
	MUL	R3, R0, R3	; R3 = 2x^2
	
	MOV	R0, #6		; Temporarily set R0 = 6
	MUL	R4, R1, R2	; R4 = xy
	MUL	R4, R0, R4	; R4 = 6xy
	
	MOV	R0, #3		; Temporarily set R0 = 3
	MUL	R5, R2, R2	; R5 = y^2
	MUL	R5, R0, R5	; R5 = 3y^2
	
	ADD	R0, R3, R4	; R0 = 2x^2 + 6xy
	ADD	R0, R0, R5	; R0 = 2x^2 + 6xy + 3y^2
	
; (iv) x^3-4x^2+3x+8

	LDR	R1, =2	; x = 2
	LDR	R2, =3	; y = 3, not needed

	MUL R2, R1, R1	; R2 = x^2
	MUL R3, R1, R2	; R3 = x^3
	
	MOV R0, #4		; Temporarily set R0 = 4
	MUL R2, R0, R2	; R2 = 4x^2
	
	MOV R0, #3		; Temporarily set R0 = 3
	MUL R1, R0, R1	; R1 = 3x
	
	MOV R0, #8		; Set R0 = 8
	ADD R0, R0, R1	; R0 = 8 + 3x
	ADD R0, R0, R3	; R0 = 8 + 3x + x^3
	SUB R0, R0, R2	; R0 = x^3 - 4x^2 + 3x + 8 


STOP	B	STOP

	END
