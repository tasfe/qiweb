<%
response.cookies("language")=request.QueryString("language")
response.Cookies("language").expires=date()+1
if instr(request.ServerVariables("HTTP_REFERER"),"default.asp")<>0 then
	response.Redirect "index.asp"
else
	if instr(request.ServerVariables("HTTP_REFERER"),".asp")<>0 then
		response.Redirect request.ServerVariables("HTTP_REFERER")
	else
		response.Redirect "index.asp"
	end if
end if
%>