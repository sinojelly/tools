rem ע��: �ļ��������пո񣬶���%%c���ܸ�Ϊ"%%c"

rem if exist send_log.txt del send_log.txt

for %%c in (*.rar *.7z *.zip) do call sendfile.bat %%c

pause
