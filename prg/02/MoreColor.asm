  processor    6502
  org    $1000

loop:   
    lda #$04
    /*Background color (only bits #0-#3).*/
    sta $d021
    lda #$03
    # Border color (only bits #0-#3).
    sta $d020
    lda #$06
    # Change border again
    sta $d020
    jmp loop    
