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
xml_temp_str=xml_temp_str & "<urlset xmlns='http://www.google.com/schemas/sitemap/0.84' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xsi:schemaLocation='http://www.google.com/schemas/sitemap/0.84 http://www.google.com/schemas/sitemap/0.84/sitemap.xsd'> " & vbCRLF
'首页
mod_date=year(date()) & "-" & right("0" & month(date()),2) & "-" & right("0" & day(date()),2)
function date_format(in_date)
	date_format=year(in_date) & "-" & right("0" & month(in_date),2) & "-" & right("0" & day(in_date),2)
end function
xml_temp_str=xml_temp_str & "<url>" & vbCRLF
xml_temp_str=xml_temp_str & "<loc>" & url_path & "</loc>" & vbCRLF
xml_temp_str=xml_temp_str & "<lastmod>" & mod_date & "</lastmod>" & vbCRLF
xml_temp_str=xml_temp_str & "<changefreq>daily</changefreq>" & vbCRLF
xml_temp_str=xml_temp_str & "</url>" & vbCRLF
'网站各栏目
sql="select * from sitemap"
rs.open sql,conn,1,1
do while not rs.eof 
xml_temp_str=xml_temp_str & "<url>" & vbCRLF
xml_temp_str=xml_temp_str & "<loc>" & url_path & "index.asp?sitepage=" & rs("id") & "</loc>" & vbCRLF
xml_temp_str=xml_temp_str & "<lastmod>" & date_format(rs("edit_date")) & "</lastmod>" & vbCRLF
xml_temp_str=xml_temp_str & "<changefreq>daily</changefreq>" & vbCRLF
xml_temp_str=xml_temp_str & "</url>" & vbCRLF
rs.movenext
loop
rs.close
'各栏目中的内容
table_list="article,product,album,software,movie"
table_name=split(table_list,",")
for i=0 to ubound(table_name)
	sql="select id,create_date,class from " & table_name(i)
	rs.open sql,conn,1,1
	do while not rs.eof 
	xml_temp_str=xml_temp_str & "<url>" & vbCRLF
	xml_temp_str=xml_temp_str & "<loc>" & url_path & "index.asp?sitepage=" & rs("class") & "&amp;contentid=" & rs("id") & "</loc>" & vbCRLF
	xml_temp_str=xml_temp_str & "<lastmod>" & date_format(rs("create_date")) & "</lastmod>" & vbCRLF
	xml_temp_str=xml_temp_str & "<changefreq>daily</changefreq>" & vbCRLF
	xml_temp_str=xml_temp_str & "</url>" & vbCRLF
	rs.movenext
	loop
	rs.close
next
xml_temp_str=xml_temp_str & "</urlset>"
set rs=nothing
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'set xml = Server.CreateObject("Microsoft.XMLDOM")
'xml.async = false
'xml.loadxml xml_temp_str
'xml.save Server.MapPath("sitemap.xml")
'Set xml = Nothing
Response.ContentType="text/xml"
response.write xml_temp_str
response.end
%>