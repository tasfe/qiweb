<!--#include file="../common.asp"-->
<!--#include file="../htmleditor/fckeditor.asp"-->
<%
check_admin
pd_id=ufomail_request("querystring","id")
set rs=server.CreateObject("adodb.recordset")
sql="select * from lyb where id=" & pd_id
rs.open sql,conn,1,1
if rs.eof then
	rs.close
	set rs=nothing
	err_msgbox "数据不存在,请返回!"
end if
question_id=rs("id")
lyb_title=rs("lyb_title")
lyb_content=rs("lyb_content")
lyb_email=rs("lyb_email")
lyb_QQ=rs("lyb_QQ")
lyb_reply=rs("lyb_reply")
lyb_date=rs("lyb_date")
user_id=rs("user_id")
rs.close
set rs=nothing
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''保存操作
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'
if ufomail_request("form","action")<>"" then
	pd_id=ufomail_request("form","lyb_id")
	answer=ufomail_request("form","answer")
	answer_date=now()
	input_label="lyb_reply"
	input_value=answer 
	call db_save("edit","lyb",input_label,input_value,"id=" & pd_id)
	response.Redirect(ufomail_request("form","url"))
end if
%>
<html xmlns:x86>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>回复留言</title>
<?IMPORT NAMESPACE="x86" IMPLEMENTATION="RichEdit.htc"?>
<link href="../css.css" rel="stylesheet" type="text/css">
</head>

<body>
<!--功能标题-->
<div class="page-title">回复留言</div>
<%if return_info<>"" then%>
<div class="return-info"><%=return_info%></div>
<%end if%>
<div class="help-info">说明： <br>
  1管理你的留言<br>
</div>
<div class="oper-content"> 
<table width="95%" border="1" align="center" cellpadding="6" cellspacing="0" bordercolor="#CCCCCC" class="table-cell">
                    <form name="form1" method="post" action="">
                      <tr> 
                        <td width="100" align="right" bgcolor="#f2f8ff">留言者：</td>
                        <td><a href="view_user.asp?id=<%=user_id%>" target="_blank"><%=user_id%></a>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td align="right" bgcolor="#f2f8ff">留言时间：</td>
                        <td><%=lyb_date%>&nbsp; </td>
                      </tr>
                      <tr> 
                        <td align="right" bgcolor="#f2f8ff">标题：</td>
                        <td><%=lyb_title%></td>
                      </tr>
					  <tr> 
                        <td align="right" bgcolor="#f2f8ff">内容：</td>
                        <td><%=lyb_content%></td>
                      </tr>
                      <tr> 
                        <td align="right" bgcolor="#f2f8ff">回复：</td>
                        <td>
						<%
				Dim oFCKeditor
				Set oFCKeditor = New FCKeditor
				oFCKeditor.ToolbarSet = "MyToolbar"
				oFCKeditor.Width = "100%"
				oFCKeditor.Height = "300"
				oFCKeditor.Config("LinkBrowser") = "true" 
				oFCKeditor.Config("ImageBrowser") = "true" 
				oFCKeditor.Config("FlashBrowser") = "true" 
				oFCKeditor.Config("LinkUpload") = "true" 
				oFCKeditor.Config("ImageUpload") = "true" 
				oFCKeditor.Config("FlashUpload") = "true" 
				oFCKeditor.Value = lyb_reply
				oFCKeditor.Create "answer"
				%>*</td>
                      </tr>
                      <tr> 
                        <td align="right" bgcolor="#f2f8ff">&nbsp;</td>
                        <td><input name="action" type="submit" class="bt" id="action" value="保存" onFocus="javascript:answer.value=answer1.html"> 
                          <input name="reset" type="reset" class="bt" id="reset" value="重置">
                          <input name="lyb_id" type="hidden" id="lyb_id" value="<%=question_id%>">
						  <input name="url" type="hidden" id="lyb_id" value="<%=request.ServerVariables("HTTP_REFERER")%>"></td>
                      </tr>
                    </form>
                  </table></div>
				  <br>
<div class="page-foot"><%=db_getvalue("setup_name='page_foot'","sys_setup","setup_value")%></div><br>
</body>
</html>
