<%
'/----------------------------------------
'	本模块定义一些用于新闻采集的类模块
'/----------------------------------------
Function Manhunt(webstr,Label1,Label2,IgnoreCase,Global,Include,Stir)
	Label1=myConvert(Label1)
	Label2=myConvert(Label2)
	dim webstr2
	webstr2=myConvert(webstr)
	dim objregexp,matches,match,str
	Set objRegExp = New Regexp 
	With objRegExp
		.IgnoreCase = IgnoreCase 
		.Global = Global
		.Pattern = "("&Label1&").+?("&Label2&")"
		Set Matches =.Execute(webstr2) 
		For Each Match in Matches 
			str=str&Match.Value&"$url$"
		Next 
		set Matches=nothing
		if not Include then
			.Pattern = "("&Label1&")"
			str=.replace(str,"")
			.Pattern = "("&Label2&")"
			str=.replace(str,"")
		end if
		if Stir then
			str=replace(str,"""","")
			str=replace(str,"'","")
		end if
		if not Global then
			str=replace(str,"$url$","")
		end if
	end with
	set objRegExp=nothing
	if str="" then
		Manhunt=false
	else
		Manhunt=str
		Manhunt=myConvert_t(Manhunt)
	end if
End Function

Function myConvert_t(val)
	myConvert_t=replace(val,"§§","$")
	myConvert_t=replace(myConvert_t,"§（","(")
	myConvert_t=replace(myConvert_t,"§）",")")
	myConvert_t=replace(myConvert_t,"§※","*")
	myConvert_t=replace(myConvert_t,"§＋","+")
	myConvert_t=replace(myConvert_t,"§·",".")
	myConvert_t=replace(myConvert_t,"§［","[")
	myConvert_t=replace(myConvert_t,"§？","?")
	myConvert_t=replace(myConvert_t,"§＼","\")
	myConvert_t=replace(myConvert_t,"§｛","{")
	myConvert_t=replace(myConvert_t,"§｜","|")
End Function

Function myConvert(val)
	myConvert=replace(val,"$","§§")
	myConvert=replace(myConvert,"(","§（")
	myConvert=replace(myConvert,")","§）")
	myConvert=replace(myConvert,"*","§※")
	myConvert=replace(myConvert,"+","§＋")
	myConvert=replace(myConvert,".","§·")
	myConvert=replace(myConvert,"[","§［")
	myConvert=replace(myConvert,"?","§？")
	myConvert=replace(myConvert,"\","§＼")
	myConvert=replace(myConvert,"{","§｛")
	myConvert=replace(myConvert,"|","§｜")
End Function

Function stripHTML(strHTML,ben,und)
	dim SearchFile,SearchFile1,pos1,pos2
	SearchFile = InStrB(1, strHTML, ben, vbBinaryCompare) > 0
	SearchFile1 = InStrB(1,strHTML, und, vbBinaryCompare) > 0
	If SearchFile and  SearchFile1 Then
		pos1 = InStrB(1, strHTML, ben, vbBinaryCompare) 
		pos2 = InStrB(pos1, strHTML, und, vbBinaryCompare)  
		stripHTML = MidB( strHTML, pos1 ,pos2-pos1+lenB(und))
	else
		stripHTML=false
	end if
End Function

Function SeparateHTML(strHTML,ben,und)
	dim SearchFile,SearchFile1,pos1,pos2
	SearchFile = InStrB(1, strHTML, ben, vbBinaryCompare) > 0
	SearchFile1 = InStrB(1,strHTML, und, vbBinaryCompare) > 0
	If SearchFile and  SearchFile1 Then
		pos1 = InStrB(1, strHTML, ben, vbBinaryCompare) 
		pos2 = InStrB(pos1+lenB(ben), strHTML, und, vbBinaryCompare)
		SeparateHTML = MidB(strHTML,pos1+lenB(ben),pos2-pos1-lenB(ben)) 
	else
		SeparateHTML =false
	end if
End Function

'前一个参数是目标地址，第二个参数是参考地址
Function HttpUrls(strs,http)
	dim imageurl,url2,n,url1,imagea,i
	httpurls=""
	imageurl=""
	if UCase(left(http,4))<>"HTTP" then
		http="http://"&http
	end if
	url2=split(http,"/")
	i=0
	imageurl=""
	for i=0 to 2
		imageurl=imageurl&url2(i)&"/"
	next
	n=0	
	if UCase(left(strs,4))="HTTP" then
		httpurls=strs
	else
		if UCase(left(strs,2))="//" then
			httpurls="http:"&strs
		else
			if UCase(left(strs,1))="/" then
				url1=right(strs,len(strs)-1)
				httpurls=imageurl&url1
			else
				if UCase(left(strs,1))="#" then
					httpurls=strs
				else
					if UCase(left(strs,3))="../" then
						url1=Split(strs,"../")
						if ubound(url2)-ubound(url1)>=3 then
							strs=""
							i=0
							for i=0 to ubound(url2)-ubound(url1)-1
								strs=strs&url2(i)&"/"
							next
							strs=strs&url1(ubound(url1))
							httpurls=strs
						else
						'***
							url1=Split(strs,"/")
							httpurls=imageurl&url1(ubound(url1))
						end if
					else	
						imagea=""
						i=0
						for i=0 to ubound(url2)-1
							imagea=imagea&url2(i)&"/"
						next
						httpurls=imagea&strs
					end if
				end if
			end if
		end if
	end if
End Function
'google自动翻译模快
function get_google_Translate(s_language,send_text)
	dim Http,user_cookies,url,bintou,checkcoder,send_temp,temp_http,web_str
	send_temp=send_text
	
	temp_http="http://translate.google.com/translate_t?langpair=" & s_language
	send_temp="text=" & server.urlencode(send_temp) & ""
	
	set Http=server.createobject("Msxml2.XMLHTTP")
	url=replace(temp_http,"&amp;","&")
	Http.open "POST",url,false
	Http.send(send_temp)
	if Http.readystate<>4 then 
		get_google_Translate=""
        exit function
    end if
	web_str=Http.responseBody
	web_str=bytesToBSTR(web_str,"utf-8")
	web_str=SeparateHTML(web_str,"<div id=result_box dir=ltr>","</div></td>")
	web_str=replace(web_str,"&amp;","&")
	get_google_Translate=web_str
    set http=nothing
    if err.number<>0 then err.Clear 
end function
'判断远程文件是否存在 
function Save2local(LocalFileName,RemoteFileUrl)
	dim Ads,Retrieval,GetRemoteData 
	On Error Resume Next 
	Dim httpxml 
	Set httpxml = Server.CreateObject("MicroSoft.XMLHTTP") 
	httpxml.open "HEAD",RemoteFileUrl,False 
	httpxml.send 
	If httpxml.status <> 200 Then 
		Save2local=false
		exit function
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
	.SaveToFile LocalFileName,2 
	.Cancel() 
	.Close() 
	End With 
	Set Ads=nothing 
	if err.number<>0 then 
		err.Clear
		Save2local=false
		file_delete tofile 
	else
		Save2local=true
	end if 
end function
%>