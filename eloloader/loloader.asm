;.PAGE 'LOLOADER64";.OPT LIST;**********************************=$0801        ;START OF BASIC;*********************************; SET BSTUB TO ONE TO ALLOW FOR; INSERTION OF BASIC STUB CODE;*********************************BSTUB = 1;*********************************;;         LOLOADER64;      LOLOAD.C64 V072882;LOAD OBJECT FILE FROM ASSEMBLER64; (C) 1982 BY COMMODORE MACHINES;;  DOCUMENTED BY DENTON MARLOWE;*********************************;; BASIC FORMAT PROGRAM;; 10 SYS(2063);;*********************************;.IFN BSTUB <.IF  BSTUB == 1 .WORD BASIC    ;LINE LINK POINTER .BYTE $0A,$00  ;LINE NUMBER (10) .BYTE 158      ;SYS COMMAND TOKEN .TEXT '(2063)' ;CALL TO $080F .BYTE $00      ;END OF LINEBASIC .BYTE $00,$00  ;END OF BASIC;>.FI;*********************************;*=$080F        ;LOADER64 ORGIN;*********************************; EQUATES FOR TITLE IN MAIN BODY; SOURCE CODE FILE;; LOLOADER.ASM OR HILOADER.ASM;;.BYTE 'LOLOAD.C64 V072882';.BYTE 'HILOAD.C64 V072882';.BYTE TITLE1,TITLE2;.BYTE 'LOAD.C64 V072882';.BYTE $0D;;*********************************TITLE1=$4C ;'L'TITLE2=$4F ;'O';*********************************; SET FLAG TO ALLOW BASIC; AND KERNAL (ERROR) MESSAGES; $80 FOR BASIC; $40 FOR KERNAL;*********************************SETMSG=$FF90 LDA #$C0     ;ALLOW ALL MSG JSR SETMSG;*********************************; MAIN BODY OF CODE;*********************************.INCLUDE "loader.asm";*********************************.END