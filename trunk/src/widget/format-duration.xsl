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
	<xsl:import href="../xslui.xsl" />

	<xsl:template name="ui:format-duration">
		<xsl:param name="start" />
		<xsl:param name="end" />
		<xsl:param name="duration">
			<xsl:call-template name="date:difference">
				<xsl:with-param name="start" select="'1998-01-01T01:33:12Z'" />
				<xsl:with-param name="end" select="'2000-09-01T07:13:47Z'" />
			</xsl:call-template>
		</xsl:param>

		<xsl:variable name="date">
			<xsl:choose>
				<xsl:when test="contains($duration, 'T')">
					<xsl:value-of select="substring(substring-before($duration, 'T'), 2)" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="substring($duration, 2)" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="time">
			<xsl:value-of select="substring-after($duration, 'T')" />
		</xsl:variable>

		<xsl:variable name="result">
			<xsl:call-template name="ui:date-duration">
				<xsl:with-param name="date" select="$date" />
			</xsl:call-template>
			<xsl:call-template name="ui:time-duration">
				<xsl:with-param name="time" select="$time" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:value-of select="$result" />

	</xsl:template>

	<xsl:template name="ui:date-duration">
		<xsl:param name="date" />

		<xsl:choose>
			<xsl:when test="contains($date, 'Y')">
				<xsl:value-of select="substring-before($date, 'Y')" />
				<xsl:text>年</xsl:text>
				<xsl:call-template name="ui:date-duration">
					<xsl:with-param name="date" select="substring-after($date, 'Y')" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($date, 'M')">
				<xsl:value-of select="substring-before($date, 'M')" />
				<xsl:text>个月</xsl:text>
				<xsl:call-template name="ui:date-duration">
					<xsl:with-param name="date" select="substring-after($date, 'M')" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($date, 'D')">
				<xsl:value-of select="substring-before($date, 'D')" />
				<xsl:text>天</xsl:text>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="ui:time-duration">
		<xsl:param name="time" />

		<xsl:choose>
			<xsl:when test="contains($time, 'H')">
				<xsl:value-of select="substring-before($time, 'H')" />
				<xsl:text>个小时</xsl:text>
				<xsl:call-template name="ui:time-duration">
					<xsl:with-param name="time" select="substring-after($time, 'H')" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($time, 'M')">
				<xsl:value-of select="substring-before($time, 'M')" />
				<xsl:text>分钟</xsl:text>
				<xsl:call-template name="ui:time-duration">
					<xsl:with-param name="time" select="substring-after($time, 'M')" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($time, 'S')">
				<xsl:value-of select="substring-before($time, 'S')" />
				<xsl:text>秒</xsl:text>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
