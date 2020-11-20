;
; CS1022 Introduction to Computing II 2019/2020
; Polling Example
;

; TIMER0 registers
T0TCR		EQU	0xE0004004
T0TC		EQU	0xE0004008
T0MR0		EQU	0xE0004018
T0MCR		EQU	0xE0004014

; Pin Control Block registers
PINSEL4		EQU	0xE002C010

; GPIO registers
FIO2DIR1	EQU	0x3FFFC041
FIO2PIN1	EQU	0x3FFFC055

	AREA	RESET, CODE, READONLY
	ENTRY

	; Enable P2.10 for GPIO
	LDR	R4, =PINSEL4	; load address of PINSEL4
	LDR	R5, [R4]	; read current PINSEL4 value
	BIC	R5, #(0x3 << 20); modify bits 20 and 21 to 00
	STR	R5, [R4]	; write new PINSEL4 value
	LDR R10, =0x500000	; R10 = min_time (5s)
	LDR R11, =0x800000	; R11 = max_time (8s)

	; Set P2.10 for input
	LDR	R4, =FIO2DIR1	; load address of FIO2DIR1

	NOP			; on "real" hardware, we cannot place
				; an instruction at address 0x00000014
	LDRB	R5, [R4]	; read current FIO2DIR1 value
	BIC	R5, #(0x1 << 2)	; modify bit 2 to 0 for input, leaving other bits unmodified
	STRB	R5, [R4]	; write new FIO2DIR1

	LDR	R4, =FIO2PIN1	; load address of FIO2PIN1

whRepeat			; while (forever) {
	LDRB	R6, [R4]	;   lastState = FIO2PIN1 & 0x4
	AND	R6, R6, #0x4	;

	; keep testing pin state until it changes

whPoll				;   do {
	LDRB	R5, [R4]	;     currentState = FIO2PIN1 & 0x4
	AND	R5, R5, #0x4	;
	CMP	R5, R6		;
	BEQ	whPoll		;   } while (currentState == lastState)

	; pin state has changed ... but has it changed to 0?

	CMP	R5, #0		;   if (currentState == 0) {
	BNE	eIf		;
	LDR	R1, =T0TC
	LDR R1, [R1]
	; Reset TIMER0 using Timer Control Register
	;   Set bit 0 of TCR to 0 to stop TIMER
	;   Set bit 1 of TCR to 1 to reset TIMER
	LDR	R8, =T0TCR
	LDR	R9, =0x2
	STRB	R9, [R8]
	
	LDR	R8, =T0TC
	LDR	R9, =0x0
	STR	R9, [R8]
	
	CMP R1, R10	; if (elapsed_time < min_time)
	BLO loser	;	winner = FALSE
	CMP R1, R11	; if (elapsed_time > max_time)
	BHI loser	;	winner = FALSE
	MOV R0, #1	; else { winner = TRUE }
	
loser
	
	CMP R0, #1	;		if (winner)
	BNE whRepeat
	
	; Set P2.10 for output
	LDR	R5, =FIO2DIR1	; load address of FIO2DIR1
	NOP
	LDRB	R6, [R5]	; read current FIO2DIR1 value
	ORR	R6, #(0x1 << 2)	; modify bit 2 to 1 for output, leaving other bits unmodified
	STRB	R6, [R5]	; write new FIO2DIR1
	
	; Reset TIMER0 using Timer Control Register
	;   Set bit 0 of TCR to 0 to stop TIMER
	;   Set bit 1 of TCR to 1 to reset TIMER
	LDR	R5, =T0TCR
	LDR	R6, =0x2
	STRB	R6, [R5]

	; Set to match after 0.5 secs using Match Register
	;   Assuming a 1Mhz clock input to TIMER0, set MR
	;   MR0 (0xE0004018) to 500,000
	;   Note that this gives a period of 1s (0.5 on, 0.5 off)
	LDR	R4, =T0MR0
	LDR	R5, =500000
	STR	R5, [R4]
	
	LDR	R4, =T0MCR		; Stop on match using Match Control Register
	LDR	R5, =0x04
	STRH	R5, [R4]	; Set bit 2 of MCR (0xE0004014) to 1 to stop the counter after
						; match (5 secs)

whBlink

	LDR	R5, =T0TCR		; Reset TIMER0 using Timer Control Register
	LDR	R6, =0x2		;   Set bit 0 of TCR to 0 to stop TIMER
	STRB	R6, [R5]	;   Set bit 1 of TCR to 1 to reset TIMER
	
	; There appears to be a bug in the uVision simulation
	;   of the TIMER peripherals. Setting the RESET bit of
	;   the TCR (above) should reset the Timer Counter (TC)
	;   but does not appear to do so. We can force it back
	;   to zero here.
	LDR	R5, =T0TC
	LDR	R6, =0x0
	STR	R6, [R5]
	
	LDR	R4, =T0TCR		; Start TIMER0 using the Timer Control Register
	LDR	R5, =0x01
	STRB	R5, [R4]	; Set bit 0 of TCR to enable the timer

	
whWait					; Keep testing TCR until the timer has stopped
	LDR	R4, =T0TCR
	LDRB	R5, [R4]
	TST	R5, #1
	BNE	whWait

	; read current P2.10 output value
	;   0 or 1 in bit 2 of FIO2PIN1
	LDR	R4, =0x04		;   setup bit mask for P2.10 bit in FIO2PIN1
	LDR	R5, =FIO2PIN1		;
	LDRB	R6, [R5]		;   read FIO2PIN1

	; modify P2.10 output (leaving other pin outputs controlled by
	;   FIO2PIN1 with their original value)
	TST	R6, R4			;   if (LED off)  TST Ry, Rz
	BNE	elsOff			;   {
	ORR	R6, R6, R4		;     set bit 2 (turn LED on)
	B	endIf			;   }
elsOff					;   else {
	BIC	R6, R6, R4		;     clear bit 2 (turn LED on)
endIf					;   }

	
	STRB	R6, [R5]	; write new FIO2PIN1 value
	
	B	whBlink
	
	B	whRepeat

eIf
	
	r
	LDR	R7, =T0TCR		; Start TIMER0 using the Timer Control Register
	LDR	R8, =0x01
	STRB	R8, [R7]	;   Set bit 0 of TCR to enable the time
	B	whRepeat	; }

	END
