<!--#include file="common.asp"-->
<!--#include file="UpLoadClass.asp"-->
<%
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''	文档作用：上传处理
''	创建时间：2005-3-12
''	修改情况：	2005-3-14 增加了取得上传文件的页面的URL的功能.(朱祺艺)
''				2005-3-24 增加了页面权限控制模块(朱祺艺)
''				2005-7-23 增加了文件归档保存功能(朱祺艺)
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
%>
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title><%=site_name%></title>
<%=page_head%>
<link href="css.css" rel="stylesheet" type="text/css">
<style type="text/css">
<!--
body {
	font-size: 9pt;
}
-->
</style>
</head> 

<body leftmargin="2" topmargin="2">
<%
Server.ScriptTimeOut=999999			'设置最大运行时间。 
'上传方式upload_type值: 0＝风声无组件上传，1＝Aspupload3.0  
dim upload_type,file_maxsize,f_form,upload_folder,upload_mask
dim musk_font_size,musk_font_color,musk_font_shadow,musk_border,musk_border_color,musk_font_text
Set fso = CreateObject("Scripting.FileSystemObject")
folder_name=replace(replace(date(),"/",""),"-","")
upload_folder=db_getvalue("setup_name='upload_forder'","sys_setup","setup_value") & folder_name & "/"
if fso.folderExists(root_path & replace(upload_folder,"/","\"))=false then
	fso.createfolder root_path & replace(upload_folder,"/","\")
end if
'获得最大上传的容量 
file_maxsize=clng(db_getvalue("setup_name='upload_maxsize'","sys_setup","setup_value")) 
'获得上传组件的类型 
upload_type=cint(db_getvalue("setup_name='upload_object'","sys_setup","setup_value")) 
Randomize
'用于产生五位随机数
RanNum = Int(90000*rnd)+10000
select case upload_type
	case 0
		call upload_0()
	case 1
		call upload_1()
end select
'===========================风声无组件上传===========================
sub upload_0()
	dim upload,send_time,filename,oldname,rs,errr
	dim u_file,f_name,temp_var
	Set upload=new UpLoadClass
	send_time=now()
	upload.MaxSize  = file_maxsize
	upload.FileType = ""
	if server_name="/" then
		upload.Savepath = upload_folder
	else
		upload.Savepath =replace(server_name & upload_folder,"//","/")
	end if
	upload.autosave = 2
	upload.open
	u_file=upload.form("filename")
	if instr(u_file,";")<>0 then
		temp_var=split(u_file,";")
		select case ubound(temp_var)
			case 0
				f_name=temp_var(0)
			case else
				f_name=temp_var(0)
				f_form=temp_var(1)
		end select
	end if
	if f_name="" or f_name="[one]" then
		filename=year(send_time) & right("0" & month(send_time),2) & right("0" & day(send_time),2) & right("0" & hour(send_time),2) & right("0" & minute(send_time),2) & right("0" & second(send_time),2) & RanNum
		filename=filename  & "." & upload.form("file1_ext") 
	else
		if f_name="[name]" then
			filename=upload.form("file1_name")
		else
			filename=f_name & "." & upload.form("file1_ext") 
		end if
	end if
	if db_getvalue("file_id='" & filename & "'","sys_uploadfile","file_id")<>"" then
		response.write "文件已经存在 [ <a href='" & url_path & "upload.asp?filename=" & upload.form("filename") & "'>重新上传</a> ]"
		response.end
	end if
	if upload.form("add_detail")<>"" then
		'取得各种参数
		file_title=upload.Form("file_title")
		file_desc=upload.Form("file_desc")
		'检查录入的数据!
		if file_title="" then
			err_msgbox "没有输入图片名称!"
		end if
	end if
	errr=upload.save("file1",filename)
	if errr=false then
		select case upload.form("file1_err") 
			case -1
				Response.Write "请先选择你要上传的文件[ <a href='" & url_path & "upload.asp?filename=" & upload.form("filename") & "'>重新上传</a> ]"
			case 1
				Response.Write "文件大小超过了限制 " & ((file_maxsize/1024)\1024) & " M[ <a href='" & url_path & "upload.asp?filename=" & upload.form("filename") & "'>重新上传</a> ]"
			case 2
				Response.Write "文件类型不正确[ <a href='" & url_path & "upload.asp?filename=" & upload.form("filename") & "'>重新上传</a> ]"
			case 3
				Response.Write "文件超过大小,类型不正确[ <a href='" & url_path & "upload.asp?filename=" & upload.form("filename") & "'>重新上传</a> ]"
			case else
				Response.Write "意外错误！[ <a href='" & url_path & "upload.asp?filename=" & upload.form("filename") & "'>重新上传</a> ]"
		end select
		response.end
	end if
	if f_form<>"" then
		response.write "<script>parent.document.forms(0)." & f_form & "upload_file.value+='" & upload.form("file1_name") & "||';parent.document.forms(0)." & f_form & ".value+='" & upload.form("file1") & "||'</script>"
	else
		response.write "<script>parent.document.forms(0).upload_file.value+='" & upload.form("file1_name") & "||';parent.document.forms(0).upload_id.value+='" & upload.form("file1") & "||'</script>"
	end if
	response.write "文件上传成功 "
	if f_name="" or f_name="[name]" then
		response.write "[ <a href='" & url_path & "upload.asp?filename=" & upload.form("filename") & "'>继续上传</a> ]"
	end if
	file_id=upload.form("file1")
	file_name=upload.form("file1_name")
	file_size=upload.form("file1_size")
	file_path=upload_folder
	file_owner=request.cookies("user_id")
	file_date=send_time
	file_use=false
	input_label="file_id|+|file_name|+|file_size|+|file_path|+|file_owner|+|file_date|+|file_title|+|file_desc|+|file_use"
	input_value=file_id & "|+|" & file_name & "|+|" & file_size & "|+|" & file_path & "|+|" & file_owner & "|+|" & file_date & "|+|" & file_title & "|+|" & file_desc & "|+|" & file_use
	call db_save("add","uploadfile",input_label,input_value,oper_edit)
	set upload=nothing
end sub
''---------------------------------------------------------------------------------------
''========================================ASP upload 上传组件=============================
sub upload_1()
	on error resume next
	dim upload,send_time,filename
	dim oldname,rs,savepath,errr,file1,maxsize
	dim u_file,f_name,temp_var
	Set upload=Server.CreateObject("Persits.Upload")
	send_time=now()
	MaxSize=file_maxsize	'最大可上传40M
	Upload.SetMaxSize MaxSize,true
	if server_name="/" then
		filepath = upload_folder
	else
		filepath =replace(server_name & upload_folder,"//","/")
	end if
	Savepath = server.mappath(filepath) & "\"
	Upload.ProgressID = Request.QueryString("PID")
	errr=upload.save
	if err.number=8 then
		Response.Write "文件大小超过了限制 " & ((file_maxsize/1024)\1024) & " M[ <a href='" & url_path & "upload.asp?filename=" & upload.form("filename") & "'>重新上传</a> ]"
		response.end
	end if
	if errr<1 then 
		Response.Write "请先选择你要上传的文件[ <a href='" & url_path & "upload.asp?filename=" & upload.form("filename") & "'>重新上传</a> ]"
		response.end
	end if
	set rs=server.CreateObject("adodb.recordset")
	for each file1 in upload.files
		u_file=upload.form("filename")
		if instr(u_file,";")<>0 then
			temp_var=split(u_file,";")
			select case ubound(temp_var)
				case 0
					f_name=temp_var(0)
				case else
					f_name=temp_var(0)
					f_form=temp_var(1)
			end select
		end if
		if f_name="" or f_name="[one]" then
			filename=year(send_time) & right("0" & month(send_time),2) & right("0" & day(send_time),2) & right("0" & hour(send_time),2) & right("0" & minute(send_time),2) & right("0" & second(send_time),2) & RanNum
			filename=filename  & file1.ext
		else
			if f_name="[name]" then
				filename=file1.filename
			else
				filename=f_name & file1.ext
			end if
		end if
		if upload.form("add_detail")<>"" then
			'取得各种参数
			file_title=upload.Form("file_title")
			file_desc=upload.Form("file_desc")
			'检查录入的数据!
			if file_title="" then
				err_msgbox "没有输入图片名称!"
			end if
			''-----------------------------------------------------------------------------------
		end if
		if file1.size=0 then
			response.write "文件大小不能为“0” [ <a href='" & url_path & "upload.asp?filename=" & upload.form("filename") & "'>重新上传</a> ]"
			response.end
		end if
		if db_getvalue("file_id='" & filename & "'","sys_uploadfile","file_id")<>"" then
		response.write "文件已经存在 [ <a href='" & url_path & "upload.asp?filename=" & upload.form("filename") & "'>重新上传</a> ]"
		response.end
		end if
		if f_form<>"" then
			response.write "<script>parent.document.forms(0)." & f_form & "upload_file.value+='" & file1.filename & "||';parent.document.forms(0)." & f_form & ".value+='" & filename & "||'</script>"
		else		
			response.write "<script>parent.document.forms(0).upload_file.value+='" & file1.filename & "||';parent.document.forms(0).upload_id.value+='" & filename & "||'</script>"
		end if
		response.write "文件上传成功 "
		if f_name="" or f_name="[name]" then
			response.write "[ <a href='" & url_path & "upload.asp?filename=" & upload.form("filename") & "'>继续上传</a> ]"
		end if
		file1.saveas Savepath & filename
		
		file_id=filename
		file_name=file1.filename
		file_size=file1.size
		file_path=upload_folder
		file_owner=request.cookies("user_id")
		file_date=send_time
		file_use=false
		input_label="file_id|+|file_name|+|file_size|+|file_path|+|file_owner|+|file_date|+|file_title|+|file_desc|+|file_use"
		input_value=file_id & "|+|" & file_name & "|+|" & file_size & "|+|" & file_path & "|+|" & file_owner & "|+|" & file_date & "|+|" & file_title & "|+|" & file_desc & "|+|" & file_use
		call db_save("add","uploadfile",input_label,input_value,oper_edit)
		
	next
	set upload=nothing
	set rs=nothing
end sub
%>
<script language="javascript">
parent.document.all("upload_form<%=f_form%>").height=22
</script>
</body>
</html>