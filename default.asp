<!--#include file="common.asp"-->
<%
response.Buffer=true
'判断要不要打开展示页
homepage_open=db_getvalue("setup_name='homepage_open'","sys_setup","setup_value")
if homepage_open="1" then
	response.redirect "index.asp"
	response.end
end if
xml_temp_str=""
''写出页头
xml_temp_str=xml_temp_str & "<?xml version='1.0' encoding='utf-8'?>" & vbCRLF
''写出XSL样式表 
homepage=db_getvalue("setup_name='homepage'","sys_setup","setup_value")
if homepage_open="0" and homepage<>"" then
	homepage=get_left(homepage,".") & ".xsl"
else
	homepage="default.xsl"
end if

xml_temp_str=xml_temp_str & "<?xml-stylesheet type='text/xsl' href='template/homepage/" & homepage & "'?>" & vbCRLF
''页面内容 
xml_temp_str=xml_temp_str & "<page>" & vbCRLF
''显示网站的meta:
xml_temp_str=xml_temp_str & "	<page_meta><![CDATA[" & db_getvalue("setup_name='page_head'","sys_setup","setup_value") & "]]></page_meta>" & vbCRLF
''显示多少种语言:
show_language=db_getvalue("setup_name='show_language'","sys_setup","setup_value")
xml_temp_str=xml_temp_str & "	<show_language>" & show_language & "</show_language>" & vbCRLF
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
xml_temp_str=xml_temp_str & "	<homepage_name><![CDATA[" & db_getvalue("ID=" & language,"[language]","homepage_name") & "]]></homepage_name>" & vbCRLF
'下面是公用语言包
%>
<!--#include file="public_language.inc"-->
<%
xml_temp_str=xml_temp_str & "</page>"
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
liulanqi=request.ServerVariables("HTTP_User-Agent")
file_content=""
if Instr(liulanqi,"Mozilla")<>0 and ufomail_request("querystring","viewer")<>"wap" then
	xls_use="catalog_html.xsl"
	xsl.load  Server.MapPath("template/homepage/" & homepage)
else
	xsl.load  Server.MapPath("template/homepage/wap.xsl")
	Response.ContentType = "text/vnd.wap.wml"
	response.Write "<?xml version='1.0' encoding='utf-8'?>" 
	response.Write "<!DOCTYPE wml PUBLIC '-//WAPFORUM//DTD WML 1.1//EN' 'http://www.wapforum.org/DTD/wml_1.1.xml'>" 
	response.Write xml.transformNode(xsl)
	response.end
end if
if homepage_open="2" and homepage<>"" then
	file_path=root_path & "\template\homepage\user.htm"
	Set objStream = Server.CreateObject("ADODB.Stream")
    With objStream
        .Type = 2
        .Mode = 3
        .Open
        .LoadFromFile file_path
        .Charset = "utf-8"
        .Position = 2
        file_content = .ReadText
        .Close
    End With
    Set objStream = Nothing
else
	file_content=xml.transformNode(xsl)
end if
html_url=save_to_html(file_content,"default.htm")
Set xml = Nothing
Set xsl = Nothing
'call to_html("http://txmaimai.com/","default.htm")
'response.end

response.redirect(html_url)
%>