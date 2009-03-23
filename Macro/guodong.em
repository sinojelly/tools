/******************************************************************************
 * 版权所有(C)  Huawei Technologies Co., Ltd. 2009-2019. All rights reserved.
 *-----------------------------------------------------------------------------
 * 模 块 名 : 
 * 文件名称 : Guodong.em
 * 文件标识 : {[N/A]}
 * 功能描述 : 一组实用的Source Insight工具宏.
 * 注意事项 : 
 * 其它说明 : 
 * 
 * 历史记录 : 
 *-----------------------------------------------------------------------------
 * 版    本 : 1.0
 * 问 题 单 : 
 * 作    者 : chenguodong
 * 时    间 : 2009-3-15 19:38:15
 * 修改说明 : 创建文件
 * 
 *-----------------------------------------------------------------------------
 */

/*说明:
该宏文件实现一些编码程中能会到的功能, 如添加文件头、函数说明和宏定义等, 
使用时能自动添加文件名、函数名和当前日期.

使用说明:
1. Project->Open Project... 打开Base工程
(该工程一般在"我的文档\Source Insight\Projects\Base"中);
2. Project->Add and Remove Project Files... 加入宏文件(即Franco.em);
3. Options->Menu Assignments 打开Menu Assignments窗口, 在Command中输入Macro, 
选中要使用的宏, 添加到合适的菜单中.

注意: 如果Source Insight比 V3.50.0063版本要老, 需要做如下修改:
1 把global全局变量的使用改成另外的形式.
2 把ln++等位置换成ln = ln + 1

批处理自动完成安装实现原理:

1、打开Base工程(如果已经打开其它工程将关闭)
insight3 -p "%USERPROFILE%\My Documents\Source Insight\Projects\Base\Base.PR"

2、文件同步
insight3 -ub

3、通过insight3.exe" -c GD_ModifyBase方式调用命令或者宏.

4、SI宏中可以以环境变量方式访问dos变量。

5、把em文件复制到Base工程目录, 
       然后使用SyncProjEx(hprj, fAddNewFiles, fForceAll, fSupressWarnings)把后面三个参数
       设为TRUE，则能够把em文件增加进工程，能够使得其中的宏可以被调用.

*/


/*****************************************************************************
 *  函数名称   : GD_setup
 *  功能描述   : GD Source Insight命令设置.
 *  输入参数   : 无
 *  返 回 值       : 无
 *  其它说明   : 如果该快捷键已分配,弹出提示,输入"yes"表示覆盖.
 *----------------------------------------------------------------------------  
 * 历史记录(变更单, 责任人@修改日期, 操作说明)  
 *  $0000000(N/A),  chengodong @2009-3-15 19:23,  创建函数  
 *----------------------------------------------------------------------------      
 */
macro GD_setup()
{    
    GD_ModifyBase() //在批处理中修改Base工程加入这个文件

    GD_setupkey()

    //GD_help()

    //stop
}

macro GD_ModifyBase()
{
   hprj = OpenProj(GetEnv("SI_BASE_PRJ")); // 打开Base工程, SI_BASE_PRJ -- Base工程路径
   //msg GetEnv("SI_BASE_PRJ")
   //AddFileToProj(hprj, GetEnv("SI_EM_FILE")); //似乎不好用, 不能找到em中的函数 // SI_EM_FILE -- Source Insight 宏文件
   //msg GetEnv("SI_EM_FILE")
   //SyncProj(hprj)
   SyncProjEx(hprj, TRUE, TRUE, TRUE)
   CloseProj(hprj)    
}

/*****************************************************************************
 *  函数名称   : GD_setupkey
 *  功能描述   : GD Source Insight命令设置.
 *  输入参数   : 无
 *  返 回 值       : 无
 *  其它说明   : 如果该快捷键已分配,弹出提示,输入"yes"表示覆盖.
 *----------------------------------------------------------------------------  
 * 历史记录(变更单, 责任人@修改日期, 操作说明)  
 *  $0000000(N/A),  chengodong @2009-3-15 19:23,  创建函数  
 *----------------------------------------------------------------------------      
 */
macro GD_setupkey()
{
    // 老版本的不支持全局变量,如何显示帮助?
    
    //g_gd_help = "" 
    hhelp = NewBuf("Guodong Command List")

    // Ctrl+Alt+H   添加/修改函数头、类头。
    gd_assignkey(hhelp, "h", "GD_AddHeader", "Add/modify class/function/etc. header.")

    // Ctrl+Alt+F  添加/修改文件头
    gd_assignkey(hhelp, "f", "GD_AddFileHeader", "Add/modify file header.")

    // Ctrl+Alt+O  cpp/h文件切换.
    gd_assignkey(hhelp, "o", "GD_SHSwitch", "Source/Header switch.")

    // Ctrl+Alt+A  自动添加所有工程目录中的文件
    gd_assignkey(hhelp, "a", "GD_AddFiles", "Add all files in project dir.")

    // Ctrl+Alt+E 打开当前文件所在目录    
    gd_assignkey(hhelp, "e", "GD_OpenExplorer", "Open current file dir.")

    // Ctrl+Alt+C 归档当前文件   
    gd_assignkey(hhelp, "c", "GD_TortoiseSVNCommit", "Commit current file to SVN server.")

    // Ctrl+Alt+S 统计当前文件代码行(如果选中代码则是选中代码行)
    gd_assignkey(hhelp, "s", "GD_CodeLine", "Count the code line of current file or selected code.")

    // Ctrl+Alt+M Measure 统计当前文件圈复杂度(如果选中代码则是选中代码圈复杂度)
    gd_assignkey(hhelp, "m", "GD_SourceMonitor", "Run SourceMonitor check current file or selected code.")

    // Ctrl+Alt+F1  显示帮助信息, 包括doxys帮助

    // Ctrl+Alt+B    注释/反注释选中的代码行
    gd_assignkey(hhelp, "b", "GD_Comment", "Comment/Uncomment the selected content.")
    //stop

    // Ctrl+Alt+L    Lint当前文件. 这个还是增加custom lint比较好。
    // 在%j/Lint目录下执行命令: D:\Tools\CMD\Lint\SmartLint\PC-Lint8.0\lint-nt  *_opt.lnt *_file.lnt
    //gd_assignkey(hhelp, "l", "GD_Lint", "Lint current file.")

    // Ctrl+Alt+R   执行指定的批处理/可执行文件.(可以用来编译/Lint整个工程/运行文件)
    // 指定可执行文件、运行目录、参数
    // 可能需要自己写一个ComboBox列表的应用程序,返回选中的文件字符串给SI
    // 在自己的应用程序中写一个批处理,然后再在macro中调用.
    // 研究一下Ask的机制.
    // 另外，通过抓窗口能实现自动加入命令
    // gd_assignkey(hhelp, "r", "GD_RunCmd", "Run the specified command.")

    // 自己常用的快捷键由于Fn的关系，使用不方便,把这些快捷键重新定义

    SetCurrentBuf(hhelp)
    SaveBufAs(hhelp, "GdCommandList.txt")
    //SetBufDirty(hhelp) // Save之后不能设置了,否则会有异常
}

macro GD_CodeLine()
{
    hwnd = GetCurrentWnd()
    lnFirst = GetWndSelLnFirst(hwnd)
    lnLast = GetWndSelLnLast(hwnd)
    hbuf = GetCurrentBuf()

    rc = gd_ParseCodeInit()
    if(lnLast == lnFirst) // 不是选中多行, 则统计当前文件
    { 
        lnFirst = 0
        lnLast = GetBufLineCount(hbuf)        
    }

    ln = lnFirst
    while (ln < lnLast)
    {
        szLine = GetBufLine(hbuf, ln)
        rc = gd_ParseCodeLine(szLine, rc, False)
        ln = ln + 1
    }

    msg rc
}

/*****************************************************************************
 *  函数名称   : GD_help
 *  功能描述   : GD Source Insight命令帮助.
 *  输入参数   : 无
 *  返 回 值       : 无
 *  其它说明   : 
  *----------------------------------------------------------------------------  
 * 历史记录(变更单, 责任人@修改日期, 操作说明)  
 *  $0000000(N/A),  chengodong @2009-3-15 19:23,  创建函数  
 *---------------------------------------------------------------------------- 
 */
 /*
macro GD_help()
{
    hbuf = NewBuf("Guodong Command List") // create output buffer
    if (hbuf == 0)
    {
        msg ("Create buffer fail!")
        return
    }

    rc = gd_nextline(g_gd_help, 0)
    while (rc != "")
    {
        AppendBufLine(hbuf, rc.line)
        rc = gd_nextline(g_gd_help, rc.nextPos)
    }
    
    SetCurrentBuf(hbuf) // put search results in a window
    SetBufDirty(hbuf, FALSE); // don't bother asking to save

}*/


// 取string的最前面n个字符
macro gd_strleft(string, n)
{
    len = strlen(string)
    if (n >= len)
    {
        return string
    }
    return strmid(string, 0, n)
}

// 取string的最前面n个字符
macro gd_strright(string, n)
{
    len = strlen(string)
    if (n >= len)
    {
        return string
    }
    return strmid(string, len - n, len)
}

/// 注释/反注释选中的代码
macro GD_Comment()
{
    hwnd = GetCurrentWnd()
    lnFirst = GetWndSelLnFirst(hwnd)
    lnLast = GetWndSelLnLast(hwnd)
    hbuf = GetCurrentBuf()
    
    if(lnLast == lnFirst) 
    {
       hbufText = GetBufSelText(hbuf)
       szTemp = gd_strtrim(hbufText)
       if ((gd_strleft(szTemp,2)=="/*") && (gd_strright(szTemp,2)=="*/")) //Uncomment
       {
           szCode = gd_strreplace(hbufText, "/*", "")
           szCode = gd_strreplace(szCode, "*/", "")
           SetBufSelText(hbuf, szCode)
           return
       }
       SetBufSelText(hbuf, "/*@hbufText@*/")       
    }
    else 
    {
       szFirst = GetBufLine(hbuf, lnFirst)
       szLast = GetBufLine(hbuf, lnLast)
       szFirstTmp = gd_strtrim(szFirst)
       szLastTmp = gd_strtrim(szLast)
       if ((gd_strleft(szFirstTmp,2)=="/*") && (gd_strright(szLastTmp,2)=="*/")) //Uncomment
       {
           DelBufLine(hbuf, lnFirst)
           bInsFirst =False
           if (strlen(szFirstTmp) > 2) // 如果改行只有/ *, 则删除该行
           {
               bInsFirst = True
               InsBufLine(hbuf, lnFirst, gd_strreplace(szFirst, "/*", ""))
           }
           lnLastNew = lnLast
           if (!bInsFirst)
           {
               lnLastNew = lnLast - 1
           }
           DelBufLine(hbuf, lnLastNew)
           if (strlen(szLastTmp) > 2) // 如果改行只有/ *, 则删除该行
           {
               InsBufLine(hbuf, lnLastNew, gd_strreplace(szLast, "*/", ""))
           }
           return
       }
       InsBufLine(hbuf, lnFirst, "/* ")
       InsBufLine(hbuf, lnLast+2, "*/") 
       SetBufIns( hbuf,lnFirst,3)
    }
}

macro gd_CatPath(dir, file)
{
    if (gd_strright(dir, 1)!="\\")
    {
        dir = cat(dir, "\\")
    }

    return cat(dir, file)
}

macro GD_SourceMonitor()
{
    //"D:\Tools\CMD\SourceMonitor\SourceMonitor.exe" /DC++ %f   当前文件
    //"D:\Tools\CMD\SourceMonitor\SourceMonitor.exe" /DC++ %s   选中代码

    exePath = GetEnv("SRCMONITOR_PATH")

    hwnd = GetCurrentWnd()
    lnFirst = GetWndSelLnFirst(hwnd)
    lnLast = GetWndSelLnLast(hwnd)
    hbuf = GetCurrentBuf()
    
    if(lnLast > lnFirst) // 选中多行则统计选中代码
    {
        //szText = GetBufSelText(hbuf)
        hTemp = NewBuf("Select")
        i = lnFirst
        lnLastLimit = lnLast + 1
        while (i < lnLastLimit) // 注意要加1，否则选中中的最后一行未被复制.
        {
            szLine = GetBufLine(hbuf, i)
            AppendBufLine(hTemp, szLine)
            i = i + 1
        }
        tempDir = GetEnv("TEMP")
        if (tempDir == "")
        {
            tempDir = "C:\\Temp"
        }
        tempFile = gd_CatPath(tempDir, "gd_si_select.cpp")
        SaveBufAs (hTemp, tempFile)
        CloseBuf(hTemp)
    }
    else
    {
        tempFile = GetBufName(hbuf)  // 当前文件
    }
    
    ShellExecute ("open", "\"@exePath@\"", "/DC++ @tempFile@", "", 1)

}

macro gd_GetFileDir(file)
{
    pos = gd_strrch(file, "\\")
    if (pos < 0)
    {
        return file
    }

    return strmid(file, 0, pos)
}

macro GD_OpenExplorer()
{
    //ShellExecute open explorer /e,/select,%f
    
    hbuf = GetCurrentBuf()    
    szCurPathName = GetBufName(hbuf)
    //ShellExecute ("open", szCurPathName, "explorer /e,/select", "", 1) // 这样打开文件了
    ShellExecute ("open", gd_GetFileDir(szCurPathName), "explorer /e,/select", "", 1) // OK
    //ShellExecute ("open", "explorer", "/e,/select \"@szCurPathName@\"", "", 1) // NOK
    //stop
}

macro GD_TortoiseSVNCommit()
{
    //"C:\Program Files\TortoiseSVN\bin\TortoiseProc.exe" /command:commit /path:%f /notempfile /closeonend

    exePath = GetEnv("TortoiseSVN_PATH")

    //msg exePath

    hbuf = GetCurrentBuf()    
    szCurPathName = GetBufName(hbuf)
    //ShellExecute ("open", szCurPathName, "\"@exePath@\" /command:commit /path:\"@szCurPathName@\" /notempfile /closeonend", "", 1)
    ShellExecute ("open", "\"@exePath@\"", "/command:commit /path:\"@szCurPathName@\" /notempfile /closeonend", "", 1)
    //RunCmd("\"@exePath@\" /command:commit /path:\"@szCurPathName@\" /notempfile /closeonend")
    //RunCmdLine ("\"@exePath@\" /command:commit /path:\"@szCurPathName@\" /notempfile /closeonend", "", TRUE)
    
    //stop
}

/*
macro gd_FileNamePair(file1, file2)
{
    file1 = gd_strtrim(file1)
    file2 = gd_strtrim(file2)
    len1 = strlen(file1)
    len2 = strlen(file2)
    if ((len1 <= 0) || (len2 <= 0))
    {
        return False
    }
    len = gd_min(len1, len2)
    i = 0
    while (i < len)
    {
        if (file1[i] != file2[i])
        {
            break
        }
        i = i + 1
    }

    suffix1 = strmid(file1, i, len1)
    suffix2 = strmid(file2, i, len2)

    if ((((suffix1 == "h") || (suffix1 == "hpp") || (suffix1 == "hxx")) && ((suffix2 == "c") || (suffix2 == "cpp") || (suffix2 == "cxx")))
     || (((suffix2 == "h") || (suffix2 == "hpp") || (suffix2 == "hxx")) && ((suffix1 == "c") || (suffix1 == "cpp") || (suffix1 == "cxx"))))
    {
        return True
    }

    return False
}

/// 这个函数能够完成功能，但是需要搜索函数表,太慢
macro GD_SHSwitch()
{
    // 获取当前文件名
    hbuf = GetCurrentBuf()    
    szCurPathName = GetBufName(hbuf)
    szCurFileName = GetFileName(szCurPathName)
    //msg szCurFileName

    hprj = GetCurrentProj()
    ifileMax = GetProjFileCount (hprj)
    ifile = 0
    while (ifile < ifileMax)
    {
        filename = GetProjFileName (hprj, ifile) // filename是相对路径
        bearfilename = GetFileName(filename)
        //msg filename
        if (gd_FileNamePair(bearfilename, szCurFileName))
        {
            break
        }
        ifile = ifile + 1
    }

    if (ifile >= ifileMax)
    {
        msg "File not in project file list."
        return
    }

    //hPairFile = GetBufHandle (filename) // filename原来是打开的才能找得到它的buf
    hPairFile = OpenBuf (filename) // 这里只传文件名不能打开
    if (hPairFile == hNil)
    {
        msg "File(" # filename # ") not found"
        return
    }
    SetCurrentBuf (hPairFile) // 显示文件
}
*/

macro gd_FileSuffix(file)
{
    pos = gd_strrch(file, ".")

    if (pos <= 0)
    {
        return ""
    }

    return strmid(file, pos, strlen(file))
}

macro gd_SuffixReplace(file, suffix)
{
    pos = gd_strrch(file, ".")

    if (pos <= 0)
    {
        return ""
    }

    strTmp = strmid(file, 0, pos)
    strTmp = cat(strTmp, suffix)

    return strTmp
}

macro GD_SHSwitch()
{
    // 获取当前文件名
    hbuf = GetCurrentBuf()    
    szCurPathName = GetBufName(hbuf)
    szCurFileName = GetFileName(szCurPathName)
    //msg szCurFileName

    filename = ""
    hPairFile = hNil
    szSuffix = gd_FileSuffix(szCurFileName)
    if ((szSuffix == ".cpp") || (szSuffix == ".c") || (szSuffix == ".cxx"))
    {
        filename = gd_SuffixReplace(szCurFileName, ".h")
        hPairFile = OpenBuf (filename)
        if (hPairFile == hNil)
        {
            filename = gd_SuffixReplace(szCurFileName, ".hpp")
            hPairFile = OpenBuf (filename)
            if (hPairFile == hNil)
            {
                filename = gd_SuffixReplace(szCurFileName, ".hxx")
                hPairFile = OpenBuf (filename)
                if (hPairFile == hNil)
                {
                    return
                }
            }
        }
    }
    else if ((szSuffix == ".h") || (szSuffix == ".hpp") || (szSuffix == ".hxx"))
    {
        filename = gd_SuffixReplace(szCurFileName, ".cpp")
        hPairFile = OpenBuf (filename)
        if (hPairFile == hNil)
        {
            filename = gd_SuffixReplace(szCurFileName, ".c")
            hPairFile = OpenBuf (filename)
            if (hPairFile == hNil)
            {
                filename = gd_SuffixReplace(szCurFileName, ".cxx")
                hPairFile = OpenBuf (filename)
                if (hPairFile == hNil)
                {
                    return
                }
            }
        }
    }

    if (hPairFile == hNil)
    {
        Beep()
        return
    }

    SetCurrentBuf (hPairFile) // 显示文件
}

macro GD_AddFiles()
{
    SyncProjEx(GetCurrentProj(), TRUE, TRUE, TRUE)
}

macro gd_ParamAlign(param)
{
    szParaAlign = ""
    
    szWhiteString = "                              "  // 30 space
    nParaAlign = 14
    
    nParaLen = strlen(param)
    if (nParaAlign > nParaLen)
    {
        szParaAlign = strtrunc(szWhiteString, nParaAlign - nParaLen)
    }

    return szParaAlign
}

/*****************************************************************************
 *  函数名称   : GD_addheader
 *  功能描述   : 增加class/func/etc. header .
 *  输入参数   : 无
 *  返 回 值       : 无
 *  其它说明   : 
        在函数/类中任何位置触发这个宏，就可以在该函数前面加上函数/类头

        已知问题:
        由于GetCurSymbol在模板类中任何地方都返回模板类名,
        所以模板类只能自动加类头,函数头不能自动添加.
 *----------------------------------------------------------------------------  
 * 历史记录(变更单, 责任人@修改日期, 操作说明)  
 *  $0000000(N/A),  chengodong @2009-3-15 19:23,  创建函数  
 *---------------------------------------------------------------------------- 
 */
macro GD_AddHeader()
{
    //global horizon

    //if (horizon == "")
    //{
        horizon = " \\internal --------------------------------------------------------------------"
    //}
    
    szMyName = gd_UserName()
    
    hbuf = GetCurrentBuf()
    loc = gd_GetCurSymbolLoc()
    if (loc == "") {
    //   msg ("line: @ln@, focus should be in a function!")
       return
    }
    ln = loc.lnFirst
    symLnFirst = ln
    date = gd_DateTime()
    
    // 获取函数定义前面空白字符个数,便于整体缩进.
    szFirstLine = GetBufLine(hbuf, ln)
    
    headws = gd_head_wsnum(szFirstLine)
    
    szAlign = ""
    nTmp = headws.spaceCnt
    //while (nTmp--)
    while (nTmp)
    {
        szAlign = cat(szAlign, " ")
        nTmp = nTmp - 1
    }

    if (gd_ModifyHeader(hbuf, ln, szAlign)) // 已经有头只是修改它
    {
        return
    }

    // 获取完整声明,不含注释(便于解析参数)
    symDeclare = gd_CurSymbolDeclare()
    if (symDeclare == "")
    {
         return
    }

    szFunction = symDeclare

    brief = Ask("请输入简述:")  // 注意Ask要放在NewBuf之前,否则用户取消之后就有buf未释放
    
    // 获取参数信息
    // 解析模板参数 
    hTmpParams = hNil
    keyWords = "template"
    if ((strlen(symDeclare) > strlen(keyWords))) 
    {
        if ((keyWords == strmid(symDeclare, 0, strlen(keyWords))))
        {
            endPos = gd_strrch(symDeclare, ">")
            beginPos = gd_strfind(symDeclare, "<") + 1
            szTemplateParam = strmid(symDeclare, beginPos, endPos)
            hTmpParams = gd_getparams(szTemplateParam)

            szFunction = strmid(symDeclare, endPos + 1, strlen(symDeclare)) // 函数声明
        }
    }

    ret = ""
    //获取函数参数
    hFuncParams = hNil
    if ((loc.Type == "Method") || (loc.Type == "Function"))
    {
        leftPos = gd_strfind(szFunction, "(")
        rightPos = gd_strfind(szFunction, ")")
        szFuncParams = strmid(szFunction, leftPos + 1, rightPos)
        hFuncParams = gd_getparams(szFuncParams)
    
        //获取返回值类型
        spacePos = gd_strfind(szFunction, " ")
        spacePosT = gd_strfind(szFunction, "	")
        spacePos = gd_min(spacePos, spacePosT)
        if (spacePos > 0)
        {
            ret = strmid(szFunction, 0, spacePos)
        }        
    }
    
    InsBufLine(hbuf, ln , szAlign # "/**")
    ln = ln + 1
    InsBufLine(hbuf, ln , szAlign # " @brief@.")    
    ln = ln + 1
    InsBufLine(hbuf, ln , szAlign # " \\internal ********************************************************************")
    ln = ln + 1
    InsBufLine(hbuf, ln , szAlign # " 其它说明(请先空一行) :")
    ln = ln + 1
    InsBufLine(hbuf, ln , szAlign # " ")
    ln = ln + 1
    InsBufLine(hbuf, ln , szAlign # " ")
    ln = ln + 1
    // 有模板参数
    if (hTmpParams != hNil)
    {
        InsBufLine(hbuf, ln , szAlign # " \\internal 模板参数:")
        ln = ln + 1
        i = 0
        count = GetBufLineCount(hTmpParams)
        while (i < count)
        {
            rec = GetBufLine(hTmpParams, i)
            InsBufLine(hbuf, ln , szAlign # " \\param  " # rec.name # gd_ParamAlign(rec.name) # " ")
            ln = ln + 1
            i = i + 1
        }
        CloseBuf(hTmpParams)
    }
    
    //有函数参数
    if (hFuncParams != hNil)
    {
        InsBufLine(hbuf, ln , szAlign # " \\internal 函数参数:")
        ln = ln + 1
        i = 0
        count = GetBufLineCount(hFuncParams)
        while (i < count)
        {
            rec = GetBufLine(hFuncParams, i)
            if (rec.name == "") // 入参为void特殊处理
            {
                break
            }
            InsBufLine(hbuf, ln , szAlign # " \\param  " # rec.name # gd_ParamAlign(rec.name) #  " [" # gd_ParamTypeDescription(rec.type) # "]")
            ln = ln + 1
            i = i + 1
        }
        CloseBuf(hFuncParams)
    }
    if ((ret != "") && (ret != "void") && (ret != "VOID"))
    {
        ret_des = ""
        if ((ret == "BOOL") || (ret == "bool"))
        {
            ret_des = "TRUE - 成功; FALSE - 失败."
        }
        InsBufLine(hbuf, ln , szAlign # " \\return  " # gd_ParamAlign("") # "@ret_des@")
        ln = ln + 1
    }
    InsBufLine(hbuf, ln , szAlign # " ")
    ln = ln + 1
    InsBufLine(hbuf, ln , szAlign # " \\internal 历史记录:")
    ln = ln + 1
    InsBufLine(hbuf, ln , szAlign # horizon)   
    ln = ln + 1
    InsBufLine(hbuf, ln , szAlign # " \\version 1.0")
    ln = ln + 1
    InsBufLine(hbuf, ln , szAlign # " \\author @szMyName@")
    ln = ln + 1
    InsBufLine(hbuf, ln , szAlign # " \\assessor ")
    ln = ln + 1
    InsBufLine(hbuf, ln , szAlign # " @date@")
    ln = ln + 1
    InsBufLine(hbuf, ln , szAlign # " \\note V1.0说明: 创建" # loc.Type # ".")
    ln = ln + 1
    InsBufLine(hbuf, ln , szAlign # horizon) 
    ln = ln + 1
    InsBufLine(hbuf, ln , szAlign # "*/")
    
    SetBufIns(hbuf, loc.lnFirst + 5, 1) // 光标停在其它说明的起始位置
}

macro gd_ModifyHeader(hbuf, ln, szAlign)
{
    horizon = " \\internal --------------------------------------------------------------------"
    if (ln < /*2*/ 5 ) // 前面不足两行, 实际的注释远远不止两行
    {
        return False
    }
    szPrevLine = GetBufLine(hbuf, ln - 1)
    szPrevLine = gd_strtrim(szPrevLine)
    if (szPrevLine != "*/")
    {
        return False
    }

    szPrevLine2 = GetBufLine(hbuf, ln - 2)
    szPrevLine2 = gd_strtrim(szPrevLine2)
    if (szPrevLine2 != gd_strtrim(horizon))
    {
        return False
    }

    // 依次往上读每一行,找到version
    lastVersion = gd_LastVersion(hbuf, ln - 2, "\\version ")

    if (lastVersion == "")
    {
        return False
    }

    thisVersion = gd_IncVersion(lastVersion)

    description = Ask("请输入修改描述:")

    // 函数声明前面是horizon和* /结尾的函数头，需要增加历史记录
    ln = ln - 1
    InsBufLine(hbuf, ln , szAlign # " \\version @thisVersion@")
    ln = ln + 1
    InsBufLine(hbuf, ln , szAlign # " \\author " # gd_UserName())
    ln = ln + 1
    InsBufLine(hbuf, ln , szAlign # " \\assessor ")
    ln = ln + 1
    InsBufLine(hbuf, ln , szAlign # " " # gd_DateTime())
    ln = ln + 1
    InsBufLine(hbuf, ln , szAlign # " \\note V@thisVersion@说明: " # description # ".")
    ln = ln + 1
    InsBufLine(hbuf, ln , szAlign # horizon) 

    return True
}

macro GD_AddFileHeader()
{
    headStartLine = "/******************************************************************************"
    headCopyright = " * 版权所有(C)  " # gd_Copyright()
    headInsertion = " *-----------------------------------------------------------------------------"
    headVerStart  = " * 版    本 : "
    headEndLine   = " */"

    hbuf = GetCurrentBuf()

    if (gd_ModifyFileHeader(hbuf))
    {
        return
    }
    
    szpathName = GetBufName(hbuf)
    szfileName = GetFileName(szpathName)
    nlength = StrLen(szfileName)
    // szInf = Ask("Enter the information of file:")
    szDescription = Ask("请输入文件功能描述:")
    //szDescription = ""
    
    //hbuf = GetCurrentBuf()
    ln = 0
    InsBufLine(hbuf, ln, headStartLine)
    ln = ln + 1
    InsBufLine(hbuf, ln, headCopyright)
    ln = ln + 1
    InsBufLine(hbuf, ln, headInsertion)
    ln = ln + 1
    InsBufLine(hbuf, ln, " * 模 块 名 : ")
    ln = ln + 1
    InsBufLine(hbuf, ln, " * 文件名称 : @szfileName@")
    ln = ln + 1
    InsBufLine(hbuf, ln, " * 文件标识 : {[N/A]}")
    ln = ln + 1
    InsBufLine(hbuf, ln, " * 功能描述 : @szDescription@")
    ln = ln + 1
    InsBufLine(hbuf, ln, " * 注意事项 : ")
    ln = ln + 1
    InsBufLine(hbuf, ln, " * 其它说明 : ")
    ln = ln + 1
    InsBufLine(hbuf, ln, " * ")
    ln = ln + 1
    InsBufLine(hbuf, ln, " * 历史记录 : ")
    ln = ln + 1
    InsBufLine(hbuf, ln, headInsertion)
    ln = ln + 1
    InsBufLine(hbuf, ln, headVerStart # "1.0")
    ln = ln + 1
    InsBufLine(hbuf, ln, " * 问 题 单 : ")
    ln = ln + 1
    InsBufLine(hbuf, ln, " * 作    者 : " # gd_UserName())
    ln = ln + 1
    InsBufLine(hbuf, ln, " * 时    间 : " # gd_DateTime())
    ln = ln + 1
    InsBufLine(hbuf, ln, " * 修改说明 : 创建文件")
    ln = ln + 1
    InsBufLine(hbuf, ln, " * ")
    ln = ln + 1
    InsBufLine(hbuf, ln, headInsertion)
    ln = ln + 1
    InsBufLine(hbuf, ln, headEndLine)
    
    SetBufIns(hbuf, 8, 14)
}

macro gd_ModifyFileHeader(hbuf)
{
    headStartLine = "/******************************************************************************"
    headCopyright = " * 版权所有(C)  " # gd_Copyright()
    headInsertion = " *-----------------------------------------------------------------------------"
    headVerStart  = " * 版    本 : "
    headEndLine   = " */"
    
    szLine = GetBufLine(hbuf, 0)
    if (gd_strtrim(szLine) != gd_strtrim(headStartLine)) // 起始行不匹配
    {
        return False
    }

    szLine = GetBufLine(hbuf, 1)
    if (gd_strtrim(szLine) != gd_strtrim(headCopyright)) // 版权行不匹配
    {
        return False
    }

    szLine = GetBufLine(hbuf, 2)
    if (gd_strtrim(szLine) != gd_strtrim(headInsertion)) // 第三行的插入行不匹配
    {
        return False
    }

    // 以上都匹配直接找到头注释末尾
    lineCnt = GetBufLineCount(hbuf)
    
    i = 3    
    while (True)
    {
        szLine = GetBufLine(hbuf, i)
        if (gd_strtrim(szLine) == "*/")
        {
            break
        }
        i = i + 1
        if (i >= lineCnt)
        {
            return False
        }
    }

    thisVersion = "1.0"

    // 依次往上读每一行,找到version
    lastVersion = gd_LastVersion(hbuf, i, headVerStart)

    if (lastVersion != "")
    {
        thisVersion = gd_IncVersion(lastVersion)
    }    

    description = Ask("请输入修改描述:")

    // 函数声明前面是horizon和* /结尾的函数头，需要增加历史记录
    ln = i   
    InsBufLine(hbuf, ln, " * 版    本 : " # thisVersion)
    ln = ln + 1
    InsBufLine(hbuf, ln, " * 问 题 单 : ")
    ln = ln + 1
    InsBufLine(hbuf, ln, " * 作    者 : " # gd_UserName())
    ln = ln + 1
    InsBufLine(hbuf, ln, " * 时    间 : " # gd_DateTime())
    ln = ln + 1
    InsBufLine(hbuf, ln, " * 修改说明 : " # description)
    ln = ln + 1
    InsBufLine(hbuf, ln, " * ")
    ln = ln + 1
    InsBufLine(hbuf, ln, headInsertion)

    return True
}

macro gd_LastVersion(hbuf, ln, versionStart)
{
    versionStart = gd_skipws(versionStart)
    verStartLen = strlen(versionStart)
    while (True)
    {
        ln = ln - 1
        if (ln >= 0)
        {
            szLine = GetBufLine(hbuf, ln)
            szLine = gd_strtrim(szLine)
            if (gd_strfind(szLine, versionStart) == 0)
            {
                szLine = strmid(szLine, verStartLen, strlen(szLine))
                return szLine
            }
        }
        else
        {
            return ""
        }
    }

    return ""
}

macro gd_IncVersion(lastVersion)
{
    lastVersion = gd_strtrim(lastVersion)
    dotPos = gd_strfind(lastVersion, ".")
    if (dotPos < 0)
    {
        if (IsNumber(lastVersion))
        {
            return lastVersion + 1
        }
        return lastVersion
    }

    mainVer = strmid(lastVersion, 0, dotPos)
    subVer = strmid(lastVersion, dotPos + 1, strlen(lastVersion))

    if (subVer >= 9)
    {
        mainVer = mainVer + 1
        subVer = 0
    }
    else
    {
        subVer = subVer + 1
    }

    return mainVer # "." # subVer
}

/*****************************************************************************
 *  函数名称   : gd_ParamTypeDescription
 *  功能描述   :根据参数类型获得简要描述信息.
 *  输入参数   : 无
 *  返 回 值       : 无
 *  其它说明   :  
          处理规则很简单, 所有参数都有in属性,
          非const 引用还有out属性.
          使用者需要根据实际情况稍微修改.
 *----------------------------------------------------------------------------  
 * 历史记录(变更单, 责任人@修改日期, 操作说明)  
 *  $0000000(N/A),  chengodong @2009-3-15 19:23,  创建函数  
 *---------------------------------------------------------------------------- 
 */
macro gd_ParamTypeDescription(type)
{
    type = gd_strtrim(type);
    len = strlen(type)
    if (len <= 0)
    {
        return ""
    }

    szDes = "in"

    constPos = gd_strfind_word(type, "const")

    if ((constPos < 0) && (type[len - 1] == "&")) // 引用并且没有const修饰
    {
        szDes = cat(szDes, " out")
    }

    return szDes
}

/*****************************************************************************
 *  函数名称   : gd_SymbolDeclare
 *  功能描述   : 获取当前函数/类等的完整的标识符声明
 *  输入参数   : 无
 *  返 回 值       : 无
 *  其它说明   :  从lnFirst开始, 到"{"为止(不包括"{")，去掉注释。
 *----------------------------------------------------------------------------  
 * 历史记录(变更单, 责任人@修改日期, 操作说明)  
 *  $0000000(N/A),  chengodong @2009-3-15 19:23,  创建函数  
 *---------------------------------------------------------------------------- 
 */
macro gd_CurSymbolDeclare()
{
    loc = gd_GetCurSymbolLoc()

    if (loc == "")
    {
        return ""
    }
    
    ln = loc.lnFirst

    hbuf = GetCurrentBuf()

    rc = gd_ParseCodeInit()
    while (true)
    {
        szLine = GetBufLine(hbuf, ln) 
        decEnd = gd_strfind(szLine, "{")
        if (/*(szLine == "") ||*/ (decEnd >= 0)) // 空行或者有{时终止
        {
            rc.pureCode = cat(rc.pureCode, strmid(szLine, 0, decEnd))
            break
        }
        if (szLine == "")
        {
            break
        }
        rc = gd_ParseCodeLine(szLine, rc, True)
        ln = ln + 1
    }

    return rc.pureCode
}

/*****************************************************************************
 *  函数名称   : gd_ParseCodeInit
 *  功能描述   : 解析代码的记录初始化.
 *  输入参数   : 无
 *  返 回 值       : 无
 *  其它说明   :        
 *----------------------------------------------------------------------------  
 * 历史记录(变更单, 责任人@修改日期, 操作说明)  
 *  $0000000(N/A),  chengodong @2009-3-15 19:23,  创建函数  
 *---------------------------------------------------------------------------- 
 */
macro gd_ParseCodeInit()
{
    rc = ""
    rc.bCommentSet = False
    rc.bQuatoSet = False
    rc.pureCode = ""
    rc.nLines = 0
    rc.nBlankLines = 0
    rc.nCommentLines = 0
    rc.nCodeLines = 0

    return rc
}

/*****************************************************************************
 *  函数名称   : gd_ParseCodeLine
 *  功能描述   : 解析一行C/C++代码,获得除掉注释的纯代码
 *  输入参数   : 无
 *  返 回 值       : 无
 *  其它说明   : 
       除了得到纯代码，此函数还能用于统计代码行.
       第一次调用, rc需要如下初始化(调用gd_ParseCodeInit() 即可)
       rc.bCommentSet = False
       rc.bQuatoSet = False
       rc.pureCode = ""
       rc.nLines = 0
       rc.nBlankLines = 0
       rc.nCommentLines = 0
       rc.nCodeLines = 0
 *----------------------------------------------------------------------------  
 * 历史记录(变更单, 责任人@修改日期, 操作说明)  
 *  $0000000(N/A),  chengodong @2009-3-15 19:23,  创建函数  
 *---------------------------------------------------------------------------- 
 */
macro gd_ParseCodeLine(szLine, rc, needPureCode)
{
    //global m_nStatMethod
    m_nStatMethod = 1    
    
	bStatedComment = FALSE;//本行作为注释行是否已统计过
	bStatedCode = FALSE;   //本行作为代码行是否已统计过

	rc.nLines = rc.nLines + 1;

	szLine = gd_skipws(szLine); //先将文件头的空格或制表符去掉

	if(szLine == "") //为空白行
	{
		rc.nBlankLines = rc.nBlankLines + 1;
		return rc
	}

	if(rc.bCommentSet && gd_strfind(szLine, "*/")==-1)
	{
		rc.nCommentLines = rc.nCommentLines + 1;
		return rc
	}

	if(gd_strfind(szLine, "//")==-1 && gd_strfind(szLine, "/*")==-1 && gd_strfind(szLine, "*/")==-1)
	{//如果本行根本就无注释符，则要不是注释符，要不是代码行
		if(rc.bCommentSet)
		{
			rc.nCommentLines = rc.nCommentLines + 1; 
			return rc
		}
		else
		{
			if(gd_strfind(szLine, '"')==-1)
			{
				rc.nCodeLines = rc.nCodeLines + 1; 
				// 本行全是代码
				if (needPureCode)
				{
				    rc.pureCode = cat(rc.pureCode, szLine)
				}
				return rc
			}
		}
	}

	if(gd_strfind(szLine, "//")==0 && !rc.bCommentSet && !rc.bQuatoSet)
	{
		rc.nCommentLines = rc.nCommentLines + 1;
		return rc
	}

	bEndWithComment = False

	bDoubleSplashFound = FALSE;
	bSplashStarFound = FALSE;
	i = 0
	line_len = strlen(szLine) 
	while (i < line_len - 1)
	{
	    if(!rc.bCommentSet)
	    {
	        // 字符szLine[i]是真正的代码,加上它
			if (needPureCode)
			{
			    rc.pureCode = cat(rc.pureCode, szLine[i])
			}
	    }
		if(szLine[i]=="/" && szLine[i+1]=="/" && !rc.bCommentSet && !rc.bQuatoSet)
		{
		    // 前面把/加入纯code了，需要去掉
		    if (needPureCode)
			{
			    rc.pureCode = strmid(rc.pureCode, 0, strlen(rc.pureCode) - 1)
			    bEndWithComment = TRUE
			}
			
		    // 本行有//注释标记
			if(!bStatedComment && (m_nStatMethod==1 || m_nStatMethod ==2))
			{
				bStatedComment = TRUE;
				rc.nCommentLines = rc.nCommentLines + 1;
			}
			bDoubleSplashFound = TRUE;
			i = i + 1
			break;
		}
		else if(szLine[i]=="/" && szLine[i+1]=="*" && !rc.bCommentSet && !rc.bQuatoSet)
		{
		    // 前面把/加入纯code了，需要去掉
		    if (needPureCode)
			{
			    rc.pureCode = strmid(rc.pureCode, 0, strlen(rc.pureCode) - 1)
			}

		    // 本行有/*注释标记
			if(!bStatedComment && (m_nStatMethod==1 || m_nStatMethod ==2))
			{
				bStatedComment = TRUE;
				rc.nCommentLines = rc.nCommentLines + 1;
			}
			rc.bCommentSet = TRUE;
			bSplashStarFound = TRUE;
			i = i + 1
			i = i + 1 //continue 之前需要补充一个i++
			continue
		}
		//计算代码行必须在bCommentSet关闭之前
		else if(szLine[i]!=gd_space() && szLine[i]!=gd_table() && !rc.bCommentSet)
		{		
			if(!bStatedCode)
			{
				bStatedCode = TRUE;
				rc.nCodeLines = rc.nCodeLines + 1;
			}
			if(szLine[i]=="\\")
			{//\之后的字符要跳过
				i = i + 1;
				i = i + 1
				continue;
			}
			if(szLine[i]=="\'")
			{
				if(szLine[i+1]=="\\")
					i = i + 2;
				else
					i = i + 1;
				i = i + 1
				continue;
			}
			if(szLine[i]=="\"")
			{//"必须引起重视，感谢ltzhou
				rc.bQuatoSet = !rc.bQuatoSet;
			}
		}
		else if(szLine[i]=="*" && szLine[i+1]=="/" && rc.bCommentSet && !rc.bQuatoSet)
		{
			if(!bStatedComment && (m_nStatMethod==1 || m_nStatMethod ==2))
			{
				bStatedComment = TRUE;
				rc.nCommentLines = rc.nCommentLines + 1;
			}
			rc.bCommentSet = FALSE;
			bSplashStarFound = TRUE;
			i = i + 1;	

			if ((i == line_len - 2)||(i == line_len - 1))
			{
			    bEndWithComment = TRUE
			}
		}

		// 非continue都在这里自加
		i = i + 1
	}	

	if (!bEndWithComment) // 不是以* /结束
	{
	    // 把最后一个字符加入代码
		if (needPureCode)
		{
		    rc.pureCode = cat(rc.pureCode, szLine[line_len - 1])
		}	
	}

	if(bDoubleSplashFound)
	{
		if(m_nStatMethod==2 && bStatedCode) //如果统计方法为第三种，且同时有代码行与注释行，则只计注释行
		{
			rc.nCodeLines = rc.nCodeLines - 1;
		}
		if(m_nStatMethod==0 && !bStatedCode)//如果统计方法为第一种，且未作为代码行统计过，那么必为注释行
		{
			rc.nCommentLines = rc.nCommentLines + 1;
		}
		return rc;
	}

	if(szLine[line_len - 1]=="\""&&!rc.bCommentSet)
	{//若某行最后一个是"，则必定用来关闭bQuatoSet，记代码行一行，否则报错
		rc.bQuatoSet = !rc.bQuatoSet;
		if(!rc.bQuatoSet)
		{
			if(!bStatedCode)
			{
				bStatedCode = TRUE;
				rc.nCodeLines = rc.nCodeLines + 1;
			}
		}
		else
		{
		/*	CStdioFile fileLog;				
			if(fileLog.Open(m_strLogFile, CFile::modeCreate|CFile::modeWrite|CFile::modeNoTruncate)==TRUE)
			{
				CString strMsg;
				if(fileLog.GetLength()==0)
				{
					strMsg.Format("文件\t行\t问题\n", strFileName, nLines);
					fileLog.WriteString(strMsg);
				}
				strMsg.Format("%s\t%d\t字符串换行未用\\\n", strFileName, nLines);
				fileLog.WriteString(strMsg);
				fileLog.Close();
			}*/
		}
		return rc;
	}

	if(szLine[line_len-1]!=' ' && szLine[line_len-1]!='\t' && !rc.bCommentSet
		&& szLine[line_len-2]!='*' && szLine[line_len-1]!='/')
	{//如果最后一个字符非空格或制表符，且前面无/*，最后两个字符不是*/，则为代码行
		if(!bStatedCode)
		{
			bStatedCode = TRUE;
			rc.nCodeLines = rc.nCodeLines + 1;
		}
	}

	if(bSplashStarFound)
	{
		if(m_nStatMethod==2 && bStatedCode) //如果统计方法为第三种，且同时有代码行与注释行，则只计注释行
		{
			rc.nCodeLines = rc.nCodeLines - 1;
		}

		if(m_nStatMethod==0 && !bStatedCode && !bStatedComment)	//若该行无代码如    /*abc*/ //222
																//但是统计方法是第一种，则需要追加注释行计数一次
		{
			bStatedComment = TRUE;
			rc.nCommentLines = rc.nCommentLines + 1;
		}
	}

	if(!bStatedComment && rc.bCommentSet)//可能是前面有/*，在第一种统计方法中，未作为代码行计算过，那么本行肯定是注释行
	{
		if(m_nStatMethod==0 && !bStatedCode)
		{
			bStatedComment = TRUE;
			rc.nCommentLines = rc.nCommentLines + 1;
		}
	}

//		if(bQuatoSet && bufRead[bufRead.GetLength()-1]=='"')
//		{
//			bQuatoSet = FALSE;
//		}

	if(rc.bQuatoSet && szLine[line_len-1]!='\\')
	{
	/*	CStdioFile fileLog;
		if(fileLog.Open(m_strLogFile, CFile::modeCreate|CFile::modeWrite|CFile::modeNoTruncate)==TRUE)
		{
			CString strMsg;
			if(fileLog.GetLength()==0)
			{
				strMsg.Format("文件\t行\t问题\n", strFileName, nLines);
				fileLog.WriteString(strMsg);
			}
			strMsg.Format("%s\t%d\t字符串换行未用\\\n", strFileName, nLines);
			fileLog.WriteString(strMsg);
			fileLog.Close();
		}*/
	}

    // 少了这个则相当于return ""，会出现异常
	return rc

}

// 判断nPos是否在字符串中
macro gd_instring(szLine, nPos)
{
    bInStr = false
    
    quotCnt = 0
    while (true)
    {
        quotPos = gd_strfind(szLine, "\"")
        if (quotPos < 0)
        {
            break
        }

        if (quotPos < nPos)
        {
            if (quotCnt == 0)
            {
                quotCnt = 1
            }
            else
            {
                quotCnt = 0
            }
        }
        else
        {
            break
        }
    }

    if (quotCnt > 0)
    {
        // 是字符串
        bInStr = true
    }

    return bInStr
}

macro gd_strfind_from(string, find, nFrom)
{
    if ((nFrom < 0) || (nFrom > strlen(string) - strlen(find)))
    {
        return -1
    }
    tempString = strmid(string, nFrom, strlen(string))
    nFind = gd_strfind(tempString, find)
    if (nFind < 0)
    {
        return -1
    }

    return nFrom + nFind
}

macro gd_nextline(string, nStart)
{
    if (nStart >= strlen(string))
    {
        return ""
    }
    
    rc = ""

    newline = gd_newline()
    endPos = gd_strfind_from(string, newline, nStart)
    if (endPos < 0)
    {
        rc.line = strmid(string, nStart, strlen(string))
        rc.nextPos = strlen(string)
    }
    else
    {
        rc.line = strmid(string, nStart, endPos)
        rc.nextPos = endPos + strlen(newline)
    }

    return rc
}

/*****************************************************************************
 *  函数名称   : gd_get_username
 *  功能描述   : 设置用户名字.
 *  输入参数   : 无
 *  返 回 值       : 无
 *  其它说明   : 该用户名字会在自动生成的注释中出现.
                                SourceInsight的环境变量在关机之后消失了,
                                所以需要使用注册表.
 *****************************************************************************/
macro gd_UserName()
{
    return GetEnv("SI_USER")
}

/*****************************************************************************
 *  函数名称   : gd_get_copyright
 *  功能描述   : 获取版权信息.
 *  输入参数   : 无
 *  返 回 值       :版权字符串
 *  其它说明   : .
 *****************************************************************************/
macro gd_Copyright()
{
    return GetEnv("SI_COPYRIGHT")
}

/*****************************************************************************
 *  函数名称   : gd_assignkey
 *  功能描述   : 分配快捷键给指定命令/宏.
 *  输入参数   : key                -   单字节字符串, 与Ctrl,Alt一起构成快捷键.
                              : cmd_name     -   命令名称或者宏的名字
 *  返 回 值       : 无
 *  其它说明   : 如果该快捷键已分配,弹出提示,输入"yes"表示覆盖.
 *****************************************************************************/
macro gd_assignkey(hhelp, key, cmd_name, cmd_description)
{
    //KeyFromChar(char, fCtrl, fShift, fAlt)

    // 获取批处理设置的功能组合基础键
    // 设为Alt, 用起来比较方便
    gd_ctrl = GetEnv("HOT_KEY_CTRL")
    gd_alt  = GetEnv("HOT_KEY_ALT")
    gd_shift = GetEnv("HOT_KEY_SHIFT")

    if ((gd_ctrl == "") && (gd_alt == "") && (gd_shift == "")) // 未设置
    {
        gd_ctrl = 1;
        gd_alt = 1
        gd_shift = 0
    }
    szHotKey = ""
    if (gd_ctrl == 1)
    {
        if (szHotKey == "") szHotKey = "Ctrl"
        else szHotKey = cat(szHotKey, "+Ctrl")
    }
    if (gd_alt == 1)
    {
        if (szHotKey == "") szHotKey = "Alt"
        else szHotKey = cat(szHotKey, "+Alt")
    }
    if (gd_shift == 1)
    {
        if (szHotKey == "") szHotKey = "Shift"
        else szHotKey = cat(szHotKey, "+Shift")
    }
    if (szHotKey == "")
    {
        msg "Hot key must use Ctrl/Shift/Alt."
        return
    }

    key_code = KeyFromChar(key, gd_ctrl, gd_shift, gd_alt)
    if (GetEnv("ALL_REPLACE") != "1") // 不是全部替换
    {        
        old_cmd = CmdFromKey(key_code)
        if (old_cmd != "")
        {
            answer = Ask("@szHotKey@+@key@ has been assigned to @old_cmd@, replace it?(Input \"yes\" or \"all\" to replace or replace all, otherwise not replace)")
            answer = tolower(answer)
            if (answer == "yes")
            {
                // 把当前冲突的老的快捷键替换为新的
            }
            else if (answer == "all")
            {
                // 保存状态为把老的快捷键替换为新的
                PutEnv("ALL_REPLACE", "1")
            }
            else // if (answer == "ignore")
            {
                // 跳过这一个快捷键的设置
                msg ("Assign @szHotKey@+@key@ to @cmd_name@ fail!")
                return        
            }
        }
    }

    // 分配快捷键给宏/命令, 如果已经分配该快捷键则被覆盖
    AssignKeyToCmd(key_code, cmd_name)

    // 在 全局变量中保存帮助信息
    //global g_gd_help

    //newline = gd_newline()
    //g_gd_help = cat(g_gd_help, "@szHotKey@+@key@                 :    @cmd_name@  @cmd_description@ @newline@")
    AppendBufLine(hhelp, "@szHotKey@+@key@                 :    @cmd_name@  @cmd_description@")
}

macro gd_newline()
{
    // 注意字符串长度有意安排为与"@newline@"相同,便于用例设计
    newline = "$$$^^^&&&"
    //newline = cat(newline, CharFromAscii(13))
    //newline = cat(newline, CharFromAscii(10)) // 这种方式也不能使得最后的输出换行
    return newline
}

macro gd_print(hbuf)
{
    SetCurrentBuf(hbuf) // put search results in a window
    SetBufDirty(hbuf, FALSE)  // don't bother asking to save
    //CloseBuf(hbuf) // 不能close, close了就看不到了
}

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
date = gd_Date()
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
InsBufLine(hbuf, 2, " * Copyright: " # gd_Copyright())
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
macro gd_GetCurSymbolLoc()
{
    symbol = GetCurSymbol()

    //msg symbol

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
        //msg loc
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

// 查找整个单词(与strfind相比，限制词的开始和结束)
macro gd_strfind_word(string, find)
{
    pos = gd_strfind(string, find)
    if (pos < 0)
    {
        return -1
    }

    isBegin = FALSE
    if (pos == 0)
    {
        isBegin = TRUE
    }

    if (!isBegin)
    {
        if (gd_IsWhiteChar(string[pos - 1]))
        {
            isBegin = TRUE
        }
        else
        {
            // 开始位置不是Word开始
            return -1
        }
    }

    endPos = pos + strlen(find)
    if (endPos >= strlen(string))
    {
        // find结束也就是行结束
        return pos
    }

    if (gd_IsWhiteChar(string[endPos]))
    {
        return pos
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
    string = gd_skipws(string)
    len = strlen(string)
    if (len <= 0)
    {
        return ""
    }

    leftCnt = 0    // <的个数

    rc = ""

    i = 0
    while ( i < len )
    {
        if ((string[i] == ",") && (leftCnt == 0)) // 不在<>中，且遇到逗号,说明找到一个参数结束标记
        {
            type_param = strmid(string, 0, i)            
            rc = gd_ParseParam(type_param)
            rc.remain = strmid(string, i + 1, len)
            return rc;
        }
        if (string[i] == "<")
        {
            leftCnt = leftCnt + 1
        }
        else if (string[i] == ">")
        {
            if (leftCnt > 0)
            {
                leftCnt = leftCnt - 1
            }
            else
            {
                 msg("\"<\" and \">\" not match!")
            }
        }
        i = i + 1
    }

    // 走到这里说明只有一个参数    
    rc = gd_ParseParam(string)
    rc.remain = ""
    return rc;
}

// 去掉首尾的空白字符
macro gd_strtrim(string)
{
    string = gd_skipws(string)

    len = strlen(string)
    if (len <= 0)
    {
        return ""
    }

    bTailWs = False
    
    i = len - 1
    while ( i >= 0)
    {
        if ((string[i] == gd_space()) ||(string[i] == gd_table()))
        {
            i = i - 1
            bTailWs = True
            continue;
        }
        break
    }

    if (bTailWs)
    {
        string = strmid(string, 0, i + 1)
    }
    return string
}

// 把第一个匹配到的src替换为dst
macro gd_strreplace(string, src, dst)
{
    result = ""
    pos = gd_strfind(string, src)
    if (pos < 0)
    {
        return string
    }
    result = cat(result, strmid(string, 0, pos))
    result = cat(result, dst)
    result = cat(result, strmid(string, pos + strlen(src), strlen(string)))

    return result
}

macro gd_IsWhiteChar(ch)
{
    if ((ch == gd_space()) || (ch == gd_table()))
    {
        return TRUE
    }

    return FALSE
}

macro gd_ParseParam(string)
{
    rc = ""
    rc.type = ""
    rc.name = ""

    string = gd_strtrim(string)
    len = strlen(string)
    if (len <= 0)
    {
        return rc
    }

    nameStart = gd_strrch_ws(string)
    if (nameStart <= 0)
    {
        rc.type = string
        rc.name = ""
        return rc
    }

    // 如果有=则后面的是默认参数,需要重新找变量名
    i = nameStart - 1
    while (i >= 0)
    {
        if (gd_IsWhiteChar(string[i]))
        {
            i = i - 1
            continue
        }

        if (string[i] == "=")
        {
            // 需要重新调整nameStart
            string = strmid(string, 0, i)
            string = gd_strtrim(string)
            nameStart = gd_strrch_ws(string)
            if (nameStart <= 0)
            {
                msg string # " = something , no var name." 
                rc.type = string
                rc.name = ""
                return rc
            }            
        }
        break
    }
 
    if ((string[nameStart + 1] == "&")||(string[nameStart + 1] == "*")) // 引用和指针符号可能紧接着变量名
    {
        nameStart = nameStart + 1
        while ((string[nameStart] == "&")||(string[nameStart] == "*"))
        {
            nameStart = nameStart + 1
            if (nameStart >= len)
            {
                // 正常情况不可能
                //return rc
                break
            }
        }
    }

    rc.type = gd_strtrim(strmid(string, 0, nameStart))
    rc.name = gd_strtrim(strmid(string, nameStart, strlen(string)))

    return rc
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
        rec = "type=\"" # param.type # "\";name=\"" # param.name # "\""
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

macro gd_Date()
{ 
    szTime = GetSysTime(1)
    Year = szTime.Year
    Month = szTime.Month
    Day = szTime.Day
    return "@Year@-@Month@-@Day@"
}

macro gd_DateTime()
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


