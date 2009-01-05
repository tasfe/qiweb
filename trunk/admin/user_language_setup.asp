<!--#include file="../common.asp"-->
<!--#include file="../htmleditor/fckeditor.asp"-->
<%
	
	check_admin
	setup_name=ufomail_request("querystring","name")
	show_language=db_getvalue("setup_name='show_language'","sys_setup","setup_value")
	if ufomail_request("Form","action")<>"" then
		setup_name=ufomail_request("form","setup_name")
		set rs=server.CreateObject("adodb.recordset")
		sql="select * from [language] where id in(" & show_language & ")"
		rs.open sql,conn,1,3
		do while not rs.eof 
			rs(setup_name)=ufomail_request("Form",setup_name & "_" & rs("id"))
			rs.update
			rs.movenext
		loop
		rs.close
		set rs=nothing
		response.redirect "user_language_setup.asp?name=" & setup_name
		response.end
	end if
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html xmlns:x86>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>用户语言设置</title>
<?IMPORT NAMESPACE="x86" IMPLEMENTATION="RichEdit.htc"?>
<link href="../css.css" rel="stylesheet" type="text/css">
</head>

<body>

<!--功能标题-->
<div class="page-title">设置（<%=setup_name%>）</div>
<%if return_info<>"" then%>
<div class="return-info"><%=return_info%></div>
<%end if%>
<div class="help-info">说明： <br>
  1、用户语言设置（<%=setup_name%>）<br></div>
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
        <td width="100" align="right" bgcolor="#f2f8ff"><%=rs("language")%>设置（<%=setup_name%>）：</td>
          <td><%
				
				oFCKeditor.Value = rs(setup_name)
				oFCKeditor.Create setup_name & "_" & rs("id")
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
            <input name="setup_name" type="hidden" id="setup_name" value="<%=setup_name%>"></td>
        </tr>
      </table>
    </form>
</div>
<br>
<div class="page-foot"><%=db_getvalue("setup_name='page_foot'","sys_setup","setup_value")%></div><br>
</body>
</html>
