;
; CSU11021 Introduction to Computing I 2019/2020
; Mode
;

	AREA	RESET, CODE, READONLY
	ENTRY

	LDR	R4, =tstN	; load address of tstN
	LDR	R1, [R4]	; load value of tstN

	LDR	R2, =tstvals	; load address of numbers
	LDR	R5, =0x40000000	; load address of prevValues

	MOV R3, #0		; curVal = 0
	MOV R6, #0		; curIter = 0
	MOV R7, #0		; occurs = 0
	MOV R8, #0		; maxOccurs = 0
	MOV R9, #0		; temp = 0
	MOV R10, #0		; occurIter = 0
	MOV R11, #0		; prevVal = 0
	B while
	
eloop		CMP R7, R8		; If (occurs <= maxOccurs) {
			BLS while		;   Do nothing }
			MOV R0, R3		; else {curVal = mode 
			MOV R8, R7		;		maxOccurs = occurs }
			
while
			LDR	R2, =tstvals	; load address of numbers
			MOV R9, #4			; R9 = 4
			MUL R9, R6, R9		; R9 = 4 * curIter
			ADD R2, R2, R9		; Move tstVals address forward to current iteration
			ADD R6, #1			; curIter ++
			LDR	R5, =0x40000000	; load address of prevValues
			CMP R6, R1		; while (curIter != N) {
			BHI ewhile
			MOV R7, #1		;   occurs = 1
			LDRB R3, [R2]	;	curVal = tstVals[curIter]

begin		MOV R9, #4		; R9 = 4
			MUL R9, R6, R9	; R9 = 4 * curIter
			ADD R2, R2, R9	; tstVals moves forward to curIter address
			
start		MOV R11, #0		;	loopVal = 0
			MOV R10, R6		;	occurIter = curIter
loop		ADD R10, R10, #1;	occurIter = curIter + 1	
			CMP R10, R1		;   for (occurIter = curIter + 1; occurIter <= N; occurIter ++) {
			BHI eloop
			LDRB R11, [R2]	;	loopVal = tstVals[occurIter]
			ADD R2, R2, #4	;	occurIter ++
			CMP R3, R11		;	if (curVal != loopVal) {
			BNE loop		;	  RestartLoop }
			ADD R7, R7, #1	;	else { occurs ++
			B loop			;		   RestartLoop }
ewhile

	
	

STOP	B	STOP

tstN	DCD	8			; N (number of numbers)
tstvals	DCD	5, 4, 5, 5, 1, 2, 1, 9	; numbers

	END