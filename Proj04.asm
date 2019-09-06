TITLE Composite Numbers     (Proj04.asm)

; Author: Cory Schmidt
; CS271 / Prog04                 Date: 02/19/2018
;	Description: Asks user to enter the number of composites they would like to display. 
;	Prompts them to enter and integer between 1 and 400.
;	The user enters the number and the program tests to make sure the number is in range.
;	If the number is out of range, and error message is displayed.
;	The program then calculates and displays all of the composite numbers, up to and including the nth composite. 	

INCLUDE Irvine32.inc

.data				; this is the data area
programTitle		BYTE "Composite Numbers",0
myName				BYTE "	Programmed by Cory Schmidt",0
instructions_1		BYTE "Enter the composite numbers you would like to see.",0
instructions_2		BYTE " I'll accept orders for up to 400 composites.",0
instructions_3		BYTE "Enter the number of composites to display [1 .. 400]: ",0
errorMsg			BYTE "Out of range. Try again.",0
spaces				BYTE " ",0

; terminating message
goodbye				BYTE "Results certified by Cory. Goodbye.",0

;variables
userNumber		DWORD	?
column			DWORD	?
currentNum		DWORD	?
tryFactor		DWORD	?
tryFactorMax	DWORD	?

;constants
LOWERLIMIT = 1
UPPERLIMIT = 400
COLUMNMAX = 10

.code
main PROC
   call		introduction
   call		getUserData
   call		showComposites
   call		farewell
   exit
main ENDP

introduction PROC
   call   CrLf
   mov			edx, OFFSET programTitle
   call			WriteString
   mov			edx, OFFSET myName
   call			WriteString
   call			CrLf

   mov			edx, OFFSET instructions_1
   call			WriteString
   mov			edx, OFFSET instructions_2
   call			WriteString
   call			CrLf
   mov			ecx, 0
   ret
introduction ENDP

getUserData PROC
                   mov			edx, OFFSET instructions_3
                   call			WriteString
                   call			ReadInt
                   mov			userNumber, eax
				   call			validate
getUserData ENDP

validate PROC
                   mov			eax, userNumber
                   cmp			eax, LOWERLIMIT
                   jl			error
				   cmp			eax, UPPERLIMIT
				   jg			error
				   jmp			validated
	
	error:		   mov			edx, OFFSET errorMsg
				   call			WriteString
				   call			CrLf
				   call			getUserData
	
	validated:		ret
validate ENDP
            
showComposites	PROC
	; start loop counter at userNumber
	; manually set first composite number to 4
		mov		ecx, userNumber
		mov		currentNum, 4
		mov		column, 1

calculateLoop:	call	isComposite

	; print numbers/spaces, calculate new line
	printNum:
		mov		eax, currentNum
		call	WriteDec
		mov		edx, OFFSET spaces
		call	WriteString
		inc		currentNum
		cmp		column, COLUMNMAX
		jge		newLine
		inc		column
		jmp		continueLoop

	; print new line
	newLine:
		call	Crlf
		mov		column, 1

	continueLoop:
		loop	calculateLoop

	ret
showComposites	ENDP

isComposite	PROC
	resetFactoring:
		mov		eax, currentNum
		dec		eax
		mov		tryFactor, 2
		mov		tryFactorMax, eax

	tryFactoring:	mov		eax, currentNum
					cdq
					div		tryFactor
					cmp		edx, 0
					je		compositeFound
					inc		tryFactor
					mov		eax, tryFactor
					cmp		eax, tryFactorMax
					jle		tryFactoring	
					inc		currentNum	; failed to find any factors
					jmp		resetFactoring

	compositeFound:
		ret
isComposite	ENDP

farewell PROC
   ; say goodbye
   call			CrLf
   mov			edx, OFFSET goodbye
   call			WriteString
   call			CrLf
   exit
farewell ENDP
END main