
@echo off
rem sed -n "s/; CMD:/ CMD:/p" sinojelly.ahk

dir /B *.ahk > %Temp%\temp_all_ahk.txt
for /f "eol=;" %%i in (%Temp%\temp_all_ahk.txt) do (
   sed -n "s/; CMD:/ CMD:/p" %%i
)

pause
