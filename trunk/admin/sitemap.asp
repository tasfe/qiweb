<!--#include file="../common.asp"-->
<%
	check_admin
	default_language=db_getvalue("setup_name='default_language'","sys_setup","setup_value")
	if ufomail_request("Form","action")<>"" then
		errr=false
		title=ufomail_request("Form","title")
		parent=ufomail_request("Form","parent")
		seq=ufomail_request("Form","seq")
		if ufomail_request("Form","sitemap_id")<>"" then
		data_style=db_getvalue("id=" & ufomail_request("Form","sitemap_id"),"sitemap","data_style")
			if cstr(data_style)<>ufomail_request("Form","data_style") then
				select case data_style
				case 0
					data_count=db_getvalue("class=" & ufomail_request("Form","sitemap_id"),"article","count(*)")
					if data_count<>0 then
						return_info="请先删除这个栏目下面的所有文章再修改这个栏目的数据类型！"
						errr=true
					end if
				case 1
					data_count=db_getvalue("class=" & ufomail_request("Form","sitemap_id"),"product","count(*)")
					if data_count<>0 then
						return_info="请先删除这个栏目下面的所有产品修改这个栏目的数据类型！"
						errr=true
					end if
				end select
			end if
			child_id=db_getvalue("parent=" & ufomail_request("Form","sitemap_id"),"sitemap","id")
			if child_id<>"" and parent<>0 then
				return_info="请先删除从属于它的栏目"
				errr=true
			end if
		end if
		data_style=ufomail_request("Form","data_style")
		
		if title="" then
			return_info="没有输入标题!"
			errr=true
		end if
		if parent="" then
			return_info="没有选择所属分类"
			errr=true
		end if
		if seq="" then
			return_info="没有输入排序!"
			errr=true
		end if
		if data_style="" then
			return_info="没有栏目类型!"
			errr=true
		end if
		if not errr then
			if ufomail_request("Form","sitemap_id")="" then
				input_label="title|+|seq|+|parent|+|data_style|+|create_date|+|edit_date|+|language|+|code" 
				input_value=title & "|+|" & seq & "|+|" & parent & "|+|" & data_style & "|+|" & now() & "|+|" & now() & "|+|" & ufomail_request("Form","language") & "|+|" & create_code()
				call db_save("add","sitemap",input_label,input_value,"")
			else
				input_label="title|+|seq|+|parent|+|data_style|+|edit_date"
				input_value=title & "|+|" & seq & "|+|" & parent & "|+|" & data_style & "|+|" & now()
				call db_save("edit","sitemap",input_label,input_value,"id=" & ufomail_request("Form","sitemap_id"))
			end if
			response.redirect "sitemap.asp?language=" & ufomail_request("Form","language")
		end if
	end if
	if ufomail_request("QueryString","action")="dele" and ufomail_request("QueryString","id")<>"" then
		data_style=db_getvalue("id=" & ufomail_request("QueryString","id"),"sitemap","data_style")
		errr=false
		'检查它后面有没有子目录了？
		child_id=db_getvalue("parent=" & ufomail_request("QueryString","id"),"sitemap","id")
		if child_id<>"" then
			return_info="请先删除从属于它的栏目"
			errr=true
		end if
		'检查有没有数据,有数据就要把原来的数据一起清除
		'
		select case data_style
			case 0
				data_count=db_getvalue("class=" & ufomail_request("QueryString","id"),"article","count(*)")
				if data_count<>0 then
					return_info="请先删除这个栏目下面的所有文章再删除这个栏目"
					errr=true
				end if
			case 1
				data_count=db_getvalue("class=" & ufomail_request("QueryString","id"),"product","count(*)")
				if data_count<>0 then
					return_info="请先删除这个栏目下面的所有产品再删除这个栏目"
					errr=true
				end if
		end select
		if not errr then
			sql="delete * from sitemap where id=" & ufomail_request("QueryString","id")
			conn.execute sql
			response.redirect "sitemap.asp?language=" & ufomail_request("QueryString","language")
		end if
		
	end if
	language=ufomail_request("QueryString","language")
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>栏目管理</title>
<link href="../css.css" rel="stylesheet" type="text/css">
</head>

<body>
<!--功能标题-->
<div class="page-title"><%=db_getvalue("id=" & language,"[language]","[language]")%>栏目管理</div>
<%if return_info<>"" then%>
<div class="return-info"><%=return_info%></div>
<%end if%>
<div class="help-info">说明： <br>
  1、下面是你的网站的栏目分类<br>
</div>
<div class="oper-content"> 
	<div class="button">
		<a href="sitemap.asp?language=<%=ufomail_request("QueryString","language")%>">新增栏目</a>
		<%if default_language<>ufomail_request("QueryString","language") then%>
		<a href="sitemap_copy.asp?language=<%=ufomail_request("QueryString","language")%>">从默认语言中复制</a>
		<%end if%>
	</div> 
  <%
  set rs=server.createobject("adodb.recordset")
  set rs1=server.createobject("adodb.recordset")
  sql="select * from sitemap where parent=0 and [language]=" & ufomail_request("QueryString","language") & " order by seq"
  rs.open sql,conn,1,1
  response.write "<div class='sitemap'><ul>"
  do while not rs.eof 
	response.write "<li><span>" & rs("title") & "</span><a href='sitemap.asp?id=" & rs("id") & "&language=" & ufomail_request("QueryString","language") & "'>修改</a><a href='sitemap.asp?action=dele&id=" & rs("id") & "&language=" & ufomail_request("QueryString","language") & "'>删除</a>"
		sql="select * from sitemap where parent=" & rs("id") & " order by seq"
		rs1.open sql,conn,1,1
		if not rs1.eof then
			response.write "<ul>"
			do while not rs1.eof 
				response.write "<li><span>" & rs1("title") & "</span><a href='sitemap.asp?id=" & rs1("id") & "&language=" & ufomail_request("QueryString","language") & "'>修改</a><a href='sitemap.asp?action=dele&id=" & rs1("id") & "&language=" & ufomail_request("QueryString","language") & "'>删除</a></li>"
				rs1.movenext
			loop
			response.write "</ul>"
		end if
		rs1.close
	response.write "</li>"
	rs.movenext
  loop
  response.write "</ul></div>"
  rs.close
  %>
  <form action="" method="post" name="form1">
  	
    <table width="500" border="1" cellpadding="2" cellspacing="0" bordercolor="#CCCCCC" class="table-cell">
      <tr bgcolor="#e0e0e0"> 
        <td>栏目名称</td>
        <td>栏目类型</td>
        <td>所属分类</td>
        <td>排序</td>
      </tr>
	  <%
	  if ufomail_request("QueryString","id")<>"" then
	  	sql="select * from sitemap where id=" & ufomail_request("QueryString","id")
		rs.open sql,conn,1,1
		if not rs.eof then
			title=rs("title")
			parent=rs("parent")
			seq=rs("seq")
			data_style=rs("data_style")
			sitemap_id=rs("id")
		end if
		rs.close
	  end if
	  %>
      <tr>
        <td><input name="title" type="text" id="title" value="<%=title%>" size="15"></td>
        <td><select name="data_style">
            <option value="0" <%if data_style=0 then response.write " selected"%>>普通图文</option>
            <option value="1" <%if data_style=1 then response.write " selected"%>>产品类型</option>
            <option value="2" <%if data_style=2 then response.write " selected"%>>留言信息</option>
            <option value="3" <%if data_style=3 then response.write " selected"%>>网址链接</option>
            <option value="4" <%if data_style=4 then response.write " selected"%>>客户反馈</option>
            <option value="5" <%if data_style=5 then response.write " selected"%>>相册类型</option>
            <option value="6" <%if data_style=6 then response.write " selected"%>>文件下载</option>
            <option value="7" <%if data_style=7 then response.write " selected"%>>视频分享</option>
          </select></td>
        <td><select name="parent">
            <option value="0">作为分类</option>
			<%
			sql="select * from sitemap where parent=0 and [language]=" & ufomail_request("QueryString","language") & " order by seq"
			rs.open sql,conn,1,1
			do while not rs.eof 
				if parent=rs("id") then
				response.write "<option value='" & rs("id") & "' selected>" & rs("title") & "</option>"
				else
				response.write "<option value='" & rs("id") & "'>" & rs("title") & "</option>"
				end if
			rs.movenext
			loop
			rs.close
			set rs=nothing
			%>
          </select></td>
        <td><input name="seq" type="text" id="seq" value="<%=seq%>" size="5"></td>
      </tr>
    </table>
    <hr size="1"/>
    <input name="action" type="submit" id="action" value="保存">
    <input name="sitemap_id" type="hidden" id="sitemap_id" value="<%=sitemap_id%>">
	<input name="language" type="hidden" id="language" value="<%=ufomail_request("QueryString","language")%>">
  </form>
</div>
<br>
<div class="page-foot"><%=db_getvalue("setup_name='page_foot'","sys_setup","setup_value")%></div><br>
</body>
</html>
