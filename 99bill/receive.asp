<!--#include file="../common.asp"-->
<!--#include file="../big_md5.asp"-->
<%
'''''''''
 ' @Description: 快钱网关接口范例
 ' @Copyright (c) 上海快钱信息服务有限公司
 ' @version 2.0
'''''''''
	merchant_key =db_getvalue("setup_name='bill99_userkey'","sys_setup","setup_value")		'''商户密钥

	merchant_id = request("merchant_id")			'''获取商户编号
	orderid =  request("orderid")		'''获取订单编号
	amount =  request("amount")	'''获取订单金额
	dealdate =  request("date")		'''获取交易日期
	succeed =  request("succeed")	'''获取交易结果,Y成功,N失败
	mac =  request("mac")		'''获取安全加密串
	merchant_param =  request("merchant_param")		'''获取商户私有参数

	couponid = request("couponid")		'''获取优惠券编码
	couponvalue = request("couponvalue") 		'''获取优惠券面额

	'''生成加密串,注意顺序
	ScrtStr = "merchant_id=" & merchant_id & "&orderid=" & orderid & "&amount=" & amount & "&date=" & dealdate & "&succeed=" & succeed & "&merchant_key=" & merchant_key
	mymac=md5(ScrtStr) 
		

	 v_result="失败"
	if ucase(mac)=ucase(mymac)   then 
			
			if succeed="Y"   then		'''支付成功
				
				v_result="成功"
				'''
				'''#商户网站逻辑处理#
				'''  
				'检查定单状态 
				order_no=orderid
				sql="update po_basic set po_status=2 where PO_NO='"&trim(order_no)&"'"
				conn.execute sql
				
			else		'''支付失败  
				response.write "<a href='" & url_path & "po_view.asp?id=" & orderid & "'>支付不成功!请返回!</a>"
				response.end
			end if

	else		'''签名错误

	end if
	

%>
<!doctype html public "-//w3c//dtd html 4.0 transitional//en" >
<html>
	<head>
		<title>快钱99bill</title>
		<meta http-equiv="content-type" content="text/html; charset=gb2312" />
	</head>
	
	<body>
		
		<div align="center">
		<table width="259" border="0" cellpadding="1" cellspacing="1" bgcolor="#CCCCCC" >
			<tr bgcolor="#FFFFFF">
				<td width="68">订单编号:</td>
			  <td width="182"><%=orderid%></td>
			</tr>
			<tr bgcolor="#FFFFFF">
				<td>订单金额:</td>
			  <td><%=amount%></td>
			</tr>
			<tr bgcolor="#FFFFFF">
				<td>支付结果:</td>
			  <td><%=v_result%></td>
			</tr>
	  </table>
	</div>

	</body>
</html>