
	processor 6502

	seg Code
	org $F000

Start:
	lda #100			; Load the A regis with 100
	ldy #1				; Y = 1
	sty $82				; $82(value for incremenetig the A regis)
	
AddFive:				; Will add five to the A
	ldx #$05			; X = 5
	stx $80				; $80 = X(5) this is the max number of looping times
	ldx #0				; X = 0
	stx $81				; $81 = X(0) this is the counter for the loop until 5
AddFiveLoop:
	clc
	adc	$82				; A++ ($82 = 1)
	inc $81				; $81(counter) ++
	ldx $81				; Load counter data into X regis
	cpx $80				; Compare X(counter value) with $81 (max number of iterations)
	bne AddFiveLoop		; If Zero flag not set by the comparison, then Loop

SubtractTen:
	ldx #$0A			; X = 10
	stx $80				; $80(max loop counter) = 10
	ldx #0				; X = 0
	stx $81				; $81(counter) = 0
SubtractTenLoop:
	sec
	sbc	$82				; A-- ($82 = 1)
	inc $81				; $81(counter) ++
	ldx $81				; X = $81(counter)
	cpx $80				; X == $80( max loop times )
	bne SubtractTenLoop	; If Zero flag is not set, then we loop

	; by this time the A value should be $5F(94)

	org $FFFC
	.word Start
	.word Start



