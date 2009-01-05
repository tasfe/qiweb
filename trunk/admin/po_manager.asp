<!--#include file="../common.asp"-->
<%
	check_admin
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>订单管理</title>
<link href="../css.css" rel="stylesheet" type="text/css">
</head>

<body>

<!--功能标题-->
<div class="page-title">订单管理</div>
<%if return_info<>"" then%>
<div class="return-info"><%=return_info%></div>
<%end if%>
<div class="help-info">说明： <br>
  1、管理网站的订单<br>
  <form name="form1" method="post" action="po_manager.asp">
       快速查找：在此输入订单编号,或下单者ID 
          <input type="text" name="keyword"> <input type="submit" name="Submit" value="查找"> 
      </form>
	  
  </div>
<div class="oper-content"> 
<%set rs=server.createobject("adodb.recordset")
				  	if request.Form("keyword")<>"" then
						sql="select * from po_basic where po_no like '%" & request.Form("keyword") & "%' or po_accepter like '%" & request.Form("keyword") & "%'"
					else
						sql="select * from po_basic order by po_status,po_date desc"
					end if 
					pgsize=50
					page=request.querystring("page")
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
					%> <table width="95%" border="0" cellpadding="3" cellspacing="0" bgcolor="#E2F4FF" class="all_border" >
          <tr> 
            <td width="60%">共有:<strong><font color=green> <%=pgnm%> </font></strong>页 每页<font color="green"><strong> <%=pgsize%> </strong></font>条记录 第<font color="green"><strong> <%=page%> </strong></font>页</td>
            <td width="10%"><a href=po_manager.asp?page=1>第一页</a></td>
            <td width="10%"> <%if page=1 then %> <font color=red>上一页</font> <%else %> <a href=po_manager.asp?page=<%=page-1%>>上一页</a> 
              <%end if%> </td>
            <td width="10%"> <%if page=pgnm then %> <font color=red>下一页</font> <%else %> <a href=po_manager.asp?page=<%=page+1%>>下一页</a> 
              <%end if%> </td>
            <td width="10%"><a href=po_manager.asp?page=<%=pgnm%>>最后一页</a></td>
          </tr>
        </table>
        <%
					end sub
				%> <table width="95%" border="0" cellpadding="2" cellspacing="0" class="all_border" ID="PowerTable">
          <tr bgcolor="#E2F4FF"> 
            <td class="td_r">订单编号</td>
            <td class="td_r">收货人</td>
            <td class="td_r">运费</td>
            <td class="td_r">总价格</td>
            <td class="td_r">交易日期</td>
            <td>订单状况</td>
          </tr>
          <%
		
		do while not rs.eof and count<pgsize
			response.write "<tr><td class='td_t_r'><a href='po_view.asp?id=" & rs("po_no") & "'>" & rs("po_no") & "</a></td>"
			response.write "<td class='td_t_r'>" & rs("po_accepter") & "</td>"
			response.write "<td class='td_t_r'>" & rs("po_freight") & "</td>"
			response.write "<td class='td_t_r'>" & rs("po_price") & "</td>"
			response.write "<td class='td_t_r'>" & rs("po_date") & "</td>"
			response.write "<td class='td_t'>"
			select case rs("po_status")
				case 0
					response.write "报价中"
				case 1
					response.write "未付款"
				case 2
					response.write "已付款"
				case 3
					response.write "已发货"
				case 4
					response.write "交易完成"
				case 99
					response.write "已取消"
			end select
			response.write "</td></tr>"
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
<br>
<br>
<div class="page-foot"><%=db_getvalue("setup_name='page_foot'","sys_setup","setup_value")%></div><br>
</body>
</html>
