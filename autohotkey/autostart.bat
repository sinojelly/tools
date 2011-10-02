cd /d %~dp0

reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run" /v "脚本文件名" /d "%cd%\sinojelly.ahk"

