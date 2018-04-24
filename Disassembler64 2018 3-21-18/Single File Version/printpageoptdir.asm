.PAGE 'DISASSEMBLER64'
.OPT LIST


;*********************************
; OUTPUT .OPT LIST DIRECTIVE
;*********************************
MSGPGE .TEXT '.PAGE ',$00
;*********************************
; OUTPUT .OPT LIST DIRECTIVE
;*********************************
OPTPAG = *
;*********************************
; OUTPUT COMMENT LINE
;*********************************
 JSR NEWLIN   ;PRINT BYTE
 JSR COMET    ;COMENT LINE
 JSR NEWLIN   ;PRINT BYTE
;*********************************
; OUTPUT .PAGE DIRECTIVE
;*********************************
 JSR PRTOTH   ;PRINT LINE DATA
 LDA #<MSGPGE ;.PAGE
 LDY #>MSGPGE ;
 JSR STRPNT
 LDA #"'"
 JSR PCHAR
;
 LDA #<BUFPFL ;FILE NAME
 LDY #>BUFPFL ;
 JSR STRPNT
;
 LDA #"'"
 JSR PCHAR

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




;*********************************
; SAVE A COPY OF PROGRAM FILE NAME
;*********************************
NUMPFL = $AA
BUFPFL = *
 .BYTE $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
 .BYTE $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
 .BYTE $AA,$AA,$AA,$AA
;*********************************
;SAVE A COPY OF PROGRAM FILE NAME
;*********************************
PFILEH = *
 STY NUMPIL
 LDX #$00
PFILEI = *
 LDA BUF,X
 STA BUFPFL,X
 INX
 CPX NUMPIL
 BNE PFILEI
 LDA #$00
 STA BUFPFL,X
 RTS
 

;*********************************
; OUTPUT .OPT LIST DIRECTIVE
;*********************************
MSGOPT .TEXT '.OPT LIST',$00
;*********************************
; OUTPUT .OPT LIST DIRECTIVE
;*********************************
OPTDIR = *
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
 LDA #<MSGOPT ;.FIL
 LDY #>MSGOPT ;
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