TITLE Elemetry Arthimetic     (proj01.asm)

; Author: Cory Schmidt
; CS271 / Prog01                 Date: 01/21/2018
; Description: Calculates sum, difference, product, quotient and remainder of two numbers entered by the user.

INCLUDE Irvine32.inc

.data				; this is the data area
programTitle	BYTE "Elementary Arthimetic"	
myName			BYTE " by Cory A. Schmidt",0
instructions	BYTE "Enter 2 numbers, and I'll show you the sum, difference, product, quotient, and remainder.",0
firstNumber		DWORD ? ; first number entered by the user
secondNumber	DWORD ? ; second number entered by the user
number_1		BYTE "First number: ",0
number_2		BYTE "Second number: ",0
goodbye			BYTE "Impressed? Bye!"	; terminating message

sum				DWORD ? ; variable named sum for addition
difference		DWORD ? ; variable named difference for subtraction
product			DWORD ? ; variable named product for multipication 
quotient		DWORD ? ; variable named quotient for division
remainder		DWORD ? ; variable named remainder for division

equalString			BYTE " = ",0	;equal sign for calculation results
sumString			BYTE "+",0	;addition sign for calculating sum
differenceString	BYTE "-",0 ; subtraction sign for calculating difference
productString		BYTE "*",0 ; multipication sign for calculating product
quotientString		BYTE "/",0 ; division sign for calculating quotient
remainderString		BYTE " remainder ",0	;finds remainder post division 

.code				; this is the code area
main PROC

;Introduction

;displays programTitle
mov edx, OFFSET programTitle
call WriteString
call CrLf

;displays instructions
mov edx, OFFSET instructions
call WriteString
call CrLf

;get the data

;get firstNumber
mov edx, OFFSET number_1
call WriteString
call ReadInt
mov firstNumber, eax

;get secondNumber
mov edx, OFFSET number_2
call WriteString
call ReadInt
mov secondNumber, eax

;calculate the required values

;calculates/stores sum
mov eax, firstNumber
add eax, secondNumber
mov sum, eax

;calculates/stores difference
mov eax, firstNumber
sub eax, secondNumber
mov difference, eax

;calculates/stores product
mov eax, firstNumber
mov ebx, secondNumber
mul ebx
mov product, eax

;calculates/stores quotient/remainder
mov edx, 0
mov eax, firstNumber
cdq
mov ebx, secondNumber
cdq
div ebx
mov quotient, eax
mov remainder, eax

;display the results

;displays sum results
mov eax, firstNumber
call WriteDec
mov edx, OFFSET sumString
call WriteString
mov eax, secondNumber
call WriteDec
mov edx, OFFSET equalString
call WriteString
mov eax, sum
call WriteDec
call CrLf

;displays difference results
mov eax, firstNumber
call WriteDec
mov edx, OFFSET differenceString
call WriteString
mov eax, secondNumber
call WriteDec
mov edx, OFFSET equalString
call WriteString
mov eax, difference
call WriteDec
call CrLf

;displays product results
mov eax, firstNumber
call WriteDec
mov edx, OFFSET productString
call WriteString
mov eax, secondNumber
call WriteDec
mov edx, OFFSET equalString
call WriteString
mov eax, product
call WriteDec
call CrLf

;displays quotient/remainder results
mov eax, firstNumber
call WriteDec
mov edx, OFFSET quotientString
call WriteString
mov eax, secondNumber
call WriteDec
mov edx, OFFSET equalString
call WriteString
mov eax, quotient
call WriteDec
mov edx, OFFSET remainderString
call WriteString
mov eax, remainder
call WriteDec
call CrLf

;say goodbye

;displays terminating message
mov edx, OFFSET goodbye
call WriteString
call CrLf

	exit	; exit to operating system
main ENDP

END main
