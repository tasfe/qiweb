<!--#include file="../common.asp"-->
<%
	check_admin
	language=ufomail_request("QueryString","language")
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>设置各个栏目的样式</title>
<link href="../css.css" rel="stylesheet" type="text/css">
</head>

<body>
<!--功能标题-->
<div class="page-title"><%=db_getvalue("id=" & language,"[language]","[language]")%>网站的栏目样式管理</div>
<%if return_info<>"" then%>
<div class="return-info"><%=return_info%></div>
<%end if%>
<div class="help-info">说明： <br>
  1、点击下面<%=db_getvalue("id=" & language,"[language]","[language]")%>网站栏目右边的设置样式按钮进行样式设置<br>
</div>
<div class="oper-content"> 
  <%
  set rs=server.createobject("adodb.recordset")
  set rs1=server.createobject("adodb.recordset")
  sql="select * from sitemap where parent=0 and [language]=" & ufomail_request("QueryString","language") & " order by seq"
  rs.open sql,conn,1,1
  response.write "<div class='sitemap'><ul>"
  do while not rs.eof 
	response.write "<li><span>" & rs("title") & "</span><a href='frame_edit.asp?id=" & rs("id") & "'>设置</a>"
		sql="select * from sitemap where parent=" & rs("id") & " order by seq"
		rs1.open sql,conn,1,1
		if not rs1.eof then
			response.write "<ul>"
			do while not rs1.eof 
				response.write "<li><span>" & rs1("title") & "</span><a href='frame_edit.asp?id=" & rs1("id") & "'>设置</a></li>"
				rs1.movenext
			loop
			response.write "</ul>"
		end if
		rs1.close
	response.write "</li>"
	rs.movenext
  loop
  response.write "</ul></div>"
  rs.close
  %>
</div>
<br>
<div class="page-foot"><%=db_getvalue("setup_name='page_foot'","sys_setup","setup_value")%></div><br>
</body>
</html>
