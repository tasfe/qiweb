<!--#include file="common.asp"-->
<%
file_id=request.QueryString("file_id")
if instr(file_id,"||")<>0 then
file_id=get_left(file_id,"||")
end if
file_path=file_show(file_id)
'file_name=db_getvalue("pd_pic='" & file_id & "||' or pd_picture like '%" & file_id & "||%'","pd_basic","pd_name")
response.redirect file_path
%>