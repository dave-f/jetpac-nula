REM Jet-Pac : NuLA refuel version 1.0
REM By Dave Footitt & Chris Hogg 2020
REM
MODE7
*FX200,3
?&FE00=8:?&FE01=&30
*FX9
*FX10
?&FE20=&10
*FX19
E%=FNTM(5)
?&FE22=&44
*FX19
G%=FNTM(5)
NULA%=E%/G%>0.75
MODE7
*FX4,2
IF NULA% PRINT "NuLA detected!" ELSE PRINT "No NuLA detected":END
INPUT "Number of lives (1-99)",LIVES%
PRINT "Remap CAPS/CTRL to A/S (Yes/No)?";
*FX15
A$=GET$
IF A$<>"Y" AND A$<>"y" AND A$<>"N" AND A$<>"n" GOTO 21
IF A$="Y" OR A$="y" THEN PRINT "Yes" ELSE PRINT "No"
?&70 = FNCLAMP(LIVES%)
IF A$="Y" OR A$="y" THEN ?&71=1 ELSE ?&71=0
PRINT ?&70
PRINT "Loading..."
CLOSE #0
*RUN JetNula
END
DEFFNTM(N%):LOCALI%,T%:TIME=0:FORI%=1TON%:*FX19
NEXT:T%=TIME:=T%
DEFFNCLAMP(N%):IF N%<1 THEN N%=1 ELSE IF N%>99 THEN N%=99
=N%