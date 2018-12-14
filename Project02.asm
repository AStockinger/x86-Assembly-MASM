TITLE Fibonacci Numbers     (Project02.asm)

; Author: Amy Stockinger
; Last Modified: October 10 2018
; OSU email address: stockina@oregonstate.edu
; Course number/section: CS271 400
; Project Number: 2                Due Date: October 14 2018
; Description: Program that asks user for name, greets user and instructs user to enter an integer from 1-46,
; then displays that may terms of the Fibonacci sequences, with even numbers in red. Program also prompts user
; to play again or quit, with a farewell message.
; some helpful links I used:
; useful site for jumps: http://unixwiz.net/techtips/x86-jumps.html
; useful site for color library: http://programming.msjc.edu/asm/help/source/irvinelib/settextcolor.htm
; useful site for test: https://stackoverflow.com/questions/13064809/the-point-of-test-eax-eax

INCLUDE Irvine32.inc

UPPERLIMIT	EQU		46																				; upper limit for choice

.data
title_1		BYTE	"Fibonacci Numbers, by Amy Stockinger", 0
ec1			BYTE	"**EC: This program displays numbers in aligned columns.", 0
ec2			BYTE	"**EC: Something incredible: This program displays EVEN numbers in RED.", 0
userName	BYTE	33 DUP(0)																		; string for userName
getName		BYTE	"What's your name? ", 0
greet		BYTE	"Hello, ", 0
prompt_1	BYTE	"Enter the number of Fibonnaci terms to be displayed.", 0
prompt_2	BYTE	"Give the number as an integer in the range [1...46]", 0
prompt_3	BYTE	"How many Fibonacci terms do you want? ", 0
error_1		BYTE	"Out of range. Enter a number in [1...46]", 0
choice		DWORD	?
playAgain	BYTE	"Would you like to play again? press 1 for YES and any other number for NO: ", 0
yesOrNo		DWORD	?
results		BYTE	"Results certified by Amy Stockinger", 0
goodBye		BYTE	"Goodbye, ", 0
startTerm1	DWORD	1																				; for fibonacci addition
startTerm2	DWORD	0																				; for fibonacci addition
rowCount	DWORD	0																				; row counter for newlines
colCount	DWORD	0																				; column counter for tab adjustments

.code
main PROC
; introduction 
	mov		edx, OFFSET title_1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET ec1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET ec2
	call	WriteString
	call	CrLf
	call	CrLf
	mov		edx, OFFSET getName		; get user name
	call	WriteString
	mov		edx, OFFSET userName
	mov		ecx, 32
	call	ReadString

greeting:
	mov		edx, OFFSET greet
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	call	CrLf
; user instructions
	mov		edx, OFFSET prompt_1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET prompt_2
	call	WriteString
	call	CrLf
	mov		edx, OFFSET prompt_3
	call	WriteString

; get user desired number of terms and verify
get_number:
	call	ReadInt
	mov		choice, eax
	cmp		eax, UPPERLIMIT
	jg		error
	cmp		choice, 0
	jle		error
	jmp		initial

error: ; error check
	mov		edx, OFFSET error_1
	call	WriteString
	call	CrLf
	jmp		get_number

initial: ; display first term
	mov		ecx, choice				; put choice into ecx
	mov		eax, startTerm1
	call	WriteDec
	jmp		returnColor

; jumps for loop output formatting
addTab: ; add tab where necessary
	mov		al, 9
	call	WriteChar
	jmp		returnTab
newline: ; insert newline where necessary
	call	CrLf
	mov		rowCount, 0
	inc		colCount
	jmp		returnNewline
color: ; add color to even numbers only
	mov		eax, lightRed			; change color to light red
	call	SetTextColor
	mov		eax, startTerm1
	call	WriteDec
	mov		eax, white
	call	SetTextColor			; change color back to white
	jmp		returnColor

; displayFibs -- calculate and display with loop, including jumps for newline, extra tabs, and color
calculate:
	mov		eax, startTerm1
	mov		ebx, startTerm1
	add		eax, startTerm2
	mov		startTerm1, eax
	mov		startTerm2, ebx
	test	eax, 1					; test result against 1 to determine parity
	jz		color					; jump if zero flag = 0
	call	WriteDec
returnColor:
	mov		al, 9					; print a tab char
	call	WriteChar
	cmp		colCount, 7				; print extra tab for first 6 lines
	jl		addTab
returnTab:
	inc		rowCount				; increment row counter
	cmp		rowCount, 5
	je		newline					; add newline
returnNewline:
	loop	calculate				; restart loop

play_again: ; reset all counters/choice and ask to play again
	call	CrLf
	mov		startTerm1, 1
	mov		startTerm2, 0
	mov		choice, 0
	mov		colCount, 0
	mov		rowCount, 0
	mov		edx, OFFSET playAgain
	call	WriteString
	call	ReadInt
	mov		yesOrNo, eax
	cmp		eax, 1
	je		greeting

bye: ; farewell message
	call	CrLf
	mov		edx, OFFSET results
	call	WriteString
	call	CrLf
	mov		edx, OFFSET goodBye
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	call	CrLf

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main