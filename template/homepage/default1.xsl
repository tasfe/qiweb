<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:output method="html" encoding="utf-8" indent="yes"/>
	<!--统一调用页面的页头页尾模板-->
	<xsl:template match="/">
		<html>
			<!--调用统一的HEAD内容-->
			<head>
				<meta http-equiv="Content-Type" content="text/html; charset=uft-8"/>
				<xsl:value-of select="//page_meta" disable-output-escaping="yes"/>		
				<title>
					<xsl:value-of select="//homepage_name"/>
				</title>
				<link href="/template/homepage/css/default1.css" rel="stylesheet" type="text/css" media="all"/>
			</head>
			<!--head完成-->		
			<body>
				<div class="page-body">
					<div class="page-title"><xsl:value-of select="//homepage_name"/></div>
					<div class="page-content">
						<a target="_self" href="javascript:goUrl()">
							<script type="text/javascript">
							<xsl:comment>
							<![CDATA[
							imgUrl1="/template/homepage/images/1/01.jpg";
							imgtext1="欢迎光临我们的网站！"
							imgLink1=escape("start.asp?language=1");
							imgUrl2="/template/homepage/images/1/02.jpg";
							imgtext2="成功源于对技术的信心！"
							imgLink2=escape("start.asp?language=1");
							imgUrl3="/template/homepage/images/1/03.jpg";
							imgtext3="全心全意，做到最好"
							imgLink3=escape("start.asp?language=1");
							imgUrl4="/template/homepage/images/1/04.jpg";
							imgtext4="合作，真诚，团结"
							imgLink4=escape("start.asp?language=1");
							imgUrl5="/template/homepage/images/1/05.jpg";
							imgtext5="我们的宗旨：完美，奉献，追求，理想"
							imgLink5=escape("start.asp?language=1");
							
							 var focus_width=500
							 var focus_height=300
							 var text_height=24
							 var swf_height = focus_height+text_height
							 
							 var pics=imgUrl1+"|"+imgUrl2+"|"+imgUrl3+"|"+imgUrl4+"|"+imgUrl5
							 var links=imgLink1+"|"+imgLink2+"|"+imgLink3+"|"+imgLink4+"|"+imgLink5
							 var texts=imgtext1+"|"+imgtext2+"|"+imgtext3+"|"+imgtext4+"|"+imgtext5
							 
							 document.write('<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cabstart.asp?language=1version=6,0,0,0" width="'+ focus_width +'" height="'+ swf_height +'">');
							 document.write('<param name="allowScriptAccess" value="sameDomain"><param name="movie" value="/template/homepage/flash/2.swf"><param name="quality" value="high"><param name="bgcolor" value="#f0f0f0">');
							 document.write('<param name="menu" value="false"><param name=wmode value="opaque">');
							 document.write('<param name="FlashVars" value="pics='+pics+'&links='+links+'&texts='+texts+'&borderwidth='+focus_width+'&borderheight='+focus_height+'&textheight='+text_height+'">');
							 document.write('<embed src="/template/homepage/flash/2.swf" wmode="opaque" FlashVars="pics='+pics+'&links='+links+'&texts='+texts+'&borderwidth='+focus_width+'&borderheight='+focus_height+'&textheight='+text_height+'" menu="false" bgcolor="start.asp?language=1F0F0F0" quality="high" width="'+ focus_width +'" height="'+ focus_height +'" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />');  
							 document.write('</object>');
							]]>
							</xsl:comment>
							</script>
						</a>
					</div>
				</div>
				<div class="page-foot">
					<xsl:for-each select="page/public_language/language_name">
						<a href="start.asp?language={@id}" class="language_button"><span><xsl:value-of select="."/></span></a>
					</xsl:for-each>
				</div>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
