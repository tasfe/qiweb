<!--#include file="../common.asp"-->
<%
	response.Buffer=true
	check_admin
	content_id=ufomail_request("querystring","id")
	if ufomail_request("QueryString","action")="dele" and content_id<>"" then
		'删除操作
		sql="delete * from gather where id=" & content_id
		conn.execute sql
		response.redirect "gather_manager.asp"
		response.end
	end if
	if content_id<>"" then
	'获得修改的内容
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
	end if
	
	if ufomail_request("form","gather_name")<>"" then
		'保存操作
		gather_name=ufomail_request("form","gather_name")
		gather_url=ufomail_request("form","gather_url")
		gather_area1=ufomail_request("form","gather_area1")
		gather_area2=ufomail_request("form","gather_area2")
		gather_list1=ufomail_request("form","gather_list1")
		gather_list2=ufomail_request("form","gather_list2")
		gather_list_page=ufomail_request("form","gather_list_page")
		gather_list_page_url=ufomail_request("form","gather_list_page_url")
		gather_list_page_num=ufomail_request("form","gather_list_page_num")
		gather_title1=ufomail_request("form","gather_title1")
		gather_title2=ufomail_request("form","gather_title2")
		gather_content1=ufomail_request("form","gather_content1")
		gather_content2=ufomail_request("form","gather_content2")
		gather_content_page=ufomail_request("form","gather_content_page")
		gather_content_page_url=ufomail_request("form","gather_content_page_url")
		gather_date1=ufomail_request("form","gather_date1")
		gather_date2=ufomail_request("form","gather_date2")
		gather_flash=ufomail_request("form","gather_flash")
		gather_picture=ufomail_request("form","gather_picture")
		gather_link=ufomail_request("form","gather_link")
		gather_link1=ufomail_request("form","gather_link1")
		gather_link2=ufomail_request("form","gather_link2")
		content_id=ufomail_request("form","content_id")
		input_label="gather_url|+|gather_area1|+|gather_area2|+|gather_list1|+|gather_list2|+|gather_list_page|+|gather_list_page_url|+|gather_list_page_num|+|gather_title1|+|gather_title2|+|gather_content1|+|gather_content2|+|gather_content_page|+|gather_content_page_url|+|gather_date1|+|gather_date2|+|gather_flash|+|gather_picture|+|gather_link|+|gather_link1|+|gather_link2|+|gather_name"
		input_value=gather_url & "|+|" & gather_area1 & "|+|" & gather_area2 & "|+|" & gather_list1 & "|+|" & gather_list2 & "|+|" & gather_list_page & "|+|" & gather_list_page_url & "|+|" & gather_list_page_num & "|+|" & gather_title1 & "|+|" & gather_title2 & "|+|" & gather_content1 & "|+|" & gather_content2 & "|+|" & gather_content_page & "|+|" & gather_content_page_url & "|+|" & gather_date1 & "|+|" & gather_date2 & "|+|" & gather_flash & "|+|" & gather_picture & "|+|" & gather_link & "|+|" & gather_link1 & "|+|" & gather_link2 & "|+|" & gather_name 
		if content_id="" then
			call db_save("add","gather",input_label,input_value,"id=" & content_id)
		else
			call db_save("edit","gather",input_label,input_value,"id=" & content_id)
		end if
		response.redirect "gather_manager.asp"
		response.end
	end if
%>
<html xmlns:x86>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>新闻采集模块管理</title>
<?IMPORT NAMESPACE="x86" IMPLEMENTATION="RichEdit.htc"?>
<link href="../css.css" rel="stylesheet" type="text/css">

</head>

<body>

<!--功能标题-->
<div class="page-title">新闻采集模块管理</div>
<div class="help-info">说明： <br>
  1、设置新闻采集模块的各项内容<br>
</div>
<div class="oper-content"> 
  <form name="form1" method="post" action="">
    <table width="95%" border="1" cellpadding="4" cellspacing="0" bordercolor="#CCCCCC" class="table-cell">
      <tr> 
        <td width="120" align="right" bgcolor="#eeeeee">模块名称：</td>
        <td><input name="gather_name" type="text" id="gather_name" value="<%=gather_name%>" size="50">
          <input name="content_id" type="hidden" id="content_id" value="<%=content_id%>"> </td>
      </tr>
      <tr> 
        <td align="right" bgcolor="#eeeeee">目标地址：</td>
        <td><input name="gather_url" type="text" id="gather_url" value="<%=gather_url%>" style="width:100%">
        </td>
      </tr>
      <tr> 
        <td align="right" bgcolor="#eeeeee">远程保存内容：</td>
        <td>图片
          <input name="gather_picture" type="checkbox" id="gather_picture" value="1" <%if gather_picture=1 then response.write " checked"%>>
          FLASH
          <input name="gather_flash" type="checkbox" id="gather_flash" value="1" <%if gather_flash=1 then response.write " checked"%>></td>
      </tr>
      <tr> 
        <td align="right" bgcolor="#eeeeee">地址列表区域<br>
          开始代码：</td>
        <td><textarea name="gather_area1" id="gather_area1" style="width:100%;height:80px;"><%=gather_area1%></textarea></td>
      </tr>
      <tr> 
        <td align="right" bgcolor="#eeeeee">地址列表区域<br>
          结束代码：</td>
        <td><textarea name="gather_area2" id="gather_area2" style="width:100%;height:80px;"><%=gather_area2%></textarea></td>
      </tr>
      <tr> 
        <td align="right" bgcolor="#eeeeee">地址列表的网址<br>
          开始代码 ：</td>
        <td><textarea name="gather_list1" id="gather_list1" style="width:100%;height:80px;"><%=gather_list1%></textarea></td>
      </tr>
      <tr> 
        <td align="right" bgcolor="#eeeeee">地址列表的网址<br>
          结束代码 ：</td>
        <td><textarea name="gather_list2" id="gather_list2" style="width:100%;height:80px;"><%=gather_list2%></textarea></td>
      </tr>
      <tr> 
        <td align="right" bgcolor="#eeeeee">是否采集分页的网址：</td>
        <td><input type="radio" name="gather_list_page" value="1" <%if gather_list_page=1 then response.write " checked"%>>
          采集 
          <input type="radio" name="gather_list_page" value="0" <%if gather_list_page=0 then response.write " checked"%>>
          不采集 </td>
      </tr>
      <tr> 
        <td align="right" bgcolor="#eeeeee">分页后缀：</td>
        <td><input name="gather_list_page_url" type="text" id="gather_list_page_url" value="<%=gather_list_page_url%>" size="50"></td>
      </tr>
      <tr> 
        <td align="right" bgcolor="#eeeeee">采集多少页：</td>
        <td><input name="gather_list_page_num" type="text" id="title33" value="<%=gather_list_page_num%>" size="10">
          页</td>
      </tr>
      <tr> 
        <td align="right" bgcolor="#eeeeee">文章标题<br>
          开始代码：</td>
        <td><textarea name="gather_title1" id="gather_title1" style="width:100%;height:80px;"><%=gather_title1%></textarea></td>
      </tr>
      <tr> 
        <td align="right" bgcolor="#eeeeee">文章标题<br>
          结束代码：</td>
        <td><textarea name="gather_title2" id="gather_title2" style="width:100%;height:80px;"><%=gather_title2%></textarea></td>
      </tr>
      <tr> 
        <td align="right" bgcolor="#eeeeee">文章内容<br>
          开始代码：</td>
        <td><textarea name="gather_content1" id="gather_content1" style="width:100%;height:80px;"><%=gather_content1%></textarea></td>
      </tr>
      <tr> 
        <td align="right" bgcolor="#eeeeee">文章内容<br>
          结束代码：</td>
        <td><textarea name="gather_content2" id="gather_content2" style="width:100%;height:80px;"><%=gather_content2%></textarea></td>
      </tr>
      <tr> 
        <td align="right" bgcolor="#eeeeee">文章内容是否有分页：</td>
        <td><input type="radio" name="gather_content_page" value="1" <%if gather_content_page=1 then response.write " checked"%>>
          分页 
          <input name="gather_content_page" type="radio" value="0" <%if gather_content_page=0 then response.write " checked"%>>
          不分页 </td>
      </tr>
      <tr> 
        <td height="30" align="right" bgcolor="#eeeeee">内容下一页地址：</td>
        <td><input name="gather_content_page_url" type="text" id="gather_content_page_url" value="<%=gather_content_page_url%>" size="50"></td>
      </tr>
      <tr> 
        <td align="right" bgcolor="#eeeeee">编辑日期开始代码：</td>
        <td><textarea name="gather_date1" id="gather_date1" style="width:100%;height:80px;"><%=gather_date1%></textarea></td>
      </tr>
      <tr> 
        <td align="right" bgcolor="#eeeeee">编辑日期结束代码：</td>
        <td><textarea name="gather_date2" id="gather_date2" style="width:100%;height:80px;"><%=gather_date2%></textarea></td>
      </tr>
      <tr> 
        <td align="right" bgcolor="#eeeeee">是否添加文章来源：</td>
        <td><input name="gather_link" type="radio" value="1" <%if gather_link=1 then response.write " checked"%>>
          添加
			<input type="radio" name="gather_link" value="0" <%if gather_link=0 then response.write " checked"%>>
          不添加</td>
      </tr>
      <tr> 
        <td align="right" bgcolor="#eeeeee">文章来源开始代码：</td>
        <td><textarea name="gather_link1" id="gather_link1" style="width:100%;height:80px;"><%=gather_link1%></textarea></td>
      </tr>
      <tr> 
        <td align="right" bgcolor="#eeeeee">文章来源结束代码：</td>
        <td><textarea name="gather_link2" id="gather_link2" style="width:100%;height:80px;"><%=gather_link2%></textarea></td>
      </tr>
    </table>
    <br>
    <input type="submit" name="action" value="Submit">
    <input type="button" name="button" value="save as " onclick="javascript:content_id.value='';document.form1.submit();">
    <input type="reset" name="Reset" value="Reset">
  </form>
</div>
<br>
<div class="page-foot"><%=db_getvalue("setup_name='page_foot'","sys_setup","setup_value")%></div><br>
</body>
</html>
