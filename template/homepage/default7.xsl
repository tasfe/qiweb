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
				<link href="/template/homepage/css/default7.css" rel="stylesheet" type="text/css" media="all"/>
			</head>
			<!--head完成-->		
			<body>
				<div class="page-body">
				<div class="page-title"><xsl:value-of select="//homepage_name"/></div>
				<div class="page-content">
					<div class="left">
					<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,29,0" width="211" height="210">
					  <param name="movie" value="/template/homepage/flash/spiral.swf"/>
					  <param name="quality" value="high"/>
					  <param name="wmode" value="transparent"/>
					  <embed src="/template/homepage/flash/spiral.swf" wmode="transparent" quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" width="211" height="210"></embed>
					</object>	
					</div>
					<div class="right">
					<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,29,0" width="236" height="217">
					  <param name="movie" value="/template/homepage/flash/974.swf"/>
					  <param name="quality" value="high"/>
					  <param name="wmode" value="transparent"/>
					  <embed src="/template/homepage/flash/974.swf" wmode="transparent" quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" width="236" height="217"></embed>
					</object>	
					</div>			
				</div>
				<div class="page-foot">
					<xsl:for-each select="page/public_language/language_name">
						<a href="start.asp?language={@id}" class="language_button"><span><xsl:value-of select="."/></span></a>
					</xsl:for-each>
				</div>
				</div>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
