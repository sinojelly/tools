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

#include %A_ScriptDir%\params.ahk
#include %A_ScriptDir%\WinManip.ahk


; ���ô��ڲ���ʱָ���Ĺؼ��ֿ����Ǵ��ڱ��������λ��
SetTitleMatchMode 2

#include %A_ScriptDir%\supercalc.ahk
#include %A_ScriptDir%\cmd2dir.ahk
#include %A_ScriptDir%\pgup2home.ahk
#include %A_ScriptDir%\exepath.ahk


; ���Ʊ��ű�������
; TODO: ��Ȼ��������ͣ�ˣ�ͼ���죬����û��������Ч
;^!P::Pause  ; ��Ctrl+Alt+P��ͣ���ٰ�һ����ָ����С�


;=============================================================
; ======= �ı��༭��(N - Notepad) ========
; CMD: Win+N ���ı��༭�� (N-Notepad++)
#N::RunOrActive(win_editor_name, win_editor_path)

; CMD: Ctrl+Win+N ��Notepad++��ѡ�е��ļ�
; ��Explorer���ڲ���Ч������Explorer���ڵ�class���������ȼ���Group  TODO:������������
;GroupAdd, ExploreClass, ahk_class ExploreWClass
;GroupAdd, ExploreClass, ahk_class CabinetWClass
;#IfWinActive ahk_group ExploreClass
^#N::
ClipBoard =
Send,^c
ClipWait   ;�ȴ����ƶ��������
run %win_editor_path% %ClipBoard%
return
;#IfWinActive

; CMD: Ctrl+Win+U ��UtraEdit��ѡ�е��ļ�
^#U::
ClipBoard =
Send,^c
ClipWait   ;�ȴ����ƶ��������
run %ue_path% %ClipBoard%
return

;=============================================================
; ======= ������(P - Programming) ========
; CMD: Win+P ��Visual Studio 
#P::RunOrActive(vc_name, vc_path)

; CMD: Ctrl+Win+P ��Source Insight 
^#P::RunOrActive(si_name, si_path)
	
; CMD: Ctrl+P ��Eclipse 
^P::RunOrActive(eclipse_name, eclipse_path)

; CMD: Ctrl+Win+R ��������ʽ���Թ��� (R-RegExp)
^#R::RunOrActive(regexp_tool_name, regexp_tool_path)


;=============================================================
; ======= �������(Comunication) ========
; CMD: Win+Q ��QQ
; ���ڿ��ܲ�ѯ��������һ���ô˷�����½QQ����
;#Q::RunOrActive(qq_name, qq_path)
#Q::Run %qq_path%

; depracate: Win+T ������������
;#T::RunOrActive(ctrl_win_talk_name, ctrl_win_talk_path)

;=============================================================
; ======= �������(T - Task) ========
; CMD: Win+T ��Google Task�������
;#T::Run C:\Users\jelly\AppData\Local\Google\Chrome\Application\chrome.exe --app="https://mail.google.com/tasks/ig?pli=1"
#T::RunOrActive(gtask_name, gtask_path)

; CMD: Ctrl+Win+T ��Google ����
^#T::RunOrActive(gcalendar_name, gcalendar_path)

;=============================================================
; ======= �����(I - Internet) ========
; CMD: Win+I ��Chrome����� 
#I::RunOrActive(win_internet_name, win_internet_path)

; CMD: Ctrl+Win+I �򿪻������� 
^#I::RunOrActive(ctrl_win_internet_name, ctrl_win_internet_path)

; CMD: Ctrl+I ����Proxy 
; ��RunOrActive�������к��޷�����bat�ˡ�
^I::Run %ctrl_internet_proxy_path%


;=============================================================	
; ======= ����(D - Download) ========
; CMD: Ctrl+Win+D �������ع��� (D-Download)
^#D::RunOrActive(ctrl_win_download_name, ctrl_win_download_path)

; CMD: Ctrl+Alt+D ������Ŀ¼ (D-Download)
^!D::Run %download_dir%


;=============================================================
; ======= ����(F - Financial ) ========
; CMD: Ctrl+Win+F �򿪼������ 
^#F::RunOrActive(ctrl_win_financial_name, ctrl_win_financial_path)


;=============================================================
; ======= ͼ��ͼ����(G - Graphic ) ========
; CMD: Win+PrtSc ��ץͼ���
#PrintScreen::RunOrActive(snap_name, snap_path)


;=============================================================
; ======= ����(L - Language ) ========
; CMD: Win+W ���дʵ� 
#W::RunOrActive(dict_name, dict_path)


;=============================================================
; ======= ֪ʶ����(K - Knowledge ) ========
; CMD: Win+K ��WizKnowledge
#K::RunOrActive(win_knowledge_name, win_knowledge_path)


;=============================================================
; ======= �鼮 ========
; CMD: Win+B �����
#B::RunOrActive(bookshelf_name, bookshelf_path)


;=============================================================
; ======= Ŀ¼·���Ĳ��� ========
; CMD: Alt+R ����򿪵���Ŀ(�ļ�/�ļ���) (R-Recent)
!R::Run %recent_dir%

; CMD: Win+A ���ļ��������� (��Everything�����е������)
; ������������ڲ����ˣ�������Ҳ������������󲻻�������ݿ⣬���Ǻܿ죬ֻ����Ҫȷ�Ϸ���Ӳ��
; CMD: Ctrl+Win+A �����ļ��������� (����Everything)
^#A::Run %everything_path%

; CMD: Ctrl+Win+C ��ѡ���ļ�·�����Ƶ�������
; ��Ctrl+C���ƣ������ļ���˵���ڽ�����ת�����ı���ʽ�����ļ���·��, ͨ��һ��������ת�Ϳ��԰��ļ�·���ַ����浽�����塣
^#C::
ClipBoard =
Send,^c
ClipWait   ;�ȴ����ƶ��������
FilePath= %ClipBoard%
ClipBoard = %FilePath%
return 


; Win+M ��С�����д���(��Win+D�������Ǳ�ǩ������С������˰�Win+Dӳ��ΪWin+M)
; ���ַ�ʽ��Ҫ�Բ��󣬶��ҿ���ʹ��Win+D��Ч��
;#D::Send #M



;=============================================================
; ======= Openһ�� ========
; CMD: 0ue  ��UE 
; ��Ȼ���뻻�в�����Ч
; ʹ��ʱ���ڱ༭λ�����롰openue�ո񡱣�����ַ�����ʧ����ִ�����
::0ue::
Run %ue_path%
return

; CMD: 0vc  ��VC
::0vc::
Run %vc_path%
return

; CMD: 0si  ��Source Insight
::0si::
Run %si_path%
return





; Note: From now on whenever you run AutoHotkey directly, this script
; will be loaded.  So feel free to customize it to suit your needs.

; Please read the QUICK-START TUTORIAL near the top of the help file.
; It explains how to perform common automation tasks such as sending
; keystrokes and mouse clicks.  It also explains more about hotkeys.

