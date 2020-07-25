; Placeholder assembly file
; 14 July 2020

ORG $900
GUARD &A00

.START:
    ;LDA #22
    ;JSR &FFEE
    ;LDA #2
    ;JSR &FFEE
    LDX #0

    ; Program video NuLA
.PROGRAM_PAL:
    LDA PAL,X

    ; first write -  colour index | red
    STA &FE23
    INX
    LDA PAL,X

    ; second write - green | blue
    STA &FE23
    INX
    CPX #30
    BNE PROGRAM_PAL

.LOAD_GAME:
    LDX #LO(LOADER)
    LDY #HI(LOADER)
    JSR &FFF7

    ; Patch the game to use standard keys
.PATCH_GAME:

.RUN_GAME:
    JMP &5900

.PAL:
    INCBIN "bin/pal.bin"

.LOADER:
    EQUS "LOAD JET-PAC",13

.END:
    PRINT "Bytes used: ",END-START
    PUTFILE "org/jet-ldr","jet-ldr",&1900,&8023
    PUTFILE "org/jetpac","jetpac",&5C00,&6000
    PUTFILE "org/jet-pac","jet-pac",&2000,&5900
    PUTFILE "bin/fuelscr.bin","fuel",&3000,&3000
    SAVE "test",START,END
