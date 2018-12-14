TITLE Designing Low-Level I/O Procedures     (Program06.asm)

; Author: Amy Stockinger
; Last Modified: 11/19/18
; OSU email address: stockina@oregonstate.edu
; Course number/section: CS271 - 400
; Project Number: 6                 
; Due Date: 12/2/18
; Description: this program greets the user, prompts them for 10 number inputs, validates that the string input is
; all decimal digits, converts the string to a decimal numbers, stores the decimal numbers, then converts the numbers
; back to string to be displayed back to the user, along with the calculated sum and average of those numbers.
; EC1: the inputs are numbered
; EC3: the readval and writeval procs are recursive

INCLUDE Irvine32.inc

ARRSIZE		EQU		10

; prompts user then gets string input
; parameters: a var address and a string buffer
getString	MACRO	aVariable, aStringBuffer
	push	edx
	push	ecx
	displayString aStringBuffer
	mov		edx, aVariable
	mov		ecx, 20				; buffer is 20 chars
	call	ReadString			; put input into string
	pop		ecx
	pop		edx
ENDM

; displays a string to user
; parameters: a string buffer
displayString	MACRO	aStringBuffer
	push	edx
	mov		edx, aStringBuffer
	call	WriteString
	pop		edx
ENDM

.data
intro		BYTE	"Desinging low-level I/O procedures         Written by: Amy Stockinger", 13, 10, 0
info		BYTE	"Each number needs to be small enough to fit inside a 32-bit register.", 13, 10,
					"After you have finished inputting the raw numbers, I will display a list", 13, 10,
					"of the valid integers, their sum, and their average value.", 13, 10,
					"**EC1: The lines are numbered with total values entered.**", 13, 10,
					"**EC3: ReadVal and WriteVal are recursive.**", 13, 10, 10, 0
prompt		BYTE	"Please enter an unsigned number: ", 0
error		BYTE	"ERROR: You did not enter an unsigned number, or your number was too big. Try again.", 13, 10, 0
display		BYTE	"You entered the following numbers:", 13, 10, 0
dispSum		BYTE	"The sum of these numbers is: ", 0
dispAvg		BYTE	"The average is: ", 0
farewell	BYTE	"Thanks for playing!", 0
numArray	DWORD	ARRSIZE DUP(?)	; num array
userInput	BYTE	21 DUP(?)		; empty string for user input
output		BYTE	21 DUP (?)		; output string

.code

main PROC

push	OFFSET intro		; +12
push	OFFSET info			; +8
call	Introduction		; introduce program

push	OFFSET error		; +28
push	OFFSET prompt		; +24
push	ARRSIZE				; +20
push	OFFSET numArray		; +16
push	OFFSET userInput	; +12
push	1					; +8
call	ReadVal				; gets 10 values from user

push	OFFSET output		; +24, output byte string
push	OFFSET display		; +20
push	OFFSET dispAvg		; +16
push	OFFSET dispSum		; +12
push	OFFSET numArray		; +8, array
call	DisplayResults		; displays 10 numbers, their sum and the average

push	OFFSET farewell		; +8
call	GoodBye				; ending statement

exit  ; exit to operating system
main ENDP

;******************************************************************
; Procedure to introduce the program
; Receives: two string addresses
; Returns: nothing
; Preconditions: none
; Registers changed: none
;******************************************************************
Introduction PROC
push	ebp
mov		ebp, esp
pushad

displayString [ebp + 12]
displayString [ebp + 8]

popad
pop		ebp
ret 8
Introduction ENDP


;******************************************************************
; Procedure to get string input from user, converts string to
; numeric, and validates that it is a number and appropriate size,
; then adds that number to the array
; Receives: array, user prompts, string to take user input
; Returns: filled 10-element array
; Preconditions: array offset pushed onto stack
; Registers changed: none
;******************************************************************
ReadVal PROC
push	ebp
mov		ebp, esp
pushad
mov		ecx, [ebp + 8]
cmp		ecx, 10
jg		done

askForNum:						; prompt user
mov		eax, [ebp + 8]
call	writeDec
mov		al, 32
call	WriteChar
mov		edx, [ebp + 12]
mov		eax, [ebp + 24]
getString	edx, eax

mov		eax, 0					; eax to load string byte
mov		ecx, 0					; ecx to hold sum of digits
mov		edi, 1					; edi to count digits
mov		esi, [ebp + 12]			; move string input to esi
validate:
cmp		edi, 10					; make sure number isnt too big
jg		err
lodsb
cmp		al, 57					; check range
jg		err
cmp		al, 0					; check that its not the end of the string
je		recurse
cmp		al, 48
jl		err

inc		edi						; increase digit count if the byte is a digit
sub		al, 48					; subtract 48 to convert ASCII to a decimal
push	eax
add		eax, ecx				; add previous digits to the new one
mov		ebx, 10
mul		ebx						; multiply it by 10 to make room for next
mov		ecx, eax		
pop		eax
jmp		validate

err:							; display error message
displayString [ebp + 28]
mov		eax, 0
jmp		askForNum

recurse:
cmp		edi, 1					; user cannot enter a blank space
je		err
mov		eax, ecx				; move total to eax for division
mov		ebx, 10
div		ebx						; divide number by 10 to undo multiplication after last digit
mov		esi, [ebp + 16]
mov		[esi], eax				; put decimal number into array

push	[ebp + 28]
push	[ebp + 24]
push	[ebp + 20]
add		esi, 4					; add 4 to array address to store next input there
push	esi
push	[ebp + 12]
mov		ecx, [ebp + 8]
inc		ecx
push	ecx
call	ReadVal					; recurse to get all 10 values

done:
popad
pop		ebp
ret 24
ReadVal ENDP


;******************************************************************
; Procedure to convert numeric value to string of digits
; used as a subproc for DisplayResults proc
; Receives: array address
; Returns: prints string of numbers from a numeric value
; Preconditions: for this program, array initialized
; Registers changed: none
;******************************************************************
WriteVal PROC
push	ebp
mov		ebp, esp
pushad
mov		edi, [ebp + 12]				; byte string addr to edi
mov		eax, [ebp + 8]				; mov decimal number into eax

nextNum:
cdq
mov		ebx, 10
div		ebx							; divide decimal num by 10
cmp		eax, 0						; if not 0, recurse
jne		callFunction
jmp		doneWriting				

callFunction:
push	edi
push	eax
call	WriteVal

doneWriting:
add		edx, 48						; if done, add 48 to remainder
mov		eax, edx					; move ASCII char to string
stosb
displayString [ebp + 12]			; print the string

popad
pop		ebp
ret 8
WriteVal ENDP


;******************************************************************
; Procedure to display numArray, its sum and average
; Receives: array, string labels, a string buffer var
; Returns: prints numArray contents, sum and avg, a byte string var
; Preconditions: array initialized
; Registers changed: none
;******************************************************************
DisplayResults	PROC
push	ebp
mov		ebp, esp
pushad
mov		ecx, 10

call	CrLf
displayString [ebp + 20]		; display list of nums prompt
mov		eax, [ebp + 8]
writeLoop:
push	[ebp + 24]
push	[eax]
call	WriteVal
push	eax
mov		al, 9
call	WriteChar				; nums separated by tabs
pop		eax
add		eax, 4
loop	writeLoop				; loop to call WriteVal to convert dec nums back to string for display

call	CrLf

mov		ecx, 10					; set up to calculate sum
mov		edx, 0
mov		eax, 0					; start count at 0
mov		esi, [ebp + 8]			; array to esi
displayString	[ebp + 12]
calcSum:
add		edx, [esi]				; add array number to edx
add		esi, 4					; move to next dword address
loop	calcSum					; loop 10 times per ecx
mov		eax, edx
push	[ebp + 24]
push	eax
call	WriteVal
call	CrLf

calcAvg:
displayString	[ebp + 16]
mov		eax, edx
cdq
mov		ebx, 10
div		ebx						; divide sum by 10 to get approx average
push	[ebp + 24]
push	eax
call	WriteVal
call	CrLf
call	CrLf

popad
pop		ebp
ret 24
DisplayResults	ENDP


;******************************************************************
; Procedure to say goodbye to user
; Receives: nothing
; Returns: nothing
; Preconditions: none
; Registers changed: none
;******************************************************************
GoodBye PROC
push	ebp
mov		ebp, esp
pushad

displayString [ebp + 8]
call	CrLf

popad
pop		ebp
ret 4
GoodBye	ENDP

END main