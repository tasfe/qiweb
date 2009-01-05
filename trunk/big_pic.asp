<!--#include file="common.asp"-->
<%
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''	记录网站的文件更新记录
''	生成新版本需要更新的文件
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
file_id=request.QueryString("id")
if instr(file_id,"||")<>0 then
file_id=get_left(file_id,"||")
end if
define_width=db_getvalue("setup_name='para_picture_width'","sys_setup","setup_value")
define_height=db_getvalue("setup_name='para_picture_height'","sys_setup","setup_value")
'获得水印的设置
upload_mask=db_getvalue("setup_name='upload_mask'","sys_setup","setup_value")
musk_font_size=db_getvalue("setup_name='musk_font_size'","sys_setup","setup_value")
musk_font_color=db_getvalue("setup_name='musk_font_color'","sys_setup","setup_value")
musk_font_shadow=db_getvalue("setup_name='musk_font_shadow'","sys_setup","setup_value")
musk_font_text=db_getvalue("setup_name='musk_font_text'","sys_setup","setup_value")
	if musk_font_text="" then
		musk_font_text=db_getvalue("setup_name='homepage_name_gb'","sys_setup","setup_value")
	end if
musk_border=db_getvalue("setup_name='musk_border'","sys_setup","setup_value")
musk_border_color=db_getvalue("setup_name='musk_border_color'","sys_setup","setup_value")


if define_width=0 or isnull(define_width) or define_width="" then
define_width=500
else
define_width=cint(define_width)
end if
if define_height=0 or isnull(define_height) then
define_height=500
else
define_height=cint(define_height)
end if

pd_pic=file_show(file_id)
Set Jpeg = Server.CreateObject("Persits.Jpeg")
Jpeg.New define_width, define_height, clng("&H" & musk_border_color)
' Draw 1-pixel blue frame

file_path=Server.MapPath(pd_pic)
if file_ifopen(file_path)=0 then
Set Img = Server.CreateObject("Persits.Jpeg")
Img.Open file_path

' Resize to inscribe in 100x100 square
Img.PreserveAspectRatio = True
If Img.OriginalWidth > define_width or Img.OriginalHeight > define_height Then
  If Img.OriginalWidth > Img.OriginalHeight Then
	Img.Width = define_width
  Else
	Img.Height = define_height
  End If
End If
X = 0 
Y = 0
' center image inside frame vert or horiz as needed
Jpeg.Canvas.DrawImage X + (define_width - Img.Width) / 2, Y + (define_height - Img.Height) / 2, Img
Jpeg.Canvas.Font.Color = clng("&H" & musk_font_color) ' black
Jpeg.Canvas.Font.Family = "黑体"
Jpeg.Canvas.Font.Bold = True
Jpeg.Canvas.Font.Size = cint(musk_font_size)
Jpeg.Canvas.Font.Quality = 1 ' antialiased
Jpeg.Canvas.Font.BkMode = "Transparent"

' Draw album title centered
	if upload_mask="1" then
	Title=musk_font_text
	TitleWidth = Jpeg.Canvas.GetTextExtent( Title )
	Jpeg.Canvas.Print (Jpeg.Width - TitleWidth) / 2, Jpeg.Height/2-9,Title
	end if
else
Title="图片不存在"
TitleWidth = Jpeg.Canvas.GetTextExtent( Title )
Jpeg.Canvas.Print (Jpeg.Width - TitleWidth) / 2, Jpeg.Height/2-9, Title
end if
if musk_border="1" then
	' Draw frame: black, 2-pixel width
	Jpeg.Canvas.Pen.Color = clng("&H" & musk_border_color) ' Black
	Jpeg.Canvas.Pen.Width = 1
	Jpeg.Canvas.Brush.Solid = False ' or a solid bar would be drawn
	Jpeg.Canvas.DrawBar 0,0, Jpeg.Width, Jpeg.Height
end if
Jpeg.SendBinary
response.end
'Jpeg.Save Server.MapPath("img/" & pd_id & ".jpg")

'Server.Transfer "img/" & pd_id & ".jpg"
'response.end
%>
