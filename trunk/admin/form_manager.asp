<!--#include file="../common.asp"-->
<!--#include file="../htmleditor/fckeditor.asp"-->
<%
	check_admin
	set fso=server.CreateObject("Scripting.FileSystemObject")
	file_name=ufomail_request("querystring","file_name")
	file_path=root_path & "\form\"
	if file_name="" then file_name="form1.htm"
	Set objStream = Server.CreateObject("ADODB.Stream")
    With objStream
        .Type = 2
        .Mode = 3
        .Open
        .LoadFromFile file_path & file_name
        .Charset = "utf-8"
        .Position = 2
        file_content = .ReadText
        .Close
    End With
    Set objStream = Nothing
'-----------------------------------------------------------------------------
	if ufomail_request("Form","action")<>"" then
		file_content=ufomail_request("Form","file_content")
		file_name=ufomail_request("Form","file_name")
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
			objStreamt.SaveToFile file_path & file_name,2
			objStreamt.close
			.Close
		End With
		Set objStream = Nothing
		response.Redirect "form_manager.asp?file_name=" & file_name
	end if
	if ufomail_request("querystring","action")="dele" then
		if lcase(file_name)<>"form1.htm" then
			fso.deletefile file_path & file_name
			response.Redirect "form_manager.asp"
		else
			return_info="form1.htm是系统固定的文件，不能删除！"
		end if
	end if
%>
<html xmlns:x86>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>自定义客户反馈表单模板</title>
<?IMPORT NAMESPACE="x86" IMPLEMENTATION="RichEdit.htc"?>
<link href="../css.css" rel="stylesheet" type="text/css">

</head>

<body>

<!--功能标题-->
<div class="page-title">自定义客户反馈表单模板</div>
<%if return_info<>"" then%>
<div class="return-info"><%=return_info%></div>
<%end if%>
<div class="help-info">说明： <br>
  1、你可以随意定义反馈表单的内容，并在任何一个页面中调用。<br>
  2、操作方法大致如下：<br>
  第一步：定义你的反馈表单，定义好后可以点击保存进行保存。建议用户修改文件名称，这样就会得到一份新的模板。<br>
  第二步：将反馈表单调用代码复制到你需要使用表单的页面中。<br>
  第三步：切换到源代码模式，把代码粘贴即可！<br>
  3、请点击<a href="email_para.asp">这里</a>设置你接收客户反馈的电邮地址和电邮主题！<!--br>
  4、你还可以点击下面按钮从<a href="http://qiweb.cn" target="_blank">QiWeb.cn</a>下载新模板！ 
  <div class="button"><a href="template_update.asp?style=form">下载新模板</a></div-->
  </div>
<div class="oper-content">
  <table width="95%" border="0" cellpadding="5" cellspacing="0">
        <tr> 
          <td width="100" valign="top"><table width="100%" border="0" cellpadding="4" cellspacing="0" class="all_border">
              <tr> 
                <td bgcolor="#eeeeee" class="tdh_b"><img src="../images/page-title.gif" align="absmiddle"> 
                  模板列表</td>
              </tr>
			  <%
			  Set f = fso.GetFolder(file_path)
			  Set fc = f.Files
				For Each f1 in fc
					response.write "<tr><td><a href='form_manager.asp?file_name=" & f1.name & "'>" & f1.name & "</a>"
					if lcase(f1.name)<>"form1.htm" then
						response.write "　<a href='form_manager.asp?file_name=" & f1.name & "&action=dele'><img src='../images/close.gif' alt='删除模板文件'/></a></td></tr>"
					end if
			    Next
				set fc=nothing
				set f=nothing
			  %>
            </table></td>
          <td valign="top">
		  <table width="100%" border="0" cellpadding="4" cellspacing="0" class="all_border">
		  	<form name="form1" method="post" action="">
              <tr> 
                <td class="tdh_b"><img src="../images/page-title.gif"> 
                  修改模板:<input name="file_name" type="text" id="file_name" value="<%=file_name%>">(修改文件名，将会新建一个模板)</td>
              </tr>
              <tr> 
                <td height="300" align="center" valign="top" class="tdh_b" >
				<%
				Dim oFCKeditor
				Set oFCKeditor = New FCKeditor
				oFCKeditor.ToolbarSet = "Default"
				oFCKeditor.Config("LinkBrowser") = "true" 
				oFCKeditor.Config("ImageBrowser") = "true" 
				oFCKeditor.Config("FlashBrowser") = "true" 
				oFCKeditor.Config("LinkUpload") = "true" 
				oFCKeditor.Config("ImageUpload") = "true" 
				oFCKeditor.Config("FlashUpload") = "true" 
				oFCKeditor.Config("FullPage")=false
				oFCKeditor.Width = "100%"
				oFCKeditor.Height = "300"
				oFCKeditor.Value = file_content
				oFCKeditor.Create "content"
				%> 
                  </td>
              </tr>
              <tr>
                <td align="center" valign="top">
                    <input name="action" type="submit" class="bt" id="action" value="保存"><input name="Submit2" type="reset" class="bt" value="重置">
                   </td>
              </tr>
			  </form>
            </table></td>
        </tr>
		<tr><td colspan="2">
		<div class="return-info">本表单调用代码</div>
		<code> &lt;iframe src=&quot;form.asp?form=<%=get_left(file_name,".")%>&quot; 
        id=&quot;customer_form&quot; width=&quot;100%&quot; frameborder=&quot;0&quot; 
        scrolling=&quot;no&quot;&gt;反馈表单&lt;/iframe&gt; </code> </td>
    </tr>
      </table>
</div>
<div class="page-foot"><%=db_getvalue("setup_name='page_foot'","sys_setup","setup_value")%></div><br>
</body>
</html>
