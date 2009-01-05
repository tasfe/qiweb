<!--#include file="../common.asp"-->
<!--#include file="../md5.asp"-->
<%
	check_admin
	user_name=session("admin_id")
	if ufomail_request("form","action")<>"" then
		if ufomail_request("form","pass")="" then
			err_msgbox "请输入原密码！"
		end if
		if db_getvalue("admin_id='" & user_name & "'","admin","password")<>md5(ufomail_request("form","pass")) then
			err_msgbox "你输入的原密码错误！"
		end if
		if ufomail_request("form","new_pass")="" then
			err_msgbox "请输入的新密码！"
		end if
		if ufomail_request("form","config_pass")="" then
			err_msgbox "请输入确认的新密码！"
		end if 
		if ufomail_request("form","new_pass")<>ufomail_request("form","config_pass") then
			err_msgbox "两次输入的密码不一致！"
		end if
		input_label="password"
		input_value=md5(ufomail_request("form","config_pass"))
		call db_save("edit","admin",input_label,input_value,"admin_id='" & user_name & "'")
		call turn_login()
	end if
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>修改密码</title>

<link href="../css.css" rel="stylesheet" type="text/css">
</head>

<body>
<!--功能标题-->
<div class="page-title">修改密码</div>
<%if return_info<>"" then%>
<div class="return-info"><%=return_info%></div>
<%end if%>
<div class="help-info">说明： <br>
  1、修改密码后会要求你重新登录！<br>
</div>
<div class="oper-content"> 
  <table width="300" border="1" cellpadding="5" cellspacing="0" bordercolor="#CCCCCC" class="table-cell">
    <form name="form1" method="post" action="">
      <tr> 
        <td colspan="2" align="center" bgcolor="#FFFFCC" class="td_b">&gt;&gt;&gt;登录密码&lt;&lt;&lt;</td>
      </tr>
      <tr> 
        <td width="100" align="right" bgcolor="#E5ECF4">原密码：</td>
        <td><input name="pass" type="password" class="all_border" id="pass" style="width:150" size="15"></td>
      </tr>
      <tr> 
        <td align="right" bgcolor="#E5ECF4">新密码：</td>
        <td><input name="new_pass" type="password" class="all_border" id="new_pass2" style="width:150" size="15"></td>
      </tr>
      <tr> 
        <td align="right" bgcolor="#E5ECF4" class="tdh_b">确认密码：</td>
        <td class="tdh_b"><input name="config_pass" type="password" class="all_border" id="config_pass2" style="width:150" size="15"></td>
      </tr>
      <tr> 
        <td colspan="2" align="center"><input name="action" type="submit" class="bt" value="确认更改"></td>
      </tr>
    </form>
    <form name="form1" method="post" action="">
    </form>
  </table></div>
  <br>
<div class="page-foot"><%=db_getvalue("setup_name='page_foot'","sys_setup","setup_value")%></div><br>
</body>
</html>
