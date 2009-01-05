<!--#include file="../common.asp"-->
<!--#include file="../md5.asp"-->
<%
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''	文档作用：管理登录
''	创建时间：2006-7-17
''	修改情况：
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

if ufomail_request("form","action")<>"" then
	if ufomail_request("form","user_id")="" then
		err_msgbox "没有填写账号!"
	end if
	if ufomail_request("form","user_password")="" then
		err_msgbox "没有输入密码!"
	end if
	user_name=ufomail_request("form","user_id")
	password=ufomail_request("form","user_password")
	if db_getvalue("admin_id='" & user_name & "'","admin","password")<>"" and db_getvalue("admin_id='" & user_name & "'","admin","password")=md5(password) then
		session("admin_id")=user_name
		session("admin_password")=md5(password)
		response.redirect "default.asp"
		response.end
	else
		err_msgbox "密码错误!"
	end if
else
	url=session("turn_url")
end if
%><html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>login</title>
<link href="../css.css" rel="stylesheet" type="text/css">
</head>

<body>
<table width="100%" height="100%" border="0" cellpadding="4" cellspacing="0" class="non-border">
  <tr> 
    <td align="center"><table width="500" border="0" cellpadding="0" cellspacing="0" class="all-border">
        <tr>
          <td><img src="images/login_top.gif" width="500" height="84"></td>
        </tr>
        <tr>
          <td height="120" align="center" valign="top"><form name="form1" method="post" action="">
              <table width="150" border="0" cellspacing="0" cellpadding="4" class="non-border">
                <tr> 
                  <td>帐号： 
                    <input type="text" name="user_id" class="all_border" style="width:100"> 
                  </td>
                </tr>
                <tr> 
                  <td>密码： 
                    <input type="password" name="user_password" class="all_border" style="width:100"> 
                  </td>
                </tr>
                <tr> 
                  <td align="center"> <input name="imageField2" type="image" src="images/bt_login.gif" width="42" height="18" border="0"> 
                    <input name="url" type="hidden" id="url" value="<%=url%>"><input name="action" type="hidden" id="action" value="login"> 
                  </td>
                </tr>
              </table>
            </form>
            
          </td>
        </tr>
      </table></td>
  </tr>
</table>
</body>
</html>
