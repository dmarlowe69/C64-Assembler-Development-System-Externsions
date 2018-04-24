;*********************************; FILE ASC.ASM;*********************************;;        DISASSEMBLER64;    SYMBOLIC DISASSEMBLER;       BY DENTON MARLOWE;;  (C)1986 BY DENTON MARLOWE;;*********************************; DATA TABLE HANDLER;*********************************DATAOP LDA NDATA ;GET NUM TABLES BEQ ENDAX ;IF ZERO EXIT LDA #$00 ;ZERO BYTE STA CDATA ;SET FIRST TABLE BEQ DATAO1 ;ENDAX JMP ENDDAT ;;*********************************DATAO1 LDA CDATA ;CURRENT TABLE CMP NDATA ;LAST TABLE DONE BEQ ENDAX ;IF SO EXIT ASL A ;CDATA*2 ASL A ;CDATA*4 CLC ADC CDATA ;CDATA*5 TAY ;PUT INTO INDEX LDA TDATA,Y ;START LOW STA WORKER ;STORE INY ;INC OFFSET LDA TDATA,Y ;START HIGH STA WORKER+1 ;STORE SEC ;C=1 LDA WORKER ; SBC SELECT ; STA TEMP ; LDA WORKER+1 ; SBC SELECT+1 ; ORA TEMP ; BEQ DATAO2 ;MATCH INC CDATA ;NEXT TABLE BNE DATAO1 ;CHECK FOR MATCH;*********************************; GET TABLE DATA;*********************************DATAO2 INY ;INC OFFSET LDA TDATA,Y ;END LOW STA EAS ;STORE INY ;INC OFFSET LDA TDATA,Y ;END HIGH STA EAS+1 ;STORE INY ;INC OFFSET LDA TDATA,Y ;DATA TYPE STA TEXTER ;STORE CMP #'S'       ;IS IT SKIPPER BNE ASCCCC ;;*********************************; SKIP RANGE OF ADDRESSES;********************************* LDA PASS CMP CPASS BNE ASCCCC LDA EAS STA SELECT LDA EAS+1 STA SELECT+1 JSR INCSL JSR ORGIN JSR DECSL JSR COMENT JMP DATUT;*********************************; CHECK PASS;*********************************ASCCCC LDA PASS CMP EPASS ;EXTERNAL BNE ASCKKSKIPER LDA EAS STA SELECT LDA EAS+1 STA SELECT+1 JMP DATUT;*********************************; DISASSEMBLER LOOP FOR DATA;*********************************ASCKK LDA PASS ;GET PASS CMP CPASS ;IS IT LAST BNE ASCI1 ;NO PRINT JSR COMENT ;COMMENT LINEASCII LDA PASS ;GET PASS CMP CPASS ;IS IT LAST BNE ASCI1 ;NO PRINT JSR PRTDAT ;PRINT LINEASCI1 JSR ACHECK ;DIS ONE LINE BCS ASCIIQ ;IF EA STOP;********************************* JSR STOP BEQ ASCIIQ JSR GETIN BEQ ASCII CMP #' ' BNE ASCII LDA DEVICE PHA LDA #$03 STA DEVICE LDA #<PMSG LDY #>PMSG JSR STRPNT PLA STA DEVICEPAUS1 JSR GETIN BEQ PAUS1 BNE ASCII;*********************************ASCIIQ LDA PASS ;GET PASS CMP CPASS ;IS IT LAST BNE DATUT ;EXIT JSR INCSL JSR COMENT ;COMMENT LINE JSR DECSL;*********************************; EXIT TO NEXTSL;*********************************DATUT LDA #$FF ;SET N=1 RTS ;RETURNENDDAT LDA #$00 ;SET N=0 RTS ;RETURN;*********************************; CHECK OPTIONS;*********************************ACHECK LDA TEXTER ;GET DATA TYPE CMP #'4'         ;WORD-1 BEQ AC0 CMP #'3'         ;DBYTE BEQ AC1 CMP #'2'         ;WORD BEQ AC0 JMP BYTES ;BYTE OR ASCIIAC0 JMP WORDS ;WORD OR WORD-1AC1 JMP DBYTES ;DBYTES;*********************************; .BYTE DIRECTIVE;*********************************BYTES LDA PASS ;GET PASS CMP CPASS ;IS IT LAST BNE BYTESX ;IF NOT EXIT JSR PRTONE ;PRINT BYTE JSR PRAD ;PRINT ADDRESS LDY #>MBYTE ;.BYTE LDA #<MBYTE ; JSR STRPNT ;PRINT IT LDA TEXTER ;GET TYPE CMP #'0'          ;ASCII BEQ ALINE ;ASCII BYTES JSR DOLLAR ;PRINT $ JSR GETSL ;GET BYTE JSR PRBYT ;PRINT BYTE JSR NEWLIN ;NEXT LINEBYTESX JMP NEXTBY ;NEXT BYTE;*********************************; ASCII TEXT;*********************************ALINE LDA #$00 ;ZERO BYTE STA TEMP ;STORE IN COUNT;*********************************; CHECK FIRST BYTE OF LINE;********************************* JSR GETSL ;GET BYTE JSR CASCII ;CHECK FOR ASCII BCS NASCII ;IF NOT BRANCH LDA #"'"      ;PRINT ONE QUOTE JSR PCHAR ;PRINT IT;*********************************ALOP JSR GETSL ;GET BYTE JSR CASCII ;IS IT ASCII BCS EASCII ;IF NOT END LINE JSR PCHAR ;PRINT ASCII; REV 2-12-2018 START; IF CHAR = ' THEN PRINT SECOND ' JSR GETSL ; GET BYTE AGAIN CMP #$27 ;''' BNE Q00000 JSR PCHAR ;PRINT ASCIIQ00000 = *; REV 2-12-2018 END JSR NEXTBY ;INC SELECT JSR NEXTBY ;INC SELECT BCS EASCI1 ;C=1 IF END INC TEMP ;INC COUNT LDA TEMP ;LOAD COUNT CMP #$28 ;40 CHAR BEQ EASCII ;IF SO END JMP ALOP ;NEXT;*********************************EASCI1 JSR EASCII SEC RTS;*********************************EASCII LDA #"'" ;PRINT ONE QUOTE JSR PCHAR ; JMP NEWLIN ;PRINT CR;*********************************NASCII JSR DOLLAR ;PRINT $ JSR GETSL ;GET BYTE JSR PRBYT ;PRINT IT JSR NEWLIN ;PRINT CR JMP NEXTBY ;NEXT SL;*********************************; CHECK ACCUM FOR PRINTABLE ASCII;*********************************CASCII CMP #$20 ;< SPACE BMI NOASC ;IF LESS NOASCII CMP #$60 ;> _ BCS NOASC ;IF GREATER NO CLC ;CLEAR CARRY OK RTS ;RETURNNOASC SEC ;SET CARRY BAD RTS ;RETURN;*********************************; .DBYTE DIRECTIVE;*********************************DBYTES LDA PASS ;CHECK PASS CMP CPASS ;LAST PASS BNE DBYTEX ;EXIT JSR PRTTWO ;PRINT 2 BYTES JSR PRAD ;PRINT ADDRESS LDY #>MDBYTE ;.DBYTE LDA #<MDBYTE ; JSR STRPNT ;PRINT IT JSR GETSL ;GET BYTE STA WORKED+1 ;STORE JSR INCSL ;GET BYTE JSR GETSL ;GET BYTE STA WORKED ;STORE JSR DOLLAR ;PRINT $ JSR PWORKD ;PRINT WORD JSR NEWLIN ;PRINT CRDBYTEX JMP NEXTBY ;NEXT SL;*********************************; .WORD DIRECTIVE;*********************************WORDS LDA PASS ;GET PASS CMP CPASS         ;LAST BNE WORD1 ;IF NOT BRANCH JSR PRTTWO ;PRINT 2 BYTES JSR PRAD ;PRINT ADDRESS LDY #>MWORD ;.WORD LDA #<MWORD ; JSR STRPNT ;PRINT IT;*********************************; GET WORD INTO WORKED;*********************************WORD1 JSR GETSL ;GET BYTE STA WORKED ;STORE BYTE STA SMALLP ;STORE BYTE JSR INCSL ;GET BYTE JSR GETSL ;GET BYTE STA WORKED+1 ;STORE BYTE STA SMALLP+1 ;STORE BYTE LDA TEXTER ;GET OPTION CMP #'4'          ;.WORD ADRS-1 BEQ WORDM ;BRANCH;*********************************; CHECK PASS;********************************* LDA PASS ;CHECK PASS CMP IPASS  ;INTERNAL BEQ WORDPT ;TABLE WORD CMP EPASS BEQ WORDSY;*********************************; PRINT WORD;********************************* JSR SYMOP ;CHECK SYMBOL BCS WORDS3 ;C=1 SYMBOL JSR DOLLAR ;PRINT $ JSR PWORKD ;PRINT WORD JSR NEWLIN ;PRINT CRWORDSX JMP NEXTBY ;NEXT SLWORDPT JSR PUTI ;PUT IN TABLE JMP NEXTBY ;NEXT SLWORDSY JSR SYMOP JMP NEXTBY;*********************************; .WORD ADDRESS-1;*********************************WORDM CLC LDA WORKED ADC #$01 STA WORKED LDA WORKED+1 ADC #$00 STA WORKED+1;*********************************; CHECK PASS;********************************* LDA PASS ;CHECK PASS CMP IPASS ;INTERNAL BEQ WORDPT ;TABLE WORD CMP EPASS ;EXTERNAL BEQ WORDSY ;TABLE WORD;*********************************; PRINT WORD;********************************* JSR SYMOP ;CHECK SYMBOL BCC WORDS2 ;C=0 NO SYMBOL LDA #'-' JSR PCHAR LDA #'1' JSR PCHAR JMP WORDS3;*********************************WORDS2 JSR DOLLAR ;PRINT $ LDA SMALLP STA WORKED LDA SMALLP+1 STA WORKED+1 JSR PWORKD ;PRINT WORDWORDS3 JSR NEWLIN ;PRINT CRWORDXX JMP NEXTBY ;NEXT SL;*********************************; SELECT NEXT BYTE OF DATA;*********************************NEXTBY LDA SELECT+1 CMP EAS+1 BCC SBLOK BNE NOBINC LDA SELECT CMP EAS BCS NOBINCSBLOK JSR INCSL CLC RTSNOBINC SEC RTS;*********************************MBYTE .TEXT ' .BYTE ',0MWORD .TEXT ' .WORD ',0MDBYTE .TEXT ' .DBYTE ',0;*********************************;.FIL 0:TABLE.ASM;*********************************.END