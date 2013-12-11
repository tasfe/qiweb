<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:output method="html" encoding="utf-8" indent="yes"/>
	<!--统一调用页面的页头页尾模板-->
	<xsl:template match="/">
		<html>
			<!--调用统一的HEAD内容-->
			<head>
				<meta http-equiv="Content-Type" content="text/html; charset=uft-8"/>
				<xsl:value-of select="//site_meta" disable-output-escaping="yes"/>		
				<title>
					<xsl:if test="//page_head_title!=''">
						<xsl:value-of select="//page_head_title"/> --
					</xsl:if>
					<xsl:value-of select="//site_name"/>
				</title>
				<script type="text/javascript" src="js/prototype.js"></script>
				<script type="text/javascript" src="js/scriptaculous.js?load=effects"></script>
				<script type="text/javascript" src="js/lightbox.js"></script>
				<link rel="stylesheet" href="css/lightbox.css" type="text/css" media="screen" />
				<link href="template/site/css/index18.css" rel="stylesheet" type="text/css" media="screen"/>
				<!-- 打印时候使用的样式表 -->
				<link href="template/site/css/print.css" rel="stylesheet" type="text/css" media="print"/>
			</head>
			<!--head完成-->		
			<body>
			<div class="content">
				<div class="page-top">
				<div class="page-title">
					<!--网站LOGO-->
					<xsl:if test="page/site_logo!=''">
						<div class="site-logo" style="background-image:url({page/site_logo})">
						<a href="default.asp">
							<img src="{page/site_logo}" alt="{//site_name} LOGO" id="logo"/>
						</a></div>
					</xsl:if>
					<!--网站广告-->
					<div class="page-adv"><xsl:value-of select="//site_adv" disable-output-escaping="yes"/></div>
					<div class="language-button">
						<!--语言选择按钮-->
						<span>
							<xsl:for-each select="page/public_language/language_name">
								<a href="start.asp?language={@id}" class="language_button"><xsl:value-of select="."/></a>
							</xsl:for-each>
						</span>
					</div>
					<!--网站名称-->	
					<!--
					<div class="site-name"><xsl:value-of select="//site_name"/></div>
					-->
					</div>
				</div>
				<div class="page-body">
				
					<div class="body-left">
						<xsl:if test="count(//site_news)>0">
						<!--
						<div class="page-nav">
						
							<div class="body-left-title"><span><xsl:value-of select="/page/language_pack/text_news"/></span></div>
						
							<div class="news-content">
								<marquee width="100%" height="160" direction="up"  scrollAmount="{//para_news_scrollAmount}">
								<xsl:value-of select="//site_news" disable-output-escaping="yes"/>
								</marquee>
							</div>
						</div>
						-->
						</xsl:if>
						<!--搜索框架-->
						<div class="page-search">
							
							<form action="index.asp" name="search_form" method="get">
							<div class="main-menu">
							<xsl:value-of select="/page/language_pack/text_product_search"/>
							</div>
								<input name="keyword" id="keyword" type="text"/>
								<input type="image" src="template/site/images/18/search.gif" name="action" value="search"/>
							</form>
						</div>
						<!--菜单-->
						<div class="page-menu" ID="divMenuBar">
							<ul>
							<xsl:for-each select="page/sitemap/pagename">
								<xsl:if test="page_id=/page/parent_page">
									<li><a href="index.asp?sitepage={page_id}" id="active-link"  class="main-menu">
									<xsl:attribute name="title">tdMenuBarItem<xsl:value-of select="page_id" /></xsl:attribute>
									<span><xsl:value-of select="title"/></span></a>
									<xsl:if test="count(sitemap)>0">
										<ul>
											<xsl:for-each select="sitemap/pagename">
												<xsl:if test="page_id=/page/cur_page">
													<li><a href="index.asp?sitepage={page_id}" id="nav-link" class="sub-menu"><xsl:value-of select="title"/></a></li>
												</xsl:if>
												<xsl:if test="page_id!=/page/cur_page">
													<li><a href="index.asp?sitepage={page_id}" class="sub-menu"><xsl:value-of select="title"/></a></li>
												</xsl:if>
											</xsl:for-each>
										</ul>
									</xsl:if>
									</li>
								</xsl:if>
								<xsl:if test="page_id!=/page/parent_page">
									<li><a href="index.asp?sitepage={page_id}"  class="main-menu">
									<xsl:attribute name="ID">tdMenuBarItem<xsl:value-of select="page_id" /></xsl:attribute>
									<span><xsl:value-of select="title"/></span></a>
									<xsl:if test="count(sitemap)>0">
										<ul>
											<xsl:for-each select="sitemap/pagename">
												<xsl:if test="page_id=/page/cur_page">
													<li><a href="index.asp?sitepage={page_id}" id="nav-link" class="sub-menu"><xsl:value-of select="title"/></a></li>
												</xsl:if>
												<xsl:if test="page_id!=/page/cur_page">
													<li><a href="index.asp?sitepage={page_id}" class="sub-menu"><xsl:value-of select="title"/></a></li>
												</xsl:if>
											</xsl:for-each>
										</ul>
									</xsl:if>
									</li>
								</xsl:if>
							</xsl:for-each>
							</ul>
						</div>
						<!--侧边广告代码-->
						<div id="link_adv"></div>
					</div>
				
					<div class="body-middle">
						<!--装饰物-->
						<xsl:if test="//frame!='' and count(page/product_list/product)!=1">
							
							<xsl:value-of select="//frame" disable-output-escaping="yes"/>
						</xsl:if>
						<xsl:if test="//frame=''">
						<div class="page-xp">
						</div>
						</xsl:if>
						<div class="body-content">
							<xsl:if test="page/data_style=0">
							<!--调用普通图文-->
								<xsl:call-template name="article"/>
							</xsl:if>
							<xsl:if test="page/data_style=1">
							<!--调用产品数据-->
								<xsl:call-template name="product"/>
							</xsl:if>
							<xsl:if test="page/data_style=2">
								<xsl:call-template name="lyb"/>
							<!--调用留言板-->
							</xsl:if>
							<xsl:if test="page/data_style=4">
								<xsl:call-template name="guestbook"/>
							<!--调用客户反馈-->
							</xsl:if>
							<xsl:if test="page/data_style=5">
								<xsl:call-template name="album"/>
							<!--调用相册-->
							</xsl:if>
							<xsl:if test="page/data_style=6">
								<xsl:call-template name="filelist"/>
							<!--调用文件下载-->
							</xsl:if>
							<xsl:if test="page/data_style=7">
								<xsl:call-template name="movie"/>
							<!--调用视频MP3列表-->
							</xsl:if>
							<xsl:if test="page/data_style=99">
								<xsl:call-template name="search_list"/>
							<!--调用查找结果列表-->
							</xsl:if>
							<!--调用用户定制的模块-->
							<xsl:for-each select="page/user_template/page_content">
							<!--
								<xsl:value-of select="." disable-output-escaping="yes"/>
								-->
							</xsl:for-each>
							<!--调用用户特殊定制的内容-->
							<xsl:for-each select="page/user/page_content">
								<xsl:value-of select="." disable-output-escaping="yes"/>
							</xsl:for-each>
							<!--显示页面关键词-->
							<xsl:if test="//keyword!=''">
							<div class="page-keyword">Tag : <b><xsl:value-of select="//keyword" disable-output-escaping="yes"/>
							</b></div>
							</xsl:if>
						</div>
						
						<!--正文底部广告代码-->
						<div id="content_bottom_adv"></div>
						<!--显示页面支持的RSS，RSS2。0，sitemap的图标-->
						<div id="web-code">
							<a href="javascript:print();" title="Print this page!"><img src="images/printer.png" alt="printer Version"/></a>
							<a href="index.asp?viewer=wap" target="_blank" title="View by your handphone!"><img src="images/wap.png" alt="WAP Version"/></a>
							<a href="rss1.asp" target="_blank"><img src="images/rss100.png" alt="RSS1.0 Version"/></a>
							<a href="rss2.asp" target="_blank"><img src="images/rss200.png" alt="RSS2.0 Version"/></a>
							<a href="sitemap.asp" target="_blank"><img src="images/sitemap.png" alt="Google Sitemap 1.0 Power by qiweb.cn"/></a>
							<script language="JavaScript"> 
							<xsl:comment><![CDATA[
							var __cc_uid="admin";
							]]></xsl:comment>
							</script>
							<script language="JavaScript" src="admin/count/count.js"></script>
						</div>
					</div>
					<!--此栏内容固定-->
					<div class="body-right">
						<div class="shop">
						<a href="pd_car.asp" style="color: white">Shopping Basket</a>
						</div>
						<div class="buy">
							<b>Items: <xsl:value-of select="page/user_template/page_content" disable-output-escaping="yes"/></b> <br/>
							<i>&#187; <a href="pd_car.asp">View full details</a></i>
						</div>
						
					</div>
				</div>
				<!--友情链接-->
				<xsl:if test="count(page/linklist/link)>0">
				<div class="page-link">
					<div class="page-link-title"><xsl:value-of select="/page/language_pack/text_link"/></div>
					
					<!--图片链接-->
					<div class="logo-link">
						<xsl:for-each select="page/linklist/link[link_logo!='']">
						<a href="{link_url}" target="_blank"><img src="{link_logo}" alt="{link_desc}"/></a>
						</xsl:for-each>
					</div>
					
					<!--文字链接-->
					<div class="text-link">
						<xsl:for-each select="page/linklist/link[link_logo='']">
							<a href="{link_url}" target="_blank"><xsl:value-of select="link_name"/></a>
						</xsl:for-each>
					</div>
				</div><br/>
				</xsl:if>
				<div class="page-foot">
				<div class="courtesy">
				<div align="center">
					<span style="float: right"><a onclick="scrollTo(0,0)" href="javascript:;"><img src="http://www.yjx888.cn/images/up.gif" height="10px" width="10px" alt="top" style="vertical-align: middle"/> Top</a></span><a href="http://www.yjx888.cn/" title="sex toys">Sex Toys</a> | <a href="http://www.yjx888.cn/become-an-affiliate.asp">Become an Affiliate</a> | <a href="http://www.yjx888.cn/help.asp?fn=a&amp;id0=36">About Us</a> | <a href="http://www.yjx888.cn/privacy-policy.asp">Privacy Policy</a> | <a href="http://www.yjx888.cn/typos.asp">Typos</a> | <a href="http://www.yjx888.cn/linkexchange.asp">Resources</a> | <a href="http://www.yjx888.cn/sitemap.asp">Site Map</a><br/>
				</div>
				</div>
				<span>
				<xsl:value-of select="//foot_info" disable-output-escaping="yes"/></span></div>
				
				
				<!--页面底部广告代码-->
				<div id="page_bottom_adv"></div>
				<!--最后面才加载广告不影响页面的显示-->
				
				
				
			</div>
			</body>
		</html>
	</xsl:template>
	
	<!--调用普通图文-->
	<xsl:template name="article">
		<!--多于一篇文章显示列表-->
		<xsl:if test="count(page/article_list/article)>1">
			<div class="article-title"><h1>
				<xsl:value-of select="page/sitemap/pagename/title[../page_id=//parent_page]"/>
				<xsl:if test="//parent_page!=//cur_page">
					>>
					<xsl:value-of select="page/sitemap/pagename/sitemap/pagename/title[../page_id=//cur_page]"/>
				</xsl:if></h1>
			</div>
			<!--调用分页-->
			<xsl:call-template name="page_nav">
				<xsl:with-param name="page_name">index.asp?sitepage=<xsl:value-of select="//cur_page"/>&amp;</xsl:with-param>
			</xsl:call-template>
			<!--显示文章列表-->
			<xsl:for-each select="page/article_list/article">
				<div class="article-list">
					<a href="index.asp?sitepage={//cur_page}&amp;contentid={content_id}" target="_blank"><li><xsl:value-of select="title"/></li></a>
					<xsl:value-of select="create_date"/>
				</div>
			</xsl:for-each>
			<!--调用分页-->
			<xsl:call-template name="page_nav">
				<xsl:with-param name="page_name">index.asp?sitepage=<xsl:value-of select="//cur_page"/>&amp;</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
		<!--一篇文章显示当前文章内容-->
		<xsl:if test="count(page/article_list/article)=1">
			<div class="article-title"><h1><xsl:value-of select="page/article_list/article/title"/></h1></div>
			<div class="article-content"><xsl:value-of select="page/article_list/article/content" disable-output-escaping="yes"/></div>
			<div class="article-date"><xsl:value-of select="/page/language_pack/text_edit_time"/><xsl:value-of select="page/article_list/article/create_date"/></div>
		</xsl:if>
		<!--没有文章显示空白页面-->
		<xsl:if test="count(page/article_list/article)=0">
			<div class="page-empty"></div>
		</xsl:if>
	</xsl:template>
	<!--调用产品数据-->
	<xsl:template name="product">
		<!--没有产品时显示的内容-->
		<xsl:if test="count(page/product_list/product)=0">
			<div class="article-title"><h1>
				<xsl:value-of select="page/sitemap/pagename/title[../page_id=//parent_page]"/>
				<xsl:if test="//parent_page!=//cur_page">
					>>
					<xsl:value-of select="page/sitemap/pagename/sitemap/pagename/title[../page_id=//cur_page]"/>
				</xsl:if>
				<xsl:if test="count(//keyword)!=0">
					查找关键字“<font color="red"><xsl:value-of select="//keyword"/></font>”的结果如下：
				</xsl:if></h1>
			</div>
			<div class="page-empty"></div>
		</xsl:if>
		<!--只有一个产品时的显示方式-->
		<xsl:if test="count(page/product_list/product)=1">
			<xsl:for-each select="page/product_list/product">
				<div class="product-title"><h1><xsl:value-of select="/page/language_pack/text_product_name"/><strong><xsl:value-of select="title"/></strong></h1></div>
				<div class="product-pic">
					<xsl:if test="pic!=''">
						<a href="{picture}" target="_blank">
						<img src="{pic}" alt="{title}" width="140px"/>
						</a>
					</xsl:if>	
					<xsl:if test="pic=''">
						<img src="template/site/images/no_pic.gif" alt="{//site_name}"/>
					</xsl:if>				
				</div>
				<div class="product-price"><xsl:value-of select="/page/language_pack/text_product_price"/><xsl:value-of select="price"/> <xsl:value-of select="/page/language_pack/text_price_unit"/></div>
				<div class="product-num"><xsl:value-of select="/page/language_pack/text_product_amount"/><xsl:value-of select="num"/> <xsl:value-of select="/page/language_pack/text_product_unit"/></div>
				<!--此处显示订购按钮和购物车按钮-->
				<xsl:if test="//site_shop_open=1">
				<div class="product-botton">
					<a href="pd_buy.asp?id={content_id}" target="pd_buy"><span><xsl:value-of select="/page/language_pack/text_product_buy"/></span></a>
					<a href="pd_car.asp"><span><xsl:value-of select="/page/language_pack/text_product_car"/></span></a>
				</div>
				</xsl:if>
				<!--end code-->
				<div class="product-content">
				<li><strong><xsl:value-of select="/page/language_pack/text_product_detail"/></strong></li><hr size="1"/><xsl:value-of select="content" disable-output-escaping="yes"/>
				</div>
				<xsl:if test="picture!=''">
					<div class="product-pictures">
						<li><strong><xsl:value-of select="/page/language_pack/text_product_picture"/></strong></li><hr size="1"/>
						<!--根据系统设置，设置图片的大小-->
						<xsl:if test="//para_picture_width='' and //para_picture_height=''">
						<img src="{picture}" alt="{title}" width="500px"/>
						</xsl:if>
						<xsl:if test="//para_picture_width='' and //para_picture_height!=''">
						<img src="{picture}" alt="{title}" height="{//para_picture_height}px"/>
						</xsl:if>
						<xsl:if test="//para_picture_width!='' and //para_picture_height=''">
						<img src="{picture}" alt="{title}" width="{//para_picture_width}px"/>
						</xsl:if>
						<xsl:if test="//para_picture_width!='' and //para_picture_height!=''">
						<img src="{picture}" alt="{title}" width="{//para_picture_width}px" height="{//para_picture_height}px"/>
						</xsl:if>
						<!--end code-->
					</div>
				</xsl:if>
				<xsl:if test="pictures!=''">
					<div class="product-pictures">
						<li><strong><xsl:value-of select="/page/language_pack/text_product_pictures"/></strong></li><hr size="1"/><xsl:value-of select="pictures" disable-output-escaping="yes"/>
					</div>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
		<!--多于一个产品时的显示方式-->
		<xsl:if test="count(page/product_list/product)>1">
			<!--
			<div class="article-title"><h1>
			
				<xsl:value-of select="page/sitemap/pagename/title[../page_id=//parent_page]"/>
				<xsl:if test="//parent_page!=//cur_page">
					>>
					<xsl:value-of select="page/sitemap/pagename/sitemap/pagename/title[../page_id=//cur_page]"/>
				</xsl:if></h1>
			</div>
			-->
			<!--调用分页-->
			<xsl:call-template name="page_nav">
				<xsl:with-param name="page_name">index.asp?keyword=<xsl:value-of select="//keyword"/>&amp;sitepage=<xsl:value-of select="//cur_page"/>&amp;</xsl:with-param>
			</xsl:call-template>
			<!--显示产品列表-->
			<xsl:for-each select="page/product_list/product">
				<div class="product_list">
					<xsl:if test="pic=''">
						<img src="template/site/images/no_pic.gif" alt="{//site_name}"/>
					</xsl:if>
					<xsl:if test="pic!=''">
						<a href="index.asp?sitepage={//cur_page}&amp;contentid={content_id}" style="border:0px solid #ccc;background:#fff;" target="_blank">
						<!--根据系统设置，设置图片的大小-->
						<xsl:if test="//para_pic_width='' and //para_pic_height=''">
						<img src="{pic}" alt="{title}" width="110px"/>
						</xsl:if>
						<xsl:if test="//para_pic_width='' and //para_pic_height!=''">
						<img src="{pic}" alt="{title}" height="{//para_pic_height}px"/>
						</xsl:if>
						<xsl:if test="//para_pic_width!='' and //para_pic_height=''">
						<img src="{pic}" alt="{title}" width="{//para_pic_width}px"/>
						</xsl:if>
						<xsl:if test="//para_pic_width!='' and //para_pic_height!=''">
						<img src="{pic}" alt="{title}" width="{//para_pic_width}px" height="{//para_pic_height}px"/>
						</xsl:if>
						<!--end code-->
						</a>
					</xsl:if>
					<a href="index.asp?sitepage={//cur_page}&amp;contentid={content_id}" target="_blank">
					<strong><xsl:value-of select="title"/></strong></a>
					<div>RRP:&#163;<xsl:value-of select="price*1.25"/>
					</div>
					<div><strong>Our Price:&#163;<xsl:value-of select="price"/>
					</strong>
					</div>
					<div><a href="pd_buy.asp?id={content_id}" target="pd_buy" id="buyit2">Add</a>
					<a href="index.asp?sitepage={//cur_page}&amp;contentid={content_id}" target="_blank" id="info2">Info</a>
					</div>
				</div>
			</xsl:for-each>
			<!--调用分页-->
			<xsl:call-template name="page_nav">
				<xsl:with-param name="page_name">index.asp?keyword=<xsl:value-of select="//keyword"/>&amp;sitepage=<xsl:value-of select="//cur_page"/>&amp;</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<!--调用留言本-->
	<xsl:template name="lyb">
		<div class="article-title"><h1>
			<xsl:value-of select="page/sitemap/pagename/title[../page_id=//parent_page]"/>
			<xsl:if test="//parent_page!=//cur_page">
				>>
				<xsl:value-of select="page/sitemap/pagename/sitemap/pagename/title[../page_id=//cur_page]"/>
			</xsl:if></h1>
		</div>
		<div class="lyb-button"><a href="#ly"><xsl:value-of select="/page/language_pack/text_lyb_bt"/></a></div>
		<hr size="1"/>
		<!--调用分页-->
			<xsl:call-template name="page_nav">
				<xsl:with-param name="page_name">index.asp?sitepage=<xsl:value-of select="//cur_page"/>&amp;</xsl:with-param>
			</xsl:call-template>
		<xsl:for-each select="page/lyb_list/lyb">
			<div class="lyb-list">
				<ul>
					<li><xsl:value-of select="/page/language_pack/text_lyb_name"/><xsl:value-of select="user_id"/></li>
					<li><xsl:value-of select="/page/language_pack/text_lyb_email"/><a href="mailto:{lyb_email}" target="_blank"><xsl:value-of select="lyb_email"/></a></li>
					<li><xsl:value-of select="/page/language_pack/text_lyb_phone"/><xsl:value-of select="lyb_QQ"/></li>
					<li><xsl:value-of select="/page/language_pack/text_lyb_time"/><xsl:value-of select="lyb_date"/></li>
				</ul>
				<div class="lyb-title"><xsl:value-of select="/page/language_pack/text_title"/><xsl:value-of select="lyb_title"/></div>
				<div class="lyb-content"><xsl:value-of select="lyb_content" disable-output-escaping="yes"/></div>
				<xsl:if test="lyb_reply!=''">
				<div class="lyb-reply"><xsl:value-of select="/page/language_pack/text_lyb_reply"/><xsl:value-of select="lyb_reply" disable-output-escaping="yes"/></div>
				</xsl:if>
			</div>
		</xsl:for-each>
		<!--调用分页-->
			<xsl:call-template name="page_nav">
				<xsl:with-param name="page_name">index.asp?sitepage=<xsl:value-of select="//cur_page"/>&amp;</xsl:with-param>
			</xsl:call-template>
		<hr size="1"/>
		<div class="oper-info"><xsl:value-of select="/page/language_pack/text_add_lyb_help"/></div>
		<form action="lyb_save.asp" name="form1" method="post" id="lyb-form"><a name="ly"/>
			<table border="0" width="450px" cellpadding="4" cellspacing="0">
				<tr>
					<th><xsl:value-of select="/page/language_pack/text_add_lyb_name"/></th>
					<td><input type="text" name="user_id" style="width:100" class="inpt-text" value=""/>*</td>
				</tr>
				<tr>
					<th><xsl:value-of select="/page/language_pack/text_add_lyb_code"/></th>
					<td><input type="text" name="ValidCode" style="width:100" class="inpt-text" value=""/>
					<img src="xbm.asp" alt="{/page/language_pack/text_add_lyb_code}"/></td>
				</tr>
				<tr>
					<th><xsl:value-of select="/page/language_pack/text_add_lyb_phone"/></th>
					<td><input type="text" name="lyb_QQ" style="width:100" class="inpt-text" value=""/></td>
				</tr>
				<tr>
					<th><xsl:value-of select="/page/language_pack/text_add_lyb_email"/></th>
					<td><input type="text" name="lyb_email" style="width:200" class="inpt-text" value=""/></td>
				</tr>
				<tr>
					<th><xsl:value-of select="/page/language_pack/text_add_lyb_title"/></th>
					<td><input type="text" name="lyb_title" style="width:300" class="inpt-text" value=""/> *</td>
				</tr>
				<tr>
					<th><xsl:value-of select="/page/language_pack/text_add_lyb_content"/></th>
					<td><textarea name="lyb_content" class="inpt-text" style="width:300;height:80;">
						</textarea> *
					</td>
				</tr>
				<tr>
					<th></th>
					<td><input type="submit" name="action" value="{/page/language_pack/text_add_lyb_submit}" class="inpt-bt"/>
						<input type="reset" name="reset" value="{/page/language_pack/text_add_lyb_reset}" class="inpt-bt"/></td>
				</tr>
			</table>
		</form>
	</xsl:template>
	<!--调用客户反馈-->
	<xsl:template name="guestbook">
		<div class="article-title"><h1>
			<xsl:value-of select="page/sitemap/pagename/title[../page_id=//parent_page]"/>
			<xsl:if test="//parent_page!=//cur_page">
				>>
				<xsl:value-of select="page/sitemap/pagename/sitemap/pagename/title[../page_id=//cur_page]"/>
			</xsl:if></h1>
		</div>
		<div class="oper-info"><xsl:value-of select="/page/language_pack/text_guestbook_help"/></div>
		<form action="http://qiweb.cn/server/guestbook_save.asp" name="form1" method="post" id="lyb-form"><a name="ly"/>
			<table border="0" width="450px" cellpadding="4" cellspacing="0">
				<tr>
					<th><xsl:value-of select="/page/language_pack/text_add_lyb_name"/></th>
					<td><input type="text" name="user_id" style="width:100" class="inpt-text" value=""/>*</td>
				</tr>
				<tr>
					<th><xsl:value-of select="/page/language_pack/text_add_lyb_code"/></th>
					<td><input type="text" name="ValidCode" style="width:100" class="inpt-text" value=""/>
					<img src="http://qiweb.cn/server/xbm.asp" alt="{/page/language_pack/text_add_lyb_code}"/></td>
				</tr>
				<tr>
					<th><xsl:value-of select="/page/language_pack/text_add_lyb_phone"/></th>
					<td><input type="text" name="lyb_QQ" style="width:100" class="inpt-text" value=""/></td>
				</tr>
				<tr>
					<th><xsl:value-of select="/page/language_pack/text_add_lyb_email"/></th>
					<td><input type="text" name="lyb_email" style="width:200" class="inpt-text" value=""/></td>
				</tr>
				<tr>
					<th><xsl:value-of select="/page/language_pack/text_add_lyb_title"/></th>
					<td><input type="text" name="lyb_title" style="width:300" class="inpt-text" value=""/> *</td>
				</tr>
				<tr>
					<th><xsl:value-of select="/page/language_pack/text_add_lyb_content"/></th>
					<td><textarea name="lyb_content" class="inpt-text" style="width:300;height:80;">
						</textarea> *
					</td>
				</tr>
				<tr>
					<th></th>
					<td><input type="submit" name="action" value="{/page/language_pack/text_add_lyb_submit}" class="inpt-bt"/>
						<input type="reset" name="reset" value="{/page/language_pack/text_add_lyb_reset}" class="inpt-bt"/></td>
				</tr>
			</table>
		</form>
	</xsl:template>
	<!--调用相册格式-->
	<xsl:template name="album">
		<!--调用分页-->
		<xsl:call-template name="page_nav">
			<xsl:with-param name="page_name">index.asp?sitepage=<xsl:value-of select="//cur_page"/>&amp;</xsl:with-param>
		</xsl:call-template>
		<!--显示相片列表-->
		<xsl:for-each select="page/album_list/album">
			<div class="album_list">
				<a href="{pic}" rel="lightbox[qiweb]" title="{title}{content}">
				<!--根据系统设置，设置图片的大小-->
				<xsl:if test="//para_pic_width='' and //para_pic_height=''">
				<img src="{pic}" alt="{title}" width="110px"/>
				</xsl:if>
				<xsl:if test="//para_pic_width='' and //para_pic_height!=''">
				<img src="{pic}" alt="{title}" height="{//para_pic_height}px"/>
				</xsl:if>
				<xsl:if test="//para_pic_width!='' and //para_pic_height=''">
				<img src="{pic}" alt="{title}" width="{//para_pic_width}px"/>
				</xsl:if>
				<xsl:if test="//para_pic_width!='' and //para_pic_height!=''">
				<img src="{pic}" alt="{title}" width="{//para_pic_width}px" height="{//para_pic_height}px"/>
				</xsl:if>
				<!--end code-->
				<span><strong><xsl:value-of select="title"/></strong></span>
				</a>
			</div>
		</xsl:for-each>
		<!--调用分页-->
		<xsl:call-template name="page_nav">
			<xsl:with-param name="page_name">index.asp?sitepage=<xsl:value-of select="//cur_page"/>&amp;</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!--调用文件下载列表-->
	<xsl:template name="filelist">
		<!--没有软件时显示的内容-->
		<xsl:if test="count(page/software_list/software)=0">
			<div class="article-title"><h1>
				<xsl:value-of select="page/sitemap/pagename/title[../page_id=//parent_page]"/>
				<xsl:if test="//parent_page!=//cur_page">
					>>
					<xsl:value-of select="page/sitemap/pagename/sitemap/pagename/title[../page_id=//cur_page]"/>
				</xsl:if></h1>
			</div>
			<div class="page-empty"></div>
		</xsl:if>
		<!--只有一个软件时的显示方式-->
		<xsl:if test="count(page/software_list/software)=1">
			<xsl:for-each select="page/software_list/software">
				<div class="product-title"><h1><xsl:value-of select="/page/language_pack/text_software_name"/><strong><xsl:value-of select="title"/></strong></h1></div>
				<div class="product-pic">
					<xsl:if test="pic!=''">
						<a href="{pic}" target="_blank">
						<img src="{pic}" alt="{title}" width="200px"/>
						</a>
					</xsl:if>	
					<xsl:if test="pic=''">
						<img src="template/site/images/no_pic.gif" alt="{//site_name}"/>
					</xsl:if>				
				</div>
				<!--此处显示本地下载，其它下载按钮-->
				<div class="download-botton">
					<xsl:if test="picture!=''">
					<a href="software_download.asp?id={content_id}" target="pd_buy"><span><xsl:value-of select="/page/language_pack/text_download"/></span></a>
					</xsl:if>
					<xsl:if test="other_link!=''">
					<a href="#other_download"><span><xsl:value-of select="/page/language_pack/text_other_download"/></span></a>
					</xsl:if>&#160;
				</div>
				<!--end code-->
				<div class="product-content">
				<li><strong><xsl:value-of select="/page/language_pack/text_software_detail"/></strong></li><hr size="1"/><xsl:value-of select="content" disable-output-escaping="yes"/>
				</div>
				<a name="other_download"></a>
				<xsl:if test="other_link!=''">
					<div class="other-link">
						<li><strong><xsl:value-of select="/page/language_pack/text_other_download"/></strong></li><hr size="1"/><xsl:value-of select="other_link" disable-output-escaping="yes"/>
					</div>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
		<!--多于一个软件时的显示方式-->
		<xsl:if test="count(page/software_list/software)>1">
			<div class="article-title"><h1>
				<xsl:value-of select="page/sitemap/pagename/title[../page_id=//parent_page]"/>
				<xsl:if test="//parent_page!=//cur_page">
					>>
					<xsl:value-of select="page/sitemap/pagename/sitemap/pagename/title[../page_id=//cur_page]"/>
				</xsl:if></h1>
			</div>
			<!--调用分页-->
			<xsl:call-template name="page_nav">
				<xsl:with-param name="page_name">index.asp?keyword=<xsl:value-of select="//keyword"/>&amp;sitepage=<xsl:value-of select="//cur_page"/>&amp;</xsl:with-param>
			</xsl:call-template>
			<!--显示软件列表-->
			<xsl:for-each select="page/software_list/software">
				<div class="software_list">
					<a href="index.asp?sitepage={//cur_page}&amp;contentid={content_id}" target="_blank">
					<strong><xsl:value-of select="title"/></strong></a>
					<div>
					<span><img src="{pic}" width="100%" height="100%"/></span>
					<xsl:value-of select="content" disable-output-escaping="yes"/>
					</div>
				</div>
			</xsl:for-each>
			<!--调用分页-->
			<xsl:call-template name="page_nav">
				<xsl:with-param name="page_name">index.asp?keyword=<xsl:value-of select="//keyword"/>&amp;sitepage=<xsl:value-of select="//cur_page"/>&amp;</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<!--调用电影MP3视频内容-->
	<xsl:template name="movie">
		<!--没有视频时显示的内容-->
		<xsl:if test="count(page/movie_list/movie)=0">
			<div class="article-title"><h1>
				<xsl:value-of select="page/sitemap/pagename/title[../page_id=//parent_page]"/>
				<xsl:if test="//parent_page!=//cur_page">
					>>
					<xsl:value-of select="page/sitemap/pagename/sitemap/pagename/title[../page_id=//cur_page]"/>
				</xsl:if></h1>
			</div>
			<div class="page-empty"></div>
		</xsl:if>
		<!--只有一个视频时的显示方式-->
		<xsl:if test="count(page/movie_list/movie)=1">
			<xsl:for-each select="page/movie_list/movie">
				<div class="product-title"><h1><xsl:value-of select="/page/language_pack/text_movie_name"/><strong><xsl:value-of select="title"/></strong></h1></div>
				<div class="product-pic">
					<xsl:if test="pic!=''">
						<a href="{pic}" target="_blank">
						<img src="{pic}" alt="{title}" width="200px"/>
						</a>
					</xsl:if>	
					<xsl:if test="pic=''">
						<img src="template/site/images/no_pic.gif" alt="{//site_name}"/>
					</xsl:if>				
				</div>
				<!--此处显示本地下载，其它下载按钮-->
				<div class="download-botton">
					<xsl:if test="picture!=''">
					<a href="movie_download.asp?id={content_id}" target="pd_buy"><span><xsl:value-of select="/page/language_pack/text_download"/></span></a>
					</xsl:if>
					<xsl:if test="other_link!=''">
					<a href="#other_download"><span><xsl:value-of select="/page/language_pack/text_other_download"/></span></a>
					</xsl:if>&#160;
				</div>
				<!--end code-->
				<div class="product-content">
				<li><strong><xsl:value-of select="/page/language_pack/text_movie_play"/></strong></li><hr size="1"/>
				<div class="text_movie_play"><span>
				<xsl:value-of select="picture" disable-output-escaping="yes"/>
				</span>
				</div>
				</div>
				<div class="product-content">
				<li><strong><xsl:value-of select="/page/language_pack/text_movie_detail"/></strong></li><hr size="1"/><xsl:value-of select="content" disable-output-escaping="yes"/>
				</div>
				<a name="other_download"></a>
				<xsl:if test="other_link!=''">
					<div class="other-link">
						<li><strong><xsl:value-of select="/page/language_pack/text_other_download"/></strong></li><hr size="1"/><xsl:value-of select="other_link" disable-output-escaping="yes"/>
					</div>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
		<!--多于一个视频时的显示方式-->
		<xsl:if test="count(page/movie_list/movie)>1">
			<div class="article-title"><h1>
				<xsl:value-of select="page/sitemap/pagename/title[../page_id=//parent_page]"/>
				<xsl:if test="//parent_page!=//cur_page">
					>>
					<xsl:value-of select="page/sitemap/pagename/sitemap/pagename/title[../page_id=//cur_page]"/>
				</xsl:if></h1>
			</div>
			<!--调用分页-->
			<xsl:call-template name="page_nav">
				<xsl:with-param name="page_name">index.asp?keyword=<xsl:value-of select="//keyword"/>&amp;sitepage=<xsl:value-of select="//cur_page"/>&amp;</xsl:with-param>
			</xsl:call-template>
			<!--显示视频列表-->
			<xsl:for-each select="page/movie_list/movie">
				<div class="movie_list">
					<a href="index.asp?sitepage={//cur_page}&amp;contentid={content_id}" target="_blank">
					<strong><xsl:value-of select="title"/></strong></a>
					<div>
					<span><img src="{pic}" width="100%" height="100%"/></span>
					<xsl:value-of select="content" disable-output-escaping="yes"/>
					</div>
				</div>
			</xsl:for-each>
			<!--调用分页-->
			<xsl:call-template name="page_nav">
				<xsl:with-param name="page_name">index.asp?keyword=<xsl:value-of select="//keyword"/>&amp;sitepage=<xsl:value-of select="//cur_page"/>&amp;</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="search_list">
		<div class="article-title"><h1>
			<xsl:if test="count(//keyword)!=0">
				“<font color="red"><xsl:value-of select="//keyword"/></font>”<xsl:value-of select="/page/language_pack/text_search_result"/>
			</xsl:if></h1>
		</div>
		<!--调用分页-->
		<xsl:call-template name="page_nav">
			<xsl:with-param name="page_name">index.asp?keyword=<xsl:value-of select="//keyword"/>&amp;sitepage=<xsl:value-of select="//cur_page"/>&amp;</xsl:with-param>
		</xsl:call-template>
		<!--显示查找结果列表-->
		<xsl:for-each select="page/search_list/search">
			<div class="software_list">
				<a href="index.asp?sitepage={class}&amp;contentid={content_id}" target="_blank">
				<strong><xsl:value-of select="title"/></strong></a>
				<div>
				<xsl:value-of select="content" disable-output-escaping="yes"/>
				</div>
			</div>
		</xsl:for-each>
		<!--调用分页-->
		<xsl:call-template name="page_nav">
			<xsl:with-param name="page_name">index.asp?keyword=<xsl:value-of select="//keyword"/>&amp;sitepage=<xsl:value-of select="//cur_page"/>&amp;</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="page_nav">
		<!--page_name表示页面的名称,如city.asp?,切记?必需要带上.-->
		<xsl:param name="page_name"/>
		<xsl:if test="//pgnm>1">
		<table class="page-number" cellpadding="0" cellspacing="0" align="center">
			<form name="page-list" onsubmit="window.location='{$page_name}orderby={//orderby}&amp;direct={//direct}&amp;page=' + this.page_num.value;return false;">
			<tr>
				<td><xsl:value-of select="/page/language_pack/text_page_each"/>
						<strong>
							<xsl:value-of select="//pgsize"/>
						</strong>
				</td>
				<td align="right">
					<font color="red"><xsl:value-of select="//pg"/></font>/<xsl:value-of select="//pgnm"/>
					<img src="images/spacer.gif" alt="blank"/>
					<xsl:if test="//pg>1">
						<a href="{$page_name}orderby={//orderby}&amp;direct={//direct}&amp;page={//pg - 1}"><img src="images/pre_page_simple_act.gif" alt="{/page/language_pack/text_page_pre}"/></a>
					</xsl:if>
					<xsl:if test="not(//pg>1)">
						<img src="images/pre_page_simple.gif" alt="{/page/language_pack/text_page_pre}"/>
					</xsl:if>
					<xsl:if test="//pg+1&lt;=//pgnm">
						<a href="{$page_name}orderby={//orderby}&amp;direct={//direct}&amp;page={//pg+1}"><img src="images/next_page_act.gif" alt="{/page/language_pack/text_page_next}"/></a>
					</xsl:if>
					<xsl:if test="not(//pg+1&lt;=//pgnm)">
						<img src="images/next_page.gif" alt="{/page/language_pack/text_page_next}"/> 
					</xsl:if>
					<xsl:value-of select="/page/language_pack/text_page_goto"/><input type="text" class="inpt-tx" style="width:30px;height:16px;font-size:12px;" name="page_num"/><xsl:value-of select="/page/language_pack/text_page"/><input type="image" src="images/btn_ok.gif" style="vertical-align:middle;"/>
				</td>
			</tr>
			</form>
		</table>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
