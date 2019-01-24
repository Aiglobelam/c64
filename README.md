# c64
My C64 projects


# VICE
* OSX: use sdl version

## Load turbo assembler
* Version [Turbo Assembler 7.1](https://csdb.dk/search/?seinsel=all&search=turbo+assembler) by [Megastyle](https://csdb.dk/group/?id=473)
* In Vice menu, FILE, Attatch disk image, unit 8

## Load program from a disk
```
READY.
```
Where is program?. Load and list contents of disk.
```
LOAD "$",8

SEARCHING FOR $
LOADING
READY.
```
Issue list command
```
LIST
```
Now we can do `LOAD "TURBOASS V7.1",8,1"` OR `LOAD"*",8,1`
```
SEARCHIN FOR TURBOASS V7.1
LOADING
READY.
```
I do not know why but, run does'nt start the program, we have to use
```
SYS 36864
```
