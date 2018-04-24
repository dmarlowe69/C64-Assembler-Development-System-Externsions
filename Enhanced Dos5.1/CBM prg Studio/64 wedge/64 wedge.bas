!--------------------------------------------------
!- Thursday, January 21, 2016 8:48:49 AM
!- Import of : 
!- c:\users\denton\desktop\64 wedge.prg
!- Commodore 64
!--------------------------------------------------
10 IFA=0THENA=1:PRINT"{clear}":LOAD"dos 5.1e",8,1
15 POKE53070,8:SYS52224:POKE53070,2:PRINT"{down}{space*10}{reverse on} command summary "
20 PRINT".$ directory{space*8}@{space*2}error status
25 PRINT".v validate{space*8}>n{space*2}device# = n
30 PRINT".i initialize{space*7}!{space*2}monitor/break
35 PRINT".q{space*2}disable dos support
40 PRINT"sys 52224{space*2}reactivate dos support
45 PRINT"/filename{space*14}load
50 PRINT"^filename{space*14}load & run
55 PRINT"&filename{space*14}append
60 PRINT"{arrow left}filename{space*14}save
65 PRINT"{arrow left}@0:filename{space*11}save & replace
70 PRINT"=filename{space*14}verify
75 PRINT"%filename{space*14}load absolute
80 PRINT".s0:filename{space*11}scratch
85 PRINT".r0:newname=0:oldname{space*2}rename
90 PRINT".c0:newfile=0:oldfile{space*2}copy/merge 1-4
92 PRINT"{space*2},0:old2,---0:old4{space*6}files
95 PRINT".n0:diskname,id{space*8}format new disk
100 NEW
