<!--#include file="../common.asp"-->
<%
check_admin
po_no=request.querystring("id")
set rs=server.createobject("adodb.recordset")
sql="select * from po_basic where po_no='" & po_no & "'"
rs.open sql,conn,1,1
if rs.eof then
	err_msgbox "数据不存在!"
end if
PO_NO=rs("PO_NO")
Po_price=rs("PO_price")
po_freight=rs("po_freight")
po_accepter=rs("po_accepter")
po_address=rs("po_address")
po_post=rs("po_post")
po_phone=rs("po_phone")
po_status=rs("po_status")
po_email=rs("po_email")
po_date=rs("po_date")
po_remark=rs("po_remark")
po_sendinfo=rs("po_sendinfo")
po_handphone=rs("po_handphone")
rs.close
if ufomail_request("form","action")<>"" then
	PO_NO=ufomail_request("form","PO_NO")
	po_remark=ufomail_request("form","po_remark")
	po_price=ufomail_request("form","po_price")
	po_freight=ufomail_request("form","po_freight")
	po_sendinfo=ufomail_request("form","po_sendinfo")
	po_status=ufomail_request("form","po_status")
	input_label="po_remark|+|PO_price|+|po_freight|+|po_sendinfo|+|po_status"
	input_value=po_remark & "|+|" & po_price & "|+|" & po_freight & "|+|" & po_sendinfo & "|+|" & po_status
	call db_save("edit","po_basic",input_label,input_value,"PO_NO='" & PO_NO & "'")
	response.redirect "po_view.asp?id=" & po_no
end if
set rs=nothing
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
  1、本系统使用的支付方式是当买家在网上下了订单后，并不会立即提供地址给买家付款的，因为涉及到运费和一些相关附加费的问题。所以下了订单后，订单的状态为“报价中”<br>
  2、在“报价中”这个状态中可以修改商品的总价格和运费。还可以在其它信息中输入一些和买家沟通的信息，比如新的买家地址等等；<br>
  3、提供报价后，可以用EMAIL或是一些通讯工具，把订单地址发给买家，通知买家打开地址尽快付款！<br>
  4、买家付款后，订单状况会变为已付款。或是买家用银行转账的方式，也可以自行修改状态为：已付款<br>
  5、在此“已付款”状态下，输入发货情况，并把状态修改为“已发货”可以通知买家商品已发。<br>
  6、在“已发货”状态下，使用支付宝付款的话会由买家确认收到货后，自动把状态修改为“交易成功”<br>
  7、当买家使用其它支付方式付款的话，需要自行将状态改为“交易成功”<br>
  8、无效的订单，请将状态改为“已取消”<br>
</div>
<div class="oper-content"> 
<form action="" method="post">
  <table width="95%" border="0" cellpadding="4" cellspacing="0" class="all_border_h">
    <tr> 
      <td class="tdh_r_b">订单号:</td>
      <td class="tdh_b">
        <%=PO_NO%>(地址：<font color="red"><%=url_path%>po_view.asp?id=<%=PO_NO%></font>)
		<input type="hidden" name="po_no" value="<%=PO_NO%>"/>
          &nbsp; (<a href="po_dele.asp?id=<%=PO_NO%>">删除此订单</a>)</td>
    </tr>
    <tr> 
      <td class="tdh_r_b">创建日期:</td>
      <td class="tdh_b">
        <%=po_date%>
        &nbsp;</td>
    </tr>
    <tr> 
      <td class="tdh_r_b">订单状况:</td>
      <td class="tdh_b">
			  <select name="po_status" id="po_status">
				<%
				temp_str="0、报价中||1、未付款||2、已付款||3、已发货||4、交易完成||99、已取消"
				temp_str1="0||1||2||3||4||99"
				temp_str=split(temp_str,"||")
				temp_str1=split(temp_str1,"||")
				for i=0 to ubound(temp_str)
					if temp_str1(i)=cstr(po_status) then
						response.write "<option value='" & temp_str1(i) & "' selected>" & temp_str(i) & "</option>"
					else
						response.write "<option value='" & temp_str1(i) & "'>" & temp_str(i) & "</option>"
					end if
				next 
				%>
			  </select>
        &nbsp;</td>
    </tr>
    <tr> 
      <td class="tdh_r_b">收件人姓名:</td>
      <td class="tdh_b">
        <%=po_accepter%>
        &nbsp;</td>
    </tr>
    <tr> 
      <td class="tdh_r_b">收件人地址:</td>
      <td class="tdh_b">
        <%=po_address%>
        &nbsp;</td>
    </tr>
    <tr> 
      <td height="25" class="tdh_r_b">邮政编码:</td>
      <td class="tdh_b">
        <%=po_post%>
        &nbsp;</td>
    </tr>
    <tr> 
      <td class="tdh_r_b">电话号码:</td>
      <td class="tdh_b">
        <%=po_phone%>
        &nbsp;</td>
    </tr>
	<tr> 
      <td class="tdh_r_b">手机号码:</td>
      <td class="tdh_b">
        <%=po_handphone%>
        &nbsp;</td>
    </tr>
    <tr> 
      <td class="tdh_r_b">电邮账号:</td>
      <td class="tdh_b">
        <%=po_email%>
        &nbsp;</td>
    </tr>
    <tr> 
      <td class="tdh_r_b">其它信息:</td>
      <td class="tdh_b">
        <textarea name="po_remark" style="width:400px;height:80px;"><%=po_remark%></textarea>
        &nbsp;</td>
    </tr>
    <tr> 
      <td colspan="2" class="tdh_b"><table width="100%" border="0" cellpadding="2" cellspacing="0" class="all_border_h">
          <tr bgcolor="#eeeeee"> 
            <td class="tdh_r">序号</td>
            <td class="tdh_r">产品编号</td>
            <td class="tdh_r">产品名称</td>
            <td class="tdh_r">订购数量</td>
            <td>价格</td>
          </tr>
          <%
						  set rs=server.createobject("adodb.recordset")
						  sql="select product.*,po_detail.po_id as po_id ,po_detail.po_num as po_num,po_detail.po_price from po_detail INNER JOIN product ON po_detail.pd_id = product.id where po_id='" & po_no & "'"
						  rs.open sql,conn,1,1
						  i=0
						  do while not rs.eof 
						  i=i+1
						  %>
          <tr> 
            <td class="tdh_t_r">
              <%=i%>
              &nbsp;</td>
            <td class="tdh_t_r"><a href="product_view.asp?id=<%=rs("id")%>" target="_blank">
              <%=rs("id")%>
              </a>&nbsp;</td>
            <td class="tdh_t_r">
              <%=rs("title")%>
              &nbsp;</td>
            <td class="tdh_t_r">
              <%=rs("po_num")%>
              &nbsp;</td>
            <td class="tdh_t">
              <%Pd_price=rs("po_price")
			  if isnull(pd_price) then pd_price=0
			  response.write formatnumber(pd_price,2)%>
              &nbsp;</td>
          </tr>
          <%
						  rs.movenext
						  loop
						  rs.close
						  set rs=nothing%>
        </table></td>
    </tr>
    <tr> 
      <td class="tdh_r_b">商品总价格:</td>
      <td class="tdh_b">
        <input name="po_price" value="<%=PO_price%>" id="po_price" onBlur="javascript:po_total.value= parseFloat(po_freight.value)+ parseFloat(po_price.value)"/>
        元&nbsp;</td>
    </tr>
    <tr> 
      <td class="tdh_r_b">商品运费:</td>
      <td class="tdh_b">
        <input value="<%=po_freight%>" name="po_freight" id="po_freight" onBlur="javascript:po_total.value= parseFloat(po_freight.value)+ parseFloat(po_price.value)"/>
        元&nbsp;</td>
    </tr>
    <tr> 
      <td class="tdh_r_b">总价:</td>
      <td class="tdh_b">
        <input value="<%=po_freight+PO_price%>" id="po_total" name="po_total" class="non-border" style="color:red;font-weight:bold;"/>
        元&nbsp;</td>
    </tr>
	<tr> 
      <td class="tdh_r_b">发货情况:</td>
      <td class="tdh_b">
        <textarea name="po_sendinfo" style="width:400px;height:80px;"><%=po_sendinfo%></textarea>
        &nbsp;</td>
    </tr>
  </table>
    <br>
    <input type="submit" name="action" value="Submit">
    <input type="reset" name="Submit2" value="Reset">
  </form>
</div>
<br>
<br>
<br>
<div class="page-foot"><%=db_getvalue("setup_name='page_foot'","sys_setup","setup_value")%></div><br>
</body>
</html>

