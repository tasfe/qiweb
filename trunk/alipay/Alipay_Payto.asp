<%

Class creatAlipayItemURL
	'获得最终的购买url
	
Public Function creatAlipayItemURL(t1,t4,t5,service,partner,sign_type,subject,body,out_trade_no,price,show_url,quantity,payment_type,logistics_type,logistics_fee,logistics_payment,seller_email,notify_url,receive_name,receive_address,receive_zip,receive_phone,receive_mobile,buyer_msg,key)
	Dim itemURL
	dim INTERFACE_URL,imgsrc,imgtitle
	'初始化各必要变量
	INTERFACE_URL	= t1	'支付接口
	imgsrc			= t4		'支付宝按钮图片
	imgtitle		= t5		'按钮悬停说明
	mystr = Array("service="&service,"partner="&partner,"subject="&subject,"body="&body,"out_trade_no="&out_trade_no,"price="&price,"show_url="&show_url,"quantity="&quantity,"payment_type="&payment_type,"logistics_type="&logistics_type,"logistics_fee="&logistics_fee,"logistics_payment="&logistics_payment,"seller_email="&seller_email,"notify_url="&notify_url,"receive_name="&receive_name,"receive_address="&receive_address,"receive_zip="&receive_zip,"receive_phone="&receive_phone,"receive_mobile="&receive_mobile,"buyer_msg="&buyer_msg,"_input_charset=utf-8")
	Count=ubound(mystr)
	For i = Count TO 0 Step -1
		minmax = mystr( 0 )
		minmaxSlot = 0
		For j = 1 To i
			mark = (mystr( j ) > minmax)
			If mark Then 
				minmax = mystr( j )
				minmaxSlot = j
			End If
		Next
		If minmaxSlot <> i Then 
			temp = mystr( minmaxSlot )
			mystr( minmaxSlot ) = mystr( i )
			mystr( i ) = temp
		End If
	Next
	
	For j = 0 To Count Step 1
		value = SPLIT(mystr( j ), "=")
		If  value(1)<>"" then
			If j=Count Then
				md5str= md5str&mystr( j )
			Else 
				md5str= md5str&mystr( j )&"&"
			End If 
		End If 
	Next
	md5str=md5str&key
	'response.write md5str & "<br>"
	sign=md5(md5str)
	itemURL	= itemURL&INTERFACE_URL 
	For j = 0 To Count Step 1      
		value = SPLIT(mystr( j ), "=")
		If  value(1)<>"" then
			itemURL= itemURL & mystr( j )&"&"
		End If 	     
		'response.write mystr( j ) & "<br/>"
	Next
	itemURL	= itemURL&"sign="&sign&"&sign_type="&sign_type        
	'response.write  sign 
	creatAlipayItemURL	= get_AlipayButtonURL	(itemURL,imgtitle,imgsrc)	
End Function
'----------------------------------------------------------------------------------------------------------------
Public Function get_AlipayButtonURL(itemURL,imgtitle,imgsrc)
	dim responseText1
	responseText1	=	responseText1 & "<a href='" & itemURL & "' target='_blank'>"		'购买网址
	responseText1	=	responseText1 & "<img alt='" & imgtitle & "' src='"				'图片说明
	responseText1	=	responseText1 & imgsrc											'图片地址
	responseText1	=	responseText1 & "' align='absmiddle' border='0'/></a>"
	get_AlipayButtonURL=responseText1
End Function
End Class
%>