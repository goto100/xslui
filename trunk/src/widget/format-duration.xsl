<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:dc="http://purl.org/dc/elements/1.1/"

	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:date="http://exslt.org/dates-and-times"
	xmlns:lang="http://imyui.cn/i18n-xsl"
	xmlns:ui="http://imyui.cn/xslui"
	xmlns="http://www.w3.org/1999/xhtml"
>

	<xsl:import href="../exslt/date/difference.xsl" />
	<xsl:import href="../exslt/date/add-duration.xsl" />
	<xsl:import href="../exslt/date/format-date.xsl" />
	<xsl:import href="../i18n.xsl" />

	<xsl:template name="ui:format-duration">
		<xsl:param name="duration" />

		<xsl:choose>
			<xsl:when test="contains($duration, 'D')">
				
			</xsl:when>
			<xsl:when test="contains($duration, 'H')">
				<xsl:value-of select="substring-after(substring-before($duration, 'H'), 'T')" />
				<xsl:text>小时</xsl:text>
			</xsl:when>
			<xsl:when test="contains($duration, 'M')">
				<xsl:value-of select="substring-after(substring-before($duration, 'M'), 'T')" />
				<xsl:text>分钟</xsl:text>
			</xsl:when>
			<xsl:when test="contains($duration, 'S')">
				<xsl:value-of select="substring-after(substring-before($duration, 'S'), 'T')" />
				<xsl:text>秒</xsl:text>
			</xsl:when>
		</xsl:choose>
		<xsl:text>前</xsl:text>
	</xsl:template>

</xsl:stylesheet>