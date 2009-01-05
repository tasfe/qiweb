<!--#include file="../common.asp"-->
<%
	check_admin
	if ufomail_request("Form","action")<>"" then
		link_name=ufomail_request("Form","link_name")
		link_desc=ufomail_request("Form","link_desc")
		link_url=ufomail_request("Form","link_url")
		link_logo=ufomail_request("Form","link_logo")
		if link_name="" then
			err_msgbox "没有输入链接名称"
		end if
		if link_url="" then
			err_msgbox "没有输入链接地址"
		end if
		input_label="link_name|+|link_desc|+|link_url|+|link_logo|+|language"
		input_value=link_name & "|+|" & link_desc & "|+|" & link_url & "|+|" & link_logo & "|+|" & ufomail_request("Form","language") 
		if ufomail_request("Form","link_id")<>"" then
			call db_save("edit","link",input_label,input_value,"id=" & ufomail_request("Form","link_id"))
		else
			call db_save("add","link",input_label,input_value,"")
		end if
		response.redirect "link.asp?language=" & ufomail_request("Form","language")
	end if
	if ufomail_request("QueryString","action")="dele" and ufomail_request("QueryString","id")<>"" then
		sql="delete * from link where id=" & ufomail_request("QueryString","id")
		conn.execute sql
		response.redirect "link.asp?language=" & ufomail_request("QueryString","language")
	end if
	language=ufomail_request("QueryString","language")
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title><%=db_getvalue("id=" & language,"[language]","[language]")%>链接管理</title>
<link href="../css.css" rel="stylesheet" type="text/css">
</head>

<body>
<!--功能标题-->
<div class="page-title"><%=db_getvalue("id=" & language,"[language]","[language]")%>链接管理</div>
<%if return_info<>"" then%>
<div class="return-info"><%=return_info%></div>
<%end if%>
<div class="help-info">说明： <br>
  1、管理友情链接，达到流量交换！<br>
</div>
<div class="oper-content"> 
  <form action="" method="post" name="form1">
    <table width="95%" border="1" cellpadding="2" cellspacing="0" bordercolor="#CCCCCC" class="table-cell">
      <tr> 
        <td width="200" bgcolor="#E0E0E0">链接名称</td>
        <td bgcolor="#E0E0E0">链接说明</td>
        <td width="120" bgcolor="#E0E0E0">LOGO</td>
        <td colspan="2" align="center" bgcolor="#E0E0E0">操作</td>
      </tr>
	  <%
	  set rs=server.CreateObject("adodb.recordset")
	  sql="select * from [link] where [language]=" & ufomail_request("QueryString","language")
	  rs.open sql,conn,1,1
	  do while not rs.eof 
	  %>
      <tr> 
        <td><%=rs("link_name")%></td>
        <td><%=rs("link_desc")%></td>
        <td><%if rs("link_logo")<>"" then
		response.write "<img src='" & rs("link_logo") & "'/>"
		end if%> </td>
        <td width="60" align="center">[ <a href="link.asp?language=<%=ufomail_request("QueryString","language")%>&id=<%=rs("id")%>">修改</a> ]</td>
        <td width="60" align="center">[ <a href="link.asp?language=<%=ufomail_request("QueryString","language")%>&action=dele&id=<%=rs("id")%>">删除</a> ]</td>
      </tr>
	  <%
	  rs.movenext
	  loop
	  rs.close
	  %>
    </table>
    <br>
    在下面输入新增的链接：<br>
    <br>
	<%
	  if ufomail_request("QueryString","id")<>"" then
	  	sql="select * from link where id=" & ufomail_request("QueryString","id")
		rs.open sql,conn,1,1
		if not rs.eof then
			link_name=rs("link_name")
			link_desc=rs("link_desc")
			link_url=rs("link_url")
			link_logo=rs("link_logo")
			link_id=rs("id")
		end if
		rs.close
	  end if
	  %>
    <table width="500" border="1" cellpadding="2" cellspacing="0" bordercolor="#CCCCCC" class="table-cell">
      <tr> 
        <td width="120" align="right" bgcolor="#E0E0E0">链接名称：</td>
        <td>
<input name="link_name" type="text" id="link_name" value="<%=link_name%>" size="20"></td>
      </tr>
      <tr> 
        <td align="right" bgcolor="#E0E0E0">链接说明：</td>
        <td>
<input name="link_desc" type="text" id="link_desc" value="<%=link_desc%>" size="50"></td>
      </tr>
      <tr>
        <td align="right" bgcolor="#E0E0E0">链接地址：</td>
        <td>
<input name="link_url" type="text" id="link_url" value="<%=link_url%>" size="50"></td>
      </tr>
      <tr>
        <td align="right" bgcolor="#E0E0E0">LOGO地址：</td>
        <td>
<input name="link_logo" type="text" id="link_logo" value="<%=link_logo%>" size="40"></td>
      </tr>
    </table>
    <br>
    <input name="action" type="submit" id="action" value="Submit">
    <input name="link_id" type="hidden" id="link_id" value="<%=link_id%>">
    <input type="hidden" name="language" value="<%=ufomail_request("QueryString","language")%>">
  </form>
</div>
<br>
<div class="page-foot"><%=db_getvalue("setup_name='page_foot'","sys_setup","setup_value")%></div><br>
</body>
</html>
