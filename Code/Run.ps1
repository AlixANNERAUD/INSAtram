ptop ./INSAtram.pas ./INSAtram.pas
ptop ./Unit_Types.pas ./Unit_Types.pas
ptop ./Unit_Graphics.pas ./Unit_Graphics.pas
ptop ./Unit_Logic.pas ./Unit_Logic.pas


fpc ./INSAtram.pas -FE"./Binaries"

./Binaries/INSAtram.exe

del ./Binaries/INSAtram.exe