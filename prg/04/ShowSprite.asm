    processor    6502
    org    $1000
	

 lda #$80
 sta $07f8

 #-----------------------
 #- Sprite Enablers $d015
 #-----------------------
 # here we set it to 1 which means sprite 1 is enabled
 lda #%$00000001
 lda #$01
 sta $d015
 
 #-------------------------
 #- Sprite positioning x,y
 #------------------------- 
 ldx #$01
 stx $d000
 stx $d001


loop:
 jmp loop

 org $2000
 INCBIN "sprite1.prg"