
	processor 6502

	org $F000
	seg Code

	include "vcs.h"
	include "macro.h"


Start: 
	CLEAN_START				; Clears the stack, mapped TIA registers, zero page memory region.
	
	lda #$80				; blue color
	sta COLUBK				; setting the color to the TIA background register
	
	lda #$40
	sta COLUP0				; Setting the color for the player 0
	
	lda #$1F				; Setting the color for the player 1
	sta COLUP1

FrameStart:
	lda #%00000010			; bit 2 in A register
	sta VSYNC				; turn on VSYNC
	sta VBLANK				; turn on VBLANK

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; VSYNC scanlines
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	REPEAT 3
		sta WSYNC
	REPEND

	lda #%00000000
	sta VSYNC


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; VBLANK scanlines
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	REPEAT 37
		sta WSYNC
	REPEND

	lda #%00000000
	sta VBLANK

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; VISIBLE scanlines - 192
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


VisibleScanlines:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Draw 10 blank scanlines
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	REPEAT 10
		sta WSYNC
	REPEND

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Displays 10 scanlines for the scoreboard number
;; Pulls data from an array of bytes defined at NUmberBitMap
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	ldy #0
	lda #$0F				
	sta COLUPF				; Setting the color for the PF, in this case for the scoreboard

ScoreboardLoop:
	lda NumberBitmap,Y
	sta PF1
	sta WSYNC
	iny
	cpy #10
	bne ScoreboardLoop

	lda #0
	sta PF1					; Disable playfield

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Draw 50 empty scanlines between scoreboard and player
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	REPEAT 50
		sta WSYNC	
	REPEND	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Display 10 scanlies for the Player 0 graphics.
;; Pulls data from an array of bytes defined PlayerBitmap
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	ldy #0
Player0Loop:
	lda PlayerBitmap,Y
	sta GRP0 
	sta WSYNC
	iny
	cpy #10
	bne Player0Loop

	lda #0
	sta GRP0				; Disable the player 0 graphics
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Display 10 scanlies for the Player 0 graphics.
;; Pulls data from an array of bytes defined PlayerBitmap
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ldy #0
Player1Loop:
	lda PlayerBitmap,Y
	sta GRP1
	sta WSYNC
	iny
	cpy #10
	bne Player1Loop

	lda #0
	sta GRP1				; Disable player 1 graphics
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Drawing the remaining 102 scanlienes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	REPEAT 102
		sta WSYNC
	REPEND

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Loop to the next frame
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	jmp FrameStart

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	org $FFE8
PlayerBitmap:				; 10 bytes
	.byte #%01111110		;  ######
	.byte #%11111111		; ######## 
	.byte #%10011001		; #  ##  #
	.byte #%11111111		; ########
	.byte #%11111111		; ########
	.byte #%11111111		; ########
	.byte #%10111101		; # #### #
	.byte #%11000011		; ##    ##
	.byte #%11111111		; ########	
	.byte #%01111110		;  ###### 

	org $FFF2				
NumberBitmap:				; 10 bytes
	.byte #%00001110		; ########
	.byte #%00001110		; ########
	.byte #%00000010		;      ###
	.byte #%00000010		; 	   ###
	.byte #%00001110		; ########
	.byte #%00001110		; ########
	.byte #%00001000		; ###
	.byte #%00001000		; ###
	.byte #%00001110		; ########
	.byte #%00001110		; ########

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Complete ROM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	org $FFFC				; Finishing the cartradge wit 16 bits expected for the reset buttom and the unsed Interrupt memory address;
	.word Start
	.word Start





