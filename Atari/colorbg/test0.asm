
	processor 6502

	include "macro.h"
	include "vcs.h"

	seg Code
	org $F000

Start: 
	CLEAN_START				; Clears the CPU registers from $00 to FF


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Activate the VSYNC and VBLANK modes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

FrameStart: 
	ldx #%00000010			; Setting the bit 2 
	stx VSYNC				; Set the VSYNC mode to 1
	stx VBLANK				; Set the VBLANK mode to 1


	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Generate 3 scanlines for the VSYNC
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

VsyncDraw:	
	sta WSYNC				; fist scanline
	sta WSYNC				; second scanline
	sta WSYNC				; third scanline

	lda #0
	sta VSYNC				; turn off VSYNC
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Draw 37 scanlines for the VBLANK
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	ldy #37
	tya
	sta $80		; $80 = 37
	ldx #0

LoopVBlank:
	clc
	sta WSYNC				; Signal a scanline
	inx
	cpx $80					; X >= $80(37)
	bcc LoopVBlank			; if carry flag clear, then loop, thus, X < $80(37)	

	lda #0
	sta VBLANK				; turn off VBLANK

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Paint Rainbow in the screen
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ldx #192

LoopVisible:
	stx COLUBK 
	stx WSYNC
	dex
	bne	LoopVisible


	jmp FrameStart


	org $FFFC
	.word Start
	.word Start









	
