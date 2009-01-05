<%
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''		语言包
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''
''
show_language=db_getvalue("setup_name='show_language'","sys_setup","setup_value")
if isempty(show_language) then show_language=1
set temp_rs=server.CreateObject("adodb.recordset")
sql="select * from [language] where id in (" & show_language & ") order by id"
temp_rs.open sql,conn,1,1
xml_temp_str=xml_temp_str & "	<public_language>" & vbCRLF
do while not temp_rs.eof
	xml_temp_str=xml_temp_str & "		<language_name id='" & temp_rs("id") & "'><![CDATA[" & temp_rs("language_name") & "]]></language_name>" & vbCRLF
temp_rs.movenext
loop
xml_temp_str=xml_temp_str & "	</public_language>" & vbCRLF
temp_rs.close
set temp_rs=nothing
%>