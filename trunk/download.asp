<%
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''	文档作用：下载组件
''	创建时间：2005-8-19
''	修改情况：	2005-10-24 改为用ASPupload组件进行下载..(朱祺艺)
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
response.Buffer=true
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''	用于文件下载!
''	f_path:文件的绝对路径,f_filename:要保存的文件名
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''' 

function transferfile(f_path,f_filename)
	dim path,mimetype,filename
	path=f_path
	filename=f_filename
	on   error   resume   next   
    Set   S=CreateObject("Adodb.Stream")     
    S.Mode=3     
    S.Type=1     
    S.Open     
    S.LoadFromFile(path)   
    if   Err.Number>0   then     
      Response.Status="404"   
    else   
      Response.ContentType="application/octet-stream"   
      Response.AddHeader   "Content-Disposition:","attachment;   filename="   &   filename   
      Range=Mid(Request.ServerVariables("HTTP_RANGE"),7)   
      if   Range=""   then   
        Response.BinaryWrite(S.Read)   
      else   
        S.position=Clng(Split(Range,"-")(0))   
        Response.BinaryWrite(S.Read)   
      End   if   
    end   if   
    Response.End   
end function

function transferfile_back(f_path,f_filename)
	dim path,mimetype,filename
	path=f_path
	filename=f_filename
	Set Upload = Server.CreateObject("Persits.Upload")
	Upload.SendBinary Path, True, "application/octet-binary", True,filename
	transferfile=true
end function
%>