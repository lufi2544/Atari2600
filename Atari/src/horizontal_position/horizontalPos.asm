	processor 6502

	include "vcs.h"
	include "macro.h"

	seg Code
	org $F000


Start:
	CLEAN_START

	lda #$80
	sta COLUBK

StartFrame:
	lda #%00000010
	sta VBLANK
	sta VSYNC

VerticalSync:
	ldx #3
	sta WSYNC
	dex
	bne VerticalSync 

	lda #%00000000
	sta VSYNC

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; We are going to set the Horizontal positioning for the player in the Vertical Blank
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

VerticalBlank:
	ldx #37	
	sta WSYNC
	dex
	bne VerticalBlank

	lda #0
	sta VBLANK

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 192 Visible Scanlines
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ldx #192
LoopVisible:
	sta WSYNC
	dex 
	bne LoopVisible


	lda #%00000010
	sta VBLANK

Overscan:
	ldx #35
	sta WSYNC
	dex
	bne Overscan

	lda #%00000000
	sta VBLANK

	jmp StartFrame

	org $FFFC
	.word Start
	.word Start

