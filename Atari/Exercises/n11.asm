
	processor 6502
	seg Code

	.org $F000

Start:
	lda #$01		; A = 1
	sta $80			; $80 = A(1)
	ldx #0			; X max times looping = 10

Loop: 				; Multipliying a number by 2, storing the result in $80,X address, taking the last address number as parameter for the next multiplication. 
	lda $80,X		; A = $8,X
	asl				; shifting A data 1 bit to the left
	inx				; X++
	sta $80,X		; $80,X = A store the value of the multiplication by 2 in one address further
	cpx #10			; compare X == 10
	bne Loop
	
End:
	jmp End

	.org $FFFC
	.word Start
	.word Start
