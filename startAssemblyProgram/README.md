# How to start a c64 progrm
For me known ways of starting an assembly program...

## Basic Loader technique - 1
- Assembler: Kickassembler
- Macro: BasicUpstart2

### Example program
This program uses Kickass macro called "BasicUpstart2", you send it a label as input param
* File: `myCode.asm`: *Will make screen crazy =), program loops for ever.*
<img src="https://github.com/Aiglobelam/c64/blob/master/startAssemblyProgram/incd021.png" width="480px"/>

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
Note to self and other, whats up with the `3800` in the hex dump of `myCode.prg`? Should it not be `4000`? Well if I load the program into Vice and use its **mlm** Machine Language Monitor and inspect the memory by typing `m 4000` I can see the program `ee 21 d0 4c 00 40` there so that seems correct aany how... And space `3800` is empty...

### SOB - Start Of Basic
In a commodore C64, address locations `$002B` and `$002C` ("zero pages": `$2B` and `$2C`)

Contain address for where the BASIC program is stored in memory => SOB, (**S**)tart (**O**)f (**B**)asic
```
       $002B: $01 (remember instruciton are stored as Low Byte First)
       $002C: $08
```
Result: `$0801`, From this address, if you write a Basic program, it will take up memory in between SOB to EOB (End of...).

### File: `ByteDump.txt` - revisit

#### `0801: 0c 08`
As we see in the build output, file `ByteDump.txt`: mem location `0801` is set to contain: `0c 08`. The first two bytes tell Basic at which mem address the next Basic instruction start (*common knowledge nudge nudge*). And if we look at adress `080c` we see the values `00 00` which indicates end of Basic program (*more common knowledge...*). But what lies in between those rows? Next is location `0803` becuase this `0801` took up 2 bytes, 1 byte for `0c` and one byte for `08`. 

#### `0803: 0a 00`
So what is this `0a 00`? Google "C64 000a" gives us something about `LOAD/VERIFY switch. Values:` hmmm wtf??? can't be that? It might be an opcode!? Ok more googling... `00` is **BRK** `0a` is **ASL** hmmm this does not make sense!? Can we think in another way... **epiphany**!!!! Lets pretend we are BASIC, what does the first line of a Basic program starts with? Thats right it starts with a "line number". So `000a` <=> 10 in decimal, which means 10 is our first line number!!! So our Basic program now looks like `10`. Next byte read should be at `0805` cause `0a 00` made used of 2 bytes.

#### `0805: $9E`
Ok here we need more knowledge about [Basic tokens](https://www.c64-wiki.com/wiki/BASIC_token). In a Basic progrm whenever the user edits or creates a BASIC line, any keywords are replaced by their respective token, and conversely. In this case `9E` is the Basic [SYS](https://www.c64-wiki.com/wiki/SYS) command. So so far our Basic prg line looks like `10 SYS`. Next byte to read should be at `0806` cause we used 1 byte for `9e` for `0805`

#### `0806: 31 36 33 38 34`
So, these numbers `31 36 33 38 34` they seem not to be specific Basic commands. So they must be ordinary "chars", that is the value represents a char in the C64 PETSCII table... and in this case they all seem to be integers `$31`=1, `$36`=6, `$33`=3, `$38`=8, `$34`=4 which is equivalent to the decimal number **16384**. Converted to hex it will be `$4000`. so far our Basic prg line looks like `10 SYS4000` (notice missing space between `SYS` and address `4000`, i guess a missing space is ok there. Remember what we told Kickassembler in `myCode.asm`? That our code should start at `$4000` => `* = $4000`. So here we used 5 bytes. Next code shoule be at `080B`. 

**PS 1**: *Note that these numbers  `31 36 33 38 34` can be other figures, depending on where your assembly program start in memory*

**PS 2**: hex `$31`=1, `$31`=2, `$33`=3, `$34`=4`$35`=5, `$36`=6, `$37`=7, `$38`=8, `$39`=9

#### `080B: 00`
A `00` tells Basic we have reached the end of line of the current instruction. So `10 SYS4000` end of line. After EOL Basic now moves on to the next instruction which according to our instructions at `0801` is located at `080C`

#### `080c: 00 00`
Here Basic reads 2 * `00` which indicates the end of the Basic program. Now Basic exexutes the program first row `10 SYS4000`. SYS executes the assembly code at location `4000`

#### `4000: ee 21 d0`
Opcode `ee` is **INC** *Increment absolute* that is `inc $...` Where the address `...` is what to increment by 1. In our case `...` is address `d021` which is the address in memory where we have the screen background color. Where bit #0-#3 represent the color, that is the 4 bits marked with `x` are used `... xxxx `. *With 4 bits we can represent 16 colors.* 

#### `4003: 4c 00 40`
Next instruction is opcode **jmp** *absolute* `4c` and the address we should jump to is `4000` and then that code executes again, and the we come back to `4003` inc background color, jmp to `4000` unt so witer =)
