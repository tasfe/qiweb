<!--#include file="common.asp"-->
<%
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''生成《天下买卖网商品》格式的XML文件
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
xml_temp_str=""
''写出页头
set rs=server.createobject("adodb.recordset")
xml_temp_str=xml_temp_str & "<?xml version='1.0' encoding='UTF-8'?>" & vbCRLF
''页面内容 
xml_temp_str=xml_temp_str & "<document>" & vbCRLF
'首页
language=request.cookies("language")
if isempty(language) then 
	default_language=db_getvalue("setup_name='default_language'","sys_setup","setup_value")
	language=cint(default_language)
end if 

xml_temp_str=xml_temp_str & "<webSite>" & url_path & "</webSite>" & vbCRLF
xml_temp_str=xml_temp_str & "<webMaster>" & db_getvalue("setup_name='user_name'","sys_setup","setup_value") & "</webMaster>" & vbCRLF
xml_temp_str=xml_temp_str & "<shop_logo>" & db_getvalue("setup_name='shop_logo'","sys_setup","setup_value") & "</shop_logo>"
xml_temp_str=xml_temp_str & "<shop_desc>" & db_getvalue("setup_name='shop_desc'","sys_setup","setup_value") & "</shop_desc>"
xml_temp_str=xml_temp_str & "<product_num>" & db_getvalue("setup_name='product_num'","sys_setup","setup_value") & "</product_num>"
xml_temp_str=xml_temp_str & "<shop_carry>" & db_getvalue("setup_name='shop_carry'","sys_setup","setup_value") & "</shop_carry>"
xml_temp_str=xml_temp_str & "<shop_freight>" & db_getvalue("setup_name='shop_freight'","sys_setup","setup_value") & "</shop_freight>"
'打开推荐产品

shop_product=db_getvalue("setup_name='shop_product'","sys_setup","setup_value")
sql="select * from product where id in (" & shop_product & ") and [language]=" & language & " order by create_date desc"
rs.open sql,conn,1,1
do while not rs.eof
xml_temp_str=xml_temp_str & "<show_product>"
xml_temp_str=xml_temp_str & "	<content_id>" & rs("id") & "</content_id>" & vbCRLF
xml_temp_str=xml_temp_str & "	<title><![CDATA[" & rs("title") & "]]></title>" & vbCRLF
xml_temp_str=xml_temp_str & "	<link>" & url_path & "index.asp?sitepage=" & rs("class") & "&amp;contentid=" & rs("id") & "</link>" & vbCRLF
xml_temp_str=xml_temp_str & "	<content><![CDATA[" & rs("content") & "]]></content>" & vbCRLF
xml_temp_str=xml_temp_str & "	<pic><![CDATA[" & file_show(rs("pic")) & "]]></pic>" & vbCRLF
xml_temp_str=xml_temp_str & "	<price>" & rs("price") & "</price>" & vbCRLF
xml_temp_str=xml_temp_str & "	<num>" & rs("num") & "</num>" & vbCRLF
xml_temp_str=xml_temp_str & "</show_product>"
rs.movenext
loop
rs.close

'各栏目中的内容
sql="select * from product where content<>'' and [language]=" & language & " order by create_date desc"
rs.open sql,conn,1,1
do while not rs.eof 
xml_temp_str=xml_temp_str & "<product>" & vbCRLF
xml_temp_str=xml_temp_str & "			<content_id>" & rs("id") & "</content_id>" & vbCRLF
xml_temp_str=xml_temp_str & "			<title><![CDATA[" & rs("title") & "]]></title>" & vbCRLF
xml_temp_str=xml_temp_str & "		<keyword><![CDATA[" & add_link(rs("keyword")) & "]]></keyword>" & vbCRLF
if ufo=1 then
xml_temp_str=xml_temp_str & "			<content><![CDATA[" & rs("content") & "]]></content>" & vbCRLF
end if
xml_temp_str=xml_temp_str & "			<create_date>" & rs("create_date") & "</create_date>" & vbCRLF
xml_temp_str=xml_temp_str & "			<price>" & rs("price") & "</price>" & vbCRLF
xml_temp_str=xml_temp_str & "			<num>" & rs("num") & "</num>" & vbCRLF
xml_temp_str=xml_temp_str & "			<pic><![CDATA[" & file_show(rs("pic")) & "]]></pic>" & vbCRLF
xml_temp_str=xml_temp_str & "			<picture><![CDATA[" & file_show(rs("picture")) & "]]></picture>" & vbCRLF
xml_temp_str=xml_temp_str & "			<pictures><![CDATA[" 
call uploadfile_list(rs("pictures"),"pictures",2) 
xml_temp_str=xml_temp_str & "]]></pictures>" & vbCRLF
xml_temp_str=xml_temp_str & "</product>" & vbCRLF
rs.movenext
loop
rs.close
xml_temp_str=xml_temp_str & "</document>"
set rs=nothing

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'set xml = Server.CreateObject("Microsoft.XMLDOM")
'xml.async = false
'xml.loadxml xml_temp_str
'xml.save Server.MapPath("news.xml")
'Set xml = Nothing
Response.ContentType="text/xml"
response.write xml_temp_str
response.end
%>