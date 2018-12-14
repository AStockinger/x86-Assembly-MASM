TITLE Composite Numbers     (Program04.asm)

; Author: Amy Stockinger
; Last Modified: 10/24/2018
; OSU email address: stockina@oregonstate.edu
; Course number/section: CS271 - 400
; Project Number: 4              Due Date: 11/04/18
; Description: This program will print the user-requested number of composite integers in aligned columns
; The program greets the user and prompts them to request the number of composite numbers they would like
; displayed. The program will store non-composite (prime) numbers into an array and use those numbers to 
; check if other numbers are composite. Composite numbers are printed in aligned columns and with 10 rows
; per page.
; there are two extra un-used procedures at the bottom on the list that fill an array with prime numbers
; and the other prodecure prints it out, without formatting. please disregard them.

INCLUDE Irvine32.inc

UPPERLIMIT	EQU		1000			; upper limit is a const

.data

userName		BYTE	33 DUP(0)	; for user's name
numComposites	DWORD	?			; user-specified number of composites
composite		DWORD	2			; variable to hold composite numbers
compBool		DWORD	?			; using 0 and 1 as booleans if a number is composite
colCounter		DWORD	0			; to add newline for printing
rowCounter		DWORD	0			; to be incremented when a newline is added, and make new page after 10 rows
primeArray		DWORD	200 dup (0)	; 200 to handle approx number of primes between 1-1000 (the range)
primeCount		DWORD	?
header			BYTE	"Composite Numbers by Amy Stockinger", 0
EC1				BYTE	"**EC: This program aligns the columns.", 0
EC2				BYTE	"**EC: This program displays more numbers with separate pages", 0
EC3				BYTE	"**EC: This program checks against prime divisors.", 0
getName			BYTE	"What is your name? ", 0
greet			BYTE	"Hello, ", 0
instruct		BYTE	"Please enter number of composites to display [1 ... 1000]: ", 0
errorMsg		BYTE	"Out of range. Try again.", 0
farewell		BYTE	"Results certified by Amy Stockinger. Goodbye, ", 0

.code
main PROC

call	intro			; introduce program and greet user by name
call	getUserData		; ask user how many composites they want to see
call	showComposite	; show user requested composites
call	goodbye			; say goodbye

exit  ; exit to operating system

main ENDP

;----- Additional procedures ------;

intro PROC USES edx ecx
; description: introduces program and stores users name in variable
; receieves nothing, returns program heading, user's name
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
mov		edx, OFFSET getName		; get name
call	WriteString
mov		ecx, 32
mov		edx, OFFSET userName
call	ReadString
mov		edx, OFFSET greet
call	WriteString
mov		edx, OFFSET userName
call	WriteString
call	CrLf
ret
intro ENDP


getUserData PROC USES edx eax
; description: gets user number and validates it is in range
; receives nothing, returns numComposites (in range)
getNumberLoop:
	mov		edx, OFFSET instruct
	call	WriteString
	call	readInt
	mov		numComposites, eax
	call	validate
	cmp		numComposites, 0
	je		getNumberLoop		; loop again if numComposites is out of range
	call	CrLf
	ret
getUserData ENDP


validate PROC USES eax edx
; description: validates that user input is between 1 and 400 (inclusive)
; receives: numComposites (set by user), returns: an error message if not in range, and sets numComposites to 0
mov		eax, numComposites
cmp		eax, UPPERLIMIT
jg		notInRange				; if  numComposites is over the limit, jump to error message
cmp		eax, 1					; it must also be greater than or equal to 1, or the error messge will display
jge		inRange				
notInRange:
mov		edx, OFFSET errorMsg
call	WriteString
mov		numComposites, 0		; set numComposites to 0 if out of range so it can be reprompted in getUserData
call	CrLf
inRange:
ret
validate ENDP


showComposite PROC USES ecx eax
; description: prints composite numbers by calling subproc isComposite
; receives numComposites, returns print out of composite numbers with readable format
mov		ecx, numComposites		; set loop counter
PrintLoop:
mov		eax, composite
call	isComposite				; check if number is composites (starts at 2)
cmp		compBool, 1				; check bool variable set by subproc
je		print					; print if composite
inc		composite				; otherwise increment composite and start from the top, as not to affect ecx
jmp		PrintLoop
return_print:					; print jump returns here and also increments composite before returning to printloop
inc 	composite
loop	PrintLoop				; loop instruction
ret
print:
mov		eax, composite
call	WriteDec				; print numbers determined to be composite
mov		al, 9
call	WriteChar				; tab in between numbers
inc		colCounter				; manage columns and rows to format output properly
cmp		colCounter, 10
je		newline
jmp		return_print
newline:						; adds a newline and resets applicable counters
call	CrLf
mov		colCounter, 0
inc		rowCounter
cmp		rowCounter, 10
je		pressKey
jmp		return_print
pressKey:						; adds a break for user input to continue
call	WaitMsg
call	CrLf
mov		rowCounter, 0
jmp		return_print
showComposite ENDP


isComposite PROC USES edi eax ebx edx
; description: checks composite variable to see if it is composite by using stored non-composite (prime) numbers
; to see if the prime numbers are multiples of the composite
; receives composite, returns compBool as a flag of 1 (is composite) or 0 (is not)
mov		edi, OFFSET primeArray	; begin at array's address
mov		eax, composite
compareLoop:
mov		edx, 0
mov		ebx, 0					
cmp		ebx, [edi]				; check if array number is zero (meaning it is empty)
je		isNotComp				; will add 2 to array initially, then it will be used as a signal that larger numbers are prime, when they run out of divisors
mov		eax, composite
mov		ebx, [edi]
div		ebx						; divide the composite by all numbers less than itself in the prime array
cmp		edx, 0					; if remainder is zero, it is divisible by a prime and is therefore composite
je		isCompFlag
add		edi, 4
mov		eax, composite
mov		ebx, [edi]
jmp		compareLoop
isCompFlag:						; if number is divisible by a prime, it is composite
mov		compBool, 1				; and the proc will return 1 
jmp		endCompCheck
isNotComp:						; if not composite, then it is prime and added to the array 
mov		[edi], eax				; and the proc will return 0
mov		compBool, 0
endCompCheck:
ret
isComposite ENDP


goodbye PROC USES edx
; description: displays farewell message with user's name
; receives userName, returns goodbye message
call	CrLf
mov		edx, OFFSET farewell
call	WriteString
mov		edx, OFFSET userName
call	WriteString
ret
goodbye ENDP


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
COMMENT @
These are extra procedures I made to practice and play with making an array. Please disregard.
@

findPrimes PROC USES edi eax ebx edx
; fills array with all prime numbers between 1-1000
mov		edi, OFFSET primeArray
mov		eax, primeCount
mov		[edi], eax				; move 2 into the array
inc		primeCount
mov		ebx, primeCount
checkLoop:
dec		ebx
cmp		ebx, 1					; if ebx gets down to 1, then the number is prime
je		isPrime
mov		edx, 0
mov		eax, primeCount
div		ebx
cmp		edx, 0
je		nextNum
jmp		checkLoop
isPrime: ; if nothing found in loop, add to array
mov		eax, primeCount
add		edi, 4
mov		[edi], eax
NextNum:
inc		primeCount
mov		ebx, primeCount
dec		ebx
cmp		primeCount, 1200		; 1200 was a constant, but I took it out since it is unused
jne		checkLoop
ret
findPrimes ENDP

printPrimes PROC USES edi ecx eax
; prints primeArray without formatting, for testing purposes
mov		edi, OFFSET primeArray
mov		ecx, 168
printPLoop:
mov		eax, [edi]
call	WriteDec
add		edi, 4
loop	printPLoop
call	CrLf
ret
printPrimes ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

END main