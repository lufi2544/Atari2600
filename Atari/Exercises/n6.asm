
	processor 6502
	seg Code

	org $F000				; Setting the org to the origin of the cartridge


Start:
	lda #1					; Load A with #1
	ldx #2					; Load X with #2
	ldy #3					; Load Y with #3

	inx						; X++
	iny						; Y++
	
	clc 					; Clear Carry flag
	adc #1					; A++

	dex						; X--
	dey						; Y--

	sec						; Set Carry flag
	sbc #1					; A--

End:
	jmp End

	org $FFFC
	.word Start				; Set the ROM reset memory address $FFFC
	.word Start				; Set the ROM interrupt memory address $FFFE


