<!--#include file="../common.asp"-->
<!--#include file="../htmleditor/fckeditor.asp"-->
<%
	check_admin
	show_language=db_getvalue("setup_name='show_language'","sys_setup","setup_value")
	if ufomail_request("Form","action")<>"" then
		set rs=server.CreateObject("adodb.recordset")
		sql="select * from [language] where id in(" & show_language & ")"
		rs.open sql,conn,1,3
		do while not rs.eof 
			rs("site_adv")=ufomail_request("Form","site_adv_" & rs("id"))
			rs.update
			rs.movenext
		loop
		rs.close
		set rs=nothing
		response.redirect "adv_manager.asp"
		response.end
	end if
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html xmlns:x86>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>广告条管理</title>
<?IMPORT NAMESPACE="x86" IMPLEMENTATION="RichEdit.htc"?>
<link href="../css.css" rel="stylesheet" type="text/css">
</head>

<body>

<!--功能标题-->
<div class="page-title">广告条管理</div>
<%if return_info<>"" then%>
<div class="return-info"><%=return_info%></div>
<%end if%>
<div class="help-info">系统帮助： <br>
  1、在下面代码框中分别输入各个语言版本的广告代码！<br>
</div>
<div class="oper-content"> 
  <form name="form1" method="post" action="">
<table width="95%" border="1" cellpadding="6" cellspacing="0" bordercolor="#CCCCCC" class="table-cell">
        <%
			Dim oFCKeditor
			Set oFCKeditor = New FCKeditor
			oFCKeditor.ToolbarSet = "UfoToolbar"
			oFCKeditor.Width = "100%"
			oFCKeditor.Height = "200"
			oFCKeditor.Config("LinkBrowser") = "true" 
			oFCKeditor.Config("ImageBrowser") = "true" 
			oFCKeditor.Config("FlashBrowser") = "true" 
			oFCKeditor.Config("LinkUpload") = "true" 
			oFCKeditor.Config("ImageUpload") = "true" 
			oFCKeditor.Config("FlashUpload") = "true" 

			gb_to_big5=db_getvalue("setup_name='gb_to_big5'","sys_setup","setup_value")
			set rs=server.CreateObject("adodb.recordset")
			sql="select * from [language] where id in(" & show_language & ") order by id"
			rs.open sql,conn,1,1
			do while not rs.eof
			if rs("id")=2 and gb_to_big5="true" then
			else
		%>
		<tr> 
        <td width="100" align="right" bgcolor="#f2f8ff"><%=rs("language")%>网站广告：</td>
          <td><%
				
				oFCKeditor.Value = rs("site_adv")
				oFCKeditor.Create "site_adv_" & rs("id")
				%></td>
        </tr>
		<%
			end if
				rs.movenext
			loop
			rs.close
			set rs=nothing
		%>
        <tr> 
          <td align="right" bgcolor="#f2f8ff">&nbsp;</td>
        <td><input type="submit" name="action" value="保存"> 
          <input name="reset" type="reset" class="bt" id="reset" value="重置"> 
            <input name="lyb_id" type="hidden" id="lyb_id" value="<%=question_id%>"></td>
        </tr>
      </table>
    </form>
</div>
<br>
<div class="page-foot"><%=db_getvalue("setup_name='page_foot'","sys_setup","setup_value")%></div><br>
</body>
</html>
