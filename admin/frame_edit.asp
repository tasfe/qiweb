<!--#include file="../common.asp"-->
<!--#include file="../htmleditor/fckeditor.asp"-->
<%
	check_admin
	site_id=ufomail_request("QueryString","id")
	if site_id="" then
		err_msgbox "未传递任何参数"
	end if
	set rs=server.CreateObject("adodb.recordset")
	sql="select * from sitemap where id=" & site_id
	rs.open sql,conn,1,1
	if not rs.eof then
		frame=rs("frame")
		title=rs("title")
		language=rs("language")
	end if
	rs.close
	set rs=nothing
	if ufomail_request("Form","action")<>"" then
		frame=ufomail_request("Form","frame")
		all_frame=ufomail_request("Form","all_frame")
		input_label="frame|+|language"
		input_value=frame & "|+|" & language
		if all_frame="1" then
			sql="update sitemap set frame='" & frame & "' where [language]=" & language
			conn.execute sql
		else
			call db_save("edit","sitemap",input_label,input_value,"id=" & ufomail_request("Form","site_id"))
		end if
		response.redirect "frame_manager.asp?language=" & language
		response.end
	end if
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html xmlns:x86>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>设置<%=db_getvalue("id=" & language,"[language]","[language]")%>栏目样式</title>
<?IMPORT NAMESPACE="x86" IMPLEMENTATION="RichEdit.htc"?>
<link href="../css.css" rel="stylesheet" type="text/css">
</head>

<body>

<!--功能标题-->
<div class="page-title">设置<%=db_getvalue("id=" & language,"[language]","[language]")%>栏目样式</div>
<%if return_info<>"" then%>
<div class="return-info"><%=return_info%></div>
<%end if%>
<div class="help-info">说明： <br>
  1、此处可以定制特殊的样目装饰样式，如不修改，将使用模板的默认设置；<br>
  2、如要使用模板设置，请留空！<br>
</div>
<div class="oper-content"> 
	<div class="help-info">
		你正在设置的栏目样式是：<%=title%>
	</div>
  <form name="form1" method="post" action="">
    <table width="95%" border="1" cellpadding="6" cellspacing="0" bordercolor="#CCCCCC" class="table-cell">
      <tr> 
        <td width="100" align="right" bgcolor="#f2f8ff">样式：</td>
        <td><%
				Dim oFCKeditor
				Set oFCKeditor = New FCKeditor
				oFCKeditor.ToolbarSet = "MyToolbar"
				oFCKeditor.Config("LinkBrowser") = "true" 
				oFCKeditor.Config("ImageBrowser") = "true" 
				oFCKeditor.Config("FlashBrowser") = "true" 
				oFCKeditor.Config("LinkUpload") = "true" 
				oFCKeditor.Config("ImageUpload") = "true" 
				oFCKeditor.Config("FlashUpload") = "true" 
				oFCKeditor.Width = "100%"
				oFCKeditor.Height = "300"
				oFCKeditor.Value = frame
				oFCKeditor.Create "frame"
				%> </td>
      </tr>
      <tr> 
        <td align="right" bgcolor="#f2f8ff">&nbsp;</td>
        <td><input type="submit" name="action" value="保存"> <input name="reset" type="reset" class="bt" id="reset" value="重置"> 
          <input name="site_id" type="hidden" id="lyb_id" value="<%=site_id%>">
          <input name="all_frame" type="checkbox" id="all_frame" value="1">
          将此样式应用到所有栏目中</td>
      </tr>
    </table>
    </form>
</div>
<br>
<div class="page-foot"><%=db_getvalue("setup_name='page_foot'","sys_setup","setup_value")%></div><br>
</body>
</html>
