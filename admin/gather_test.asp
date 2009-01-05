<!--#include file="../common.asp"-->
<!--#include file="../gather_class.asp"-->
<%
'on error resume next
call check_admin()
content_id=ufomail_request("querystring","id")
set rs=server.createobject("adodb.recordset")
sql="select * from gather where id=" & content_id
rs.open sql,conn,1,1
if not rs.eof then
	gather_name=rs("gather_name")
	gather_url=rs("gather_url")
	gather_area1=rs("gather_area1")
	gather_area2=rs("gather_area2")
	gather_list1=rs("gather_list1")
	gather_list2=rs("gather_list2")
	gather_list_page=rs("gather_list_page")
	gather_list_page_url=rs("gather_list_page_url")
	gather_list_page_num=rs("gather_list_page_num")
	gather_title1=rs("gather_title1")
	gather_title2=rs("gather_title2")
	gather_content1=rs("gather_content1")
	gather_content2=rs("gather_content2")
	gather_content_page=rs("gather_content_page")
	gather_content_page_url=rs("gather_content_page_url")
	gather_date1=rs("gather_date1")
	gather_date2=rs("gather_date2")
	gather_flash=rs("gather_flash")
	gather_picture=rs("gather_picture")
	gather_link=rs("gather_link")
	gather_link1=rs("gather_link1")
	gather_link2=rs("gather_link2")
end if
rs.close
set rs=nothing
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>测试新闻采集模块</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../css.css" rel="stylesheet" type="text/css">
</head>

<body>
<div class="page-title"> 检查目标网址</div>
<div class="help-info"> 看看下面的内容是不是你设置的新闻源页面？<br>
<code><a href="<%=gather_url%>" target="test"><%=gather_url%></a></code>
<iframe src="<%=gather_url%>" name="target_url" frameborder="0" scrolling="auto" height="160px" width="96%" id="test_url">你的浏览器不支持IFRAME，请更换浏览器</iframe>
</div>
<div class="page-title">获得新闻列表的地址</div>
<div class="help-info"> 下面列出的是从目标网址获得的新闻列表的网址<br/>
<%
webstr=getHTTPPage(gather_url)
webstr=stripHTML(webstr,gather_area1,gather_area2)
webstr=Manhunt(webstr,gather_list1,gather_list2,true,true,false,true)
webstr=Split(webstr,"$url$")
for i=0 to ubound(webstr)
	if webstr(i)<>"" then
		response.write "<li><a href='" & HttpUrls(webstr(i),gather_url) & "' target='test'>" &  HttpUrls(webstr(i),gather_url) & "</a></li>"
	end if
next
%>
</div>
<div class="page-title">获得新闻的内容</div>
<div class="help-info">下面列出其中的第一篇新闻和最后一篇新闻<br/>
<%
for i=0 to ubound(webstr)
	if webstr(i)<>"" and i<3 then
		temp_http=HttpUrls(webstr(i),gather_url)
		web_str=getHTTPPage(temp_http)
%>
  <table width="90%" border="0" cellspacing="0" cellpadding="4" class="all-border">
    <tr> 
      <th>来源网址：</th>
      <td><%=HttpUrls(webstr(i),gather_url)%>&nbsp;</td>
    </tr>
    <tr> 
      <th width="100">新闻标题：</th>
      <td><%=SeparateHTML(web_str,gather_title1,gather_title2)%>&nbsp;</td>
    </tr>
    <tr> 
      <th>新闻内容：</th>
      <td><%=SeparateHTML(web_str,gather_content1,gather_content2)%>&nbsp;</td>
    </tr>
    <tr> 
      <th>编辑日期：</th>
      <td><%=SeparateHTML(web_str,gather_date1,gather_date2)%>&nbsp;</td>
    </tr>
  </table><br>
<%
	end if
next
%>
</div>
<div class="page-foot"><%=db_getvalue("setup_name='page_foot'","sys_setup","setup_value")%></div><br></body>
</html>
