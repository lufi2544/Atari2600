
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
	lda #183
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
	lda Player0H
	tay 					; setting the Y to Player0H
	dey						; Y-- Y = (Player0H - 1)
	tya
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
	sbc $84					; A-=($84(DeltaResultP0))
	tay						; Y = result of the delta coordinate 	
	sta WSYNC				; CPU HOLD FOR TIA finishing drawing the current scanline so we avoid manpulating the registers mid scanline drawing
	lda FruitBitMap,Y		; Extract the graphicsPattern for the player	
	sta GRP0
	lda FruitColorBitMap,Y	; Extract the color for the player
	sta COLUP0
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
	
	dec Player0Y
	jmp FrameStart


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SPRITES DEFINITION
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PlayerColorBitMap:				; 9 bytes Think about this as an aray with lenght 9 and indx from 0 to 8
	.byte #$00
	.byte #$02
	.byte #$02
	.byte #$52
	.byte #$52
	.byte #$52
	.byte #$52
	.byte #$52
	.byte #$52

PlayerBitMap:				 
	.byte #%00000000
	.byte #%00010000
	.byte #%00001000
	.byte #%00011100
	.byte #%00110110
	.byte #%00101110
	.byte #%00101110
	.byte #%00111110
	.byte #%00011100

	



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ROM COMPLETION (4Kb)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	org $FFFC
	.word Start				; 2 bytes for address for the start function, expected by the Atari
	.word Start				; 2 bytes for completing the interrupt mapping, not used.
