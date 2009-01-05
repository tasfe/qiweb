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
  3、此处输入的是XSL代码或是HTML代码，请在输入时选择输入的代码类型。<br>
  4、此为高级功能，供具有一定网页制作技术的人员自由定制，修改之前请先学习HTML，XML和XSL等方面的知识！<br>
  5、如使用XSL编码，下面代码以供参考：
  <table width="90%" cellpadding="4">
  	<tr><td>首页名称：</td>
      <td>&lt;xsl:value-of select=&quot;//page_meta&quot; disable-output-escaping=&quot;yes&quot;/&gt;</td>
    </tr>
	<tr><td>首页的META：</td>
      <td>&lt;xsl:value-of select=&quot;//homepage_name&quot;/&gt;</td>
    </tr>
	<tr>
      <td>语言选择按钮：</td>
      <td>&lt;xsl:for-each select=&quot;page/public_language/language_name&quot;&gt;<br>	
        &lt;a href=&quot;start.asp?language={@id}&quot; class=&quot;language_button&quot;&gt;&lt;span&gt;&lt;xsl:value-of 
        select=&quot;.&quot;/&gt;&lt;/span&gt;&lt;/a&gt;<br> &lt;/xsl:for-each&gt;</td>
    </tr>
  </table>
  </div>
<div class="oper-content"> 
<div class="return-info">使用的编码：
<select onchange="javascript:window.location='sys_homepage_diy.asp?style=' + this.;">
	<option value="true" selected="selected">HTML</option>
	<option value=""></option>
</select>
</div>
  <form name="form1" method="post" action="">
    <%
	Dim oFCKeditor
	Set oFCKeditor = New FCKeditor
	oFCKeditor.ToolbarSet = "MyToolbar"
	edit_style=ufomail_request("querystring","style")
	if edit_style="" then 
		edit_style=true
		oFCKeditor.Config("FullPage")=edit_style
		oFCKeditor.Width = "100%"
		oFCKeditor.Height = "300"
		oFCKeditor.Value = file_content
		oFCKeditor.Create "content"
	else
		edit_style=false
		response.write "<textarea name='content' style='width:100%;height:300px;'>" & file_content & "</textarea>"
	end if
	
	%>
	<hr size="1"/>
    <input type="submit" name="action" value="保存模板">
  </form>
</div>
<div class="help-info">
标准的XSL空白页面代码！(供参考)<br>
  <code>&lt;?xml version=&quot;1.0&quot; encoding=&quot;utf-8&quot;?&gt;<br>
  &lt;xsl:stylesheet version=&quot;1.0&quot; xmlns:xsl=&quot;http://www.w3.org/1999/XSL/Transform&quot; 
  xmlns:fo=&quot;http://www.w3.org/1999/XSL/Format&quot;&gt;<br>
  &nbsp; &nbsp;&lt;xsl:output method=&quot;xml&quot; encoding=&quot;utf-8&quot; 
  indent=&quot;yes&quot;/&gt;<br>
  &nbsp; &nbsp;&lt;xsl:template match=&quot;/&quot;&gt;<br>
  &nbsp; &nbsp;&nbsp; &nbsp;&lt;html&gt;<br>
  &nbsp; &nbsp; &nbsp; &nbsp;&lt;!--调用统一的HEAD内容--&gt;<br>
  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&lt;head&gt;<br>
  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&lt;meta http-equiv=&quot;Content-Type&quot; 
  content=&quot;text/html; charset=uft-8&quot;/&gt;<br>
  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&lt;xsl:value-of select=&quot;//page_meta&quot; 
  disable-output-escaping=&quot;yes&quot;/&gt; <br>
  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&lt;title&gt;<br>
  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&lt;xsl:value-of select=&quot;//homepage_name&quot;/&gt;<br>
  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&lt;/title&gt;<br>
  &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;!--以上最好不要修改！--&gt;<br>
  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&lt;!--下面输入页面样式，样式表开始--&gt;<br>
  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&lt;style type=&quot;text/css&quot;&gt;<br>
  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.class{}<br>
  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&lt;/style&gt;<br>
  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&lt;/head&gt;<br>
  &nbsp; &nbsp; &nbsp; &nbsp;&lt;!--head完成--&gt; <br>
  &nbsp; &nbsp; &nbsp;&lt;body&gt;<br>
  &nbsp; &nbsp; &nbsp;&lt;!--页面的内容,由用户自行填写--&gt;<br>
  &nbsp; &nbsp; &nbsp;&lt;/body&gt;<br>
  &lt;/html&gt;<br>
  &lt;/xsl:template&gt;<br>
  &lt;/xsl:stylesheet&gt; </code></div>
<div class="page-foot"><%=db_getvalue("setup_name='page_foot'","sys_setup","setup_value")%></div><br>
</body>
</html>
