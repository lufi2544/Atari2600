
	processor 6502

	seg Code
	org $F000 			; Set the start of the ROM at this address

Start:
	lda #$A				; Load the A register with the hex value $A
	ldx #$FF			; Load the X register with the binary value %1111111
	sta $80				; Store the value in the A register into the memory address $80
	stx $81				; Store the value in the A register into the memory address $81

	org $FFFC
	.word Start			; mem address at $FFFC for reset pin
	.word Start			; mem address at $FFFE for interrupt pin, expected but inexistant in the 6507
	
