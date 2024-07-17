	processor 6502
		
	include "vcs.h"
	include "macro.h"

	seg.u Vars
	org $80
P0X	byte					; sprite X
Player0H ds 1				; Player Height
Player0Y ds 1				; Player Y Position

	seg Code
	org $F000

Start:
	CLEAN_START

	lda #$80
	sta COLUBK		

	lda #183
	ldx #9
	sta Player0Y
	stx Player0H

	lda #40
	sta P0X					; Initialize the playerX Coordinate

StartFrame:
	lda #%00000010
	sta VSYNC
	sta VBLANK

	ldx #3
Vsync:
	sta WSYNC
	dex 
	bne Vsync

	lda #%00000000
	sta VSYNC

Vblank:
	lda P0X
	and #%01111111			; Keeps the value of  a always positive removeing the bit 7

	sta WSYNC
	sta HMCLR

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The goal is to adjust the player's horizontal position by dividing the player's position (P0X) by
;; 15 using a loop that subtracts 15 repeatedly.
;; Each subtraction and branch operation takes a specific number of CPU cycles and TIA cycles.(15 in this case)
;; 2 CPU for subtracting and 3 for branching, which makes 15 TIA cycles.
;;
;; The remainder after these subtractions will help to fine-tune the player's position.
;;
;; The loop continues as long as the result is non-negative (carry flag set).
;; When the result becomes negative, the carry flag is cleared, and the loop exits.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	sec
DivideLoop:					; Subtract 15 whilt A > 0
	sbc #15
	bcs DivideLoop

	eor #%00000111			; clamp between -8 and 7
	asl						; shift left by 4, as HMP0 uses only 4 bits
	asl
	asl
	asl
	sta	HMP0				; stores the result once the bits are shifted to HMP0 register			
	sta RESP0				; sets the P0 position to the beam position
	sta WSYNC				; wait until the scanline finishes to avoid visual glitches
	sta HMOVE				; submits adjustment position stored in HMP0 to the P0 and maybe P1.

	ldx #35
VblankLoop:
	sta WSYNC
	dex 
	bne VblankLoop

	lda #%00000000
	sta VBLANK

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
	lda PlayerBitMap,Y		; Extract the graphicsPattern for the player	
	sta GRP0
	lda PlayerColorBitMap,Y	; Extract the color for the player
	sta COLUP0
	dex 
	bne LoopVisible

	ldx #%00000010
	stx VBLANK

	ldx #30
Overscan:
	sta WSYNC
	dex
	bne Overscan

	ldx #%0000000
	stx VBLANK

	inc P0X
	lda P0X
	cmp #80
	bne ResetFrame
	lda #40
	sta P0X

ResetFrame:
	jmp StartFrame


PlayerColorBitMap:				; 9 bytes Think about this as an aray with lenght 9 and indx from 0 to 8
	.byte #$00
	.byte #$52
	.byte #$52
	.byte #$52
	.byte #$52
	.byte #$52
	.byte #$52
	.byte #$02
	.byte #$02

PlayerBitMap:				 
	.byte #%00000000
	.byte #%00011100
	.byte #%00111110
	.byte #%00101110
	.byte #%00101110
	.byte #%00110110
	.byte #%00011100
	.byte #%00001000
	.byte #%00010000

	org $FFFC
	.word Start
	.word Start

