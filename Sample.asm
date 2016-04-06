; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
; Program Exercise 6
; Student:		Kirill Kudaev  
; Professor: 	Tom Fuller
; College:		Principia College
; Date:			April 4, 2016
; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
; This program simulates towers of hanoi puzzle.
; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
    include \masm32\include\masm32rt.inc
; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

.data

	; Storage for variables
	pegFrom		BYTE	?			; stores the number of peg we are moving disk from			
	pegTo		BYTE	?			; stores the number of peg we are moving disk to
	cRepeat		db 		3 DUP(?)	; stores char input	


.code
	include helper.inc

start:   
; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
	cls
    call maine
    inkey
    exit
; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
;	towers(n, i, j, k) where
;	n	-	number of disks
;	i	-	start peg
;	j	-	end peg
;	k	-	extra peg
; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
	towers proc

		push 	ebp 		; save frame pointer
		mov		ebp,esp 	; set new frame pointer above esp
		pushad				; push all general perpose registers to the stack
		
		cmp 	WORD PTR [ebp+14],1 ; check if 1 disk (WORD PTR - size directive, because the size is ambiguous)
		jne 	MoreThan1 			; skip if more than 1
		
		;Testing:
		;pushad
		;print 	"1 Disk.",13,10
		;popad
		
		mov 	ax,[ebp+12] 	; stores to ax the number of peg we are moving disk from
		mov 	pegFrom,al 		; ..and now stores to pegFrom
		mov 	ax,[ebp+10] 	; stores to ax the number of peg we are moving disk to
		mov 	pegTo,al 		; ..and now stores to pegTo
		
		call	message			; prints out a message how to move the last disk
		jmp 	FinishTowers
		
		MoreThan1:
		
		; Testing:
		;pushad
		;print 	"More than 1 Disk.",13,10
		;popad
		
		mov 	bx,[ebp+14] 	; store number of disks to bx
		dec 	bx 				; decrement number of disks by 1
		push 	bx 				; push n: number of disks total minus 1
		pushw 	[ebp+12] 		; push i: initial start peg
		pushw 	[ebp+8] 		; push j: extra peg is now end peg
		pushw 	[ebp+10] 		; push k: end peg is now extra peg
		call 	towers 			; calls towers(n,i,j,k) recursively with parameters above 
		
		add 	esp,8 			; remove parameters from the stack
		pushw 	1 				; push n: 1 disk
		pushw 	[ebp+12] 		; push i: initial start peg
		pushw 	[ebp+10] 		; push j: initial end peg
		pushw 	[ebp+8] 		; push k: initial extra peg
		call 	towers 			; calls towers(n,i,j,k) recursively with parameters above 
		
		add 	esp,8 			; remove parameters from the stack
		push 	bx 				; push n: number of disks total minus 1
		pushw 	[ebp+8] 		; push i: initial start peg
		pushw 	[ebp+10] 		; push j: initial destination
		pushw 	[ebp+12] 		; push k: initial extra peg
		call 	towers 			; calls towers(n,i,j,k) recursively with parameters above 
		
		add 	esp,8 			; remove parameters from the stack

		FinishTowers:
		popad					; pop all general perpose registers from stack
		pop		ebp
		
		ret
		
	towers endp
; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
;	Prints out a message of type:
;	"Move a disk from peg (pegFrom) to peg (pegTo)"
; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
	message proc
	
		print 	"Move a disk from peg "
		movsx 	ebx, pegFrom		; moves to ebx with sign extension
		print	str$(ebx)
		print 	" to peg "
		movsx 	ebx, pegTo			; moves to ebx with sign extension
		print	str$(ebx), 13, 10

		ret
	message endp
; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
	
	maine proc
	
		NewGame:
		mov 	ebx,sval(input("Enter the number of disks: ")) 	; get user input as an integer
		push 	bx
		mov		bl, 1	; start peg	
		push 	bx
		mov		bl, 2	; end peg		
		push 	bx
		mov		bl, 3	; extra peg	
		push 	bx
		
		call towers
		
		QuestionLoop:
		print	"Run again? Please reply Y or N: "
		invoke	StdIn,ADDR cRepeat,3				; in order to get a char input from user (to al)
		call	nwln								; new line
		mov 	al, [BYTE PTR cRepeat]			
		cmp		al, "y"								; "yes" case
		je		NewGame
		cmp		al, "Y"								; "yes" case
		je		NewGame
		cmp		al,	"n"								; "no" case
		je		Finish
		cmp		al,	"N"								; "no" case
		je		Finish
		print	"Invalid response", 13, 10			; otherwise when invalid character was entered
		jmp 	QuestionLoop
		
		Finish:		
		ret   	; return from the maine procedure
	maine endp

; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

end start
