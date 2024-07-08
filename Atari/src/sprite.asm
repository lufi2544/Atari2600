
	processor 6502

	include "vcs.h"
	include "macro.h"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Variables segment
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	seg.u Vars
	org $80
Player0H ds 1				; Player Height
Player0Y ds 1				; Player Y Position
GraphicsC equ #%00000010 ; Global var for initializing the Vsync and VBlank


	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ROM CODE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	seg Code
	org $F000


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; START
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Start:
	CLEAN_START
	lda #120
	ldx #9
	sta Player0Y
	stx Player0H

	lda #$00
	sta COLUBK				; BackGround Color

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	FRAME START
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
FrameStart: 
	lda GraphicsC
	sta VSYNC
	sta VBLANK

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	VSYNC AND VBLANK SCANLINES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ldx #3
Vsync:
	sta WSYNC
	dex
	bne Vsync

	ldx #%00000000
	stx VSYNC

	ldx #37
Vblank: 
	sta WSYNC
	dex
	bne Vblank

	ldx #%00000000
	stx VBLANK
		

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 192 Visible Scanlines
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ldx #192
LoopVisible:				; Try draw player comparing current scanline number with the PlayerY Position.  
	txa	
	sec
	sbc Player0Y
	cmp Player0H			; if result is < Player0H then Draw Player and >= 0
	bcc DrawPlayer
	lda #0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  Set the Player Color and Graphics Register in the TIA
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DrawPlayer:
	tay						; Y = Result of the DeltaPlayer0H
	sty $84					; $84 = Y
	ldy Player0H			; Y = Player0H
	dey						; Y--
	tya						; A = Y(PlayerH-1)
	sec 					; Set Carry Flag
	sbc $84					; A-=($84(Player0H - 1))
	tay						; Y = result of the delta coordinate 	
	lda FruitBitMap,Y		; Extract the graphicsPattern for the player
	sta GRP0		 

	lda FruitColorBitMap,Y	; Extract the color for the player
	sta COLUP0
	sta WSYNC
	dex 
	bne LoopVisible
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 35 Over Scan Scanlines
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	ldx #35
	lda GraphicsC
	sta VBLANK
Overscan:
	sta WSYNC
	dex
	bne Overscan

	lda #0
	sta VBLANK

	
	jmp FrameStart


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SPRITES DEFINITION
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	org $FFE9
FruitColorBitMap:				; 9 bytes Think about this as an aray with lenght 9 and indx from 0 to 8
	.byte #$C5
	.byte #$44
	.byte #$44
	.byte #$44
	.byte #$43
	.byte #$43
	.byte #$41
	.byte #$41
	.byte #$0F

	org $FFF3					; 9 bytes
FruitBitMap:				 
	.byte #%00011000
	.byte #%01101100
	.byte #%11111111
	.byte #%11111101
	.byte #%11111101
	.byte #%11111101
	.byte #%01111010
	.byte #%00010100
	.byte #%00000000

	



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ROM COMPLETION (4Kb)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	org $FFFC
	.word Start				; 2 bytes for address for the start function, expected by the Atari
	.word Start				; 2 bytes for completing the interrupt mapping, not used.
