;
; CSU11021 Introduction to Computing I 2019/2020
; First Program
;

	AREA	RESET, CODE, READONLY
	ENTRY
	MOV	R1, #2		; R1 = 2
	MOV	R0, R1		; R0 = R1
	ADD	R0, R0, R0	; R0 = R0 + R0
	ADD R0, R0, R0	; R0 = R0 + R0
	ADD	R0, R0, R0	; R0 = R0 + R0
	; your program goes here

STOP	B	STOP

	END
