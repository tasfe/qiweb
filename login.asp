<!--#include file="common.asp"-->
<!--#include file="md5.asp"-->
<%
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''	文档作用：用户登录
''	创建时间：2006-7-17
''	修改情况：
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

if ufomail_request("form","action")<>"" then
	if ufomail_request("form","user_name")="" then
		err_msgbox "Please input your username!"
	end if
	if ufomail_request("form","user_password")="" then
		err_msgbox "Please input password!"
	end if
	user_name=ufomail_request("form","user_name")
	password=ufomail_request("form","user_password")
	temp_str=getHTTPPage("http://txmaimai.cn/check_user.asp?user=" & user_name & "&key=" & md5(password))
	if temp_str="true" then
		session("admin_id")=user_name
		session("admin_password")=md5(password)
		response.redirect "default.asp"
		response.end
	else
		err_msgbox "password is error!"
	end if
else
	response.redirect request.ServerVariables("HTTP_REFERER")
end if
%>