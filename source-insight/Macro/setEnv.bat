@rem Win7�������Թ���Ա�������

@rem ����SourceInsight �û����������ֻ������ע����.
setx SI_USER        chenguodong

@rem ����SourceInsight����ע���е�Copyright
setx SI_COPYRIGHT   "Huawei Technologies Co., Ltd. 2009-2019. All rights reserved."

@rem ����TortoiseSVN·��
setx TortoiseSVN_PATH  "C:\Program Files\TortoiseSVN\bin\TortoiseProc.exe"

@rem ����SourceMonitor·��
setx SRCMONITOR_PATH   "%GD_TOOL%\SourceMonitor\SourceMonitor.exe"

@rem ��ݼ�����
set HOT_KEY_CTRL=0
set HOT_KEY_ALT=1
@rem Shift���������չ�������������������
@rem set HOT_KEY_SHIFT=0   

@rem �����ݼ��Ƿ�ȫ���滻
set ALL_REPLACE=1

set SI_BASE_PRJ=D:\Users\Jelly\Documents\Source Insight\Projects\Base\Base.PR
set SI_EM_FILE=guodong.em

rem copy %SI_EM_FILE% "%SI_BASE_PRJ:Base.PR=%"

call "C:\Program Files\Source Insight 3\insight3.exe" -c GD_setup


pause
