

; CMD: Win+= 计算光标所在行的表达式
; 把结果以"=result"的形式显示出来。
#=:: ; 选中公式,调用计算器进行运算并粘贴结果到=号后
        {
        clipboard = ; 首先清空剪贴板
        SendInput, {Shift Down}{Home}{Shift Up} ; 接下来选择要计算的公式
        Sleep,100
        SendInput,^c 
        FileDelete,%A_ScriptDir%\temp_calculate.ahk ;循环使用辅助脚本的措施.
        Sleep,100
        FileAppend,
        (
        d:=Round(%Clipboard%,3)  ; 在摇篮中把结果给扼杀成三位小数点
        Clipboard = `%d`% ; `号是为了保留％号的原意
        Return
        )
        ,%A_ScriptDir%\temp_calculate.ahk
        Sleep,100
        Run,%A_ScriptDir%\temp_calculate.ahk ; 运行辅助脚本
        Sleep,100
        WinActivate, Notepad++
        SendInput,{End}=^v{Enter}  ; 粘贴结果,并拿等号作分隔 
        Return
        }