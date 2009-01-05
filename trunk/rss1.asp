<!--#include file="common.asp"-->
<%
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''生成ASP文件的sitemap文件;并产生副本:sitemap.xml
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
xml_temp_str=""
''写出页头
set rs=server.createobject("adodb.recordset")
xml_temp_str=xml_temp_str & "<?xml version='1.0' encoding='UTF-8'?>" & vbCRLF
''页面内容 
xml_temp_str=xml_temp_str & "<rdf:RDF xmlns:rdf='http://www.w3.org/1999/02/22-rdf-syntax-ns#' xmlns:dc='http://purl.org/dc/elements/1.1/' xmlns:sy='http://purl.org/rss/1.0/modules/syndication/' xmlns:admin='http://webns.net/mvcb/' xmlns='http://purl.org/rss/1.0/'>" & vbCRLF
xml_temp_str=xml_temp_str & "<channel rdf:about='" & url_path & "'>" & vbCRLF
'首页
language=request.cookies("language")
if isempty(language) then 
	default_language=db_getvalue("setup_name='default_language'","sys_setup","setup_value")
	language=cint(default_language)
end if 
xml_temp_str=xml_temp_str & "<title>" & db_getvalue("ID=" & language,"[language]","homepage_name") & "</title>" & vbCRLF
xml_temp_str=xml_temp_str & "<link>" & url_path & "</link>" & vbCRLF
xml_temp_str=xml_temp_str & "<description><![CDATA[" & db_getvalue("ID=" & language,"[language]","site_name") & "]]></description>" & vbCRLF
xml_temp_str=xml_temp_str & "<dc:language>zh-cn</dc:language>" & vbCRLF
xml_temp_str=xml_temp_str & "<dc:creator>QiWeb Maker(http://qiweb.cn)</dc:creator>" & vbCRLF
xml_temp_str=xml_temp_str & "</channel>" & vbCRLF
'call nav()
sub nav()
'网站各栏目
sql="select * from sitemap"
rs.open sql,conn,1,1
do while not rs.eof 
xml_temp_str=xml_temp_str & "<item>" & vbCRLF
xml_temp_str=xml_temp_str & "	<title><![CDATA[" & rs("title") & "]]></title>" & vbCRLF
xml_temp_str=xml_temp_str & "	<link>" & url_path & "index.asp?sitepage=" & rs("id") & "</link>" & vbCRLF
xml_temp_str=xml_temp_str & "	<description><![CDATA[" & rs("title") & "]]></description>" & vbCRLF
xml_temp_str=xml_temp_str & "</item>" & vbCRLF
rs.movenext
loop
rs.close
end sub
'各栏目中的内容
table_list="article,product,album,software,movie"
table_name=split(table_list,",")
for i=0 to ubound(table_name)
	sql="select top 20 id,title,content,class from " & table_name(i) & " order by create_date desc"
	rs.open sql,conn,1,1
	do while not rs.eof 
	xml_temp_str=xml_temp_str & "<item>" & vbCRLF
	xml_temp_str=xml_temp_str & "	<title><![CDATA[" & rs("title") & "]]></title>" & vbCRLF
	xml_temp_str=xml_temp_str & "	<link>" & url_path & "index.asp?sitepage=" & rs("class") & "&amp;contentid=" & rs("id") & "</link>" & vbCRLF
	content=rs("content")
	text=get_text_desc(content,400)
	xml_temp_str=xml_temp_str & "	<description><![CDATA[" & text & "]]></description>" & vbCRLF
	xml_temp_str=xml_temp_str & "</item>" & vbCRLF
	rs.movenext
	loop
	rs.close
next
xml_temp_str=xml_temp_str & "</rdf:RDF>"
set rs=nothing
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'set xml = Server.CreateObject("Microsoft.XMLDOM")
'xml.async = false
'xml.loadxml xml_temp_str
'xml.save Server.MapPath("rss1.xml")
'Set xml = Nothing
Response.ContentType="text/xml"
response.write xml_temp_str
response.end
%>
