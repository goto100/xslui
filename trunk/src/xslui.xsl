<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:lang="http://imyui.cn/i18n-xsl"
	xmlns:ui="http://imyui.cn/xslui"
>

	<xsl:import href="i18n.xsl" />

	<ui:config>
		<languagePath>i18n/</languagePath>
		<language>zh-CN</language>
	</ui:config>

	<xsl:param name="ui:config" select="document('')/*/ui:config" />

	<xsl:template name="ui:label">
		<xsl:param name="name" />
		<xsl:param name="param" />
		<xsl:call-template name="lang:label">
			<xsl:with-param name="labels-path" select="$ui:config/languagePath" />
			<xsl:with-param name="lang-name" select="$ui:config/language" />
			<xsl:with-param name="name" select="$name" />
			<xsl:with-param name="param" select="$param" />
		</xsl:call-template>
	</xsl:template>

</xsl:stylesheet>