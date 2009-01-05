<!--#include file="../common.asp"-->
<%
	check_admin
	file_path=root_path & "\plug-in\plug-in.inc"
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
		response.Redirect "plugin_manager.asp"
	end if
%>
<html xmlns:x86>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>插件文件管理</title>
<?IMPORT NAMESPACE="x86" IMPLEMENTATION="RichEdit.htc"?>
<link href="../css.css" rel="stylesheet" type="text/css">

</head>

<body>

<!--功能标题-->
<div class="page-title">插件文件管理（BETA）</div>
<%if return_info<>"" then%>
<div class="return-info"><%=return_info%></div>
<%end if%>
<div class="help-info">说明： <br>
  1、此功能用于配置一些高级的功能。可以让你的网站功能无限升级！<br>
  2、此功能存在一定风险，因此请用户注意修改后台管理密码！<br>
  3、请使用标准的ASP语言进行编辑。<br>
</div>
<div class="oper-content">
  <form name="form1" method="post" action="">
  <textarea name="content" style="width:100%;height:400px;"><%=file_content%></textarea>

	<hr size="1"/>
    <input type="submit" name="action" value="保存模板">
  </form>
</div>
<div class="page-foot"><%=db_getvalue("setup_name='page_foot'","sys_setup","setup_value")%></div><br>
</body>
</html>
