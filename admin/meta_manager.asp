﻿<!--#include file="../common.asp"-->
<%
	check_admin
	show_language=db_getvalue("setup_name='show_language'","sys_setup","setup_value")
	if ufomail_request("Form","action")<>"" then
		set rs=server.CreateObject("adodb.recordset")
		sql="select * from [language] where id in(" & show_language & ")"
		rs.open sql,conn,1,3
		do while not rs.eof 
			rs("site_meta")=ufomail_request("Form","site_meta_" & rs("id"))
			rs.update
			rs.movenext
		loop
		rs.close
		set rs=nothing
		response.redirect "meta_manager.asp"
		response.end
	end if
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html xmlns:x86>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>网站Meta设置</title>
<?IMPORT NAMESPACE="x86" IMPLEMENTATION="RichEdit.htc"?>
<link href="../css.css" rel="stylesheet" type="text/css">
</head>

<body>

<!--功能标题-->
<div class="page-title">网站Meta设置</div>
<%if return_info<>"" then%>
<div class="return-info"><%=return_info%></div>
<%end if%>
<div class="help-info">说明： <br>
  1、在此输入相关的每一个网页的Meta标签；<br>
  2、关于Meta标签的说明，请看后面的文章；<br>
</div>
<div class="oper-content"> 
  <form name="form1" method="post" action="" onSubmit="javascript:news_gb.value=news_gb1.html;news_en.value=news_en1.html;news_japan.value=news_japan1.html;news_ko.value=news_ko1.html;">
    <table width="95%" border="1" cellpadding="6" cellspacing="0" bordercolor="#CCCCCC" class="table-cell">
	  <%
			set rs=server.CreateObject("adodb.recordset")
			gb_to_big5=db_getvalue("setup_name='gb_to_big5'","sys_setup","setup_value")
			sql="select * from [language] where id in(" & show_language & ") order by id"
			rs.open sql,conn,1,1
			do while not rs.eof
			if rs("id")=2 and gb_to_big5="true" then
			else
		%>
		<tr> 
        <td width="100" align="right" bgcolor="#f2f8ff"><%=rs("language")%>网站Meta设置：</td>
          <td><textarea name="site_meta_<%=rs("id")%>" class="all_border" id="site_meta_<%=rs("id")%>" style="width:100%;height:150px;"><%=rs("site_meta")%></textarea></td>
        </tr>
		<%
			end if
				rs.movenext
			loop
			rs.close
			set rs=nothing
		%>
      <tr> 
        <td align="right" bgcolor="#f2f8ff">&nbsp;</td>
        <td><input type="submit" name="action" value="保存"> <input name="reset" type="reset" class="bt" id="reset" value="重置"> 
          <input name="lyb_id" type="hidden" id="lyb_id" value="<%=question_id%>"></td>
      </tr>
    </table>
    </form>
</div>
<div class="help-info"> Meta标签详解<br>
  <br>
  引言 <br>
  <br>
  您的个人网站即使做得再精彩，在“浩瀚如海”的网络空间中，也如一叶扁舟不易为人发现，如何推广<br>
  个人网站，人们首先想到的方法无外乎以下几种：<br>
  <br>
  ●　在搜索引擎中登录自己的个人网站 <br>
  ●　在知名网站加入你个人网站的链接 <br>
  ●　在论坛中发帖子宣传你的个人网站 <br>
  <br>
  很多人却忽视了HTML标签META的强大功效，一个好的META标签设计可以大大提高你的个人网站被搜索到的可能性，有兴趣吗，谁我来重新认识一下META标签吧！ 
  <br>
  META标签是HTML语言HEAD区的一个辅助性标签，它位于HTML文档头部的&lt;HEAD&gt;标记和&lt;TITLE&gt;标记之间，它提供用户不可见的信息。meta标签通常用来为搜索引擎robots定义页面主题，或者是定义用户浏览器上的cookie；它可以用于鉴别作者，设定页面格式，标注内容提要和关键字；还可以设置页面使其可以根据你定义的时间间隔刷新自己,以及设置RASC内容等级，等等。 
  <br>
  <br>
  详细介绍 <br>
  <br>
  下面介绍一些有关 标记的例子及解释。 <br>
  <br>
  META标签分两大部分：HTTP标题信息(HTTP-EQUIV)和页面描述信息(NAME)。 <br>
  <br>
  ★HTTP-EQUIV <br>
  HTTP-EQUIV类似于HTTP的头部协议，它回应给浏览器一些有用的信息，以帮助正确和精确地显示网页内容。常用的HTTP-EQUIV类型有： <br>
  <br>
  1、Content-Type和Content-Language (显示字符集的设定) <br>
  说明：设定页面使用的字符集，用以说明主页制作所使用的文字已经语言，浏览器会根据此来调用相应的字符集显示page内容。 <br>
  用法：&lt;Meta http-equiv=&quot;Content-Type&quot; Content=&quot;text/html; Charset=gb2312&quot;&gt;<br>
  &lt;Meta http-equiv=&quot;Content-Language&quot; Content=&quot;zh-CN&quot;&gt; 
  <br>
  <br>
  注意：　该META标签定义了HTML页面所使用的字符集为GB2132，就是国标汉字码。如果将其中的“charset=GB2312”替换成“BIG5”，则该页面所用的字符集就是繁体中文Big5码。当你浏览一些国外的站点时，IE浏览器会提示你要正确显示该页面需要下载xx语支持。这个功能就是通过读取HTML页面META标签的Content-Type属性而得知需要使用哪种字符集显示该页面的。如果系统里没有装相应的字符集，则IE就提示下载。其他的语言也对应不同的charset，比如日文的字符集是“iso-2022-jp 
  ”，韩文的是“ks_c_5601”。<br>
  <br>
  Content-Type的Content还可以是：text/xml等文档类型；<br>
  Charset选项：ISO-8859-1(英文)、BIG5、UTF-8、SHIFT-Jis、Euc、Koi8-2、us-ascii, x-mac-roman, 
  iso-8859-2, x-mac-ce, iso-2022-jp, x-sjis, x-euc-jp,euc-kr, iso-2022-kr, gb2312, 
  gb_2312-80, x-euc-tw, x-cns11643-1,x-cns11643-2等字符集；Content-Language的Content还可以是：EN、FR等语言代码。 
  <br>
  <br>
  2、Refresh (刷新) <br>
  说明：让网页多长时间（秒）刷新自己，或在多长时间后让网页自动链接到其它网页。<br>
  用法：&lt;Meta http-equiv=&quot;Refresh&quot; Content=&quot;30&quot;&gt;<br>
  &lt;Meta http-equiv=&quot;Refresh&quot; Content=&quot;5; Url=http://www.xia8.net&quot;&gt;<br>
  注意：其中的5是指停留5秒钟后自动刷新到URL网址。 <br>
  <br>
  3、Expires (期限) <br>
  说明：指定网页在缓存中的过期时间，一旦网页过期，必须到服务器上重新调阅。<br>
  用法：&lt;Meta http-equiv=&quot;Expires&quot; Content=&quot;0&quot;&gt;<br>
  &lt;Meta http-equiv=&quot;Expires&quot; Content=&quot;Wed, 26 Feb 1997 08:21:57 
  GMT&quot;&gt;<br>
  注意：必须使用GMT的时间格式，或直接设为0(数字表示多少时间后过期)。 <br>
  <br>
  4、Pragma (cach模式) <br>
  说明：禁止浏览器从本地机的缓存中调阅页面内容。<br>
  用法：&lt;Meta http-equiv=&quot;Pragma&quot; Content=&quot;No-cach&quot;&gt;<br>
  注意：网页不保存在缓存中，每次访问都刷新页面。这样设定，访问者将无法脱机浏览。 <br>
  <br>
  5、Set-Cookie (cookie设定) <br>
  说明：浏览器访问某个页面时会将它存在缓存中，下次再次访问时就可从缓存中读取，以提高速度。当你希望访问者每次都刷新你广告的图标，或每次都刷新你的计数器，就要禁用缓存了。通常HTML文件没有必要禁用缓存，对于ASP等页面，就可以使用禁用缓存，因为每次看到的页面都是在服务器动态生成的，缓存就失去意义。如果网页过期，那么存盘的cookie将被删除。<br>
  用法：&lt;Meta http-equiv=&quot;Set-Cookie&quot; Content=&quot;cookievalue=xxx; 
  expires=Wednesday,<br>
  21-Oct-98 16:14:21 GMT; path=/&quot;&gt;<br>
  注意：必须使用GMT的时间格式。 <br>
  <br>
  6、Window-target (显示窗口的设定) <br>
  说明：强制页面在当前窗口以独立页面显示。<br>
  用法：&lt;Meta http-equiv=&quot;Widow-target&quot; Content=&quot;_top&quot;&gt;<br>
  注意：这个属性是用来防止别人在框架里调用你的页面。Content选项：_blank、_top、_self、_parent。 <br>
  <br>
  7、Pics-label (网页RSAC等级评定)<br>
  说明：在IE的Internet选项中有一项内容设置，可以防止浏览一些受限制的网站，而网站的限制级<br>
  别就是通过该参数来设置的。<br>
  用法：&lt;META http-equiv=&quot;Pics-label&quot; Contect=<br>
  &quot;(PICS－1.1'http://www.rsac.org/ratingsv01.html'<br>
  I gen comment 'RSACi North America Sever' by 'inet@microsoft.com' <br>
  for 'http://www.microsoft.com' on '1997.06.30T14:21－0500' r(n0 s0 v0 l0))&quot;&gt; 
  <br>
  注意：不要将级别设置的太高。RSAC的评估系统提供了一种用来评价Web站点内容的标准。用户可以设置Microsoft Internet Explorer（IE3.0以上）来排除包含有色情和暴力内容的站点。上面这个例子中的HTML取自Microsoft的主页。代码中的（n 
  0 s 0 v 0 l 0）表示该站点不包含不健康内容。级别的评定是由RSAC，即美国娱乐委员会的评级机构评定的，如果你想进一步了解RSAC评估系统的等级内容，或者你需要评价自己的网站，可以访问RSAC的站点：http://www.rsac.org/。 
  <br>
  <br>
  8、Page-Enter、Page-Exit (进入与退出) <br>
  说明：这个是页面被载入和调出时的一些特效。<br>
  用法：&lt;Meta http-equiv=&quot;Page-Enter&quot; Content=&quot;blendTrans(Duration=0.5)&quot;&gt;<br>
  &lt;Meta http-equiv=&quot;Page-Exit&quot; Content=&quot;blendTrans(Duration=0.5)&quot;&gt;<br>
  注意：blendTrans是动态滤镜的一种，产生渐隐效果。另一种动态滤镜RevealTrans也可以用于页面进入与退出效果: <br>
  &lt;Meta http-equiv=&quot;Page-Enter&quot; Content=&quot;revealTrans(duration=x, 
  transition=y)&quot;&gt;<br>
  &lt;Meta http-equiv=&quot;Page-Exit&quot; Content=&quot;revealTrans(duration=x, 
  transition=y)&quot;&gt; <br>
  <br>
  Duration　表示滤镜特效的持续时间(单位：秒)<br>
  Transition　滤镜类型。表示使用哪种特效，取值为0-23。 <br>
  <br>
  0 矩形缩小<br>
  1 矩形扩大<br>
  2 圆形缩小<br>
  3 圆形扩大<br>
  4 下到上刷新<br>
  5 上到下刷新<br>
  6 左到右刷新<br>
  7 右到左刷新<br>
  8 竖百叶窗<br>
  9 横百叶窗<br>
  10 错位横百叶窗<br>
  11 错位竖百叶窗<br>
  12 点扩散<br>
  13 左右到中间刷新<br>
  14 中间到左右刷新<br>
  15 中间到上下<br>
  16 上下到中间<br>
  17 右下到左上<br>
  18 右上到左下<br>
  19 左上到右下<br>
  20 左下到右上<br>
  21 横条<br>
  22 竖条<br>
  23 以上22种随机选择一种 <br>
  <br>
  9、MSThemeCompatible (XP主题)<br>
  说明：是否在IE中关闭 xp 的主题<br>
  用法：&lt;Meta http-equiv=&quot;MSThemeCompatible&quot; Content=&quot;Yes&quot;&gt;<br>
  注意：关闭 xp 的蓝色立体按钮系统显示样式，从而和win2k 很象。 <br>
  <br>
  10、IE6 (页面生成器)<br>
  说明：页面生成器generator，是ie6<br>
  用法：&lt;Meta http-equiv=&quot;IE6&quot; Content=&quot;Generator&quot;&gt;<br>
  注意：用什么东西做的，类似商品出厂厂商。 <br>
  <br>
  11、Content-Script-Type (脚本相关)<br>
  说明：这是近来W3C的规范，指明页面中脚本的类型。<br>
  用法：&lt;Meta http-equiv=&quot;Content-Script-Type&quot; Content=&quot;text/javascript&quot;&gt;<br>
  注意： <br>
  <br>
  ★NAME变量 <br>
  <br>
  name是描述网页的，对应于Content（网页内容），以便于搜索引擎机器人查找、分类（目前几乎所有的搜索引擎都使用网上机器人自动查找meta值来给网页分类）。<br>
  name的value值（name=&quot;&quot;）指定所提供信息的类型。有些值是已经定义好的。例如description(说明)、keyword(关键字)、refresh(刷新)等。还可以指定其他任意值，如：creationdate(创建日期) 
  、<br>
  document ID(文档编号)和level(等级)等。<br>
  name的content指定实际内容。如：如果指定level(等级)为value(值)，则Content可能是beginner(初级)、intermediate(中级)、advanced(高级)。 
  <br>
  <br>
  1、Keywords (关键字)<br>
  说明：为搜索引擎提供的关键字列表<br>
  用法：&lt;Meta name=&quot;Keywords&quot; Content=&quot;关键词1,关键词2，关键词3,关键词4,……&quot;&gt;<br>
  注意：各关键词间用英文逗号“,”隔开。META的通常用处是指定搜索引擎用来提高搜索质量的关键词。当数个META元素提供文档语言从属信息时，搜索引擎会使用lang特性来过滤并通过用户的语言优先参照来显示搜索结果。例如：<br>
  &lt;Meta name=&quot;Kyewords&quot; Lang=&quot;EN&quot; Content=&quot;vacation,greece,sunshine&quot;&gt;<br>
  &lt;Meta name=&quot;Kyewords&quot; Lang=&quot;FR&quot; Content=&quot;vacances,grè:ce,soleil&quot;&gt; 
  <br>
  <br>
  2、Description (简介)<br>
  说明：Description用来告诉搜索引擎你的网站主要内容。<br>
  用法：&lt;Meta name=&quot;Description&quot; Content=&quot;你网页的简述&quot;&gt;<br>
  注意： <br>
  <br>
  3、Robots (机器人向导)<br>
  说明：Robots用来告诉搜索机器人哪些页面需要索引，哪些页面不需要索引。Content的参数有all、none、index、noindex、follow、nofollow。默认是all。<br>
  用法：&lt;Meta name=&quot;Robots&quot; Content=&quot;All|None|Index|Noindex|Follow|Nofollow&quot;&gt;<br>
  注意：许多搜索引擎都通过放出robot/spider搜索来登录网站，这些robot/spider就要用到meta元素的一些特性来决定怎样登录。 <br>
  <br>
  all：文件将被检索，且页面上的链接可以被查询；<br>
  none：文件将不被检索，且页面上的链接不可以被查询；(和 &quot;noindex, no follow&quot; 起相同作用)<br>
  index：文件将被检索；（让robot/spider登录）<br>
  follow：页面上的链接可以被查询；<br>
  noindex：文件将不被检索，但页面上的链接可以被查询；(不让robot/spider登录)<br>
  nofollow：文件将不被检索，页面上的链接可以被查询。(不让robot/spider顺着此页的连接往下探找) <br>
  <br>
  4、Author (作者)<br>
  说明：标注网页的作者或制作组<br>
  用法：&lt;Meta name=&quot;Author&quot; Content=&quot;张三，abc@sina.com&quot;&gt;<br>
  注意：Content可以是：你或你的制作组的名字,或Email <br>
  <br>
  5、Copyright (版权)<br>
  说明：标注版权<br>
  用法：&lt;Meta name=&quot;Copyright&quot; Content=&quot;本页版权归Zerospace所有。All Rights 
  Reserved&quot;&gt;<br>
  注意： <br>
  <br>
  6、Generator (编辑器)<br>
  说明：编辑器的说明<br>
  用法：&lt;Meta name=&quot;Generator&quot; Content=&quot;PCDATA|FrontPage|&quot;&gt;<br>
  注意：Content=&quot;你所用编辑器&quot; <br>
  <br>
  7、revisit-after (重访)<br>
  说明：<br>
  用法：&lt;META name=&quot;revisit-after&quot; CONTENT=&quot;7 days&quot; &gt;<br>
  注意： <br>
  <br>
  <br>
  ★Head中的其它一些用法 <br>
  <br>
  1、scheme (方案)<br>
  说明：scheme can be used when name is used to specify how the value of content 
  should<br>
  be interpreted.<br>
  用法：&lt;meta scheme=&quot;ISBN&quot; name=&quot;identifier&quot; content=&quot;0-14-043205-1&quot; 
  /&gt;<br>
  注意： <br>
  <br>
  2、Link (链接)<br>
  说明：链接到文件<br>
  用法：&lt;Link href=&quot;soim.ico&quot; rel=&quot;Shortcut Icon&quot;&gt;<br>
  注意：很多网站如果你把她保存在收件夹中后，会发现它连带着一个小图标，如果再次点击进入之后还会发现地址栏中也有个小图标。现在只要在你的页头加上这段话，就能轻松实现这一功能。&lt;LINK&gt; 
  用来将目前文件与其它 URL 作连结，但不会有连结按钮，用於 &lt;HEAD&gt; 标记间， 格式如下： <br>
  &lt;link href=&quot;URL&quot; rel=&quot;relationship&quot;&gt; <br>
  &lt;link href=&quot;URL&quot; rev=&quot;relationship&quot;&gt; <br>
  <br>
  3、Base (基链接)<br>
  说明：插入网页基链接属性<br>
  用法：&lt;Base href=&quot;http://www.xia8.net/&quot; target=&quot;_blank&quot;&gt;<br>
  注意：你网页上的所有相对路径在链接时都将在前面加上“http://www.cn8cn.com/”。其中target=&quot;_blank&quot;是链接文件在新的窗口中打开，你可以做其他设置。将“_blank”改为“_parent”是链接文件将在当前窗口的父级窗口中打开；改为“_self”链接文件在当前窗口（帧）中打开；改为“_top”链接文件全屏显示。 
  <br>
  以上是META标签的一些基本用法，其中最重要的就是：Keywords和Description的设定。为什么呢？道理很简单，这两个语句可以让搜索引擎能准确的发现你，吸引更多的人访问你的站点!根据现在流行搜索引擎(Google，Lycos，AltaVista等)的工作原理，搜索引擎先派机器人自动在WWW上搜索，当发现新的网站时，便于检索页面中的Keywords和Description，并将其加入到自己的数据库，然后再根据关键词的密度将网站排序。 
  <br>
  <br>
  由此看来，我们必须记住添加Keywords和Description的META标签，并尽可能写好关键字和简介。否则，<br>
  后果就会是：<br>
  <br>
  ●　如果你的页面中根本没有Keywords和Description的META标签，那么机器人是无法将你的站点加入数 据库，网友也就不可能搜索到你的站点。 
  <br>
  ●　如果你的关键字选的不好，关键字的密度不高，被排列在几十甚至几百万个站点的后面被点击的可 能性也是非常小的。 <br>
  <br>
  写好Keywords(关键字)要注意以下几点： <br>
  <br>
  ●　不要用常见词汇。例如www、homepage、net、web等。<br>
  ●　不要用形容词，副词。例如最好的，最大的等。 <br>
  ●　不要用笼统的词汇，要尽量精确。例如“爱立信手机”，改用“T28SC”会更好。 <br>
  <br>
  “三人之行，必有我师”，寻找合适关键词的技巧是：到Google、Lycos、Alta等著名搜索引擎，搜索与<br>
  你的网站内容相仿的网站，查看排名前十位的网站的META关键字，将它们用在你的网站上，效果可想而知了。<br>
</div>
<br>
<div class="page-foot"><%=db_getvalue("setup_name='page_foot'","sys_setup","setup_value")%></div><br>
</body>
</html>
