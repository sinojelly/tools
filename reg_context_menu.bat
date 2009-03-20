@rem 运行此文件之后可以通过右键菜单blat send mail发送附件。

echo 请确认当前路径是否正确(正确直接回车，否则输入正确路径)：
echo %CD%
set /p Input=
if not {%Input%}=={} (set CUR_DIR=%Input%) else (set CUR_DIR=%CD%)

rem cd /d %CUR_DIR%
echo current dir is: %CUR_DIR%




@REM 由于在system32中才能运行reg add成功，所以加了下面这句话，如果不存在此路径，需要修改
cd /d C:\windows\system32
reg add "HKEY_CLASSES_ROOT\*\shell\blat send email\command" /ve /t REG_SZ /d "cmd.exe /v:ON /k call %CUR_DIR%\..\path\setEnv.bat & sendfile.bat \"%%1\" &pause &exit" /f 


pause