;
; CSU11021 Introduction to Computing I 2019/2020
; Convert a sequence of ASCII digits to the value they represent
;

	AREA	RESET, CODE, READONLY
	ENTRY

	LDR	R1, ='2'	; Load R1 with ASCII code for symbol '2'
	LDR	R2, ='0'	; Load R2 with ASCII code for symbol '0'
	LDR	R3, ='3'	; Load R3 with ASCII code for symbol '3'
	LDR	R4, ='4'	; Load R4 with ASCII code for symbol '4'

	MOV R0, #1000	; Temporarily set R0 to 1,000 for future Base 10 conversion
	SUB R1, R1, #48	; Subtract 48 to convert from ASCII
	MUL R1, R0, R1	; Convert into base 10 (2000)
	
	MOV R0, #100	; Temporarily set R0 to 100 for future Base 10 conversion
	SUB R2, R2, #48	; Subtract 48 to convert from ASCII
	MUL R2, R0, R2	; Convert into base 10 (000)

	MOV R0, #10		; Temporarily set R0 to 10 for future Base 10 conversion
	SUB R3, R3, #48	; Subtract 48 to convert from ASCII
	MUL R3, R0, R3	; Convert into base 10 (30)

	MOV R0, #1		; Temporarily set R0 to 1 for future Base 10 conversion
	SUB R4, R4, #48	; Subtract 48 to convert from ASCII
	MUL R4, R0, R4	; Convert into base 10 (4)
	
	ADD R0, R1, R2	; R0 = R1 + R2
	ADD R0, R0, R3	; R0 = R1 + R2 + R3
	ADD R0, R0, R4	; R0 = R1 + R2 + R3 + R4


STOP	B	STOP

	END
