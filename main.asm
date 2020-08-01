; Placeholder assembly file
; 14 July 2020

ORG $900
GUARD &A00

.START:
    JMP LOAD_GAME
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

    ; Patch the game to use A/S keys
.PATCH_GAME:
    LDA #&AE
    STA &3F08
    STA &3F0A
    LDA #&BE
    STA &3EFC
    STA &3EFE

    ; Disable the palette reshuffle...
    ; Not sure why it does this
    LDA #&EA
    STA &3378
    STA &3379
    STA &337A
    STA &337D
    STA &337E
    STA &337F

    ; Give us 9 lives
    LDA #&09
    STA &307B

.RUN_GAME:
    JMP &5900

.TEST_KEYS:
    LDA #22
    JSR &FFEE
    LDA #2
    JSR &FFEE

.PRINT:
    LDX #0

.KEY_LOOP:
    LDA DEBUGSTR,X
    BEQ SCAN
    JSR &FFEE
    INX
    JMP KEY_LOOP

.SCAN:
    LDA #&81
    LDX #&BF
    LDY #&BF
    JSR &FFF4
    JMP PRINT

.PAL:
    INCBIN "bin/pal.bin"

.LOADER:
    EQUS "LOAD JET-PAC",13

.DEBUGSTR:
    EQUS "SCAN..",13,10,0

.END:
    PRINT "Bytes used: ",END-START
    PUTFILE "org/jet-ldr","jet-ldr",&1900,&8023
    PUTFILE "org/jetpac","jetpac",&5C00,&6000
    PUTFILE "org/jet-pac","jet-pac",&2000,&5900
    SAVE "test",START,END
