;
; CSU11021 Introduction to Computing I 2019/2020
; String Copy
;

	AREA	RESET, CODE, READONLY
	ENTRY

	LDR	R0, =tststr	; address of existing string
	LDR	R1, =0x40000000	; address for new string

	;
	; Write your program here to create the duplicate string
	;
	
while
		LDRB R2, [R0]	; char = tststr[charIndex]
		CMP R2, #0		; while (R2 != null) {
		BEQ ewhile		 
		STRB R2, [R1]	; newAddress[charIndex]
		ADD R1, R1, #1	; charIndex ++
		ADD R0, R0, #1	; }
		B while

ewhile

STOP	B	STOP

tststr	DCB	"This is a test!",0

	END
