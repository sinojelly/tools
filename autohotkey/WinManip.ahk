
; Window Manipulation


; 如果程序未启动：启动并且激活它
; 如果程序未激活：激活它
; 如果程序激活的：最小化它
; 调用示例：#X::RunOrActive("RegEx TestBed", "D:\Tools\CMD\RegExp\RegEx TestBed.exe")  注意引号是必须的，起码有空格时是这样。
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