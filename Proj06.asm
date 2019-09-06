TITLE Low-level I/O procedures    (Proj06.asm)

; Author: Cory Schmidt
; CS271 / Prog06A                 Date: 03/19/2018
;Implement and test ReadVal and WriteVal procedures for unsigned integers.
;Implement macros getString and displayString.
	;getString should display a prompt, then get the user’s keyboard input into a memory location
	;displayString should print the string which is stored in a specified memory location.
	;readVal should invoke the getString macro to get the user’s string of digits. It should then convert the digit string to numeric, while validating the user’s input.
	;writeVal should convert a numeric value to a string of digits, and invoke the displayString macro to produce the output.
;Small test program gets 10 valid integers from user, stores numeric values in an array. The program then displays the integers, their sum, and their average. 	

;**EC: Numbers each line of user input and displays running subtotal of user's numbers
;      ReadVal and WriteVal procedures are recursive

INCLUDE Irvine32.inc

NO_LOOPS = 10   ;numer of inputs to loop
STRSIZE = 20   ;max size of input strings

;-----------------------------------------------------
getString MACRO buffer, prompt_string
;
; Displays a variable, using its known attributes.
;-----------------------------------------------------
   push   edx
   push   ecx
   displayString OFFSET prompt_string
   mov       edx, buffer
   mov       ecx, STRSIZE - 1
   call   ReadString
   pop       ecx
   pop       edx
ENDM

;-----------------------------------------------------
displayString MACRO buffer
; Displays a string.
;-----------------------------------------------------
   push   edx
   mov       edx, buffer
   call   WriteString
   pop       edx
ENDM

.data
dwordArray			DWORD   NO_LOOPS DUP(?)
loopcount			DWORD   0               ;loop counter
runningtot			DWORD   0               ;running total accumulator
programTitle		BYTE   "PROGRAMMING ASSIGNMENT 6: Designing low-level I/O procedures", 0
myName				BYTE   "Written by: Cory A. Schmidt",0
instructions_1		BYTE   "Please provide 10 unsigned decimal integers.",0
instructions_2		BYTE   "Each number needs to be small enough to fit inside a 32 bit register.",0
instructions_3		BYTE   "After you have finished inputting the raw numbers I will display a list",0
instructions_4		BYTE   "of the integers, their sum, and their average value. ",0
extracredit_1		BYTE   "**EC: Each line of inputted entered is numbered and displays running subtotal of numbers entered following each input.",0
extracredit_2		BYTE   "**EC: ReadVal and WriteVal procedures are recursive.",0
prompt_1			BYTE   "Please enter an unsigned number: ",0
prompt_2			BYTE   "Please try again: ",0
error				BYTE   "ERROR : You did not enter an unsigned number or your number was too big.", 0
results_1			BYTE   "You entered the following numbers: ",0
results_2			BYTE   "The sum of these numbers is: ",0
results_3			BYTE   "The average is: ", 0
goodBye				BYTE   "Thanks for playing!",0
spacer				BYTE   ", ",0

.code
;-----------------------------------------------------
main PROC
;-----------------------------------------------------
   displayString OFFSET programTitle
   call   CrLf
   displayString OFFSET myName
   call   CrLf
   call   CrLf
   displayString OFFSET instructions_1
   call   CrLf
   displayString OFFSET instructions_2
   call   CrLf
   displayString OFFSET instructions_3
   call   CrLf
   displayString OFFSET instructions_4
   call   CrLf
   displayString OFFSET extracredit_1
   call   CrLf
   displayString OFFSET extracredit_2
   call   CrLf
   call   CrLf
   displayString OFFSET prompt_1
   push   0FFFFFFFFh					;largest possible 32bit int
   call   WriteVal
   call   CrLf
   displayString OFFSET prompt_2
   mov       ecx, NO_LOOPS				;global variable
   mov       edi, OFFSET dwordArray		;array[0]

mainloop:
   mov				eax, loopcount
   call				WriteDec
   mov				eax, runningtot
   call				WriteDec
   call				CrLf
   push				edi                       ;push the array
   call				ReadVal
   call				CrLf
   inc				loopcount
   mov				eax, [edi]
   add				edi, 4                   ;increment array
   mov				ebx, runningtot
   add				eax, ebx
   jc				overflow
   mov				runningtot, eax
   loop				mainloop
   jmp				skipend

overflow:
   displayString	OFFSET error
   call				CrLf

skipend:
   push				NO_LOOPS               ;size of array
   push				OFFSET dwordArray
   call				Results
   call				CrLf
   displayString	OFFSET goodBye
   call				CrLf
   exit   ; exit to operating system
main ENDP

;-----------------------------------------------------
ReadVal PROC
; Converts a string of user input to an integer.
;-----------------------------------------------------
   push   ebp
   mov       ebp, esp
   jmp       skip1
errormess:
   displayString OFFSET error
   call   CrLf
   jmp       skip1
skip1:
   mov       esi, [ebp+8]
   getString esi, prompt_1
   mov       eax, 0
   push   eax
reads:
   mov       eax, 0
   LODSB
   cmp       al, 0
   je       endread       ;NULL terminate
   pop       ebx           ;restore calculated value
   push   eax           ;save ascii char
   mov       eax, ebx
   mov       ebx, 10
   mul       ebx           ;multiply result by 10
   jc       errormess
   mov       edx, eax   ;store result in edx
   pop       eax           ;reload ascii char
   cmp       al, 48       ;cmp to ascii 0
   jl       errormess
   cmp       al, 57       ;cmp to ascii 9
   jg       errormess
   mov       ah, 48
   sub       al, ah       ;convert ascii to dec
   mov       ah, 0
   add       eax, edx
   jc       errormess
   push   eax           ;save calculated value
   jmp       reads
endread:
   pop       eax
   mov       esi, [ebp+8]
   mov       [esi], eax
   ;displayString OFFSET prompt_2   ;debug
   ;call   WriteDec
   ;call   CrLf
   pop       ebp
   ret 4
ReadVal ENDP

;-----------------------------------------------------
WriteVal PROC
; Converts a numeric value to a string of digits and displays output.
;-----------------------------------------------------
   push   ebp
   mov       ebp, esp
   pushad
   sub       esp, 2           ;make space for the character string
;-----header------
   mov       eax, [ebp+8]
   lea       edi, [ebp-2]   ;LEA to access the local address
   mov       ebx, 10
   mov       edx, 0
   div       ebx               ;divide input by 10
   cmp       eax, 0
   jle       endwrite       ;end recursion when eax = 0
   push   eax
   call   WriteVal
endwrite:
   mov       eax, edx
   add       eax, 48           ;convert to ascii
   stosb                   ;store in edi
   mov       eax, 0           ;null terminator
   stosb
   sub       edi, 2           ;reset edi
   displayString edi
;-----footer------
   add       esp, 2
   popad
   pop       ebp
   ret       4
WriteVal ENDP

;-----------------------------------------------------
Results PROC
; Calculates the sum and mean of ints in an array.
;-----------------------------------------------------
   push   ebp
   mov       ebp, esp
   mov       esi, [ebp+8]
   mov       ecx, [ebp+12]
   sub       esp, 4
   mov       edx, 0           ;use eax to calculate the sum
   displayString OFFSET results_1
   call   crlf
   jmp       s1
resloop:
   displayString OFFSET spacer
s1:
   push   [esi]
   call   WriteVal
   mov       ebx, [esi]
   add       edx, ebx
   add       esi, 4
   loop   resloop
   call   crlf
   displayString OFFSET results_2
   push   edx               ;display the sum
   call   WriteVal
   call   crlf
   displayString OFFSET results_3
   mov       eax, edx
   mov       edx, 0
   mov       ebx, [ebp+12]
   div       ebx
   push   eax
   call   WriteVal
   call   crlf
   add       esp, 4
   pop       ebp
   ret       8
Results ENDP

END main

