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
				<link href="template/homepage/css/default8.css" rel="stylesheet" type="text/css" media="all"/>
			</head>
			<!--head完成-->		
			<body bgcolor="#000000">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr> 
			    <td width="391" style="font-size:16px;color:#fff;text-align:center;"><xsl:value-of select="//homepage_name" disable-output-escaping="yes"/></td>
			    
			    <td><img src="/template/homepage/images/3/in02.gif" width="386" height="112"/></td>
			  </tr>
			</table>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr> 
			    <td width="391" background="/template/homepage/images/3/inbg2.gif"></td>
			    
			    <td width="32" background="/template/homepage/images/3/inbg2.gif"></td>
			    <td width="77" rowspan="2"><object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,29,0" width="77" height="243">
			        <param name="movie" value="/template/homepage/images/3/flash.swf"/>
			        <param name="quality" value="high"/>
			        <embed src="/template/homepage/images/3/flash.swf" quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" width="77" height="243"></embed></object></td>
			    <td background="/template/homepage/images/3/inbg2.gif"><img src="/template/homepage/images/3/in04.gif" width="274" height="21"/></td>
			  </tr>
			  <tr> 
			    <td><img src="/template/homepage/images/3/in05.gif" width="391" height="222"/></td>
			    <td background="/template/homepage/images/3/inbg4.gif"></td>
			    <td background="/template/homepage/images/3/inbg4.gif"><img src="/template/homepage/images/3/in07.gif" width="274" height="222"/></td>
			  </tr>
			</table>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td><img src="/template/homepage/images/3/in08.gif" width="423" height="73"/><img src="/template/homepage/images/3/in09.gif" width="354" height="73"/></td>
			  </tr>
			</table>
			<div class="page-foot">
				<xsl:for-each select="page/public_language/language_name">
					<a href="start.asp?language={@id}" class="language_button"><span><xsl:value-of select="."/></span></a>
				</xsl:for-each>
			</div>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
