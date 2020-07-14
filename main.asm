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
    PUTFILE "README.md","README",1900
    SAVE  "DAVE",START,END
