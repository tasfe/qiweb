<!--#include file="../common.asp"-->
<%
	check_admin
	upload_object=db_getvalue("setup_name='upload_object'","sys_setup","setup_value")
	upload_maxsize=db_getvalue("setup_name='upload_maxsize'","sys_setup","setup_value")
	upload_forder=db_getvalue("setup_name='upload_forder'","sys_setup","setup_value")
	upload_mask=db_getvalue("setup_name='upload_mask'","sys_setup","setup_value")
	musk_border_color="FFFFFF"
	musk_font_text=db_getvalue("setup_name='musk_font_text'","sys_setup","setup_value")
	if musk_font_text="" then
		musk_font_text=db_getvalue("setup_name='homepage_name_gb'","sys_setup","setup_value")
	end if
	musk_font_size=db_getvalue("setup_name='musk_font_size'","sys_setup","setup_value")
	musk_font_color=db_getvalue("setup_name='musk_font_color'","sys_setup","setup_value")
	musk_font_shadow=db_getvalue("setup_name='musk_font_shadow'","sys_setup","setup_value")
	musk_border=db_getvalue("setup_name='musk_border'","sys_setup","setup_value")
	musk_border_color=db_getvalue("setup_name='musk_border_color'","sys_setup","setup_value")
	if ufomail_request("Form","action")<>"" then
		call db_save("edit","sys_setup","setup_value|+|setup_name",ufomail_request("Form","upload_object") & "|+|upload_object","setup_name='upload_object'")
		call db_save("edit","sys_setup","setup_value|+|setup_name",ufomail_request("Form","upload_maxsize") & "|+|upload_maxsize","setup_name='upload_maxsize'")
		call db_save("edit","sys_setup","setup_value|+|setup_name",ufomail_request("Form","upload_forder") & "|+|upload_forder","setup_name='upload_forder'")
		call db_save("edit","sys_setup","setup_value|+|setup_name",ufomail_request("Form","upload_mask") & "|+|upload_mask","setup_name='upload_mask'")
		call db_save("edit","sys_setup","setup_value|+|setup_name",ufomail_request("Form","musk_font_text") & "|+|musk_font_text","setup_name='musk_font_text'")
		call db_save("edit","sys_setup","setup_value|+|setup_name",ufomail_request("Form","musk_font_size") & "|+|musk_font_size","setup_name='musk_font_size'")
		call db_save("edit","sys_setup","setup_value|+|setup_name",ufomail_request("Form","musk_font_color") & "|+|musk_font_color","setup_name='musk_font_color'")
		call db_save("edit","sys_setup","setup_value|+|setup_name",ufomail_request("Form","musk_font_shadow") & "|+|musk_font_shadow","setup_name='musk_font_shadow'")
		call db_save("edit","sys_setup","setup_value|+|setup_name",ufomail_request("Form","musk_border") & "|+|musk_border","setup_name='musk_border'")
		call db_save("edit","sys_setup","setup_value|+|setup_name",ufomail_request("Form","musk_border_color") & "|+|musk_border_color","setup_name='musk_border_color'")
		response.Redirect "upload_setup.asp"
	end if
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>上传设置</title>
<link href="../css.css" rel="stylesheet" type="text/css">
</head>

<body>
<script language="JavaScript" src="dialog.js"></script>
<!--功能标题-->
<div class="page-title">上传设置</div>
<%if return_info<>"" then%>
<div class="return-info"><%=return_info%></div>
<%end if%>
<div class="help-info">说明： <br>
  1、下面设置上传文件的一些选项。<br></div>
<div class="oper-content"> 
  <form name="form1" method="post" action="">
    <div class="row">使用的上传控件： 
      <select name="upload_object" id="upload_object">
        <option value="0" <%if upload_object="0" then response.write " selected='selected'"%>>无组件上传控件</option>
        <option value="1" <%if upload_object="1" then response.write " selected='selected'"%>>ASPUPLOAD上传控件</option>
      </select>
    </div>
    <div class="row">上传文件的最大限制： 
      <select name="upload_maxsize" id="upload_maxsize">
        <option value="1048576" <%if upload_maxsize="1048576" then response.write " selected='selected'"%>>1M</option>
        <option value="2097152" <%if upload_maxsize="2097152" then response.write " selected='selected'"%>>2M</option>
        <option value="4194304" <%if upload_maxsize="4194304" then response.write " selected='selected'"%>>4M</option>
        <option value="8388608" <%if upload_maxsize="8388608" then response.write " selected='selected'"%>>8M</option>
        <option value="16777216" <%if upload_maxsize="16777216" then response.write " selected='selected'"%>>16M</option>
        <option value="33554432" <%if upload_maxsize="33554432" then response.write " selected='selected'"%>>32M</option>
        <option value="52428800" <%if upload_maxsize="52428800" then response.write " selected='selected'"%>>50M</option>
        <option value="67108864" <%if upload_maxsize="67108864" then response.write " selected='selected'"%>>64M</option>
      </select>
    </div>
    <div class="row">文件上传后存放的路径： 
      <input name="upload_forder" type="text" id="upload_forder" value="<%=upload_forder%>" size="40">
    </div>
    <div class="row">是否启用图片水印： 
      <select name="upload_mask" id="upload_mask" onChange="javascript:if(this.options[this.selectedIndex].value==0)musk_photo.style.display='none';else musk_photo.style.display='';">
        <option value="0" <%if upload_mask="0" then response.write " selected='selected'"%>>不启用</option>
        <option value="1" <%if upload_mask="1" then response.write " selected='selected'"%>>启用</option>
      </select>
    </div>
	<div id="musk_photo" <%if upload_mask="0" then response.write " style='display:none;'"%>>
	<div class="row">水印显示的文字： 
      <input name="musk_font_text" type="text" id="musk_font_text" value="<%=musk_font_text%>" size="40">
    </div>
	<div class="row"> 水印的文字大小： 
      <select name="musk_font_size" id="musk_font_size">
        <option value="8" <%if musk_font_size="8" then response.write " selected='selected'"%>>8</option>
        <option value="9" <%if musk_font_size="9" then response.write " selected='selected'"%>>9</option>
        <option value="10" <%if musk_font_size="10" then response.write " selected='selected'"%>>10</option>
        <option value="12" <%if musk_font_size="12" then response.write " selected='selected'"%>>12</option>
        <option value="14" <%if musk_font_size="14" then response.write " selected='selected'"%>>14</option>
        <option value="18" <%if musk_font_size="18" then response.write " selected='selected'"%>>18</option>
        <option value="24" <%if musk_font_size="24" then response.write " selected='selected'"%>>24</option>
        <option value="36" <%if musk_font_size="36" then response.write " selected='selected'"%>>36</option>
		 <option value="48" <%if musk_font_size="48" then response.write " selected='selected'"%>>48</option>
		  <option value="60" <%if musk_font_size="60" then response.write " selected='selected'"%>>60</option>
		   <option value="72" <%if musk_font_size="72" then response.write " selected='selected'"%>>72</option>
      </select>
    </div>
	<div class="row"> 水印文字颜色：
		 <input name="musk_font_color" id="d_musk_font_color" value="<%=musk_font_color%>">
	  <img src="rect.gif" style="cursor:hand;background-color:#<%=musk_font_color%>;" id="s_musk_font_color" onclick="SelectColor('musk_font_color')"/>
    </div>
	<div class="row"> 是否加上投影效果：
      <select name="musk_font_shadow" id="musk_font_shadow">
        <option value="0" <%if musk_font_shadow="0" then response.write " selected='selected'"%>>不启用</option>
        <option value="1" <%if musk_font_shadow="1" then response.write " selected='selected'"%>>启用</option>
      </select>
    </div>
	<div class="row"> 是否为图片加边框：
      <select name="musk_border" id="musk_border">
        <option value="1" <%if musk_border="0" then response.write " selected='selected'"%>>加边框</option>
        <option value="0" <%if musk_border="1" then response.write " selected='selected'"%>>不加边框</option>
      </select>
    </div>
	
	<div class="row"> 边框的颜色：  
	  <input name="musk_border_color" id="d_musk_border_color" value="<%=musk_border_color%>">
	  <img src="rect.gif" style="cursor:hand;background-color:#<%=musk_border_color%>;" id="s_musk_border_color" onclick="SelectColor('musk_border_color')"/>
    </div>
	</div>
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
