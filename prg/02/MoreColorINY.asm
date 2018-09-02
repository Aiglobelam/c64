  processor    6502
  org    $1000

loop:   
    ldy #$03
    # $d020 = Border color (only bits #0-#3).
    sty $d020
    INY
    sty $d021
    jmp loop
   