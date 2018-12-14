TITLE Elementary Arithmetic     (Project01.asm)

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

quiz4   MACRO p,q
        LOCAL here
        push   eax
        push   ecx
        mov    eax, p
        mov    ecx, q
here:
        mul    P
        loop   here

        mov    p, eax
        pop    ecx
        pop    eax
ENDM

.data
; variable definitions
x       DWORD 3
y       DWORD 3

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

mov    ebx, 3
   mov    ecx, 12
   mov    edx, ecx
   quiz4  ecx, ebx

main ENDP

END main
