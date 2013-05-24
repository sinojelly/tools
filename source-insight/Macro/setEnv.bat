@rem Win7下无须以管理员身份运行

@rem 设置SourceInsight 用户名，该名字会出现在注释中.
rem setx SI_USER        chenguodong

@rem 设置SourceInsight生成注释中的Copyright
rem setx SI_COPYRIGHT   "Guodong Workshop. 2009-2019. All rights reserved."

@rem 设置TortoiseSVN路径
rem setx TortoiseSVN_PATH  "C:\Program Files\TortoiseSVN\bin\TortoiseProc.exe"

@rem 设置SourceMonitor路径
rem setx SRCMONITOR_PATH   "%GD_TOOL%\SourceMonitor\SourceMonitor.exe"

@rem 快捷键设置(1表示使用)
set HOT_KEY_CTRL=0
set HOT_KEY_ALT=1
@rem Shift最好用来扩展类似命令，不在这里设置
set HOT_KEY_SHIFT=0

@rem 如果快捷键是否全部替换
set ALL_REPLACE=1

set SI_BASE_PRJ=C:\Users\Jelly\Documents\Source Insight\Projects\Base\Base.PR
set SI_EM_FILE=guodong.em

copy %SI_EM_FILE% "%SI_BASE_PRJ:Base.PR=%"

@rem 如果 GD_setup 无法调用，可能是 guodong.em 文件未加入Base工程导致。手动加入之后，关闭 SI，再次运行下面命令应该就好了。
call "C:\Program Files (x86)\Source Insight 3\Insight3.exe" -c GD_setup

pause
