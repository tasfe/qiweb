<!--#include file="../common.asp"-->
<%
	check_admin
	dim list_id
	list_id=""
	default_language=db_getvalue("setup_name='default_language'","sys_setup","setup_value")
	language=ufomail_request("querystring","language")
	sitemap_id=ufomail_request("querystring","class")
	if language<>default_language then
		
		code=db_getvalue("id=" & sitemap_id,"sitemap","code")
		if code<>"" then
			set rs=server.CreateObject("adodb.recordset")
			sql="select * from sitemap where [language]=" & default_language & " and code='" & code & "'"
			rs.open sql,conn,1,1
			if not rs.eof then
				default_id=rs("id")
				data_style=rs("data_style")
			end if
			rs.close
			if isempty(default_id)=false then
				select case data_style
					case 0
						sql="select * from article where class=" & default_id
						table_name="article"
					case 1
						sql="select * from product where class=" & default_id
						table_name="product"
					case 5
						sql="select * from album where class=" & default_id
						table_name="album"
					case 6
						sql="select * from software where class=" & default_id
						table_name="software"
					case 7
						sql="select * from movie where class=" & default_id
						table_name="movie"
				end select
				rs.open sql,conn,1,3
				do while not rs.eof 
					if isnull(rs("code")) then
						rs("code")=create_code() & rs("id")
						rs.update
					end if
					if db_getvalue("code='" & rs("code") & "' and class=" & sitemap_id & " and [language]=" & language,table_name,"id")="" then
						if list_id="" then 
							list_id=rs("id")
						else
							list_id=list_id & "," & rs("id")
						end if 
					end if
				rs.movenext
				loop
				rs.close
			end if
			set rs=nothing
		end if
	end if
	if list_id<>"" then
		select case table_name
			case "article"
				sql="insert into " & table_name & " (seq,class,title,create_date,content,code,[language]) select seq," & sitemap_id & " as class,title,create_date,content,code, " & language & " as [language] from " & table_name & " where ID in(" & list_id & ")"
			case "product"
				sql="insert into " & table_name & " (seq,class,title,create_date,content,code,[language],pic,picture,pictures,price,num) select seq," & sitemap_id & " as class,title,create_date,content,code, " & language & " as [language],pic,picture,pictures,price,num from " & table_name & " where ID in(" & list_id & ")"
			case "album"
				sql="insert into " & table_name & " (seq,class,title,create_date,content,code,[language],pic,view_num) select seq," & sitemap_id & " as class,title,create_date,content,code, " & language & " as [language],pic,view_num from " & table_name & " where ID in(" & list_id & ")"
			case "software"
				sql="insert into " & table_name & " (seq,class,title,create_date,content,code,[language],pic,picture,[password],other_link,view_num,download_num) select seq," & sitemap_id & " as class,title,create_date,content,code, " & language & " as [language],pic,picture,[password],other_link,view_num,download_num from " & table_name & " where ID in(" & list_id & ")"
			case "movie"
				sql="insert into " & table_name & " (seq,class,title,create_date,content,code,[language],pic,picture,other_link,view_num,download_num) select seq," & sitemap_id & " as class,title,create_date,content,code, " & language & " as [language],pic,picture,other_link,view_num,download_num from " & table_name & " where ID in(" & list_id & ")"
		end select
		conn.execute sql
	end if
	response.redirect request.ServerVariables("HTTP_REFERER")
	response.end
%>