@rem ���д��ļ�֮�����ͨ���Ҽ��˵�blat send mail���͸�����

echo ��ȷ�ϵ�ǰ·���Ƿ���ȷ(��ȷֱ�ӻس�������������ȷ·��)��
echo %CD%
set /p Input=
if not {%Input%}=={} (set CUR_DIR=%Input%) else (set CUR_DIR=%CD%)

rem cd /d %CUR_DIR%
echo current dir is: %CUR_DIR%




@REM ������system32�в�������reg add�ɹ������Լ���������仰����������ڴ�·������Ҫ�޸�
cd /d C:\windows\system32
reg add "HKEY_CLASSES_ROOT\*\shell\blat send email\command" /ve /t REG_SZ /d "cmd.exe /v:ON /k call %CUR_DIR%\..\path\setEnv.bat & sendfile.bat \"%%1\" &pause &exit" /f 


pause