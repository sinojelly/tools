/*说明:
该宏文件实现一些编码程中能会到的功能, 如添加文件头、函数说明和宏定义等, 
使用时能自动添加文件名、函数名和当前日期.

使用说明:
1. Project->Open Project... 打开Base工程
(该工程一般在"我的文档\Source Insight\Projects\Base"中);
2. Project->Add and Remove Project Files... 加入宏文件(即Franco.em);
3. Options->Menu Assignments 打开Menu Assignments窗口, 在Command中输入Macro, 
选中要使用的宏, 添加到合适的菜单中.

附上宏定义文件*/

/* Franco.em - a small collection of useful editing macros */

macro getMyName()
{
return "chenguodong"
}

macro MyInsFileHeader()
{
szMyName = getMyName()
szTime = GetSysTime(1)
date = getDate()
Day = szTime.Day
Month = szTime.Month
Year = szTime.Year
if (Day < 10) {
   szDay = "0@Day@"
}else {
   szDay = Day
}

hBuf = GetCurrentBuf()
szpathName = GetBufName(hBuf)
szfileName = GetFileName(szpathName)
nlength = StrLen(szfileName)
// szInf = Ask("Enter the information of file:")
szDescription = ""

hbuf = GetCurrentBuf()
InsBufLine(hbuf, 0, "/******************************************************************************")
InsBufLine(hbuf, 1, " * Filename : @szfileName@")
InsBufLine(hbuf, 2, " * Copyright: Copyright 2007 O2Micro, Inc")
InsBufLine(hbuf, 3, " * Created : @date@ by @szMyName@")
InsBufLine(hbuf, 4, " * Description -")
InsBufLine(hbuf, 5, " * @szDescription@")
InsBufLine(hbuf, 6, " ******************************************************************************/")
InsBufLine(hbuf, 7, "")

// InsBufLine(hbuf, 6, " ******************************************************************************")
// InsBufLine(hbuf, 7, " * cvs log info:")
// InsBufLine(hbuf, 8, " * $Log: @szfileName@,v $")
// InsBufLine(hbuf, 9, " ******************************************************************************/")
// InsBufLine(hbuf, 10, "")

SetBufIns(hbuf, 5, 3)
}

// 找到当前函数/类的行号.(即使有函数重载也能支持)
macro GetCurSymbolLine()
{
    symbol = GetCurSymbol()

    hCurBuf = GetCurrentBuf()
    szCurFile = GetBufName(hCurBuf)
    lnCur = GetBufLnCur(hCurBuf)

    //msg ("File: " # szCurFile # "  lnCur: " # lnCur # "  symbol: " #symbol)

    //symbol = Ask("What symbol do you want to locate?")
    hbuf = NewBuf("output")
    count = GetSymbolLocationEx(symbol, hbuf, 1, 1, 1)

    if (count < 1)
    {
        CloseBuf(hbuf)
        return -1
    }

    if (count == 1) // 不存在多个同名符号
    {
        // 如果找到的符号与当前文件名不符则返回0.(因为cpp文件中有时在函数外面GetCurSymbol也返回类名，会找到h中的定义处。)
        loc = GetBufLine(hbuf, 0)
        //msg (loc.file # " loc::::and::::cur " # szCurFile)
        if (szCurFile != loc.file)
        {
            CloseBuf(hbuf)
            return -1
        }
        
        ln = GetSymbolLine(symbol)
        CloseBuf(hbuf)
        return ln
    }

    nearCurLn = -1   // 找比当前行号小的最大行号
    
    ln = 0
    while (ln < count)
    {
        loc = GetBufLine(hbuf, ln)
        //msg (loc.file # " at line " # loc.lnFirst)

        if ((szCurFile == loc.file) && (loc.lnFirst <= lnCur))
        {
            if (nearCurLn < loc.lnFirst)
            {
                nearCurLn = loc.lnFirst
            }            
        }
        
        ln = ln + 1

    }
    CloseBuf(hbuf)

    return nearCurLn
}

// 找到当前函数/类的行号.(即使有函数重载也能支持)
macro GetCurSymbolLoc()
{
    symbol = GetCurSymbol()

    hCurBuf = GetCurrentBuf()
    szCurFile = GetBufName(hCurBuf)
    lnCur = GetBufLnCur(hCurBuf)

    //msg ("File: " # szCurFile # "  lnCur: " # lnCur # "  symbol: " #symbol)

    //symbol = Ask("What symbol do you want to locate?")
    hbuf = NewBuf("output")
    count = GetSymbolLocationEx(symbol, hbuf, 1, 1, 1)

    if (count < 1)
    {
        CloseBuf(hbuf)
        return ""
    }

    if (count == 1) // 不存在多个同名符号
    {
        // 如果找到的符号与当前文件名不符则返回0.(因为cpp文件中有时在函数外面GetCurSymbol也返回类名，会找到h中的定义处。)
        loc = GetBufLine(hbuf, 0)
        //msg (loc.file # " loc::::and::::cur " # szCurFile)
        if (szCurFile != loc.file)
        {
            CloseBuf(hbuf)
            return ""
        }
        
        //ln = GetSymbolLine(symbol)
        CloseBuf(hbuf)
        //return ln
        return loc
    }

    nearCurLn = -1   // 找比当前行号小的最大行号
    nearCurLoc = ""
    
    ln = 0
    while (ln < count)
    {
        loc = GetBufLine(hbuf, ln)
        //msg (loc.file # " at line " # loc.lnFirst)

        if ((szCurFile == loc.file) && (loc.lnFirst <= lnCur))
        {
            if (nearCurLn < loc.lnFirst)
            {
                nearCurLn = loc.lnFirst
                nearCurLoc = loc
            }            
        }
        
        ln = ln + 1

    }
    CloseBuf(hbuf)

    //return nearCurLn
    return nearCurLoc
}

/**
在函数中任何位置触发这个宏，就可以在该函数前面加上函数/类头
如果函数有多个重载形式，GetSymbolLine需要用户选择一个。去掉该函数调用。chenguodong
*/
macro MyInsFunHeader()
{
szMyName = getMyName()

hbuf = GetCurrentBuf()
//szFunc = GetCurSymbol()
//ln = GetSymbolLine(szFunc)
//if(ln < 0) {
//if (strlen(szFunc) <= 0)
ln = GetCurSymbolLine()
if (ln < 0) {
//   msg ("line: @ln@, focus should be in a function!")
   return
}
symLnFirst = ln
date = getDateTime()
brief = Ask("请输入简述:")
InsBufLine(hbuf, ln ++, "/**")
InsBufLine(hbuf, ln ++, " 简述: @brief@.")
InsBufLine(hbuf, ln ++, " 详述: ")
InsBufLine(hbuf, ln ++, " ")
// 当前行或者上一行有template的需要考虑模板参数.(认为template不可能换行)
InsBufLine(hbuf, ln ++, " \\param ")
InsBufLine(hbuf, ln ++, " \\return ")
InsBufLine(hbuf, ln ++, " ")
InsBufLine(hbuf, ln ++, " \\internal 其它的section标记(eg:\\\\todo,\\\\bug,\\\\example,\\\\remark,\\\\sa(see also),\\\\since,\\")
InsBufLine(hbuf, ln ++, " \\\\throw,\\\\warning,\\\\deprecated)等放在这里或者放在历史记录中的版本描述中.")
InsBufLine(hbuf, ln ++, " ")
InsBufLine(hbuf, ln ++, " \\internal 历史记录:")
InsBufLine(hbuf, ln ++, " \\version 1.0")
InsBufLine(hbuf, ln ++, " \\author @szMyName@")
InsBufLine(hbuf, ln ++, " \\assessor ")
InsBufLine(hbuf, ln ++, " \\create")
InsBufLine(hbuf, ln ++, " time @date@")
InsBufLine(hbuf, ln ++, " V1.0说明: 创建函数/类.")
InsBufLine(hbuf, ln ++, "*/")

SetBufIns(hbuf, symLnFirst + 2, 7) // 光标停在详述之后
}

macro testDevelop()
{
    loc = GetCurSymbolLoc()
    if (loc == "")
    {
        msg ("loc is null.")
        return
    }
    msg ("Symbol:" # loc.Symbol # "Type:" # loc.Type # " lnFirst:" # loc.lnFirst # " lnName:" # loc.lnName # " ichName:" # loc.ichName)
}

/* insert head file define */
macro MyInsHDef()
{
hBuf = GetCurrentBuf()
szpathName = GetBufName(hBuf)
szfileName = GetFileName(szpathName)
szfileName = toupper(szfileName)
nlength = StrLen(szfileName)
i = 0
szdefineName = ""
while (i < nlength) {
   if (szfileName[i] == ".") {
    szdefineName = Cat(szdefineName, "_")
   }else {
    szdefineName = Cat(szdefineName, szfileName[i])
   }
   i = i + 1
}
szdefineName = Cat("_", szdefineName)
szdefineName = Cat(szdefineName, "_")
IfdefineSz(szdefineName)
}

macro MyInsCommentInLine()
{ 
hwnd = GetCurrentWnd()
lnFirst = GetWndSelLnFirst(hwnd)
lnLast = GetWndSelLnLast(hwnd)
hbuf = GetCurrentBuf()

if(lnLast == lnFirst) {
   hbufText = GetBufSelText(hbuf)
   SetBufSelText(hbuf, "/* @hbufText@ */")
}else {
   InsBufLine(hbuf, lnFirst, "/* ")
   InsBufLine(hbuf, lnLast+2, "*/") 
   SetBufIns( hbuf,lnFirst,3)
}
}

macro MyInsIfDef()
{ 
hwnd = GetCurrentWnd()
lnFirst = GetWndSelLnFirst(hwnd)
lnLast = GetWndSelLnLast(hwnd)

hbuf = GetCurrentBuf()

date = getDateTime();
line = lnFirst+1;
InsBufLine(hbuf, lnFirst, "#ifdef remark_here /* @date@ reason: */")
InsBufLine(hbuf, lnLast+2, "#endif /* #ifdef remark_here (line:@line@)*/")

SetBufIns( hbuf,lnFirst,StrLen(date) + 30)
}

macro GetFileName(pathName)
{
nlength = strlen(pathName)
i = nlength - 1
name = ""
while (i + 1) {
   ch = pathName[i]
   if ("\\" == "@ch@") {
    break
   }
   i = i - 1
}
i = i + 1
while (i < nlength) {
   name = cat(name, pathName[i])
   i = i + 1
}
return name
}

macro getDate()
{ 
szTime = GetSysTime(1)
Year = szTime.Year
Month = szTime.Month
Day = szTime.Day
return "@Year@-@Month@-@Day@"
}

macro getDateTime()
{ 
szTime = GetSysTime(1)
Year = szTime.Year
Month = szTime.Month
Day = szTime.Day
Hour = szTime.Hour
Minute = szTime.Minute
Second = szTime.Second
return "@Year@-@Month@-@Day@ @Hour@:@Minute@:@Second@"
}

/******************************************************************************
 * PrintTime - print date time on where the cursor point to
 * DESCRIPTION: -
 *
 * Input:
 * Output:
 * Returns:
 *
 * modification history
 * --------------------
 * 01a, 23mar2003, t357 written
 * --------------------
 ******************************************************************************/
macro PrintTime()
{
 szTime = getDateTime()
 szMyName = getMyName()
 hbuf = GetCurrentBuf()
 ln = GetBufLnCur(hbuf)
 szCurLine = GetBufLine(hbuf, ln)
 DelBufLine(hbuf, ln)
 InsBufLine(hbuf, ln, "@szCurLine@ @szMyName@ @szTime@")
 SetBufIns(hbuf, ln, StrLen(szCurLine) + 2 + strlen(szMyName) + strlen(szTime))
}

//在行尾添加添加//lint !e
macro SupressLineLintWarning()
{
 hbuf = GetCurrentBuf()
 ln = GetBufLnCur(hbuf)
 szCurLine = GetBufLine(hbuf, ln)
 DelBufLine(hbuf, ln)
 InsBufLine(hbuf, ln, "@szCurLine@ //lint !e")
 SetBufIns(hbuf, ln, StrLen(szCurLine) + 10)
}

//在行尾添加添加///<
macro ShortLineNote()
{
 hbuf = GetCurrentBuf()
 ln = GetBufLnCur(hbuf)
 szCurLine = GetBufLine(hbuf, ln)
 DelBufLine(hbuf, ln)
 InsBufLine(hbuf, ln, "@szCurLine@ ///< ")
 SetBufIns(hbuf, ln, StrLen(szCurLine) + 6)
}

//在行尾添加添加/**<    */
macro LongLineNote()
{
 hbuf = GetCurrentBuf()
 ln = GetBufLnCur(hbuf)
 szCurLine = GetBufLine(hbuf, ln)
 DelBufLine(hbuf, ln)
 InsBufLine(hbuf, ln, "@szCurLine@ /**<  */")
 SetBufIns(hbuf, ln, StrLen(szCurLine) + 6)
}

// Wrap ifdeinef <sz> .. endif around the current selection
macro IfdefineSz(sz)
{
 hwnd = GetCurrentWnd()
 lnFirst = GetWndSelLnFirst(hwnd)
 lnLast = GetWndSelLnLast(hwnd)

 hbuf = GetCurrentBuf()
 InsBufLine(hbuf, lnFirst, "#ifndef @sz@")
 InsBufLine(hbuf, lnFirst + 1, "#define @sz@")
 InsBufLine(hbuf, lnLast + 3,  "#endif  /* @sz@ */")
 SetBufIns(hbuf, lnFirst + 2, 0)
}


