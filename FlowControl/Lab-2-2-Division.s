;
; CSU11021 Introduction to Computing I 2019/2020
; Division (inefficient!)
;

	AREA	RESET, CODE, READONLY
	ENTRY

		MOV R0, #0		; a = 0
		MOV R1, #0		; b = 0

		MOV R2, #84		; R2 = 84
		MOV R3, #8		; R3 = 8

while
		CMP R2, R3
		BLS fin
		SUB R2, R2, R3
		ADD R0, R0, #1
		B	while
		
fin		MOV R1, R2

STOP	B	STOP

	END
