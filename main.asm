; Placeholder assembly file
; 14 July 2020
;
; .. Eventually some NuLA setup code will need calling from Jet-Pac, perhaps store at &380

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
    ; Not sure why it does this as yet
    LDA #&EA
    STA &3378
    STA &3379
    STA &337A
    STA &337D
    STA &337E
    STA &337F

    ;Stop aliens spawning
    ;LDA #&60
    ;STA &4466

    ; Test alien Y pos clamping
    LDA #&90
    STA &447e

    ; Give us 99 lives, for player 1 and player 2
    LDA #&99
    STA &307B
    STA &308C

    ; Patch title
    LDX #0

.TITLE_LOOP:
    LDA TITLESTR,X
    BEQ RUN_GAME
    STA &287C,X
    INX
    JMP TITLE_LOOP

    ; And go
.RUN_GAME:
    JMP &5900

.PAL:
    INCBIN "bin/pal.bin"

.LOADER:
    EQUS "LOAD JET-PAC",13

.DEBUGSTR:
    EQUS "SCAN..",13,10,0

.TITLESTR:
    ;EQUS "......JET-PAC Selection Page"
    EQUS "      JET-PAC : NuLA Refuel "
    EQUB 0

.END:
    PRINT "Bytes used: ",END-START
    PUTFILE "org/jet-ldr","jet-ldr",&1900,&8023
    PUTFILE "org/jetpac","jetpac",&5C00,&6000
    PUTFILE "org/jet-pac","jet-pac",&2000,&5900
    SAVE "test",START,END
