    processor    6502
    org    $1000
	
 # Screen mem $0400 - $0800
 # Sprite POINTERS 8 last bytes of screen mem
 # 1) $07f8 
 # 2) $07f9 
 # 3) $07fa 
 # 4) $07fb 
 # 5) $07fc 
 # 6) $07fd 
 # 7) $07fe 
 # 8) $07ff
 # Render Sprite Steps:
 #	A) Pointer to data
 #     Calculated like (Sprite Size) * (#nbr in pointer) = location in mem
 #                               $40 * #nbr              = m
 #	B) Position
 #	C) Enable
 
 # A) Pointer to data
 #    Where are our sprite located? 
 #    AT $2000 according to INCBIN and org command
 #    (Sprite Size) * (#nbr in pointer) = location in mem
 #    $40           * ???               = $2000
 #    0100 0000     * ???               = 00100000 00000000
 lda #$80
 # User sprite 1
 sta $07f8
 # $01 = 0000.0001 = 1
 lda #$01
 # $d015 Sprite enabler register, 
 # here we set it to 1 which means sprite 1 is enabled
 sta $d015
 lda #$80
 sta $d000
 sta $d001

loop:
 jmp loop

 # Where to store sprite data in mem
 org $2000
 INCBIN "sprite1.prg"