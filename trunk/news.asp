<!--#include file="common.asp"-->
<!--#include file="gather_class.asp"-->
<%
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''生成《互联网新闻开放协议》格式的XML文件
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
xml_temp_str=xml_temp_str & "<webMaster>ufomail@163.com</webMaster>" & vbCRLF
xml_temp_str=xml_temp_str & "<updatePeri>1440</updatePeri>" & vbCRLF
'各栏目中的内容
sql="select top 50 id,title,content,class,create_date from article where content<>'' order by create_date desc"
rs.open sql,conn,1,1
do while not rs.eof 
xml_temp_str=xml_temp_str & "<item>" & vbCRLF
xml_temp_str=xml_temp_str & "	<title><![CDATA[" & rs("title") & "]]></title>" & vbCRLF
xml_temp_str=xml_temp_str & "	<link>" & url_path & "index.asp?sitepage=" & rs("class") & "&amp;contentid=" & rs("id") & "</link>" & vbCRLF
content=rs("content")
text=RegExpreplace(content,"<([^>]*)>","")
xml_temp_str=xml_temp_str & "	<description><![CDATA[" & left(text,200) & "]]></description>" & vbCRLF
xml_temp_str=xml_temp_str & "	<text><![CDATA[" & text & "]]></text>" & vbCRLF
set images=RegExpExecute("src=('|"")+([^\f\n\r\t\v'""]*)(""|')+ ",content)
For Each url in images
img_url=url.SubMatches(1)
xml_temp_str=xml_temp_str & "	<image>" & HttpUrls(img_url,url_path) & "</image>" & vbCRLF
next
if RegExptest("src=('|"")+([^\f\n\r\t\v'""]*)(""|')+ ",content)=false then
	xml_temp_str=xml_temp_str & "	<image></image>" & vbCRLF
end if
xml_temp_str=xml_temp_str & "	<pubDate>" & date_format(rs("create_date")) & "</pubDate>" & vbCRLF
xml_temp_str=xml_temp_str & "</item>" & vbCRLF
rs.movenext
loop
rs.close
xml_temp_str=xml_temp_str & "</document>"
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
'xml.save Server.MapPath("news.xml")
'Set xml = Nothing
Response.ContentType="text/xml"
response.write xml_temp_str
response.end
%>