<%@ codepage=65001%>
<!--#include file="system.inc"-->
<%
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''	文档作用：用于设置各种公用参数，公用函数，连接数据库,配置系统参数.
''	创建时间：2005-8-27
''	修改情况：	
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''on error resume next
dim conn,root_path,url_path,xml_temp_str
''检查,是否有未关闭的的RS对象,如有进行关闭,以释放内存; 
if isobject(rs) then
	if rs.state=1 then
		rs.close
	end if
	set rs=nothing 
end if 
if isobject(rs1) then
	if rs1.state=1 then
		rs1.close
	end if
	set rs1=nothing 
end if 
if isobject(rs_list) then
	if rs_list.state=1 then
		rs_list.close
	end if
	set rs_list=nothing 
end if
if isobject(conn) then
	conn.close
	set conn=nothing
end if
root_path=Server.MapPath(server_name) 
call conn_data()
'response.write "网站暂停使用3分钟,进行数据转换!"
'response.end
Session.timeout = 120
response.buffer=server_server			'设置缓存
server.ScriptTimeout=server_runtime		'设置脚本运行时间 
if request.cookies("language")="" then
default_language=db_getvalue("setup_name='default_language'","sys_setup","setup_value")
response.cookies("language")=default_language
response.Cookies("language").expires=date()+1
end if
'''''''''''''''''''''''''
''	下面函数用于连接据库
'''''''''''''''''''''''''
sub conn_data()
	db_path=root_path & "\db\INFO#web#20060621.asa" 
	Set conn = Server.CreateObject("ADODB.Connection")
	connstr="Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & db_path 
	'如果你的服务器采用较老版本Access驱动，请用下面连接方法
	'connstr="driver={Microsoft Access Driver (*.mdb)};dbq=" & db_path 
	conn.Open connstr
end sub
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''检查管理员的权限
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''
sub check_admin()
	dim rs,sql
	set rs=server.createobject("adodb.recordset")
	if session("admin_id")="" then
		call turn_login()
		response.end
	end if
	sql="select * from admin where admin_id='" & session("admin_id") & "' and password='" & session("admin_password") & "'"
	rs.open sql,conn,1,1
	if rs.eof then
		call turn_login()
		response.end
	end if
	view_content=rs("content")
	view_product=rs("product")
	view_book=rs("book")
	view_class=rs("class")
	view_lyb=rs("lyb")
	view_personal=rs("personal")
	rs.close
	set rs=nothing
end sub
sub turn_login()
	
	for each form_name in request.Form
		response.Cookies("form")(form_name)=ufomail_request("form",form_name)
		'response.write ufomail_request("form",form_name)
	next
	if request.ServerVariables("url")<>"/admin/password_edit.asp" then
	session("turn_url")=request.ServerVariables("url") & "?" & request.ServerVariables("QUERY_STRING")
	else
	session("turn_url")=""
	end if
	response.write "<script language="
	response.write "'javascript'>" & vbCRLF
	response.write "top.location='" & url_path & "admin/login.asp';" & vbCRLF
	response.write "</script>"  & vbCRLF
end sub
'''''''''''''''''''''''''''''''
''	检查是否登录
'''''''''''''''''''''''''''''''
''密码错误,直接跳到错误页;成功登录返回用户类型;
dim user_id,user_password
function check_login()
	user_id=request.cookies("user_id")
	user_password=request.cookies("user_password")
	if user_id="" or user_password="" then
		response.redirect url_path & "login.asp?url=" & request.ServerVariables("URL") & "?" & request.ServerVariables("QUERY_STRING")
		response.end
		exit function
	end if
	set rs=server.CreateObject("adodb.recordset")
	sql="select user_status,user_style,user_password from user_basic where user_id='" & user_id & "'"
	rs.open sql,conn,1,1
	if rs.eof then
		rs.close
		set rs=nothing
		response.redirect url_path & "login.asp?url=" & request.ServerVariables("URL") & "?" & request.ServerVariables("QUERY_STRING")
		exit function
	else
		if rs("user_password")<>user_password then
			rs.close
			set rs=nothing
			response.redirect url_path & "login.asp?url=" & request.ServerVariables("URL") & "?" & request.ServerVariables("QUERY_STRING")
			exit function
		end if
		if rs("user_status")<>0 then
			err_msgbox "你的账号被锁定!"
			rs.close
			set  rs=nothing
			exit function
		end if
		check_login=rs("user_style")
		rs.close
		set rs=nothing
		exit function
	end if
end function
''''''''''''''''''''''''''''''''''' 
''	返回错误提示!
'''''''''''''''''''''''''''''''''''
''函数作用:返回对应的错误提示,然后跳回原页面.
''返回值:无
sub err_msgbox(err_text)
	dim e_text
	e_text=err_text
	response.write "<script language="
	response.write "'javascript'>" & vbCRLF
	response.write "window.alert('" & e_text & "');"
	response.write "history.go(-1);"
	response.write "</script>"
	response.end
end sub 
''''''''''''''''''''''''''''''''''' 
''	返回错误提示!
'''''''''''''''''''''''''''''''''''
''函数作用:返回对应的错误提示,然后关闭窗口.
''返回值:无
sub err_alert(err_text)
	dim e_text
	e_text=err_text
	response.write "<script language="
	response.write "'javascript'>" & vbCRLF
	response.write "window.alert('" & e_text & "');"
	response.write "window.close();"
	response.write "</script>"
	response.end
end sub 
'''''''''''''''''''''''''''''''''''''
'操作判断,
sub comfirm(msg,true_text,false_text)
	response.write "<script language='JavaScript'>"
	response.write "var ufo=window.confirm('" & msg & "');"
	response.write "if (ufo){" & true_text & ";}"
	response.write "else { " & false_text & ";}"
	response.write "</script>"
	response.end
end sub
''----------------------------------------------------------------------------------------------------------------
''---发送电邮公共函数-------------------------------------------------------------------------------------------------------------
''----------------------------------------------------------------------------------------------------------------
''--函数用途:用于发送电邮.
''--函数参数说明:
''--函数需要把所有人名自动根据数据库:user_basic的数据转换为对应的电邮地址
''--m_to:发送给谁;格式如下:"朱祺艺;刘晃;anna;"
''--m_from:发件人的电邮地址"朱祺艺"
''--m_cc:抄送给:"朱祺艺;刘晃;anna;"
''--m_subject:电邮主题    
''--m_body:电邮内容 
''--m_importance:电邮优先级(数字) :  0|1|2
''--m_title:电邮的简单     
''--m_url:电邮相关的网址 
sub send_email(mm_to,mm_from,mm_cc,mm_subject,mm_body,mm_title,mm_url,mm_importance)
	on error resume next 
	dim m_to,m_from,m_cc
	dim m_subject,m_body,m_title
	dim m_url,m_importance
	dim mail
	dim email_account,email_password,email_accepter,email_accepter_name
	m_to=mm_to
	m_from=mm_from
	m_cc=mm_cc
	m_subject=mm_subject
	m_body=mm_body
	m_title=mm_title
	m_url=mm_url
	m_importance=mm_importance
	'设置默认的电邮主题:
	if m_subject="" then
		m_subject="客户通知!!"
	end if
	'设置默认的电邮优先级:
	if m_importance=""  then
		m_importance=1
	end if
	'设置默认的电邮内容:
	if m_body="" then
		m_body=m_body & "<html><head><title>e-mail</title><meta http-equiv='Content-Type' content='text/html; charset=utf-8'>"
		m_body=m_body & "<style type='text/css'>"
		m_body=m_body & "<!--"
		m_body=m_body & "body {font-size: 9pt;}"
		m_body=m_body & "p {text-indent: 2em;}"
		m_body=m_body & "ul {list-style-type: square;font-size: 12pt;color: #003366;}"
		m_body=m_body & "-->"
		m_body=m_body & "</style></head><body bgcolor='#FFFFFF' text='#000000'>"
		m_body=m_body & "<p><br>TO:<font color='dodgerblue'>" & m_to & "</font><br>CC:<font color='dodgerblue'>" & m_cc & "</font><br>FROM:<font color='dodgerblue'>" & m_from & "</font><br>TIME:<font color='dodgerblue'>" & now() & "</font></p>"
		m_body=m_body & "<p>你好！</p><p>" & url_path & "提醒你注意以下事项：</p><ul><LI>" & m_title & "</LI></ul>"
		m_body=m_body & "<p>您可以点击下面链接查看详细资料：</p>"
		m_body=m_body & "<p><a href='" & m_url & "' target='_blank'>" & m_url & "</a></p><p><br>"
		m_body=m_body & "--------------------------------------------------------------------------------<br>"
		m_body=m_body & "" & url_path & "</body></html>"
	else
		m_body=m_body & "<hr size='1'>"
		m_body=m_body & "&copy; " & url_path & "</body></html>"
	end if
	
	'设置默认的电邮收件人地址: 
	if m_to="" or isnull(m_to) then
		m_to=mail_server_manager
	end if
	'设置默认的电邮发件人地址: 
	if m_from="" then
		m_from=mail_server_manager
	end if
	email_account=db_getvalue("setup_name='email_account'","sys_setup","setup_value")
	email_password=db_getvalue("setup_name='email_password'","sys_setup","setup_value")
	email_accepter=db_getvalue("setup_name='email_accepter'","sys_setup","setup_value")
	email_accepter_name=db_getvalue("setup_name='email_accepter_name'","sys_setup","setup_value")
	select case mail_server_style
		case "ASPmail"
			'-------------ASPmail-------------------------------------------------- 
			Set Mail1 = Server.CreateObject("Persits.MailSender")
			Mail1.Host="smtp." & get_right(email_account,"@")
			'mail1.host="txmaimai"
			Mail1.Username=get_left(email_account,"@")
			Mail1.password=email_password
			email_address=split(m_to,";")
			for each e_address in email_address
				mail1.AddAddress e_address
			next
			mail1.from=m_from
			email_address=split(m_cc,";")
			for each e_address in email_address
				mail1.Addcc e_address
			next
			mail1.CharSet = "UTF-8"
			mail1.ContentTransferEncoding = "Quoted-Printable"
			mail1.subject="" & Mail1.EncodeHeader(m_subject, "utf-8")
			mail1.body=m_body
			mail1.IsHTML=true
			mail1.send
			set mail1=nothing
			'---------------------------------------------------------------------
		case "CDONTS"
			'-------------CDONTS-------------------------------------------------- 
			set mail1=Server.Createobject("CDONTS.NewMail")
			mail1.to=m_to
			mail1.from=m_from
			mail1.cc=m_cc
			mail1.subject="" & m_subject
			mail1.body=m_body
			mail1.bodyFormat=0
			mail1.mailFormat=0
			mail1.importance=m_importance
			mail1.send
			set mail1=nothing
			'---------------------------------------------------------------------
		case "Jmail"
			'-------------Jmail-------------------------------------------------- 
			Set Mail1 = Server.CreateObject("JMAIL.Message")
			Mail1.silent = true
			Mail1.Logging = true
			Mail1.Charset = "utf-8"
			Mail1.ContentType = "text/html"
			'Mail1.ServerAddress=mail_server_host
			mail_server_host="smtp." & get_right(email_account,"@")
			Mail1.maildomain=mail_server_host
			Mail1.FromName=email_accepter_name
			Mail1.MailServerUserName=email_account
			Mail1.MailServerPassword=email_password
			Mail1.Priority = 3
			email_address=split(m_to,";")
			for each e_address in email_address
				temp_str=trim(cstr(e_address))
				if temp_str<>"" and not isnull(temp_str) then
					mail1.AddRecipient temp_str
				end if 
			next
			mail1.from=email_account
			'email_address=split(m_cc,";")
			'for each e_address in email_address
			'	mail1.Addcc e_address
			'next
			mail1.subject="" & m_subject
			mail1.body=m_body
			
			if not mail1.send(mail_server_host) then
				'发送不成功,就记录为LOG文件
				MyFileName = root_path & "\email_log.htm"
				Set FSO = Server.CreateObject("Scripting.FileSystemObject")
				Set TS = FSO.OpenTextFile(MyFileName, 8, true)
				TS.write "<pre>" & mail1.log & "</pre>"
				TS.Writeline "<hr/>"
				TS.close
				Set TS = Nothing
				Set FSO = Nothing
			end if
			mail1.close
			set mail1=nothing		
			'---------------------------------------------------------------------
	end select
end sub
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''	根据id,来获得数据库对应的值。
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' db_id:
'' db_table:
'' db_label:
function db_getvalue(db_id,db_table,db_label)
	on error resume next 
	dim id,table,label,rs,sql
	id=db_id
	table=db_table
	label=db_label
	db_getvalue=""
	set rs=server.CreateObject("adodb.recordset")
	sql="select " & label & " from " & table & " where " & db_id
	rs.open sql,conn,1,1
	if not rs.eof then
		db_getvalue=rs(0)
	else
		db_getvalue=""
	end if
	rs.close
	set rs=nothing
end function
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''	获得网址
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''  
''主要是配合用于虚拟目录运行方式的 
function get_url()
	if server_name="/" then
		get_url=request.ServerVariables("url")
	else
		get_url=replace(request.ServerVariables("url"),server_name,"")
	end if
end function
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''	用于录入增加或修改数据库。
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''	oper_style:	edit|add ;
''	oper_table: table_name
''	oper_label: 字段1|+|字段2
''	oper_value: 字段1|+|字段2
''	oper_edit: 字段=值
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
sub db_save(oper_style,oper_table,oper_label,oper_value,oper_edit)
	on error resume next
	dim o_style,o_table,o_label,o_value,rs,sql,Criteria,rs_table,errr,rs_fields,i,o_edit
	o_style=oper_style
	o_table=oper_table
	o_label=oper_label
	o_value=oper_value
	o_edit=oper_edit
	errr=true
	Criteria = Array(Empty, Empty, Empty, "TABLE") 
	if o_label="" then
		err_msgbox "没有输入相对项名。"
	end if
	if o_value="" then
		err_msgbox "没有输入相对应的值。"
	end if
	if o_style="edit" and o_edit="" then
		err_msgbox "请输入修改的条件"
	end if
	if right(o_label,3)="|+|" then o_label=left(o_label,len(o_label)-3)
	if right(o_value,3)="|+|" then o_value=left(o_value,len(o_value)-3)
	o_label=split(o_label,"|+|")
	o_value=split(o_value,"|+|")
	if ubound(o_label)<>ubound(o_value) then
		err_msgbox "oper_label:" & oper_label & "\noper_value:" & oper_value & "\n数值对应不上？"
	end if
	Set rs_table = conn.OpenSchema(20, Criteria)
	do while not rs_table.eof
		if o_table=rs_table("TABLE_NAME") then
			errr=false
		end if
	rs_table.movenext
	loop
	set rs_table=nothing
	if errr=true then
		err_msgbox "数据库中不存在表：" & o_table
	end if
	set rs=server.createobject("adodb.recordset")
	if o_style="add" then
		sql="select * from " & o_table
	else
		sql="select * from " & o_table & " where " & o_edit
	end if
	rs.open sql,conn,1,3
	if o_style="add" then
		rs.addnew
	else
		if rs.eof then
			rs.addnew
		end if
	end if
	'' 检验字段名，字段类型是否与输入相符。
	if not rs.eof or o_style="add" then
	set rs_fields=rs.fields
	for i=0 to ubound(o_label)
		'err_msgbox rs_fields.item(o_label(i)).name
		if rs_fields.item(o_label(i)).name<>o_label(i) then
			err_msgbox "数据表[" & o_table & "]中没有[" & o_label(i) & "]字段"
		else
			if o_value(i)<>"" then
				rs(o_label(i))=replace(o_value(i),"''","'")
			else
				rs(o_label(i))=N
			end if
		end if
	next 
	rs.update
	end if
	select case err.number
		case 0,53
		case -2147217873
		err_msgbox "数据库中已有重复的字段，请改换进行输入！"
		'case -2147217887
		'err_msgbox "类型不匹配！"
		case else
		response.write o_table & "<br>"
		response.write oper_label & "<br>"
		response.write oper_value & "<br>"
		response.write oper_edit & "<br>"
		'response.end
		err_msgbox "Error # " & CStr(Err.Number) & " " & Err.Description
	end select
	rs.close
	set rs=nothing
end sub
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'''	帮助入口
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
sub show_help()
	response.write "<a href='" & url_path & "help/help_add.asp?id=" & get_url() & "' target='_blank'><img id=help_pic src='" & view_style.item("sys_help") & "' width='45' height='18' style='cursor:hand' border='0'></a>"
end sub
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'''	历史记录
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''str:	表名||ID 
sub show_history(str)
	dim history_id
	history_id=str
	response.write "<img src='" & view_style.item("sys_history") & "' align='absmiddle'> "
    response.write "<a href='" & url_path & "system/history_view.asp?id=" & history_id & "' target='_blank'>事件</a>"
end sub
''---------------------------------------------------------------------------------------------
''--------------检查文件是否正被人打开
''---------------------------------------------------------------------------------------------
''s_filename:检查打开的文件名(完整路径) 
''返回值:2代表未找到文件,1代表文件正被打开,0代表文件正常 
function file_ifopen(s_filename)  
	on error resume next
	dim fso,f1,filename,temp
	filename=s_filename
	set fso=CreateObject("Scripting.FileSystemObject")
	if fso.fileexists(filename) then
		set f1=fso.getfile(filename)
		temp=f1.name
		f1.name="ufotest"
		f1.name=temp
		set f1=nothing
	else
		file_ifopen=2
		exit function
	end if
	select case err.number
		case 58
			file_ifopen=1
		case else
			file_ifopen=0
	end select
end function
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''	删除文件
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''' 
''s_file_path:检查打开的文件名(完整路径) 
sub file_delete(s_file_path) 
	dim fso,file_path
	file_path=s_file_path
	if file_path="" then
		err_msgbox "没有输入路径!"
	end if 
	select case file_ifopen(file_path)
		case 1
			err_msgbox "文件正在操作!"
		case 2
			err_msgbox "文件不存在,无法删除!"
	end select
	set fso=CreateObject("Scripting.FileSystemObject")
	fso.DeleteFile file_path 
end sub
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''获得文件路径
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''
function file_show(file_s)
	dim rs,sql,file_id
	file_id=file_s
	if file_id="" then 
		file_show=""
		exit function
	end if
	if instr(file_id,"||")<>0 then
		file_id=replace(file_id,"||","")
	end if
	set rs=server.createobject("adodb.recordset")
	sql="select file_id,file_path from uploadfile where file_id='" & file_id & "' and file_use=true"
	rs.open sql,conn,1,1
	if not rs.eof then
		file_show=rs("file_path") & rs("file_id")
		file_show=replace(file_show,"//","/")
	else
		file_show=""
	end if
	rs.close
	set rs=nothing
end function
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''	移动文件
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''s_file:原文件名称
''d_file:移动后更改的名称,如不修改留空.
''d_path:欲移到的目标路径(使用相对路径).
sub file_move(s_file,d_file,d_path)
	dim rs,fso,old_filename,old_filepath,new_filename,new_filepath,sql,temp_path
	old_filename=s_file
	new_filename=d_file
	new_filepath=d_path
	if old_filename & "1"="1" then
		err_msgbox "没有源文件,无法操作!"
	end if
	set fso=CreateObject("Scripting.FileSystemObject")
	set rs=server.CreateObject("adodb.recordset")
	sql="select * from uploadfile where file_id='" & old_filename & "'"
	rs.open sql,conn,1,1
	if rs.eof then
		err_msgbox "数据库中无相关记录!无法进行操作!"
	end if
	old_filepath=root_path & "\" & rs("file_path") & rs("file_id")
	old_filepath=replace(old_filepath,"/","\")
	if file_ifopen(old_filepath)<>0 then
		err_msgbox "原文件正在打开,或被锁定,无法进行操作!"
	end if
	if new_filename<>"" then
		temp_path=root_path & "\" & new_filepath & new_filename
	else
		temp_path=root_path & "\" & new_filepath & old_filename
	end if
	temp_path=replace(temp_path,"/","\")
	if file_ifopen(temp_path)<>2 then
		err_msgbox "目标文件夹已有同名的文件,请重新命名!"
	end if
	if new_filename & "1"="1" then
		input_label="file_path"
		input_value=replace(new_filepath,"\","/")
	else
		input_label="file_id|+|file_path|+|"
		input_value=new_filename & "|+|" & replace(new_filepath,"\","/") & "|+|"
	end if
	call db_save("edit","sys_uploadfile",input_label,input_value,"file_id='" & old_filename & "'")
	fso.COPYFile old_filepath,temp_path
	fso.DeleteFile old_filepath
end sub
function htmlencode2(str)
	dim result
	dim l
	if isNULL(str) then 
		htmlencode2=""
		exit function
	end if
	l=len(str)
    result=""
	dim i
	for i = 1 to l
		select case mid(str,i,1)
			case "<"
				result=result+"&lt;"
			case ">"
				result=result+"&gt;"
			case chr(13)
				result=result+"<br>"
			case chr(34)
				result=result+"&quot;"
			case "&"
				result=result+"&amp;"
			case chr(32)
				'result=result+"&nbsp;"
				if i+1<=l and i-1>0 then
					if mid(str,i+1,1)=chr(32) or mid(str,i+1,1)=chr(9) or mid(str,i-1,1)=chr(32) or mid(str,i-1,1)=chr(9)  then	                      
						result=result+"&nbsp;"
					else
						result=result+" "
					end if
				else
					result=result+"&nbsp;"	                    
				end if
			case chr(9)
				result=result+"    "
			case else
				result=result+mid(str,i,1)
		end select
	next 
	htmlencode2=result
end function
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''	将HTML语句转回输入框
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' 
function textencode(s_str)
	dim temp_str
	temp_str=s_str
	if isnull(temp_str) then
		textencode=""
		exit function
	end if
	if temp_str="" then 
		textencode=""
		exit function
	end if
	temp_str=replace(temp_str,"<br>",chr(13))
	temp_str=replace(temp_str,"&nbsp;"," ")
	textencode=temp_str
end function
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''	用于取得取得指字符串左边的字符串
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' m_input:输入的字符串
'' split_str:分隔的字签名串
function get_left(m_input,split_str)
	if instr(m_input,split_str)<>0 then
		get_left=left(m_input,instr(m_input,split_str)-1)
	else
		get_left=m_input
	end if
end function
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''	用于取得取得指字符串右边的字符串
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' m_input:输入的字符串
'' split_str:分隔的字签名串 
function get_right(m_input,split_str)
	if instr(m_input,split_str)<>0 then
		get_right=right(m_input,len(m_input)-instr(m_input,split_str)-len(split_str)+1)
	else
		get_right=m_input
	end if
end function
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''  上传文件后将文件的相关信息存放入数据库file表中. 
''	然后返回file表id给所设置的字段:input_name 
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''	为了增加这个控件的通用性及功能,将u_name的格式定为:"文件名;表单名称;是否显示找查按钮;是否显示详情;" 
''	按顺序依次调用,用;号隔开每个参数
''  u_name_文件名.当u_name的值为:"[name]"时，上传的文件不改名。当u_name的值为:"[one]"时，只上传一份文件,其它值为新上传文件的文件名,为空值时,系统自动重命名(根据日期加随机数)。  
''	u_name_表单名称,可以指定所应用表单的名称,为空时可以使用默认的upload_id得到上传后的文件名,不为空时,通过设置的值去取得文件名,如设为ECR_file,则可以通过request.form("ECR_file")  
''	u_name_是否显示详情:为空是为显示,设为TRUE时显示,设为False时不显示
''	u_name_是否显示找查按钮:为空时显示,设为TRUE时显示,设为FALSE时不显示  
''	u_width:上传文件后文件名的显示框的宽度 
''	u_height:上传文件后文件名的显示框的高度 
''	通过隐藏的upload_id	对话框传递变量     
''  u_input:可以输入的文件格式，如果为空，就不限制文件格式；
''	
sub upload_box(u_name,u_width,u_height,u_input)
	dim width,height,new_name,input_file,temp_var
	dim f_name,f_form,f_search,f_detail
	new_name=u_name
	input_file=u_input
	if instr(new_name,";")<>0 then
		temp_var=split(new_name,";")
		select case ubound(temp_var)
			case 0
				f_name=temp_var(0)
			case 1
				f_name=temp_var(0)
				f_form=temp_var(1)
			case 2
				f_name=temp_var(0)
				f_form=temp_var(1)
				f_search=temp_var(2)
			case else
				f_name=temp_var(0)
				f_form=temp_var(1)
				f_search=temp_var(2)
				f_detail=temp_var(3)
		end select
	end if
	if new_name<>"" then new_name="?filename=" & new_name 
	width=u_width
	height=u_height
	if width=0 or width<220 then width="100%"
	response.write "<iframe id='upload_form" & f_form & "' name='upload_form' frameborder='0' width=" & width & " height='22' scrolling='no' src='" & url_path & "upload.asp" & new_name & "'></iframe>"
	if height<>0 then 
		response.write "<br><textarea name='" & f_form & "upload_file' style='width:" & width & ";height:" & height & ";border: 1px solid #999999;' readonly></textarea>"
	else
		response.write "<textarea name='" & f_form & "upload_file' style='display:none' readonly></textarea>"
	end if
	if f_form<>"" then
		response.write "<input type='hidden' name='"  & f_form & "' id='"  & f_form & "' value=''>"
	else
		response.write "<input type='hidden' name='upload_id' id='upload_id' value=''>"
	end if
	response.write "<input type='hidden' name='" & f_form & "upload_fileext' id='" & f_form & "upload_fileext' value='" & input_file & "'>"
end sub
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''	将upload_file表中的文件设为已用
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''	input_file 要更改的文件列表，多个文件用：“||”隔开 
''
sub upload_use(input_file)
	dim temp_str,upload_file,file_url
	upload_file=input_file
	if upload_file<>"" then
		temp_str=upload_file
		if right(temp_str,2)="||" then
			temp_str=left(temp_str,len(temp_str)-2)
		end if
		temp_str=replace(temp_str,"||","','")
		temp_str="'" & temp_str & "'"
		sql="update uploadfile set file_use=true where file_id in (" & temp_str & ") and file_use=false"
		conn.execute sql
	end if
end sub
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''	将upload_file表中的文件设为未用，即old_filelist上的文件，被删除后，将删除的文件记录取消。 
''	暂时将这个函数的作用屏蔽;
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''' 
''	old_filelist:修改前数据库中的文件列表，
''	new_filelist:修改后要输入数据库中的文件列表.
''	 
sub upload_unuse(old_filelist,new_filelist)  
	dim old_file,new_file,dele_file
	old_file=old_filelist
	new_file=new_filelist
	if old_file<>"" then  
		dele_file=""
		old_file=split(old_file,"||")
		for i=0 to ubound(old_file)
			if old_file(i)<>"" then
				if instr(new_file,old_file(i))=0 then
					if dele_file="" then
						dele_file="'" & old_file(i) & "'"
					else
						dele_file=dele_file & ",'" & old_file(i) & "'"
					end if
				end if
			end if
		next 
		if dele_file<>"" then
			sql="update uploadfile set file_use=false where file_id in (" & dele_file & ")"
			conn.execute sql
		end if
	end if
end sub
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''	已上传文件显示列表达。
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''	f_list,要显示的文件列表名,名字用“||”隔开	
''	f_output,对文件进行操作的<input type=checkbox name='f_output'>
''	f_style,文件列表显示的样式 
sub uploadfile_list(f_list,f_output,f_style)
	dim file_list,output_name,file_name,f_name,f_num
	file_list=f_list
	output_name=f_output
	show_style=f_style
	if show_style<>"" then
	else
	show_style="0"
	end if
	if file_list<>"" then
	else
		exit sub
	end if
	if output_name="" then
		output_name="upload_file"
	end if
	if right(file_list,2)="||" then
		file_list=left(file_list,len(file_list)-2)
	end if
	file_name=split(file_list,"||")
	
	select case show_style
		case "0"
			response.write "已上传的文件列表，如需删除请将文件后面的勾取消。<br><font color=blue>"
			f_num=0
			for each f_name in file_name
				f_num=f_num+1
				temp_file_name=db_getvalue("file_id='" & f_name & "'","uploadfile","file_name")
				response.write f_num & "、<a href='" & url_path & "pic_show.asp?file_id=" & f_name & "' target='_blank'>"
				if lcase(right(f_name,3))="jpg" or lcase(right(f_name,3))="gif" then
					response.write "<img src='" & url_path & db_getvalue("file_id='" & f_name & "'","uploadfile","file_path") & f_name & "' width='160' border='1'></a>"
				else
					response.write temp_file_name & " </a>"
				end if
				real_name=db_getvalue("file_id='" & f_name & "'","uploadfile","file_title")
				if real_name<>"" and real_name<>temp_file_name then
				response.write "(" & real_name & ")-- "
				else
				response.write "-- "
				end if
				response.write "<input type='checkbox' name='" & output_name & "' value='" & f_name & "' checked></input><br>"
			next 
			response.write "</font><hr size=1>"
		case "1"
			f_num=0
			for each f_name in file_name
				f_num=f_num+1
				temp_file_name=db_getvalue("file_id='" & f_name & "'","uploadfile","file_name")
				response.write "<li>" & f_num & "、<a href='" & url_path & "pic_show.asp?file_id=" & f_name & "' target='_blank'><font color=blue>"
				response.write temp_file_name & " </font></a>"
				real_name=db_getvalue("file_id='" & f_name & "'","uploadfile","file_title")
				if real_name<>"" and real_name<>temp_file_name then
				response.write "(" & real_name & ")"
				end if
			next
		case "2"
			'用于展示图片
			f_num=0
			xml_temp_str=xml_temp_str & "<table border='0' width='" & 160*3 & "'><tr>"
			for each f_name in file_name
				if f_num mod 3=0 and f_num<>0 then
					xml_temp_str=xml_temp_str & "</tr><tr>"
				end if
				f_num=f_num+1
				temp_file_name=db_getvalue("file_id='" & f_name & "'","uploadfile","file_name")
				xml_temp_str=xml_temp_str & "<td align='center' valign='top'><a href='" & file_show(f_name) & "' target='_blank'><img src='" & url_path & db_getvalue("file_id='" & f_name & "'","uploadfile","file_path") & "/" & f_name & "' width='160' border='0' alt='" & temp_file_name & "'></a>"
				real_name=db_getvalue("file_id='" & f_name & "'","uploadfile","file_title")
				if real_name<>"" and real_name<>temp_file_name then
					xml_temp_str=xml_temp_str & "<br>" & real_name 
				else
					xml_temp_str=xml_temp_str & "<br>" & temp_file_name 
				end if
				xml_temp_str=xml_temp_str & "</td>"
			next
			xml_temp_str=xml_temp_str & "</tr></table>"
	end select
end sub
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''	根据系统时间及随机数产生编号
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''
function create_code()
	dim send_time,h_date,h_time,RanNum
	Randomize
	'用于产生五位随机数
	RanNum = Int(90000*rnd)+10000
	send_time=now()
	h_date=right(year(send_time),2) & right("0" & month(send_time),2) & right("0" & day(send_time),2) 
	h_time=right("0" & hour(send_time),2) & right("0" & minute(send_time),2) & right("0" & second(send_time),2)
	create_code=hex(h_date) & "-" & hex(h_time) & "-" & hex(RanNum)
end function
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''调用方法 DelStr(值)，防止SQL注入攻击	
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'
Function DelStr(Str)
	If IsNull(Str) Or IsEmpty(Str) Then
		Str	= ""
	End If
	DelStr	= Replace(Str,";","")
	DelStr	= Replace(DelStr,"'","")
	DelStr	= Replace(DelStr,"&","")
	DelStr	= Replace(DelStr," ","")
	DelStr	= Replace(DelStr,"　","")
	DelStr	= Replace(DelStr,"%20","")
	DelStr	= Replace(DelStr,"--","")
	DelStr	= Replace(DelStr,"==","")
	DelStr	= Replace(DelStr,"<","")
	DelStr	= Replace(DelStr,">","")
	DelStr	= Replace(DelStr,"%","")
End Function
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Function ReplaceText(HTML_STR)
  Dim regEx, str1					' 建立变量。
  str1 = HTML_STR
  Set regEx = New RegExp			' 建立正则表达式。
  regEx.IgnoreCase = true					' 设置是否区分大小写。
  regEx.Global = True	
  regEx.Pattern = "<br><br>"					' 设置模式。  
  str1= regEx.Replace(str1, "<br>")		' 作替换。
  regEx.Pattern = "<table[^>]*>"				' 设置模式。  
  str1= regEx.Replace(str1, "")			' 作替换。
  regEx.Pattern = "</table>"					' 设置模式。  
  str1= regEx.Replace(str1, "")			' 作替换。
  regEx.Pattern = "<tr[^>]*>"					' 设置模式。  
  str1= regEx.Replace(str1, "")			' 作替换。
  regEx.Pattern = "</tr>"					' 设置模式。  
  str1= regEx.Replace(str1, "")			' 作替换。
  regEx.Pattern = "<td[^>]*>"					' 设置模式。  
  str1= regEx.Replace(str1, "	")		' 作替换。
  regEx.Pattern = "</td>"					' 设置模式。  
  str1= regEx.Replace(str1, "")			' 作替换。
  regEx.Pattern = "<th[^>]*>"					' 设置模式。  
  str1= regEx.Replace(str1, "")			' 作替换。
  regEx.Pattern = "</th>"					' 设置模式。  
  str1= regEx.Replace(str1, "")			' 作替换。
  regEx.Pattern = "<font[^>]*>"					' 设置模式。  
  str1= regEx.Replace(str1, "")			' 作替换。
  regEx.Pattern = "</font>"					' 设置模式。  
  str1= regEx.Replace(str1, "")			' 作替换。
  regEx.Pattern = "<div[^>]*>"					' 设置模式。  
  str1= regEx.Replace(str1, "")			' 作替换。
  regEx.Pattern = "</div>"					' 设置模式。  
  str1= regEx.Replace(str1, "")			' 作替换。
  regEx.Pattern = "<span[^>]*>"					' 设置模式。  
  str1= regEx.Replace(str1, "")			' 作替换。
  regEx.Pattern = "</span>"					' 设置模式。  
  str1= regEx.Replace(str1, "")			' 作替换。
  regEx.Pattern = "<hr[^>]*>"					' 设置模式。  
  str1= regEx.Replace(str1, "")			' 作替换。
  regEx.Pattern = "<IMG[^>]*>"					' 设置模式。  
  str1= regEx.Replace(str1, "")			' 作替换。
  regEx.Pattern = "<a[^>]*>"					' 设置模式。  
  str1= regEx.Replace(str1, "")			' 作替换。
  regEx.Pattern = "</a>"					' 设置模式。  
  str1= regEx.Replace(str1, "")			' 作替换。
  regEx.Pattern = "<P[^>]*>"					' 设置模式。  
  str1= regEx.Replace(str1, "")			' 作替换。
  regEx.Pattern = "</P>"					' 设置模式。  
  str1= regEx.Replace(str1, "<br>")		' 作替换。
  regEx.Pattern = "<tbody[^>]*>"				' 设置模式。  
  str1= regEx.Replace(str1, "")			' 作替换。
  regEx.Pattern = "</tbody>"					' 设置模式。  
  str1= regEx.Replace(str1, "")			' 作替换。
  ReplaceText=str1
End Function
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' 正则表达式,
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''patrn:查找模式
''strng:要查找的字符串
''返回值:true表示匹配;false表示不匹配;
function RegExpTest(patrn, strng)
	Dim regEx, retVal
	Set regEx = New RegExp
	regEx.Pattern = patrn
	regEx.IgnoreCase =true
	RegExpTest = regEx.Test(strng)
End function
Function RegExpExecute(patrn, strng)
  Dim regEx 
  Set regEx = New RegExp
  regEx.Pattern = patrn
  regEx.IgnoreCase = true
  regEx.Global = True
  set RegExpExecute = regEx.Execute(strng)
End Function
Function RegExpReplace(temp_str,patrn, replStr)
  Dim regEx, str1				' 建立变量。
  str1 = temp_str
  Set regEx = New RegExp					' 建立正则表达式。
  regEx.Pattern = patrn					' 设置模式。
  regEx.IgnoreCase = True					' 设置是否区分大小写。
  regEx.Global = True
  RegExpReplace = regEx.Replace(str1, replStr)			' 作替换。
End Function
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''获取网址的网页内容
''''''''''''''''''''''''''''''''''''''''''''''''''''''''
function getHTTPPage(url)
    dim Http,user_cookies,bintou,checkcoder
	'user_cookies=request.ServerVariables("HTTP_COOKIE")
    set Http=server.createobject("Msxml2.XMLHTTP")
	url=replace(url,"&amp;","&")
	Http.open "GET",url,false
	'Http.setRequestHeader "Cookie",user_cookies
    Http.send()
    if Http.readystate<>4 then 
		getHTTPPage=""
        exit function
    end if
	getHTTPPage=Http.responseBody
	if lenb(getHTTPPage)>2 then
		bintou=LeftB(getHTTPPage,2)
		If AscB(MidB(bintou,1,1))=&HEF And AscB(MidB(bintou,2,1))=&HBB Then
			checkcoder="utf-8"
		ElseIf AscB(MidB(bintou,1,1))=&HFF And AscB(MidB(bintou,2,1))=&HFE Then
			checkcode="unicode"
		Else
			checkcode="gb2312"
		End If
	else
		checkcode="gb2312"
	end if
    getHTTPPage=bytesToBSTR(getHTTPPage,checkcode)
    set http=nothing
    if err.number<>0 then err.Clear 
end function


''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'代码转换
''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Function BytesToBstr(body,Cset)
        dim objstream
        set objstream = Server.CreateObject("adodb.stream")
        objstream.Type = 1
        objstream.Mode =3
        objstream.Open
        objstream.Write body
        objstream.Position = 0
        objstream.Type = 2
        objstream.Charset = Cset
        BytesToBstr = objstream.ReadText 
        objstream.Close
        set objstream = nothing
End Function

''''''''''''''''''''''''''''''''''''''''
''将获的ASP页面转为HTML页面并把页面存在HTML目录中
''web_url:要转换为excel的网址,该网页处理成一需要处理成一个表格的形式;
''html_name:生成的excel文件的临时文件名
function to_html(web_url,html_name)
	dim fso,temp_str
	exit function
	set fso=server.CreateObject("Scripting.FileSystemObject") 
	strExcelFile=root_path & "\html\" & html_name
	if fso.fileExists(strExcelFile) then 
		Set f = fso.GetFile(strExcelFile)
		if now()-f.DateLastModified<7 then
			to_excel=""
			exit function
		end if
	end if
	temp_str=getHTTPPage(web_url)
	temp_str=replace(temp_str,"src=""images/","src=""http://txmaimai.com/images/")
	temp_str=replace(temp_str,"src=""Images/","src=""http://txmaimai.com/images/")
	temp_str=replace(temp_str,"src=""link_logo/","src=""http://txmaimai.com/link_logo/")
	temp_str=replace(temp_str,"src=""template/","src=""http://txmaimai.com/template/")
	temp_str=replace(temp_str,"href=""","href=""http://txmaimai.com/")
	temp_str=replace(temp_str,"href=""http://txmaimai.com/http://","href=""http://")
	if fso.fileExists(strExcelFile) then fso.deletefile strExcelFile 
	Set xslFile = fso.CreateTextFile(strExcelFile , True) 
	xslFile.WriteLine(temp_str) 
	xslFile.Close 
	set fso=nothing 
	to_excel=strExcelFile
end function
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''	简繁转换
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
function gb2312_big5(cc)
	dim s,t,c,d,i,content
	content=cc
	if content="" or isnull(content) then
		gb2312_big5=""
		exit function
	end if
	 s=db_getvalue("setup_name='chart_gb'","sys_setup","setup_value")
	 t=db_getvalue("setup_name='chart_big5'","sys_setup","setup_value")
	c=split(s,",")
	d=split(t,",")
	for i=0 to 2555
	content=replace(content,c(i),d(i))
	next
	gb2312_big5=content
end function
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''	获得数值，并对数值进行处理
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
function ufomail_request(style,parm)
	dim s_style,parm_str,return_value
	s_style=style
	parm_str=parm
	select case lcase(s_style)
		case "form"
			return_value=request.form(parm_str)
			if return_value<>"" then
			return_value=Replace(return_value,"<[CDATA[","")
			return_value=Replace(return_value,"]]>","")
			'return_value=DelStr(return_value)
			end if
		case "querystring"
			return_value=request.querystring(parm_str)
			if return_value<>"" then
			return_value=Replace(return_value,"<[CDATA[","")
			return_value=Replace(return_value,"]]>","")
			'return_value=DelStr(return_value)
			end if
		case "cookies"
			return_value=request.cookies(parm_str)
	end select
	ufomail_request=return_value
end function
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''	更新程序文件
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
sub update_file(f_path)
	dim file_path,user_name,sys_version,sys_key,temp_str
	dim objStreamt,objStream
	file_path=f_path
	user_name=db_getvalue("setup_name='user_name'","sys_setup","setup_value")
	sys_version=db_getvalue("setup_name='sys_version'","sys_setup","setup_value")
	sys_key=db_getvalue("setup_name='user_key'","sys_setup","setup_value")
	temp_str=getHTTPPage("http://txmaimai.cn/infoweb/update/get_file.asp?user=" & user_name & "&key=" & sys_key & "&file=" & file_path)
	file_path=root_path & "/" & file_path
	file_path=replace(file_path,"/","\")
	file_path=replace(file_path,"\\","\")
	Set objStreamt = Server.CreateObject("ADODB.Stream")
	Set objStream = Server.CreateObject("ADODB.Stream")
	With objStream
		.Open
		.Charset = "utf-8"
		.Position = 0
		.WriteText temp_str
		.Position = 3
		objStreamt.open
		objStreamt.type = 1
		.CopyTo objStreamt
		objStreamt.SaveToFile file_path,2
		objStreamt.close
		.Close
	End With
	Set objStream = Nothing
end sub
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'''
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
function movie_player(url)
	'---------------------
	' write by 绿水青山
	'--------------------- 
	
	dim lurl,temp_str
	lurl=url
	temp_str=""
	select case Lcase(right(lurl,4))
		case ".swf"
			temp_str=temp_str & "" & vbCrlF
			temp_str=temp_str & "<object classid='clsid:D27CDB6E-AE6D-11cf-96B8-444553540000' codebase='http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,29,0' width='450' height='330'>" & vbCrlF
			temp_str=temp_str & "<param name='movie' value='" & lurl & "'>" & vbCrlF
			temp_str=temp_str & "<param name='quality' value='high'>" & vbCrlF
			temp_str=temp_str & "<embed src='" & lurl & "' quality='high' pluginspage='http://www.macromedia.com/go/getflashplayer' type='application/x-shockwave-flash' width='450' height='330'></embed>" & vbCrlF
			temp_str=temp_str & "</object>" & vbCrlF
			
		CASE ".wmv",".mpg",".avi" 
			temp_str=temp_str & "" & vbCrlF
			temp_str=temp_str & "<object align=middle classid=CLSID:22d6f312-b0f6-11d0-94ab-0080c74c7e95 class=OBJECT id=MediaPlayer width=450 height=330 >" & vbCrlF
			temp_str=temp_str & "<param name=ShowStatusBar value=-1>" & vbCrlF
			temp_str=temp_str & "<param name=Filename value=" & replace(lurl,chr(32),"%20",1) & ">" & vbCrlF
			temp_str=temp_str & "<embed type=application/x-oleobject codebase=http://activex.microsoft.com/activex/controls/mplayer/en/nsmp2inf.cab#Version=5,1,52,701 flename=mp src='" & replace(lurl,chr(32),"%20",1) & "' width=500 height=100></embed>" & vbCrlF
			temp_str=temp_str & "</object>" & vbCrlF
			
		CASE ".mid" 
			temp_str=temp_str & "<object align=middle classid=CLSID:22d6f312-b0f6-11d0-94ab-0080c74c7e95 class=OBJECT id=MediaPlayer width=450 height=70 >" & vbCrlF
			temp_str=temp_str & "<param name=ShowStatusBar value=-1>" & vbCrlF
			temp_str=temp_str & "<param name=Filename value='" & replace(lurl,chr(32),"%20",1) & "'>" & vbCrlF
			temp_str=temp_str & "<embed type=application/x-oleobject codebase=http://activex.microsoft.com/activex/controls/mplayer/en/nsmp2inf.cab#Version=5,1,52,701 flename=mp src='" & replace(lurl,chr(32),"%20",1) & "' width=500 height=70></embed>" & vbCrlF
			temp_str=temp_str & "</object>" & vbCrlF
			temp_str=temp_str & "" & vbCrlF
			
		case else
			select case Lcase(right(lurl,3))
				case ".rm","ram","mvb"
					temp_str=temp_str & "<OBJECT classid=clsid:CFCDAA03-8BE4-11cf-B84B-0020AFBBCCFA class=OBJECT id=RAOCX width=450 height=300>" & vbCrlF
					temp_str=temp_str & "<PARAM NAME=SRC VALUE='" & lurl & "'><PARAM NAME=CONSOLE VALUE=Clip1>" & vbCrlF 
					temp_str=temp_str & "<PARAM NAME=CONTROLS VALUE=imagewindow><PARAM NAME=AUTOSTART VALUE=true>" & vbCrlF 
					temp_str=temp_str & "</OBJECT><br>" & vbCrlF
					temp_str=temp_str & "<OBJECT classid=CLSID:CFCDAA03-8BE4-11CF-B84B-0020AFBBCCFA height=32 id=video2 width=450>" & vbCrlF
					temp_str=temp_str & "<PARAM NAME=SRC VALUE='" & lurl & "'><PARAM NAME=AUTOSTART VALUE=-1>" & vbCrlF
					temp_str=temp_str & "<PARAM NAME=CONTROLS VALUE=controlpanel><PARAM NAME=CONSOLE VALUE=Clip1>" & vbCrlF
					temp_str=temp_str & "</OBJECT>" & vbCrlF
				case ".ra","mp3"
					temp_str=temp_str & "<OBJECT classid=CLSID:CFCDAA03-8BE4-11CF-B84B-0020AFBBCCFA height=32 id=video2 width=450>" & vbCrlF
					temp_str=temp_str & "<PARAM NAME=SRC VALUE='" & lurl & "'><PARAM NAME=AUTOSTART VALUE=-1>" & vbCrlF
					temp_str=temp_str & "<PARAM NAME=CONTROLS VALUE=controlpanel><PARAM NAME=CONSOLE VALUE=Clip1>" & vbCrlF
					temp_str=temp_str & "</OBJECT>" & vbCrlF
				case else 
					temp_str=temp_str & "<embed name=player src='" & lurl & "' type=audio/x-pn-realaudio-plugin width=450 height=360 border=0 autostart=1> " & vbCrlF
					temp_str=temp_str & "" & vbCrlF
			end select 
	end select
	movie_player=temp_str
end function
'''''''''''''''''''''''''''''''''''''''''
''	取得文章简要
'''''''''''''''''''''''''''''''''''''''''
function get_text_desc(content_str,num)
	dim content,get_num
	content=content_str
	get_num=num
	if content<>"" then
		content=RegExpreplace(content,"<([^>]*)>","")
		content=RegExpreplace(content,"\t","")
		content=RegExpreplace(content,"\n|\r","")
		content=RegExpreplace(content,"  ","")
		if len(content)>get_num then
			content=left(content,get_num) & "……"
		end if
	end if
	get_text_desc=content
end function
function big_pic(pic)
	if ObjTest("Persits.Jpeg")<>"" then
		'big_pic="big_pic.asp?id=" & pic
		big_pic=file_show(pic)
	else
		big_pic=file_show(pic)
	end if
end function
function small_pic(pic)
	if ObjTest("Persits.Jpeg")<>"" then
		small_pic="small_pic.asp?id=" & pic
		small_pic=file_show(pic)
	else
		small_pic=file_show(pic)
	end if
end function
'检查组件是否被支持及组件版本的子程序
function ObjTest(strObj)
  on error resume next
  ObjTest=""
  VerObj=""
  set TestObj=server.CreateObject (strObj)
  If -2147221005 <> Err then		'感谢网友iAmFisher的宝贵建议
    ObjTest = TestObj.version
    if ObjTest="" or isnull(ObjTest) then ObjTest=TestObj.about
  end if
  set TestObj=nothing
End function
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''新的生成HTML代码！
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
function save_to_html(content,file_name)
	dim f_name,file_path,file_content,objStreamt,objStream
	f_name=	file_name
	file_content=content
	'处理一下页面内容中的链接
	'file_content=lcase(file_content)
	file_content=replace(file_content,"src=""","src=""/")
	file_content=replace(file_content,"href=""","href=""/")
	file_content=replace(file_content,"src=""/http://","src=""http://")
	file_content=replace(file_content,"href=""/http://","href=""http://")
	file_content=replace(file_content,"src=""//","src=""/")
	file_content=replace(file_content,"href=""//","href=""/")
	file_content=replace(file_content,"action=""","action=""/")
	file_content=replace(file_content,"action=""/http://","action=""http://")
	file_path=root_path & "\html\" & f_name
	Set objStreamt = Server.CreateObject("ADODB.Stream")
	Set objStream = Server.CreateObject("ADODB.Stream")
	With objStream
		.Open
		.Charset = "utf-8"
		.Position = 0
		.WriteText file_content
		.Position = 3
		objStreamt.open
		objStreamt.type = 1
		.CopyTo objStreamt
		objStreamt.SaveToFile file_path,2
		objStreamt.close
		'.savetofile file_path,2
		.Close
	End With
	Set objStream = Nothing
	save_to_html="/html/" & f_name
	Set objStreamt = Nothing
end function

'''''''''''''''''''''''''''''''
''	错误捕捉
'''''''''''''''''''''''''''''''
if err.number<>0 then
	Set objASPError = Server.GetLastError
	response.write "错误代号:#" & CStr(Err.Number) 
	response.write "<br>错误描述:#" & Err.Description 
	response.write "<br>错误来源:#" & err.Source 
	response.write "<br>出错页面:#" & request.ServerVariables("url") & "?" & request.ServerVariables("QUERY_STRING")
	response.write "<br>错误行数:#" & objASPError.Line
end if
%>