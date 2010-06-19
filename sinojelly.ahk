; IMPORTANT INFO ABOUT GETTING STARTED: Lines that start with a
; semicolon, such as this one, are comments.  They are not executed.

; This script has a special filename and path because it is automatically
; launched when you run the program directly.  Also, any text file whose
; name ends in .ahk is associated with the program, which means that it
; can be launched simply by double-clicking it.  You can have as many .ahk
; files as you want, located in any folder.  You can also run more than
; one ahk file simultaneously and each will get its own tray icon.

; SAMPLE HOTKEYS: Below are two sample hotkeys.  The first is Win+Z and it
; launches a web site in the default browser.  The second is Control+Alt+N
; and it launches a new Notepad window (or activates an existing one).  To
; try out these hotkeys, run AutoHotkey again, which will load this file.

; ���ӣ�Win+z ��������д�autohotkey��ҳ
; #z::Run www.autohotkey.com

; ���ӣ�ctrl+alt+n ��notepad
; ^!n::
; IfWinExist Untitled - Notepad
; 	WinActivate
; else
; 	Run Notepad
; return

; ���ô��ڲ���ʱָ���Ĺؼ��ֿ����Ǵ��ڱ��������λ��
SetTitleMatchMode 2

; �ʼǱ�����Fn���£�����ʹ��End��Home���ܲ����㣬������PgUp/PgDn����������
PgDn::Send {End}
PgUp::Send {Home}
End::Send {PgDn}
Home::Send {PgUp}

; shiftѡ��
+PgDn::Send +{End}
+PgUp::Send +{Home}
+End::Send +{PgDn}
+Home::Send +{PgUp}

; ctrl+home�ļ���;ctrl+end�ļ�β��
^PgDn::Send ^{End}
^PgUp::Send ^{Home}
^End::Send ^{PgDn}
^Home::Send ^{PgUp}

; CMD: Alt+R ����򿪵���Ŀ(�ļ�/�ļ���) (R-Recent)
!r::Run "C:\Users\jelly\AppData\Roaming\Microsoft\Windows\Recent\"

; CMD: Ctrl+PrtSc ��ץͼ���
^PrintScreen::
IfWinExist HyperSnap
{
	WinActivate
}
else
{
	Run "D:\Program Files\HyperSnap 6\HprSnap6.exe"
}
return

; CMD: Ctrl+P ����Proxy (P-Proxy)
^p::
IfWinExist ssh_start.bat
	WinActivate
else
	Run "D:\Tools\CMD\ssh\ssh_start.bat"
return

; CMD: Ctrl+Alt+D �������ع��� (D-Download)
^!d::
IfWinExist Ѹ��
	WinActivate
else
	Run "C:\Program Files\Thunder Network\Thunder\Program\Thunder.exe"
return

; CMD: Ctrl+D ������Ŀ¼ (D-Download)
^d::Run "D:\Users\Downloads"

; CMD: Win+A ���ļ��������� (��Everything�����е������)
; ������������ڲ����ˣ�������Ҳ������������󲻻�������ݿ⣬���Ǻܿ죬ֻ����Ҫȷ�Ϸ���Ӳ��
; CMD: Ctrl+Shift+A �����ļ��������� (����Everything)
^+A::Run "D:\Tools\CMD\Everything-1.2.1.371\Everything-1.2.1.371.exe"

; CMD: Win+W ���дʵ� (W-Word)
#W::
IfWinExist �е��ʵ�
	WinActivate
else
	Run "C:\Program Files\Youdao\Dict\YodaoDict.exe"
return

; Win+M ��С�����д���(��Win+D�������Ǳ�ǩ������С������˰�Win+Dӳ��ΪWin+M)
; ���ַ�ʽ��Ҫ�Բ��󣬶��ҿ���ʹ��Win+D��Ч��
;#D::Send #M

; CMD: Win+N ���ı��༭�� (N-Notepad++)
#N::
IfWinExist Notepad++
	WinActivate
else
	Run "C:\Program Files\Notepad++\notepad++.exe"
return

; CMD: Win+H �򿪻������� (H-Huohu)
#H::
IfWinExist Mozilla Firefox
    WinActivate
else
	Run "D:\Program Files\FirefoxPortable\FirefoxPortable.exe"
return
	
; CMD: Win+C ��Chrome����� (C-Chrome)
#C::
IfWinExist Chromium
    WinActivate
else
	Run "D:\Program Files\chrome-win32\chrome.exe"
return

; CMD: Win+V ��Visual Studio (V-VisualStudio)
#V::
IfWinExist Microsoft Visual Studio
    WinActivate
else 
	Run "C:\Program Files\Microsoft Visual Studio 9.0\Common7\IDE\devenv.exe"
return

; CMD: Win+I ��Source Insight (I-Insight)
#I::
IfWinExist Source Insight
    WinActivate
else 
	Run "D:\Program Files\SourceInsight3.50.064\Insight3.exe"
return
	
; CMD: Win+J ��Eclipse (J-Java)
; Win+L��lock windows
#J::
IfWinExist Eclipse
    WinActivate
else 
	Run "D:\Program Files\eclipse-SDK-3.4.2-win32\eclipse\eclipse.exe"
return

; CMD: Win+B ��PDF�Ķ���(B-book)
#B::
IfWinExist Foxit Reader
    WinActivate
else 
	Run "D:\Program Files\Foxit Reader.exe"
return

; CMD: Win+K ��WizKnowledge(K-Knowledge)
#K::
IfWinExist WizExplorer
    WinActivate
else 
	Run "C:\Program Files\WizBrother\Wiz\WizExplorer.exe"
return

; CMD: Win+Q ��QQ(Q-QQ)
; ���ڿ��ܲ�ѯ��������һ���ô˷�����½QQ����
#Q::
IfWinExist QQ
    WinActivate
else 
	Run "D:\Program Files\QQ2009\Bin\QQ.exe"
return

RunOrActive(WinTitle, ExePath)
{
	IfWinExist %WinTitle%
	{
		WinActivate
	}
	else 
	{
		Run %ExePath%
		WinWait %WinTitle%
		WinActivate
	}
	return
}

; CMD: Win+X ��������ʽ���Թ��� (X-RegExp)
#X::RunOrActive("RegEx TestBed", "D:\Tools\CMD\RegExp\RegEx TestBed.exe")

/* IfWinExist RegEx TestBed
    WinActivate
else 
{
	Run "D:\Tools\CMD\RegExp\RegEx TestBed.exe"
	WinWait RegEx TestBed
	WinActivate
}
return
 */

; Note: From now on whenever you run AutoHotkey directly, this script
; will be loaded.  So feel free to customize it to suit your needs.

; Please read the QUICK-START TUTORIAL near the top of the help file.
; It explains how to perform common automation tasks such as sending
; keystrokes and mouse clicks.  It also explains more about hotkeys.

