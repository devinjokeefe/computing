;
; CSU11021 Introduction to Computing I 2019/2020
; Proper Case
;

	AREA	RESET, CODE, READONLY
	ENTRY

	LDR	R0, =tststr	; address of existing string
	LDR	R1, =0x40000000	; address for new string
	
	;
	; Write your program here to create the Proper Case string
	;
	 
	MOV R5, #0x20			; Initialise R5 as space ASCII value
	
	LDRB R2, [R0]			; Load initial ASCII value into memory at R2
	
	CMP R2, #'a'			; if (value < 'a') {
	BLO propCase			; Do nothing }
	CMP R2, #'z'			; else if (value > 'z') {
	BHI propCase			; Do nothing }
	SUB R2, R2, #0x20		; else { capitaliseValue }
	STR R2, [R1]			; Store value in memory
	B	propCase

isSpace		MOV R4, #1				; prevIsSpace = True;
			STRB R5, [R1]			; Insert space ASCII value into memory

propCase	ADD R1, R1, #1			; writeAddress ++
			ADD R0, R0, #1			; readAddress ++
			LDRB R2, [R0]			; char = readString[readAddress]
			CMP R2, #0				; if (char == null) {
			BEQ endPropCase 		; GoTo end }
			CMP R2, #0x20			; else if (char == 'space') {
			BEQ isSpace				; GoTo isSpace (); }
			CMP R2, #'a'			; else if (value > 'z') {
			BLO isUpper				; isUpper (); } 
			B	isLower				; else { isLower (); }

isUpper		CMP R4, #0				; if (!prevIsSpace) {
			BEQ toLower				; toLower (); }
			STRB R2, [R1]			; else { Store char in new string in memory 
			B	propCase			; propCase (); }

isLower		CMP R4, #1				; if (prevIsSpace) {
			BEQ toUpper				; toUpper (); }
			STRB R2, [R1]			; else { Store char in new string in memory 
			B propCase				; propCase (); }
			
toUpper		SUB R2, R2, #0x20		; char = capitalise(char);
			MOV R4, #0				; prevIsSpace = false;
			STRB R2, [R1]			; Store char in new string in memory
			B propCase				; propCase ();

toLower		ADD R2, R2, #0x20		; char = lowerCase(char);
			MOV R4, #0				; prevIsSpace = false;
			STRB R2, [R1]			; Store char in new string in memory 
			B propCase				; propCase ();
			
			
			
endPropCase MOV R5, #0
			STRB R5, [R1]

STOP	B	STOP

tststr	DCB	"hello wORLD",0

	END
