<!--#include file="common.asp"-->
<%
formname=ufomail_request("QueryString","form")
if isempty(formname) then formname="form1"
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>填写表单</title>
<link href="css.css" rel="stylesheet" type="text/css">
</head>

<body onLoad="resize_windows()">
<script language="JavaScript">
function resize_windows()
{
	parent.document.all('customer_form').height=document.body.scrollHeight;
	zoomsize=parent.document.all('customer_form').scrollWidth/document.body.scrollWidth;
	if (zoomsize<1) document.body.style.zoom=zoomsize;
}
</script>
<form name="form1" method="post" action="form_finish.asp" target="_blank">
<div id="mail_content">
<%
	file_path=root_path & "\form\" & formname & ".htm"
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
	response.write file_content
%>
</div>
<hr size="1"/>
<input type="button" name="submit1" value="Submit"  onclick="document.forms(0).submit()" onfocus="mail_body.value=mail_content.innerHTML"/>
<input type="reset" name="reset1" value="Reset"/>
<input name="mail_body" type="hidden" id="mail_body">
</form>
</body>
</html>