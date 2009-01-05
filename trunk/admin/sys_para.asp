<!--#include file="../common.asp"-->
<%
	check_admin
	para_news_scrollAmount=db_getvalue("setup_name='para_news_scrollAmount'","sys_setup","setup_value")
	para_product_count=db_getvalue("setup_name='para_product_count'","sys_setup","setup_value")
	para_album_count=db_getvalue("setup_name='para_album_count'","sys_setup","setup_value")
	para_software_count=db_getvalue("setup_name='para_software_count'","sys_setup","setup_value")
	para_movie_count=db_getvalue("setup_name='para_movie_count'","sys_setup","setup_value")
	para_search_count=db_getvalue("setup_name='para_search_count'","sys_setup","setup_value")
	para_pic_width=db_getvalue("setup_name='para_pic_width'","sys_setup","setup_value")
	para_pic_height=db_getvalue("setup_name='para_pic_height'","sys_setup","setup_value")
	para_picture_width=db_getvalue("setup_name='para_picture_width'","sys_setup","setup_value")
	para_picture_height=db_getvalue("setup_name='para_picture_height'","sys_setup","setup_value")
	if ufomail_request("Form","action")<>"" then
		call db_save("edit","sys_setup","setup_value|+|setup_name",ufomail_request("Form","para_news_scrollAmount") & "|+|para_news_scrollAmount","setup_name='para_news_scrollAmount'")
		call db_save("edit","sys_setup","setup_value|+|setup_name",ufomail_request("Form","para_product_count") & "|+|para_product_count","setup_name='para_product_count'")
		call db_save("edit","sys_setup","setup_value|+|setup_name",ufomail_request("Form","para_album_count") & "|+|para_album_count","setup_name='para_album_count'")
		call db_save("edit","sys_setup","setup_value|+|setup_name",ufomail_request("Form","para_software_count") & "|+|para_software_count","setup_name='para_software_count'")
		call db_save("edit","sys_setup","setup_value|+|setup_name",ufomail_request("Form","para_movie_count") & "|+|para_movie_count","setup_name='para_movie_count'")
		call db_save("edit","sys_setup","setup_value|+|setup_name",ufomail_request("Form","para_search_count") & "|+|para_search_count","setup_name='para_search_count'")
		call db_save("edit","sys_setup","setup_value|+|setup_name",ufomail_request("Form","para_pic_width") & "|+|para_pic_width","setup_name='para_pic_width'")
		call db_save("edit","sys_setup","setup_value|+|setup_name",ufomail_request("Form","para_pic_height") & "|+|para_pic_height","setup_name='para_pic_height'")
		call db_save("edit","sys_setup","setup_value|+|setup_name",ufomail_request("Form","para_picture_width") & "|+|para_picture_width","setup_name='para_picture_width'")
		call db_save("edit","sys_setup","setup_value|+|setup_name",ufomail_request("Form","para_picture_height") & "|+|para_picture_height","setup_name='para_picture_height'")
		response.redirect "sys_para.asp"
	end if
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>界面参数设置</title>
<link href="../css.css" rel="stylesheet" type="text/css">
</head>

<body>

<!--功能标题-->
<div class="page-title">界面参数设置</div>
<%if return_info<>"" then%>
<div class="return-info"><%=return_info%></div>
<%end if%>
<div class="help-info">说明： <br>
  1、本页面设置页面显示的各种参数！<br></div>
<div class="oper-content"> 
  <form name="form1" method="post" action="">
  	<div class="row">
	首页公告栏的滚动速度：<input name="para_news_scrollAmount" type="text" id="para_news_scrollAmount" value="<%=para_news_scrollAmount%>" size="2">
      （数值越大，滚动速度越块！默认为：1）；</div>
	<div class="row">
	产品列表每页显示的数量：<input name="para_product_count" type="text" id="para_product_count" value="<%=para_product_count%>" size="2">
      个（默认值 为：9）； </div>
	<div class="row">
	相册每页显示的相片数量：<input name="para_album_count" type="text" id="para_album_count" value="<%=para_album_count%>" size="2">
      个（默认值 为：9）； </div>
	  <div class="row">
	软件列表每页显示的数量：<input name="para_software_count" type="text" id="para_software_count" value="<%=para_software_count%>" size="2">
      个（默认值 为：9）； </div>
	  <div class="row">
	视频列表显示的数量：<input name="para_movie_count" type="text" id="para_movie_count" value="<%=para_movie_count%>" size="2">
      个（默认值 为：9）； </div>
	  <div class="row">
	搜索结果显示的数量：<input name="para_search_count" type="text" id="para_search_count" value="<%=para_search_count%>" size="2">
      个（默认值 为：9）； </div>
	<div class="row">
	产品列表页面中图片的大小，宽：<input name="para_pic_width" type="text" id="para_pic_width" value="<%=para_pic_width%>" size="4">
      px，高：<input name="para_pic_height" type="text" id="para_pic_height" value="<%=para_pic_height%>" size="4">
      px （默认值为：宽为180px，高为“空”值）；<br>
      产品展示页面中产品图片的大小，宽： 
      <input name="para_picture_width" type="text" id="para_picture_width" value="<%=para_picture_width%>" size="4">
      px，高：
      <input name="para_picture_height" type="text" id="para_picture_height" value="<%=para_picture_height%>" size="4">
      px （默认值为：宽为500px，高为“空”值）； </div>
	
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
