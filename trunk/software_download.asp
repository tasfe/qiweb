<!--#include file="common.asp"-->
<!--#include file="download.asp"-->
<%
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''	文档作用：下载文件
''	创建时间：2005-6-13
''	修改情况：	2005-10-29 修改数据库打开方式,提高系统运行速度(朱祺艺)
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
software_id=ufomail_request("querystring","id")
password=ufomail_request("querystring","pass")
if software_id & "1"="1" then
	response.write "error,files has not find!"
	response.End
end if
success=false
set rs=server.CreateObject("adodb.recordset")
sql="select * from software where id=" & software_id
rs.open sql,conn,1,1
if not rs.eof then
	if rs("password") & "1"<>"1" then 
		if rs("password") & "1"<>password & "1" then
		%>
		<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
		<html>
		<head>
		<title>需要输入下载密码：</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link href="../css.css" rel="stylesheet" type="text/css">
		</head>
		
		<body>
		<form post='get' name='form1'>
		下载密码（password）：<input type='password' name='pass' value=''/>
		<input type="hidden" name="id" value="<%=software_id%>"/>
		<input type="submit" name="action" value="submit"/>
		<%if password<>"" then response.write "<font color='red'>password wrong!</font>"%>
		</form>
		</body>
		</html>
		<%
		response.end
		end if
	end if
	file_id=get_left(rs("picture"),"||")
	filename=db_getvalue("file_id='" & file_id & "'","uploadfile","file_name")
	path=root_path & "\" & db_getvalue("file_id='" & file_id & "'","uploadfile","file_path") & "\" & rs("picture")
	path=replace(path,"/","\")
	path=replace(path,"\\","\")
	path=get_left(path,"||")
end if
if filename<>"" then
	success=transferfile(path,filename)
end if
if success=false then
	response.write "error!has not success download."
end if
response.end
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
%>