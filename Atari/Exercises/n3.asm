
	processor 6502
	
	seg Code
	org $F000

Start:
	lda #15 		; Load the A register with decimal 15.
	tax				; Transfer the value from A to X.
	tay				; Transfer the value from A to Y.
	txa				; Transfer the value from X to A.
	tya				; Transfer the value from Y to A.

	ldx #6			; Load the X with decimal 6.
	stx $80			; Sets the x data into $80 address
	ldy $80			; Loads the y regis with the $80 data value, coming from X value.


	org $FFFC		; End the ROM by adding required values to memroy position $FFFC
	.word Start		; Put 2 bytes with the reset address at memory position $FFFC
	.word Start		; Put 2 bytes with the break address at memory position $FFFE



