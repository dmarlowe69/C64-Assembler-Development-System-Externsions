;.PAGE 'COMPARE";.OPT LIST;**********************************=$0801        ;START OF BASIC;*********************************; SET BSTUB TO ONE TO ALLOW FOR; INSERTION OF BASIC STUB CODE;*********************************BSTUB = 1;*********************************;;         COMPARE64;      COMPARE.C64 V072882;COMPARE PRG FILE FROM ASSEMBLER64;        BUILD PROCESS; (C) 1982 BY COMMODORE MACHINES;;  WRITTEN BY DENTON MARLOWE;*********************************;; BASIC FORMAT PROGRAM;; 10 SYS(2063);;*********************************;.IFN BSTUB <.IF  BSTUB == 1 .WORD BASIC    ;LINE LINK POINTER .BYTE $0A,$00  ;LINE NUMBER (10) .BYTE 158      ;SYS COMMAND TOKEN .TEXT '(2063)' ;CALL TO $080F .BYTE $00      ;END OF LINEBASIC .BYTE $00,$00  ;END OF BASIC;>.FI;*********************************;*=$080F        ;OBJ2PRG ORGIN;*********************************; SET FLAG TO ALLOW BASIC; AND KERNAL (ERROR) MESSAGES; $80 FOR BASIC; $40 FOR KERNAL;*********************************SETMSG=$FF90 LDA #$40     ;ALLOW KERNAL MESSAGES JSR SETMSG;*********************************; MAIN BODY OF CODE;*********************************.INCLUDE "compare.asm";*********************************.END