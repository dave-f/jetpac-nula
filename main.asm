; Placeholder assembly file
; 14 July 2020
;
; .. Eventually some NuLA setup code will need calling from Jet-Pac
; .. Perhaps store at &100.

ORG &1900
GUARD &2000

LOAD_ADDRESS = &2000
PALETTE_ADDRESS = &100 ; Palette stored at bottom of stack
ENABLE_NULA_ADDRESS = &2EA ; Enable function at OSFILE control block workspace
DISABLE_NULA_ADDRESS = &100+&20 ; Disable function after the palette
STACK_TOP = &12F
STACK_DATA = LOAD_ADDRESS + &2900

; TODO - Read values passed in from BASIC loader

.START:
    LDA #0
    LDX #0
    CLC
    SED

.BCDLOOP:
    ADC #1
    INX
    CPX #42
    BNE BCDLOOP
    CLD
    STA &70

.LOAD_GAME:
    LDX #LO(LOADER)
    LDY #HI(LOADER)
    JSR &FFF7

    ; Patch the game to use A/S keys
.PATCH_GAME:
    LDA #&AE
    STA &3F08
    STA &3F0A
    STA &3D9D
    LDA #&BE
    STA &3EFC
    STA &3EFE
    STA &3DA5

    ; Disable the palette reshuffle...
    ; Not sure why it does this as yet
    LDA #&EA
    STA &3378
    STA &3379
    STA &337A
    STA &337D
    STA &337E
    STA &337F

    ; Stop aliens spawning
    ; LDA #&60
    ; STA &4466

    ; Test alien X/Y pos clamping
    ; LDA #&20
    ; STA &448B
    ; LDA #&90
    ; STA &447e

    ; Give us 99 lives, for player 1 and player 2
    LDA #&99
    STA &307B
    STA &308C

    ; Change text colours on the score display
    LDA #&07
    STA &3283
    STA &3372

    ; These 3 stores define the top and bottom bar colours
    ; These may have to be platform colours for the aliens to collide?
    LDA #&1
    ;STA &33ab
    LDA #&3f
    ;STA &33b0
    LDA #&2
    ;STA &33bb

    ; Patch game to call into the disable/enable nula code
    LDX #0

.COPY_ENABLE_CODE:
    LDA ENABLE_NULA,X
    STA ENABLE_NULA_ADDRESS,X
    INX
    CPX #21+1
    BNE COPY_ENABLE_CODE
    LDX #0

.COPY_PALETTE_DATA:
    LDA PAL,X
    STA STACK_DATA,X
    INX
    CPX #32
    BNE COPY_PALETTE_DATA
    LDX #0

.COPY_DISABLE_CODE:
    LDA DISABLE_NULA,X
    STA STACK_DATA+32,X
    INX
    CPX #(ENABLE_NULA-DISABLE_NULA)+1
    BNE COPY_DISABLE_CODE

    ; Initial game mode
    LDA #LO(DISABLE_NULA_ADDRESS)
    STA &2EA3
    LDA #HI(DISABLE_NULA_ADDRESS)
    STA &2EA4

    ; Enter game; enable NuLA
    LDA #LO(ENABLE_NULA_ADDRESS)
    STA &38FB
    LDA #HI(ENABLE_NULA_ADDRESS)
    STA &38FC

    ; Game Over
    LDA #LO(DISABLE_NULA_ADDRESS)
    STA &3512
    LDA #HI(DISABLE_NULA_ADDRESS)
    STA &3513

    ; Quit Game (Y/N)?
    LDA #LO(DISABLE_NULA_ADDRESS)
    STA &4A44
    LDA #HI(DISABLE_NULA_ADDRESS)
    STA &4A45

    ; Patch title
    LDX #0

.TITLE_LOOP:
    LDA TITLESTR,X
    BEQ RUN_GAME
    STA &287C,X
    INX
    JMP TITLE_LOOP

    ; All set!
.RUN_GAME:
    JMP &5900

.DISABLE_NULA:
    JSR &FFEE
    LDA #&40
    STA &FE22
    RTS

.ENABLE_NULA:
    PHA
    LDX #0

.PROGRAM_PAL:
    LDA &100,X
    STA &FE23
    INX
    CPX #30
    BNE PROGRAM_PAL
    PLA
    JMP &197A

.PAL:
    INCBIN "bin/game.pal"

.LOADER:
    EQUS "LOAD JET-PAC",13

.TITLESTR:
    ;EQUS "......JET-PAC Selection Page"
    EQUS  "      JET-PAC : NuLA Refuel "
    EQUB 0

.END:
    PRINT "Bytes used: ",END-START
    PRINT "Bytes used for enable code: ", PAL-ENABLE_NULA, "Available: ", &2FF-ENABLE_NULA_ADDRESS
    PRINT "Bytes used for disable code: ", ENABLE_NULA-DISABLE_NULA, "Available: ", (STACK_TOP-&100)-32
    PUTFILE "org/jet-ldr","jet-ldr",&1900,&8023
    PUTFILE "org/jetpac","jetpac",&5C00,&6000
    PUTFILE "org/jet-pac","jet-pac",&2000,&5900
    PUTBASIC "loader.bas","loader"
    SAVE "test",START,END
