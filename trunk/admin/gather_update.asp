<!--#include file="../common.asp"-->
<%
'on error resume next
Server.ScriptTimeOut=999999
dim errmsg
errmsg=""
call check_admin()
'获得程序的授权码和权本号
user_name=db_getvalue("setup_name='user_name'","sys_setup","setup_value")
sys_version=db_getvalue("setup_name='sys_version'","sys_setup","setup_value")
sys_key=db_getvalue("setup_name='user_key'","sys_setup","setup_value")
'检查组件是否被支持及组件版本的子程序
function ObjTest(strObj)
  on error resume next
  ObjTest=false
  set TestObj=server.CreateObject (strObj)
  If -2147221005 <> Err then		'感谢网友iAmFisher的宝贵建议
    'ObjTest=true
  end if
  set TestObj=nothing
End function
'判断远程文件是否存在 
sub SaveRemoteFile(LocalFileName,RemoteFileUrl)
	dim Ads,Retrieval,GetRemoteData 
	On Error Resume Next 
	Dim httpxml 
	Set httpxml = Server.CreateObject("MicroSoft.XMLHTTP") 
	httpxml.open "HEAD",RemoteFileUrl,False 
	httpxml.send 
	If httpxml.status <> 200 Then 
		Fonderr = true 
		errmsg=errmsg & "<li>更新文件包不存在！请与我们的技术人员联系，TEL：020-86333077</li>" 
		exit sub 
	Else 
		Fonderr = False 
	End If 
	Set httpxml = Nothing 
	'转换成二进制数据流 
	Set Retrieval = Server.CreateObject("Microsoft.XMLHTTP") 
	With Retrieval 
		.Open "Get", RemoteFileUrl, False, "", "" 
		.Send 
		GetRemoteData = .ResponseBody 
	End With 
	'写入本地 
	streamtemp=replace("Adodxxb.Strexxam","xx","") 
	Set Ads = Server.CreateObject(streamtemp) 
	With Ads 
	.Type = 1 
	.Open 
	.Write GetRemoteData 
	.SaveToFile root_path & "\" & LocalFileName,2 
	.Cancel() 
	.Close() 
	End With 
	Set Ads=nothing 
end sub

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>下载新的文章采集模板</title>
<link href="../css.css" rel="stylesheet" type="text/css">
</head>

<body>
<div class="page-title">下载新闻采集模块</div>
<div class="help-info">升级步骤：<br>
第一步：检查你的程序授权<br>
  第二步：下载新的采集模块数据库<br>
  第三步：更新你的网站数据库<br>
  第四步：完成操作</div>
<%if isnull(session("step")) or isempty(session("step")) or session("step")="" or session("step")=1 then%>
	<div class="page-title">第一步</div>
	<%
	
	'检查程序版本及授权，看看是否可以进行升级？
	'第一步，检查授权，获得服务器的数据链接代码
	
	'response.write "http://txmaimai.cn/infoweb/update/check_user.asp?user=" & user_name & "&key=" & sys_key
	'response.end
	temp_str=getHTTPPage("http://txmaimai.cn/infoweb/update/check_user.asp?user=" & user_name & "&key=" & sys_key)
	if temp_str="" then
		%>
		<div class="return-info">连接升级服务器失败，请稍后再试，如多次重试仍无法连接，请联系QQ：40459931，或Email:ufomail@163.com!</div>
		<%
		call page_end()
		response.end
	end if
	if temp_str="false" then
		%>
		<div class="return-info">你使用的程序的许可证没通过服务器的验证，不能提供自动升级服务，如有问题请联系QQ：40459931，或Email:ufomail@163.com!</div>
		<%
		call page_end()
		response.end
	end if
	if temp_str="true" then
		%>
		<div class="return-info">程序许可证已通过服务器的验证！进行下一步操作</div>
		<%
	end if
	session("step")=1
end if



if session("step")=1 then
'然后更新网站中的程序文件 
	%>
	<div class="page-title">第二步</div>
	<%
	call SaveRemoteFile("gather.mdb","http://qiweb.cn/server/gather.mdb")
	if errmsg<>"" then
		%>
		<div class="return-info"><%=errmsg%></div>
		<%
		call page_end()
		response.end
	else
		session("step")=2
		%>
		<div class="return-info">已下载新的模板数据库！</div>
		<script language="JavaScript">
			window.location="gather_update.asp"
		</script>	
		<%
		call page_end()
		response.end
	end if
end if
'开始进入更新 
if session("step")=2 then
'首先更新数据库的结构。
	'获得要更新的SQL语句
	%>
	<div class="page-title">第三步</div>
	<%
	'先删除旧数据库中的旧模块
	call update_db()
	sub update_db()
	on error resume next
	sql="delete from gather where title like '[sys]%'"
	conn.execute sql
	sql="insert into gather(gather_name,gather_url,gather_area1,gather_area2,gather_list1,gather_list2,gather_list_page,gather_list_page_url,gather_list_page_num,gather_title1,gather_title2,gather_content1,gather_content2,gather_content_page,gather_content_page_url,gather_date1,gather_date2,gather_flash,gather_picture,gather_link,gather_link1,gather_link2) select gather_name,gather_url,gather_area1,gather_area2,gather_list1,gather_list2,gather_list_page,gather_list_page_url,gather_list_page_num,gather_title1,gather_title2,gather_content1,gather_content2,gather_content_page,gather_content_page_url,gather_date1,gather_date2,gather_flash,gather_picture,gather_link,gather_link1,gather_link2 from gather as N_gather in '" & root_path & "\gather.mdb" & "'"
	conn.execute sql
	end sub
	session("step")=3
	%>
	<div class="return-info">已对本地数据库进行更新！</div>
	<script language="JavaScript">
		window.location="gather_update.asp"
	</script>	
	<%
	call page_end()
	response.end
end if
'最后写入更新日志  
if session("step")=3 then
	%>
	<div class="page-title">第四步</div>
	<%
	temp_str=getHTTPPage("http://txmaimai.cn/infoweb/update/update_history.asp?user=" & user_name & "&key=" & sys_key & "&version=" & sys_version & "&web=" & url_path & "&ip=" & request.ServerVariables("REMOTE_ADDR"))
	if temp_str<>"" and temp_str<>"0" then
		call db_save("edit","sys_setup","setup_value|+|setup_name",temp_str & "|+|sys_version","setup_name='sys_version'")
		session("step")=4
		call file_delete(root_path & "\gather.mdb")
		%>
		<div class="return-info">写入历史记录！</div>
		<script language="JavaScript">
			window.location="gather_update.asp"
		</script>	
		<%
		call page_end()
		response.end
	else
		%>
		<div class="return-info">写入历史记录出错！</div>
		<%
		call page_end()
		response.end
	end if
end if 
if session("step")=4 then
	%>
	<div class="page-title">更新完成</div>
	<div class="return-info">已下载完最新的模板文件</div>
	<%
	session("step")=1
end if
call page_end()
%>
<%
sub page_end()%>
<br>
<br>
<div class="page-foot"><%=db_getvalue("setup_name='page_foot'","sys_setup","setup_value")%></div><br>

</body>
</html>
<%end sub%>
