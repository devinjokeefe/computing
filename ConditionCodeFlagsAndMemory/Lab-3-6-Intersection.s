;
; CSU11021 Introduction to Computing I 2019/2020
; Intersection
;

	AREA	RESET, CODE, READONLY
	ENTRY

	LDR	R0, =0x40000000	; address of sizeC
	LDR	R1, =0x40000004	; address of elemsC
	
	LDR	R6, =sizeA	; address of sizeA
	LDR	R2, [R6]	; load sizeA
	LDR	R3, =elemsA	; address of elemsA
	
	LDR	R6, =sizeB	; address of sizeB
	LDR	R4, [R6]	; load sizeB
	LDR	R5, =elemsB	; address of elemsB

	;
	; Your program to compute the interaction of A and B goes here
	;
	; Store the size of the intersection in memory at the address in R0
	;
	; Store the elements in the intersection in memory beginning at the
	;   address in R1
	;
	
	MOV R6, #0		; curIter = 0
	MOV R7, #0		; loopIter = 0
	MOV R8, #0		; curAVal = 0
	MOV R9, #0		; curBVal = 0
	
compareA	CMP R6, R2 		; for (curIter = 0; curIter < sizeA; curIter ++) { 
			BEQ end
			LDRB R8, [R3]	; curAVal = elemsA[curIter]
			LDR	R5, =elemsB	; address of elemsB
loopA		CMP R7, R4		; while (loopIter != sizeB) {
			BEQ loopEndA
			LDRB R9, [R5]	; curBVal = elemsB[curIter]
			CMP R8, R9		; if (curAVal = curBVal) {
			BEQ successA	;	putInSet(); }
			ADD R5, R5, #4	; else { moveToNextBVal(); 
			ADD R7, R7, #1	;		 loopIter ++;
			B loopA			; }
			
successA	STRB R8, [R1]	; R8 = elemsCVal
			ADD R1, R1, #1	; elemsCAddress ++
			LDRB R7, [R0]	; R7 = Number Of Elements in Set
			ADD R7, R7, #1	; R7 ++;
			STRB R7, [R0]	; Store the new number of elements in set in R0

loopEndA	MOV R7, #0		; loopIter = 0
			ADD R6, R6, #1	; curIter ++
			ADD R3, R3, #4	; Move to next element of elemsA
			B compareA

end

STOP	B	STOP

sizeA	DCD	4
elemsA	DCD	7, 14, 6, 3

sizeB	DCD	9
elemsB	DCD	20, 11, 14, 5, 7, 2, 9, 12, 17

	END
