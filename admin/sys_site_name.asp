<!--#include file="../common.asp"-->
<%
	check_admin
	show_language=db_getvalue("setup_name='show_language'","sys_setup","setup_value")
	if ufomail_request("Form","action")<>"" then
		set rs=server.CreateObject("adodb.recordset")
		sql="select * from [language] where id in(" & show_language & ")"
		rs.open sql,conn,1,3
		do while not rs.eof 
			rs("site_name")=ufomail_request("Form","site_name_" & rs("id"))
			rs.update
			rs.movenext
		loop
		rs.close
		set rs=nothing
		response.Redirect "sys_site_name.asp"
	end if
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>网站名称</title>
<link href="../css.css" rel="stylesheet" type="text/css">
</head>

<body>

<!--功能标题-->
<div class="page-title">网站名称</div>
<%if return_info<>"" then%>
<div class="return-info"><%=return_info%></div>
<%end if%>
<div class="help-info">说明： <br>
  1、输入各语言版本的网站名称<br></div>
<div class="oper-content"> 
  <form name="form1" method="post" action="">
  	<%
	gb_to_big5=db_getvalue("setup_name='gb_to_big5'","sys_setup","setup_value")
	set rs=server.CreateObject("adodb.recordset")
	sql="select * from [language] where id in(" & show_language & ") order by id"
	rs.open sql,conn,1,1
	do while not rs.eof
	if rs("id")=2 and gb_to_big5="true" then
	else
	%>
    <div><%=rs("language")%>网站名称：
      <input name="site_name_<%=rs("id")%>" type="text" id="site_name_<%=rs("id")%>" value="<%=rs("site_name")%>" size="40">
    </div>
	<%
	end if
	rs.movenext
	loop
	rs.close
	set rs=nothing
	%>
    <hr size="1"/>
    <input type="submit" name="action" value="保存设置">
  </form>
</div>
<br>
<br>
<br>
<div class="page-foot"><%=db_getvalue("setup_name='page_foot'","sys_setup","setup_value")%></div><br>
</body>
</html>
