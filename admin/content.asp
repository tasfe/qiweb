<!--#include file="../common.asp"-->
<%
	check_admin
	default_language=db_getvalue("setup_name='default_language'","sys_setup","setup_value")
	if ufomail_request("Form","action")<>"" then
		call db_save("edit","sitemap","link_url|+|edit_date",ufomail_request("Form","link_url") & "|+|" & now(),"id=" & ufomail_request("Form","sitemap_id"))
		response.redirect "content.asp?id=" & ufomail_request("Form","sitemap_id") & "&language=" & ufomail_request("Form","language")
		response.end
	end if
	language=ufomail_request("QueryString","language")
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title><%=db_getvalue("id=" & language,"[language]","[language]")%>内容管理</title>
<link href="../css.css" rel="stylesheet" type="text/css">
</head>

<body>
<!--功能标题-->
<div class="page-title"><%=db_getvalue("id=" & language,"[language]","[language]")%>内容管理</div>
<%if return_info<>"" then%>
<div class="return-info"><%=return_info%></div>
<%end if%>
<div class="help-info">系统帮助： <br>
  1、先找到你要修改的内容是属于那一个菜单的，在菜单后面点击“列出内容”！<br>
  2、接着底部就会列出你选择的菜单下的所有网页内容！<br>
  3、然后可以点击修改原有的内容，或是在这个菜单下新增加内容。<br>
  </div>
<div class="oper-content"> 
  <%
  set rs=server.createobject("adodb.recordset")
  set rs1=server.createobject("adodb.recordset")
  sql="select * from sitemap where parent=0 and [language]=" & language & " order by seq"
  rs.open sql,conn,1,1
  response.write "<div class='sitemap'><ul>"
  do while not rs.eof 
	response.write "<li><span>" & rs("title") & "</span><a href='content.asp?id=" & rs("id") & "&language=" & language & "#edit_form'>列出内容</a>"
		sql="select * from sitemap where parent=" & rs("id") & " order by seq"
		rs1.open sql,conn,1,1
		if not rs1.eof then
			response.write "<ul>"
			do while not rs1.eof 
				response.write "<li><span>" & rs1("title") & "</span><a href='content.asp?id=" & rs1("id") & "&language=" & language & "#edit_form'>列出内容</a></li>"
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
  	content_style="[内容]"
  	if ufomail_request("QueryString","id")<>"" then
		sql="select * from sitemap where id=" & ufomail_request("QueryString","id")
		rs.open sql,conn,1,1
		if not rs.eof then
			title=rs("title")
			data_style=rs("data_style")
			select case data_style
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
			sitemap_id=rs("id")
		end if
		rs.close
	end if
	if isempty(data_style) then data_style=0
  %>
  <div class="help-info">
  	[ <%=title%> ] 栏目下有以下<%=content_style%>：
  </div>
  <a name="edit_form"/>
  	<% if data_style<>3 and isempty(sitemap_id)=false then%>
	<div class="button">
	<a href="content_edit.asp?language=<%=language%>&class=<%=sitemap_id%>&style=<%=data_style%>">增加<%=content_style%></a> 
	<%
	if default_language<>language then
	%>
	<a href="content_copy.asp?language=<%=language%>&class=<%=sitemap_id%>&style=<%=data_style%>">从默认语言中复制</a>
	<%
	end if
	%>
	<a href="gather_link.asp?site_id=<%=sitemap_id%>">数据采集设置</a>
	<a href="gather.asp?site_id=<%=sitemap_id%>">数据采集</a>
	<a href="content_edit.asp?language=<%=language%>&class=<%=sitemap_id%>&style=<%=data_style%>&action=deleall"><font color='red'>清空此栏目所有数据</font></a>
	</div>
	<%
	end if
	sub table_head()
	dim site_id
	site_id=ufomail_request("QueryString","id")
	%>
  <table width="95%" border="0" cellpadding="3" cellspacing="0" bgcolor="#E2F4FF" class="all_border" >
	<tr> 
	  <td width="60%">共有:<strong><font color=green> <%=pgnm%> 
		</font></strong>页 每页<font color="green"><strong> <%=pgsize%> 
		</strong></font>条记录 第<font color="green"><strong> <%=page%> 
		</strong></font>页</td>
	  <td width="10%"><a href=content.asp?id=<%=site_id%>&language=<%=language%>&page=1#edit_form>第一页</a></td>
	  <td width="10%"> 
		<%if page=1 then %>
		<font color=red>上一页</font> 
		<%else %>
		<a href=content.asp?id=<%=site_id%>&language=<%=language%>&page=<%=page-1%>#edit_form>上一页</a> 
		<%end if%>
	  </td>
	  <td width="10%"> 
		<%if page=pgnm then %>
		<font color=red>下一页</font> 
		<%else %>
		<a href=content.asp?id=<%=site_id%>&language=<%=language%>&page=<%=page+1%>#edit_form>下一页</a> 
		<%end if%>
	  </td>
	  <td width="10%"><a href=content.asp?id=<%=site_id%>&language=<%=language%>&page=<%=pgnm%>#edit_form>最后一页</a></td>
	</tr>
  </table>
  <%
	end sub
	if ufomail_request("QueryString","id")<>"" then
		select case data_style
		case 0
			sql="select * from article where class=" & sitemap_id
		case 1
			sql="select * from product where class=" & sitemap_id
		case 2
			response.write "<script language='javascript'>window.location='lyb_manager.asp';</script>"
			response.end
		case 3
			sql="select * from sitemap where id=" & sitemap_id
		case 4
			response.write "<script language='javascript'>window.location='http://qiweb.cn/server/guest_manager.asp?user_name=" & db_getvalue("setup_name='user_name'","sys_setup","setup_value") & "';</script>"
			response.end
		case 5
			sql="select * from album where class=" & sitemap_id
		case 6
			sql="select * from software where class=" & sitemap_id
		case 7
			sql="select * from movie where class=" & sitemap_id
		end select
		pgsize=30
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
			if pgnm>1 then
				'显示分页
				call table_head()
				'response.write "<br/>"
			end if
		end if
	end if
	%>
  <table width="95%" border="1" cellpadding="2" cellspacing="0" bordercolor="#CCCCCC" class="table-cell">
    <tr bgcolor="#e0e0e0"> 
      <td>标题</td>
      <td width="110">所属分类</td>
      <td width="100" bgcolor="#e0e0e0">发布时间</td>
      <td width="100" align="center">操作</td>
    </tr>
    <%
	  if ufomail_request("QueryString","id")<>"" then
		if not rs.eof then
			do while not rs.eof and count<pgsize 
			if data_style=3 then
			%>
			<tr>
			 <form name="form1" method="post" action="content.asp">
      <td colspan="4" height="60"> 
       	在下面输入你的要连接的网址，如http://txmaimai.com：<br/>
          <input type="text" name="link_url" size="60" value="<%=rs("link_url")%>"/>
          <input type="submit" name="action" value="保存">
          <input type="hidden" name="language" value="<%=language%>"> 
          <input type="hidden" name="sitemap_id" value="<%=sitemap_id%>">
        </td>
      </form>
			</tr>
			<%
			else
			%>
		<tr> 
		  <td><%=rs("title")%></td>
		  <td><%=title%></td>
		  <td><%=rs("create_date")%></td>
		  
      <td align="center">[ <a href="content_edit.asp?language=<%=language%>&class=<%=sitemap_id%>&style=<%=data_style%>&id=<%=rs("id")%>">修改</a> 
        ][ <a href="content_edit.asp?language=<%=language%>&class=<%=sitemap_id%>&style=<%=data_style%>&id=<%=rs("id")%>&action=dele">删除</a> 
        ]</td>
		</tr>		
			<%
			end if
			count=count+1
			rs.movenext
			loop
		else
			%>
	  <tr align="center"> 
         <td colspan="4" height="60">还没有内容请点[增加]添加内容</td>
      </tr>
	 		<%
		end if
		rs.close
	  else
	  %>
	  <tr align="center"> 
         <td colspan="4" height="60">请先选择栏目分类</td>
      </tr>
	  <%
	  end if
	  %>
  </table>
  <%
 			if pgnm>1 then
				'显示分页
				call table_head()
			end if
  %>
</div>
<br>
<div class="page-foot"><%=db_getvalue("setup_name='page_foot'","sys_setup","setup_value")%></div><br>
</body>
</html>
