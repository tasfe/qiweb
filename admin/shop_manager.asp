<!--#include file="../common.asp"-->
<%
	check_admin
	show_language=db_getvalue("setup_name='show_language'","sys_setup","setup_value")
	site_shop_open=db_getvalue("setup_name='site_shop_open'","sys_setup","setup_value")
	payfor_style =db_getvalue("setup_name='payfor_style'","sys_setup","setup_value")
	if isnull(payfor_style)=false then
	payfor_style=replace(payfor_style," ","")
	end if
	alipay_username=db_getvalue("setup_name='alipay_username'","sys_setup","setup_value")
	alipay_userkey=db_getvalue("setup_name='alipay_userkey'","sys_setup","setup_value")
	alipay_userid=db_getvalue("setup_name='alipay_userid'","sys_setup","setup_value")
	paypal_username=db_getvalue("setup_name='paypal_username'","sys_setup","setup_value")
	bill99_username=db_getvalue("setup_name='bill99_username'","sys_setup","setup_value")
	bill99_userkey=db_getvalue("setup_name='bill99_userkey'","sys_setup","setup_value")
	if ufomail_request("Form","action")<>"" then
		call db_save("edit","sys_setup","setup_value|+|setup_name",ufomail_request("Form","site_shop_open") & "|+|site_shop_open","setup_name='site_shop_open'")
		call db_save("edit","sys_setup","setup_value|+|setup_name",ufomail_request("Form","payfor_style") & "|+|payfor_style","setup_name='payfor_style'")
		call db_save("edit","sys_setup","setup_value|+|setup_name",ufomail_request("Form","alipay_username") & "|+|alipay_username","setup_name='alipay_username'")
		call db_save("edit","sys_setup","setup_value|+|setup_name",ufomail_request("Form","alipay_userkey") & "|+|alipay_userkey","setup_name='alipay_userkey'")
		call db_save("edit","sys_setup","setup_value|+|setup_name",ufomail_request("Form","alipay_userid") & "|+|alipay_userid","setup_name='alipay_userid'")
		call db_save("edit","sys_setup","setup_value|+|setup_name",ufomail_request("Form","paypal_username") & "|+|paypal_username","setup_name='paypal_username'")
		call db_save("edit","sys_setup","setup_value|+|setup_name",ufomail_request("Form","bill99_username") & "|+|bill99_username","setup_name='bill99_username'")
		call db_save("edit","sys_setup","setup_value|+|setup_name",ufomail_request("Form","bill99_userkey") & "|+|bill99_userkey","setup_name='bill99_userkey'")
		response.redirect "shop_manager.asp"
	end if
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>网站商城参数设置</title>
<link href="../css.css" rel="stylesheet" type="text/css">
</head>

<body>

<!--功能标题-->
<div class="page-title">网站商城参数设置</div>
<%if return_info<>"" then%>
<div class="return-info"><%=return_info%></div>
<%end if%>
<div class="help-info">说明： <br>
  1、对网站商城的参数进行设置！<br>
  2、网站集成使用“<a href="https://www.alipay.com/trade/btool_index.htm" target="_blank">支付宝</a>”，“<a href="https://www.paypal.com/cn/" target="_blank">贝宝</a>”，“<a href="https://www.99bill.com/" target="_blank">快钱</a>”三种支付方式！你可以点击文字链接进入这些支付方式的网站了解详细的情况！<br>
  3、使用这三种网上支付方式的费用说明：“<a href="http://help.alipay.com/support/help_detail.htm?help_id=3303" target="_blank">支付宝</a>”，“<a href="https://www.paypal.com/cn/cgi-bin/webscr?cmd=_wp-standard-overview-outside" target="_blank">贝宝</a>”，“<a href="http://www.99bill.com/help/help20.html" target="_blank">快钱</a>”！<br>
  4、点击下面链接设置支付方式的说明文字 
  <div class="button">
  	<a href="user_language_setup.asp?name=text_shop_alipay">支付宝</a>
	<a href="user_language_setup.asp?name=text_shop_paypal">贝宝</a>
	<a href="user_language_setup.asp?name=text_shop_bill99">快钱</a>
	<a href="user_language_setup.asp?name=text_shop_bank">银行汇款</a>
  </div>
</div>
<div class="oper-content"> 
  <form name="form1" method="post" action="">
    <div class="row">
	1、是否开启网上商城？开启后产品展示页面将会出现“订购”按钮。
      <select name="site_shop_open" id="site_shop_open" onChange="javascript:if(this.options[this.selectedIndex].value==0)shop_setup.style.display='none';else shop_setup.style.display='';">
        <option value="0" <%if site_shop_open="0" then response.write " selected='selected'"%>>不启用</option>
        <option value="1" <%if site_shop_open="1" then response.write " selected='selected'"%>>启用</option>
      </select>
    </div>
	<div id="shop_setup" <%if site_shop_open="0" then response.write " style='display:none;'"%>> 
      2、使用那一种支付方式，可以同时选择多种支付方式？<br>
	<select name="payfor_style" size="5" multiple onChange="change()">
	  <%
	  '0\支付宝;1\贝宝;2\快钱;
		temp_str="支付宝;贝宝;快钱"
		temp_str1="0;1;2"
		temp_str=split(temp_str,";")
		temp_str1=split(temp_str1,";")
		for i=0 to ubound(temp_str)
			if instr("," & payfor_style & ",", "," & temp_str1(i) & ",")>0 then
				response.write "<option value='" & temp_str1(i) & "' selected>" & temp_str(i) & "</option>"
			else
				response.write "<option value='" & temp_str1(i) & "'>" & temp_str(i) & "</option>"
			end if
		next
	%>
      </select>
      按着Ctrl进行选择或取消。<br>
    3、支付方式的参数设置： 
	<div id="alipay_setup" style="<%if instr("," & payfor_style & ",", ",0,")=0 then response.write "display:none;"%>width:300px;background:#f2f8ff;padding:2px;margin:6px;border:1px dotted #ccc;">
		<li>支付宝账号：<input name="alipay_username" type="text" id="alipay_username" value="<%=alipay_username%>" size="20"></li>
		<li>客户号：<input name="alipay_userid" type="text" id="alipay_userid" value="<%=alipay_userid%>" size="20"></li>
		<li>授权码：<input name="alipay_userkey" type="text" id="alipay_userkey" value="<%=alipay_userkey%>" size="20"></li>
	</div>
	<div id="paypal_setup" style="<%if instr("," & payfor_style & ",", ",1,")=0 then response.write "display:none;"%>width:300px;background:#f2f8ff;padding:2px;margin:6px;border:1px dotted #ccc;">
		<li>贝宝账号：<input name="paypal_username" type="text" id="paypal_username" value="<%=paypal_username%>" size="20"></li>
	</div>
	<div id="bill99_setup" style="<%if instr("," & payfor_style & ",", ",2,")=0 then response.write "display:none;"%>width:300px;background:#f2f8ff;padding:2px;margin:6px;border:1px dotted #ccc;">
		<li>快钱账号：<input name="bill99_username" type="text" id="bill99_username" value="<%=bill99_username%>" size="20"></li>
		<li>授权码：<input name="bill99_userkey" type="text" id="bill99_userkey" value="<%=bill99_userkey%>" size="20"></li>
	</div>
    </div>
    <hr size="1"/>
	<script language="JavaScript">
	function change()
	{
		var sobject=window.event.srcElement;
		if (sobject.options[0].selected)
			alipay_setup.style.display="";
		else
			alipay_setup.style.display="none";
		if (sobject.options[1].selected)
			paypal_setup.style.display="";
		else
			paypal_setup.style.display="none";
		if (sobject.options[2].selected)
			bill99_setup.style.display="";
		else
			bill99_setup.style.display="none";
	}
	</script>
    <input type="submit" name="action" value="保存设置">
  </form>
</div>
<br>
<br>
<br>
<div class="page-foot"><%=db_getvalue("setup_name='page_foot'","sys_setup","setup_value")%></div><br>
</body>
</html>
