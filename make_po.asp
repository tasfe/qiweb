<!--#include file="common.asp"-->
<%
if request.Form("action")<>"" then
	po_name=trim(delstr(request.form("user_name")))
	po_address=trim(delstr(request.form("user_address")))
	po_post=trim(delstr(request.form("user_post")))
	po_phone=trim(delstr(request.form("user_phone")))
	po_handphone=trim(DelStr(request.form("user_handphone")))
	po_email=trim(delstr(request.form("user_email")))
	po_remark=trim(delstr(request.Form("po_remark")))
	pd_id_list="" 
	For Each cookie in Request.Cookies("pd_buy") 
		if isnumeric(Request.Cookies("pd_buy")(cookie)) then
			if pd_id_list="" then
				pd_id_list=right(cookie,len(cookie)-1)
			else
				pd_id_list=pd_id_list & "," & right(cookie,len(cookie)-1)
			end if
		end if
	next
	if pd_id_list="" then
		err_msgbox "error!"
	end if
	if po_name="" then
		err_msgbox "error!"
	else
		'验证收货人姓名是不是三或四个中文字
		if not RegExpTest("^[\u0391-\uFFE5]{2,4}$",po_name) then
			err_msgbox "error!"
		end if
	end if
	if po_address="" then
		err_msgbox "error!"
	else
		if len(po_address)<6 then
			err_msgbox "error!"
		end if
	end if	
	if po_post="" then
		err_msgbox "error!"
	else
		if not RegExpTest("^[0-9]\d{5}$",po_post) then
			err_msgbox "error!"
		end if
	end if
	if po_phone<>"" then
		if not RegExpTest("^((\(\d{2,3}\))|(\d{3}\-))?(\(0\d{2,3}\)|0\d{2,3}-)?[1-9]\d{6,7}(\-\d{1,4})?$",po_phone) then
			err_msgbox "error!"
		end if
	end if
	if po_handphone<>"" then
		if not RegExpTest("^((\(\d{2,3}\))|(\d{3}\-))?1[3,5]?\d{9}$",po_handphone) then
			err_msgbox "error!"
		end if
	end if		
	if po_phone & po_handphone="" then
		err_msgbox "error!"
	end if	
	if po_email="" then
		err_msgbox "error!"
	else
		if not RegExpTest("^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$",po_email) then
			err_msgbox "error!"
		end if
	end if
	'开始生成订单
	po_no=create_code()
	po_date=now()
	input_label="PO_NO|+|PO_price|+|po_freight|+|po_accepter|+|po_address|+|po_post|+|po_phone|+|po_handphone|+|po_email|+|po_date|+|po_remark"
	input_value=PO_NO & "|+|" & PO_price & "|+|" & po_freight & "|+|" & po_name & "|+|" & po_address & "|+|" & po_post & "|+|" & po_phone & "|+|" & po_handphone & "|+|" & po_email & "|+|" & po_date & "|+|" & po_remark & "|+|"
	call db_save("add","po_basic",input_label,input_value,oper)
	'记录商品资料
	For Each cookie in Request.Cookies("pd_buy") 
		if isnumeric(Request.Cookies("pd_buy")(cookie)) then
			po_num=Request.Cookies("pd_buy")(cookie)
			pd_id=right(cookie,len(cookie)-1)
			po_id=po_no
			po_price=Request.Cookies("pd_price")(cookie)
			input_label="pd_id|+|po_id|+|po_num|+|po_price"
			input_value=pd_id & "|+|" & po_id & "|+|" & po_num & "|+|" & po_price & "|+|"
			call db_save("add","po_detail",input_label,input_value,oper)
		end if
	next
	'清空cookies
	For Each cookie in Request.Cookies("pd_buy") 
		'response.cookies("pd_buy")(cookie)=""
	next
	'发送生成订单电邮
	mm_to=po_email
	mm_subject="您在" & url_path & "的订单:" & po_no
	mm_title="我们收到你在网站下的订单!" 
	mm_title=mm_title & "<hr size='1'><table><tr><th>订单号：</th><td>" & po_no & "<td></tr><th>收货人：</th><td>" & po_name & "<td></tr></table>查到订单的详细情况!请尽快用支付宝给我们付款,我会收到支付宝的通知后会在24小时内将货发出!"
	mm_url=url_path & "po_view.asp?id=" & po_no
	call send_email(mm_to,mm_from,mm_cc,mm_subject,mm_body,mm_title,mm_url,mm_importance)
	response.Redirect "po_view.asp?id=" & po_no
end if
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
xml_temp_str=xml_temp_str & "		<payfor_style>" & db_getvalue("setup_name='payfor_style'","sys_setup","setup_value") & "</payfor_style>" & vbCRLF
xml_temp_str=xml_temp_str & "	</page_para>" & vbCRLF
'调出网页的内容 

xml_temp_str=xml_temp_str & "	<cur_page>0</cur_page>" & vbCRLF
xml_temp_str=xml_temp_str & "	<parent_page>0</parent_page>" & vbCRLF
xml_temp_str=xml_temp_str & "	<frame></frame>" & vbCRLF
xml_temp_str=xml_temp_str & "	<page_title>" & db_getvalue("id=" & language,"[language]","text_shop_comfirm") & "</page_title>" & vbCRLF
'--------------------------------------------------------------------------------------------------------
xml_temp_str=xml_temp_str & "	<user><page_content><![CDATA[" & pd_shop_car & "]]></page_content></user>" & vbCRLF
'--------------------------------------------------------------------------------------------------------
function pd_shop_car()
	dim rs,pd_id_list,total_price,pd_buy_num
	pd_shop_car=""
	pd_id_list="" 
	For Each cookie in Request.Cookies("pd_buy") 
		if isnumeric(Request.Cookies("pd_buy")(cookie)) then
			if pd_id_list="" then
				pd_id_list=right(cookie,len(cookie)-1)
			else
				pd_id_list=pd_id_list & "," & right(cookie,len(cookie)-1)
			end if
		end if
	next
	pd_shop_car=pd_shop_car & "<div class='article-title'>" & db_getvalue("id=" & language,"[language]","text_shop_comfirm") & "</div>" & vbCRLF
	'pd_shop_car=pd_shop_car & "<!--购物车中的商品信息-->" & vbCRLF
	pd_shop_car=pd_shop_car & "<div class='body-content'><table cellpadding='2' cellspacing='0' border='0' width='90%' class='all-border'>" & vbCRLF
	pd_shop_car=pd_shop_car & "<tr bgcolor='#e0e0e0'><th width='70'>ID</th><th>" & db_getvalue("id=" & language,"[language]","text_product_name") & "</th><th width='70'>" & db_getvalue("id=" & language,"[language]","text_product_price") & "</th><th width='50'>" & db_getvalue("id=" & language,"[language]","text_product_amount") & "</th><th width='70'>" & db_getvalue("id=" & language,"[language]","text_shop_totalprice") & "</th></tr>" & vbCRLF
	if pd_id_list<>"" then
		sql="select * from product where id in (" & pd_id_list & ") and [language]=" & language
		set rs=server.CreateObject("adodb.recordset")
		rs.open sql,conn,1,1
		total_price=0
		do while not rs.eof
			pd_buy_num=cint(request.cookies("pd_buy")("P" & rs("id")))
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
		pd_shop_car=pd_shop_car & "		<tr><td colspan='5' align='right'>" & db_getvalue("id=" & language,"[language]","text_shop_freight") & ":<font color=blue>" &  db_getvalue("id=" & language,"[language]","text_shop_noprice") & "</font></td></tr>" & vbCRLF
		pd_shop_car=pd_shop_car & "		<tr><td colspan='5' align='right'>Total:<font color=blue>" & formatnumber(total_price,2) & db_getvalue("id=" & language,"[language]","text_price_unit") & "</font></td></tr>" & vbCRLF
	else
		pd_shop_car=pd_shop_car & "<tr><td colspan='5' height='80' align='center'>" & db_getvalue("id=" & language,"[language]","text_shop_nobook") & "</td></tr>" & vbCRLF	
	end if
	pd_shop_car=pd_shop_car & "	</table>" & vbCRLF
	pd_shop_car=pd_shop_car & "	<form name='form2' id='shop_form' action='make_po.asp' method='post'>" & vbCRLF
	pd_shop_car=pd_shop_car & "	<table cellpadding='2' cellspacing='0' border='0' width='78%' class='all-border'>" & vbCRLF
	pd_shop_car=pd_shop_car & "	<tr><th colspan='2'>" & db_getvalue("id=" & language,"[language]","text_shop_comfirm") & "</th></tr>" & vbCRLF
	pd_shop_car=pd_shop_car & "	<tr><th>" & db_getvalue("id=" & language,"[language]","text_shop_username") & "</th><td><input type='text' name='user_name' value='' class='inpt-tx' style='width:100;'/></td></tr>"
	pd_shop_car=pd_shop_car & "	<tr><th>" & db_getvalue("id=" & language,"[language]","text_shop_address") & "</th><td><input type='text' name='user_address' value='' class='inpt-tx' style='width:300;'/></td></tr>"
	pd_shop_car=pd_shop_car & "	<tr><th>" & db_getvalue("id=" & language,"[language]","text_shop_userpost") & "</th><td><input type='text' name='user_post' value='' class='inpt-tx' style='width:100;'/></td></tr>"
	pd_shop_car=pd_shop_car & "	<tr><th>" & db_getvalue("id=" & language,"[language]","text_shop_userphone") & "</th><td><input type='text' name='user_phone' value='' class='inpt-tx' style='width:200;'/></td></tr>"
	pd_shop_car=pd_shop_car & "	<tr><th>" & db_getvalue("id=" & language,"[language]","text_shop_usermobi") & "</th><td><input type='text' name='user_handphone' value='' class='inpt-tx' style='width:200;'/></td></tr>"
	pd_shop_car=pd_shop_car & "	<tr><th>" & db_getvalue("id=" & language,"[language]","text_shop_useremail") & "</th><td><input type='text' name='user_email' value='' class='inpt-tx' style='width:250;'/></td></tr>"
	pd_shop_car=pd_shop_car & "	<tr><th>" & db_getvalue("id=" & language,"[language]","text_shop_otherinfo") & "</th><td><textarea name='po_remark' style='width:280;height:80;'></textarea></td></tr>"
	pd_shop_car=pd_shop_car & "	<tr><th></th><td><input type='button' name='reg' value='" & db_getvalue("id=" & language,"[language]","text_shop_step_pre") & "' onclick='window.location=""pd_car.asp?url=index.asp""'/>"
	pd_shop_car=pd_shop_car &"<input type='submit' name='action' value='" & db_getvalue("id=" & language,"[language]","text_shop_step_next") & "'/></td></tr>"
	pd_shop_car=pd_shop_car & "	</table>" & vbCRLF
	pd_shop_car=pd_shop_car & "	</form></div>" & vbCRLF
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