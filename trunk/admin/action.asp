<!--#include file="../common.asp"-->
<%
	response.Buffer=true
	check_admin
	url=session("turn_url")
	if request.Cookies("form")("action")="" then
		session("turn_url")=""
		if url="" or url="/admin/left.asp" or url="/admin/logout.asp?" then
			response.redirect "main.asp"
		else
			response.redirect url
		end if
		response.end
	end if
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>操作超时，重新提交！</title>
<link href="../css.css" rel="stylesheet" type="text/css">
</head>

<body>
<!--功能标题-->
<div class="page-title">重新提交刚才输入的内容</div>
<%if return_info<>"" then%>
<div class="return-info"><%=return_info%></div>
<%end if%>
<div class="help-info">系统帮助： <br>
  1、当出现此页面时，表示你刚刚有输入的内容没有成功保存，请点击下面的“重新提交”按钮。以重新保存数据！<br>
<script src="http://www.qiweb.cn/help/action.js" language="JavaScript"></script>
</div>
<div class="oper-content"> 
  <form name="form1" method="post" action="<%=url%>">
  	<div class="row"> 
	<%for each form_name in request.Cookies("form")
		response.write "<textarea style='display:none;' type='text' name='" & form_name & "'>" & Server.HTMLEncode(request.Cookies("form")(form_name)) & "</textarea>"
	 	response.Cookies("form")(form_name)=""
	  next 
	%>
	</div>
	<div align="center">
    <input type="submit" name="action" value="重新提交" style="width:60%;height:80px;font-size:60px;margin:40px 10px;">
	</div>
  </form>
</div>
<br>
<br>
<br>
<div class="page-foot"><%=db_getvalue("setup_name='page_foot'","sys_setup","setup_value")%></div><br>
</body>
</html>
