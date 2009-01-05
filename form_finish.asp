<!--#include file="common.asp"-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>成功提交你填写的表单</title>
<link href="css.css" rel="stylesheet" type="text/css">
</head>

<body>
<%
Dim Mail1 , HTML
email_account=db_getvalue("setup_name='email_account'","sys_setup","setup_value")
email_password=db_getvalue("setup_name='email_password'","sys_setup","setup_value")
email_accepter=db_getvalue("setup_name='email_accepter'","sys_setup","setup_value")
email_accepter_name=db_getvalue("setup_name='email_accepter_name'","sys_setup","setup_value")
HTML =  request.Form("mail_body")
call send_email(email_accepter,email_accepter,mm_cc,"From Web Form Infomation!",HTML,mm_title,mm_url,mm_importance)		
response.write "Info have been send to <a href='mailto:" & email_account & "'>" & email_account & "</a><p align='center'>Thank you!</p>"
%>
</body>
</html>