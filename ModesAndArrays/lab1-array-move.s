;
; CS1022 Introduction to Computing II 2018/2019
; Lab 1 - Array Move
;

N	EQU	16		; number of elements

	AREA	globals, DATA, READWRITE

; N word-size values

ARRAY	SPACE	N*4		; N words


	AREA	RESET, CODE, READONLY
	ENTRY

	; for convenience, let's initialise test array [0, 1, 2, ... , N-1]

	LDR	R0, =ARRAY				; R0 = array.address
	LDR	R1, =0					; R1 = 0
L1	CMP	R1, #N					; while (R1 < N) {
	BHS	L2
	STR	R1, [R0, R1, LSL #2]	;	R1 = Memory.address[R0 = R1*4]
	ADD	R1, R1, #1				;	R1 = R1 + 1
	B	L1						; }
L2

	; initialise registers for your program

	LDR	R0, =ARRAY				; R0 = array.address
	LDR	R1, =8					; R1 = 6 (Old index)
	LDR	R2, =2					; R2 = 3 (New index)
	LDR	R3, =N					; R3 = N

	; your program goes here
	
	MOV R7, #4					; tmp = 4
	
	MUL R5, R1, R7				; tempVal = 4 * oldIndex
	ADD R5, R0, R5				; oldIndexAddress = array.address + tempVal //designated as i
	LDR R4, [R0, R1, LSL #2]	; a = array[oldIndexAddress]
	
	MUL R6, R2, R7				; tempVal = 4 * newIndex
	ADD R6, R0, R6				; newIndexAddress = array.address + tempVal
	
gtr
	CMP R1, R2					; if (oldIndex == newIndex) {
	BEQ end						; 	endProgram (); }
	CMP R1, R2					; if (oldIndex <= newIndex) {
	BLS less					; 	less (); }

whGtr
	CMP R1, R2					; while (oldIndex < newIndex) {
	BLS endWhGtr
	SUB R5, R1, #1				; tmpAddress = i - 1
	LDR R7, [R0, R5, LSL #2]	; tmp = array[i-1]
	STR	R7, [R0, R1, LSL #2]	; array [i] = tmp
	SUB R1, R1, #1				; i--
	B whGtr						; }
endWhGtr

	STR R4, [R0, R2, LSL #2]	; array[newIndexAddress] = a
	B end
	
less
whLss
	CMP R1, R2					; while (i > newIndex) {
	BHS endWhLss
	ADD R5, R1, #1				; tmpAddress = i = 1
	LDR R7, [R0, R5, LSL #2]	; tmp = array[i+1]
	STR	R7, [R0, R1, LSL #2]	; array [i] = tmp
	ADD R1, R1, #1				; i++
	B whLss						; }

endWhLss
	STR R4, [R0, R2, LSL #2]	; array[newIndexAddress] = a
	
end

STOP	B	STOP

	END
