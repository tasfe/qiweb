<!--#include file="../common.asp"-->
<%
	check_admin
	email_account=db_getvalue("setup_name='email_account'","sys_setup","setup_value")
	email_password=db_getvalue("setup_name='email_password'","sys_setup","setup_value")
	email_accepter=db_getvalue("setup_name='email_accepter'","sys_setup","setup_value")
	email_accepter_name=db_getvalue("setup_name='email_accepter_name'","sys_setup","setup_value")
	if ufomail_request("Form","action")<>"" then
		call db_save("edit","sys_setup","setup_value|+|setup_name",ufomail_request("Form","email_account") & "|+|email_account","setup_name='email_account'")
		call db_save("edit","sys_setup","setup_value|+|setup_name",ufomail_request("Form","email_password") & "|+|email_password","setup_name='email_password'")
		call db_save("edit","sys_setup","setup_value|+|setup_name",ufomail_request("Form","email_accepter") & "|+|email_accepter","setup_name='email_accepter'")
		call db_save("edit","sys_setup","setup_value|+|setup_name",ufomail_request("Form","email_accepter_name") & "|+|email_accepter_name","setup_name='email_accepter_name'")
		response.redirect "email_para.asp"
	end if
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>电邮相关参数设置</title>
<link href="../css.css" rel="stylesheet" type="text/css">
</head>

<body>

<!--功能标题-->
<div class="page-title">设置与电邮相关的参数</div>
<%if return_info<>"" then%>
<div class="return-info"><%=return_info%></div>
<%end if%>
<div class="help-info">说明： <br>
  1、本页面设置电邮的各种参数！<br>
  2、Jmail组件邮件服务器参数填写你的电邮账号及登录电邮的密码，建议使用163免费邮<br>
  3、设置你接收从网站发来的邮件地址，这处填写的是你平时用来收邮件的用户名和地址，此参数是用来获得用户反馈信息用的！<br>
</div>
<div class="oper-content"> 
  <form name="form1" method="post" action="">
  	<div class="row"> Jmail 组件邮件服务器参数：<br>
      1、账号：<input name="email_account" type="text" value="<%=email_account%>"/><br>
      2、密码：<input name="email_password" type="text" value="<%=email_password%>"/><br>
      设置你接收从网站上发来的邮件的地址<br>
      1、用户名：<input name="email_accepter_name" type="text" value="<%=email_accepter_name%>"/><br>
	  2、电邮地址：<input name="email_accepter" type="text" value="<%=email_accepter%>"/> </div>
	<hr size="1"/>
    <input type="submit" name="action" value="保存设置">
  </form>
</div>
<br>
<br>
<br>
<div class="page-foot"><%=db_getvalue("setup_name='page_foot'","sys_setup","setup_value")%></div><br>
</body>
</html>
