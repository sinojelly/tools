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

#include %A_ScriptDir%\params.ahk
#include %A_ScriptDir%\WinManip.ahk


; 设置窗口查找时指定的关键字可以是窗口标题的任意位置
SetTitleMatchMode 2

#include %A_ScriptDir%\supercalc.ahk
#include %A_ScriptDir%\cmd2dir.ahk
#include %A_ScriptDir%\pgup2home.ahk
#include %A_ScriptDir%\exepath.ahk


; 控制本脚本的运行
; TODO: 虽然看起来暂停了，图标变红，但是没有真正生效
;^!P::Pause  ; 按Ctrl+Alt+P暂停，再按一次则恢复运行。


;=============================================================
; ======= 文本编辑器(N - Notepad) ========
; CMD: Win+N 打开文本编辑器 (N-Notepad++)
#N::RunOrActive(win_editor_name, win_editor_path)

; CMD: Ctrl+Win+N 用Notepad++打开选中的文件
; 在Explorer窗口才有效，由于Explorer窗口的class有两个，先加入Group  TODO:不能正常工作
;GroupAdd, ExploreClass, ahk_class ExploreWClass
;GroupAdd, ExploreClass, ahk_class CabinetWClass
;#IfWinActive ahk_group ExploreClass
^#N::
ClipBoard =
Send,^c
ClipWait   ;等待复制动作的完成
run %win_editor_path% %ClipBoard%
return
;#IfWinActive

; CMD: Ctrl+Win+U 用UtraEdit打开选中的文件
^#U::
ClipBoard =
Send,^c
ClipWait   ;等待复制动作的完成
run %ue_path% %ClipBoard%
return

;=============================================================
; ======= 编程软件(P - Programming) ========
; CMD: Win+P 打开Visual Studio 
#P::RunOrActive(vc_name, vc_path)

; CMD: Ctrl+Win+P 打开Source Insight 
^#P::RunOrActive(si_name, si_path)
	
; CMD: Ctrl+P 打开Eclipse 
^P::RunOrActive(eclipse_name, eclipse_path)

; CMD: Ctrl+Win+R 打开正则表达式测试工具 (R-RegExp)
^#R::RunOrActive(regexp_tool_name, regexp_tool_path)


;=============================================================
; ======= 交流软件(Comunication) ========
; CMD: Win+Q 打开QQ
; 窗口可能查询不到，第一次用此方法登陆QQ即可
;#Q::RunOrActive(qq_name, qq_path)
#Q::Run %qq_path%

; depracate: Win+T 打开网易闪电邮
;#T::RunOrActive(ctrl_win_talk_name, ctrl_win_talk_path)

;=============================================================
; ======= 任务管理(T - Task) ========
; CMD: Win+T 打开Google Task任务管理
;#T::Run C:\Users\jelly\AppData\Local\Google\Chrome\Application\chrome.exe --app="https://mail.google.com/tasks/ig?pli=1"
#T::RunOrActive(gtask_name, gtask_path)

; CMD: Ctrl+Win+T 打开Google 日历
^#T::RunOrActive(gcalendar_name, gcalendar_path)

;=============================================================
; ======= 浏览器(I - Internet) ========
; CMD: Win+I 打开Chrome浏览器 
#I::RunOrActive(win_internet_name, win_internet_path)

; CMD: Ctrl+Win+I 打开火狐浏览器 
^#I::RunOrActive(ctrl_win_internet_name, ctrl_win_internet_path)

; CMD: Ctrl+I 启动Proxy 
; 用RunOrActive则多次运行后无法启动bat了。
^I::Run %ctrl_internet_proxy_path%


;=============================================================	
; ======= 下载(D - Download) ========
; CMD: Ctrl+Win+D 启动下载工具 (D-Download)
^#D::RunOrActive(ctrl_win_download_name, ctrl_win_download_path)

; CMD: Ctrl+Alt+D 打开下载目录 (D-Download)
^!D::Run %download_dir%


;=============================================================
; ======= 财务(F - Financial ) ========
; CMD: Ctrl+Win+F 打开记账软件 
^#F::RunOrActive(ctrl_win_financial_name, ctrl_win_financial_path)


;=============================================================
; ======= 图形图像处理(G - Graphic ) ========
; CMD: Win+PrtSc 打开抓图软件
#PrintScreen::RunOrActive(snap_name, snap_path)


;=============================================================
; ======= 语言(L - Language ) ========
; CMD: Win+W 运行词典 
#W::RunOrActive(dict_name, dict_path)


;=============================================================
; ======= 知识管理(K - Knowledge ) ========
; CMD: Win+K 打开WizKnowledge
#K::RunOrActive(win_knowledge_name, win_knowledge_path)


;=============================================================
; ======= 书籍 ========
; CMD: Win+B 打开书架
#B::RunOrActive(bookshelf_name, bookshelf_path)


;=============================================================
; ======= 目录路径的操作 ========
; CMD: Alt+R 最近打开的项目(文件/文件夹) (R-Recent)
!R::Run %recent_dir%

; CMD: Win+A 打开文件搜索工具 (在Everything已运行的情况下)
; 如果任务栏窗口不见了，则可能找不到，但启动后不会更新数据库，还是很快，只是需要确认访问硬盘
; CMD: Ctrl+Win+A 启动文件搜索工具 (启动Everything)
^#A::Run %everything_path%

; CMD: Ctrl+Win+C 把选中文件路径复制到剪贴板
; 用Ctrl+C复制，对于文件来说，内建变量转换成文本格式就是文件的路径, 通过一个变量中转就可以把文件路径字符串存到剪贴板。
^#C::
ClipBoard =
Send,^c
ClipWait   ;等待复制动作的完成
FilePath= %ClipBoard%
ClipBoard = %FilePath%
return 


; Win+M 最小化所有窗口(与Win+D的区别是便签不会最小化。因此把Win+D映射为Win+M)
; 这种方式必要性不大，而且可能使得Win+D无效。
;#D::Send #M



;=============================================================
; ======= Open一族 ========
; CMD: 0ue  打开UE 
; 居然必须换行才能生效
; 使用时，在编辑位置输入“openue空格”，则该字符串消失，并执行命令。
::0ue::
Run %ue_path%
return

; CMD: 0vc  打开VC
::0vc::
Run %vc_path%
return

; CMD: 0si  打开Source Insight
::0si::
Run %si_path%
return





; Note: From now on whenever you run AutoHotkey directly, this script
; will be loaded.  So feel free to customize it to suit your needs.

; Please read the QUICK-START TUTORIAL near the top of the help file.
; It explains how to perform common automation tasks such as sending
; keystrokes and mouse clicks.  It also explains more about hotkeys.

