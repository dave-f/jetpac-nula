MODE7
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
IF NULA% PRINT "NuLA detected!"
CLOSE #0
*RUN test
END
DEFFNTM(N%):LOCALI%,T%:TIME=0:FORI%=1TON%:*FX19
NEXT:T%=TIME:=T%