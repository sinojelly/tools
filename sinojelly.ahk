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

; 例子：Win+z 在浏览器中打开autohotkey主页
; #z::Run www.autohotkey.com

; 例子：ctrl+alt+n 打开notepad
; ^!n::
; IfWinExist Untitled - Notepad
; 	WinActivate
; else
; 	Run Notepad
; return

#include WinManip.ahk

; 设置窗口查找时指定的关键字可以是窗口标题的任意位置
SetTitleMatchMode 2

; 笔记本电脑Fn按下，才能使用End和Home，很不方便，把它和PgUp/PgDn交换过来。
PgDn::Send {End}
PgUp::Send {Home}
End::Send {PgDn}
Home::Send {PgUp}

; shift选择
+PgDn::Send +{End}
+PgUp::Send +{Home}
+End::Send +{PgDn}
+Home::Send +{PgUp}

; ctrl+home文件首;ctrl+end文件尾。
^PgDn::Send ^{End}
^PgUp::Send ^{Home}
^End::Send ^{PgDn}
^Home::Send ^{PgUp}

; CMD: Alt+R 最近打开的项目(文件/文件夹) (R-Recent)
!R::Run "C:\Users\jelly\AppData\Roaming\Microsoft\Windows\Recent\"

; CMD: Win+PrtSc 打开抓图软件
#PrintScreen::RunOrActive("HyperSnap", "D:\Program Files\HyperSnap 6\HprSnap6.exe")

; CMD: Win+P 启动Proxy (P-Proxy)
; 用RunOrActive则多次运行后无法启动bat了。
#P::Run "D:\Tools\CMD\ssh\ssh_start.bat"

; CMD: Ctrl+Win+D 启动下载工具 (D-Download)
^#D::RunOrActive("迅雷", "C:\Program Files\Thunder Network\Thunder\Program\Thunder.exe")

; CMD: Ctrl+D 打开下载目录 (D-Download)
^D::Run "D:\Users\Downloads"

; CMD: Win+A 打开文件搜索工具 (在Everything已运行的情况下)
; 如果任务栏窗口不见了，则可能找不到，但启动后不会更新数据库，还是很快，只是需要确认访问硬盘
; CMD: Ctrl+Win+A 启动文件搜索工具 (启动Everything)
^#A::Run "D:\Tools\CMD\Everything-1.2.1.371\Everything-1.2.1.371.exe"

; CMD: Win+W 运行词典 (W-Word)
#W::RunOrActive("有道词典", "C:\Program Files\Youdao\Dict\YodaoDict.exe")

; Win+M 最小化所有窗口(与Win+D的区别是便签不会最小化。因此把Win+D映射为Win+M)
; 这种方式必要性不大，而且可能使得Win+D无效。
;#D::Send #M

; CMD: Win+N 打开文本编辑器 (N-Notepad++)
#N::RunOrActive("Notepad++", "C:\Program Files\Notepad++\notepad++.exe")

; CMD: Win+H 打开火狐浏览器 (H-Huohu)
#H::RunOrActive("Mozilla Firefox", "D:\Program Files\FirefoxPortable\FirefoxPortable.exe")
	
; CMD: Win+C 打开Chrome浏览器 (C-Chrome)
#C::RunOrActive("Chromium", "D:\Program Files\chrome-win32\chrome.exe")

; CMD: Win+V 打开Visual Studio (V-VisualStudio)
#V::RunOrActive("Microsoft Visual Studio", "C:\Program Files\Microsoft Visual Studio 9.0\Common7\IDE\devenv.exe")

; CMD: Win+I 打开Source Insight (I-Insight)
#I::RunOrActive("Source Insight", "D:\Program Files\SourceInsight3.50.064\Insight3.exe")
	
; CMD: Win+J 打开Eclipse (J-Java)
; Win+L是lock windows
#J::RunOrActive("Eclipse", "D:\Program Files\eclipse-SDK-3.4.2-win32\eclipse\eclipse.exe")

; CMD: Win+B 打开PDF阅读器(B-book)
#B::RunOrActive("Foxit Reader", "D:\Program Files\Foxit Reader.exe")

; CMD: Win+K 打开WizKnowledge(K-Knowledge)
#K::RunOrActive("WizExplorer", "C:\Program Files\WizBrother\Wiz\WizExplorer.exe")

; CMD: Win+Q 打开QQ(Q-QQ)
; 窗口可能查询不到，第一次用此方法登陆QQ即可
#Q::RunOrActive("QQ", "D:\Program Files\QQ2009\Bin\QQ.exe")

; CMD: Win+X 打开正则表达式测试工具 (X-RegExp)
#X::RunOrActive("RegEx TestBed", "D:\Tools\CMD\RegExp\RegEx TestBed.exe")


; Note: From now on whenever you run AutoHotkey directly, this script
; will be loaded.  So feel free to customize it to suit your needs.

; Please read the QUICK-START TUTORIAL near the top of the help file.
; It explains how to perform common automation tasks such as sending
; keystrokes and mouse clicks.  It also explains more about hotkeys.

