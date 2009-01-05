<!--#include file="../common.asp"-->
<%
	check_admin
	default_language=db_getvalue("setup_name='homepage_open'","sys_setup","setup_value")
	if ufomail_request("form","action")<>"" then
		call db_save("edit","sys_setup","setup_value",ufomail_request("form","setup_value"),"setup_name='homepage_open'")
		response.Redirect "sys_homepage_open.asp"
		default_language=ufomail_request("form","setup_value")
	end if
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>首页开关</title>
<link href="../css.css" rel="stylesheet" type="text/css">
</head>

<body>
<!--功能标题-->
<div class="page-title">首页开关</div>
<%if return_info<>"" then%>
<div class="return-info"><%=return_info%></div>
<%end if%>
<div class="help-info">说明： <br>
  1、在启用“网站首页”时,可以进行首页设计管理；访问网站先进入首页。<br>
  2、在关闭“网站首页”时,首页设计管理无效；访问网站直接进入一级栏目页； <br>
  3、在使用“自定首页”前，应先上传自己设计的首页面，并做好相关链接<br></div>
<div class="oper-content"> 
  <form name="form1" method="post" action="">
    <li>请选择网站是否打开动画首页:
    <select name="setup_value">
	<%
	'0/启用;1/不启用;2/自定义
		temp_str="启用;不启用;自定义"
		temp_str1="0;1;2;"
		temp_str=split(temp_str,";")
		temp_str1=split(temp_str1,";")
		for i=0 to ubound(temp_str)
			if default_language=temp_str1(i) then
				response.write "<option value='" & temp_str1(i) & "' selected>" & temp_str(i) & "</option>"
			else
				response.write "<option value='" & temp_str1(i) & "'>" & temp_str(i) & "</option>"
			end if
		next
	%>
    </select></li>
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
