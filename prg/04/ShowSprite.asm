    processor    6502
    org    $1000
	
 # Screen mem $0400 - $0800
 # Sprite POINTERS 8 last bytes of screen mem
 # (0)$07f8 (1)$07f9 (2)$07fa (3)$07fb (4)$07fc (5)$07fd (6)$07fe (7)$07ff
 # Render Sprite Steps:
 #	A) Pointer to data
 #     Calculated like (Sprite Size) * (#nbr in pointer) = location in mem
 #                               $40 * #nbr              = m
 #	B) Position
 #	C) Enable
 
 # A) Pointer to data
 #    Where are our sprite located? AT $2000 according to INCBIN and org command
 #    (Sprite Size) * (#nbr in pointer) = location in mem
 #    $40           * ???               = $2000
 #    0100 0000     * ???               = 0010 0000
 lda #$80 
 sta $07f8
 lda #$01
 sta $d015
 lda #$80
 sta $d000
 sta $d001

loop:
 jmp loop

 org $2000
 INCBIN "sprite1.prg"