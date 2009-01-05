<!--#include file="../common.asp"-->
<%
	check_admin
	dim list_id
	list_id=""
	default_language=db_getvalue("setup_name='default_language'","sys_setup","setup_value")
	language=ufomail_request("querystring","language")
	set rs=server.CreateObject("adodb.recordset")
	sql="select * from sitemap where [language]=" & default_language
	rs.open sql,conn,1,3
	do while not rs.eof
		if isnull(rs("code")) then
			rs("code")=create_code() & rs("id")
			rs.update
		end if
		if db_getvalue("code='" & rs("code") & "' and [language]=" & language,"sitemap","id")="" then
			if list_id="" then 
				list_id=rs("id")
			else
				list_id=list_id & "," & rs("id")
			end if 
		end if
	rs.movenext
	loop
	rs.close
	if list_id<>"" then
		sql="insert into sitemap (seq,parent,title,data_style,template,create_date,edit_date,adv_info,code,[language]) select seq,parent,title,data_style,template,create_date,edit_date,adv_info,code," & language & " as [language] from sitemap where ID in(" & list_id & ")"
		conn.execute sql
	end if
	sql="select * from sitemap where [language]=" & language & " and parent<>0"
	rs.open sql,conn,1,3
	do while not rs.eof
		code=db_getvalue("id=" & rs("parent"),"sitemap","code")
		rs("parent")=cint(db_getvalue("code='" & code & "' and [language]=" & language,"sitemap","id"))
		rs.update
	rs.movenext
	loop
	set rs=nothing
	response.redirect request.ServerVariables("HTTP_REFERER")
	response.end
%>