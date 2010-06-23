; Stuff to do when Windows Explorer is open
;

; CMD: Win+C  �ڵ�ǰλ�ô�������
#C::
hWnd := WinExist("A")
WinGetClass wClass, ahk_id %hWnd%
If (wClass != "ExploreWClass" and wClass != "CabinetWClass")
    MsgBox Use this only with a Windows Explorer window!
Else
    OpenCmdInCurrent()
return

; Opens the command shell 'cmd' in the directory browsed in Explorer.
; Note: expecting to be run when the active window is Explorer.
;
OpenCmdInCurrent()
{
    WinGetText, full_path, A  ; This is required to get the full path of the file from the address bar

    ; Split on newline (`n)
    StringSplit, word_array, full_path, `n
    full_path = %word_array1%   ; Take the first element from the array
	;MsgBox %full_path%

    ; Just in case - remove all carriage returns (`r)
    StringReplace, full_path, full_path, `r, , all 
	full_path := substr(full_path, strlen("��ַ: ")) ; ����ַ: ������ַ���������ϵͳ���
	;msgbox %full_path%
    IfInString full_path, \
    {
		Run, cmd /V:ON /K cd /D "%full_path%" & call %GD_TOOL%\path\setEnv.bat
    }
    else
    {
        Run, cmd /K cd /D "C:\ "
    }
}
