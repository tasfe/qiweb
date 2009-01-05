<!--#include file="common.asp"-->
<!--#include file="big_md5.asp"-->
<!--#include file="Alipay/Alipay_Payto.asp"-->
<%
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
xml_temp_str=xml_temp_str & "		<site_shop_open>" & db_getvalue("setup_name='site_shop_open'","sys_setup","setup_value") & "</site_shop_open>" & vbCRLF
xml_temp_str=xml_temp_str & "		<payfor_style>" & replace(db_getvalue("setup_name='payfor_style'","sys_setup","setup_value") & " "," ","") & "</payfor_style>" & vbCRLF
xml_temp_str=xml_temp_str & "	</page_para>" & vbCRLF
'调出网页的内容 

xml_temp_str=xml_temp_str & "	<cur_page>0</cur_page>" & vbCRLF
xml_temp_str=xml_temp_str & "	<parent_page>0</parent_page>" & vbCRLF
xml_temp_str=xml_temp_str & "	<frame></frame>" & vbCRLF
xml_temp_str=xml_temp_str & "	<page_title>" & db_getvalue("id=" & language,"[language]","text_shop_orderform") & "</page_title>" & vbCRLF
'--------------------------------------------------------------------------------------------------------
xml_temp_str=xml_temp_str & "	<user><page_content><![CDATA[" & pd_shop_car & "]]></page_content></user>" & vbCRLF
'--------------------------------------------------------------------------------------------------------
function pd_shop_car()
	dim rs,pd_id_list,total_price,pd_buy_num
	pd_shop_car=""
	po_no=ufomail_request("querystring","id")
	set rs=server.CreateObject("adodb.recordset")
	sql="select * from po_basic where PO_no='" & po_no & "'"
	rs.open sql,conn,1,1
	if not rs.eof then
		PO_NO=rs("PO_NO")
		PO_price=rs("PO_price")
		po_freight=rs("po_freight")
		po_accepter=rs("po_accepter")
		po_address=rs("po_address")
		po_post=rs("po_post")
		po_phone=rs("po_phone")
		po_handphone=rs("po_handphone")
		po_status=rs("po_status")
		po_email=rs("po_email")
		po_date=rs("po_date")
		po_remark=rs("po_remark")
		po_sendinfo=rs("po_sendinfo")
		temp_str=db_getvalue("id=" & language,"[language]","text_po_status")
		temp_str1="0||1||2||3||4||99"
		temp_str=split(temp_str,"||")
		temp_str1=split(temp_str1,"||")
		for i=0 to ubound(temp_str)
			if temp_str1(i)=cstr(po_status) then
				text_status=temp_str(i)
			end if
		next 
	else
		pd_shop_car="Error! this data not exist!"
		exit function
	end if
	rs.close
	pd_shop_car=pd_shop_car & "<div class='article-title'>" & db_getvalue("id=" & language,"[language]","text_shop_orderform") & "</div>" & vbCRLF
	'pd_shop_car=pd_shop_car & "<!--购物车中的商品信息-->" & vbCRLF
	pd_shop_car=pd_shop_car & "<div class='body-content'><table cellpadding='2' cellspacing='0' border='0' width='90%' class='all-border'>" & vbCRLF
	pd_shop_car=pd_shop_car & "<tr bgcolor='#e0e0e0'><th width='70'>ID</th><th>" & db_getvalue("id=" & language,"[language]","text_product_name") & "</th><th width='70'>" & db_getvalue("id=" & language,"[language]","text_product_price") & "</th><th width='50'>" & db_getvalue("id=" & language,"[language]","text_product_amount") & "</th><th width='70'>" & db_getvalue("id=" & language,"[language]","text_shop_totalprice") & "</th></tr>" & vbCRLF
	sql="select product.*,po_detail.po_id as po_id ,po_detail.po_num as po_num,po_detail.po_price from po_detail INNER JOIN product ON po_detail.pd_id = product.id where po_id='" & po_no & "'"
	rs.open sql,conn,1,1
	total_price=0
	do while not rs.eof
		pd_buy_num=cint(rs("po_num"))
		pd_shop_car=pd_shop_car & "	<tr>" & vbCRLF
		pd_shop_car=pd_shop_car & "		<td>" & rs("id") & "</td>" & vbCRLF
		pd_shop_car=pd_shop_car & "		<td><a href='index.asp?sitepage=" & rs("class") & "&contentid=" & rs("id") & "' target='_blank'>" & rs("title") & "</a></td>" & vbCRLF
		pd_shop_car=pd_shop_car & "		<td>" & rs("price") & db_getvalue("id=" & language,"[language]","text_price_unit") & "</td>" & vbCRLF
		pd_shop_car=pd_shop_car & "		<td>" & pd_buy_num & "</td>" & vbCRLF
		if rs("price")="" or isnull(rs("price")) or isempty(rs("price")) then
			pd_shop_car=pd_shop_car & "		<td>" & db_getvalue("id=" & language,"[language]","text_shop_noprice") & "</td>" & vbCRLF
		else
			pd_shop_car=pd_shop_car & "		<td>" & formatnumber(pd_buy_num * rs("price"),2) & db_getvalue("id=" & language,"[language]","text_price_unit") & "</td>" & vbCRLF
			total_price=total_price
		end if
		pd_shop_car=pd_shop_car & "	</tr>" & vbCRLF
	rs.movenext
	loop
	rs.close
	set rs=nothing
	pd_shop_car=pd_shop_car & "		<tr><td colspan='5' align='right'>" & db_getvalue("id=" & language,"[language]","text_shop_freight") & ":<font color=blue>" &  po_freight & db_getvalue("id=" & language,"[language]","text_price_unit") & "</font></td></tr>" & vbCRLF
	pd_shop_car=pd_shop_car & "		<tr><td colspan='5' align='right'>Total:<font color=blue>" & PO_price+po_freight & db_getvalue("id=" & language,"[language]","text_price_unit") & "</font></td></tr>" & vbCRLF
	pd_shop_car=pd_shop_car & "	</table><br/>" & vbCRLF
	pd_shop_car=pd_shop_car & "	<table cellpadding='2' cellspacing='0' border='0' width='78%' class='all-border'>" & vbCRLF
	pd_shop_car=pd_shop_car & "	<tr><th colspan='2'>" & db_getvalue("id=" & language,"[language]","text_shop_orderform") & "</th></tr>" & vbCRLF
	pd_shop_car=pd_shop_car & "	<tr><th>" & db_getvalue("id=" & language,"[language]","text_status") & "</th><td><font color=blue>" & text_status & "</font></td></tr>"
	pd_shop_car=pd_shop_car & "	<tr><th>" & db_getvalue("id=" & language,"[language]","text_shop_username") & "</th><td>" & po_accepter & "</td></tr>"
	pd_shop_car=pd_shop_car & "	<tr><th>" & db_getvalue("id=" & language,"[language]","text_shop_address") & "</th><td>" & po_address & "</td></tr>"
	pd_shop_car=pd_shop_car & "	<tr><th>" & db_getvalue("id=" & language,"[language]","text_shop_userpost") & "</th><td>" & po_post & "</td></tr>"
	pd_shop_car=pd_shop_car & "	<tr><th>" & db_getvalue("id=" & language,"[language]","text_shop_userphone") & "</th><td>" & po_phone & "</td></tr>"
	pd_shop_car=pd_shop_car & "	<tr><th>" & db_getvalue("id=" & language,"[language]","text_shop_usermobi") & "</th><td>" & po_handphone & "</td></tr>"
	pd_shop_car=pd_shop_car & "	<tr><th>" & db_getvalue("id=" & language,"[language]","text_shop_useremail") & "</th><td>" & po_email & "</td></tr>"
	pd_shop_car=pd_shop_car & "	<tr><th>" & db_getvalue("id=" & language,"[language]","text_shop_otherinfo") & "</th><td><pre>" & po_remark & "</pre></td></tr>"
	if po_status=1 then
		payfor_style =db_getvalue("setup_name='payfor_style'","sys_setup","setup_value")
		if instr(payfor_style,"0")<>0 then
			dim service,agent,partner,sign_type,subject,body,out_trade_no,price,discount,show_url,quantity,payment_type,logistics_type,logistics_fee,logistics_payment,logistics_type_1,logistics_fee_1,logistics_payment_1,seller_email,notify_url
			dim t1,t4,t5,key
			dim AlipayObj,itemUrl
				t1				=	"https://www.alipay.com/cooperate/gateway.do?"	'支付接口
				t4				=	url_path & "images/alipay_bwrx.gif"		'支付宝按钮图片
				t5				=	"推荐使用支付宝付款"						'按钮悬停说明
				
				service         =   "trade_create_by_buyer"
				partner			=	db_getvalue("setup_name='alipay_userid'","sys_setup","setup_value")  ' 2088002070937129		'partner合作伙伴ID(必须填)
				sign_type       =   "MD5"
				subject			=	po_no		'商品名称
				body			=	po_no			'body			商品描述 
				out_trade_no    =   po_no           '客户网站订单号，（现取系统时间，可改成网站自己的变量） 
				price		    =	formatnumber(PO_price,2)				'price商品单价			0.01～50000.00
				show_url        =   url_path & "po_view.asp?id=" & po_no        '商品展示地址（可以直接写网站首页网址）
				quantity        =   "1"               '商品数量
				payment_type    =   "1"                '支付类型，（1代表商品购买）
				'receive_name	=	po_accepter
				'receive_address	=	po_address	
				'receive_zip		=	po_post	
				'receive_phone	=	po_phone
				'receive_mobile	=	po_handphone
				'buyer_msg		=	po_remark
				logistics_type  =   "EXPRESS"
				logistics_fee   =   formatnumber(PO_freight,2)               '物流费用
				logistics_payment  =   "BUYER_PAY"    '物流费用承担(买家付)
				seller_email    =    db_getvalue("setup_name='alipay_username'","sys_setup","setup_value")   '(必须填)
				key             =    db_getvalue("setup_name='alipay_userkey'","sys_setup","setup_value")  '(必须填)
				notify_url=  url_path & "alipay/Alipay_Notify.asp" 
			    Set AlipayObj	= New creatAlipayItemURL
				itemUrl=AlipayObj.creatAlipayItemURL(t1,t4,t5,service,partner,sign_type,subject,body,out_trade_no,price,show_url,quantity,payment_type,logistics_type,logistics_fee,logistics_payment,seller_email,notify_url,receive_name,receive_address,receive_zip,receive_phone,receive_mobile,buyer_msg,key)
		pd_shop_car=pd_shop_car & "	<tr><td colspan='2'>" & db_getvalue("id=" & language,"[language]","text_shop_alipay")
		pd_shop_car=pd_shop_car & "<div id='payfor'>" & itemUrl & "</div></td></tr>"
		end if
		if instr(payfor_style,"1")<>0 then
		pd_shop_car=pd_shop_car & "	<tr><td colspan='2'>" & db_getvalue("id=" & language,"[language]","text_shop_paypal")
		pd_shop_car=pd_shop_car & "<div id='payfor'><form action='https://www.paypal.com/cgi-bin/webscr' method='post'>"
		pd_shop_car=pd_shop_car & "<input type='hidden' name='cmd' value='_xclick'>"
		pd_shop_car=pd_shop_car & "<input type='hidden' name='business' value='" & db_getvalue("setup_name='paypal_username'","sys_setup","setup_value") & "'>"
		pd_shop_car=pd_shop_car & "<input type='hidden' name='return' value='" & url_path & "paypal/receive.asp?action=success&id=" & po_no & "'>" 
		pd_shop_car=pd_shop_car & "<input type='hidden' name='quantity' value='1'>"
		pd_shop_car=pd_shop_car & "<input type='hidden' name='item_name' value='" & url_path & "po_view.asp?id=" & po_no & "'>"
		pd_shop_car=pd_shop_car & "<input type='hidden' name='item_number' value='" & po_no & "'>"
		pd_shop_car=pd_shop_car & "<input type='hidden' name='amount' value='" & PO_price & "'>"
		pd_shop_car=pd_shop_car & "<input type='hidden' name='shipping' value='" & po_freight & "'>"
		pd_shop_car=pd_shop_car & "<input type='hidden' name='custom' value='ufomail@163.com'>"
		pd_shop_car=pd_shop_car & "<input type='hidden' name='invoice' value='" & po_no & "'>"
		pd_shop_car=pd_shop_car & "<input type='hidden' name='charset' value='utf-8'>"
		pd_shop_car=pd_shop_car & "<input type='hidden' name='no_shipping' value='1'>"
		site_logo=db_getvalue("setup_name='site_logo'","sys_setup","setup_value")
		site_logo=file_show(site_logo)
		'pd_shop_car=pd_shop_car & "<input type='hidden' name='image_url' value='" & site_logo & "'>"
		pd_shop_car=pd_shop_car & "<input type='hidden' name='cancel_return' value='" & url_path & "paypal/receive.asp?action=cancel&id=" & po_no & "'>"
		pd_shop_car=pd_shop_car & "<input type='hidden' name='no_note' value='0'>"
		pd_shop_car=pd_shop_car & "<input type='hidden' name='currency_code' value='CNY'>"
		pd_shop_car=pd_shop_car & "<input type='image' src='paypal/x-click-but01.gif' name='submit' alt='Make payments with PayPal - it's fast, free and secure!'>"
		pd_shop_car=pd_shop_car & "</form></div>"
		pd_shop_car=pd_shop_car & "</td></tr>"
		end if
		if instr(payfor_style,"2")<>0 then
		pd_shop_car=pd_shop_car & "	<tr><td colspan='2'>" & db_getvalue("id=" & language,"[language]","text_shop_bill99")
		pd_shop_car=pd_shop_car & "<div id='payfor'><form name='frm' method='post' action='https://www.99bill.com/webapp/receiveMerchantInfoAction.do'>"
		pd_shop_car=pd_shop_car & "<input name='merchant_id' type='hidden' value='" & db_getvalue("setup_name='bill99_username'","sys_setup","setup_value") & "'/>"
		pd_shop_car=pd_shop_car & "<input name='orderid'  type='hidden' value='" & po_no & "'/>"
		pd_shop_car=pd_shop_car & "<input name='amount'  type='hidden' value='" & PO_price+po_freight & "'/>"
		pd_shop_car=pd_shop_car & "<input name='currency'  type='hidden' value='1'/>"
		pd_shop_car=pd_shop_car & "<input name='isSupportDES'  type='hidden' value='2'/>"
		merchant_url=url_path & "99bill/receive.asp"
		merchant_key=db_getvalue("setup_name='bill99_userkey'","sys_setup","setup_value")
		ScrtStr="merchant_id=" & db_getvalue("setup_name='bill99_username'","sys_setup","setup_value") & "&orderid=" & po_no & "&amount=" & PO_price+po_freight & "&merchant_url=" & merchant_url & "&merchant_key=" & merchant_key
		mac=ucase(md5(ScrtStr))
		pd_shop_car=pd_shop_car & "<input name='mac'  type='hidden' value='" & mac & "'/>"
		pd_shop_car=pd_shop_car & "<input name='merchant_url'  type='hidden'  value='" & url_path & "99bill/receive.asp'/>"
		pd_shop_car=pd_shop_car & "<input name='pname'  type='hidden' value='" & po_accepter & "'/>"
		pd_shop_car=pd_shop_car & "<input name='commodity_info'  type='hidden'  value='" & url_path & "po_view.asp?id=" & po_no & "'/>"
		pd_shop_car=pd_shop_car & "<input name='merchant_param' type='hidden'  value='ufomail@163.com'/>"
		pd_shop_car=pd_shop_car & "<input name='pemail' type='hidden'  value='" & po_email & "'/>"
		pd_shop_car=pd_shop_car & "<input name='pid' type='hidden'  value=''/>"
		pd_shop_car=pd_shop_car & "<input name='payby99bill'  type='image' src='99bill/button_99bill_tj1.gif'  value='快钱支付'/>"
		pd_shop_car=pd_shop_car & ""
		pd_shop_car=pd_shop_car & "</form></div></td></tr>"
		end if
		pd_shop_car=pd_shop_car & "	<tr><td colspan='2'>" & db_getvalue("id=" & language,"[language]","text_shop_bank") & "</td></tr>"
	end if
	pd_shop_car=pd_shop_car & "	</table>" & vbCRLF
	pd_shop_car=pd_shop_car & "	</div>" & vbCRLF
end function
'--------------------------------------------------------------------------------------------------------
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
end if
set xml = Server.CreateObject("Microsoft.XMLDOM")
set xsl = Server.CreateObject("Microsoft.XMLDOM")
xml.async = false
xsl.async = false
xml.loadxml xml_temp_str
'response.write "template/" &  site
'response.end
xsl.load  Server.MapPath("template/" &  site)
'xml.save Server.MapPath("default.xml")
response.write xml.transformNode(xsl)
Set xml = Nothing
Set xsl = Nothing
'call to_html("http://txmaimai.com/","default.htm")
'response.end
%>
<!--#include file="plug-in/plug-in.inc" -->