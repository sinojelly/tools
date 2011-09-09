;主要函数[获取进程路径]来自论坛网友(hughman)帮助,谢谢你
;~ ========= 获取进程路径 =========
GetModuleFileNameEx( p_pid )
{
   if A_OSVersion in WIN_95,WIN_98,WIN_ME
   {
      MsgBox, This Windows version (%A_OSVersion%) is not supported.
      return
   }

   h_process := DllCall( "OpenProcess", "uint", 0x10|0x400, "int", false, "uint", p_pid )
   if ( ErrorLevel or h_process = 0 )
      return

   name_size = 255
   VarSetCapacity( name, name_size )

   result := DllCall( "psapi.dll\GetModuleFileNameExA", "uint", h_process, "uint", 0, "str", name, "uint", name_size )

   DllCall( "CloseHandle", h_process )

   return, name
}


; CMD: Ctrl+Win+E   一键打开当前激活窗口应用程序的所在目录
^#E:: 
WinGet,PID,PID,A
NowRoute:=GetModuleFileNameEx(PID)
SplitPath,NowRoute,NowFile,NowDir
;MsgBox %NowRoute%
aaa=explorer.exe /select ,"%NowRoute%"
Run,%aaa%
Return
