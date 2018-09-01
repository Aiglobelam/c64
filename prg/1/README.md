# Program
Makes colors go crazy on screen.
Based on tutorial https://digitalerr0r.wordpress.com/2011/03/19/commodore-64-programming-a-quick-start-guide-to-c-64-assembly-programming-on-windows/

## CODE
```
  processor    6502
  org    $1000

loop:
    inc $d021
    jmp loop
```

## Build
* Built with dasm-2
* Build command: `dasm Colors.asm -oColors.prg`

## Emulator
* Load in vice...
* Type `sys 4096` to start program (4096 ==> hex $1000) and that is where we asked dasm to put program in memory.

Check code in memory using a Machine Language Monitor, 
### show memory `m 1000`
`C:1000  ee 21 d0 4c  00 10 00 00  00 00 00 00  00 00 00 0`

### dissademble `d 1000`
```
.C:1000  EE 21 D0    INC $D021
.C:1003  4C 00 10    JMP $1000
.C:1006  00          BRK
```

