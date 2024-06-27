
	processor 6502


	include "vcs.h"
	include "macro.h"

	seg Code
	org $F000				; Set the ROM origin at this memory address

Start: 
	CLEAN_START				; Clears the Zero Page and the Stack

	lda #%00000001		
	sta CTRLPF      		; sets the bit 0 in the CTRLPF register which controls the reflection of the field
	lda #$83				; this is the blue
	sta COLUBK

FrameStart:
	lda #%00000010
	sta VSYNC				; Turn on the VSYNC
	sta VBLANK				; Turn on the VBLANK


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Paint 3 scanlines for the VSYNC
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	lda #0
	ldx #3
VsyncLoop:
	sta WSYNC				; signal the the TIA and wait scanline draw
	dex						; x--
	bne VsyncLoop			; X == A(0)

	lda #%00000000			
	sta VSYNC				; Turn off the VSYNC

 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Paint recommended 37 VBLANK scanlines
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	lda #0
	ldx #37

VblankLoop:
	sta WSYNC
	dex						; X--
	bne VblankLoop


	lda #%00000000
	sta VBLANK				; Turn off the VBLANK

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 			   7 scanlines
;  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  ;;;;								    ;;;;									  ;;;;
;  ;;;;								    ;;;;									  ;;;;
;  ;;;;								    ;;;;									  ;;;;
;  ;;;;								    ;;;;									  ;;;;
;  ;;;;								    ;;;;									  ;;;;
;  ;;;;								    ;;;;									  ;;;;
;  ;;;;		    164 scanlines			;;;;								      ;;;;
;  ;;;;								    ;;;;									  ;;;;
;  ;;;;								    ;;;;									  ;;;;
;  ;;;;								    ;;;;									  ;;;;
;  ;;;;								    ;;;;									  ;;;;
;  ;;;;								    ;;;;									  ;;;;
;  ;;;;								    ;;;;									  ;;;;
;  ;;;;								    ;;;;									  ;;;;   
;  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;   		    7 scanlines
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Paint 7 scanlines for the background - 7 blank PF scanlines
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	lda #%00000000		
	sta PF0
	sta PF1
	sta PF2

	ldx #7
BackgroundLoop:	
	sta WSYNC
	dex
	bne BackgroundLoop


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Part 1 of the playing field - 7 patterened scanlines 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	lda #$1F
	sta COLUPF				; Setting the color for the playfield

	lda #%11100000
	sta PF0
	lda #%11111111
	sta PF1
	sta PF2

	ldx #7	
Part1Loop:					; Drawing 7 scanlines for the firstpart of the playing field
	sta WSYNC
	dex						; X--
	bne Part1Loop	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Part 2 of the playing field - 164 scanlines
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	lda #%01100000
	sta PF0
	lda #%00000000			; Just modifying the PF1 and PF2 registers
	sta PF1

	lda #%10000000
	sta PF2
	
	ldx #164
Part2Loop:
	sta WSYNC
	dex 
	bne Part2Loop	


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Part 3 of the playing field - 7 patterned scanlines
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	lda #%11100000
	sta PF0
	lda #%11111111
	sta PF1
	sta PF2

	ldx #7
Part3Loop:
	sta WSYNC
	dex
	bne Part3Loop

	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Part 4 of the playing field  - 7 blank scanlines
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	lda #%00000000				
	sta PF0
	sta PF1
	sta PF2

	ldx #7
Part4Loop:
	sta WSYNC
	dex 
	bne Part4Loop


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; OverScan scanlines
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	lda #%00000010
	sta VBLANK
	ldx #30
OverScanLoop:	
	sta WSYNC
	dex
	bne OverScanLoop: 

	lda #%00000000
	sta VBLANK


	jmp FrameStart

	org $FFFC				; Complete our cartridge for it to be 4KB 
	.word Start
	.word Start
