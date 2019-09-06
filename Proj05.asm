TITLE Sorting Random Integers     (Proj05.asm)

; Author: Cory Schmidt
; CS271 / Prog04                 Date: 03/04/2018
;	Description: Asks user to enter a number in a range (between 10 to 200)
;	Generates random integers in the range and storing them in order in an array.
;	Displays the integers before sorting, 10 numbers per line.
;	Sort the list in descending order.
;	Calculate and display the median value, rounded to the nearest integer.
;	Display the sorted list, 10 numbers per line. 

INCLUDE Irvine32.inc

.data
programTitle		BYTE   "Sorting Random Integers", 0
myName				BYTE	"Cory Schmidt", 0
instructions		BYTE   "This program generates random numbers in the range [100 .. 999], displays the original list,"
					BYTE   " sorts the list, and calculates the median value. Finally, it displays the list sorted in descending order.", 0
promptUser			BYTE   "How many numbers should be generated? [10...200] ", 0
invalidInt			BYTE   "Invalid input", 0
arrayTitle1			BYTE   "The unsorted random numbers:", 0
arrayTitle2			BYTE   "The sorted list:", 0
arrayForm1			BYTE   "     ", 0   ;spacing between numbers
arrayForm2			DWORD   1           ;numbers per line
unsortedMessage		BYTE   "The unsorted random numbers:", 0  
medianMessage		BYTE   "The median is ", 0

;min and max range of the number of random integers to generate
MIN = 10
MAX = 200

;low and high range of random integers to generate
LO = 100
HI = 999

userInput			DWORD   ?				;random numbers to be generated
randArray			DWORD   MAX DUP(?)		;random numbers generated
randArraySize		DWORD   ?				;size of array
range				DWORD   ?				;range of random numbers to generate

.code
intro PROC
   mov    edx, OFFSET programTitle     ;introduce program title
   call   WriteString
   call   CrLf
   mov	  edx, OFFSET myName
   call   WriteString
   call   CrLf
   mov    edx, OFFSET instructions     ;introduce program
   call   WriteString
   call   CrLf
   call   CrLf
   ret
intro ENDP

getData PROC
   push		 ebp            ;save old ebp
   mov       ebp, esp                  
getInput:
   ;Prompt user for the number of random integers to be generated
   mov    edx, [ebp+16]     ;prompt user for number of random integers
   call   WriteString
   call   ReadInt          
   mov    [ebp+8], eax     
   call   CrLf

   ;Validate user's input to be in the range [10...200]
   cmp    eax, min          ;compare user's input to min range allowed
   jl     invalidInput      ;if user's input < min input is invalid
   cmp    eax, max          ;compare user's input to max range allowed
   jg	  invalidInput      ;if user's input > max input is invalid
   jmp    Valid             ;input is valid

invalidInput:
   mov    edx, [ebp+12]                        ;invalid input message
   call   WriteString
   call   CrLF
   jmp    getInput                             ;get new input

Valid:
   mov    userInput, eax                      
   pop    ebp                                  
   ret    12                            
getData ENDP

fillArray PROC
   push   ebp                               
   mov    ebp, esp

   ;Calculate range [LO, HI]
   mov    eax, HI                                   ;HI range
   sub    eax, LO                                   ;LO range
   inc    eax                                
   mov    ebx, [ebp+20]                     
   mov    [ebx], eax                        
	;;;;;;;;
   ;Generate random numbers and store them in array
   mov    ecx, [ebp+16]                           ;loop user's input
   mov    esi, [ebp+12]                           ;first element of array
Generate:
   mov    ebx, [ebp+20]                           ;range variable address
   mov    eax, [ebx]                               ;global range variable value
   call   RandomRange                               ;generate random number based on global range
   add    eax, LO                                   ;adjust random generator for min value

   ;Store random number in array
   mov    [esi], eax                               ;store random integer in current array index
   add    esi, 4                                   ;add 4 bytes to current array index for next index

   ;Increment array size by 1
   mov    ebx, [ebp+8]                           ;size of array
   mov    eax, 1                                  
   add    [ebx], eax                               ;increment array size by 1

   loop   Generate                               ;obtain & store more random numbers

   pop    ebp                                       ;restore old ebp
   ret    16
fillArray ENDP

displayArray PROC
   push   ebp                                       ;save old ebp
   mov    ebp, esp

   ;Display array's title
   mov    edx, [ebp+16]                           ;array's title
   call   WriteString                  
   call   CrLf  

   ;Display array
   mov     ecx, [ebp+8]                           ;number of elements in array
   mov     esi, [ebp+12]                           ;array
More:
   mov    eax, [esi]                               ;current array element
   call   WriteDec

   ;Format array output
   mov    edx, OFFSET arrayForm1                   ;5 spaces between elements
   call   WriteString
   mov    eax, arrayForm2                           ;number of elements per line counter
   mov    ebx, 10
   mov    edx, 0
   div    ebx
   cmp    edx, 0
   jne    SameLine
   call   CrLf
SameLine:
   add       esi, 4                                   ;add 4 bytes to current array element for next element
   inc       arrayForm2                               ;increment line counter by 1
   loop   More                                   ;display more elements

   call   CrLF
   pop       ebp                                       ;restore old ebp
   ret       12
DisplayArray ENDP

sortList PROC
   push   ebp
   mov       ebp, esp
   mov       ecx, [ebp+8]                           ;size of array (filled elements)
L1:
   mov       esi, [ebp+12]                           ;array's current element
   mov       edx, ecx
L2:
   mov       eax, [esi]
   mov       ebx, [esi+4]
   cmp       ebx, eax
   jle       L3                                       ;if current element <= next element
   mov       [esi], ebx                               ;swap elements since current element > next element
   mov       [esi+4], eax

L3:
   add       esi, 4
   loop   L2
   mov       ecx, edx
   loop   L1

   pop       ebp
   ret       8
sortList ENDP

displayMedian PROC
   push   ebp                                      
   mov       ebp, esp

   ;Determine whether the number of integers are even or odd
   mov       eax, [ebp + 8]                           ;array size
   mov       edx, 0                                   ;set to 0 for remainder
   mov       ebx, 2
   div       ebx
   cmp       edx, 0
   je       IsEven                                   ;array size is even

   ;Array size is odd
   inc       eax                                       
   jmp       Display

IsEven:
   mov       ebx, eax                              
   inc       ebx                                       
   add       eax, ebx                              
   mov       ebx, 2
   div       ebx                                       
   jmp       Display

Display:
   mov    edx, OFFSET medianMessage                 
   call   WriteString
   call   WriteDec
   call   CrLf

   pop       ebp                                     
   ret       12
displayMedian ENDP

main PROC
   call       Randomize               ;create seed for RandomRange
   call       intro                   ;introduce program and get user's input

   ;Get, validate user's input for the number of random numbers to generate
   push       OFFSET promptUser       ;pass string argument to prompt user for input
   push       OFFSET invalidInt       ;pass string argument to warn for invalid input
   push       OFFSET userInput       ;pass argument to store user's input
   call       getData               ;procedure to validate, store user's input

   ;Generate random numbers and store them in an array
   push       OFFSET range           ;pass argument for range of random numbers to generate
   push       userInput           ;pass argument for random numbers to generate
   push       OFFSET randArray           ;pass argument for array to store random numbers
   push       OFFSET randArraySize       ;pass argument for array's size
   call       fillArray               ;procedure to generate & store random numbers in an array

   ;Display unsorted random numbers to user
   push       OFFSET arrayTitle1       ;title of array
   push       OFFSET randArray           ;first element of array
   push       randArraySize               ;array size
   call       displayArray               ;call procedure to display array elements


   ;Sort unsorted array
   push       OFFSET randArray           ;first element of array
   push       randArraySize               ;array size
   call       sortList                   ;call procedure to sort array      


   ;Display sorted random numbers to user
   push       OFFSET arrayTitle2       ;title of array
   push       OFFSET randArray           ;first element of array
   push       randArraySize               ;array size
   call       DisplayArray               ;display array elements

   ;Display Median
   push       OFFSET medianMessage       ;median message
   push       OFFSET randArray           ;first element of array
   push       randArraySize               ;array size
   call       displayMedian                   ;display median


   exit   ; exit to operating system
main ENDP

END main

