# How to start a c64 progrm
For me known ways of starting an assembly program...

## Basic Loader technique - 1
- Assembler: Kickassembler
- Macro: BasicUpstart2

### Example program
This program uses Kickass macro called "BasicUpstart2", you send it a label as input param
* File: `myCode.asm`: *Will make screen crazy =), progrm loops for ever.*

```
       BasicUpstart2(start)
               * = $4000
       start:  inc $d021
               jmp start
```
-  `BasicUpstart2(start)`: *Magic macro that somehow start our code...*
-  `* = $4000`: *Way to tell kickass where our code should start in memory*
- `inc`: *opcode for increase numeric value at specified mem address (inc value at $d021)*
- `$d021`: *Memory location for Background color (only bits #0-#3)*
- `jmp`: *Transfer program execution to this place, here we use a label instead of address...*

### Build program
Command: `java -jar ~/dev/c64/compilers/KickAssembler/KickAss.jar -bytedump myCode.asm`
- option: `-bytedump`: *Dumps the assembled bytes in the file ByteDump.txt together with the code that generated them.*

```
       //------------------------------------------------------
       //------------------------------------------------------
       //          Kick Assembler v5.7 by Mads Nielsen
       //------------------------------------------------------
       //------------------------------------------------------
       parsing
       flex pass 1
       flex pass 2
       flex pass 3
       Output pass
       Writing prg file: myCode.prg

       Memory Map
       ----------
       Default-segment:
         $0801-$080d Basic
         $080e-$080d Basic End
         $4000-$4005 Unnamed
```

### Files
* File: `myCode.sym`
```
       .label start=$4000
```

* File: `ByteDump.txt`
```
       ******************************* Segment: Default *******************************
       [Basic]
       0801: 0c 08     -
       0803: 0a 00     -
       0805: 9e        -
       0806: 31 36 33 38 34                                   -
       080b: 00        -
       080c: 00 00     - upstartEnd:

       [Unnamed]
       4000: ee 21 d0  - start:  inc $d021
       4003: 4c 00 40  -         jmp start
```

* File: `myCode.prg`
Command: `hexdump myCode.prg`
```
       0000000 01 08 0c 08 0a 00 9e 31 36 33 38 34 00 00 00 00
       0000010 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
       *
       0003800 00 ee 21 d0 4c 00 40
       0003807
```

### Explination
In a commodore C64, address locations `$002B` and `$002C` ("zero pages": $2B and $2C)

Contains the addres for where BASIC is stored in memory => SOB, (**S**)tart (**O**)f (**B**)asic
```
       $002B: $01 (Low Byte First)
       $002C: $08
```
Result: `$0801`, From this address, if you write a Basic program, it will take up memory in between SOB to EOB (End of...).

* File: `ByteDump.txt` - revisit...

`0801: 0c 08`: As we see in the build output for example file `ByteDump.txt`: mem location `0801` contains: `0c 08` which tells Basic at which mem address the next Basic instruction start (*common knowledge nudge nudge*). And if we look at adress `080c` we see the values `00 00` which indicates end of Basic program (*more common knowledge...*). But what lies in between those rows?

`0803: 0a 00`: So what is this... google "C64 address 000a" gives us something about `LOAD/VERIFY switch. Values:` hmmm wtf??? can't be that? It might be an opcode!? Ok more googling... `00` is **BRK** `0a` is **ASL** hmmm this does not make sense!? Can we think in another way... **epiphany**!!!! Lets pretend we are BASIC, what does the first line of a Basic program starts with? Thats right it starts with a "line number". So `000a` <=> 10 in decimal, which means 10 is our first line number!!!

`0805: $9E` Ok here we need more knowledge about [Basic tokens](https://www.c64-wiki.com/wiki/BASIC_token). In a Basic progrm whenever the user edits or creates a BASIC line, any keywords are replaced by their respective token, and conversely. In this case `9E` is the Basic [SYS](https://www.c64-wiki.com/wiki/SYS) command. So so far our Basic prg line looks like `10 SYS`

`0806: 31 36 33 38 34`: To be continued...


## Basic Loader technique - 2

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
