<?xml version="1.0" encoding="gb2312"?>
<xsl:stylesheet version="1.0"
	xmlns:dc="http://purl.org/dc/elements/1.1/"

	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:date="http://exslt.org/dates-and-times"

	xmlns:ui="http://imyui.cn/xslui"
>

	<xsl:template match="dc:date" mode="ui:duration">
		<xsl:param name="now">2008-12-26T20:08:08Z</xsl:param>
		<xsl:param name="duration">
			<xsl:call-template name="date:difference">
				<xsl:with-param name="start" select="." />
				<xsl:with-param name="end" select="$now" />
			</xsl:call-template>
		</xsl:param>
		<xsl:param name="range">P14D</xsl:param>

		<xsl:variable name="result">
			<xsl:call-template name="date:add-duration">
				<xsl:with-param name="duration1" select="concat('-', $range)" />
				<xsl:with-param name="duration2" select="$duration" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="substring($result, 1, 1) != '-'">
				<xsl:call-template name="date:format-date">
					<xsl:with-param name="date-time" select="." />
					<xsl:with-param name="pattern">yyyy-MM-dd HH:mm:ss</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="ui:format-duration">
					<xsl:with-param name="start" select="." />
					<xsl:with-param name="end" select="$now" />
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
