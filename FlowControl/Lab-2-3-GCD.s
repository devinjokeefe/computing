;
; CSU11021 Introduction to Computing I 2019/2020
; GCD
;

	AREA	RESET, CODE, READONLY
	ENTRY

		MOV R0, #24		; a = 0
		MOV R1, #32		; b = 0
	
init					; Start of while loop
		CMP R0, R1		; while (a != b) {
		BNE	while		; GoTo if condition
		B fin			; else { Finish program }}
	
while
		CMP R0, R1		; if ( a > b ) {
		BHI iftrue		; GoTo a -= b function } 
		B iffalse		; else { GoTo b -= a function }}
		
iftrue
		SUB R0, R0, R1	; a -= b
		B init			; Back to while loop
iffalse
		SUB R1, R1, R0	; b -= a
		B init			; Back to while loop

fin

STOP	B	STOP

	END