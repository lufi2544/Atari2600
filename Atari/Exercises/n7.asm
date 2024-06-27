	
	processor 6502
	seg Code

	org $F000				; Setting the origin for the ROM code at address $F000

	
Start:
	lda #10 				; Loads the A regis with value #10
	sta $80					; Stores the value of A regis to address $80
	inc $80					; Increments the value of the (zero page) $80 by 1
	dec $80					; Decrements the vlaue of the (zero page) $80 by 1

End:
	jmp End

	org $FFFC
	.word Start				; Setting the Address $FFFC with 2 bytes, espected by the Atari for the Reset instruction	
	.word Start				; 2 bytes for the interrupt address, not used.

