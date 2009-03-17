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
    //GD_modifybase() 在批处理中修改Base工程加入这个文件

    GD_setupkey()

    GD_help()

    stop
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
    g_gd_help = "" 

    // Ctrl+Alt+H   添加函数头、类头。
    gd_assignkey("h", "GD_AddHeader", "add class/function/struct/etc. header.")

    // Ctrl+Alt+M  修改函数头、类头, 增加修改历史。
    gd_assignkey("m", "GD_modifyheader", "modify class/function/struct/etc. header, add modify history.")
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

}

/*****************************************************************************
 *  函数名称   : GD_addheader
 *  功能描述   : 增加class/func/etc. header .
 *  输入参数   : 无
 *  返 回 值       : 无
 *  其它说明   : 
        在函数/类中任何位置触发这个宏，就可以在该函数前面加上函数/类头
 *----------------------------------------------------------------------------  
 * 历史记录(变更单, 责任人@修改日期, 操作说明)  
 *  $0000000(N/A),  chengodong @2009-3-15 19:23,  创建函数  
 *---------------------------------------------------------------------------- 
 */
macro GD_AddHeader()
{
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
    while (nTmp--)
    {
        szAlign = cat(szAlign, " ")
    }
msg 1
    // 获取完整声明,不含注释
    symDeclare = gd_CurSymbolDeclare()
    if (symDeclare == "")
    {
         return
    }

    szFunction = symDeclare
msg szFunction    
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
msg szFunction
    ret = ""
    //获取函数参数
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
msg ret
    brief = Ask("请输入简述:")
    InsBufLine(hbuf, ln ++, szAlign # "/**")
    InsBufLine(hbuf, ln ++, szAlign # " @brief@.")    
    InsBufLine(hbuf, ln ++, szAlign # " \\internal ********************************************************************")
    InsBufLine(hbuf, ln ++, szAlign # " \\internal 其它说明(请先空一行) :")
    InsBufLine(hbuf, ln ++, szAlign # " ")
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
            InsBufLine(hbuf, ln ++, szAlign # " \\param  " # rec.param # " ")
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
            InsBufLine(hbuf, ln ++, szAlign # " \\param  " # rec.param # " ")
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
        InsBufLine(hbuf, ln ++, szAlign # " \\return " # szParamAlign # "@ret_des@")
    }
    InsBufLine(hbuf, ln ++, szAlign # " ")
    InsBufLine(hbuf, ln ++, szAlign # " \\internal 历史记录:")
    InsBufLine(hbuf, ln ++, szAlign # " \\internal --------------------------------------------------------------------")    
    InsBufLine(hbuf, ln ++, szAlign # " \\version 1.0")
    InsBufLine(hbuf, ln ++, szAlign # " \\author @szMyName@")
    InsBufLine(hbuf, ln ++, szAlign # " \\assessor ")
    InsBufLine(hbuf, ln ++, szAlign # " @date@")
    InsBufLine(hbuf, ln ++, szAlign # " \\note V1.0说明: 创建" # loc.Type # ".")
    InsBufLine(hbuf, ln ++, szAlign # " \\internal --------------------------------------------------------------------") 
    InsBufLine(hbuf, ln ++, szAlign # "*/")
    
    SetBufIns(hbuf, loc.lnFirst + 5, 1) // 光标停在其它说明的起始位置
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
    global m_nStatMethod
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
macro gd_assignkey(key, cmd_name, cmd_description)
{
    //KeyFromChar(char, fCtrl, fShift, fAlt)
    
    key_code = KeyFromChar(key, 1, 0, 1)
    old_cmd = CmdFromKey(key_code)
    if (old_cmd != "")
    {
        answer = Ask("Ctrl+Alt+@key@ has been assigned to @old_cmd@, replace it?(Input \"yes\" to replace, otherwise not replace)")
        if (!(tolower(answer) == "yes"))
        {
            msg ("Assign Ctrl+Alt+@key@ to @cmd_name@ fail!")
            return
        }
    }

    // 分配快捷键给宏/命令, 如果已经分配该快捷键则被覆盖
    AssignKeyToCmd(key_code, cmd_name)

    // 在 全局变量中保存帮助信息
    global g_gd_help

    newline = gd_newline()
    g_gd_help = cat(g_gd_help, "Ctrl+Alt+@key@                 :    @cmd_name@  @cmd_description@ @newline@")
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
macro gd_GetCurSymbolLoc()
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


