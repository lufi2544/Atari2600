	processor 6502
		
	include "vcs.h"
	include "macro.h"


	seg Code
	org $F000

Start:
	lda #$80
	sta COLUBK

StartFrame:
	lda #%00000010
	sta VSYNC
	sta VBLANK

Vsync:
	ldx #3
	sta WSYNC
	dex 
	bne Vsync

	lda #%00000000
	sta VSYNC

Vblank:
	ldx #37
	sta WSYNC
	dex 
	bne Vblank

	lda #%00000000
	sta VBLANK
Main:
	ldx #192
	sta WSYNC
	dex
	bne Main


	ldx #%00000010
	stx VBLANK

Overscan:
	ldx #35
	sta WSYNC
	dex
	bne Overscan

	ldx #%0000000
	stx VBLANK

	jmp StartFrame

	org $FFFC
	.word Start
	.word Start

