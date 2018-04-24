;*********************************
; .FIL DIRECTIVE FILE NAME BUFFER
;*********************************
FVERON .BYTE $AA
FCHARS .BYTE $AA
FILBUF = *
 .BYTE $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
 .BYTE $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
 .BYTE $AA,$AA,$AA,$AA
;
FILBAS = *
 .BYTE $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
 .BYTE $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
 .BYTE $AA,$AA,$AA,$AA;
FILEXT = *
 .BYTE $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA

FILDIR .TEXT '.FIL ',$00
LIBDIR .TEXT '.LIB ',$00
;*********************************
; PARSE FILENAME
;*********************************
PARFIL = *
 LDX #$00
PLOOP = *
 LDA NBUF,X
 CMP #'.'
 BEQ PLOOQ
 STA FILBAS,X
 INX
 BNE PLOOP
PLOOQ = *
 INX
 LDA NBUF,X
 STA FILEXT,X 
 INX
;*********************************
; OUTPUT:
;
; COMMENT LINE
; .FIL FILENAME OF NEXT VERSION
; COMMENT LINE
;
;*********************************
OUTFIL = *
;*********************************
; INCREMENET FILE VERSON PETASCII
; $30,$31,$32 ETC
;*********************************
 LDA VERSON
 STA FVERON
;*********************************
; COPY NUMBER CHARACTERS IN FILENAME
;*********************************
 LDA NCHARS
 STA FCHARS
;*********************************
; COPY FILE NAME TO FILBUF
;*********************************
 LDX #$00
FLOOP = *
 LDA NBUF,X
 CMP #','
 BEQ FLOOQ
 STA FILBUF,X
 INX
 BNE FLOOP
;
FLOOQ = *
 LDA FVERON
 CMP #'1'
 BEQ FLOOW
 DEX
;
FLOOW = *
 LDA FVERON
 STA FILBUF,X
 INX
 LDA #$00
 STA FILBUF,X
;*********************************
; OUTPUT COMMENT LINE
;*********************************
 JSR NEWLIN   ;PRINT BYTE
 JSR COMET    ;COMENT LINE
 JSR NEWLIN   ;PRINT BYTE
;*********************************
; OUTPUT .FIL DIRECTIVE
;*********************************
 JSR PRTOTH   ;PRINT LINE DATA
 LDA #<FILDIR ;.FIL
 LDY #>FILDIR ;
 JSR STRPNT
 LDA #<FILBUF
 LDY #>FILBUF
 JSR STRPNT
;*********************************
; OUTPUT COMMENT LINE
;*********************************
 JSR NEWLIN   ;PRINT BYTE
 JSR COMET    ;COMENT LINE
;*********************************
; FINAL NEWLINE
;*********************************
 JSR NEWLIN
 RTS
