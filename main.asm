; Placeholder assembly file
; 14 July 2020
;
; .. Eventually some NuLA setup code will need calling from Jet-Pac
; .. Perhaps store at &100.

ORG &1900
GUARD &2000

; Both these are still wrong as they are overwritten
RESIDENT_MEM = &100
REAL_RESIDENT_MEM = &100

.START:
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
    ; These may have to be > 8 for the aliens to collide?
    LDA #&1
    STA &33ab
    LDA #&3f
    STA &33b0
    LDA #&2
    STA &33bb

    ; 17 bytes available at &2EE-&2FF, OSFILE blocks
    LDX #0

.COPY_RESIDENT:
    LDA #&EA
    STA &2EE,X
    INX
    CPX #18
    BNE COPY_RESIDENT

    ;LDA START_RESIDENT,X
    ;STA RESIDENT_MEM,X
    ;INX
    ;CPX #END_RESIDENT-START_RESIDENT
    ;BNE COPY_RESIDENT

    ; Patch game to call into the disable/enable nula code

    ;LDA #&4C
    ;STA &2EA5
    ;LDA #LO(REAL_RESIDENT_MEM + (DISABLE_NULA - START_RESIDENT))
    ;STA &2EA6
    ;LDA #HI(REAL_RESIDENT_MEM + (DISABLE_NULA - START_RESIDENT))
    ;STA &2EA7

    ;LDA #&20
    ;STA &38EE
    ;LDA #LO(RESIDENT_MEM + (ENABLE_NULA - START_RESIDENT))
    ;STA &38EF
    ;LDA #HI(RESIDENT_MEM + (ENABLE_NULA - START_RESIDENT))
    ;STA &38F0
    ;LDA #&EA
    ;STA &38F1
    ;STA &38F2
    ;STA &38F3
    ;STA &38F4
    ;STA &38F5
    ;STA &38F6
    ;STA &38F7

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

.START_RESIDENT:
    PHA
    LDA #&0A
    STA &FE00
    LDA #&20
    STA &FE01
    PLA
    BNE ENABLE_NULA
    LDA #&40
    STA &FE22
    RTS

.ENABLE_NULA:
    LDX #0

.PROGRAM_PAL:
    LDA RESIDENT_MEM+(PAL-START_RESIDENT),X

    ; first write -  colour index | red
    STA &FE23
    INX
    LDA PAL,X

    ; second write - green | blue
    STA &FE23
    INX
    CPX #30
    BNE PROGRAM_PAL

.END_RESIDENT:
    RTS

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
    PRINT "Bytes used for resident code: ", END_RESIDENT-START_RESIDENT
    PUTFILE "org/jet-ldr","jet-ldr",&1900,&8023
    PUTFILE "org/jetpac","jetpac",&5C00,&6000
    PUTFILE "org/jet-pac","jet-pac",&2000,&5900
    SAVE "test",START,END
