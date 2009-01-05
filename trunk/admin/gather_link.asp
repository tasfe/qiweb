<!--#include file="../common.asp"-->
<%
	check_admin
	site_id=ufomail_request("querystring","site_id")
	return_url=request.ServerVariables("HTTP_REFERER")
	gather=db_getvalue("id=" & site_id,"sitemap","gather")
	if ufomail_request("Form","action")<>"" then
		gather=ufomail_request("form","gather_id")
		addnew=ufomail_request("form","addnew")
		overwrite=ufomail_request("form","overwrite")
		if addnew<>"" then
			session("addnew")=true
		end if
		if overwrite<>"" then 
			session("overwrite")=true
		end if
		input_label="gather|+|edit_date"
		input_value=gather & "|+|" & now()
		call db_save("edit","sitemap",input_label,input_value,"id=" & site_id)
		response.Redirect ufomail_request("form","url")
	end if
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>设置信息采集模块</title>
<link href="../css.css" rel="stylesheet" type="text/css">
</head>

<body>
<!--功能标题-->
<div class="page-title">设置信息采集模块</div>
<%if return_info<>"" then%>
<div class="return-info"><%=return_info%></div>
<%end if%>
<div class="help-info">说明： <br>
  1、设置此栏目的内容可以从那一个新闻列表中采集获得，以减轻网站管理员的工作量。<br>
  2、如没有设置好采集模块，请通过<a href="gather_manager.asp">这里</a>设置。<br>
</div>
<div class="oper-content"> 
  <a name="edit_form"/>
	<div class="button">
	<a href="gather_edit.asp">增加模块</a> 
	<a href="gather_update.asp">下载模块</a>
	</div>
  <form action="" method="post" name="submit_form">
  <table width="95%" border="1" cellpadding="2" cellspacing="0" bordercolor="#CCCCCC" class="table-cell">
    <tr bgcolor="#e0e0e0"> 
      <td width="100">模块名称</td>
      <td>采集目标</td>
      <td width="60" bgcolor="#e0e0e0">调用</td>
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
      <td align="center"><input name="gather_id" type="checkbox" id="gather_id" value="<%=rs("id")%>" <%if instr(", " & gather & ", ",", " & rs("id") & ", ")<>0 then response.write " checked"%>></td>
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
    <hr size="1">
	  <input name="action" type="submit" id="action" value="Submit">
	  <input type="reset" name="Submit2" value="Reset">
    <input name="url" type="hidden" id="url" value="<%=return_url%>">
    当标题重复时： 
    <input type="checkbox" name="addnew" value="true" <%if session("addnew") then response.write " checked"%>>
    增加 
    <input type="checkbox" name="overwrite" value="true" <%if session("overwrite") then response.write " checked"%>>
    覆盖 (<font color="#FF0000">此项设置只应用于当前最近的一次数据采集操作</font>) 
  </form>
</div>


<br>
<div class="page-foot"><%=db_getvalue("setup_name='page_foot'","sys_setup","setup_value")%></div><br>
</body>
</html>
