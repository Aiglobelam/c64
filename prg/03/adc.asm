  processor    6502
  org    $1000

loop:   
    lda #$00
    #$d020 = Border color (only bits #0-#3).
    sta $d020
    /*CLC Set carry (C-flag) bit in status register to 0*/
    CLC
    adc #$08
    sta $d021
    jmp loop