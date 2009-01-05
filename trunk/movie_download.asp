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
sql="select * from movie where id=" & software_id
rs.open sql,conn,1,1
if not rs.eof then
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