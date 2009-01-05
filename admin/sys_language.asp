<!--#include file="../common.asp"-->
<%
	check_admin
	default_language=db_getvalue("setup_name='default_language'","sys_setup","setup_value")
	show_language=db_getvalue("setup_name='show_language'","sys_setup","setup_value")
	gb_to_big5=db_getvalue("setup_name='gb_to_big5'","sys_setup","setup_value")
	if ufomail_request("Form","action")<>"" then
		call db_save("edit","sys_setup","setup_value",ufomail_request("Form","setup_value"),"setup_name='default_language'")
		call db_save("edit","sys_setup","setup_value",ufomail_request("Form","show_language"),"setup_name='show_language'")
		call db_save("edit","sys_setup","setup_name|+|setup_value","gb_to_big5|+|"& ufomail_request("Form","gb_to_big5"),"setup_name='gb_to_big5'")
		%>
		<script language='javascript'>
			window.parent.left.location.reload();
			window.location="sys_language.asp";
		</script>
		<%
		response.end
		default_language=ufomail_request("Form","setup_value")
		show_language=ufomail_request("Form","show_language")
		gb_to_big5=ufomail_request("Form","gb_to_big5")
	end if
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>语言设置</title>

<link href="../css.css" rel="stylesheet" type="text/css">
</head>

<body>
<!--功能标题-->
<div class="page-title">语言设置</div>
<%if return_info<>"" then%>
<div class="return-info"><%=return_info%></div>
<%end if%>
<div class="help-info">语言设置说明： <br>
  1. 本系统支持多国语言，初始状态只显示“简体中文版”。<br>
  2. 如果使用简体自动转换繁体功能，你只需要录入简体中文的内容就可以自动生成繁体中文的网页。<br>
  3. 默认语言是指访问者第一次访问网站时所看到的语言版本。<br></div>
<div class="oper-content"> 
  <form name="form1" method="post" action="">
    <li>请选择网站的默认语言： 
      <select name="setup_value">
	<%
		set rs=server.createobject("adodb.recordset")
		sql="select * from [language]"
		rs.open sql,conn,1,1
		do while not rs.eof 
			if cint(default_language)=rs("id") then
				response.write "<option value='" & rs("id") & "' selected>" & rs("language") & "</option>"
			else
				response.write "<option value='" & rs("id") & "'>" & rs("language") & "</option>"
			end if
		rs.movenext
		loop
		rs.close
	%>
    </select>
    </li>
	<li> 请选择网站显示那几个语言版本： <br>
      <select name="show_language" size="10" multiple>
	  <%
		sql="select * from [language]"
		rs.open sql,conn,1,1
		do while not rs.eof 
			show_language=replace(show_language," ","")
			if instr("," & show_language & ",", "," & rs("id") & ",")>0 then
				response.write "<option value='" & rs("id") & "' selected>" & rs("language") & "</option>"
			else
				response.write "<option value='" & rs("id") & "'>" & rs("language") & "</option>"
			end if
		rs.movenext
		loop
		rs.close
	%>
      </select>
      按着Ctrl进行选择或取消</li>
    <li>是否使用简体自动转换为繁体的功能： 
      <input type="radio" name="gb_to_big5" value="true" <%if gb_to_big5="true" then response.write " checked"%>>启用
      <input type="radio" name="gb_to_big5" value="false" <%if gb_to_big5<>"true" then response.write " checked"%>>不启用
    </li>
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
