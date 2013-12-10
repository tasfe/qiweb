<!--#include file="../common.asp"-->
<%
on error resume next
call check_admin()
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>访问统计</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../css.css" rel="stylesheet" type="text/css">
</head>

<body>

<div class="page-title">访问统计</div>
<div class="help-info"> 通过查看访问统计，可以让你了解网站的浏览情况！知道那一些页面是受欢迎的，人们是如何获知你的网站的，那个时候访问量最大？等等。。。<br>
  本系统集成了cccounter6访问统计系统。<br>
  管理账号：admin<br>
  密码：123456<br>
  超级管理密码：123abc<br><br>
  <div class="button"><a href="count/Default.htm">进入管理界面</a></div>
</div>
<div class="page-title">使用其它统计系统</div>
<div class="help-info"> 虽然本系统集成的统计系统功能已经很强大，但是你还是可以调用第三方的统计代码，对网站的流量进行统计。<br>
  操作方法如下：<br>
  1、申请第三方的统计账号！（可从下面推荐的统计系统中申请一个！）<br>
  2、获得统计代码。<br>
  3、将统计代码复制到“综合管理”-=&gt;“版权信息”上。<br>
  4、记得切换到“源代码”界面再粘贴代码！<br>
</div>
<div class="page-title">推荐的第三方统计系统</div>
<div class="help-info">下面是一些功能强大的，各有特色的统计系统。可以点击进入申请！<br><br>
	<div class="button"><a href="http://51.la" target="_blank">我要啦统计</a></div>
	<div class="button"><a href="http://www.50bang.com" target="_blank">武林榜统计</a></div>
	<div class="button"><a href="http://www.itsun.com/" target="_blank">ITSUN网站流量统计</a></div>
	<div class="button"><a href="http://www.cnzz.com/" target="_blank">中国站长联盟</a></div>
	<div class="button"><a href="http://www.textclick.com/" target="_blank">太极链</a></div>
	<div class="button"><a href="http://www.1tong.com.cn/" target="_blank">一统天下</a></div>
	<div class="button"><a href="http://stat.cnworms.com/" target="_blank">中国虫盟</a></div>
	<div class="button"><a href="http://www.yes5.net/" target="_blank">Yes5统计</a></div>
	<div class="button"><a href="http://stats.weamax.com/" target="_blank">流量通</a></div>
</div>
<br>
<br>
<div class="page-foot"><%=db_getvalue("setup_name='page_foot'","sys_setup","setup_value")%></div><br></body>
</html>
