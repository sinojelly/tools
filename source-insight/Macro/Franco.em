/*说明:
该宏文件实现一些编码程中能会到的功能, 如添加文件头、函数说明和宏定义等, 
使用时能自动添加文件名、函数名和当前日期.

使用说明:
1. Project->Open Project... 打开Base工程
(该工程一般在"我的文档\Source Insight\Projects\Base"中);
2. Project->Add and Remove Project Files... 加入宏文件(即Franco.em);
3. Options->Menu Assignments 打开Menu Assignments窗口, 在Command中输入Macro, 
选中要使用的宏, 添加到合适的菜单中.

*/

/* Franco.em - a small collection of useful editing macros */

macro getMyName()
{
    // 从环境变量中获取用户姓名
    szMyName = GetEnv(SI_USER)
    if (szMyName == "")
    {
        szMyName = Ask("第一次使用请输入您的姓名, 它将出现在自动生成的注释中.")
        PutEnv(SI_USER, szMyName)
    }
    return szMyName
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
szDescription = Ask("请输入文件功能描述:")
//szDescription = ""

hbuf = GetCurrentBuf()
InsBufLine(hbuf, 0, "/******************************************************************************")
InsBufLine(hbuf, 1, " * Filename : @szfileName@")
InsBufLine(hbuf, 2, " * Copyright: Huawei Technologies Co., Ltd. 2009-2019. All rights reserved.")
InsBufLine(hbuf, 3, " * Created : @date@ by @szMyName@")
InsBufLine(hbuf, 4, " * Description: @szDescription@")
InsBufLine(hbuf, 5, " * ")
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

// 反向查找
macro gd_strrch(string, find)
{
    len = strlen(string)

    while (len > 0)
    {
        if (string[len] == find)
        {
            return len
        }
        len = len - 1
    }

    return -1
}

// 反向找到第一个空白字符
macro gd_strrch_ws(string)
{
    spacePos = gd_strrch(string, " ")
    spacePosT = gd_strfind(string, "	")
    pos = gd_min(spacePos, spacePosT)

    return pos
}

// 正向查找
macro gd_strfind(string, find)
{
    len = strlen(string)
    findLen = strlen(find)

    i = 0
    while (i + findLen <= len)
    {
        if (strmid(string, i, i + findLen) == find)
        {
            return i
        }
        i = i + 1
    }

    return -1
}

// 返回忽略了空白字符的字符串
macro gd_skipws(string)
{
    len = strlen(string)
    i = 0
    while ( i < len)
    {
        if ((string[i]==" ") || (string[i]=="	"))
        {
            i = i + 1
        }
        else
        {
            return strmid(string, i, len)
        }
    }

    return ""
}

macro gd_min(a, b)
{
    if (a == -1) // -1为无效值,此函数尽量返回有效值
    {
        return b
    }
    if (b == -1)
    {
        return a
    }
    if (a < b)
    {
        return a
    }
    return b
}

// 跳过一对匹配的beginStr, endStr, (beginStr/endStr都只有一个字节)
macro gd_jumpover_match(string, beginStr, endStr)
{
    beginCnt = 0
    endCnt = 0

    len = strlen(string)
    if (len < 0)
    {
        msg (" match error : input string len < 0. ")
        return string
    }
    
    temp = gd_strfind(string, beginStr)
    if (temp < 0)
    {
        msg (" match error : no start. ")
        return string
    }

    i = 0
    while (i < len)
    {
        tempStr = strmid(string, i, strlen(string))
        beginPos = gd_strfind(tempStr, beginStr)
        beginPos = beginPos + i
        endPos = gd_strfind(tempStr, endStr)
        endPos = endPos + i

        if (endPos == -1) // 不存在endStr了，必然匹配失败
        {
            msg (" match error : no more end. ")
            return string
        }
        
        validMin = gd_min(beginPos, endPos)
        if (validMin == beginPos)
        {
            // 先遇到beginStr
            beginCnt = beginCnt + 1
            i = beginPos + 1
            continue
        }

        endCnt = endCnt + 1

        i = endPos + 1

        if (beginCnt == endCnt)
        {
            return strmid(string, i, strlen(string))
        }
        
    }

    msg (" match error : unknown. ")
    return string 
}

macro gd_space()
{
    return " "
}

macro gd_table()
{
    return "	"
}

macro gd_head_wsnum(string)
{
    rc = ""
    
    rc.spaceCnt = 0
    rc.tableCnt = 0

    len = strlen(string)

    i = 0
    while (i < len) 
    {
        if (string[i] == gd_space())
        {
            rc.spaceCnt = rc.spaceCnt + 1
        }
        else if (string[i] == gd_table())
        {
            rc.tableCnt = rc.tableCnt + 1
        }
        else
        {
            break
        }

        i = i + 1
        
    }

    return rc
}

macro gd_tail_wsnum(string)
{
    rc = ""
    
    rc.spaceCnt = 0
    rc.tableCnt = 0

    len = strlen(string)

    i = len - 1
    while (i >= 0) 
    {
        if (string[i] == gd_space())
        {
            rc.spaceCnt = rc.spaceCnt + 1
        }
        else if (string[i] == gd_table())
        {
            rc.tableCnt = rc.tableCnt + 1
        }
        else
        {
            break
        }
        i = i - 1
    }

    return rc
}

// 返回参数名字起始位置序号(已经掠过空格)
// 需要找到,或者字符串结束，然后反向找到空白字符
macro gd_find_paramname(string)
{
    headRc = gd_head_wsnum(string)
    headWsNum = headRc.spaceCnt + headRc.tableCnt
    commaPos = gd_strfind(string, ",")
    if ((strlen(string) <= 0) || (commaPos == headWsNum))
    {
        //msg ("param string error.")
        return ""
    }
    
    rc = ""
    tailRc = gd_tail_wsnum(string) 
    tailWsNum = tailRc.spaceCnt + tailRc.tableCnt
    rc.endPos = strlen(string) -  tailWsNum  
    if (commaPos > 0)
    {
        rc.endPos = commaPos
    }

    tempStr = strmid(string, 0, rc.endPos)
    wsPos = gd_strrch_ws(tempStr)
    if (wsPos < 0)
    {
        rc.startPos = 0
    }
    else
    {
        rc.startPos = wsPos + 1
    }

    return rc
}

macro gd_getparam(string)
{
    len = strlen(string)
    if (len <= 0)
    {
        return ""
    }
    string = gd_skipws(string)
    len2 = strlen(string)
    if (len2 <= 0)
    {
        return ""
    }

    paramPos = gd_find_paramname(string)
    tmpPos = gd_strfind(string, "<")

    startPos = -1
    if (((tmpPos == -1) || (paramPos.startPos < tmpPos)) && (paramPos.startPos >= 0)) // paramPos在<前
    {
        startPos = paramPos.startPos        
    }
    else
    {
        if (tmpPos > 0) // 有<, 需要配对
        {
            string = gd_jumpover_match(string, "<", ">")
            string = gd_skipws(string)
            paramPos = gd_find_paramname(string)
            startPos = paramPos.startPos             
        }
    }

    if (startPos == -1)
    {
        msg ("error: startPos == -1")
        return ""
    }

    endPos = paramPos.endPos

    if (endPos <= 0)
    {
        endPos = strlen(paramString)
    }

    rec = ""  // jelly:必须有这句话,否则下面对rec.param 赋值会出现rec不识别的错误.

    if (endPos > 0)
    {
        rec.param = strmid(paramString, 0, endPos)
        if (endPos < strlen(paramString))
        {
            rec.remain = strmid(paramString, endPos + 1, strlen(paramString))
        }
        else
        {
            rec.remain = ""
        }
        return rec
    }

    msg ("error: endPos <= 0")

    return ""
    
}

// 根据参数列表解析每个参数,保存每个参数的名字
// 1   int a, float b, double c
// 2   int a, template<typename T, class B> t
macro gd_getparams(string)
{
    hbuf = NewBuf("array")

    rec = ""

    param = gd_getparam(string)
    while (param != "")
    {
        rec = "param=\"" # param.param # "\""
        AppendBufLine(hbuf, rec)
        param = gd_getparam(param.remain)
    }

    if (rec == "") // 没有参数
    {
        CloseBuf(hbuf)
        return  hNil
    }
    
    return hbuf
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
    loc = GetCurSymbolLoc()
    if (loc == "") {
    //   msg ("line: @ln@, focus should be in a function!")
       return
    }
    ln = loc.lnFirst
    symLnFirst = ln
    date = getDateTime()
    
    // 获取函数定义前面空白字符个数,便于整体缩进.
    szFirstLine = GetBufLine(hbuf, ln)
    nSpaceCnt = 0
    nWSCnt = 0
    while (nSpaceCnt < strlen(szFirstLine)) 
    {
        if (szFirstLine[nSpaceCnt] == " ")//(AsciiFromChar(szFirstLine[nSpaceCnt]) != 32)
        {
            nSpaceCnt = nSpaceCnt + 1
            nWSCnt = nWSCnt + 1
        }
        else if (szFirstLine[nSpaceCnt] == "	")
        {
            nSpaceCnt = nSpaceCnt + 4
            nWSCnt = nWSCnt + 1
        }
        else
        {
            break
        }
        
    }
    //msg ("Line: " # szFirstLine # " nSpaceCnt: " # nSpaceCnt)
    szAlign = ""
    nTmp = nSpaceCnt
    while (nTmp--)
    {
        szAlign = cat(szAlign, " ")
    }
    
    // 获取参数信息
    // 当前行或者上一行有template的需要考虑模板参数.(认为template不可能换行)
    hTmpParams = hNil
    keyWords = "template"
    szFirstLine = gd_skipws(szFirstLine)
    if ((strlen(szFirstLine) > strlen(keyWords))) // 当前行有模板
    {
        if ((keyWords == strmid(szFirstLine, 0, strlen(keyWords))))
        {
            endPos = gd_strrch(szFirstLine, ">")
            beginPos = gd_strfind(szFirstLine, "<") + 1
            szTemplateParam = strmid(szFirstLine, beginPos, endPos)
            hTmpParams = gd_getparams(szTemplateParam)
        }
    }

    if ((hTmpParams == hNil) && (symLnFirst >= 1)) // 查看上一行是否有template
    {
        szPrevLine = GetBufLine(hbuf, symLnFirst - 1)
        szPrevLine = gd_skipws(szPrevLine)
        if (strlen(szPrevLine) > strlen(keyWords))
        {
            if (keyWords == strmid(szPrevLine, 0, strlen(keyWords)))
            {
                endPos = gd_strrch(szPrevLine, ">")
                beginPos = strlen(keyWords) + 1
                szTemplateParam = strmid(szPrevLine, beginPos, endPos)
                hTmpParams = gd_getparams(szTemplateParam)
            }
        }
    }

    ret = ""
    //获取函数参数
    if ((loc.Type == "Method") || (loc.Type == "Function"))
    {
        msg (szFirstLine)
        leftPos = gd_strfind(szFirstLine, "(")
        msg (szFirstLine # " leftPos is : " # leftPos)
        rightPos = gd_strfind(szFirstLine, ")")
        msg (szFirstLine # " rightPos is : " # rightPos)
        szFuncParams = strmid(szFirstLine, leftPos + 1, rightPos)
        msg (szFuncParams # " this is szFuncParams ")
        hFuncParams = gd_getparams(szFuncParams)
        msg (hFuncParams # " this is hFuncParams ")
    
        //获取返回值类型
        spacePos = gd_strfind(szFirstLine, " ")
        spacePosT = gd_strfind(szFirstLine, "	")
        spacePos = gd_min(spacePos, spacePosT)
        if (spacePos > 0)
        {
            ret = strmid(szFirstLine, 0, spacePos)
        }        
    }

    brief = Ask("请输入简述:")
    InsBufLine(hbuf, ln ++, szAlign # "/**")
    InsBufLine(hbuf, ln ++, szAlign # " 简述: @brief@.")
    InsBufLine(hbuf, ln ++, szAlign # " \\internal 详细描述写在下面(请先换行) ")
    InsBufLine(hbuf, ln ++, szAlign # " ")
    
    // 有模板参数
    if (hTmpParams != hNil)
    {
        InsBufLine(hbuf, ln ++, szAlign # " \\internal 模板参数:")
        i = 0
        count = GetBufLineCount(hTmpParams)
        while (i < count)
        {
            rec = GetBufLine(hTmpParams, i)
            InsBufLine(hbuf, ln ++, szAlign # " \\param " # rec.param # " ")
            i = i + 1
        }
        CloseBuf(hTmpParams)
    }
    
    //有函数参数
    if (hFuncParams != hNil)
    {
        InsBufLine(hbuf, ln ++, szAlign # " \\internal 函数参数:")
        i = 0
        count = GetBufLineCount(hFuncParams)
        while (i < count)
        {
            rec = GetBufLine(hFuncParams, i)
            InsBufLine(hbuf, ln ++, szAlign # " \\param " # rec.param # " ")
            i = i + 1
        }
        CloseBuf(hFuncParams)
    }
    if (ret != "") InsBufLine(hbuf, ln ++, szAlign # " \\return @ret@ ")
    InsBufLine(hbuf, ln ++, szAlign # " ")
    InsBufLine(hbuf, ln ++, szAlign # " \\internal 其它的section标记(\\\\todo,\\\\bug,\\\\example,\\\\remark,\\\\sa(see also)\\")
    InsBufLine(hbuf, ln ++, szAlign # " \\\\since,\\\\throw,\\\\warning,\\\\deprecated,etc)放在下面或者历史记录的说明后面.")
    InsBufLine(hbuf, ln ++, szAlign # " ")
    InsBufLine(hbuf, ln ++, szAlign # " \\internal 历史记录:")
    InsBufLine(hbuf, ln ++, szAlign # " \\version 1.0")
    InsBufLine(hbuf, ln ++, szAlign # " \\author @szMyName@")
    InsBufLine(hbuf, ln ++, szAlign # " \\assessor ")
    InsBufLine(hbuf, ln ++, szAlign # " @date@")
    InsBufLine(hbuf, ln ++, szAlign # " \\note V1.0说明: 创建" # loc.Type # ".")
    InsBufLine(hbuf, ln ++, szAlign # "*/")
    
    SetBufIns(hbuf, symLnFirst + 3, nSpaceCnt + 1) // 光标停在详述之后
}

macro testDevelop()
{
    loc = GetCurSymbolLoc()
    if (loc == "")
    {
        msg ("loc is null.")
        return
    }
    msg (loc)
    hbuf = GetCurrentBuf()
    szFirstLine = GetBufLine(hbuf, loc.lnFirst)
    msg ("szFirstLine : " # szFirstLine)
    szNameLine = GetBufLine(hbuf, loc.lnName)
    msg ("szNameLine : " # szNameLine)
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


