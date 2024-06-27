
	processor 6502

	seg Code
	.org $F000

Start:
	lda #$05			; A = 5
	sta $80				; $80 = A(5)
	lda #$0a			; A = 10
	sta $81				; $81 = A(0A)
	lda #0				; A = 0

	; Adds the values in the $80 and $81, counting with the A register for this, then storing the result to $82
	clc 
	adc $80
	clc 
	adc $81
	sta $82

End:
	jmp End



	.org $FFFC
	.word Start
	.word Start
