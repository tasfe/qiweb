<!--#include file="../common.asp"-->
<!--#include file="../htmleditor/fckeditor.asp"-->
<!--#include file="../gather_class.asp"-->
<%
	check_admin
	style=ufomail_request("QueryString","style")
	class_id=ufomail_request("QueryString","class")
	content_id=ufomail_request("QueryString","id")
	default_language=db_getvalue("setup_name='default_language'","sys_setup","setup_value")
	language=ufomail_request("QueryString","language")
	seq=10
	if style="" then style=0
	if ufomail_request("QueryString","action")="deleall" then
		if ufomail_request("QueryString","confirm")=1 then
			select case style
				case 0
					sql="delete * from article where [language]=" & language & " and  class=" & class_id
				case 1
					sql="delete * from product where [language]=" & language & " and  class=" & class_id
				case 5
					sql="delete * from album where [language]=" & language & " and  class=" & class_id
				case 6
					sql="delete * from software where [language]=" & language & " and  class=" & class_id
				case 7
					sql="delete * from movie where [language]=" & language & " and  class=" & class_id
			end select
			conn.execute sql
			response.redirect "content.asp?language=" & ufomail_request("QueryString","language") & "&id=" & class_id
			response.end
		else
			%>
			<script language="JavaScript">
			var ufo=window.confirm("请确认是否要删除数据！");
			if (ufo)
			{
			window.location="content_edit.asp?confirm=1&language=<%=language%>&style=<%=style%>&class=<%=class_id%>&action=deleall"
			}
			else
			{
			history.go(-1);
			}
			</script>
			<%
		end if
	end if
	if ufomail_request("QueryString","action")="dele" and content_id<>"" then
		select case style
			case 0
				sql="delete * from article where id=" & content_id
			case 1
				sql="delete * from product where id=" & content_id
			case 5
				sql="delete * from album where id=" & content_id
			case 6
				sql="delete * from software where id=" & content_id
			case 7
				sql="delete * from movie where id=" & content_id
		end select
		conn.execute sql
		response.redirect "content.asp?language=" & ufomail_request("QueryString","language") & "&id=" & class_id
		response.end
	end if
	if content_id<>"" then
		set rs=server.createobject("adodb.recordset")
		select case style
			case 0
				sql="select * from article where id=" & content_id
			case 1
				sql="select * from product where id=" & content_id
			case 5
				sql="select * from album where id=" & content_id
			case 6
				sql="select * from software where id=" & content_id
			case 7
				sql="select * from movie where id=" & content_id
		end select
		rs.open sql,conn,1,1
		if not rs.eof then
			title=rs("title")
			seq=rs("seq")
			class_id=rs("class")
			content=rs("content")
			keyword=rs("keyword")
			if style=1 then
				price=rs("price")
				num=rs("num")
				pic=rs("pic")
				picture=rs("picture")
				pictures=rs("pictures")
			end if
			if style=5 then
				pic=rs("pic")
			end if
			if style=6 or style=7 then
				pic=rs("pic")
				picture=rs("picture")
				other_link=rs("other_link")
			end if
			if style=6 then
				password=rs("password")
			end if
		end if
		code=rs("code")
		rs.close
		set rs=nothing
	end if
	if ufomail_request("form","action")<>"" then
		title=ufomail_request("form","title")
		seq=ufomail_request("form","seq")
		class_id=ufomail_request("form","class")
		data_style=ufomail_request("form","data_style")
		content_id=ufomail_request("form","content_id")
		content=ufomail_request("form","content")
		keyword=ufomail_request("form","keyword")
		if data_style=1 then
			price=ufomail_request("form","price")
			num=ufomail_request("form","num")
			pic=ufomail_request("form","pic")
			picture=ufomail_request("form","picture")
			pictures=ufomail_request("form","pictures")
			up_pic=ufomail_request("form","up_pic")
			up_picture=ufomail_request("form","up_picture")
			up_pictures=ufomail_request("form","up_pictures")
			if up_pictures<>"" then
				up_pictures=replace(up_pictures,",","||")
				up_pictures=up_pictures & "||"
			end if
		end if
		'相册
		if data_style=5 then
			pic=ufomail_request("form","pic")
			up_pic=ufomail_request("form","up_pic")
		end if
		'视频及软件
		if data_style=6 or data_style=7 then
			pic=ufomail_request("form","pic")
			up_pic=ufomail_request("form","up_pic")
			picture=ufomail_request("form","picture")
			up_picture=ufomail_request("form","up_picture")
			other_link=ufomail_request("form","other_link")
		end if
		if data_style=6 then
			password=ufomail_request("form","password")
		end if
		if title="" then
			err_msgbox "请输入标题"
		end if
		select case data_style
			case 0
				if content_id<>"" then
					input_label="title|+|content|+|keyword|+|class|+|seq|+|create_date|+|language"
					input_value=title & "|+|" & content & "|+|" & keyword & "|+|" & class_id & "|+|" & seq & "|+|" & now() & "|+|" & ufomail_request("form","language")
					call db_save("edit","article",input_label,input_value,"id=" & content_id)
				else
					input_label="title|+|content|+|keyword|+|class|+|seq|+|create_date|+|language|+|code"
					input_value=title & "|+|" & content & "|+|" & keyword & "|+|" & class_id & "|+|" & seq & "|+|" & now() & "|+|" & ufomail_request("form","language") & "|+|" & create_code()
					call db_save("add","article",input_label,input_value,"")
				end if
			case 1
				call upload_use(pic)
				call upload_use(picture)
				call upload_use(pictures)
				if content_id<>"" then
					if pic="" then pic=up_pic
					if picture="" then picture=up_picture
					pictures=pictures & up_pictures
					has_price=ufomail_request("form","has_price")
					if has_price="has_price" then
						input_label="title|+|content|+|keyword|+|class|+|seq|+|price|+|num|+|pic|+|picture|+|pictures|+|create_date|+|language"
						input_value=title & "|+|" & content & "|+|" & keyword & "|+|" & class_id & "|+|" & seq & "|+|" & price & "|+|" & num & "|+|" & pic & "|+|" & picture & "|+|" & pictures & "|+|" & now() & "|+|" & ufomail_request("form","language")
						call db_save("edit","product",input_label,input_value,"id=" & content_id)
					else
						input_label="title|+|content|+|keyword|+|class|+|seq|+|create_date"
						input_value=title & "|+|" & content & "|+|" & keyword & "|+|" & class_id & "|+|" & seq & "|+|" & now()
						call db_save("edit","product",input_label,input_value,"id=" & content_id)
					end if
				else
					input_label="title|+|content|+|keyword|+|class|+|seq|+|price|+|num|+|pic|+|picture|+|pictures|+|create_date|+|language|+|code"
					input_value=title & "|+|" & content & "|+|" & keyword & "|+|" & class_id & "|+|" & seq & "|+|" & price & "|+|" & num & "|+|" & pic & "|+|" & picture & "|+|" & pictures & "|+|" & now() & "|+|" & ufomail_request("form","language") & "|+|" & create_code()
					call db_save("add","product",input_label,input_value,"")
				end if
			case 5
			'保存相册
				call upload_use(pic)
				if pic="" then pic=up_pic
				if content_id<>"" then
					has_price=ufomail_request("form","has_price")
					if has_price="has_price" then
						input_label="title|+|content|+|keyword|+|pic|+|class|+|seq|+|create_date|+|language"
						input_value=title & "|+|" & content & "|+|" & keyword & "|+|" & pic & "|+|" & class_id & "|+|" & seq & "|+|" & now() & "|+|" & ufomail_request("form","language")
					else
						input_label="title|+|content|+|keyword|+|class|+|seq|+|create_date"
						input_value=title & "|+|" & content & "|+|" & keyword & "|+|" & class_id & "|+|" & seq & "|+|" & now()
					end if
					call db_save("edit","album",input_label,input_value,"id=" & content_id)
				else
					input_label="title|+|content|+|keyword|+|pic|+|class|+|seq|+|create_date|+|language|+|code"
					input_value=title & "|+|" & content & "|+|" & keyword & "|+|" & pic & "|+|" & class_id & "|+|" & seq & "|+|" & now() & "|+|" & ufomail_request("form","language") & "|+|" & create_code()
					call db_save("add","album",input_label,input_value,"")
				end if
			case 6
			'保存软件
				call upload_use(pic)
				call upload_use(picture)
				if pic="" then pic=up_pic
				if picture="" then picture=up_picture
				if content_id<>"" then
					has_price=ufomail_request("form","has_price")
					if has_price="has_price" then
						input_label="title|+|content|+|keyword|+|pic|+|picture|+|password|+|other_link|+|class|+|seq|+|create_date|+|language"
						input_value=title & "|+|" & content & "|+|" & keyword & "|+|" & pic & "|+|" & picture & "|+|" & password & "|+|" & other_link & "|+|" & class_id & "|+|" & seq & "|+|" & now() & "|+|" & ufomail_request("form","language")
					else
						input_label="title|+|content|+|keyword|+|class|+|seq|+|create_date"
						input_value=title & "|+|" & content & "|+|" & keyword & "|+|" & class_id & "|+|" & seq & "|+|" & now()
					end if
					call db_save("edit","software",input_label,input_value,"id=" & content_id)
				else
					input_label="title|+|content|+|keyword|+|pic|+|picture|+|password|+|other_link|+|class|+|seq|+|create_date|+|language|+|code"
					input_value=title & "|+|" & content & "|+|" & keyword & "|+|" & pic & "|+|" & picture & "|+|" & password & "|+|" & other_link & "|+|" & class_id & "|+|" & seq & "|+|" & now() & "|+|" & ufomail_request("form","language") & "|+|" & create_code()
					call db_save("add","software",input_label,input_value,"")
				end if
			case 7
				'保存视频音频
				call upload_use(pic)
				call upload_use(picture)
				if pic="" then pic=up_pic
				if picture="" then picture=up_picture
				if content_id<>"" then
					has_price=ufomail_request("form","has_price")
					if has_price="has_price" then
						input_label="title|+|content|+|keyword|+|pic|+|picture|+|other_link|+|class|+|seq|+|create_date|+|language"
						input_value=title & "|+|" & content & "|+|" & keyword & "|+|" & pic & "|+|" & picture & "|+|" & other_link & "|+|" & class_id & "|+|" & seq & "|+|" & now() & "|+|" & ufomail_request("form","language")
					else
						input_label="title|+|content|+|keyword|+|class|+|seq|+|create_date"
						input_value=title & "|+|" & content & "|+|" & keyword & "|+|" & class_id & "|+|" & seq & "|+|" & now()
					end if
					call db_save("edit","movie",input_label,input_value,"id=" & content_id)
				else
					input_label="title|+|content|+|keyword|+|pic|+|picture|+|other_link|+|class|+|seq|+|create_date|+|language|+|code"
					input_value=title & "|+|" & content & "|+|" & keyword & "|+|" & pic & "|+|" & picture & "|+|" & other_link & "|+|" & class_id & "|+|" & seq & "|+|" & now() & "|+|" & ufomail_request("form","language") & "|+|" & create_code()
					call db_save("add","movie",input_label,input_value,"")
				end if
		end select
		response.redirect "content.asp?language=" & ufomail_request("form","language") & "&id=" & class_id
	end if
Function URLEncoding(vstrIn)
    strReturn = ""
    For i = 1 To Len(vstrIn)
        ThisChr = Mid(vStrIn,i,1)
        If Abs(Asc(ThisChr)) < &HFF Then
            strReturn = strReturn & ThisChr
        Else
            innerCode = Asc(ThisChr)
            If innerCode < 0 Then
                innerCode = innerCode + &H10000
            End If
            Hight8 = (innerCode  And &HFF00)\ &HFF
            Low8 = innerCode And &HFF
            strReturn = strReturn & "%" & Hex(Hight8) &  "%" & Hex(Low8)
        End If
    Next
    URLEncoding = strReturn
End Function
%>
<html xmlns:x86>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title><%=db_getvalue("id=" & language,"[language]","[language]")%>内容管理</title>
<?IMPORT NAMESPACE="x86" IMPLEMENTATION="RichEdit.htc"?>
<link href="../css.css" rel="stylesheet" type="text/css">

</head>

<body>
<script language="JavaScript">
	function show_language(){
		if (document.getElementById('show_language').style.display=='') {
	    	document.getElementById('show_language').style.display='none'}
		else{
			document.getElementById('show_language').style.display='';
		}
	}
	</script>
<%
select case style
	case 0
		content_style="<font color='blue'>文章</font>"
	case 1
		content_style="<font color='blue'>产品</font>"
	case 2
		content_style="<font color='blue'>留言</font>"
	case 3
		content_style="<font color='blue'>链接的网址</font>"
	case 5
		content_style="<font color='blue'>相片</font>"
	case 6
		content_style="<font color='blue'>文件</font>"
	case 7
		content_style="<font color='blue'>视频音频</font>"
end select
%>
<!--功能标题-->
<div class="page-title"><%=db_getvalue("id=" & language,"[language]","[language]")%>内容管理</div>
<%if return_info<>"" then%>
<div class="return-info"><%=return_info%></div>
<%end if%>
<div class="help-info">说明： <br>
  1、按要求逐一录入<%=db_getvalue("id=" & language,"[language]","[language]") & content_style%>内容，注意标题必须录入！<br>
  2、顺序是用于文章、产品排序用的！建议开始时都输入10！以后需要某个商品排前时，只需要将这个商品的顺序改为比10小的数即可！<br>
  </div>
<div class="oper-content"> 
  <form name="form1" method="post" action="">
    <table width="95%" border="1" cellpadding="4" cellspacing="0" bordercolor="#CCCCCC" class="table-cell">
      <tr> 
        <td width="120" align="right" bgcolor="#eeeeee">标题：</td>
        <td><input name="title" type="text" id="title" value="<%=title%>" size="50">
          <input name="class" type="hidden" id="class" value="<%=class_id%>">
          <input name="data_style" type="hidden" id="data_style" value="<%=style%>">
          <input name="content_id" type="hidden" id="content_id" value="<%=content_id%>">
          *</td>
      </tr>
	  <tr> 
        <td align="right" bgcolor="#eeeeee">顺序：</td>
        <td><input name="seq" type="text" id="seq" value="<%=seq%>" size="8"></td>
      </tr>
      <tr> 
        <td align="right" bgcolor="#eeeeee">内容：</td>
        <td>
		<%		
				Dim oFCKeditor
				Set oFCKeditor = New FCKeditor
				
				oFCKeditor.Width = "100%"
				if style=5 then
					oFCKeditor.ToolbarSet = "Basic"
					oFCKeditor.Height = "120"
				else
					oFCKeditor.Config("LinkBrowser") = "true" 
					oFCKeditor.Config("ImageBrowser") = "true" 
					oFCKeditor.Config("FlashBrowser") = "true" 
					oFCKeditor.Config("LinkUpload") = "true" 
					oFCKeditor.Config("ImageUpload") = "true" 
					oFCKeditor.Config("FlashUpload") = "true" 
					oFCKeditor.ToolbarSet = "MyToolbar"
					if style=6 or style=7 then
					oFCKeditor.Height = "200"
					else
					oFCKeditor.Height = "400"
					end if
				end if
				oFCKeditor.Value = content
				oFCKeditor.Create "content"
				%></td>
      </tr>
	  <%if language<>default_language then%>
	  <tr>
	 <td align="right" bgcolor="#eeeeee">自动翻译后的内容：<br>
	<font color="red">仅用于参考！</font><br>
	<a href="http://translate.google.com/translate_t" target="_blank">详情请看这里</a></td>
	 <td><table id="laguage_com" width="100%" border="1" cellpadding="4" cellspacing="0" bordercolor="#CCCCCC" class="table-cell">
	 <%
	 content=RegExpreplace(content,"<([^>]*)>","")
	 function language_name(num)
	 	select case num
			case "1"
			language_name="zh"
			case "2"
			language_name="zh-TW"
			case "3"
			language_name="en"
			case "4"
			language_name="ja"
			case "5"
			language_name="ko"
			case "6"
			language_name="es"
			case "7"
			language_name="ar"
			case "8"
			language_name="fr"
			case "9"
			language_name="de"
			case "10"
			language_name="it"
			case "11"
			language_name="ru"
			case "12"
			language_name="pt"
			case else
			language_name="en"
		end select
	 end function
	 if default_language="1" and language="3" then
	 	web_str=get_google_Translate("zh|en",content)
	 else
	 	web_str=get_google_Translate("en|" & language_name(language),content)
	 end if
	 %><tr>
	 	<th style="width:50%;cursor:pointer;" title="点击隐藏/打开自动翻译的内容" onClick="show_language()">翻译前</th><th title="点击隐藏/打开自动翻译的内容" style="width:50%;cursor:pointer;" onClick="show_language()">自动翻译后</th>
	 </tr>
	 <tr id="show_language" style="height:30px;">
	 	<td valign="top"><%=replace(trim(content),chr(13),"<br/>")%></td>
		<td valign="top"><%=web_str%></td>
	 </tr>
	 </table>
	 </td>
	  </tr>
	  <%end if%>
	   <tr> 
        <td align="right" bgcolor="#eeeeee">关键字（用、分隔）：</td>
        <td><input name="keyword" type="text" id="keyword" value="<%=keyword%>" size="58"></td>
      </tr>
	  <%
	  ''----------------------------------------------------------------------
	  ''------------产品
	  ''----------------------------------------------------------------------
	  if (default_language=language and style=1) or (isempty(title)=true and style=1) or (db_getvalue("code='" & code & "' and [language]=" & default_language,"product","id")="" and style=1) then%>
      <tr> 
        <td align="right" bgcolor="#eeeeee">价格：</td>
        <td><input name="price" type="text" id="price" value="<%=price%>" size="8">
		<input name="has_price" type="hidden" id="has_price" value="has_price">
		</td>
      </tr>
      <tr> 
        <td align="right" bgcolor="#eeeeee">数量：</td>
        <td><input name="num" type="text" id="num" value="<%=num%>" size="8"></td>
      </tr>
      <tr> 
        <td align="right" bgcolor="#eeeeee">缩略图：</td>
        <td><%
		uploadfile_list pic,"up_pic",0
		upload_box "[one];pic;false;false;",450,0,"jpg|gif"%></td>
      </tr>
      <tr> 
        <td align="right" bgcolor="#eeeeee">大图：</td>
        <td><%
		uploadfile_list picture,"up_picture",0
		upload_box "[one];picture;false;false;",450,0,"jpg|gif"%></td>
      </tr>
      <tr>
        <td align="right" bgcolor="#eeeeee">其它图片：</td>
        <td><%
		uploadfile_list pictures,"up_pictures",0
		upload_box ";pictures;false;false;",400,30,"jpg|gif"%></td>
      </tr>
	  <%end if
	  ''----------------------------------------------------------------------
	  ''------------相册
	  ''----------------------------------------------------------------------
	  if (default_language=language and style=5) or (isempty(title)=true and style=5) or (db_getvalue("code='" & code & "' and [language]=" & default_language,"album","id")="" and style=5) then
	  %>
	  <tr> 
        <td align="right" bgcolor="#eeeeee">上传图片：</td>
        <td><input name="has_price" type="hidden" id="has_price" value="has_price">
		<%
		uploadfile_list pic,"up_pic",0
		upload_box "[one];pic;false;false;",450,0,"jpg|gif"%></td>
      </tr>
	  <%end if
	  ''----------------------------------------------------------------------
	  ''------------软件
	  ''----------------------------------------------------------------------
	   if (default_language=language and style=6) or (isempty(title)=true and style=6) or (db_getvalue("code='" & code & "' and [language]=" & default_language,"software","id")="" and style=6) then
	  %>
	  <tr> 
        <td align="right" bgcolor="#eeeeee">软件截图：</td>
        <td><%
		uploadfile_list pic,"up_pic",0
		upload_box "[one];pic;false;false;",450,0,"jpg|gif"%></td>
      </tr>
	  <tr> 
        <td align="right" bgcolor="#eeeeee">上传软件：</td>
        <td><%
		uploadfile_list picture,"up_picture",0
		upload_box "[one];picture;false;false;",450,0,"rar|zip"%></td>
      </tr>
	  <tr> 
        <td align="right" bgcolor="#eeeeee">下载密码：</td>
        <td><input name="password" type="password" id="password" value="<%=password%>" size="16">（可为空，当设置密码时，下载时需要输入正确的密码才能下载！）</td>
      </tr>
	  <tr> 
        <td align="right" bgcolor="#eeeeee">其它下载点：</td>
        <td><input name="has_price" type="hidden" id="has_price" value="has_price">
		<textarea name="other_link" style="width:100%;height:100px;"><%=other_link%></textarea><br>
		如：华军下载||http//newhua.com/dokskssks/sksks.htm 多个下载点用回车分隔
		</td>
      </tr>
	  <%end if
	  ''----------------------------------------------------------------------
	  ''------------视频
	  ''----------------------------------------------------------------------
	  if (default_language=language and style=7) or (isempty(title)=true and style=7) or (db_getvalue("code='" & code & "' and [language]=" & default_language,"movie","id")="" and style=7) then
	  %>
	  <tr> 
        <td align="right" bgcolor="#eeeeee">视频截图：</td>
        <td><%
		uploadfile_list pic,"up_pic",0
		upload_box "[one];pic;false;false;",450,0,"jpg|gif"%></td>
      </tr>
	  <tr> 
        <td align="right" bgcolor="#eeeeee">上传视频：</td>
        <td><%
		uploadfile_list picture,"up_picture",0
		upload_box "[one];picture;false;false;",450,0,"rm|swf|rmvb|wmv|avi|mid|mp3|ra"%></td>
      </tr>
	  <tr> 
        <td align="right" bgcolor="#eeeeee">其它下载点：</td>
        <td><input name="has_price" type="hidden" id="has_price" value="has_price">
		<textarea name="other_link" style="width:100%;height:100px;"><%=other_link%></textarea><br>
		如：华军下载||http//newhua.com/dokskssks/sksks.htm 多个下载点用回车分隔
		</td>
      </tr>
	  <%end if%>
    </table>
	
    <br>
    <input type="submit" name="action" value="Submit">
    <input type="hidden" name="language" value="<%=ufomail_request("QueryString","language")%>">
  </form>
</div>
<br>
<div class="page-foot"><%=db_getvalue("setup_name='page_foot'","sys_setup","setup_value")%></div><br>
</body>
</html>
