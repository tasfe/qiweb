﻿<%
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''	文档作用：用于调用各种插件代码
''	创建时间：2007-2-11
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'修改情况：
'2007-2-11：添加QQ在线插件




'-----网站QQ在线咨询插件(start)-----
'修改adm_qq后面引号中的QQ号，多个QQ号用半角逗号隔开，QQ数量不限。
adm_qq="40459931,22400144"
open_qq=false
if open_qq then
%>
<!--#include file="qq/qq.asp" -->
<%
end if
'-----网站QQ在线咨询插件(end)-------
'
'-----用户调用的系统模板代码(start)-----
function user_define_code()
	
	'返回调用好的代码
	user_define_code=""
end function
'-----用户调用的系统模板代码(end)-----
'
'-----用户定义的代码(start)-----
function user_template_code()
	
	'返回调用好的代码
	user_template_code=""
end function
'-----用户定义的代码(end)-----
%>