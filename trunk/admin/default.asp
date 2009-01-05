<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>企业网站建设专家</title>

</head>
<%
url=session("turn_url")
if url="" then
	url="main.asp"
else
	url="action.asp"
end if
%>
<frameset cols="200,*" frameborder="NO" border="0" framespacing="0">
  <frame src="left.asp" name="left" scrolling="auto" noresize>
  <frame src="<%=url%>" name="main">
</frameset>
<noframes><body>
你的浏览器不支持框架！请使用IE5以上的浏览器！
</body></noframes>
</html>
