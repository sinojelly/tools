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

/*****************************************************************************
 *  ��������   : GD_setup
 *  ��������   : GD Source Insight��������.
 *  �������   : ��
 *  �� �� ֵ       : ��
 *  ����˵��   : ����ÿ�ݼ��ѷ���,������ʾ,����"yes"��ʾ����.
 *----------------------------------------------------------------------------  
 * ��ʷ��¼(�����, ������@�޸�����, ����˵��)  
 *  $0000000(N/A),  chengodong @2009-3-15 19:23,  ��������  
 *----------------------------------------------------------------------------      
 */
macro GD_setup()
{    
    //GD_modifybase() �����������޸�Base���̼�������ļ�

    GD_setupkey()

    GD_help()

    stop
}

/*****************************************************************************
 *  ��������   : GD_setupkey
 *  ��������   : GD Source Insight��������.
 *  �������   : ��
 *  �� �� ֵ       : ��
 *  ����˵��   : ����ÿ�ݼ��ѷ���,������ʾ,����"yes"��ʾ����.
 *----------------------------------------------------------------------------  
 * ��ʷ��¼(�����, ������@�޸�����, ����˵��)  
 *  $0000000(N/A),  chengodong @2009-3-15 19:23,  ��������  
 *----------------------------------------------------------------------------      
 */
macro GD_setupkey()
{
    g_gd_help = "" 

    // Ctrl+Alt+H   ��Ӻ���ͷ����ͷ��
    gd_assignkey("h", "GD_AddHeader", "add class/function/struct/etc. header.")

    // Ctrl+Alt+M  �޸ĺ���ͷ����ͷ, �����޸���ʷ��
    gd_assignkey("m", "GD_modifyheader", "modify class/function/struct/etc. header, add modify history.")
}

/*****************************************************************************
 *  ��������   : GD_help
 *  ��������   : GD Source Insight�������.
 *  �������   : ��
 *  �� �� ֵ       : ��
 *  ����˵��   : 
  *----------------------------------------------------------------------------  
 * ��ʷ��¼(�����, ������@�޸�����, ����˵��)  
 *  $0000000(N/A),  chengodong @2009-3-15 19:23,  ��������  
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
 *  ��������   : GD_addheader
 *  ��������   : ����class/func/etc. header .
 *  �������   : ��
 *  �� �� ֵ       : ��
 *  ����˵��   : 
        �ں���/�����κ�λ�ô�������꣬�Ϳ����ڸú���ǰ����Ϻ���/��ͷ

        ��֪����:
        ����GetCurSymbol��ģ�������κεط�������ģ������,
        ����ģ����ֻ���Զ�����ͷ,����ͷ�����Զ����.
 *----------------------------------------------------------------------------  
 * ��ʷ��¼(�����, ������@�޸�����, ����˵��)  
 *  $0000000(N/A),  chengodong @2009-3-15 19:23,  ��������  
 *---------------------------------------------------------------------------- 
 */
macro GD_AddHeader()
{
    global horizon

    if (horizon == "")
    {
        horizon = " \\internal --------------------------------------------------------------------"
    }
    
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
    
    // ��ȡ��������ǰ��հ��ַ�����,������������.
    szFirstLine = GetBufLine(hbuf, ln)
    
    headws = gd_head_wsnum(szFirstLine)
    
    szAlign = ""
    nTmp = headws.spaceCnt
    while (nTmp--)
    {
        szAlign = cat(szAlign, " ")
    }

    if (gd_ModifyHeader(hbuf, ln, szAlign)) // �Ѿ���ͷֻ���޸���
    {
        return
    }

    // ��ȡ��������,����ע��(���ڽ�������)
    symDeclare = gd_CurSymbolDeclare()
    if (symDeclare == "")
    {
         return
    }

    szFunction = symDeclare
    
    // ��ȡ������Ϣ
    // ����ģ����� 
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

            szFunction = strmid(symDeclare, endPos + 1, strlen(symDeclare)) // ��������
        }
    }

    ret = ""
    //��ȡ��������
    hFuncParams = hNil
    if ((loc.Type == "Method") || (loc.Type == "Function"))
    {
        leftPos = gd_strfind(szFunction, "(")
        rightPos = gd_strfind(szFunction, ")")
        szFuncParams = strmid(szFunction, leftPos + 1, rightPos)
        hFuncParams = gd_getparams(szFuncParams)
    
        //��ȡ����ֵ����
        spacePos = gd_strfind(szFunction, " ")
        spacePosT = gd_strfind(szFunction, "	")
        spacePos = gd_min(spacePos, spacePosT)
        if (spacePos > 0)
        {
            ret = strmid(szFunction, 0, spacePos)
        }        
    }

    brief = Ask("���������:")
    InsBufLine(hbuf, ln ++, szAlign # "/**")
    InsBufLine(hbuf, ln ++, szAlign # " @brief@.")    
    InsBufLine(hbuf, ln ++, szAlign # " \\internal ********************************************************************")
    InsBufLine(hbuf, ln ++, szAlign # " ����˵��(���ȿ�һ��) :")
    InsBufLine(hbuf, ln ++, szAlign # " ")
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
            InsBufLine(hbuf, ln ++, szAlign # " \\param  " # rec.name # gd_ParamAlign(rec.name) # " ")
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
            InsBufLine(hbuf, ln ++, szAlign # " \\param  " # rec.name # gd_ParamAlign(rec.name) #  " [" # gd_ParamTypeDescription(rec.type) # "]")
            i = i + 1
        }
        CloseBuf(hFuncParams)
    }
    if ((ret != "") && (ret != "void") && (ret != "VOID"))
    {
        ret_des = ""
        if ((ret == "BOOL") || (ret == "bool"))
        {
            ret_des = "TRUE - �ɹ�; FALSE - ʧ��."
        }
        InsBufLine(hbuf, ln ++, szAlign # " \\return  " # gd_ParamAlign("") # "@ret_des@")
    }
    InsBufLine(hbuf, ln ++, szAlign # " ")
    InsBufLine(hbuf, ln ++, szAlign # " \\internal ��ʷ��¼:")
    InsBufLine(hbuf, ln ++, szAlign # horizon)    
    InsBufLine(hbuf, ln ++, szAlign # " \\version 1.0")
    InsBufLine(hbuf, ln ++, szAlign # " \\author @szMyName@")
    InsBufLine(hbuf, ln ++, szAlign # " \\assessor ")
    InsBufLine(hbuf, ln ++, szAlign # " @date@")
    InsBufLine(hbuf, ln ++, szAlign # " \\note V1.0˵��: ����" # loc.Type # ".")
    InsBufLine(hbuf, ln ++, szAlign # horizon) 
    InsBufLine(hbuf, ln ++, szAlign # "*/")
    
    SetBufIns(hbuf, loc.lnFirst + 5, 1) // ���ͣ������˵������ʼλ��
}

macro gd_ModifyHeader(hbuf, ln, szAlign)
{
    if (ln < /*2*/ 5 ) // ǰ�治������, ʵ�ʵ�ע��ԶԶ��ֹ����
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

    // �������϶�ÿһ��,�ҵ�version
    lastVersion = gd_LastVersion(hbuf, ln - 2)

    if (lastVersion == "")
    {
        return False
    }

    thisVersion = gd_IncVersion(lastVersion)

    description = Ask("�������޸�����:")

    // ��������ǰ����horizon��* /��β�ĺ���ͷ����Ҫ������ʷ��¼
    ln = ln - 1
    InsBufLine(hbuf, ln ++, szAlign # " \\version @thisVersion@")
    InsBufLine(hbuf, ln ++, szAlign # " \\author " # gd_UserName())
    InsBufLine(hbuf, ln ++, szAlign # " \\assessor ")
    InsBufLine(hbuf, ln ++, szAlign # " " # gd_DateTime())
    InsBufLine(hbuf, ln ++, szAlign # " \\note V@thisVersion@˵��: " # description # ".")
    InsBufLine(hbuf, ln ++, szAlign # horizon) 

    return True
}

macro gd_LastVersion(hbuf, ln)
{
    versionStart = "\\version "
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
 *  ��������   : gd_ParamTypeDescription
 *  ��������   :���ݲ������ͻ�ü�Ҫ������Ϣ.
 *  �������   : ��
 *  �� �� ֵ       : ��
 *  ����˵��   :  
          �������ܼ�, ���в�������in����,
          ��const ���û���out����.
          ʹ������Ҫ����ʵ�������΢�޸�.
 *----------------------------------------------------------------------------  
 * ��ʷ��¼(�����, ������@�޸�����, ����˵��)  
 *  $0000000(N/A),  chengodong @2009-3-15 19:23,  ��������  
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

    if ((constPos < 0) && (type[len - 1] == "&")) // ���ò���û��const����
    {
        szDes = cat(szDes, " out")
    }

    return szDes
}

/*****************************************************************************
 *  ��������   : gd_SymbolDeclare
 *  ��������   : ��ȡ��ǰ����/��ȵ������ı�ʶ������
 *  �������   : ��
 *  �� �� ֵ       : ��
 *  ����˵��   :  ��lnFirst��ʼ, ��"{"Ϊֹ(������"{")��ȥ��ע�͡�
 *----------------------------------------------------------------------------  
 * ��ʷ��¼(�����, ������@�޸�����, ����˵��)  
 *  $0000000(N/A),  chengodong @2009-3-15 19:23,  ��������  
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
        if (/*(szLine == "") ||*/ (decEnd >= 0)) // ���л�����{ʱ��ֹ
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
 *  ��������   : gd_ParseCodeInit
 *  ��������   : ��������ļ�¼��ʼ��.
 *  �������   : ��
 *  �� �� ֵ       : ��
 *  ����˵��   :        
 *----------------------------------------------------------------------------  
 * ��ʷ��¼(�����, ������@�޸�����, ����˵��)  
 *  $0000000(N/A),  chengodong @2009-3-15 19:23,  ��������  
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
 *  ��������   : gd_ParseCodeLine
 *  ��������   : ����һ��C/C++����,��ó���ע�͵Ĵ�����
 *  �������   : ��
 *  �� �� ֵ       : ��
 *  ����˵��   : 
       ���˵õ������룬�˺�����������ͳ�ƴ�����.
       ��һ�ε���, rc��Ҫ���³�ʼ��(����gd_ParseCodeInit() ����)
       rc.bCommentSet = False
       rc.bQuatoSet = False
       rc.pureCode = ""
       rc.nLines = 0
       rc.nBlankLines = 0
       rc.nCommentLines = 0
       rc.nCodeLines = 0
 *----------------------------------------------------------------------------  
 * ��ʷ��¼(�����, ������@�޸�����, ����˵��)  
 *  $0000000(N/A),  chengodong @2009-3-15 19:23,  ��������  
 *---------------------------------------------------------------------------- 
 */
macro gd_ParseCodeLine(szLine, rc, needPureCode)
{
    global m_nStatMethod
    m_nStatMethod = 1    
    
	bStatedComment = FALSE;//������Ϊע�����Ƿ���ͳ�ƹ�
	bStatedCode = FALSE;   //������Ϊ�������Ƿ���ͳ�ƹ�

	rc.nLines = rc.nLines + 1;

	szLine = gd_skipws(szLine); //�Ƚ��ļ�ͷ�Ŀո���Ʊ��ȥ��

	if(szLine == "") //Ϊ�հ���
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
	{//������и�������ע�ͷ�����Ҫ����ע�ͷ���Ҫ���Ǵ�����
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
				// ����ȫ�Ǵ���
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
	        // �ַ�szLine[i]�������Ĵ���,������
			if (needPureCode)
			{
			    rc.pureCode = cat(rc.pureCode, szLine[i])
			}
	    }
		if(szLine[i]=="/" && szLine[i+1]=="/" && !rc.bCommentSet && !rc.bQuatoSet)
		{
		    // ǰ���/���봿code�ˣ���Ҫȥ��
		    if (needPureCode)
			{
			    rc.pureCode = strmid(rc.pureCode, 0, strlen(rc.pureCode) - 1)
			    bEndWithComment = TRUE
			}
			
		    // ������//ע�ͱ��
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
		    // ǰ���/���봿code�ˣ���Ҫȥ��
		    if (needPureCode)
			{
			    rc.pureCode = strmid(rc.pureCode, 0, strlen(rc.pureCode) - 1)
			}

		    // ������/*ע�ͱ��
			if(!bStatedComment && (m_nStatMethod==1 || m_nStatMethod ==2))
			{
				bStatedComment = TRUE;
				rc.nCommentLines = rc.nCommentLines + 1;
			}
			rc.bCommentSet = TRUE;
			bSplashStarFound = TRUE;
			i = i + 1
			i = i + 1 //continue ֮ǰ��Ҫ����һ��i++
			continue
		}
		//��������б�����bCommentSet�ر�֮ǰ
		else if(szLine[i]!=gd_space() && szLine[i]!=gd_table() && !rc.bCommentSet)
		{		
			if(!bStatedCode)
			{
				bStatedCode = TRUE;
				rc.nCodeLines = rc.nCodeLines + 1;
			}
			if(szLine[i]=="\\")
			{//\֮����ַ�Ҫ����
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
			{//"�����������ӣ���лltzhou
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

		// ��continue���������Լ�
		i = i + 1
	}	

	if (!bEndWithComment) // ������* /����
	{
	    // �����һ���ַ��������
		if (needPureCode)
		{
		    rc.pureCode = cat(rc.pureCode, szLine[line_len - 1])
		}	
	}

	if(bDoubleSplashFound)
	{
		if(m_nStatMethod==2 && bStatedCode) //���ͳ�Ʒ���Ϊ�����֣���ͬʱ�д�������ע���У���ֻ��ע����
		{
			rc.nCodeLines = rc.nCodeLines - 1;
		}
		if(m_nStatMethod==0 && !bStatedCode)//���ͳ�Ʒ���Ϊ��һ�֣���δ��Ϊ������ͳ�ƹ�����ô��Ϊע����
		{
			rc.nCommentLines = rc.nCommentLines + 1;
		}
		return rc;
	}

	if(szLine[line_len - 1]=="\""&&!rc.bCommentSet)
	{//��ĳ�����һ����"����ض������ر�bQuatoSet���Ǵ�����һ�У����򱨴�
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
					strMsg.Format("�ļ�\t��\t����\n", strFileName, nLines);
					fileLog.WriteString(strMsg);
				}
				strMsg.Format("%s\t%d\t�ַ�������δ��\\\n", strFileName, nLines);
				fileLog.WriteString(strMsg);
				fileLog.Close();
			}*/
		}
		return rc;
	}

	if(szLine[line_len-1]!=' ' && szLine[line_len-1]!='\t' && !rc.bCommentSet
		&& szLine[line_len-2]!='*' && szLine[line_len-1]!='/')
	{//������һ���ַ��ǿո���Ʊ������ǰ����/*����������ַ�����*/����Ϊ������
		if(!bStatedCode)
		{
			bStatedCode = TRUE;
			rc.nCodeLines = rc.nCodeLines + 1;
		}
	}

	if(bSplashStarFound)
	{
		if(m_nStatMethod==2 && bStatedCode) //���ͳ�Ʒ���Ϊ�����֣���ͬʱ�д�������ע���У���ֻ��ע����
		{
			rc.nCodeLines = rc.nCodeLines - 1;
		}

		if(m_nStatMethod==0 && !bStatedCode && !bStatedComment)	//�������޴�����    /*abc*/ //222
																//����ͳ�Ʒ����ǵ�һ�֣�����Ҫ׷��ע���м���һ��
		{
			bStatedComment = TRUE;
			rc.nCommentLines = rc.nCommentLines + 1;
		}
	}

	if(!bStatedComment && rc.bCommentSet)//������ǰ����/*���ڵ�һ��ͳ�Ʒ����У�δ��Ϊ�����м��������ô���п϶���ע����
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
				strMsg.Format("�ļ�\t��\t����\n", strFileName, nLines);
				fileLog.WriteString(strMsg);
			}
			strMsg.Format("%s\t%d\t�ַ�������δ��\\\n", strFileName, nLines);
			fileLog.WriteString(strMsg);
			fileLog.Close();
		}*/
	}

    // ����������൱��return ""��������쳣
	return rc

}

// �ж�nPos�Ƿ����ַ�����
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
        // ���ַ���
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
 *  ��������   : gd_get_username
 *  ��������   : �����û�����.
 *  �������   : ��
 *  �� �� ֵ       : ��
 *  ����˵��   : ���û����ֻ����Զ����ɵ�ע���г���.
                                SourceInsight�Ļ��������ڹػ�֮����ʧ��,
                                ������Ҫʹ��ע���.
 *****************************************************************************/
macro gd_UserName()
{
    return GetEnv("SI_USER")
}

/*****************************************************************************
 *  ��������   : gd_get_copyright
 *  ��������   : ��ȡ��Ȩ��Ϣ.
 *  �������   : ��
 *  �� �� ֵ       :��Ȩ�ַ���
 *  ����˵��   : .
 *****************************************************************************/
macro gd_Copyright()
{
    return GetEnv("SI_COPYRIGHT")
}

/*****************************************************************************
 *  ��������   : gd_assignkey
 *  ��������   : �����ݼ���ָ������/��.
 *  �������   : key                -   ���ֽ��ַ���, ��Ctrl,Altһ�𹹳ɿ�ݼ�.
                              : cmd_name     -   �������ƻ��ߺ������
 *  �� �� ֵ       : ��
 *  ����˵��   : ����ÿ�ݼ��ѷ���,������ʾ,����"yes"��ʾ����.
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

    // �����ݼ�����/����, ����Ѿ�����ÿ�ݼ��򱻸���
    AssignKeyToCmd(key_code, cmd_name)

    // �� ȫ�ֱ����б��������Ϣ
    global g_gd_help

    newline = gd_newline()
    g_gd_help = cat(g_gd_help, "Ctrl+Alt+@key@                 :    @cmd_name@  @cmd_description@ @newline@")
}

macro gd_newline()
{
    // ע���ַ����������ⰲ��Ϊ��"@newline@"��ͬ,�����������
    newline = "$$$^^^&&&"
    //newline = cat(newline, CharFromAscii(13))
    //newline = cat(newline, CharFromAscii(10)) // ���ַ�ʽҲ����ʹ�������������
    return newline
}

macro gd_print(hbuf)
{
    SetCurrentBuf(hbuf) // put search results in a window
    SetBufDirty(hbuf, FALSE)  // don't bother asking to save
    //CloseBuf(hbuf) // ����close, close�˾Ϳ�������
}

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
szDescription = Ask("�������ļ���������:")
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

// ������������(��strfind��ȣ����ƴʵĿ�ʼ�ͽ���)
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
            // ��ʼλ�ò���Word��ʼ
            return -1
        }
    }

    endPos = pos + strlen(find)
    if (endPos >= strlen(string))
    {
        // find����Ҳ�����н���
        return pos
    }

    if (gd_IsWhiteChar(string[endPos]))
    {
        return pos
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
    string = gd_skipws(string)
    len = strlen(string)
    if (len <= 0)
    {
        return ""
    }

    leftCnt = 0    // <�ĸ���

    rc = ""

    i = 0
    while ( i < len )
    {
        if ((string[i] == ",") && (leftCnt == 0)) // ����<>�У�����������,˵���ҵ�һ�������������
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

    // �ߵ�����˵��ֻ��һ������    
    rc = gd_ParseParam(string)
    rc.remain = ""
    return rc;
}

// ȥ����β�Ŀհ��ַ�
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

    // �����=��������Ĭ�ϲ���,��Ҫ�����ұ�����
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
            // ��Ҫ���µ���nameStart
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
 
    if ((string[nameStart + 1] == "&")||(string[nameStart + 1] == "*")) // ���ú�ָ����ſ��ܽ����ű�����
    {
        nameStart = nameStart + 1
        while ((string[nameStart] == "&")||(string[nameStart] == "*"))
        {
            nameStart = nameStart + 1
            if (nameStart >= len)
            {
                // �������������
                //return rc
                break
            }
        }
    }

    rc.type = gd_strtrim(strmid(string, 0, nameStart))
    rc.name = gd_strtrim(strmid(string, nameStart, strlen(string)))

    return rc
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
        rec = "type=\"" # param.type # "\";name=\"" # param.name # "\""
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


