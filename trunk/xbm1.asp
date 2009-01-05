<%
Option Explicit
Response.Expires = 0
Response.AddHeader "Pragma","no-cache"
Response.AddHeader "cache-ctrol","no-cache"
Response.ContentType = "Image/BMP"
Randomize Timer

Dim Text_Data(9),Text_Len,Int_Temp(),I,j,k,Int_Temp2

''***** 参数配置区 *****

Text_Len = 4 ''验证码长度(支持1-25位)

''**********************

ReDim Int_Temp( Text_Len - 1 )

Text_Data(0)  = "00000000000001111000001100110000110111000011011100001100110000111011000011101100001100110000011110000000000000"
Text_Data(1)  = "00000000000000011000000011100000111110000000011000000001100000000110000000011000000001100000000110000000000000"
Text_Data(2)  = "00000000000001111000001100110000110011000000001100000001100000001100000001100000001100000000111111000000000000"
Text_Data(3)  = "00000000000001111000001100110000110011000000001100000011100000000011000011001100001100110000011110000000000000"
Text_Data(4)  = "00000000000001100000000110000000011011000001101100000110110000110011000011111110000000110000000011000000000000"
Text_Data(5)  = "00000000000011111100001100000000110000000011000000001111100000000011000000001100000001100000111100000000000000"
Text_Data(6)  = "00000000000000111000000011000000011000000011111000001100110000110011000011001100001100110000011110000000000000"
Text_Data(7)  = "00000000000011111100000000110000000110000000011000000011000000001100000001100000000110000000011000000000000000"
Text_Data(8)  = "00000000000001111000001100110000110011000011101100000111100000110111000011001100001100110000011110000000000000"
Text_Data(9)  = "00000000000001111000001100110000110011000011001100001100110000011111000000011000000011000000011100000000000000"

''下面随机生成各位验证码
Session("Num") = ""
For I = 0 To Text_Len - 1
   Int_Temp(I) = Int(Rnd * 10)
   Session("Num") = Session("Num") + Mid("0123456789",Int_Temp(I)+1,1)
Next

''下面输出文件头部分
Int_Temp2 = (Text_Len - 1) \ 4 * 220 + ((Text_Len - 1) / 4 - (Text_Len - 1) \ 4 * 4) * 44
Response.BinaryWrite ChrB(&H42) & ChrB(&H4D)
Response.BinaryWrite ChrB(((Int_Temp2 + 206) / 256 - (Int_Temp2 + 206) \ 256) * 256) & ChrB((Int_Temp2 + 206) \ 256)   ''特殊位
Response.BinaryWrite ChrB(0) & ChrB(0) & ChrB(0) & ChrB(0) & ChrB(0) & ChrB(0) & ChrB(&H76) & ChrB(0) & ChrB(0) & ChrB(0) & ChrB(&H28) & ChrB(0) & ChrB(0) & ChrB(0)
Response.BinaryWrite ChrB(Text_Len * 10)   ''特殊位
Response.BinaryWrite ChrB(0) & ChrB(0) & ChrB(0) & ChrB(&HB) & ChrB(0) & ChrB(0) & ChrB(0) & ChrB(&H1) & ChrB(0) & ChrB(&H4) & ChrB(0) & ChrB(0) & ChrB(0) & ChrB(0) & ChrB(0)
Response.BinaryWrite ChrB(((Int_Temp2 + 88) / 256 - (Int_Temp2 + 88) \ 256) * 256) & ChrB((Int_Temp2 + 88) \ 256)   ''特殊位

Response.BinaryWrite ChrB(0) & ChrB(0) & ChrB(0) & ChrB(0) & ChrB(0) & ChrB(0) & ChrB(0) & ChrB(0) & ChrB(0) & ChrB(0) & ChrB(16) & ChrB(0) & ChrB(0) & ChrB(0) & ChrB(16) & ChrB(0) & ChrB(0) & ChrB(0) & ChrB(0) & ChrB(0) & ChrB(0) & ChrB(0) & ChrB(0) & ChrB(0) & ChrB(&H80) & ChrB(0) & ChrB(0) & ChrB(&H80) & ChrB(0) & ChrB(0) & ChrB(0) & ChrB(&H80) & ChrB(&H80) & ChrB(0) & ChrB(&H80) & ChrB(0) & ChrB(0) & ChrB(0) & ChrB(&H80) & ChrB(0) & ChrB(&H80) & ChrB(0)
Response.BinaryWrite ChrB(&H80) & ChrB(&H80) & ChrB(0) & ChrB(0) & ChrB(&H80) & ChrB(&H80) & ChrB(&H80) & ChrB(0) & ChrB(&HC0) & ChrB(&HC0) & ChrB(&HC0) & ChrB(0) & ChrB(0) & ChrB(0) & ChrB(&HFF) & ChrB(0) & ChrB(0) & ChrB(&HFF) & ChrB(0) & ChrB(0) & ChrB(0) & ChrB(&HFF) & ChrB(&HFF) & ChrB(0) & ChrB(&HFF) & ChrB(0) & ChrB(0) & ChrB(0) & ChrB(&HFF) & ChrB(0) & ChrB(&HFF) & ChrB(0) & ChrB(&HFF) & ChrB(&HFF) & ChrB(0) & ChrB(0) & ChrB(&HFF) & ChrB(&HFF) & ChrB(&HFF) & ChrB(0)

''下面输出图片数据
For i = 10 to 0 Step -1
   For j = 0 to Text_Len - 1
      For k = 1 to 9 Step 2
         If Mid(Text_Data(Int_Temp(j)) ,  i * 10 + k , 1) = "0" Then Int_Temp2 = Get_BackColor() * 16 Else Int_Temp2 = Get_ForeColor() * 16
         If Mid(Text_Data(Int_Temp(j)) ,  i * 10 + k + 1 , 1) = "0" Then Int_Temp2 = Int_Temp2 + Get_BackColor() Else Int_Temp2 = Int_Temp2 + Get_ForeColor()
         Response.BinaryWrite ChrB(Int_Temp2)
      Next
   Next
   Int_Temp2 = (Text_Len / 4 - Text_Len \ 4) * 4
   Select Case Int_Temp2
   Case 1
      Response.BinaryWrite ChrB(0) & ChrB(0) & ChrB(0)
   Case 2
      Response.BinaryWrite ChrB(0) & ChrB(0)
   Case 3
      Response.BinaryWrite ChrB(0)
   End Select
Next

Function Get_BackColor()
''得到一个背景色
If Int(Rnd * 30) = 0 Then ''注：此处的 Rnd * 30 是决定背景杂色的多少，值越大，则杂色越少，图片越容易看清楚
   Get_BackColor = CInt(Mid("00021209",Int(Rnd * 4) * 2 + 1,2))
Else
   Get_BackColor = CInt(Mid("081515151515",Int(Rnd * 6) * 2 + 1,2))
End If
End Function

Function Get_ForeColor()
''得到一个前景色
Get_ForeColor = CInt(Mid("00021209",Int(Rnd * 4) * 2 + 1,2))
End Function
%>

