<!--#include file="common.asp"-->
<%
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''	文档作用：选择上传文件 
''	创建时间：2005-3-12 
''	修改情况：	2005-6-2 为文件查找链接做了一点小修改 (朱祺艺)
''				2005-7-23 增加了添加文件详情的功能(朱祺艺)
''				2005-10-29 修改了数据库的打开方式,以优化系统运行速度(朱祺艺)
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
set rs=server.CreateObject("adodb.recordset")
filename=request.querystring("filename") 
f_search=true
f_detail=true
if instr(filename,";")<>0 then
	temp_var=split(filename,";")
	select case ubound(temp_var)
		case 0
			f_name=temp_var(0)
		case 1
			f_name=temp_var(0)
			f_form=temp_var(1)
		case 2
			f_name=temp_var(0)
			f_form=temp_var(1)
			f_search=cbool(temp_var(2))
		case else
			f_name=temp_var(0)
			f_form=temp_var(1)
			f_search=cbool(temp_var(2))
			f_detail=cbool(temp_var(3))
	end select
end if		
%>
<script>
if (top.location==self.location){
	top.location="index.asp"
}
</script>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title><%=site_name%></title>
<%=page_head%>
<style type="text/css">
<!--
body {
	font-size: 9pt;
}
-->
</style>
</head> 
<%
if db_getvalue("setup_name='upload_bar'","sys_setup","setup_value")="true" then
	progress_bar=true
else
	progress_bar=false
end if
if progress_bar and db_getvalue("setup_name='upload_object'","sys_setup","setup_value")="1" then
Set UploadProgress = Server.CreateObject("Persits.UploadProgress")
PID = "PID=" & UploadProgress.CreateProgressID()
barref = "framebar.asp?to=10&" & PID
%>
<SCRIPT LANGUAGE="JavaScript">
	function ShowProgress()
	{
		strAppVersion = navigator.appVersion;
		if (document.form1.file1.value!="" )
		{
			if (strAppVersion.indexOf('MSIE') != -1 && strAppVersion.substr(strAppVersion.indexOf('MSIE')+5,1) > 4)
			{
				winstyle = "dialogWidth=375px; dialogHeight:130px; center:yes";
				window.showModelessDialog('<%=barref%>&b=IE',null,winstyle);
			}
			else
			{
				window.open('<%=barref%>&b=NN','','width=370,height=115',true);
			}
		}
		return true;
	}
</SCRIPT> 
<% end if%>
<body text="#000000" leftmargin="0" topmargin="0">
<div id='upload_document'>
<form name="form1" method="post" action="upfile.asp<%'if progress_bar then response.write "?" & PID%>" enctype="multipart/form-data"  > 
    <input type="hidden" name="filename" value="<%=request.querystring("filename")%>">
    <input type="file" name="file1" style="width:200;border: 1px solid #999999;font_size: 9 pt;" onChange="javascript:document.form1.Submit1.focus()">
    <input type="button" name="Submit1" value="上传" style="width:40;border: 1px solid #999999;font_size: 9 pt;" onclick="form_submit()" tabindex="0">
	<%
	if f_search=true then 
	%>
  	<input type="button" name="Button" value="查找" style="width:40;border: 1px solid #999999;font_size: 9 pt;" onClick="select_files('<%=f_form%>')">
	<%
	end if
	if f_detail=true then
	%>
    <input name="add_detail" type="checkbox" id="add_detail" value="1" onClick="show_detail()">
    详情 
	<%
	else
	%>
	<input name="add_detail" type="hidden" id="add_detail" value="" onClick="show_detail()">
	<%
	end if
	%>
    <hr size="1">
    <table border="0" align="center" cellpadding="6" cellspacing="0" class="all_border">
      <tr> 
        <td><table border="0" align="center" cellpadding="6" cellspacing="0" class="all_border">
            <tr> 
              <td align="right" valign="top" bgcolor="#F0F4F9"><div align="right" class="norap">图片名称：</div></td>
              <td><input name="file_title" type="text" class="all_border_h" id="file_title" style="width:220" title="可以双击查找已经归档的文件名称!" onDblClick="select_filerealname()">
                * </td>
            </tr>
            <tr> 
              <td align="right" valign="top" bgcolor="#F0F4F9"><div align="right" class="norap">图片概要：</div></td>
              <td> <textarea name="file_desc" class="all_border_h" id="file_desc" style="width:220;height:80"></textarea></td>
            </tr>
          </table>
          </td>
      </tr>
    </table>
    </form>
<script language="JavaScript">
function form_submit()
{
var ufo,ufo1
if(parent.document.forms(0).<%=f_form%>upload_fileext.value!="")
{
	ufo=parent.document.forms(0).<%=f_form%>upload_fileext.value
	ufo="|" + ufo.toLowerCase() + "|"
	ufo1=document.forms(0).file1.value
	ufo1=ufo1.substr(ufo1.lastIndexOf(".")+1)
	ufo1="|" + ufo1.toLowerCase() + "|"
	if (ufo.indexOf(ufo1)>=0) 
		{
		document.form1.submit();
		document.form1.Submit1.disabled=true;
		<%
		if progress_bar then response.write "return ShowProgress();"
		%>
		}
	else
		{
		window.alert("文件格式不对！\n\n文件格式要求是：" + parent.document.forms(0).<%=f_form%>upload_fileext.value + "\n\n请重新上传格式正确的文件！\n\n注意：请不要将文件的后缀更改后上传！")
		}
	}
else
{
	document.form1.submit();
	document.form1.Submit1.disabled=true;
	<%
	if progress_bar then response.write "return ShowProgress();"
	%>
}
}
function show_detail()
{
	if(window.event.srcElement.checked==true )
		{
		parent.document.all("upload_form<%=f_form%>").height=180
		}
	else
		{
		parent.document.all("upload_form<%=f_form%>").height=22
		}
}
</script>
</div>
<!--下面script用于控制主界面------------------------------->
<script language="JavaScript">
if (parent.document.all("upload_form<%=f_form%>").height!=22) 
{
window.document.form1.add_detail.checked=false
}
function hidden_detail()
{
	parent.document.all("upload_form<%=f_form%>").height=22
}	
</script>
</body>
</html>