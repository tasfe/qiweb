<!--#include file="common.asp"-->
<%
ValidCode=ufomail_request("Form","ValidCode")
if ValidCode="" then
	err_msgbox "Please input ValidCode!"
end if
user_id=ufomail_request("Form","user_id")
lyb_title=ufomail_request("Form","lyb_title")
lyb_content=htmlencode2(ufomail_request("Form","lyb_content"))
lyb_email=ufomail_request("Form","lyb_email")
lyb_QQ=ufomail_request("Form","lyb_QQ")
lyb_date=now()
if ucase(ValidCode)<>ucase(session("ValidCode")) then
	err_msgbox "ValidCode is wrong!"
end if
if user_id="" then
	err_msgbox "Please input your name!"
end if
if lyb_content="" then
	err_msgbox "Please input your leaveword!"
end if
input_label="user_id|+|lyb_title|+|lyb_content|+|lyb_email|+|lyb_QQ|+|lyb_date"
input_value=user_id & "|+|" & lyb_title & "|+|" & lyb_content & "|+|" & lyb_email & "|+|" & lyb_QQ & "|+|" & lyb_date
call db_save("add","lyb",input_label,input_value,"")
response.redirect request.ServerVariables("HTTP_REFERER")
%>
