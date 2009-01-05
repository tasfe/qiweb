<!--#include file="../common.asp"-->
<%
	check_admin
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>留言管理</title>
<link href="../css.css" rel="stylesheet" type="text/css">
</head>

<body>
<!--功能标题-->
<div class="page-title">留言本管理</div>
<%if return_info<>"" then%>
<div class="return-info"><%=return_info%></div>
<%end if%>
<div class="help-info">说明： <br>
  管理你的留言<br>
</div>
<div class="oper-content"> 
  <%
				set rs=server.createobject("adodb.recordset")
					sql="select * from lyb order by id desc"
					pgsize=50
					page=ufomail_request("querystring","page")
					rs.open sql,conn,1,3
					i=0
					rs.pagesize=pgsize
					sql=replace(sql,"*","count(*)")
					if instr(sql,"order by")<>0 then
						sql=left(sql,instr(sql,"order by")-1)
					end if
					set rs1=conn.execute(sql)
					ufo=rs1(0)
					pgnm=ufo\pgsize
					if ufo mod pgsize>0 then
						pgnm=cint(pgnm)+1
						'response.write pgnm
					end if
					if page="" then page=0
					if clng(page)<1 then page=1
					if clng(page)>=pgnm then page=pgnm
					if pgnm>0 then rs.absolutepage=page
					count=0
					call table_head()
					response.write "<br/>"
					sub table_head()
					%> <table width="95%" border="0" cellpadding="4" cellspacing="0" bgcolor="#E2F4FF" class="all-border" >
                    <tr> 
                      <td width="60%">共有:<strong><font color=green> <%=pgnm%> </font></strong>页 每页<font color="green"><strong> 
                        <%=pgsize%> </strong></font>条记录 第<font color="green"><strong> 
                        <%=page%> </strong></font>页</td>
                      <td width="10%"><a href=lyb_manager.asp?page=1>第一页</a></td>
                      <td width="10%"> <%if page=1 then %> <font color=red>上一页</font> <%else %> <a href=lyb_manager.asp?page=<%=page-1%>>上一页</a> 
                        <%end if%> </td>
                      <td width="10%"> <%if page=pgnm then %> <font color=red>下一页</font> <%else %> <a href=lyb_manager.asp?page=<%=page+1%>>下一页</a> 
                        <%end if%> </td>
                      <td width="10%"><a href=lyb_manager.asp?page=<%=pgnm%>>最后一页</a></td>
                    </tr>
                  </table>
                  <%
					end sub
				%> 
                  <table width="95%" border="1" cellpadding="4" cellspacing="0" bordercolor="#CCCCCC" class="table-cell">
                    <tr bgcolor="#e0f0ff"> 
                      <td width="40" class="td_r">ID</td>
                      <td width="60" class="td_r">留言者</td>
                      <td class="td_r">留言</td>
                      <td class="td_r">回复</td>
                      <td width="110" class="td_r">留言时间</td>
                      <td width="80" align="center" bgcolor="#e0f0ff">操作</td>
                    </tr>
                    <%
					do while not rs.eof and count<pgsize
					%>
                    <tr> 
                      <td class="td_t_r"><%=rs("id")%></td>
                      <td class="td_t_r"><%=rs("user_id")%></td>
                      <td class="td_t_r"><%=rs("lyb_title")%>&nbsp;</td>
                      <td class="td_t_r"><%=rs("lyb_reply")%>&nbsp;</td>
                      <td class="td_t_r"><%=rs("lyb_date")%>&nbsp;</td>
                      <td class="td_t">[<a href="lyb_reply.asp?id=<%=rs("id")%>">回复</a>][<a href="lyb_dele.asp?id=<%=rs("id")%>">删除</a>]</td> 
                    </tr>
                    <%
					count=count+1
					rs.movenext
					loop
					rs.close
					set rs=nothing
					%>
                  </table>
                  <br/> <%call table_head()
				  %>
</div>
<br>
<div class="page-foot"><%=db_getvalue("setup_name='page_foot'","sys_setup","setup_value")%></div><br>
</body>
</html>
