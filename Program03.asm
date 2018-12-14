TITLE Negative Integer Accumulator     (Program03.asm)

; Author: Amy Stockinger
; Last Modified: 10/15/2018
; OSU email address: stockina@oregonstate.edu
; Course number/section: CS271 - 400
; Project Number: 3               Due Date: 10/28/18
; Description: This program asks the user for their name, greets them, asks for numbers [-100, -1], loops until a
; positive number is entered, then displays the total number of numbers entered, the sum, and the average in several
; variations. The program asks the user to play again, and says goodbye.

INCLUDE Irvine32.inc

LOWERLIMIT	EQU		-100		; lower limit is a const

.data

userName	BYTE	33 DUP(0)	; for user's name
num			DWORD	?			; user-entered numbers, and maybe something else temporary
counter		DWORD	0			; counts user inputs
accumulator	DWORD	0			; to keep adding sums
oneK		DWORD	1000		; for some float manipulation
negOneK		DWORD	-1000		; for some float manipulation
header		BYTE	"Negative Integer Accumulator by Amy Stockinger", 0
EC1			BYTE	"**EC: This program numbers lines during user input.", 0
EC2			BYTE	"**EC: This program displays the average as a floating-point number, rounded to .001", 0
EC3			BYTE	"**EC: This program is astoundingly creative.", 0
getName		BYTE	"What is your name? ", 0
greet		BYTE	"Hello, ", 0
instruct	BYTE	"Please enter numbers in the range [-100, -1]", 0
instruct2	BYTE	"Enter a non-negative number when you're finished.", 0
enterNum	BYTE	" Enter Number: ", 0
errorMsg	BYTE	"That negative number is less than -100! Please enter another number.", 0
spcMsg		BYTE	"There are no negative numbers :(", 0
showTotal	BYTE	"You entered ", 0
showTotal2	BYTE	" valid number(s).", 0
showSum		BYTE	"The sum of your valid numbers is: ", 0
showAvg		BYTE	"The rounded average is: ", 0
hexAvg		BYTE	"In hexidecimal, that is: ", 0
binAvg		BYTE	"In signed binary, that is: ", 0
floatAvg	BYTE	"The floating point average in scientific notation rounded to nearest .001 is: ", 0
playAgain	BYTE	"Would you like to play again?", 0
playAgain2	BYTE	"Enter 1 for YES and any other number for NO: ", 0
ecMsg		BYTE	"Can I have double extra credit? :D", 0
ecTitle		BYTE	"How can you say no? :)", 0
ecYes		BYTE	"Woohoo!", 0
farewell	BYTE	"Goodbye, ", 0

.code
main PROC

intro: ; prints program title and EC
mov		edx, OFFSET header
call	WriteString
call	CrLf
mov		edx, OFFSET EC1
call	WriteString
call	CrLf
mov		edx, OFFSET EC2
call	WriteString
call	CrLf
mov		edx, OFFSET EC3
call	WriteString
call	CrLf
call	CrLf

; get user name
mov		edx, OFFSET getName
call	WriteString
mov		ecx, 32
mov		edx, OFFSET userName
call	ReadString
mov		edx, OFFSET greet
call	WriteString
mov		edx, OFFSET userName
call	WriteString
call	CrLf

display_instructions: ; prints 2 instruction statements
mov		edx, OFFSET instruct
call	WriteString
call	CrLf
mov		edx, OFFSET instruct2
call	WriteString
call	CrLf
mov		ecx, 0

get_numbers: ; gets numbers from user until a positive number is entered
inc		counter
mov		eax, counter
call	WriteDec
mov		edx, OFFSET enterNum
call	WriteString
call	ReadInt
mov		num, eax
cmp		eax, 0
jge		calculate				; calculate if positive number is entered
mov		eax, num
cmp		eax, LOWERLIMIT
jl		range_error				; jump to error message if number is too low
mov		eax, accumulator
add		eax, num
mov		accumulator, eax
loop	get_numbers

range_error: ; displays error message and resets counter if an invalid negative number is entered
mov		edx, OFFSET errorMsg
call	WriteString
dec		counter
call	CrLf
jmp		get_numbers

special_message:
mov		edx, OFFSET spcMsg
call	WriteString
call	CrLf
jmp		goodbye

calculate: ; calculates total nums, sum of nums, average of nums
dec		counter
jz		special_message
mov		edx, OFFSET showTotal
call	WriteString
mov		eax, counter
call	WriteDec				; display total valid numbers entered
mov		edx, OFFSET showTotal2
call	WriteString
call	CrLf
mov		edx, OFFSET showSum
call	WriteString
mov		eax, accumulator
call	WriteInt				; display final sum
call	CrLf
mov		edx, OFFSET showAvg
call	WriteString
mov		edx, 0
mov		eax, accumulator
cdq
mov		ebx, counter
idiv	ebx
push	eax						; save quotient
push	edx						; save remainder
mov		eax, counter
cdq
mov		ebx, 2
div		ebx						; calculate total nums / 2 to compare to remainder
pop		edx
mov		ecx, eax
inc		edx
pop		eax
cmp		edx, ecx
jb		WriteAvg
dec		eax
WriteAvg:
call	WriteInt				; display int average
call	CrLf
mov		edx, OFFSET hexAvg
call	WriteString
mov		num, ebx
call	WriteHex				; hex average
call	CrLf
mov		edx, OFFSET binAvg
call	WriteString
mov		ebx, num
call	WriteBin				; binary average
call	CrLf
mov		edx, OFFSET floatAvg
call	WriteString

; extra credit, divide accumulator/counter then multiply by 1000 and divide by -1000 to be negative again
neg		accumulator
fld		accumulator
fdiv	counter
fimul	oneK
frndint
fidiv	negOneK
call	WriteFloat
call	CrLf
call	CrLf

play_again: ; reset variables and ask user to play again
mov		counter, 0
mov		accumulator, 0
mov		edx, OFFSET playAgain
call	WriteString
call	CrLf
mov		edx, OFFSET playAgain2
call	WriteString
call	ReadInt
cmp		eax, 1
je		display_instructions

nothing_to_see_here: ; EC maybe 
mov		edx, OFFSET ecMsg
mov		ebx, OFFSET ecTitle
call	MsgBoxAsk
cmp		eax, IDYES
jne		goodbye
mov		edx, OFFSET ecYes
call	WriteString
call	CrLf

goodbye: ; farewell message with user name
mov		edx, OFFSET farewell
call	WriteString
mov		edx, OFFSET userName
call	WriteString

exit  ; exit to operating system

main ENDP

; (insert additional procedures here)

END main