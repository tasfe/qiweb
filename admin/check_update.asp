<!--#include file="../common.asp"-->
<%
call check_admin()
update_file("/admin/update.asp")
session("step")=2 
response.redirect "update.asp"
%>