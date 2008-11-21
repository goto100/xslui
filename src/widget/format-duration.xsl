<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:dc="http://purl.org/dc/elements/1.1/"

	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:date="http://exslt.org/dates-and-times"
	xmlns:lang="http://imyui.cn/i18n-xsl"
	xmlns:ui="http://imyui.cn/xslui"
>

	<xsl:import href="../exslt/date/difference.xsl" />
	<xsl:import href="../exslt/date/add-duration.xsl" />
	<xsl:import href="../exslt/date/format-date.xsl" />
	<xsl:import href="../i18n.xsl" />

	<xsl:template name="ui:format-duration">
		<xsl:param name="duration" />

		<xsl:choose>
			<xsl:when test="contains($duration, 'D')">
				<xsl:call-template name="ui:label">
					<xsl:with-param name="name">n-days-before</xsl:with-param>
					<xsl:with-param name="param" select="substring-after(substring-before($duration, 'D'), 'P')" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($duration, 'H')">
				<xsl:call-template name="ui:label">
					<xsl:with-param name="name">n-hours-before</xsl:with-param>
					<xsl:with-param name="param" select="substring-after(substring-before($duration, 'H'), 'T')" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($duration, 'M')">
				<xsl:call-template name="ui:label">
					<xsl:with-param name="name">n-minutes-before</xsl:with-param>
					<xsl:with-param name="param" select="substring-after(substring-before($duration, 'M'), 'T')" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($duration, 'S')">
				<xsl:call-template name="ui:label">
					<xsl:with-param name="name">n-seconds-before</xsl:with-param>
					<xsl:with-param name="param" select="substring-after(substring-before($duration, 'S'), 'T')" />
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
