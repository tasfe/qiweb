<!--#include file="../common.asp"-->
<!--#include file="../gather_class.asp"-->
<%
'on error resume next
call check_admin()
dim success_num,over_num,over_str
success_num=0
over_num=0
site_id=ufomail_request("querystring","site_id")
set rs=server.createobject("adodb.recordset")
sql="select * from sitemap where id=" & site_id
rs.open sql,conn,1,1
if not rs.eof then
	gather=rs("gather")
	data_style=rs("data_style")
	language=rs("language")
else
	response.redirect "gather_link.asp?site_id=" & site_id
end if
rs.close
select case data_style
	case 0 
		table_name="article"
	case 1
		table_name="product"
	case 5
		table_name="album"
	case 6
		table_name="software"
	case 7
		table_name="movie"
end select
sql="select * from gather where id in(" & gather & ")"
rs.open sql,conn,1,1
do while not rs.eof 
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
	call gather_save()
	rs.movenext
loop
rs.close
set rs=nothing
sub gather_save()
	dim rs,i,webstr,temp_http,web_str,webstr_page,temp_url
	dim title,content,create_date
	set rs=server.CreateObject("adodb.recordset")
	webstr=getHTTPPage(gather_url)
	webstr=stripHTML(webstr,gather_area1,gather_area2)
	webstr=Manhunt(webstr,gather_list1,gather_list2,true,true,false,true)
	if gather_list_page=1 then
		for page_no=2 to gather_list_page_num
			if instr(gather_url,"?")<>0 then
				temp_url=gather_url & "&" & gather_list_page_url & page_no
			else
				temp_url=gather_url & "?" & gather_list_page_url & page_no
			end if
			webstr_page=getHTTPPage(temp_url)
			webstr_page=stripHTML(webstr_page,gather_area1,gather_area2)
			webstr=webstr & Manhunt(webstr_page,gather_list1,gather_list2,true,true,false,true)
		next
	end if
	webstr=Split(webstr,"$url$")
	for i=0 to ubound(webstr)
		if webstr(i)<>"" then
			temp_http=HttpUrls(webstr(i),gather_url)
			web_str=getHTTPPage(temp_http)
			title=SeparateHTML(web_str,gather_title1,gather_title2)
			title=RegExpreplace(title,"<(.[^>]*)>","")
			sql="select * from " & table_name & " where title='" & replace(title,"'","''") & "'"
			rs.open sql,conn,1,3
			content=SeparateHTML(web_str,gather_content1,gather_content2)
			if gather_content_page=1 then
				'如果内容有分页的情况怎么办
			end if
			if rs.eof and title<>"False" and content<>"False" then
				rs.addnew
				'处理采集到的内容
				'第一步，保存服务器的图片到本地服务器
				Set fso = CreateObject("Scripting.FileSystemObject")
				upload_folder="/gather_files/"
				new_folder="/gather_files/"
				upload_folder=root_path & replace(upload_folder,"/","\")
				if fso.folderExists(upload_folder)=false then
					fso.createfolder upload_folder
				end if
				if gather_picture=1 then
					set temp_url=RegExpExecute("src=('|"")+([^\f\n\r\t\v'""]*)(""|')+ ",content)
					For Each url in temp_url
						img_url=url.SubMatches(1)
						new_name=create_code()
						file_type=lcase(right(img_url,4))
						if file_type=".jpg" or file_type=".gif" or file_type=".png" then
							save_path=upload_folder & new_name & file_type
							content=replace(content,url.value,"src='" & new_folder & new_name & file_type & "'")
							img_url=HttpUrls(img_url,temp_http)
							Save2local save_path,img_url
							save_path=""
						end if
						img_url=""
					next
				end if
				if gather_flash=1 then
					set temp_url=RegExpExecute("value=(""|')+([^\f\n\r\t\v'""]*)('|"")+",content)
					For Each url in temp_url
						img_url=url.SubMatches(1)
						new_name=create_code()
						file_type=lcase(right(img_url,4))
						if file_type=".swf" then
							save_path=upload_folder & new_name & file_type
							content=replace(content,img_url,new_folder & new_name & file_type)
							img_url=HttpUrls(img_url,temp_http)
							Save2local save_path,img_url
							save_path=""
						end if
					next
				end if
				'第二步，处理一些IFRAME的内容
				content=RegExpreplace(content,"<iframe([^>]*)>[^<]*</iframe>","")
				content=RegExpreplace(content,"<!--([^>]*)-->","")
				content=RegExpreplace(content,"<script([^>]*)>[^<]*</script>","")
				
				'第三步，将href中的相对链接改为绝对链接
				set temp_url=RegExpExecute("href=(""|')+([^\f\n\r\t\v'""]*)('|"")+",content)
				For Each url in temp_url
					img_url=url.SubMatches(1)
					new_folder=HttpUrls(img_url,temp_http)
					if new_folder<>img_url and len(img_url)>4 then 
						content=replace(content,img_url,new_folder)
					end if
				next
				if gather_link=1 then
					link=SeparateHTML(web_str,gather_link1,gather_link2)
					if link<>"False" then
						content =content & "From:<a href='" & temp_http & "' target='_blank'>" & link & "</a>"
					end if
				end if
				create_date=SeparateHTML(web_str,gather_date1,gather_date2)
				if isdate(create_date)=false then
					create_date=now()					
				end if
				'第三步，保存数据
				rs("title")=title
				rs("content")=content
				rs("create_date")=create_date
				rs("class")=site_id
				rs("language")=language
				rs.update
				success_num=success_num+1
			else
				if title<>"False" and content<>"False" then
					if session("addnew")=true then
						rs.addnew
					end if
					if session("overwrite")=true or session("addnew")=true then
						'处理采集到的内容
						'第一步，保存服务器的图片到本地服务器
						Set fso = CreateObject("Scripting.FileSystemObject")
						upload_folder="/gather_files/"
						new_folder="/gather_files/"
						upload_folder=root_path & replace(upload_folder,"/","\")
						if fso.folderExists(upload_folder)=false then
							fso.createfolder upload_folder
						end if
						if gather_picture=1 then
							set temp_url=RegExpExecute("src=('|"")+([^\f\n\r\t\v'""]*)(""|')+ ",content)
							For Each url in temp_url
								img_url=url.SubMatches(1)
								new_name=create_code()
								file_type=lcase(right(img_url,4))
								if file_type=".jpg" or file_type=".gif" or file_type=".png" then
									save_path=upload_folder & new_name & file_type
									content=replace(content,url.value,"src='" & new_folder & new_name & file_type & "'")
									img_url=HttpUrls(img_url,temp_http)
									Save2local save_path,img_url
									save_path=""
								end if
								img_url=""
							next
						end if
						if gather_flash=1 then
							set temp_url=RegExpExecute("value=(""|')+([^\f\n\r\t\v'""]*)('|"")+",content)
							For Each url in temp_url
								img_url=url.SubMatches(1)
								new_name=create_code()
								file_type=lcase(right(img_url,4))
								if file_type=".swf" then
									save_path=upload_folder & new_name & file_type
									content=replace(content,img_url,new_folder & new_name & file_type)
									img_url=HttpUrls(img_url,temp_http)
									Save2local save_path,img_url
									save_path=""
								end if
							next
						end if
						'第二步，处理一些IFRAME的内容
						content=RegExpreplace(content,"<iframe([^>]*)>[^<]*</iframe>","")
						content=RegExpreplace(content,"<!--([^>]*)-->","")
						content=RegExpreplace(content,"<script([^>]*)>[^<]*</script>","")
						'第三步，将href中的相对链接改为绝对链接
						set temp_url=RegExpExecute("href=(""|')+([^\f\n\r\t\v'""]*)('|"")+",content)
						For Each url in temp_url
							img_url=url.SubMatches(1)
							new_folder=HttpUrls(img_url,temp_http)
							if new_folder<>img_url and len(img_url)>4 then
								content=replace(content,img_url,new_folder)
							end if
						next
						if gather_link=1 then
							link=SeparateHTML(web_str,gather_link1,gather_link2)
							if link<>"False" then
								content =content & "From:<a href='" & temp_http & "' target='_blank'>" & link & "</a>"
							end if
						end if
						create_date=SeparateHTML(web_str,gather_date1,gather_date2)
						if isdate(create_date)=false then
							create_date=now()					
						end if
						'第三步，保存数据
						rs("title")=title
						rs("content")=content
						rs("create_date")=create_date
						rs("class")=site_id
						rs("language")=language
						rs.update
					end if
					over_num=over_num+1
					over_str=over_str & "|+@+|" & title
				end if
			end if
			rs.close
		end if
	next
	web_str=empty
	webstr_page=empty
	webstr=empty
	title=empty
	content=empty
	create_date=empty
	session("addnew")=false
	session("overwrite")=false
	set rs=nothing
end sub
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>数据采集结果</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../css.css" rel="stylesheet" type="text/css">
</head>

<body>
<div class="page-title"> 数据采集结果</div>
<div class="help-info">本次数据采集操作结果如下：<br>
  成功采集的文章数：<font color="#FF0000"><%=success_num%></font>条<br>
  以下<font color="red"><%=over_num%></font>条文章标题重复，所以略过采集数据。<hr size="1">
  <%
  over_title=split(over_str,"|+@+|")
  for i=1 to ubound(over_title)
  	response.write "<li>" & over_title(i) & "</li>"
  next
  %>
  </div>
<div class="button"><a href="content.asp?id=<%=site_id%>&language=<%=language%>">返回内容管理</a></div>
<br>
<br>
<div class="page-foot"><%=db_getvalue("setup_name='page_foot'","sys_setup","setup_value")%></div><br></body>
</html>
