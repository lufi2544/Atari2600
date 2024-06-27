;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;									;							Exercise 1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	processor 6502

	seg Code 				; Defines a segment called Code
	org $F000				; Defines the origin of the ROM at address $F000

Start:
	lda #$82				; Loads the hex 82 to the A (Acumulator) register. 
	ldx #82					; Loads the decimal val 82 to the X register.
	ldy $82					; Loads the Y register with what is inside the memory address zero page $82

	org $FFFC 				; End the ROM by adding required values to memory position $FFFC
	.word Start			; put 2 bytes with the reset address at memory position $FFFC
	.word Start 			; put 2 bytes with the break addres at memory position $FFFE --> this is unused since the 6507 does not have interrupt pin, but required for the ROM to have exactly 4kb.


	

	
