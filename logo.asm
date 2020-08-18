; Jet-Pac  :  NuLA refuel
;  Mockup start-up logo

{
    LDA #22
    JSR &FFEE
    LDA #2
    JSR &FFEE

    LDA #LO(LOGO)
    STA &70
    LDA #HI(LOGO)
    STA &71
    LDY #127 ; bottom line first

.DAVELOOP:
    TYA
    PHA

.INNERLINELOOP:
    JSR DRAWLINE
    DEY
    CPY #0
    BNE INNERLINELOOP
    PLA
    TAY
    LDA &70
    CLC
    ADC #64
    STA &70
    BCC SKIPA
    INC &71

.SKIPA:
    DEY
    CPY #(127-32)
    BNE DAVELOOP

.END:
    RTS

    ; &70/&71 -> start of line of data
    ; Y -> scanline number
.DRAWLINE:
    PHA
    TYA
    PHA
    TXA
    PHA
    TYA
    ASL A
    TAX
    LDA TABLE,X
    STA STORE+1
    LDA TABLE+1,X
    STA STORE+2
    LDY #0

.LINELOOP:
    LDA (&70),Y

.STORE:
    STA &1900
    LDA STORE+1
    CLC
    ADC #8
    STA STORE+1
    BCC SKIPB
    INC STORE+2

.SKIPB:
    INY
    CPY #64
    BNE LINELOOP
    PLA
    TAX
    PLA
    TAY
    PLA
    RTS

.LOGO:
    INCBIN "bin/logo.bin"

.TABLE:
    FOR I,0,255
      EQUW (&3000 + ((I DIV 8) * &280) + (I MOD 8)) + 8 * 8
    NEXT
}
