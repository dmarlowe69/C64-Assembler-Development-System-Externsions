;*********************************; FILE MODE.ASM;*********************************;;        DISASSEMBLER64;    SYMBOLIC DISASSEMBLER;       BY DENTON MARLOWE;;  (C)1986 BY DENTON MARLOWE;;*********************************; ADDRESSING MODE UTILITIES;*********************************;      DISASSEMBLE ONE LINE;*********************************DSLINE JSR DATAOP ;CHECK FOR DATA       BMI BYTT   ;N=1 THEN FOUND;*********************************; CHECK BIT ZP DECODING OPTIONS;*********************************       LDA BITFLG ;CHECK BIT FLAG       BEQ DISL   ;IF ZERO NO BIT       JSR GETSL  ;GET BYTE       CMP #$24   ;ZEROPAGE BIT       BEQ BYZBIT ;       CMP #$2C   ;ZEROPAGE BIT       BEQ BYABIT ;       BNE DISL   ;;*********************************; CHECK BIT ABS DECODING OPTIONS;*********************************;********************************; PROCESS LINE OF CODE;********************************DISL = *       JSR GETSL  ;GET BYTE       LDX PASS   ;GET PASS COUNT       CPX CPASS  ;LAST       BEQ DISL1  ;IF LAST BRANCH       JSR OPERN1 ;IF LAST BRANCH       JMP BYTT   ;NEXT INSTRUCTION;********************************; PRINT DISASSEMBLY ADDRESS;********************************DISL1  JSR PRTASS ;PRINT LINE DATA       JSR PRAD   ;PRINT ADDRESS       JSR SPACE  ;SPACE OVER;********************************; PRINT INSTRUCTION;********************************       JSR GETSL  ;GET BYTE       PHA        ;STORE       JSR MNEMON ;PRINT MNEMONIC       JSR SPACE  ;SPACE OVER       PLA        ;GET BYTE       JSR OPERND ;PRINT OPERANDFINAL  JSR NEWLIN ;START NEW LINEBYTT   JMP NEXTSL ;NEXT INSTRUCTION;********************************;      BIT ZP SKIP TRICK;; THE SKIP WILL ALWAYS INVOLVE; A FOLLWING OPCODE THAT IS EITHER; AN OPCODE WITH NO OPERAND OR; OR ONE BYTE OPERAND LIKE A BRANCH; OR ZERO PAGE INSTRUCTION;*********************************BYZBIT = *       LDA BITFLG       AND #$02       BEQ DISL;********************************;      TO SKIP OR NOT;*********************************      JSR INCSL  ;INC TO OPERAND      JSR GETSL  ;GET OPERAND      PHA      JSR DECSL      PLA                 ;CHECK FOR SKIP      CMP #$10   ;BPL SKIP      BEQ B0000      CMP #$18   ;CLC SKIP      BEQ B0000      CMP #$30   ;BMI      BEQ B0000      CMP #$38   ;SEC      BEQ B0000;      JMP DISL;********************************;      BIT ABS SKIP TRICK;*********************************BYABIT = *       LDA BITFLG       AND #$01       BEQ DISL;********************************;      TO SKIP OR NOT;*********************************      JSR INCSL  ;INC TO OPERAND      JSR GETSL  ;GET OPERAND      PHA      JSR DECSL      PLA                 ;CHECK FOR SKIP      CMP #$A1   ;LDY A IMMEDIATE SKIP      BEQ B0000      CMP #$A2   ;LDA A IMMEDIATE SKIP      BEQ B0000      CMP #$A9   ;LDX A IMMEDIATE SKIP      BEQ B0000      CMP #$65   ;ADC ZP      BEQ B0000      CMP #$85   ;STA ZP      BEQ B0000      CMP #$B1   ;LDA (ZP),Y      BEQ B0000      CMP #$E6   ;INC      BEQ B0000;      JMP DISL;********************************;      PRINTING PASS?;*********************************B0000 = *       LDA PASS  ;GET PASS COUNT       CMP CPASS ;LAST       BNE BYTT  ;IF NOT NEXT BYTE;*********************************;  PRINT LINE DATA FOR .BYTE;*********************************       JSR COMENT    ;COMENT LINE;       JSR PRTDAT    ;PRINT LINE DATA       JSR PRTONE    ;ONE BYTE       JSR PRAD      ;PRINT ADDRESS       JSR SPACE     ;SPACE OVER       LDA #<MSGBIT  ;.BYTE $       LDY #>MSGBIT  ;       JSR STRPNT    ;PRINT IT;       JSR GETSL     ;GET BYTE       JSR PRBYT     ;PRINT BYTE;       LDA #<MSGBZP  ;BIT COMMENT       LDY #>MSGBZP  ;       JSR STRPNT    ;PRINT IT;       JSR NEWLIN   ;PRINT BYTE       ;JSR INCSL    ;INC SELECT       JSR COMET    ;COMENT LINE       ;JSR DECSL    ;REASET SELECT       JMP FINAL    ;CR AND NEXT BYTE;*********************************;BYTEXT JMP DISL1;*********************************; ADDRESSING MODE UTILITIES;*********************************;;*********************************; ANALYSIS OPERAND ROUTINES;*********************************;    BIT ZP ONE-BYTE OPERAND; ZERO PAGE BIT IS ALMOST ALWAYS;   A BIT TRICK TO SKIP THE NEXT;          OPCODE;********************************ONEBIT NOP;*********************************;      ONE-BYTE OPERAND;********************************ONEBYT JSR INCSL ;INC TO BYTE JSR GETSL ;GET BYTE STA WORKED ;STORE OPERAND LDA #$00 ;ZERO BYTE STA WORKED+1 ;ZERO HIGH BYTE LDA PASS ;GET PASS COUNT CMP IPASS       ;INTERNAL BEQ OPCPUT ;TABLE OPERAND CMP EPASS       ;EXTERNAL BEQ OPCSYM ;EXTERNAL EQUATE;*********************************; OUTPUT OPERAND;********************************* JSR SYMOP ;CHECK FOR SYMBOL BCS TWOB ;SYMBOL FOUND JSR RANGE ;IS IT INTERNAL BCC ONEBY ;GENERATE LABEL JSR DOLLAR ;EXTERNAL JMP ONEBX ;PRINT ADDRESSONEBY JSR PRLA ;PRINT XXONEBX LDA WORKED ;GET OPERAND JMP PRBYT ;PRINT BYTE;********************************;      BIT ABS TWO-BYTE OPERAND;********************************TWOBIT NOP;********************************;      TWO-BYTE OPERAND;********************************TWOBYT JSR INCSL ;INC TO BYTE JSR GETSL ;GET BYTE STA WORKED ;STORE LOW BYTE JSR INCSL ;INC TO BYTE JSR GETSL ;GET BYTE STA WORKED+1 ;STORE HIGH BYTE LDA PASS ;GET PASS COUNT CMP IPASS       ;INTERNAL BEQ OPCPUT ;TABLE OPERNAD CMP EPASS       ;EXTERNAL BEQ OPCSYM ;EXTERNAL EQUATE;********************************;  OUTPUT OPERAND;******************************** JSR SYMOP  ;CHECK SYMBOL BCS TWOB   ;C=1 FOUND ONE JSR RANGE  ;IS IT INTERNAL BCC TWOBY  ;GERNERATE LABEL JSR DOLLAR ;EXTERNAL JMP TWOBX  ;;********************************;  OUTPUT OPERAND;********************************TWOBY =* JSR PRLA   ;PRINT XXTWOBX = * JMP PWORKD ;PRINT ADDRESSOPCPUT = * JMP PUTI   ;PUT IN TABLEOPCSYM = * JMP SYMOP  ;CHECK EXT EQUATETWOB = * RTS        ;RETURN;*********************************; ILLEGAL MODES, UNUSED OPCODES;; ZZZZ XX .BYTE $XX ;'Y' ;??? ILLEGAL OPCODE;;*********************************ILLEGL INC ERRCT   ;INC ERROR COUNT       BNE *+5     ;SKIP NEXT LINE       INC ERRCT+1 ;INC ERROR COUNT       LDY #>MBYTE ;.BYTE       LDA #<MBYTE ;       JSR STRPNT  ;PRINT STRING       JSR DOLLAR  ;PRINT $       JSR GETSL   ;GET ILLEGAL BYTE       ;BEGIN REV 2017-3       PHA         ;PUT BYTE ON STACK;       JSR PRBYT   ;PRINT IT       JSR SPACE   ;SPACE OVER;       PLA         ;POP BYTE OFF STACK       JSR CASCII  ;IS IT PRINTABLE ASCII       BCS ISKIP   ;IF NOT EXIT       PHA         ;STACK IT       JSR SPACE   ;SPACE OVER       JSR SEMIC   ;COMMENT       LDA #"'"    ;QUOTE       JSR PCHAR   ;PRINT IT       PLA         ;POP IT       JSR PCHAR   ;PRINT IT       LDA #"'"    ;QUOTE       JSR PCHAR   ;PRINT IT       JSR SPACE   ;SPACE OVER;ISKIP = *;END REV 2017-3       LDY #>ILLMSG       LDA #<ILLMSG       JMP STRPNT;********************************;      ACCUMULATOR MODE;********************************ACC LDA #'A'     ;ASCII A JMP PCHAR ;PRINT IT;********************************;       IMMEDIATE MODE;********************************IMMEDT JSR INCSL ;INC TO DATA BYTE LDX PASS ;GET PASS CPX CPASS ;LAST PASS BNE IMEXIT ;EXIT LDA #'#'        ;ASCII # JSR PCHAR ;PRINT IT JSR DOLLAR ;PRINT $ JSR GETSL ;GET BYTE PHA ;STACK IT JSR PRBYT ;PRINT IT PLA ;POP IT JSR CASCII ;PRINTABLE ASCII BCS IMEXIT ;IF NOT EXIT PHA ;STACK IT JSR SPAC6 ;SPACE OVER JSR SEMIC ;COMMENT LDA #"'"        ;QUOTE JSR PCHAR ;PRINT IT PLA ;POP IT JSR PCHAR ;PRINT IT LDA #"'"        ;QUOTE JSR PCHAR ;PRINT ITIMEXIT RTS ;EXIT;*********************************;      BIT ZERO PAGE MODE;*********************************ZERBIT NOP;*********************************;      ZERO PAGE MODE;*********************************ZEROPG JMP ONEBYT ;PRINT ONE BYTE;*********************************;      ZERO PAGE,X MODE;********************************ZEROX JSR ONEBYT ;PRINT ONE BYTE JMP XINDEX ;PRINT ,X;********************************;       ZERO PAGE,Y MODE;********************************ZEROY JSR ONEBYT ;PRINT ONE BYTE JMP YINDEX ;PRINT ,Y;*********************************;         BIT ABSOLUTE MODE;*********************************ABSBIT NOP;*********************************;         ABSOLUTE MODE;*********************************ABSLUT JSR TWOBYT ;PRINT TWO BYTE JSR DECSL ;DEC TO SECOND JSR DECSL ;DEC TO OPCODE JSR GETSL ;GET BYTE PHA JSR INCSL JSR INCSL PLA CMP #$4C ;IS IT JMP BNE ABSEXT ;IF NOT EXIT JSR NEWLIN ;NEXT LINE JSR INCSL JSR COMET ;COMMENT LINE JSR DECSLABSEXT RTS ;RETURN;*********************************;       ABSOLUTE,X MODE;********************************ABSX JSR TWOBYT ;PRINT TWO BYTE JMP XINDEX ;PRINT ,X;********************************;       ABSOLUTE,Y MODE;********************************ABSY JSR TWOBYT ;PRINT TWO BYTE JMP YINDEX ;PRINT ,Y;********************************;       IMPLIED MODE;********************************IMPLID JSR GETSL ;GET BYTE BEQ IMPLI1 ;BRK CMP #$60 ;CHECK CODE BEQ IMPLI1 ;RTS CMP #$40 ;CHECK CODE BEQ IMPLI1 ;RTIIMPONE RTS ;RETURNIMPLI1 JSR NEWLIN ;PRINT NEW LINE JSR INCSL JSR COMET ;COMMENT LINE JMP DECSL;********************************;       INDIRECT MODE;********************************INDRCT JSR LPAREN ;PRINT ( JSR TWOBYT ;PRINT TWO BYTE JSR RPAREN ;PRINT ) JSR NEWLIN ;NEXT LINE JSR INCSL JSR COMET ;COMMENT LINE JMP DECSL;********************************;     INDIRECT,X MODE;********************************INDX JSR LPAREN ;PRINT ( JSR ZEROX ;PRINT $HH,X JMP RPAREN ;PRINT );********************************;     INDIRECT,Y MODE;********************************INDY JSR LPAREN ;PRINT ( JSR ONEBYT ;PRINT ONE BYTE JSR RPAREN ;PRINT ) JMP YINDEX ;PRINT ,Y;*********************************;      RELATIVE MODE;*********************************RELATV JSR INCSL    ;INC BYTE POINTER       LDA PASS     ;GET PASS COUNT       CMP EPASS    ;EXTERNAL       BEQ RELSYM   ;EXIT ON EXTERNAL;       LDA SELECT   ;GET LOW POINTER       STA WORKED   ;STORE TEMP       LDA SELECT+1 ;GET HIGH POINTER       STA WORKED+1 ;STORE TEMP       INC WORKED   ;ADD 1 TO ADDRESS       BNE *+5      ;ZERO MEANS CARRY       INC WORKED+1 ;INC HIGH ADDRESS;       JSR GETSL    ;GET BYTE BRANCH OFFSET       CMP #$00     ;IS IT ZERO       BPL FORWRD   ;IF SO BRANCH       DEC WORKED+1 ;DEC HIGH POINTERFORWRD CLC          ;CLEAR CARRY FLAG       ADC WORKED   ;ADD IN OPERAND       BCC RELND    ;TO SELECT ADDRES       INC WORKED+1 ;AND NOW POINTSRELND  STA WORKED   ;TARGET ADDRESS;       LDA PASS     ;GET PASS COUNT       CMP IPASS    ;INTERNAL       BEQ RELPUT   ;ADDRESS TABLE;       JSR SYMOP    ;CHECK FOR SYMBOL       BCS RELSYM   ;C=1 SYMBOL;       LDA ROPT     ;CHECK OPTION       CMP #$01     ;REL TO * ?       BEQ RELPC    ;IF SO DO IT;       JMP PWORK    ;PRINT ADDRESS;RELPUT = *       JMP PUTI     ;PUT IN TABLE;RELSYM RTS          ;RETURN;*********************************; PRINT RELATIVE TO PC;*********************************RELPC JSR GETSL ;GET BRANCH DATA PHA ;SAVE ON STACK BMI RELNEG ;BACKWARD ? LDA #<POSREL LDY #>POSREL JMP RELPMRELNEG LDA #<NEGREL LDY #>NEGRELRELPM JSR STRPNT PLA ;GET BRANCH DATA CLC ;CLEAR CARRY ADC #$02 ;ADD 2 FOR BRANCH BPL RELP ;FORWARD ? CLC ;CLEAR CARRY EOR #$FF ;COMPLMENT ADC #$01 ;ADD 1 FOR 2'SRELP JSR PRBYT ;PRINT BRANCH JSR SPAC6 ;SPACE JSR SEMIC ;COMMENT CHAR JMP PWORK ;PRINT ADDRESS;*********************************;  ORGIN LABEL;*********************************ORGIN JSR PRTOTH ;PRINT LINE DATA LDA #'*'        ;PC JSR PCHAR ;PRINT IT LDA #'='        ;EQUALS JSR PCHAR ;PRINT IT JSR DOLLAR ;ASCII $ JSR PSELEC ;PRINT ADDRESS JMP NEWLIN ;START NEWLINE;*********************************; END OF FILE LABLE;*********************************EFILE JSR COMENT ;COMMENT LINE JSR PRTOTH ;PRINT LINE DATA LDA #<MSGEND ;END MESSAGE LDY #>MSGEND JSR STRPNT ;PRINT IT JMP NEWLIN ;NEW LINE;*********************************; PRINT COMMENT LINE;*********************************COMENT JSR COMET ;PRINT COMMENT JMP NEWLIN ;NEXT LINE;*********************************COMET JSR PRTOTH ;PRINT LINE DATA JSR SEMIC ;PRINT COMMENT LDA FOROPT BNE CSHORT LDY #$20 ;COUNTER .BYTE $2CCSHORT LDY #$10COMPT LDA #'*'    ;STAR JSR PCHAR ;PRINT CHAR DEY ;DEC COUNTER BNE COMPT ;20 OR 10 STARS RTS ;RETURN;*********************************;     PRINT SELECTED ADDRESS;*********************************PRLA LDA #'X' ;XX LABEL JSR PCHAR ; LDA #'X'     ; JMP PCHAR ;;*********************************; PRINT CODE ADDRESS;*********************************PRAD JSR SYM ;CHECK FOR SYMBOLIC BCS NPRAD1 ;C=1 SYMBOLIC LABEL LDA XOPT ;CHECK GENERATION BEQ P1 ;NO LABELS JSR INTCHA ;IS ADDRESS IN TAB BCS P1 ;C=1 YES LDA FOROPT ;CHECK FORMAT BEQ POVER  ;STD FORMAT JMP SPACE  ;ONE SPACEPOVER JMP SPAC6 ;SPACE OVER;*********************************; PRINT ADDRESS AS LABEL;*********************************P1 JSR PRLA ;PRINT XX JSR PSELEC ;PRINT ADDRESS NOP NOP NOPNPRAD RTS ;RETURN;*********************************NPRAD1 LDA FOROPT BNE NPRAD JMP FIXSYM;*********************************; PRINT SELECT ADDRESS;*********************************PSELEC LDA SELECT ;LOW BYTE LDY SELECT+1 ;HIGH BYTE JMP PRBYTS ;PRINT THEM;*********************************; PRINT WORKED ADDRESS WITH XX;*********************************PWORK JSR PRLA ;PRINT XX;*********************************; PRINT WORKED ADDRESS;*********************************PWORKD LDA WORKED ;LOW BYTE LDY WORKED+1 ;HIGH BYTE JMP PRBYTS ;PRINT THEM;********************************; PRINT SEMICOLON FOR COMMENT;********************************SEMIC LDA #';' JMP PCHAR;********************************; PRINT DOLLAR SIGN FOR HEX;********************************DOLLAR LDA #'$' JMP PCHAR;********************************; PRINT LEFT PARENTTHESES;********************************LPAREN LDA #'(' JMP PCHAR;********************************; PRINT RIGHT PARENTTHESES;********************************RPAREN LDA #')' JMP PCHAR;********************************; PRINT A COMMA AND AN "X";********************************XINDEX LDA #',' JSR PCHAR LDA #'X' JMP PCHAR;********************************; PRINT A COMMA AND A "Y";********************************YINDEX LDA #',' JSR PCHAR LDA #'Y' JMP PCHAR;********************************; PRINT CARRAIGE RETURN;*********************************CRLF LDA #$0D ;ASCII CR JMP PCHAR ;PRINT;*********************************; PRINT SIX SPACES;*********************************SPAC6 LDA #$05SPACM STA TEMPSPAC JSR SPACE DEC TEMP BNE SPAC;*********************************; PRINT SPACE;*********************************SPACE LDA #$20 ;ASCII SPACE JMP PCHAR ;PRINT;*********************************; SELECT NEXT BYTE;*********************************NEXTSL LDA SELECT+1 CMP EA+1 BCC SLOK BNE NOINC LDA SELECT CMP EA BCS NOINCSLOK JSR INCSL CLC RTSNOINC SEC RTS;*********************************; INC SELECTED BYTE;*********************************INCSL INC SELECT BNE *+5 INC SELECT+1 RTS;*********************************; GET SELECTED BYTE;*********************************GETSL CLC LDA SELECT ADC OFFSET STA ZEROUR LDA SELECT+1 ADC OFFSET+1 STA ZEROUR+1 LDY #$00 LDA (ZEROUR),Y RTS;*********************************; DEC SLECTED BYTE;*********************************DECSL LDA SELECT BNE *+5 DEC SELECT+1 DEC SELECT RTS;*********************************; INITIALIZE SELECT;*********************************INTSA LDA SA STA SELECT LDA SA+1 STA SELECT+1 RTS;*********************************; ASCII STRING DATA;*********************************MSGBIT .TEXT '.BYTE $',0MSGBZP .TEXT ' ;BIT ZP SKIP',0POSREL .TEXT '*+$',0NEGREL .TEXT '*-$',0MSGEND .TEXT '.END',0ILLMSG .TEXT ';??? ILLEGAL OPCODE',0;*********************************; PRINT ONE BYTE OPCODE DATA;*********************************PRTONE JSR GETSL ;GET BYTE JSR PRBYT ;PRINT BYTE LDA FOROPT BEQ PRTON1 LDA #$07 .BYTE $2CPRTON1 LDA #$09 ;10 SPACES JSR SPACM ; JMP PRTEST ;RESET I/O DEVICE;*********************************; PRINT TWO BYTE OPCODE DATA;*********************************PRTTWO JSR GETSL ;GET BYTE JSR PRBYT ;PRINT BYTE JSR SPACE ; JSR INCSL ;INC TO OPERAND JSR GETSL ;GET BYTE JSR PRBYT ;PRINT IT LDA FOROPT BEQ PRTTW1 LDA #$04 .BYTE $2CPRTTW1 LDA #$06 ;7 SPACES JSR SPACM ; JSR DECSL ;RESET POINTER JMP PRTEST ;RESET I/O DEVICE;*********************************; PRINT THREE BYTE OPCODE DATA;*********************************PRTTHE JSR GETSL ;GET BYTE JSR PRBYT ;PRINT BYTE JSR SPACE ; JSR INCSL ;INC TO OPERAND JSR GETSL ;GET BYTE JSR PRBYT ;PRINT IT JSR SPACE ; JSR INCSL ;INC TO LAST BYTE JSR GETSL ;GET BYTE JSR PRBYT ;PRINT IT LDA FOROPT BEQ PRTTH1 LDA #$01 .BYTE $2CPRTTH1 LDA #$03 ;4 SPACES JSR SPACM ; JSR DECSL ;DEC POINTER JSR DECSL ;DEC POINTER;*********************************; RESET I/O DEVICE (DISK IF USED);*********************************PRTEST LDA OUTPUT ;GET I/O DEVICE STA DEVICE ;RESET I/O RTS ;RETURN;*********************************; PRINT LINE DATA FOR OPCODE;*********************************PRTDAT LDA DEVICE ;OUTPUT DEVICE AND #$07 ;MASK DISK STA DEVICE ;RESET LDA FOROPT ;CHECK FORMAT BNE PRTDAF ;SKIP LINE # LDA LINECT+1 ;HIH BYTE LINE LDX LINECT ;LOW BYTE LINE JSR PRTNUM ;PRINT NUMBER JSR SPACE ; JSR SPACE ;PRTDAF JSR PSELEC ;PRINT ADDRESS LDA #$01 ;2 SPACES JMP SPACM ;;*********************************; PRINT LINE DATA FOR OTHER LINES;*********************************PRTOTH JSR PRTDAT ;PRINT LINE LDA FOROPT BEQ PRTOT1 LDA #$09 .BYTE $2CPRTOT1 LDA #$0B ;12 SPACES JSR SPACM ; JMP PRTEST ;RESET I/O;********************************;.FIL 0:INTERNAL.ASM;********************************.END