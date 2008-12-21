<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:dc="http://purl.org/dc/elements/1.1/"

	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:exslt="http://exslt.org/common"
	xmlns:date="http://exslt.org/dates-and-times"
	xmlns:lang="http://imyui.cn/i18n-xsl"
	xmlns:ui="http://imyui.cn/xslui"
>

	<xsl:import href="../exslt/date/difference.xsl" />
	<xsl:import href="../exslt/date/add-duration.xsl" />
	<xsl:import href="../exslt/date/format-date.xsl" />
	<xsl:import href="../xslui.xsl" />

	<xsl:template name="ui:format-duration">
		<xsl:param name="start" />
		<xsl:param name="end" />
		<xsl:param name="duration">
			<xsl:call-template name="date:difference">
				<xsl:with-param name="start" select="$start" />
				<xsl:with-param name="end" select="$end" />
			</xsl:call-template>
		</xsl:param>
	</xsl:template>

</xsl:stylesheet>
