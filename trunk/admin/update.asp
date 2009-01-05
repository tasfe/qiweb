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
'=====================压缩数据库=========================
Function CompactDB(dbPath, boolIs97)
 On Error Resume Next
 Dim fso, Engine, strDBPath,JET_3X
 JET_3X=4
 strDBPath = left(dbPath,instrrev(DBPath,"\"))
 Set fso = CreateObject("Scripting.FileSystemObject")
 If Err Then
    Err.Clear
    CompactDB =err.description
    Exit Function
 End If
 If fso.FileExists(dbPath) Then
    fso.CopyFile dbpath,strDBPath & "temp.mdb"
    Set Engine = CreateObject("JRO.JetEngine")

    If boolIs97 = "True" Then
    Engine.CompactDatabase "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & strDBPath & "temp.mdb", "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & strDBPath & "temp1.mdb;Jet OLEDB:Engine Type=" & JET_3X
 	 Else
    Engine.CompactDatabase "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & strDBPath & "temp.mdb","Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & strDBPath & "temp1.mdb"
	End If

  fso.CopyFile strDBPath & "temp1.mdb",dbpath
  fso.DeleteFile(strDBPath & "temp.mdb")
  fso.DeleteFile(strDBPath & "temp1.mdb")
  Set fso = Nothing
  Set Engine = Nothing
  CompactDB ="success!"
 Else
  CompactDB ="error?"
 End If
End Function
'解压缩mdb文件
Sub UnPack()
	on error resume next
	str = Server.MapPath(server_name) & "\"
	Set rs = CreateObject("ADODB.RecordSet")
	Set stream = CreateObject("ADODB.Stream")
	Set conn = CreateObject("ADODB.Connection")
	Set oFso = CreateObject("Scripting.FileSystemObject")
	connStr = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & Server.MapPath(server_name & "update.mdb") 
	conn.Open connStr
	rs.Open "FileData", conn, 1, 1
	stream.Open
	stream.Type = 1
	Do Until rs.Eof
		theFolder = Left(rs("P"), InStrRev(rs("P"), "\"))
		If oFso.FolderExists(str & theFolder) = False Then
			oFso.CreateFolder(str & theFolder)
		End If
		stream.SetEOS()
		If IsNull(rs("fileContent")) = False Then stream.Write rs("fileContent")
		stream.SaveToFile str & rs("P"), 2
		if err.Number<>0 then 
			errmsg=errmsg & "<li>Error # " & CStr(Err.Number) & " " & Err.Description & "(" & str & rs("P") & ")</li>" 
			err.clear 
		end if
		rs.MoveNext
	Loop
	rs.Close
	conn.Close
	stream.Close
	Set ws = Nothing
	Set rs = Nothing
	Set stream = Nothing
	Set conn = Nothing
	Set oFso = Nothing
 End Sub
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>自动升级网站程序</title>
<link href="../css.css" rel="stylesheet" type="text/css">
</head>

<body>
<div class="page-title">网站自动升级程序</div>
<div class="help-info">升级步骤：<br>
第一步：检查你的程序授权<br>
第二步：下载新的升级程序<br>
第三步：更新网站程序<br>
第四步：更新数据库的结构<br>
第五步：更新网站模板和下载新的网站模板
</div>
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
'首先下载检查更新程序的程序 
'第二步,查看升级程序是否是最新的？
if session("step")=1 then
	%>
	<div class="page-title">第二步</div>
	<div class="return-info">正在更新升级文件！</div>
	<%
	update_file("/admin/check_update.asp")
	%>
	<script language="JavaScript">
		window.location="check_update.asp"
	</script>	
	<%
	call page_end()
	response.end
	'check_update.asp这个文件用来升级update.asp这个文件
end if


if session("step")=2 then
'然后更新网站中的程序文件 
	%>
	<div class="page-title">第三步</div>
	<%
	update_file_list=getHTTPPage("http://txmaimai.cn/infoweb/update/get_update_file.asp?user=" & user_name & "&key=" & sys_key & "&version=" & sys_version)
	'下载升级文件。先判断服务是否支持RAR文件包，支持就下载RAR升级文件包，不支持就下载MDB文件包
	if update_file_list<>"" and update_file_list<>"0" then
		if ObjTest("Wscript.Shell")=true then
			update_file_list=update_file_list & ".rar"
			call SaveRemoteFile(update_file_list,"http://txmaimai.cn/infoweb/" & update_file_list)
			'下载完后开始对下载的升级文件进行解压缩
			if file_ifopen(root_path & "\tools\winrar.exe")=2 or file_ifopen(root_path & "\tools\cmd.exe")=2 then
				set fso=CreateObject("Scripting.FileSystemObject")
				'下载相对应的解压插件
				fso.CreateFolder root_path & "\tools\"
				call SaveRemoteFile("tools\winrar.exe","http://txmaimai.cn/infoweb/tools/winrar.exe")
				call SaveRemoteFile("tools\cmd.exe","http://txmaimai.cn/infoweb/tools/cmd.exe")
			end if 
			unzip_path=root_path & "\" & update_file_list
			Set WshShell = server.CreateObject("Wscript.Shell")
			temp_cmd=root_path & "\tools\cmd.exe /c " & root_path & "\tools\winrar.exe x -r -o+ " & unzip_path & " " & root_path & ""
			IsSuccess = WshShell.Run(temp_cmd,1, true)
			if IsSuccess = 0 Then
			else
				call file_delete(root_path & "\" & update_file_list)
				update_file_list=get_left(update_file_list,".") & ".mdb"
				call SaveRemoteFile("update.mdb","http://txmaimai.cn/infoweb/" & update_file_list)
				update_file_list="update.mdb"
				'从MDB文件解压缩
				call UnPack()
			end if 
		else
			update_file_list=update_file_list & ".mdb"
			call SaveRemoteFile("update.mdb","http://txmaimai.cn/infoweb/" & update_file_list)
			update_file_list="update.mdb"
			'从MDB文件解压缩
			call UnPack()
		end if
	else
		errmsg="无法下载到升级包，原因如下：<br><li>你的软件已经是最新，无须升级！</li><li>没有通过服务器授权验证</li><li>网络故障</li>"
	end if
	if errmsg<>"" then
		%>
		<div class="return-info"><%=errmsg%></div>
		<%
		call page_end()
		response.end
	else
		call file_delete(root_path & "\" & update_file_list)
		session("step")=3
		%>
		<div class="return-info">已更新所有的网站程序！</div>
		<script language="JavaScript">
			window.location="update.asp"
		</script>	
		<%
		call page_end()
		response.end
	end if
end if
'开始进入更新 
if session("step")=3 then
'首先更新数据库的结构。
	'获得要更新的SQL语句
	%>
	<div class="page-title">第四步</div>
	<%
	update_sql_list=getHTTPPage("http://txmaimai.cn/infoweb/update/get_update_sql.asp?user=" & user_name & "&key=" & sys_key & "&version=" & sys_version)
	call sql_update()
	sub sql_update()
	on error resume next
	if update_sql_list<>"0" and update_sql_list<>"" then
		update_sql=split(update_sql_list,"|@+@|")
		for i=0 to ubound(update_sql)
			sql=update_sql(i)
			sql=replace(sql,"language_update_mdb",root_path & "\language_update.mdb")
			conn.execute sql
		next
	end if
	end sub
	'压缩数据库
	'db_path=root_path & "\db\INFO#web#20060621.asa" 
	'call CompactDB(db_path,false)
	session("step")=4
	%>
	<div class="return-info">已对数据库文件进行更新！</div>
	<script language="JavaScript">
		window.location="update.asp"
	</script>	
	<%
	call page_end()
	response.end
end if
'最后写入更新日志  
if session("step")=4 then
	%>
	<div class="page-title">第五步</div>
	<%
	temp_str=getHTTPPage("http://txmaimai.cn/infoweb/update/update_history.asp?user=" & user_name & "&key=" & sys_key & "&version=" & sys_version & "&web=" & url_path & "&ip=" & request.ServerVariables("REMOTE_ADDR"))
	if temp_str<>"" and temp_str<>"0" then
		call db_save("edit","sys_setup","setup_value|+|setup_name",temp_str & "|+|sys_version","setup_name='sys_version'")
		session("step")=5
		%>
		<div class="return-info">开始刷新版本号！</div>
		<script language="JavaScript">
			window.location="update.asp"
		</script>	
		<%
		call page_end()
		response.end
	else
		%>
		<div class="return-info">刷新版本号出错！</div>
		<%
		call page_end()
		response.end
	end if
end if 
if session("step")=5 then
	%>
	<div class="page-title">升级完成</div>
	<div class="return-info">升级已完成！当前软件的版本是：<%=db_getvalue("setup_name='sys_version'","sys_setup","setup_value")%></div>
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
