# Diffrent ways of starting an assembly program that I know of

## Basic Loader technique from kickass
- Assembler: Kickassembler
- Macro: BasicUpstart2
### Example program
This program uses Kickass macro called "BasicUpstart2", you send it a label as input paraam
```
BasicUpstart2(start)
        * = $4000
start:  lda #48
        jsr $ffd2
```
- compile

## Basic Loader technique 2

*=$0801 ; 10 SYS (2064)

        byte $0E, $08, $0A, $00, $9E, $20, $28, $32
        byte $30, $36, $34, $29, $00, $00, $00
        ; Basic prgs start at MEM location dec:2048 hex:0800
        ; Our code starts at  MEM location dec:2064 hex:0810
        ; after the 15 bytes for the BASIC loader
        ; Memory position 0801 is the normal start of Basic location aka SOB.
        ; Where SOB is, is set at mem location 002B and 002C, like this.
        ; $002B: $01 (Low Byte First). So the first line in our program is
        ; => byte $0E, $08, $0A, $00, $9E, $20, $28, $32
        ; first 2 bytes tells us where the next basic instruction line is located in
        ; memory, in our case it is 080E. Our first instruction is
        ; 10 SYS (2064) => Which is a basic command for running what is at mem
        ; position 2064 => 0810.
        ; $002C: $08
        ; 0801 1  $0E => Normal location of SOB Start Of Basic
        ; 0802 2  $08 => *** 080E next line of basic code starts at 0x080E
        ; 0803 3  $0A 
        ; 0804 4  $00 => 000A A=10 dec
        ; 0805 5  $9E => Basic token for SYS
        ; 0806 6  $20 space char
        ; 0807 7  $28 ( char
        ; 0808 8  $32 2 char
        ; 0809 9  $30 0 char
        ; 080A 10 $36 6 char
        ; 080B 11 $34 4 char
        ; 080C 12 $29 ) char
        ; 080D 13 $00 => Basic end of line
        ; 080E 14 $00 => ***
        ; 080F 15 $00 => double 00 means Basic end of program
        ;                BASIC program has now ended
        ;                Before end BASIC prg invoked SYS 2064
        ;                2064 in binary:
        ;                0000 1000 0001 0000
        ;                0    8    1    0
        ;                0+ 2048+ 16+   0 = 2064 => 0810
        ;                0810 is where the cpu should read its next instruction.
        ;
        ; 0810 ... When compiled next instruction is "sei" below
        ; 0811 ... 