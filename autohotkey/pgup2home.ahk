; ��Щ���ԣ���������E43A��PageUp��Home��ͬһ����(PageDownҲ������)�����밴סFn��������Home�ĺ��塣
; ���ڳ���Ա��˵��ʹ��Home��End��Ƶ�ʺܸߣ����ⰴסһ��������ʹ�ã�Ҳ��һ�ָ��������һ����ɲ��õ�ϰ�ߡ�
; ��ˣ�д�����AHK�ű�����Fn���������������÷�����������PageUp��ΪHome��Fn+PageUp��ΪHome������PageDownҲ�����ƴ���

; �ʼǱ�����Fn���£�����ʹ��End��Home���ܲ����㣬������PgUp/PgDn����������
PgDn::Send {End}
PgUp::Send {Home}
End::Send {PgDn}
Home::Send {PgUp}

; shiftѡ��
+PgDn::Send +{End}
+PgUp::Send +{Home}
+End::Send +{PgDn}
+Home::Send +{PgUp}

; ctrl+home�ļ���;ctrl+end�ļ�β��
^PgDn::Send ^{End}
^PgUp::Send ^{Home}
^End::Send ^{PgDn}
^Home::Send ^{PgUp}
