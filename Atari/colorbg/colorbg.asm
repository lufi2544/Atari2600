
	processor 6502

	include "vcs.h"
	include "macro.h"

	seg Code
	.org $F000			; Defines the origin of the ROM at $F000

START: 
	CLEAN_START			; Macro to safely clear the memory

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Set the background luminosity color to yellow
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
OUTPUT_COLOR:
	lda #$2E			; Load color into A ($2E in NTSC yellow), we are using the PAL television signal for simplicity
	sta COLUBK			; store A to Background color address $09

	jmp OUTPUT_COLOR	; Loop outputing color to the screen



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  Fill the ROM with exactly 4KB
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	.org $FFFC			; Defines the end of the ROM at $FFFC
	.word START			; Memory mapped to the Reset instruction
	.word START			; Memory mapped to the Interrupt instruction(not used)
