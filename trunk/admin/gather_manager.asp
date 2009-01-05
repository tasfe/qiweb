<!--#include file="../common.asp"-->
<%
	check_admin
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>新闻采集模块管理</title>
<link href="../css.css" rel="stylesheet" type="text/css">
</head>

<body>
<!--功能标题-->
<div class="page-title">新闻采集模块管理</div>
<%if return_info<>"" then%>
<div class="return-info"><%=return_info%></div>
<%end if%>
<div class="help-info">说明： <br>
  1、此模块用于方便网站管理员从网络上采集相关的内容。<br>
  2、可以从服务器下载最新的采集模块。<br>
</div>
<div class="oper-content"> 
  <a name="edit_form"/>
	<div class="button">
	<a href="gather_edit.asp">增加模块</a> 
	<a href="gather_update.asp">下载模块</a>
	</div>
  <table width="95%" border="1" cellpadding="2" cellspacing="0" bordercolor="#CCCCCC" class="table-cell">
    <tr bgcolor="#e0e0e0"> 
      <td width="100">模块名称</td>
      <td>采集目标</td>
      <td width="100" bgcolor="#e0e0e0">操作</td>
    </tr>
    <%
		set rs=server.CreateObject("adodb.recordset")
	  	sql="gather"
		rs.open sql,conn,1,1
		if not rs.eof then
			do while not rs.eof
			
			%>
    <tr> 
      <td><%=rs("gather_name")%></td>
      <td><a href="<%=rs("gather_url")%>" target="_blank"><%=rs("gather_url")%></a></td>
      <td align="center">[<a href="gather_edit.asp?id=<%=rs("ID")%>">修改</a>] 
        [<a href="gather_edit.asp?action=dele&id=<%=rs("ID")%>">删除</a>][<a href="gather_test.asp?id=<%=rs("ID")%>">测试</a>]</td>
    </tr>
    <%
			rs.movenext
			loop
		else
			%>
    <tr align="center"> 
      <td colspan="3" height="60">还没有内容请点[增加]添加内容</td>
    </tr>
    <%
		end if
		rs.close
	  %>
  </table>
</div>
<br>
<div class="page-foot"><%=db_getvalue("setup_name='page_foot'","sys_setup","setup_value")%></div><br>
</body>
</html>
