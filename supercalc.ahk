

; CMD: Win+= �����������еı��ʽ
; �ѽ����"=result"����ʽ��ʾ������
#=:: ; ѡ�й�ʽ,���ü������������㲢ճ�������=�ź�
        {
        clipboard = ; ������ռ�����
        SendInput, {Shift Down}{Home}{Shift Up} ; ������ѡ��Ҫ����Ĺ�ʽ
        Sleep,100
        SendInput,^c 
        FileDelete,%A_ScriptDir%\temp_calculate.ahk ;ѭ��ʹ�ø����ű��Ĵ�ʩ.
        Sleep,100
        FileAppend,
        (
        d:=Round(%Clipboard%,3)  ; ��ҡ���аѽ������ɱ����λС����
        Clipboard = `%d`% ; `����Ϊ�˱������ŵ�ԭ��
        Return
        )
        ,%A_ScriptDir%\temp_calculate.ahk
        Sleep,100
        Run,%A_ScriptDir%\temp_calculate.ahk ; ���и����ű�
        Sleep,100
        WinActivate, Notepad++
        SendInput,{End}=^v{Enter}  ; ճ�����,���õȺ����ָ� 
        Return
        }