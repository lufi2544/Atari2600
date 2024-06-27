
	processor 6502
	seg Code

	.org $F000

Start:
	lda #1		;Initialize register A with 1

Loop:
	clc			; Clear carry flag
	adc #1		; A++
	cmp #10		; Carry flag will be 1 if (A >=10)
	bcc Loop	; loop if carry flag is set. Loop until A == 10

End:
	jmp End


	.org $FFFC
	.word Start
	.word Start
