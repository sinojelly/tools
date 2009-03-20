rem 注意: 文件名不能有空格，而且%%c不能改为"%%c"

rem if exist send_log.txt del send_log.txt

for %%c in (*.rar *.7z *.zip) do call sendfile.bat %%c

pause
