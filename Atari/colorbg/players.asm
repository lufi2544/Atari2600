
	processor 6502

	org $F000
	seg Code

	include "vcs.h"
	include "macro.h"


Start:
	CLEAN_START 			; Clearts the TIA and the page Zero memory regions and sets the Stack ptr to $FF	

	lda #$80				; load the NSTC dark blue color to the A regis
	sta COLUBK				; set the TIA register for the background color    

FrameStart:
	lda #%00000010			; Sets the bit 2 to the A regis
	sta VSYNC
	sta VBLANK 				; Activat the VBLANK and VSYNC 
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
; 	Draw 7 scanlines
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 

	ldx #7
VsyncLoop: 
	sta WSYNC				; Wait horizontal blank
	dex						; X--
	bne VsyncLoop

	lda #%00000000			; A = 0 flag
	sta VSYNC				; turning of the vsync


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
; 	Draw recommended 37 scanlines
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 

 	ldx #37
VblankLoop:
	sta WSYNC
	dex
	bne VblankLoop

	lda #%00000000
	sta VBLANK				; turning off VBLANK



; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
;  Draw 192 visible scanlines (NTSC)
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 

	ldx #192
VisibleLoop:
	sta WSYNC
	dex
	bne VisibleLoop



; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
;  Draw 30 scanlines for OverScan
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 

	ldx #30

	lda #%00000010
	sta VBLANK

OverScanLoop:
	sta WSYNC
	dex
	bne OverScanLoop
	
	lda #%00000000
	sta VBLANK


	jmp FrameStart


	org $FFFC			;; Completing cartradge with 4KB
	.word Start
	.word Start


	
