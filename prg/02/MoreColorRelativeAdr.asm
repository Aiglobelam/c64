  processor    6502
  org    $1000

loop:   
    ldx #$20
    lda #$03
    # Here we use relative addressing mode
    # Store A at $d000 + x <=> $d000 + $0020 <=> $d020
    sta $d000,X
    sta $d001,X
    jmp loop