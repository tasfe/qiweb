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
	欢迎使用TOU.mobi提供的企业信息发布系统，通过本系统会让你快速从0开始，建设出非常专业的网站！<br/>
	使用说明：<br>
	1、第一次使用请先修改管理密码！<br>
	2、点击右边的功能导航条定制自己的网站！<br>
	3、全部修改后请点击“退出系统”<br><br>
</div>
<div class="page-title">版权声明</div>
<div class="help-info">
企业信息发布系统版权系由朱祺艺所有！<br/>
现授权给“所有人”免费使用！<br>
使用者可以进行以下操作：<br>
1、用本系统建立发布自己的网站！<br>
2、用本系统发布企业信息！<br>
3、使用本系统提供的各种功能<br>
4、使用本系统给任何公司及个人建立网站并获得相应的收入。<br>
5、二次传播及分发此系统<br>
6、总之，不设任何限制
</div>
<div class="page-title">合作声明</div>
<div class="help-info">本系统程序由<font color="blue">朱祺艺</font>独立开发设计并进行技术支持</div>
<div class="page-title">责任说明</div>
<div class="help-info">
1、作者保证不在软件附带任何木马及后门程序！<br>
2、作者保证软件能正常使用！<br>
3、作者不保证由于使用者不慎操作导致的数据丢失！请做删除操作时看清数据是否真的可以删除！<br>
4、作者不对使用者利用本系统发布的信息消息负责任！请不要利用本各系统发布违反国家法规的消息！</div><br>
<div class="page-title">联系我们</div>
<div class="help-info">
<br/>技术客服：<a href="tencent://message/?uin=40459931&Site=技术支持&Menu=yes"><img border="0" SRC="http://wpa.qq.com/pa?p=1:40459931:1" alt="点击这里给我发消息"></a>
<br/>作者主页：<a href="http://www.zhuqiyi.com" target="_blank">天外来信</a>
<br/>还存在的一些网站：<a href="http://www.tou.mobi" target="_blank">汽车配件供求信息</a>、<a href="http://www.pigknow.com" target="_blank">猪知道</a>
</div>
<div class="page-title">版本号</div>
<div class="help-info">企业信息发布系统的最新版本为：2013-12-10更新</div>
<div class="page-foot"><%=db_getvalue("setup_name='page_foot'","sys_setup","setup_value")%></div><br></body>
</html>
