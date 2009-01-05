<!--#include file="../common.asp"-->
<%
	check_admin
	site_logo=db_getvalue("setup_name='site_logo'","sys_setup","setup_value")
	if ufomail_request("Form","action")<>"" then
		if ufomail_request("Form","site_logo")<>"" then
			call upload_use(ufomail_request("Form","site_logo"))
			call db_save("edit","sys_setup","setup_value",ufomail_request("Form","site_logo"),"setup_name='site_logo'")
			response.Redirect "sys_logo.asp"
		end if
	end if
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>网站LOGO</title>

<link href="../css.css" rel="stylesheet" type="text/css">
</head>

<body>

<!--功能标题-->
<div class="page-title">网站LOGO</div>
<%if return_info<>"" then%>
<div class="return-info"><%=return_info%></div>
<%end if%>
<div class="help-info">说明： <br>
  1、如果上传的是JPG格式的图片，请先关闭图片水印功能，否则会自动为上传的LOGO图片加上水印。[<a href="upload_setup.asp">设置水印</a>]<br>
  2、请上传网站的LOGO图片,然后按保存!<br>
</div>
<div class="oper-content"> 
  <%
  temp_file_name=file_show(site_logo)
  if temp_file_name="" then temp_file_name=url_path & "images/nopic.gif"
  %>
  <form name="form1" method="post" action="">
  	当前LOGO:<img src="<%=temp_file_name%>" alt="当前网站的LOGO"/>
  	<hr size="1"/>
  	<%upload_box "[one];site_logo;false;false;",250,0,"jpg|gif"%>
	<br/>
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
