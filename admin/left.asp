<!--#include file="../common.asp"-->
<!--#include file="../md5.asp"-->
<%
check_admin
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>管理导航页</title>

<link href="../css.css" rel="stylesheet" type="text/css">
</head>

<body style="border-right:1px solid #ccc">
<div><img src="images/logo.gif" alt="标记"/></div>
<div id="left-menu">
  <ul>
    <li><a href="<%=url_path%>default.asp" target="_blank">查看网站</a></li>
    <li><a href="sys_language.asp" target="main">语言设置</a></li>
    <li><a href="#" onClick="menu_change()" class="link1">首页样式设计</a> 
      <ul>
        <li><a href="sys_homepage_open.asp" target="main">首页开关</a></li>
        <li><a href="sys_homepage.asp" target="main">首页样式</a></li>
        <li><a href="sys_homepage_name.asp" target="main">首页名称</a></li>
		<li><a href="sys_homepage_diy.asp" target="main">自定义首页</a></li>
      </ul>
    </li>
    <li><a href="#" onClick="menu_change()" class="link1">网站样式设计 </a> 
      <ul>
        <li><a href="sys_site.asp" target="main">选择模板</a></li>
        <li><a href="sys_site_name.asp" target="main">网站名称</a></li>
        <li><a href="sys_logo.asp" target="main">网站LOGO</a></li>
		<li><a href="sys_para.asp" target="main">界面参数设置</a></li>
      </ul>
    </li>
	<%
	show_language=db_getvalue("setup_name='show_language'","sys_setup","setup_value")
	default_language=db_getvalue("setup_name='default_language'","sys_setup","setup_value")
	gb_to_big5=db_getvalue("setup_name='gb_to_big5'","sys_setup","setup_value")
	set rs=server.CreateObject("adodb.recordset")
	sql="select * from [language] where id in(" & show_language & ") order by id"
	rs.open sql,conn,1,1
	do while not rs.eof
	if rs("id")=2 and gb_to_big5="true" then
	else
	%>
    <li><a href="#" onClick="menu_change()" class="link1"><%=rs("language")%>网站管理<%if default_language=cstr(rs("id")) or (gb_to_big5="true" and rs("id")=1 and default_language="2") then response.write "(默认)"%></a> 
      <ul>
        <li><a href="sitemap.asp?language=<%=rs("id")%>" target="main"><%=rs("language")%>栏目管理</a></li>
		<li><a href="frame_manager.asp?language=<%=rs("id")%>" target="main"><%=rs("language")%>栏目样式</a></li>
        <li><a href="content.asp?language=<%=rs("id")%>" target="main"><%=rs("language")%>内容管理</a></li>
        <li><a href="link.asp?language=<%=rs("id")%>" target="main"><%=rs("language")%>链接管理</a></li>
      </ul>
    </li>
	<%
	end if
	rs.movenext
	loop
	rs.close
	set rs=nothing
	%>
    <li><a href="#" onClick="menu_change()" class="link1">综合管理</a> 
      <ul>
	  	<li><a href="news_manager.asp" target="main">首页公告</a></li>
        <li><a href="copyright.asp" target="main">版权信息</a></li>
        <li><a href="adv_manager.asp" target="main">广告管理</a></li>
		<li><a href="lyb_manager.asp" target="main">留言管理</a></li>
		<li><a href="http://qiweb.cn/server/guest_manager.asp" target="main">客户反馈管理</a></li>
		<li><a href="po_manager.asp" target="main">产品订单管理</a></li>
      </ul>
    </li>
	<li><a href="#" onClick="menu_change()" class="link1">高级管理</a> 
      <ul>
	  	<li><a href="shop_manager.asp" target="main">网站商城设置</a></li>
		<li><a href="email_para.asp" target="main">电邮参数设置</a></li>
	  	<li><a href="upload_setup.asp" target="main">上传设置</a></li>
		<li><a href="meta_manager.asp" target="main">Meta设置</a></li>
		<li><a href="plugin_manager.asp" target="main">插件管理</a></li>
      </ul>
    </li>
	<li><a href="#" onClick="menu_change()" class="link1">推广工具</a> 
      <ul>
	  	<li><a href="count.asp" target="main">访问统计</a></li>
		<li><a href="form_manager.asp" target="main">客户反馈表单</a></li>
	  	<li><a href="SEO_manager.asp" target="main">搜索引擎登录</a></li>
		<li><a href="gather_manager.asp" target="main">新闻采集模块管理</a></li>
		<li><a href="language_pack.asp" target="main">修改界面语言包</a></li>
		<!--
		<li><a href="txmaimai.asp" target="main">天下买卖网店联盟</a></li>
	  	<li><a href="email_" target="main">电邮群发</a></li>
		<li><a href="#" target="main">交换链系统</a></li>
		-->
      </ul>
    </li>
    <li><a href="password_edit.asp" target="main">修改密码</a></li>
	<li><a href="#" onClick="menu_change()" class="link1">系统信息</a>
	  <ul>
	    <li><a href="main.asp" target="main">系统版权</a></li>
	  	<li><a href="../aspcheck.asp" target="main">服务器信息</a></li>
	  </ul>
	</li>
    <li><a href="logout.asp" target="main">退出管理</a></li>
  </ul>
</div><br>
<br>
<div  align="center">作者：<a href="http://zhuqiyi.com/" target="_blank">天外来信</a></div>
<script language="JavaScript">
function menu_change()
{
	var eSrc = window.event.srcElement;
	var eChild = GetChildElem(eSrc.parentElement,"UL");
	eChild.style.display = ("block" == eChild.style.display ? "none" : "block");
}
function GetChildElem(eSrc,sTagName)
{
	var cKids = eSrc.children;
	for (var i=0;i<cKids.length;i++)
	{
		if (sTagName == cKids[i].tagName) return cKids[i];
	}
	return false;
}
</script>
</body>
</html>
