;��Ҫ����[��ȡ����·��]������̳����(hughman)����,лл��
;~ ========= ��ȡ����·�� =========
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


; CMD: Ctrl+Win+E   һ���򿪵�ǰ�����Ӧ�ó��������Ŀ¼
^#E:: 
WinGet,PID,PID,A
NowRoute:=GetModuleFileNameEx(PID)
SplitPath,NowRoute,NowFile,NowDir
;MsgBox %NowRoute%
aaa=explorer.exe /select ,"%NowRoute%"
Run,%aaa%
Return
