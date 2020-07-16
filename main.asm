; Placeholder assembly file
; 14 July 2020

ORG $900
GUARD &A00

.START:
    LDA #65
    JSR &FFEE
    RTS

.END:
    PRINT "Bytes used: ",END-START
    PUTFILE "org/jet-ldr","jet-ldr",&1900,&8023
    PUTFILE "org/jetpac","jetpac",&5C00,&6000
    PUTFILE "org/jet-pac","jet-pac",&2000,&5900
    SAVE "test",START,END
