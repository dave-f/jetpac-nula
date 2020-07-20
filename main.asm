; Placeholder assembly file
; 14 July 2020

ORG $900
GUARD &A00

.START:
    LDA #22
    JSR &FFEE
    LDA #2
    JSR &FFEE
    LDX #0

    ; Program video NuLA at 0xfe23
    ; first write -  colour index | red
    ; second write - green        | blue

.PROGRAM_PAL:
    LDA PAL,X
    STA &FE23
    INX
    LDA PAL,X
    STA &FE23
    INX
    CPX #32
    BNE PROGRAM_PAL
    RTS

.PAL:
    INCBIN "bin/pal.bin"

.END:
    PRINT "Bytes used: ",END-START
    PUTFILE "org/jet-ldr","jet-ldr",&1900,&8023
    PUTFILE "org/jetpac","jetpac",&5C00,&6000
    PUTFILE "org/jet-pac","jet-pac",&2000,&5900
    PUTFILE "player1.bin", "player1",&3000,&3000
    PUTFILE "player2.bin", "player2",&3280,&3280
    SAVE "test",START,END
