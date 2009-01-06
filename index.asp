<!--#include file="common.asp"-->
<%
response.Buffer=true
xml_temp_str=""
''写出页头
xml_temp_str=xml_temp_str & "<?xml version='1.0' encoding='utf-8'?>" & vbCRLF
''写出XSL样式表 
site=db_getvalue("setup_name='site'","sys_setup","setup_value")
if site<>"" then
	site="site/" & get_left(site,".") & ".xsl"
else
	site="site/index.xsl"
end if
xml_temp_str=xml_temp_str & "<?xml-stylesheet type='text/xsl' href='template/" & site & "'?>" & vbCRLF
''页面内容 
xml_temp_str=xml_temp_str & "<page>" & vbCRLF
''显示网站的meta:
xml_temp_str=xml_temp_str & "	<page_meta><![CDATA[" & db_getvalue("setup_name='page_head'","sys_setup","setup_value") & "]]></page_meta>" & vbCRLF
''显示多少种语言:
show_language=db_getvalue("setup_name='show_language'","sys_setup","setup_value")
xml_temp_str=xml_temp_str & "<show_language>" & show_language & "</show_language>" & vbCRLF
'获得网页使用的语言
language=request.cookies("language")
if isempty(language) then 
	default_language=db_getvalue("setup_name='default_language'","sys_setup","setup_value")
	language=cint(default_language)
end if 
'设置是否打开简繁自动转换程序
if language=2 then
	gb_to_big5=db_getvalue("setup_name='gb_to_big5'","sys_setup","setup_value")
	if gb_to_big5="true" then
		language=1
	end if
end if
'调出LOGO 
xml_temp_str=xml_temp_str & "	<site_logo><![CDATA[" & file_show(db_getvalue("setup_name='site_logo'","sys_setup","setup_value")) & "]]></site_logo>" & vbCRLF
'根据语言不同,调出不同的界面
set rs=server.createobject("adodb.recordset")
'调出不同语言的常量文字包 
xml_temp_str=xml_temp_str & "	<language_pack>" & vbCRLF
sql="select * from [language] where id=" & language
rs.open sql,conn,1,1
if not rs.eof then
	set rs_fields=rs.fields
	for each fields_name in rs_fields
		'response.write fields_name.name & "<br/>"
		if fields_name.name<>"site_news" then
			xml_temp_str=xml_temp_str & "		<" & fields_name.name & "><![CDATA[" & fields_name & "]]></" & fields_name.name & ">" & vbCRLF
		end if
	next
	'response.end
end if
rs.close
xml_temp_str=xml_temp_str & "	</language_pack>" & vbCRLF
'调出网站页面显示的参数
xml_temp_str=xml_temp_str & "	<page_para>" & vbCRLF
xml_temp_str=xml_temp_str & "		<para_news_scrollAmount>" & db_getvalue("setup_name='para_news_scrollAmount'","sys_setup","setup_value") & "</para_news_scrollAmount>" & vbCRLF
xml_temp_str=xml_temp_str & "		<para_pic_width>" & db_getvalue("setup_name='para_pic_width'","sys_setup","setup_value") & "</para_pic_width>" & vbCRLF
xml_temp_str=xml_temp_str & "		<para_pic_height>" & db_getvalue("setup_name='para_pic_height'","sys_setup","setup_value") & "</para_pic_height>" & vbCRLF
xml_temp_str=xml_temp_str & "		<para_picture_width>" & db_getvalue("setup_name='para_picture_width'","sys_setup","setup_value") & "</para_picture_width>" & vbCRLF
xml_temp_str=xml_temp_str & "		<para_picture_height>" & db_getvalue("setup_name='para_picture_height'","sys_setup","setup_value") & "</para_picture_height>" & vbCRLF
'商城显示
xml_temp_str=xml_temp_str & "		<site_shop_open>" & db_getvalue("setup_name='site_shop_open'","sys_setup","setup_value") & "</site_shop_open>" & vbCRLF
xml_temp_str=xml_temp_str & "		<payfor_style>" & db_getvalue("setup_name='payfor_style'","sys_setup","setup_value") & "</payfor_style>" & vbCRLF
xml_temp_str=xml_temp_str & "	</page_para>" & vbCRLF
'调出网页的内容 
if ufomail_request("querystring","keyword")<>"" then 
	sql="select * from sitemap where data_style=99 order by parent,seq"
else 
	if ufomail_request("querystring","tag")<>"" then
		sql="select * from sitemap where data_style=99 order by parent,seq"
	else
		if ufomail_request("querystring","sitepage")<>"" then
			sql="select * from sitemap where [language]=" & language & " and id=" & ufomail_request("querystring","sitepage")
		else
			sql="select * from sitemap where parent=0 and [language]=" & language & " order by seq"
		end if
	end if
end if
rs.open sql,conn,1,1
if not rs.eof then
	if rs("data_style")=3 then
		response.Redirect rs("link_url")
		response.end
	end if
	xml_temp_str=xml_temp_str & "	<cur_page>" & rs("id") & "</cur_page>" & vbCRLF
	if rs("parent")=0 then
		xml_temp_str=xml_temp_str & "	<parent_page>" & rs("id") & "</parent_page>" & vbCRLF
	else
		xml_temp_str=xml_temp_str & "	<parent_page>" & rs("parent") & "</parent_page>" & vbCRLF
	end if
	data_style=rs("data_style")
	page_head_title=rs("title")
	xml_temp_str=xml_temp_str & "	<frame><![CDATA[" & rs("frame") & "]]></frame>" & vbCRLF
	xml_temp_str=xml_temp_str & "	<data_style>" & data_style & "</data_style>" & vbCRLF
	xml_temp_str=xml_temp_str & "	<adv_info><![CDATA[" & rs("adv_info") & "]]></adv_info>" & vbCRLF
	cur_page=rs("id")
	if cur_page=db_getvalue("[language]=" & language & " and parent=0 order by seq","sitemap","ID") then
		xml_temp_str=xml_temp_str & "		<site_news><![CDATA[" & db_getvalue("id=" & language,"[language]","site_news") & "]]></site_news>" & vbCRLF
	end if
else
	if ufomail_request("querystring","keyword")="" and ufomail_request("querystring","sitepage")<>"" then
		code=db_getvalue("id=" & ufomail_request("querystring","sitepage"),"sitemap","code")
		sitemap_id=db_getvalue("code='" & code & "' and [language]=" & language,"sitemap","id")
		if sitemap_id<>"" then 
			response.Redirect "index.asp?sitepage=" & sitemap_id
		else	
			response.Redirect "index.asp"
		end if
	end if
	data_style=99
	cur_page=0
	xml_temp_str=xml_temp_str & "	<cur_page>0</cur_page>" & vbCRLF
	xml_temp_str=xml_temp_str & "	<parent_page>0</parent_page>" & vbCRLF
	xml_temp_str=xml_temp_str & "	<data_style>99</data_style>" & vbCRLF
	xml_temp_str=xml_temp_str & "	<frame></frame>" & vbCRLF
end if
rs.close
'用户调用的系统模板代码：
xml_temp_str=xml_temp_str & "	<user><page_content><![CDATA[" & user_define_code & "]]></page_content></user>" & vbCRLF
'用户定义的代码
xml_temp_str=xml_temp_str & "	<user_template><page_content><![CDATA[" & user_template_code & "]]></page_content></user_template>" & vbCRLF
if isempty(cur_page) then
	cur_page=0
end if
'根据不同的数据类型,生成不同的内容
function add_link(temp_str)
	dim ss_str,i
	if temp_str="" or isnull(temp_str) or isempty(temp_str) then
		exit function
	end if
	ss_str=split(temp_str,"、")
	for i=0 to ubound(ss_str)
	add_link=add_link & "、<a href='/index.asp?tag=" & ss_str(i) & "' target='_blank'>" & ss_str(i) & "</a>"
	next
	add_link=right(add_link,len(add_link)-1)
end function
select case data_style
	case 0
		if ufomail_request("querystring","contentid")<>"" then
			sql="select * from article where id=" & ufomail_request("querystring","contentid")
		else
			sql="select * from article where [language]=" & language & " and class=" & cur_page & " order by seq,id desc"
		end if
		pgsize=40
		page=ufomail_request("querystring","page")
		rs.open sql,conn,1,1
		if not rs.eof then
			rs.pagesize=pgsize
			ufo=rs.recordcount
			if ufo mod pgsize =0 then
				pgnm=ufo\pgsize
			else
				pgnm=ufo\pgsize+1
			end if
			if ufo=0 then
				pgnm=0
			end if
			set rs1=nothing
			if page="" then page=0
			if clng(page)<1 then page=1
			if clng(page)>=pgnm then page=pgnm
			if pgnm>0 then rs.absolutepage=page
			count=0
		end if
		if not rs.eof then
			xml_temp_str=xml_temp_str & "	<article_list>" & vbCRLF
			xml_temp_str=xml_temp_str & "		<page_info><pgsize>" & pgsize & "</pgsize><pgnm>" & pgnm & "</pgnm><pg>" & page & "</pg></page_info>" & vbCRLF
			if ufo=1 then
				xml_temp_str=xml_temp_str & "		<page_head_title><![CDATA[" & rs("title") & "]]></page_head_title>" & vbCRLF
			else
				xml_temp_str=xml_temp_str & "		<page_head_title><![CDATA[" & page_head_title & "]]></page_head_title>" & vbCRLF
			end if
			do while not rs.eof and count<pgsize 
				xml_temp_str=xml_temp_str & "	<article>" & vbCRLF
				xml_temp_str=xml_temp_str & "		<content_id>" & rs("id") & "</content_id>" & vbCRLF
				xml_temp_str=xml_temp_str & "		<title><![CDATA[" & rs("title") & "]]></title>" & vbCRLF
				if ufo=1 then
				xml_temp_str=xml_temp_str & "		<keyword><![CDATA[" & add_link(rs("keyword")) & "]]></keyword>" & vbCRLF
				xml_temp_str=xml_temp_str & "		<content><![CDATA[" & rs("content") & "]]></content>" & vbCRLF
				end if
				xml_temp_str=xml_temp_str & "		<create_date>" & rs("create_date") & "</create_date>" & vbCRLF
				xml_temp_str=xml_temp_str & "	</article>" & vbCRLF
				count=count+1
			rs.movenext
			loop
			xml_temp_str=xml_temp_str & "	</article_list>" & vbCRLF
		end if
		rs.close
	case 1
		if ufomail_request("querystring","contentid")<>"" then
			sql="select * from product where id=" & ufomail_request("querystring","contentid")
		else
			sql="select * from product where [language]=" & language & " and class=" & cur_page & " order by seq,id desc"
		end if
		para_product_count=db_getvalue("setup_name='para_product_count'","sys_setup","setup_value")
		if para_product_count="" or isnull(para_product_count) then
			para_product_count=9
		else
			para_product_count=cint(para_product_count)
		end if
		pgsize=para_product_count
		page=ufomail_request("querystring","page")
		rs.open sql,conn,1,1
		if not rs.eof then
			rs.pagesize=pgsize
			ufo=rs.recordcount
			if ufo mod pgsize =0 then
				pgnm=ufo\pgsize
			else
				pgnm=ufo\pgsize+1
			end if
			if ufo=0 then
				pgnm=0
			end if
			set rs1=nothing
			if page="" then page=0
			if clng(page)<1 then page=1
			if clng(page)>=pgnm then page=pgnm
			if pgnm>0 then rs.absolutepage=page
			count=0
		end if
		if not rs.eof then
			xml_temp_str=xml_temp_str & "	<product_list>" & vbCRLF
			xml_temp_str=xml_temp_str & "		<page_info><pgsize>" & pgsize & "</pgsize><pgnm>" & pgnm & "</pgnm><pg>" & page & "</pg></page_info>" & vbCRLF
			if ufo=1 then
				xml_temp_str=xml_temp_str & "		<page_head_title><![CDATA[" & rs("title") & "]]></page_head_title>" & vbCRLF
			else
				xml_temp_str=xml_temp_str & "		<page_head_title><![CDATA[" & page_head_title & "]]></page_head_title>" & vbCRLF
			end if
			do while not rs.eof and count<pgsize
				xml_temp_str=xml_temp_str & "		<product>" & vbCRLF
				xml_temp_str=xml_temp_str & "			<content_id>" & rs("id") & "</content_id>" & vbCRLF
				xml_temp_str=xml_temp_str & "			<title><![CDATA[" & rs("title") & "]]></title>" & vbCRLF
				if ufo=1 then
				xml_temp_str=xml_temp_str & "		<keyword><![CDATA[" & add_link(rs("keyword")) & "]]></keyword>" & vbCRLF
				xml_temp_str=xml_temp_str & "			<content><![CDATA[" & rs("content") & "]]></content>" & vbCRLF
				end if
				xml_temp_str=xml_temp_str & "			<create_date>" & rs("create_date") & "</create_date>" & vbCRLF
				xml_temp_str=xml_temp_str & "			<price>" & rs("price") & "</price>" & vbCRLF
				xml_temp_str=xml_temp_str & "			<num>" & rs("num") & "</num>" & vbCRLF
				xml_temp_str=xml_temp_str & "			<pic><![CDATA[" & small_pic(rs("pic")) & "]]></pic>" & vbCRLF
				xml_temp_str=xml_temp_str & "			<picture><![CDATA[" & big_pic(rs("picture")) & "]]></picture>" & vbCRLF
				xml_temp_str=xml_temp_str & "			<pictures><![CDATA[" 
				call uploadfile_list(rs("pictures"),"pictures",2) 
				xml_temp_str=xml_temp_str & "]]></pictures>" & vbCRLF
				xml_temp_str=xml_temp_str & "		</product>" & vbCRLF
				count=count+1
			rs.movenext
			loop
			xml_temp_str=xml_temp_str & "	</product_list>" & vbCRLF
		end if
		rs.close
	case 2
		sql="select * from lyb order by lyb_date desc"
		pgsize=20
		page=ufomail_request("querystring","page")
		rs.open sql,conn,1,1
		if not rs.eof then
			rs.pagesize=pgsize
			ufo=rs.recordcount
			if ufo mod pgsize =0 then
				pgnm=ufo\pgsize
			else
				pgnm=ufo\pgsize+1
			end if
			if ufo=0 then
				pgnm=0
			end if
			set rs1=nothing
			if page="" then page=0
			if clng(page)<1 then page=1
			if clng(page)>=pgnm then page=pgnm
			if pgnm>0 then rs.absolutepage=page
			count=0
		end if
		xml_temp_str=xml_temp_str & "		<page_head_title><![CDATA[" & page_head_title & "]]></page_head_title>" & vbCRLF
		if not rs.eof then
			xml_temp_str=xml_temp_str & "	<lyb_list>" & vbCRLF
			xml_temp_str=xml_temp_str & "		<page_info><pgsize>" & pgsize & "</pgsize><pgnm>" & pgnm & "</pgnm><pg>" & page & "</pg></page_info>" & vbCRLF
			do while not rs.eof and count<pgsize
				xml_temp_str=xml_temp_str & "		<lyb>" & vbCRLF
				xml_temp_str=xml_temp_str & "			<user_id>" & rs("user_id") & "</user_id>" & vbCRLF
				xml_temp_str=xml_temp_str & "			<lyb_title><![CDATA[" & rs("lyb_title") & "]]></lyb_title>" & vbCRLF
				xml_temp_str=xml_temp_str & "			<lyb_email><![CDATA[" & rs("lyb_email") & "]]></lyb_email>" & vbCRLF
				xml_temp_str=xml_temp_str & "			<lyb_content><![CDATA[" & rs("lyb_content") & "]]></lyb_content>" & vbCRLF
				xml_temp_str=xml_temp_str & "			<lyb_reply><![CDATA[" & rs("lyb_reply") & "]]></lyb_reply>" & vbCRLF
				xml_temp_str=xml_temp_str & "			<lyb_QQ><![CDATA[" & rs("lyb_QQ") & "]]></lyb_QQ>" & vbCRLF
				xml_temp_str=xml_temp_str & "			<lyb_date><![CDATA[" & rs("lyb_date") & "]]></lyb_date>" & vbCRLF
				xml_temp_str=xml_temp_str & "		</lyb>" & vbCRLF
				count=count+1
			rs.movenext
			loop
			xml_temp_str=xml_temp_str & "	</lyb_list>" & vbCRLF
		end if
		rs.close
	case 5 	'相册程序
		if ufomail_request("querystring","contentid")<>"" then
			sql="select * from album where id=" & ufomail_request("querystring","contentid")
		else
			sql="select * from album where [language]=" & language & " and class=" & cur_page & " order by seq,id desc"
		end if
		para_album_count=db_getvalue("setup_name='para_album_count'","sys_setup","setup_value")
		if para_album_count="" or isnull(para_album_count) then
			para_album_count=9
		else
			para_album_count=cint(para_album_count)
		end if
		pgsize=para_album_count
		page=ufomail_request("querystring","page")
		rs.open sql,conn,1,1
		if not rs.eof then
			rs.pagesize=pgsize
			ufo=rs.recordcount
			if ufo mod pgsize =0 then
				pgnm=ufo\pgsize
			else
				pgnm=ufo\pgsize+1
			end if
			if ufo=0 then
				pgnm=0
			end if
			set rs1=nothing
			if page="" then page=0
			if clng(page)<1 then page=1
			if clng(page)>=pgnm then page=pgnm
			if pgnm>0 then rs.absolutepage=page
			count=0
		end if
		xml_temp_str=xml_temp_str & "		<page_head_title><![CDATA[" & page_head_title & "]]></page_head_title>" & vbCRLF
		if not rs.eof then
			xml_temp_str=xml_temp_str & "	<album_list>" & vbCRLF
			xml_temp_str=xml_temp_str & "		<page_info><pgsize>" & pgsize & "</pgsize><pgnm>" & pgnm & "</pgnm><pg>" & page & "</pg></page_info>" & vbCRLF
			do while not rs.eof and count<pgsize
				xml_temp_str=xml_temp_str & "		<album>" & vbCRLF
				xml_temp_str=xml_temp_str & "			<content_id>" & rs("id") & "</content_id>" & vbCRLF
				xml_temp_str=xml_temp_str & "			<title><![CDATA[" & rs("title") & "]]></title>" & vbCRLF
				xml_temp_str=xml_temp_str & "			<content><![CDATA[" & rs("content") & "]]></content>" & vbCRLF
				if ufo=1 then
				xml_temp_str=xml_temp_str & "		<keyword><![CDATA[" & add_link(rs("keyword")) & "]]></keyword>" & vbCRLF
				end if
				xml_temp_str=xml_temp_str & "			<pic><![CDATA[" & big_pic(rs("pic")) & "]]></pic>" & vbCRLF
				xml_temp_str=xml_temp_str & "		</album>" & vbCRLF
				count=count+1
			rs.movenext
			loop
			xml_temp_str=xml_temp_str & "	</album_list>" & vbCRLF
		end if
		rs.close
	case 6	'软件类型
		if ufomail_request("querystring","contentid")<>"" then
			sql="select * from software where id=" & ufomail_request("querystring","contentid")
		else
			sql="select * from software where [language]=" & language & " and class=" & cur_page & " order by seq,id desc"
		end if
		para_album_count=db_getvalue("setup_name='para_software_count'","sys_setup","setup_value")
		if para_album_count="" or isnull(para_album_count) then
			para_album_count=9
		else
			para_album_count=cint(para_album_count)
		end if
		pgsize=para_album_count
		page=ufomail_request("querystring","page")
		rs.open sql,conn,1,1
		if not rs.eof then
			rs.pagesize=pgsize
			ufo=rs.recordcount
			if ufo mod pgsize =0 then
				pgnm=ufo\pgsize
			else
				pgnm=ufo\pgsize+1
			end if
			if ufo=0 then
				pgnm=0
			end if
			set rs1=nothing
			if page="" then page=0
			if clng(page)<1 then page=1
			if clng(page)>=pgnm then page=pgnm
			if pgnm>0 then rs.absolutepage=page
			count=0
		end if
		if not rs.eof then
			xml_temp_str=xml_temp_str & "	<software_list>" & vbCRLF
			xml_temp_str=xml_temp_str & "		<page_info><pgsize>" & pgsize & "</pgsize><pgnm>" & pgnm & "</pgnm><pg>" & page & "</pg></page_info>" & vbCRLF
			if ufo=1 then
				xml_temp_str=xml_temp_str & "		<page_head_title><![CDATA[" & rs("title") & "]]></page_head_title>" & vbCRLF
			else
				xml_temp_str=xml_temp_str & "		<page_head_title><![CDATA[" & page_head_title & "]]></page_head_title>" & vbCRLF
			end if
			do while not rs.eof and count<pgsize
				xml_temp_str=xml_temp_str & "		<software>" & vbCRLF
				xml_temp_str=xml_temp_str & "			<content_id>" & rs("id") & "</content_id>" & vbCRLF
				xml_temp_str=xml_temp_str & "			<title><![CDATA[" & rs("title") & "]]></title>" & vbCRLF
				content=rs("content")
				if ufo>1 then
					content=get_text_desc(content,180)
				end if
				xml_temp_str=xml_temp_str & "			<content><![CDATA[" & content & "]]></content>" & vbCRLF
				if ufo=1 then
				xml_temp_str=xml_temp_str & "		<keyword><![CDATA[" & add_link(rs("keyword")) & "]]></keyword>" & vbCRLF
				end if
				xml_temp_str=xml_temp_str & "			<create_date>" & rs("create_date") & "</create_date>" & vbCRLF
				xml_temp_str=xml_temp_str & "			<pic><![CDATA[" & small_pic(rs("pic")) & "]]></pic>" & vbCRLF
				xml_temp_str=xml_temp_str & "			<picture><![CDATA[" & rs("picture") & "]]></picture>" & vbCRLF
				xml_temp_str=xml_temp_str & "			<other_link><![CDATA[" 
				temp_str=rs("other_link")
				if temp_str & "1"<>"1" then
					temp_arr=split(temp_str,chr(13))
					for i=0 to ubound(temp_arr)
						if temp_arr(i)<>"" then
						xml_temp_str=xml_temp_str & "<a href='" & get_right(temp_arr(i),"||") & "' target='_blank'>" & get_left(temp_arr(i),"||") & "</a>"
						end if
					next
				end if
				xml_temp_str=xml_temp_str & ""
				xml_temp_str=xml_temp_str & "]]></other_link>" & vbCRLF
				xml_temp_str=xml_temp_str & "		</software>" & vbCRLF
				count=count+1
			rs.movenext
			loop
			xml_temp_str=xml_temp_str & "	</software_list>" & vbCRLF
		end if
		rs.close
	case 7	'视频列表
		if ufomail_request("querystring","contentid")<>"" then
			sql="select * from movie where id=" & ufomail_request("querystring","contentid")
		else
			sql="select * from movie where [language]=" & language & " and class=" & cur_page & " order by seq,id desc"
		end if
		para_album_count=db_getvalue("setup_name='para_movie_count'","sys_setup","setup_value")
		if para_album_count=""  or isnull(para_album_count) then
			para_album_count=9
		else
			para_album_count=cint(para_album_count)
		end if
		pgsize=para_album_count
		page=ufomail_request("querystring","page")
		rs.open sql,conn,1,1
		if not rs.eof then
			rs.pagesize=pgsize
			ufo=rs.recordcount
			if ufo mod pgsize =0 then
				pgnm=ufo\pgsize
			else
				pgnm=ufo\pgsize+1
			end if
			if ufo=0 then
				pgnm=0
			end if
			set rs1=nothing
			if page="" then page=0
			if clng(page)<1 then page=1
			if clng(page)>=pgnm then page=pgnm
			if pgnm>0 then rs.absolutepage=page
			count=0
		end if
		if not rs.eof then
			xml_temp_str=xml_temp_str & "	<movie_list>" & vbCRLF
			xml_temp_str=xml_temp_str & "		<page_info><pgsize>" & pgsize & "</pgsize><pgnm>" & pgnm & "</pgnm><pg>" & page & "</pg></page_info>" & vbCRLF
			if ufo=1 then
				xml_temp_str=xml_temp_str & "		<page_head_title><![CDATA[" & rs("title") & "]]></page_head_title>" & vbCRLF
			else
				xml_temp_str=xml_temp_str & "		<page_head_title><![CDATA[" & page_head_title & "]]></page_head_title>" & vbCRLF
			end if
			do while not rs.eof and count<pgsize
				xml_temp_str=xml_temp_str & "		<movie>" & vbCRLF
				xml_temp_str=xml_temp_str & "			<content_id>" & rs("id") & "</content_id>" & vbCRLF
				xml_temp_str=xml_temp_str & "			<title><![CDATA[" & rs("title") & "]]></title>" & vbCRLF
				content=rs("content")
				if ufo>1 then
					content=get_text_desc(content,180)
				end if
				xml_temp_str=xml_temp_str & "			<content><![CDATA[" & content & "]]></content>" & vbCRLF
				if ufo=1 then
				xml_temp_str=xml_temp_str & "		<keyword><![CDATA[" & add_link(rs("keyword")) & "]]></keyword>" & vbCRLF
				end if
				xml_temp_str=xml_temp_str & "			<create_date>" & rs("create_date") & "</create_date>" & vbCRLF
				xml_temp_str=xml_temp_str & "			<pic><![CDATA[" & small_pic(rs("pic")) & "]]></pic>" & vbCRLF
				movie_name=get_left(rs("picture"),"||")
				xml_temp_str=xml_temp_str & "			<picture><![CDATA[" & movie_player(replace(db_getvalue("file_id='" & movie_name & "'","uploadfile","file_path") & "/" & movie_name,"//","/")) & "]]></picture>" & vbCRLF
				xml_temp_str=xml_temp_str & "			<other_link><![CDATA[" 
				temp_str=rs("other_link")
				if temp_str & "1"<>"1" then
					temp_arr=split(temp_str,chr(13))
					for i=0 to ubound(temp_arr)
						if temp_arr(i)<>"" then
						xml_temp_str=xml_temp_str & "<a href='" & get_right(temp_arr(i),"||") & "' target='_blank'>" & get_left(temp_arr(i),"||") & "</a>"
						end if
					next
				end if
				xml_temp_str=xml_temp_str & ""
				xml_temp_str=xml_temp_str & "]]></other_link>" & vbCRLF
				xml_temp_str=xml_temp_str & "		</movie>" & vbCRLF
				count=count+1
			rs.movenext
			loop
			xml_temp_str=xml_temp_str & "	</movie_list>" & vbCRLF
		end if
		rs.close
	case 99
		if ufomail_request("querystring","tag")<>"" then
		xml_temp_str=xml_temp_str & "	<keyword>" & ufomail_request("querystring","tag") & "</keyword>" & vbCRLF
		sql="select id,title,content,class from article where [language]=" & language & " and keyword like '%" & trim(ufomail_request("querystring","tag")) & "%'"
		sql=sql & " UNION all select id,title,content,class from product where [language]=" & language & " and keyword like '%" & trim(ufomail_request("querystring","tag")) & "%'"
		sql=sql & " UNION all select id,title,content,class from album where [language]=" & language & " and keyword like '%" & trim(ufomail_request("querystring","tag")) & "%'"
		sql=sql & " UNION all select id,title,content,class from software where [language]=" & language & " and keyword like '%" & trim(ufomail_request("querystring","tag")) & "%'"
		sql=sql & " UNION all select id,title,content,class from movie where [language]=" & language & " and keyword like '%" & trim(ufomail_request("querystring","tag")) & "%'"
		else
		xml_temp_str=xml_temp_str & "	<keyword>" & ufomail_request("querystring","keyword") & "</keyword>" & vbCRLF
		sql="select id,title,content,class from article where [language]=" & language & " and title like '%" & trim(ufomail_request("querystring","keyword")) & "%'"
		sql=sql & " UNION all select id,title,content,class from product where [language]=" & language & " and title like '%" & trim(ufomail_request("querystring","keyword")) & "%'"
		sql=sql & " UNION all select id,title,content,class from album where [language]=" & language & " and title like '%" & trim(ufomail_request("querystring","keyword")) & "%'"
		sql=sql & " UNION all select id,title,content,class from software where [language]=" & language & " and title like '%" & trim(ufomail_request("querystring","keyword")) & "%'"
		sql=sql & " UNION all select id,title,content,class from movie where [language]=" & language & " and title like '%" & trim(ufomail_request("querystring","keyword")) & "%'"
		end if
		para_album_count=db_getvalue("setup_name='para_search_count'","sys_setup","setup_value")
		if para_album_count="" or isnull(para_album_count) then
			para_album_count=9
		else
			para_album_count=cint(para_album_count)
		end if
		pgsize=para_album_count
		page=ufomail_request("querystring","page")
		rs.open sql,conn,1,1
		if not rs.eof then
			rs.pagesize=pgsize
			ufo=rs.recordcount
			if ufo mod pgsize =0 then
				pgnm=ufo\pgsize
			else
				pgnm=ufo\pgsize+1
			end if
			if ufo=0 then
				pgnm=0
			end if
			set rs1=nothing
			if page="" then page=0
			if clng(page)<1 then page=1
			if clng(page)>=pgnm then page=pgnm
			if pgnm>0 then rs.absolutepage=page
			count=0
		end if
		xml_temp_str=xml_temp_str & "		<page_head_title><![CDATA[Search Keyword:" & ufomail_request("querystring","keyword") & "]]></page_head_title>" & vbCRLF
		if not rs.eof then
			xml_temp_str=xml_temp_str & "	<search_list>" & vbCRLF
			xml_temp_str=xml_temp_str & "		<page_info><pgsize>" & pgsize & "</pgsize><pgnm>" & pgnm & "</pgnm><pg>" & page & "</pg></page_info>" & vbCRLF
			do while not rs.eof and count<pgsize
				xml_temp_str=xml_temp_str & "		<search>" & vbCRLF
				xml_temp_str=xml_temp_str & "			<content_id>" & rs("id") & "</content_id>" & vbCRLF
				xml_temp_str=xml_temp_str & "			<title><![CDATA[" & rs("title") & "]]></title>" & vbCRLF
				content=rs("content")
				if content<>"" then
					content=RegExpreplace(content,"<([^>]*)>","")
					if len(content)>200 then
						content=left(content,200) & "……"
					end if
				end if
				xml_temp_str=xml_temp_str & "			<content><![CDATA[" & content & "]]></content>" & vbCRLF
				xml_temp_str=xml_temp_str & "			<class><![CDATA[" & rs("class") & "]]></class>" & vbCRLF
				xml_temp_str=xml_temp_str & "		</search>" & vbCRLF
				count=count+1
			rs.movenext
			loop
			xml_temp_str=xml_temp_str & "	</search_list>" & vbCRLF
		end if
		rs.close
end select
''------------------------------------------------------------------------------------
	sql="select * from link where [language]=" & language
	rs.open sql,conn,1,1
	xml_temp_str=xml_temp_str & "	<linklist>" & vbCRLF
	do while not rs.eof 
		xml_temp_str=xml_temp_str & "		<link>" & vbCRLF
		xml_temp_str=xml_temp_str & "			<link_name><![CDATA[" & rs("link_name") & "]]></link_name>" & vbCRLF 
		xml_temp_str=xml_temp_str & "			<link_url><![CDATA[" & rs("link_url") & "]]></link_url>" & vbCRLF 
		xml_temp_str=xml_temp_str & "			<link_desc><![CDATA[" & rs("link_desc") & "]]></link_desc>" & vbCRLF 
		xml_temp_str=xml_temp_str & "			<link_logo><![CDATA[" & rs("link_logo") & "]]></link_logo>" & vbCRLF 
		xml_temp_str=xml_temp_str & "		</link>" & vbCRLF
	rs.movenext
	loop
	rs.close
	xml_temp_str=xml_temp_str & "	</linklist>" & vbCRLF
sql="select * from sitemap where parent=0 and [language]=" & language & " order by seq"
rs.open sql,conn,1,1
set rs1=server.createobject("adodb.recordset")
xml_temp_str=xml_temp_str & "	<sitemap>" & vbCRLF
do while not rs.eof 
	xml_temp_str=xml_temp_str & "		<pagename>" & vbCRLF
	xml_temp_str=xml_temp_str & "			<page_id>" & rs("id") & "</page_id>" & vbCRLF
	xml_temp_str=xml_temp_str & "			<title><![CDATA[" & rs("title") & "]]></title>" & vbCRLF
	sql="select * from sitemap where parent=" & rs("id") & " and [language]=" & language & " order by seq"
	rs1.open sql,conn,1,1
	if not rs1.eof then
	xml_temp_str=xml_temp_str & "			<sitemap>" & vbCRLF
	do while not rs1.eof 
		xml_temp_str=xml_temp_str & "				<pagename>" & vbCRLF
		xml_temp_str=xml_temp_str & "					<page_id>" & rs1("id") & "</page_id>" & vbCRLF
		xml_temp_str=xml_temp_str & "					<title><![CDATA[" & rs1("title") & "]]></title>" & vbCRLF
		xml_temp_str=xml_temp_str & "				</pagename>" & vbCRLF
	rs1.movenext
	loop
	xml_temp_str=xml_temp_str & "			</sitemap>" & vbCRLF
	end if
	rs1.close
	xml_temp_str=xml_temp_str & "		</pagename>" & vbCRLF
rs.movenext
loop
rs.close
xml_temp_str=xml_temp_str & "	</sitemap>" & vbCRLF
'下面是公用语言包
%>
<!--#include file="public_language.inc"-->
<%
xml_temp_str=xml_temp_str & "</page>" & vbCRLF
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'response.write xml_temp_str
'response.end
'进行简繁转换
if gb_to_big5="true" then
	xml_temp_str=gb2312_big5(xml_temp_str)
end If
If ufomail_request("querystring","viewer")="xml" Then
	response.write xml_temp_str
	response.end
End if
set xml = Server.CreateObject("Microsoft.XMLDOM")
set xsl = Server.CreateObject("Microsoft.XMLDOM")
xml.async = false
xsl.async = false
xml.loadxml xml_temp_str
'response.write "template/" &  site
'response.end
liulanqi=request.ServerVariables("HTTP_User-Agent")
if Instr(liulanqi,"Mozilla")<>0 and ufomail_request("querystring","viewer")<>"wap" then
	xsl.load  Server.MapPath("template/" & site)
else
	xsl.load  Server.MapPath("template/site/wap.xsl")
	Response.ContentType = "text/vnd.wap.wml"
	response.Write "<?xml version='1.0' encoding='utf-8'?>" 
	response.Write "<!DOCTYPE wml PUBLIC '-//WAPFORUM//DTD WML 1.1//EN' 'http://www.wapforum.org/DTD/wml_1.1.xml'>" 
	response.Write xml.transformNode(xsl)
	response.end
end if
html_url=save_to_html(xml.transformNode(xsl),"index-" & language & "-" & ufomail_request("querystring","keyword") & "-" & ufomail_request("querystring","tag") & "-" & ufomail_request("querystring","sitepage") & "-" & ufomail_request("querystring","contentid") & "-" & ufomail_request("querystring","page") & ".htm")
Set xml = Nothing
Set xsl = Nothing
response.redirect(html_url)
%>
<!--#include file="plug-in/plug-in.inc" -->