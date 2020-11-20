;
; CS1022 Introduction to Computing II 2018/2019
; Lab 3 - Floating-Point
;

	AREA	RESET, CODE, READONLY
	ENTRY

;
; Test Data
;
FP_A	EQU	0xC1960000
FP_B	EQU	0x41C40000
SIGN_MASK	EQU 0x80000000
FRAC_MASK	EQU 0x007FFFFF
INVER_MASK	EQU 0xFFFFFFFF
EXP_MASK	EQU 0x7F800000

	; initialize system stack pointer (SP)
	LDR	SP, =0x40010000

	;
	; test your subroutines here
	;
	
	LDR R0, =FP_A				; R0 = FP_A
	LDR R1, =FP_B				; R1 = FP_B
	BL	fpadd					; fpadd(FP_A, FP_B)

stop	B	stop

;
; fpadd
; adds two IEEE 754 floating point values and returns it as an IEEE 754 floating point value
; parameters:
;	r0 - ieee 754 float
;	r1 - ieee 754 float
; return:
;	r0 - ieee 754 float

fpadd

	PUSH {R4-R12, lr}

	MOV R4, R0					; Load parameter 1 to R4
	MOV R5, R1					; Load parameter 2 to R5
	
	MOV R0, R4					; R0 = parameter_1
	BL fpexp					; R0 = fpexp (parameter_1)
	MOV R6, R0					; R6 = fpexp (parameter_1)
	
	MOV R0, R4					; R0 = parameter_1
	BL fpfrac					; R0 = fpfrac (parameter_1)
	MOV R7, R0					; R7 = fpfrac (parameter_1)
	LDR R10, =0x80000000		; R10 = fraction mask
	AND R10, R7, R10			; R10 = frac_1 sign
	
	MOV R0, R5					; R0 = parameter_2
	BL fpexp					; R0 = fpexp (parameter_2)
	MOV R8, R0					; R8 = fpexp (parameter_2)

	MOV R0, R5					; R0 = parameter_2
	BL fpfrac					; R0 = fpfrac (parameter_2)
	MOV R9, R0					; R9 = fpfrac (parameter_2)
	LDR R11, =0x80000000		; R11 = fraction mask
	AND R11, R9, R11			; R11 = frac_2 sign
	
	CMP R10, R11
	BEQ signsEqual
	MOV R12, #0
	B	beginAdd
	
signsEqual
	MOV R12, #1
	
beginAdd
	MOV R10, R6					; dominant_exponent = exp_1 (default)
	CMP R6, R8					; if (exp_1 == exp_2) {
	BEQ addFloats				;	addFractions(frac_1, frac_2) }
	CMP R6, R8					; else if (exp_1 > exp_2)
	BLO	lower					;	{
	SUB R10, R6, R8				;	  exp_diff = exp_1 - exp_2
	MOV R9, R9, LSR R10			;	  frac_2 decrements exp_diff bytes
	MOV R10, R6					;	  dominant_exponent = exp_1
	B addFloats					;	}
	
lower							; else {
	SUB R10, R8, R6				;   exp_diff = exp_2 - exp_1
	MOV R7, R7, LSR R10			;	frac_1 decrements exp_diff bytes
	MOV R10, R8					;	dominant_exponent = exp_2
								;  }

addFloats
	LDR R11, =0x00000000		; Set R11 to positive sign
	ADD R5, R7, R9				; combined_frac = frac_1 + frac_2
	

	
	LDR R4, =0x80000000			; R4 = sign mask
	AND R6, R4, R5				; R6 = fraction ^ mask (isolate sign)
	CMP R4, R6					; if (fraction == negative)
	BNE positive				; {
	LDR R11, =0x80000000		;	R11 has negative sign
	LDR R4, =0xFFFFFFFF			; 	R4 = Inversion mask
	EOR R5, R4, R5				; 	R5 = inverted fraction
	ADD R5, R5, #1				; 	Add 1 to achieve 2's complement 
								; }
	
positive	

	CMP R12, #1
	BNE	signsNotEqual
	MOV R5, R5, LSR #1
	ADD R10, R10, #1
	B	expAdd

signsNotEqual
	LDR R11, =0x00800000
	AND R12, R11, R5
	CMP R11, R12
	BEQ expAdd
	MOV R5, R5, LSL #1
	SUB R10, R10, #1
	B signsNotEqual
	
expAdd

	ADD R10, R10, #127			; exponent = dominant_exponent + b
	MOV R10, R10, LSL #23		; Move exponent to proper place in float
	ORR R11, R11, R10			; Add exponent to float
	ORR R11, R11, R5			; Add fraction to float
	
	MOV R0, R11
	
	POP {R4-R12, pc}

;
; fpfrac
; decodes an IEEE 754 floating point value to the signed (2's complement)
; fraction
; parameters:
;	r0 - ieee 754 float
; return:
;	r0 - fraction (signed 2's complement word)
;
fpfrac

	PUSH {R4-R6, lr}			; Save registers

	MOV R4, R0					; Load parameter to R4
	
	LDR R5, =SIGN_MASK			; R5 = sign mask
	AND R6, R4, R5				; R5 = fraction ^ mask (isolate sign)
	CMP R5, R6					; if (fraction != negative)
	BEQ negative				; {

	LDR R5, =FRAC_MASK			; R5 = fraction mask
	AND R4, R4, R5				; R4 = fraction ^ mask
	B returnFrac				; }

negative						; if (fraction == negative) {

	LDR R5, =FRAC_MASK			; R5 = fraction mask
	AND R4, R4, R5				; R4 = fraction ^ mask
	
	LDR R5, =INVER_MASK			; Inversion mask
	EOR R4, R4, R5				; R4 = inverted fraction
	ADD R4, R4, #1				; Add 1 to achieve 2's complement }
	
returnFrac
	MOV R0, R4					; Return 2's complement fraction in R0
	POP {R4-R6, pc}				; Load registers

;
; fpexp
; decodes an IEEE 754 floating point value to the signed (2's complement)
; exponent
; parameters:
;	r0 - ieee 754 float
; return:
;	r0 - exponent (signed 2's complement word)
;
fpexp

	PUSH {R4-R5, lr}			; Save registers

	MOV R4, R0					; Load parameter to R4
	LDR R5, =EXP_MASK			; R5 = exponent mask
	AND R4, R4, R5				; R4 = exponent ^ mask
	MOV R4, R4, LSR #23			; Load exponent to back
	
	SUB R4, R4, #127			; exponent = exp - b
	MOV R0, R4					; Returns 2's complement exponent in R0

	POP {R4-R5, pc}				; Load registers

;
; fpencode
; encodes an IEEE 754 value using a specified fraction and exponent
; parameters:
;	r0 - fraction (signed 2's complement word)
;	r1 - exponent (signed 2's complement word)
; result:
;	r0 - ieee 754 float
;
fpencode

	PUSH {R4-R8, lr}			; Save registers

	MOV R4, R0					; R4 = Parameter 1 (Fraction)
	MOV R5, R1					; R5 = Parameter 2 (Exponent)

	MOV R8, #0					; Set R8 to unsigned fraction
	LDR R7, =SIGN_MASK			; R7 = sign mask
	AND R6, R4, R7				; R6 = fraction ^ mask (isolate sign)
	CMP R6, R7					; if (sign == negative)
	BNE posSign					; {

	SUB R4, R4, #1				; Convert back from 2's complement				
	LDR R6, =INVER_MASK			;
	EOR R4, R4, R6				; }
	
	LDR R8, =SIGN_MASK			; Set fraction sign to negative

posSign

	ADD R5, R5, #127			; e = exponent + b
	MOV R5, R5, LSL #23			; Move e to the correct position
	
	ORR R7, R4, R5				; R7 = IEEE 754 value created from fraction and exponent
	ORR R8, R7, R8				; R8 = signed fraction 
	MOV R0, R8					; Returns IEEE 754 value in R0

	POP {R4-R8, pc}				; Load registers

	END

