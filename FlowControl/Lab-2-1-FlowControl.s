;
; CSU11021 Introduction to Computing I 2019/2020
; Flow Control
;

	AREA	RESET, CODE, READONLY
	ENTRY

; (i)
; if (h >= 13) {
; 	h = h - 12;
; }

		MOV R0, #15	; Temporarily assign H to equal 5
		CMP R0, #13	; If (R0 >= 13) {
		BHS	MIN		; R0 -= 12 }
		B	FIN		; Else {do nothing}

MIN		SUB	R0, R0, #12 ; Function to minus 12
FIN						; Function to do nothing

; (ii)
; if (a > b) {
;	i = i + 1;
; } else {
;	i = i - 1;
; }

		MOV R0, #4	; a = 5
		MOV R1, #4	; b = 4
		MOV R2, #1	; i = 1
		
		CMP R0, R1	; If (a > b) {
		BGT PLUS	; Add function }
		B MINUS		; Else { Minus function }
		
MINUS 	SUB R2, R2, #1	; i --	
PLUS	ADD R2, R2, #1	; i ++

; (iii)
; if (v < 10) {
; 	a = 1;
; }
; else if (v < 100) {
; 	a = 10;
; }
; else if (v < 1000) {
; 	a = 100;
; }
; else {
; 	a = 0;
; }

		MOV R0, #8	; v = 10
		MOV R1, #2	; a = 2
		
		CMP R0, #10		; If (v < 10) {
		MOV R1, #1		; a = 1
		BLO endif		; GoTo End }
		CMP R0, #100	; Else if (v < 100) {
		MOV	R1, #10		; a = 10 
		BLO endif		; GoTo End }
		CMP R0, #1000	; Else if (v < 1000) {
		MOV	R1, #100	; a = 100
		BLO endif		; GoTo End }
		MOV	R1, #0		; Else { FuncFour }

endif
		


; (iv)
; i = 3;
; while (i < 1000) {
; 	a = a + i;
; 	i = i + 3;
; }

		MOV R0, #3		; i = 3
		MOV R1, #0		; a = 0

whileOne					; while
		CMP R0, #1000	; (i < 1000) {
		BHS endwhOne		; 
		ADD R1, R1, R0		; a += i
		ADD R0, R0, #3		; i += 3
		B whileOne			; }
endwhOne


; (v) 
; for (int i = 3; i < 1000; i = i + 3) {
; 	a = a + i;
; }

		MOV R0, #3		; i = 3
		MOV R1, #0		; a = 0

whileTwo					; while
		CMP R0, #1000	; (i < 1000) {
		BHS endwhTwo		; 
		ADD R1, R1, R0	; a += i
		ADD R0, R0, #3	; i += 3
		B whileTwo			; }
endwhTwo



; (vi)
; p = 1;
; do {
; 	p = p * 10;
; } while (v < p);

		MOV R0, #1		; p = 1
		MOV R1, #0		; v = 100
		MOV R2, #10		; Constant of 10
		
while					; while loop
		MUL R0, R2, R0	; p = 10 * p
		CMP R1, R0		; if (v >= p) {
		BHS fin			; end loop }
		B while			; else { continue while loop }
		
fin
		
		


; (vii)
; if (ch >= 'A' && ch <= 'Z') {
; 	upper = upper + 1;
; }

		MOV R0, #'F'	; ch = 'F'
		
		CMP R0, #'A'	; if (ch < 'A') {
		BLO fin			; do nothing }
		CMP R0, #'Z'	; if (ch > 'Z') {
		BHI final		; do nothing }
		ADD R0, R0, #1	; else { upper += 1 }
		
final


; (viii)
; if (ch=='a' || ch=='e' || ch=='i' || ch=='o' || ch=='u')
; {
; 	v = v + 1;
; }

		MOV R0, #'i'	; ch = 'i'
		MOV R1, #0		; v = 0
		
		CMP R0, #'a'	; if (ch == 'a') {
		BEQ end_one		; v += 1 }
		CMP R0, #'e'	; else if (ch == 'e') {
		BEQ end_one		; v += 1 }
		CMP R0, #'i'	; else if (ch == 'i') {
		BEQ end_one		; v += 1 }
		CMP R0, #'o'	; else if (ch == 'o') {
		BEQ end_one		; v += 1 }
		CMP R0, #'u'	; else if (ch == 'u') {
		BEQ end_one		; v += 1 }
		B end_two		; else { do nothing }
		
end_one ADD R1, R1, #1	; function to implement v += 1
end_two					; do nothing
		


STOP	B	STOP

	END
