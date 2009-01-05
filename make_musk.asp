<!--#include file="common.asp"-->
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
dim fso,i,musk_font_size,musk_font_color,musk_font_shadow,musk_border,musk_border_color,musk_font_text
set fso=CreateObject("Scripting.FileSystemObject")
musk_font_size=db_getvalue("setup_name='musk_font_size'","sys_setup","setup_value")
musk_font_color=db_getvalue("setup_name='musk_font_color'","sys_setup","setup_value")
musk_font_shadow=db_getvalue("setup_name='musk_font_shadow'","sys_setup","setup_value")
musk_font_text=db_getvalue("setup_name='musk_font_text'","sys_setup","setup_value")
	if musk_font_text="" then
		musk_font_text=db_getvalue("setup_name='homepage_name_gb'","sys_setup","setup_value")
	end if
musk_border=db_getvalue("setup_name='musk_border'","sys_setup","setup_value")
musk_border_color=db_getvalue("setup_name='musk_border_color'","sys_setup","setup_value")
i=0
call search_files(root_path & db_getvalue("setup_name='upload_forder'","sys_setup","setup_value"))
sub mack_musk(f_path)
	dim file_path
	file_path=f_path
	''以下代码是添加图片水印的-------------------------------------------
		Set Jpeg = Server.CreateObject("Persits.Jpeg")
		' Open source image
		Jpeg.Open file_path
		
		' Resizing is optional. None in this code sample.
		
		' Draw text
		if musk_font_shadow="1" then
			Jpeg.Canvas.Font.Color =&H999999 ' Red
			Jpeg.Canvas.Font.Family = "宋体"
			Jpeg.Canvas.Font.Bold = True
			Jpeg.Canvas.Font.Quality = 0 ' Antialiased
			Jpeg.Canvas.Font.Size=cint(musk_font_size)
			Jpeg.Canvas.Font.BkMode = "Transparent" ' to make antialiasing work
			Jpeg.Canvas.Print 12, Jpeg.OriginalHeight-28, musk_font_text
		end if
		Jpeg.Canvas.Font.Color =clng("&H" & musk_font_color) ' Red
		Jpeg.Canvas.Font.Family = "宋体"
		Jpeg.Canvas.Font.Bold = True
		Jpeg.Canvas.Font.Quality = 0 ' Antialiased
		Jpeg.Canvas.Font.Size=cint(musk_font_size)
		Jpeg.Canvas.Font.BkMode = "Transparent" ' to make antialiasing work
		Jpeg.Canvas.Print 10, Jpeg.OriginalHeight-30, musk_font_text
		
		if musk_border="1" then
		' Draw frame: black, 2-pixel width
		Jpeg.Canvas.Pen.Color = clng("&H" & musk_border_color) ' Black
		Jpeg.Canvas.Pen.Width = 1
		Jpeg.Canvas.Brush.Solid = False ' or a solid bar would be drawn
		Jpeg.Canvas.DrawBar 0,0, Jpeg.Width, Jpeg.Height
		end if
		Jpeg.Save file_path
		
		i=i+1
	'''-------------------------------------------------------
end sub
sub search_files(s_f)
	'on error resume next
	dim fd,fs,f,f_path,rs_fields,rs,db_rs
	f_path=s_f
	Set f = fso.GetFolder(f_path)
	set fd=f.SubFolders
	for each fd_name in fd
		call search_files(fd_name.Path)
	next
	set fd=nothing
	set fs=f.files
	for each fs_name in fs
		response.write fs_name & "<br/>"
		if lcase(right(fs_name,3))="jpg" then
			call mack_musk(fs_name)
		end if
	next 
	set fs=nothing
end sub
%>
添加水印成功，共处理图片：<%=i%>张
</body>
</html>