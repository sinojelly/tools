@rem Win7�������Թ���Ա�������

@rem ����SourceInsight �û����������ֻ������ע����.
rem setx SI_USER        chenguodong

@rem ����SourceInsight����ע���е�Copyright
rem setx SI_COPYRIGHT   "Guodong Workshop. 2009-2019. All rights reserved."

@rem ����TortoiseSVN·��
rem setx TortoiseSVN_PATH  "C:\Program Files\TortoiseSVN\bin\TortoiseProc.exe"

@rem ����SourceMonitor·��
rem setx SRCMONITOR_PATH   "%GD_TOOL%\SourceMonitor\SourceMonitor.exe"

@rem ��ݼ�����(1��ʾʹ��)
set HOT_KEY_CTRL=0
set HOT_KEY_ALT=1
@rem Shift���������չ�������������������
set HOT_KEY_SHIFT=0

@rem �����ݼ��Ƿ�ȫ���滻
set ALL_REPLACE=1

set SI_BASE_PRJ=C:\Users\Jelly\Documents\Source Insight\Projects\Base\Base.PR
set SI_EM_FILE=guodong.em

copy %SI_EM_FILE% "%SI_BASE_PRJ:Base.PR=%"

@rem ��� GD_setup �޷����ã������� guodong.em �ļ�δ����Base���̵��¡��ֶ�����֮�󣬹ر� SI���ٴ�������������Ӧ�þͺ��ˡ�
call "C:\Program Files (x86)\Source Insight 3\Insight3.exe" -c GD_setup

pause
