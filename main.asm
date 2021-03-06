; Jet-Pac : NuLA refuel
; 14 July -- 14 August 2020

ORG &900
INCLUDE "logo.asm"
.LOGOEND:
SAVE "JetLogo",&900,LOGOEND
CLEAR &900,LOGOEND

ORG &1900
GUARD &2000

LOAD_ADDRESS = &2000
PALETTE_ADDRESS = &100 ; Palette stored at bottom of stack
ENABLE_NULA_ADDRESS = &2EA ; Enable function at OSFILE control block workspace
DISABLE_NULA_ADDRESS = &100+&20 ; Disable function after the palette
STACK_TOP = &12F
STACK_DATA = LOAD_ADDRESS + &2900
OSBYTE = &FFF4
VECTAB = &FFB7

.START:
    ; Check to see if we are using the NuLA version
    LDA &72
    BEQ LOAD_NORMAL

.LOAD_NULA:
    LDX #LO(LOADER_NULA)
    LDY #HI(LOADER_NULA)
    JMP DO_LOAD

.LOAD_NORMAL:
    LDX #LO(LOADER_NORMAL)
    LDY #HI(LOADER_NORMAL)

.DO_LOAD:
    JSR &FFF7

    ; Now patch the lives
    LDA #0
    TAX
    CLC
    SED

.BCDLOOP:
    ADC #1
    INX
    CPX &70
    BNE BCDLOOP
    CLD
    STA LIVES+1

    ; Check to see if we are remapping keys
    LDA &71
    BEQ OS_PATCH

    ; Patch the game to use A/S keys
    LDA #&AE
    STA &3F08
    STA &3F0A
    STA &3D9D
    LDA #&BE
    STA &3EFC
    STA &3EFE
    STA &3DA5

    ; Patch for OS higher than 1.2 if needed
.OS_PATCH:
    LDA #0
    LDX #1
    JSR OSBYTE 
    CPX #1
    BEQ	FONT
    LDA VECTAB
    STA	&73
    LDA VECTAB+1
    STA &74
    LDY #&0E
    LDA (&73),Y
    STA &3025
    STA &3034
    STA &303A
    INY
    LDA (&73),Y
    STA &302A
    STA &3035
    STA &303B
    LDY #&20
    LDA (&73),Y
    STA &4860
    INY
    LDA (&73),Y
    STA &4865
    LDA &FFB7
    STA &5904
    LDA &FFB8
    STA &5905
    LDY #&A
    LDA (&73),Y
    STA &3D91
    STA &3D9A
    STA &3DB1
    STA &3DCE
    STA &3DE3
    INY
    LDA (&73),Y
    STA &3D92
    STA &3D9B
    STA &3DB2
    STA &3DCF
    STA &3DE4

    ; Change font definition for characters 0-9
.FONT:
    LDA &72
    BEQ LIVES
    CPX #3     ; Use result of OS test above
    BCS MFONT
 
    ; B/B+ - change font page for chars 224-255 
    LDA #3
    STA &36E
    JMP FONTPATCH

    ; Master - copy font to ANDY	
.MFONT:
    SEI
    LDA &FE30
    PHA
    ORA #&80
    STA &FE30
    LDX #0

.MFONTLP:
    LDA &380,X
    STA &8F80,X
    INX
    CPX #80
    BNE MFONTLP
    PLA 
    STA &FE30 	 
    CLI	

    ; Patch game to use chars &F0-&F9 rather than &30-&39  
.FONTPATCH:
    LDA #&F0
    STA &340B 
    STA &3414
    STA &4700
    STA &4708

    ; Give us 99 lives, for player 1 and player 2.
.LIVES:
    LDA #&99
    STA &307B
    STA &308C


    ; Jump straight to game if we are not on NuLA
    LDA &72
    BNE NULA_PATCH
    JMP &5900

.NULA_PATCH:
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

    ; Congratulations, you are .. (high score entry)
    LDA #LO(&1CC2)
    STA &359A
    LDA #HI(&1CC2)
    STA &359B
    LDA #&20
    STA &35C2
    LDA #LO(DISABLE_NULA_ADDRESS+3)
    STA &35C3
    LDA #HI(DISABLE_NULA_ADDRESS+3) ; skip jsr &ffee
    STA &35C4
    LDA #&4C
    STA &35C5
    LDA #LO(&1CCA)
    STA &35C6
    LDA #HI(&1CCA)
    STA &35C7

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

.LOADER_NULA:
    EQUS "LOAD JetNla",13

.LOADER_NORMAL:
    EQUS "LOAD JetPac",13

.TITLESTR:
    ;EQUS "......JET-PAC Selection Page"
    EQUS  "      JET-PAC : NuLA Refuel "
    EQUB 0

.END:
    PRINT "Bytes used: ",END-START
    PRINT "Bytes used for enable code: ", PAL-ENABLE_NULA, "Available: ", &2FF-ENABLE_NULA_ADDRESS
    PRINT "Bytes used for disable code: ", ENABLE_NULA-DISABLE_NULA, "Available: ", (STACK_TOP-&100)-32

    PUTFILE "org/jet-pac","JetPac",&2000,&5900
    PUTFILE "bin/jet-pac-nula","JetNla",&2000,&5900
    PUTFILE "res/font.dat","JetFont",&380,&380
    PUTBASIC "loader.bas","Loader"
    SAVE "JetNula",START,END
