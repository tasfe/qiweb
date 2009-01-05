<!--#include file="../common.asp"-->
<%
on error resume next
call check_admin()
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>版权声明</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../css.css" rel="stylesheet" type="text/css">
</head>

<body>

<div class="page-title">Welcome!!</div>
<div class="help-info">
	欢迎使用天下网络提供的企业信息发布系统，通过本系统会让你快速从0开始，建设出非常专业的网站！<br/>
	使用说明：<br>
	1、第一次使用请先修改管理密码！<br>
	2、点击右边的功能导航条定制自己的网站！<br>
	3、全部修改后请点击“退出系统”<br><br>
</div>
<div class="page-title">版权声明</div>
<div class="help-info">
天下网络企业信息发布系统版权系由天下买卖（网络）有限公司所有！<br/>
现授权给“<%=db_getvalue("setup_name='user_name'","sys_setup","setup_value")%>”使用！<br>
使用者可以进行以下操作：<br>
1、用本系统建立发布自己的网站！<br>
2、用本系统发布企业信息！<br>
3、使用本系统提供的各种功能，及进入升级服务！<br>
使用者未得到以下授权：<br>
1、不得未经天下买卖（网络）有限公司同意，将本软件复制传播！<br>
2、不可以对本软件进行反编译等操作
</div>
<div class="page-title">合作声明</div>
<div class="help-info">本系统程序由<font color="blue">朱祺艺</font>独立开发设计并进行技术支持<br/>由<font color="blue">郑学辉</font>担任设计顾问和指导！<br/>市场拓展计划由<font color="blue">郑学辉</font>全权负责！</div>
<!--
<div class="page-title">系统LOGO</div>
<div class="oper-content"><img src="images/txmaimai.gif" alt="txmaimai's logo"/></div>
-->
<div class="page-title">责任说明</div>
<div class="help-info">
1、作者保证不在软件附带任何木马及后门程序！<br>
2、作者保证软件能正常使用！<br>
3、作者不保证由于使用者不慎操作导致的数据丢失！请做删除操作时看清数据是否真的可以删除！<br>
4、作者不对使用者利用本系统发布的信息消息负责任！请不要利用本各系统发布违反国家法规的消息！</div><br>
<div class="page-title">联系我们</div>
<div class="help-info"><br/>
销售客服：<a href="tencent://message/?uin=410999328&Site=售前客服&Menu=yes"><img border="0" SRC="http://wpa.qq.com/pa?p=1:410999328:1" alt="点击这里给我发消息"></a>
<br/>技术客服：<a href="tencent://message/?uin=40459931&Site=技术支持&Menu=yes"><img border="0" SRC="http://wpa.qq.com/pa?p=1:40459931:1" alt="点击这里给我发消息"></a></div>
<div class="page-title">版本号</div>
<%
sys_version=db_getvalue("setup_name='sys_version'","sys_setup","setup_value")
sys_key=db_getvalue("setup_name='user_key'","sys_setup","setup_value")
%>
<div class="help-info">天下网络企业信息发布系统的最新版本为：<%=getHTTPPage("http://txmaimai.cn/infoweb/update/get_version.asp")%></div>
<div class="button"><a href="update.asp">自动升级</a></div>
<div class="help-info"><br>
你现在所使用的版本是：<a href="http://txmaiami.com/infoweb/update.asp?version=<%=sys_version%>"><%=sys_version%></a><br/>
该系统的授权码为：<%=sys_key%></div>
<div class="page-foot"><%=db_getvalue("setup_name='page_foot'","sys_setup","setup_value")%></div><br></body>
</html>
