	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; The Atari 6502 has 64kb of RAM as it is a 16-bit machine, with up to 2^16 = 65536 bytes = 64KB 
	; of possible addressed memory. 
	;
	; it also expects our ROM (read only memory) which is going to be our cartridge game, to have 4KB
	; of readable memory. That is why at the end, we fill it with some 2 bytes for the Reset instruction 
	; from the Atari and the interrupt, which is empty.
	; 
	; We start the ROM at $F000( which is 64KB - 4KB), so from that address, until the end of the RAM $FFFF
	; is reserved for the ROM.
	; 
	; the 6502 processor expects at memory address $FFFC the memory address for the reset instruction.
	; this means we have to add a 2 byte number here to indicate the address
	;
	; e.g:
	; 
	; .org $FFFC
	; 
	; .word StartGame - this is a label.
	; .word StartGame - the next 2 bytes are the $FFFE and $FFFF, here the 6502 processor would expect the interrupt 
	; instruction, since the Atari 2600 does not have an interrupt pin, since it works with the 6507 processor.
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	processor 6502

	seg code 
	org $F000 ; start(origin) of the ROM cartridge 
	
Start: ; if you want to jmp to another level in a different memroy location from the current stack frame, we have to create a procedure.
	sei 	  			; Disable interrumpts
	cld		  			; Disable BCD decimal math mode
	ldx #$FF  			; Loads the X register with #$FF
	txs		  			; Transfer the X register to the Stack ptr. As the stack grows from low-up.

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; Clear the Page Zero region ($00 to $FF)	
	; Meaning the entire RAM and also the entire TIA ( graphics adapter ) registers
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	lda #0 	   			; A = 0
	ldx #$FF   			; X = #$FF
	sta $FF				; Storing the value of A, in this case 0, into the value FF before looping

MemLoop:
	dex					; X--	(P Regiser flags set)
	sta $0,X			; store A (= 0) at address 0 + X
	bne MemLoop			; Loop until X==0 (checks if Z (Zero) flag is set by the dex instruction)

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; Fill the ROM size to exactly 4KB
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	org $FFFC
	.word Start			; Reset vector at $FFFC (where the program starts)
	.word Start			; Interrupt vector at $FFFE (unused in the VCS) 
