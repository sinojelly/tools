/*˵��:
�ú��ļ�ʵ��һЩ��������ܻᵽ�Ĺ���, ������ļ�ͷ������˵���ͺ궨���, 
ʹ��ʱ���Զ�����ļ������������͵�ǰ����.

ʹ��˵��:
1. Project->Open Project... ��Base����
(�ù���һ����"�ҵ��ĵ�\Source Insight\Projects\Base"��);
2. Project->Add and Remove Project Files... ������ļ�(��Franco.em);
3. Options->Menu Assignments ��Menu Assignments����, ��Command������Macro, 
ѡ��Ҫʹ�õĺ�, ��ӵ����ʵĲ˵���.

*/

/* Franco.em - a small collection of useful editing macros */

macro getMyName()
{
    // �ӻ��������л�ȡ�û�����
    szMyName = GetEnv(SI_USER)
    if (szMyName == "")
    {
        szMyName = Ask("��һ��ʹ����������������, �����������Զ����ɵ�ע����.")
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
szDescription = Ask("�������ļ���������:")
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

// �ҵ���ǰ����/����к�.(��ʹ�к�������Ҳ��֧��)
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

    if (count == 1) // �����ڶ��ͬ������
    {
        // ����ҵ��ķ����뵱ǰ�ļ��������򷵻�0.(��Ϊcpp�ļ�����ʱ�ں�������GetCurSymbolҲ�������������ҵ�h�еĶ��崦��)
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

    nearCurLn = -1   // �ұȵ�ǰ�к�С������к�
    
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

// �ҵ���ǰ����/����к�.(��ʹ�к�������Ҳ��֧��)
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

    if (count == 1) // �����ڶ��ͬ������
    {
        // ����ҵ��ķ����뵱ǰ�ļ��������򷵻�0.(��Ϊcpp�ļ�����ʱ�ں�������GetCurSymbolҲ�������������ҵ�h�еĶ��崦��)
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

    nearCurLn = -1   // �ұȵ�ǰ�к�С������к�
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

// �������
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

// �����ҵ���һ���հ��ַ�
macro gd_strrch_ws(string)
{
    spacePos = gd_strrch(string, " ")
    spacePosT = gd_strfind(string, "	")
    pos = gd_min(spacePos, spacePosT)

    return pos
}

// �������
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

// ���غ����˿հ��ַ����ַ���
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
    if (a == -1) // -1Ϊ��Чֵ,�˺�������������Чֵ
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

// ����һ��ƥ���beginStr, endStr, (beginStr/endStr��ֻ��һ���ֽ�)
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

        if (endPos == -1) // ������endStr�ˣ���Ȼƥ��ʧ��
        {
            msg (" match error : no more end. ")
            return string
        }
        
        validMin = gd_min(beginPos, endPos)
        if (validMin == beginPos)
        {
            // ������beginStr
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

// ���ز���������ʼλ�����(�Ѿ��ӹ��ո�)
// ��Ҫ�ҵ�,�����ַ���������Ȼ�����ҵ��հ��ַ�
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
    if (((tmpPos == -1) || (paramPos.startPos < tmpPos)) && (paramPos.startPos >= 0)) // paramPos��<ǰ
    {
        startPos = paramPos.startPos        
    }
    else
    {
        if (tmpPos > 0) // ��<, ��Ҫ���
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

    rec = ""  // jelly:��������仰,���������rec.param ��ֵ�����rec��ʶ��Ĵ���.

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

// ���ݲ����б����ÿ������,����ÿ������������
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

    if (rec == "") // û�в���
    {
        CloseBuf(hbuf)
        return  hNil
    }
    
    return hbuf
}

/**
�ں������κ�λ�ô�������꣬�Ϳ����ڸú���ǰ����Ϻ���/��ͷ
��������ж��������ʽ��GetSymbolLine��Ҫ�û�ѡ��һ����ȥ���ú������á�chenguodong
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
    
    // ��ȡ��������ǰ��հ��ַ�����,������������.
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
    
    // ��ȡ������Ϣ
    // ��ǰ�л�����һ����template����Ҫ����ģ�����.(��Ϊtemplate�����ܻ���)
    hTmpParams = hNil
    keyWords = "template"
    szFirstLine = gd_skipws(szFirstLine)
    if ((strlen(szFirstLine) > strlen(keyWords))) // ��ǰ����ģ��
    {
        if ((keyWords == strmid(szFirstLine, 0, strlen(keyWords))))
        {
            endPos = gd_strrch(szFirstLine, ">")
            beginPos = gd_strfind(szFirstLine, "<") + 1
            szTemplateParam = strmid(szFirstLine, beginPos, endPos)
            hTmpParams = gd_getparams(szTemplateParam)
        }
    }

    if ((hTmpParams == hNil) && (symLnFirst >= 1)) // �鿴��һ���Ƿ���template
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
    //��ȡ��������
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
    
        //��ȡ����ֵ����
        spacePos = gd_strfind(szFirstLine, " ")
        spacePosT = gd_strfind(szFirstLine, "	")
        spacePos = gd_min(spacePos, spacePosT)
        if (spacePos > 0)
        {
            ret = strmid(szFirstLine, 0, spacePos)
        }        
    }

    brief = Ask("���������:")
    InsBufLine(hbuf, ln ++, szAlign # "/**")
    InsBufLine(hbuf, ln ++, szAlign # " ����: @brief@.")
    InsBufLine(hbuf, ln ++, szAlign # " \\internal ��ϸ����д������(���Ȼ���) ")
    InsBufLine(hbuf, ln ++, szAlign # " ")
    
    // ��ģ�����
    if (hTmpParams != hNil)
    {
        InsBufLine(hbuf, ln ++, szAlign # " \\internal ģ�����:")
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
    
    //�к�������
    if (hFuncParams != hNil)
    {
        InsBufLine(hbuf, ln ++, szAlign # " \\internal ��������:")
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
    InsBufLine(hbuf, ln ++, szAlign # " \\internal ������section���(\\\\todo,\\\\bug,\\\\example,\\\\remark,\\\\sa(see also)\\")
    InsBufLine(hbuf, ln ++, szAlign # " \\\\since,\\\\throw,\\\\warning,\\\\deprecated,etc)�������������ʷ��¼��˵������.")
    InsBufLine(hbuf, ln ++, szAlign # " ")
    InsBufLine(hbuf, ln ++, szAlign # " \\internal ��ʷ��¼:")
    InsBufLine(hbuf, ln ++, szAlign # " \\version 1.0")
    InsBufLine(hbuf, ln ++, szAlign # " \\author @szMyName@")
    InsBufLine(hbuf, ln ++, szAlign # " \\assessor ")
    InsBufLine(hbuf, ln ++, szAlign # " @date@")
    InsBufLine(hbuf, ln ++, szAlign # " \\note V1.0˵��: ����" # loc.Type # ".")
    InsBufLine(hbuf, ln ++, szAlign # "*/")
    
    SetBufIns(hbuf, symLnFirst + 3, nSpaceCnt + 1) // ���ͣ������֮��
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

//����β������//lint !e
macro SupressLineLintWarning()
{
 hbuf = GetCurrentBuf()
 ln = GetBufLnCur(hbuf)
 szCurLine = GetBufLine(hbuf, ln)
 DelBufLine(hbuf, ln)
 InsBufLine(hbuf, ln, "@szCurLine@ //lint !e")
 SetBufIns(hbuf, ln, StrLen(szCurLine) + 10)
}

//����β������///<
macro ShortLineNote()
{
 hbuf = GetCurrentBuf()
 ln = GetBufLnCur(hbuf)
 szCurLine = GetBufLine(hbuf, ln)
 DelBufLine(hbuf, ln)
 InsBufLine(hbuf, ln, "@szCurLine@ ///< ")
 SetBufIns(hbuf, ln, StrLen(szCurLine) + 6)
}

//����β������/**<    */
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


