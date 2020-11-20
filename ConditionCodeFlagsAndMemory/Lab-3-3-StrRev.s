;
; CSU11021 Introduction to Computing I 2019/2020
; String Reverse
;

	AREA	RESET, CODE, READONLY
	ENTRY

	LDR	R0, =tststr	; address of existing string
	LDR	R1, =0x40000000	; address for new string

	;
	; Write your program here to create the reversed string
	;
	
	MOV R2, #0
	
	SUB R1, R1, #1
	STRB R2, [R1]
	ADD R1, R1, #1
	
wh
		LDRB R2, [R0]
		CMP R2, #0
		BEQ endwh
		ADD R0, R0, #1
		B wh
endwh

		SUB R0, R0, #1

while
		LDRB R2, [R0]
		CMP R2, #0
		BEQ ewhile
		STRB R2, [R1]
		SUB R0, R0, #1
		ADD R1, R1, #1
		B while
ewhile

STOP	B	STOP

tststr	DCB	"This is a test!",0

	END
