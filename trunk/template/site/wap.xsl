<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:template match="/">
		<wml>
			<head>
				<title><xsl:value-of select="//site_name"/></title>
				<link href="template/site/css/wap.css" rel="stylesheet" type="text/css" media="all"/>
			</head>
			<card id="one" title="{//site_name}">
			<h1><xsl:value-of select="//site_name"/></h1>
			<img src="{page/site_logo}" alt="{//site_name} LOGO"/>
			<p align="center">
			<xsl:for-each select="page/public_language/language_name">
				<a href="start.asp?language={@id}" class="language_button"><span><xsl:value-of select="."/></span></a>
			</xsl:for-each>
			</p>
			<!--菜单-->
			<div class="page-menu">
				<ul>
				<xsl:for-each select="page/sitemap/pagename">
					<xsl:if test="page_id=/page/parent_page">
						<li><a href="index.asp?sitepage={page_id}" id="active-link"><span><xsl:value-of select="title"/></span></a></li>
					</xsl:if>
					<xsl:if test="page_id!=/page/parent_page">
						<li><a href="index.asp?sitepage={page_id}"><span><xsl:value-of select="title"/></span></a></li>
					</xsl:if>
				</xsl:for-each>
				</ul>
				
			</div>
			</card>
		</wml>
	</xsl:template>
</xsl:stylesheet>

