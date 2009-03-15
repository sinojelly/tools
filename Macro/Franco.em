/*˵��:
�ú��ļ�ʵ��һЩ��������ܻᵽ�Ĺ���, ������ļ�ͷ������˵���ͺ궨���, 
ʹ��ʱ���Զ�����ļ������������͵�ǰ����.

ʹ��˵��:
1. Project->Open Project... ��Base����
(�ù���һ����"�ҵ��ĵ�\Source Insight\Projects\Base"��);
2. Project->Add and Remove Project Files... ������ļ�(��Franco.em);
3. Options->Menu Assignments ��Menu Assignments����, ��Command������Macro, 
ѡ��Ҫʹ�õĺ�, ��ӵ����ʵĲ˵���.

���Ϻ궨���ļ�*/

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
ln = GetCurSymbolLine()
if (ln < 0) {
//   msg ("line: @ln@, focus should be in a function!")
   return
}
symLnFirst = ln
date = getDateTime()
brief = Ask("���������:")
InsBufLine(hbuf, ln ++, "/**")
InsBufLine(hbuf, ln ++, " ����: @brief@.")
InsBufLine(hbuf, ln ++, " ����: ")
InsBufLine(hbuf, ln ++, " ")
// ��ǰ�л�����һ����template����Ҫ����ģ�����.(��Ϊtemplate�����ܻ���)
InsBufLine(hbuf, ln ++, " \\param ")
InsBufLine(hbuf, ln ++, " \\return ")
InsBufLine(hbuf, ln ++, " ")
InsBufLine(hbuf, ln ++, " \\internal ������section���(eg:\\\\todo,\\\\bug,\\\\example,\\\\remark,\\\\sa(see also),\\\\since,\\")
InsBufLine(hbuf, ln ++, " \\\\throw,\\\\warning,\\\\deprecated)�ȷ���������߷�����ʷ��¼�еİ汾������.")
InsBufLine(hbuf, ln ++, " ")
InsBufLine(hbuf, ln ++, " \\internal ��ʷ��¼:")
InsBufLine(hbuf, ln ++, " \\version 1.0")
InsBufLine(hbuf, ln ++, " \\author @szMyName@")
InsBufLine(hbuf, ln ++, " \\assessor ")
InsBufLine(hbuf, ln ++, " \\create")
InsBufLine(hbuf, ln ++, " time @date@")
InsBufLine(hbuf, ln ++, " V1.0˵��: ��������/��.")
InsBufLine(hbuf, ln ++, "*/")

SetBufIns(hbuf, symLnFirst + 2, 7) // ���ͣ������֮��
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


