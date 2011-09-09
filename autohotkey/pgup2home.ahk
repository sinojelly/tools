; 有些电脑（比如联想E43A，PageUp和Home是同一个键(PageDown也是类似)，必须按住Fn，它才是Home的含义。
; 对于程序员来说，使用Home和End的频率很高，额外按住一个键才能使用，也是一种负担，而且会养成不好的习惯。
; 因此，写了这个AHK脚本，把Fn对这两个键的作用反过来，即把PageUp改为Home，Fn+PageUp改为Home，对于PageDown也是类似处理。

; 笔记本电脑Fn按下，才能使用End和Home，很不方便，把它和PgUp/PgDn交换过来。
PgDn::Send {End}
PgUp::Send {Home}
End::Send {PgDn}
Home::Send {PgUp}

; shift选择
+PgDn::Send +{End}
+PgUp::Send +{Home}
+End::Send +{PgDn}
+Home::Send +{PgUp}

; ctrl+home文件首;ctrl+end文件尾。
^PgDn::Send ^{End}
^PgUp::Send ^{Home}
^End::Send ^{PgDn}
^Home::Send ^{PgUp}
