TITLE Integer Accumulator     (Proj03.asm)

; Author: Cory Schmidt
; CS271 / Prog03                 Date: 02/12/2018
;	Description: Repeatedly prompts the user to enter a number. Validates the user input to be in [-100, -1] (inclusive).
;	Counts and accumulates the valid user numbers until a non-negative number is entered. (The non-negative number is discarded.)
;	Calculates the (rounded integer) average of the negative numbers.
;	Displays:
;		i. the number of negative numbers entered (Note: if no negative numbers were entered, display a special message and skip to iv.)
;		ii. the sum of negative numbers entered
;		iii. the average, rounded to the nearest integer (e.g. -20.5 rounds to -20)
;		iv. a parting message (with the user’s name) 

INCLUDE Irvine32.inc

.data				; this is the data area
programTitle		BYTE "Welcome to the Integer Accumlator",0
myName				BYTE " by Cory Schmidt",0
userName_msg		BYTE "What is your name?",0
hello				BYTE "Hello, ",0
instructions_1		BYTE "Please enter numbers between [-100, -1].",0
instructions_2		BYTE "Enter a non-negative number when you are finished.",0
instructions_3		BYTE "Enter a number: ",0
numbersEntered1		BYTE "You entered ",0
numbersEntered2		BYTE " valid numbers.",0
sum_msg				BYTE "The sum of your valid numbers is ",0
roundedAve_msg		BYTE "The rounded average is ",0
error_msg			BYTE "You did not enter any negative numbers.",0

; terminating message
goodbye1			BYTE "Thank you for playing Integer Accumulator! It's been a pleasure to meet you, ",0
goodbye2			BYTE ".",0

userName			BYTE 21 DUP(0)

count				DWORD ?
number				DWORD ?
userNameByteCount	DWORD ?
roundedAverage		DWORD 0
quantity			DWORD 0

;constants
LOWERLIMIT = -1
UPPERLIMIT = -100

.code			; this is the code area
main PROC
;introduction
mov				edx, OFFSET programTitle
call			WriteString
mov				edx, OFFSET myName
call			WriteString
call			CrLf

;get user's name
mov				edx, OFFSET userName_msg 
call			WriteString
call			CrLf
mov				edx, OFFSET userName
mov				ecx, SIZEOF	userName
call			ReadString
mov				userNameByteCount, eax

;greets the user
mov				edx, OFFSET hello
call			WriteString
mov				edx, OFFSET userName
call			WriteString
call			CrLf

;instructions
openingPrompt:
mov				edx, OFFSET instructions_1
call			WriteString
call			CrLf
mov				edx, OFFSET instructions_2
call			WriteString
call			CrLf

;loop that allows user to keep entering negative numbers
userNumbers:	mov				eax, count
				add				eax, 1
				mov				count, eax
				mov				edx, OFFSET instructions_3
				call			WriteString
				call			ReadInt
				mov				number, eax
				cmp				eax, LOWERLIMIT
				jg				accumulate
				cmp				eax, UPPERLIMIT
				jl				accumulate
				add				eax, quantity
				mov				quantity, eax
				loop			userNumbers

;accumlation
accumulate:		mov		eax, count
				sub		eax, 1
				jz		error
				mov		eax, quantity
				call	CrLf

				;numbers entered
				mov		edx, OFFSET numbersEntered1
				call	WriteString
				mov		eax,count
				sub		eax,1
				call	WriteDec
				mov		edx,OFFSET numbersEntered2
				call	WriteString
				call	CrLf

				;sum of numbers accumulated
				mov		edx, OFFSET sum_msg
				call	WriteString
				mov		eax, quantity
				call	WriteInt
				call	CrLf

				;rounded average of numbers entered
				mov		edx, OFFSET roundedAve_msg
				call	WriteString
				mov		eax,0
				mov		eax,quantity
				cdq	
				mov		ebx,count
				sub		ebx,1
				idiv	ebx
				mov		roundedAverage,eax
				call	WriteInt
				call	CrLf
				jmp		TheEnd

error:			mov		edx, OFFSET error_msg
				call	WriteString
				call	CrLf

;goodbye
TheEnd:
call CrLf
mov				edx, OFFSET goodbye1
call			WriteString
mov				edx, OFFSET userName
call			WriteString
mov				edx, OFFSET goodbye2
call			WriteString
call			CrLf
call			CrLf

exit	; exit to operating system
main ENDP

END main
