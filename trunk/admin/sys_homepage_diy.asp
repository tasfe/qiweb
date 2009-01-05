<!--#include file="../common.asp"-->
<!--#include file="../htmleditor/fckeditor.asp"-->
<%
	check_admin
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
'-----------------------------------------------------------------------------
	if ufomail_request("Form","action")<>"" then
		file_content=ufomail_request("Form","file_content")
		Set objStreamt = Server.CreateObject("ADODB.Stream")
		Set objStream = Server.CreateObject("ADODB.Stream")
		With objStream
			.Open
			.Charset = "utf-8"
			.Position = 0
			.WriteText request.Form("content")
			.Position = 3
			objStreamt.open
			objStreamt.type = 1
			.CopyTo objStreamt
			objStreamt.SaveToFile file_path,2
			objStreamt.close
			.Close
		End With
		Set objStream = Nothing
		response.Redirect "sys_homepage_diy.asp"
	end if
%>
<html xmlns:x86>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>自定义模板</title>
<?IMPORT NAMESPACE="x86" IMPLEMENTATION="RichEdit.htc"?>
<link href="../css.css" rel="stylesheet" type="text/css">

</head>

<body>

<!--功能标题-->
<div class="page-title">自定义首页模板</div>
<%if return_info<>"" then%>
<div class="return-info"><%=return_info%></div>
<%end if%>
<div class="help-info">说明： <br>
  1、要使用自定义模板,须先到首页开关中把首页设为&quot;自定义&quot;<br>
  2、修改下面首页的代码； <br>
  3、此处输入的是HTML代码，请在输入时选择输入的代码类型。<br>
  4、此为高级功能，供具有一定网页制作技术的人员自由定制，修改之前请先学习HTML方面的知识！<br>
</div>
<div class="oper-content">
  <form name="form1" method="post" action="">
    <%
	Dim oFCKeditor
	Set oFCKeditor = New FCKeditor
	oFCKeditor.ToolbarSet = "MyToolbar"
	oFCKeditor.Config("FullPage")=true
	oFCKeditor.Width = "100%"
	oFCKeditor.Height = "300"
	oFCKeditor.Config("LinkBrowser") = "true" 
	oFCKeditor.Config("ImageBrowser") = "true" 
	oFCKeditor.Config("FlashBrowser") = "true" 
	oFCKeditor.Config("LinkUpload") = "true" 
	oFCKeditor.Config("ImageUpload") = "true" 
	oFCKeditor.Config("FlashUpload") = "true" 
	oFCKeditor.Value = file_content
	oFCKeditor.Create "content"
	%>
	<hr size="1"/>
    <input type="submit" name="action" value="保存模板">
  </form>
</div>
<div class="page-foot"><%=db_getvalue("setup_name='page_foot'","sys_setup","setup_value")%></div><br>
</body>
</html>
