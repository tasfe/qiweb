<!--#include file="../common.asp"-->
<%
check_admin
news_id=ufomail_request("querystring","id")
sql="delete * from lyb where id=" & news_id
conn.execute sql
response.redirect request.ServerVariables("HTTP_REFERER")
%>