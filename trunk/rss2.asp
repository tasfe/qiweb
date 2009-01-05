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
xml_temp_str=xml_temp_str & "<rss version='2.0'><channel>" & vbCRLF
'首页
language=request.cookies("language")
if isempty(language) then 
	default_language=db_getvalue("setup_name='default_language'","sys_setup","setup_value")
	language=cint(default_language)
end if 
xml_temp_str=xml_temp_str & "<title>" & db_getvalue("ID=" & language,"[language]","homepage_name") & "</title>" & vbCRLF
xml_temp_str=xml_temp_str & "<link>" & url_path & "</link>" & vbCRLF
xml_temp_str=xml_temp_str & "<description><![CDATA[" & db_getvalue("ID=" & language,"[language]","site_name") & "]]></description>" & vbCRLF
xml_temp_str=xml_temp_str & "<language>zh-cn</language>" & vbCRLF
xml_temp_str=xml_temp_str & "<copyright>Copyright 2007-2008 " & url_path & "</copyright>" & vbCRLF
xml_temp_str=xml_temp_str & "<webMaster>ufomail@163.com</webMaster>" & vbCRLF
xml_temp_str=xml_temp_str & "<generator>QiWeb Maker(http://qiweb.cn)</generator>" & vbCRLF
xml_temp_str=xml_temp_str & "<cloud domain='qiweb.cn' port='80' path='/RPC2' registerProcedure='pingMe' protocol='soap'/> " & vbCRLF
xml_temp_str=xml_temp_str & "<ttl>120</ttl>" & vbCRLF
xml_temp_str=xml_temp_str & "<image>" & vbCRLF
xml_temp_str=xml_temp_str & "	<title>" & db_getvalue("ID=" & language,"[language]","homepage_name") & "</title>" & vbCRLF
xml_temp_str=xml_temp_str & "	<link>" & url_path & "</link>" & vbCRLF
xml_temp_str=xml_temp_str & "	<url>" & file_show(db_getvalue("setup_name='site_logo'","sys_setup","setup_value")) & "</url>" & vbCRLF
xml_temp_str=xml_temp_str & "</image>" & vbCRLF
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
	sql="select top 20 id,title,content,class,create_date from " & table_name(i) & " order by create_date desc"
	rs.open sql,conn,1,1
	do while not rs.eof 
	xml_temp_str=xml_temp_str & "<item>" & vbCRLF
	xml_temp_str=xml_temp_str & "	<title><![CDATA[" & rs("title") & "]]></title>" & vbCRLF
	xml_temp_str=xml_temp_str & "	<link>" & url_path & "index.asp?sitepage=" & rs("class") & "&amp;contentid=" & rs("id") & "</link>" & vbCRLF
	content=rs("content")
	text=get_text_desc(content,400)
	xml_temp_str=xml_temp_str & "	<description><![CDATA[" & text & "]]></description>" & vbCRLF
	xml_temp_str=xml_temp_str & "	<pubDate>" & date_format(rs("create_date")) & "</pubDate>" & vbCRLF
	xml_temp_str=xml_temp_str & "</item>" & vbCRLF
	rs.movenext
	loop
	rs.close
next
xml_temp_str=xml_temp_str & "</channel></rss>"
set rs=nothing
function date_format(in_date)
	dim month_name,week_name
	month_name="Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec"
	week_name="Mon,Tue,Wed,Thu,Fri,Sat,Sun"
	month_name=split(month_name,",")
	week_name=split(week_name,",")
	date_format=week_name(weekday(in_date)-1)
	date_format=date_format & " " & day(in_date) & " " & month_name(month(in_date)-1) & " " & year(in_date)
	date_format=date_format & " " & right("0" & hour(in_date),2) & ":" & right("0" & minute(in_date),2) & ":" & right("0" & second(in_date),2) & " GMT"
end function
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'set xml = Server.CreateObject("Microsoft.XMLDOM")
'xml.async = false
'xml.loadxml xml_temp_str
'xml.save Server.MapPath("rss.xml")
'Set xml = Nothing
Response.ContentType="text/xml"
response.write xml_temp_str
response.end
%>