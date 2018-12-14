TITLE Elementary Arithmetic     (Program01.asm)

; Author: Amy Stockinger
; Last Modified: September 24 2018
; OSU email address: stockina@oregonstate.edu
; Course number/section: CS271 400
; Project Number: 1               Due Date: October 7 2018
; Description: Program that displays program title, prompts them for two numbers, verifies the first is the largest
; then returns sum, difference product, quotient and remainder, and decimal quotient. 
; Asks user to play again or quit, and includes a goodbye message.

INCLUDE Irvine32.inc

; constant definitions 

.data
; variable definitions
header1		BYTE	"Elementary Arithmetic by Amy Stockinger", 0
ec1			BYTE	"**EC: Program verifies second number is less than first", 0
ec2			BYTE	"**EC: Program repeats with user input.", 0
ec3			BYTE	"**EC: Program displays floating-point number rounded to nearest 0.001", 0
header2		BYTE	"Enter 2 numbers, and I'll show you the sum, difference, product, quotient and remainder.", 0
header3		BYTE	"Please enter the larger number first.", 0
prompt1		BYTE	"First number: ", 0
result1		DWORD	?
prompt2		BYTE	"Second number: ", 0
result2		DWORD	?
plusSign	BYTE	" + ", 0
sum			DWORD	?
minusSign	BYTE	" - ", 0
difference	DWORD	?
multSign	BYTE	" x ", 0
product		DWORD	?
divSign		BYTE	" / ", 0
quotient	DWORD	?
remainder	DWORD	?
equalSign	BYTE	" = ", 0
remain		BYTE	" remainder ", 0
floatDisp	BYTE	"Here is the division with the decimal to nearest 0.001: ", 0
oneK		DWORD	1000
floatNum	REAL4	?
againOrNo	BYTE	"Would you like to do it again? Enter 1 for YES, or any number for NO: ", 0
result3		DWORD	?
goodbye		BYTE	"Goodbye!", 0

.code
main PROC
; executable instructions

intro:
	; display intro
	mov		edx, OFFSET header1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET ec1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET ec2
	call	WriteString
	call	CrLf
	mov		edx, OFFSET ec3
	call	WriteString
	call	CrLf
	mov		edx, OFFSET header2
	call	WriteString
	call	CrLf

prompt:
	; display directions
	mov		edx, OFFSET header3
	call	WriteString
	call	CrLf
	; get input 1
	mov		edx, OFFSET prompt1
	call	WriteString
	call	ReadInt
	mov		result1, eax
	; get input 2
	mov		edx, OFFSET prompt2
	call	WriteString
	call	ReadInt
	mov		result2, eax

; EC: check if first is larger than second number
	mov		eax, result2
	cmp		eax, result1
	jg		prompt				; go to prompt again if done incorrectly
	jle		calculations		; else, continue with calculations

calculations:
	; addition
	mov		eax, result1
	add		eax, result2
	mov		sum, eax

	; subtraction
	mov		eax, result1
	sub		eax, result2
	mov		difference, eax

	; multiplication
	mov		eax, result1
	mov		ebx, result2
	mul		ebx
	mov		product, eax

	; division
	mov		edx, 0
	mov		eax, result1
	mov		ebx, result2
	cdq
	div		ebx
	mov		quotient, eax
	mov		remainder, edx

	; EC calculation - multiply by 1000, round and then divide by 1000 again
	fld		result1
	fdiv	result2
	fimul	oneK
	frndint
	fidiv	oneK
	fist	floatNum

results:
	; addition
	mov		eax, result1
	call	WriteDec
	mov		edx, OFFSET plusSign
	call	WriteString
	mov		eax, result2
	call	WriteDec
	mov		edx, OFFSET equalSign
	call	WriteString
	mov		eax, sum
	call	WriteDec
	call	CrLf

	; subtraction
	mov		eax, result1
	call	WriteDec
	mov		edx, OFFSET minusSign
	call	WriteString
	mov		eax, result2
	call	WriteDec
	mov		edx, OFFSET equalSign
	call	WriteString
	mov		eax, difference
	call	WriteDec
	call	CrLf

	; multiplication
	mov		eax, result1
	call	WriteDec
	mov		edx, OFFSET multSign
	call	WriteString
	mov		eax, result2
	call	WriteDec
	mov		edx, OFFSET equalSign
	call	WriteString
	mov		eax, product
	call	WriteDec
	call	CrLf

	; division
	mov		eax, result1
	call	WriteDec
	mov		edx, OFFSET divSign
	call	WriteString
	mov		eax, result2
	call	WriteDec
	mov		edx, OFFSET equalSign
	call	WriteString
	mov		eax, quotient
	call	WriteDec
	mov		edx, OFFSET remain
	call	WriteString
	mov		eax, remainder
	call	WriteDec
	call	CrLf

	; EC: floating point decimal to .001
	mov		edx, OFFSET floatDisp
	call	WriteString
	mov		eax, result1
	call	WriteDec
	mov		edx, OFFSET divSign
	call	WriteString
	mov		eax, result2
	call	WriteDec
	mov		edx, OFFSET equalSign
	call	WriteString
	mov		eax, floatNum
	call	WriteFloat
	call	CrLf

again:
	; EC: prompt user to use again or quit
	mov		edx, OFFSET againOrNo
	call	WriteString
	call	ReadInt
	mov		result3, eax
	cmp		eax, 1
	je		prompt				; return to original prompt

bye:
	; display goodbye message before exitting
	mov		edx, OFFSET goodbye
	call	WriteString
	exit						; exit to operating system
main ENDP

; additional procedures

END main
