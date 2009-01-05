<!--#include file="common.asp"-->
<%
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''生成ASP文件的sitemap文件;并产生副本:sitemap.xml
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
server.ScriptTimeout=99999
Response.Expires = 0
Response.Buffer = False
language=request.cookies("language")
if isempty(language) then 
	default_language=db_getvalue("setup_name='default_language'","sys_setup","setup_value")
	language=cint(default_language)
end if
''写出页头
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Sitemap</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%=db_getvalue("setup_name='page_head'","sys_setup","setup_value")%>
</head>

<body>
<h1><%=db_getvalue("ID=" & language,"[language]","homepage_name")%></h1>--<a href="/sitemaps.asp" target="_blank">Sitemap XML version</a>
<hr/>
<%

response.write  "<ul> " & vbCRLF

f_path=root_path & "\HTML\"
Set Upload = Server.CreateObject("Persits.Upload")
Set Dir = Upload.Directory( f_path & "*.htm", 1)
For Each f_name in Dir
	response.write  "<li>" & vbCRLF
	response.write  date_format(f_name.LastWriteTime) & "<span style='width:30px;'><b></b></span>" & vbCRLF
	response.write  "<a href='http://" &  request.ServerVariables("SERVER_NAME") & "/HTML/" & f_name.FileName & "' target='_blank'>http://" &  request.ServerVariables("SERVER_NAME") & "/HTML/" & f_name.FileName & "</a>" & vbCRLF
	response.write  "</li>" & vbCRLF
Next
response.write  "</ul>"
set rs=nothing
function date_format(sdate)
	date_format=year(sdate) & "-" & right("0" & month(sdate),2) & "-" & right("0" & day(sdate),2)
end function
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
%>

</body>
</html>