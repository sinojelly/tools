
; Window Manipulation


; �������δ�������������Ҽ�����
; �������δ���������
; ������򼤻�ģ���С����
; ����ʾ����#X::RunOrActive("RegEx TestBed", "D:\Tools\CMD\RegExp\RegEx TestBed.exe")  ע�������Ǳ���ģ������пո�ʱ��������
RunOrActive(WinTitle, ExePath)
{
	IfWinExist %WinTitle%
	{
		IfWinNotActive %WinTitle%
			WinActivate
		Else
			WinMinimize
	}
	else 
	{
		Run %ExePath%
		WinWait %WinTitle%
		WinActivate
	}
	return
}