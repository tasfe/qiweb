<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:template match="/">
		<wml>
			<head>
				<title><xsl:value-of select="//homepage_name"/></title>
				<link href="template/homepage/css/wap.css" rel="stylesheet" type="text/css" media="all"/>
			</head>
			<card id="one" title="{//homepage_name}">
			<h1><xsl:value-of select="//homepage_name"/></h1>
			<p align="center">
			<xsl:for-each select="page/public_language/language_name">
				<a href="start.asp?language={@id}" class="language_button"><span><xsl:value-of select="."/></span></a>
			</xsl:for-each>
			</p>
			</card>
		</wml>
	</xsl:template>
</xsl:stylesheet>
