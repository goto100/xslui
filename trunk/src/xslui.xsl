<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:exslt="http://exslt.org/common"
	xmlns:date="http://exslt.org/dates-and-times"
	
	xmlns:lang="http://imyui.cn/i18n-xsl"
	xmlns:ui="http://imyui.cn/xslui"
>

	<xsl:import href="exslt/date/difference.xsl" />
	<xsl:import href="exslt/date/add-duration.xsl" />
	<xsl:import href="exslt/date/format-date.xsl" />
	<xsl:import href="function.xsl" />
	<xsl:import href="i18n.xsl" />

	<ui:config>
		<languagePath>i18n/</languagePath>
		<language>zh-CN</language>
	</ui:config>

	<xsl:param name="ui:config" select="document('')/*/ui:config" />

	<xsl:template name="ui:text">
		<xsl:param name="name" />
		<xsl:param name="param" />
		<xsl:call-template name="lang:label">
			<xsl:with-param name="labels-path" select="$ui:config/languagePath" />
			<xsl:with-param name="lang-name" select="$ui:config/language" />
			<xsl:with-param name="name" select="$name" />
			<xsl:with-param name="param" select="$param" />
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="ui:format-date">
		<xsl:param name="date" />
		<xsl:call-template name="lang:format-date">
			<xsl:with-param name="labels-path" select="$ui:config/languagePath" />
			<xsl:with-param name="lang-name" select="$ui:config/language" />
			<xsl:with-param name="date" select="$date" />
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="ui:format-duration">
		<xsl:param name="start" />
		<xsl:param name="end" />
		<xsl:param name="duration">
			<xsl:call-template name="date:difference">
				<xsl:with-param name="start" select="$start" />
				<xsl:with-param name="end" select="$end" />
			</xsl:call-template>
		</xsl:param>
		<xsl:call-template name="lang:format-duration">
			<xsl:with-param name="labels-path" select="$ui:config/languagePath" />
			<xsl:with-param name="lang-name" select="$ui:config/language" />
			<xsl:with-param name="start" select="$start" />
			<xsl:with-param name="end" select="$end" />
			<xsl:with-param name="duration" select="$duration" />
		</xsl:call-template>
	</xsl:template>

</xsl:stylesheet>