
	processor 6502

	seg Code
	org $F000
 
Start:
	ldy #10				; Loads the Y register with value 10

Loop:
	tya					; Transfers Y to A
	sta $80,Y			; Stores the value in A in the $80 + Y address
	dey					; y--
	bne Loop			; Loop until Y == 0

	sty $80				; As we breanced when Y == 0, last address was not zeroed
	
End:
	jmp End

	org $FFFC
	.word Start
	.word Start

