TITLE Fibonacci Numers     (Proj02.asm)

; Author: Cory Schmidt
; CS271 / Prog02                 Date: 01/29/2018
; Description: Calculates and displays Fibonacci numbers. 

INCLUDE Irvine32.inc

.data			; this is the data area
programTitle	BYTE "Fibonacci Numers",0
myName			BYTE " Programmed Cory A. Schmidt",0
prompt			BYTE "What is your name?",0
instructions_1	BYTE "Enter the number of Fibonacci terms to be displayed.",0
instructions_2	BYTE " Give the number as an integer in the range [1 .. 46].",0
numFibo			DWORD ? ; 
previous1		DWORD ? ;
previous2		DWORD ? ;
spaces			BYTE " ",0
first_1			BYTE "1 1",0
first_2			BYTE "1",0
temp			DWORD ?
moduloFive		DWORD 5
UPPERLIMIT = 46
LOWERLIMIT = 1
goodbye			BYTE "Goodbye, ",0	; terminating message

;user's name
buffer			BYTE 21 DUP(0)
byteCount		DWORD ?

;greet the user
hello			BYTE "Hello, ",0

;input validation
highError		BYTE "Out of range. Enter a number in [1 .. 46].",0
lowError		BYTE "Out of range. Enter a number in [1 .. 46].",0

.code			; this is the code area
main PROC
;introduction
mov				edx, OFFSET programTitle
call			WriteString
mov				edx, OFFSET myName
call			WriteString
call			CrLf

mov				edx, OFFSET prompt
call			WriteString
call			CrLf

;get user's name
mov				edx, OFFSET buffer
mov				ecx, SIZEOF buffer
call			ReadString
mov				byteCount, eax

;greets the user
mov				edx, OFFSET hello
call			WriteString
mov				edx, OFFSET buffer
call			WriteString
call			CrLf

;instructions
openingPrompt:
mov				edx, OFFSET instructions_1
call			WriteString
mov				edx, OFFSET instructions_2
call			WriteString
call			CrLf

;get user data
call			ReadInt
mov				numFibo, eax

;input validation
cmp				eax, UPPERLIMIT
jg				TooHigh
cmp				eax, LOWERLIMIT
jl				TOOLOW
je				JustOne
cmp				eax, 2
je				JustTwo

;display numbers
mov				ecx, numFibo
sub				ecx, 3
mov				eax, 1
call			WriteDec
mov				edx, OFFSET spaces
call			WriteString
call			WriteDec
mov				edx, OFFSET spaces
call			WriteString
mov				previous2, eax
mov				eax, 2
call			WriteDec
mov				edx, OFFSET spaces
call			WriteString
mov				previous1, eax

fib:
add				eax, previous2
call			WriteDec
mov				edx, OFFSET spaces
call			WriteString
mov				temp, eax
mov				eax, previous1
mov				previous2, eax
mov				eax, temp
mov				previous1, eax
mov				edx, ecx
cdq
div				moduloFive
cmp				edx, 0
jne				skip
call			CrLf

skip:
mov				eax, temp
loop			fib
jmp				TheEnd

TooHigh:
mov				edx, OFFSET highError
call			WriteString
jmp				openingPrompt

TooLow:
mov				edx, OFFSET lowError
call			WriteString
jmp				openingPrompt

JustOne:
mov				edx, OFFSET first_1
call			WriteString
jmp				TheEnd

JustTwo:
mov				edx, OFFSET first_2
call			WriteString
jmp				TheEnd

;goodbye
TheEnd:
call CrLf
mov				edx, OFFSET goodbye
call			WriteString
mov				edx, OFFSET buffer
call			WriteString
call			CrLf

	exit	; exit to operating system
main ENDP

END main
