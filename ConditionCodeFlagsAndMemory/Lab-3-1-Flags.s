;
; CSU11021 Introduction to Computing I 2019/2020
; Condition Code Flags
;

	AREA	RESET, CODE, READONLY
	ENTRY

LDR     R0, =0xC0001000
	LDR 	R1, =0x51004000
	ADDS 	R2, R0, R1 		; result? R2 = 0x11005000 flags? C = 1, N, Z, V = 0
	LDR 	R3, =0x92004000
	SUBS 	R4, R3, R3 		; result? R4 = 0 flags? Z = 1
	LDR 	R5, =0x74000100
	LDR 	R6, =0x40004000
	ADDS 	R7, R5, R6 		; result? R7 = 0xB4004100 flags? N = 1, V = 1
	LDR	R1, =0x6E0074F2
	LDR	R2, =0x211D6000
	ADDS	R0, R1, R2		; result? R0 = 0x8F1DD4F2 flags? N = 1, V = 1
	LDR	R1, =0xBE2FDD2E
	LDR	R2, =0x41D022D2
	ADDS	R0, R1, R2		; result? R0 = 0x00000000 flags? Z = 1, C = 1
	
	LDR R1, =0x00000001 
	LDR R2, =0x00000001
	ADDS R0, R1, R2				; N = 0, C = 0, V = 0, Z = 0
	
	LDR R1, =0xFFFFFFFF 
	LDR R2, =0xFFFFFFFF
	ADDS R0, R1, R2				; N = 1, C = 1, V = 0, Z = 0 How to get N=1, C=0?
	
	LDR R1, =0xF0000000 
	LDR R2, =0x20000000
	ADDS R0, R1, R2				; N = 0, C = 1, V = 0, Z = 0
	
	LDR R1, =0xFFFFFFFF 
	LDR R2, =0xFFFFFFFF
	ADDS R0, R1, R2				; N = 1, C = 1, V = 0, Z = 0
	
	LDR R1, =0x00000000 
	LDR R2, =0x00000000
	ADDS R0, R1, R2				; N = 0, C = 0, V = 0, Z = 1
	
	LDR R1, =0x80000000 
	LDR R2, =0x80000000
	ADDS R0, R1, R2				; N = 0, C = 1, V = 1, Z = 1
	


STOP	B	STOP

	END
