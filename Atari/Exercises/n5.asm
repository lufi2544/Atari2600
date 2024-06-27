
	processor 6502
	seg Code
	org $F000

Start:
	lda #$0A			; Load the A register with hex value $A
	ldx #%1010			; Load the X register with the binary value 1010
	sta $80				; Store the A value in the memory address $80( zero page )
	stx $81				; Store the X value in the memory address $81( zero page )

	lda #10				; Load a with #10
	clc					; Clear the carry flag ALWAYS
	adc $80				; Add to A regis the value in $80
	adc $81				; Add to A regis the value in the $81

	sta $82				; Store the value of A in $82

	org $FFFC
	.word Start			; Put 2 bytes at the end of the ROM $FFFC for the reset memory address.
	.word Start			; Put 2 bytes for the interrupt memory address $FFFE.
