<!--#include file="../common.asp"-->
<%
	check_admin
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>编辑语言包</title>
<link href="../css.css" rel="stylesheet" type="text/css">
</head>

<body>
<!--功能标题-->
<div class="page-title">编辑语言包</div>
<%if return_info<>"" then%>
<div class="return-info"><%=return_info%></div>
<%end if%>
<div class="help-info">说明： <br>
  1、点击下面标签进行编辑！<br>
</div>
<div class="oper-content"> 
  <form name="form1" method="post" action="">
  	<div class="row"> 
      <ul>
	  <%
	  	set rs=server.createobject("adodb.recordset")
	  	sql="select * from [sys_language]"
		rs.open sql,conn,1,1
		if not rs.eof then
			set rs_fields=rs.fields
			for each fields_name in rs_fields
				if fields_name.name<>"ID" then
					response.write  "		<li><a href='user_language_setup.asp?name=" &fields_name.name& "'>" & fields_name.name & "</a></li>" & vbCRLF
				end if
			next
			'response.end
		end if
		rs.close
		%>
	  </ul>
    </div>
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
