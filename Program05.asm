TITLE Sorting Random Integers     (Program05.asm)

; Author: Amy Stockinger
; Last Modified: 11/13/18
; OSU email address: stockina@oregonstate.edu
; Course number/section: CS271 - 400
; Project Number: 5                Due Date: 11/18/2018
; Description: This program prompts the user for a number [10, 200], generates that many random numbers [100, 999], prints
; the numbers, then displays the median value and the sorted list in descending order, going down the columns.
; EXTRA CREDIT: this program sorts using recursion
; EXTRA CREDIT: the numbers are displayed going down cols, and will only display up to 10 cols

INCLUDE Irvine32.inc

MINSIZE		EQU		10
MAXSIZE		EQU		200
LO			EQU		100
HI			EQU		999

.data
count		DWORD	?						; number of numbers requested
randArray	DWORD	MAXSIZE DUP(0)
introduce	BYTE    "Sorting Random Integers, by Amy Stockinger", 13, 10, 0
describe	BYTE	"This program generates random numbers in the range [100, 999], displays the original list, and ", 13, 10,
					"calculates the median value. Finally, it displays the list again, sorted in descending order.", 13, 10, 0
ECprint		BYTE	"***********************************************************************", 13, 10,
					"EC1: This program displays numbers ordered by column instead of row.", 13, 10,
					"EC2: This program uses a recursive bubble sort algorithm.", 13, 10,
					"***********************************************************************", 10, 13, 0
prompt		BYTE	"How many numbers should be generated? [10, 200]: ", 0
invalid		BYTE	"Invalid input.", 0
display1	BYTE	"The unsorted random numbers:", 13, 10, 0
display2	BYTE	"The median is ", 0
display3	BYTE	"The sorted list, numbers are descending going down the columns:", 10, 13, 0

.code
main PROC
call	Randomize				; initialize random

push	OFFSET ECprint
push	OFFSET describe
push	OFFSET introduce
call	introduction			; introduce program

push	OFFSET invalid
push	OFFSET prompt
push	OFFSET count
call	getCount				; Get the user's number

push	OFFSET randArray
push	count
call	fillArray				; Put that many random numbers into the array

push	OFFSET display1	
push	OFFSET randArray
push	count
call	printArray				; Print the unsorted array

push	OFFSET randArray
push	count
pop		eax
mov		ebx, 4
mul		ebx
push	eax		
call	sortArray				; sort array 

push	OFFSET display2
push	OFFSET randArray
push	count
call	getMedian				; find and display median

push	OFFSET display3			
push	OFFSET randArray
push	count
call	printArray				; display sorted array

exit							; exit to operating system
main ENDP


; ***************************************************************
; Procedure introduces the program
; receives: 3 strings
; returns: nothing
; preconditions: 3 string addresses popped onto stack
; registers changed: edx
; ***************************************************************
introduction	PROC
push	ebp
mov		ebp, esp
mov		edx, [ebp + 8]
call	WriteString
mov		edx, [ebp + 12]
call	WriteString
mov		edx, [ebp + 16]
call	WriteString
pop		ebp
ret		12
introduction	ENDP


; ***************************************************************
; Procedure to get and validate the user's input
; receives: address of count on system stack
; returns: user input in global count
; preconditions: none
; registers changed: eax, ebx, edx
; ***************************************************************
getCount   PROC
push	ebp
mov		ebp, esp
promptCount:
mov		edx, [ebp + 12]
call	WriteString				; prompt user
call	ReadInt					; get user's number
cmp		eax, MINSIZE			; validate number
jl		error
cmp		eax, MAXSIZE
jg		error
mov		ebx, [ebp + 8]
mov		[ebx], eax				; put number into count address  
jmp		returnCount
error:
mov		edx, [ebp + 16]
call	WriteString				; print error messages if number is not in range
call	CrLf
jmp		promptCount
returnCount: 
pop		ebp
ret		12
getCount   ENDP


; ***************************************************************
; Procedure to put count random numbers into randArray
; receives: address of array and value of count on system stack
; returns: first count elements of array
; preconditions: count is initialized, 10 <= count <= 200
; registers changed: eax, ebx, ecx, edi
; ***************************************************************
fillArray  PROC
push	ebp
mov		ebp, esp
mov		ecx, [ebp + 8]		; count in ecx for loop counter
mov		edi, [ebp + 12]		; address of array in edi
generate:					; make rand value	
mov		eax, 900			; using 900 will generate a number [0, 899]		
call	RandomRange
add		eax, LO				; add 100 to make it [100, 999]
mov		[edi], eax			; put value into array
add		edi, 4				; increment edi to the next index
loop	generate
pop		ebp
ret		8
fillArray  ENDP

; ***************************************************************
; Procedure to sort randArray in descending order
; receives: address of array and value of count * 4 on system stack
; returns: descended sorted randArray
; preconditions: count is initialized, 10 <= count <= 200
;                and the first count elements of array initialized
; registers changed: eax, ebx, ecx, edx, esi
; sub procedures: swap
; ***************************************************************
sortArray	PROC
push	ebp
mov		ebp, esp
mov		eax, [ebp + 8]				; eax = n = largest index
mov		esi, [ebp + 12]				; esi = address of array

cmp		eax, 4						; if n = 1(* sizeof DWORD), end loop
je		sorted
sub		eax, 4						; n - 1
mov		ecx, 0						; int i = 0
sub		ecx, 4
forLoop:
	add		ecx, 4					; i++
	cmp		ecx, eax				; i < n - 1
	jge		recursion
	mov		ebx, [esi + ecx]
	cmp		ebx, [esi + ecx + 4]	; if array[i] < array[i + 1], swap
	jg		forLoop

	push	esi
	push	ecx
	mov		edx, ecx
	add		edx, 4
	push	edx
	call	swap
	jmp		forLoop

recursion:
	push	esi
	push	eax
	call	sortArray				; call proc to sort array[0] to array[n-1]

sorted:
pop		ebp
ret		8
sortArray	ENDP

; ***************************************************************
; Procedure to swap numbers in an array
; receives: address of array and two index numbers to be switched
; returns: nothing
; preconditions: array exists
; registers changed: none
; ***************************************************************
swap	PROC
push	ebp
mov		ebp, esp
pushad
mov		esi, [ebp + 16]
mov		ebx, [ebp + 12]
mov		edx, [ebp + 8]
push	[esi + ebx]			; push numbers to stack
push	[esi + edx]
pop		edi
mov		[esi + ebx], edi	; pop into a register and place into proper address
pop		edi
mov		[esi + edx], edi
popad
pop		ebp
ret 12
swap	ENDP


; ***************************************************************
; Procedure to determine and print median value of randArray
; receives: address of array and value of count on system stack
; returns: median value of randArray
; preconditions: count is initialized, 10 <= count <= 200
;                and the first count elements of array initialized
; registers changed: eax, ebx, ecx, edx, edi
; ***************************************************************
getMedian	PROC
push	ebp
mov		ebp, esp
mov		ecx, [ebp + 8]		; count in ecx to keep a copy
mov		esi, [ebp + 12]		; address of array in esi
mov		edx, [ebp + 16]
call	WriteString
mov		eax, ecx
mov		ebx, 2
mov		edx, 0
div		ebx					; divide count by 2 to get first middle number index in sorted array
mov		ebx, 4
mul		ebx					; multiply by 4 to get the index address
mov		ebx, eax			; copy into ebx so eax can be used for printing
test	ecx, 1				; find out if ecx (count) is even
jz		isEven
mov		eax, [esi + ebx]
call	WriteDec
jmp		endMed
isEven:						; if we have an even count, there are two middle numbers
mov		eax, [esi + ebx]	; put first number in eax
sub		ebx, 4				; add 4 to ebx to get second num
add		eax, [esi + ebx]	; add both middle numbers togeher
mov		ebx, 2
div		ebx					; divide the sum by 2
cmp		edx, 1				; handle remainder
je		increment			; increment eax if necessary, otherwise print it
call	WriteDec
jmp		endMed
increment:
inc		eax
call	WriteDec
endMed:
pop		ebp
call	CrLf
ret		12
getMedian	ENDP


; ***************************************************************
; Procedure to display randArray
; receives: address of array and value of count on system stack
; returns: elements of array
; preconditions: count is initialized, 10 <= count <= 200
;                and the first count elements of array initialized
; registers changed: eax, ebx, ecx, edx, esi
; ***************************************************************
printArray	PROC
push	ebp
mov		ebp, esp
mov		ecx, [ebp + 8]		; count in ecx for loop
mov		esi, [ebp + 12]		; address of array in esi
mov		edx, [ebp + 16]
call	WriteString
mov		ebx, 10
mov		edx, 0
mov		eax, ecx			; copy count into eax
div		ebx					; div count by 10 so eax contains the number of rows needed
cmp		edx, 0
je		continue
inc		eax
continue:
mov		ebx, SIZEOF DWORD
mul		ebx					; multiply num rows * 4 for indexing
mov		ebx, 0				; mov 0 into ebx so it can be the array index incrementer
push	ebx					; save ebx to increment that for newline
cmp		edx, 0
je		skipDec
add		eax, 4
skipDec:
mov		edx, eax			; copy eax into edx so edx can be incremented by that amount each loop
mov		eax, 0				; use eax as column counter
push	eax
print:
mov		eax, [esi + ebx]
cmp		eax, 0
je		skipWrite
call	WriteDec			; print value
mov		al, 9
call	WriteChar			; print tab
jmp		skipInc
skipWrite:
inc		ecx					; if not printed, inc ecx to account for unprinted num in loop
skipInc:
add		ebx, edx			; increment ebx by edx (num rows * 4)
pop		eax
inc		eax
cmp		eax, 10
je		newLine
returnNewLine:
push	eax
loop	print
jmp		return
newLine:
mov		eax, 0				; reset column counter
pop		ebx					
add		ebx, SIZEOF DWORD
push	ebx
call	CrLf
jmp		returnNewLine
return:
pop		eax
pop		ebx
pop		ebp
call	CrLf
ret		12
printArray	ENDP

END main