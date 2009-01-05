<!--#include file="../common.asp"-->
<%
	check_admin
	site=db_getvalue("setup_name='site'","sys_setup","setup_value")
	if ufomail_request("querystring","setup_value")<>"" then
		call db_save("edit","sys_setup","setup_value",ufomail_request("querystring","setup_value"),"setup_name='site'")
		response.Redirect "sys_site.asp"
	end if
	if site & "1"="1" then site="index.jpg"
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>首页样式</title>

<link href="../css.css" rel="stylesheet" type="text/css">
</head>

<body>
<!--功能标题-->
<div class="page-title">首页样式</div>
<%if return_info<>"" then%>
<div class="return-info"><%=return_info%></div>
<%end if%>
<div class="help-info">选择首页模版说明： <br>
  1、单击模版缩图或选择模板链接即可选择该模版<br>
  2、你还可以点击下面按钮从<a href="http://qiweb.cn" target="_blank">QiWeb.cn</a>下载新模板！ 
  <div class="button"><a href="template_update.asp?style=site">下载新模板</a></div><br>
  </div>
<div class="oper-content"> 
  <form name="form1" method="post" action="">
  <li>当前选择：<img src='../template/site_pic/<%=site%>' width='160px' border='0' alt='当前网站选用的模板'/></li>
  <hr size="1"/>
  <%
			f_path=root_path & "\template\site_pic"
			set fso=server.createobject("Scripting.FileSystemObject") 
			set f=fso.GetFolder(f_path)
			set fc=f.files
			for each f_name in fc
				response.write "<span class='pic-list'><a href='sys_site.asp?setup_value=" & f_name.name & "'><img src='../template/site_pic/" & f_name.name & "' width='140px' border='0' alt='点击图片进入下一步'/></a></span>"
			next 
		%>
  </form>
</div>
<br>
<br>
<br>
<div class="page-foot"><%=db_getvalue("setup_name='page_foot'","sys_setup","setup_value")%></div><br>
</body>
</html>
