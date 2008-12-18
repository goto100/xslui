<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:xforms="http://www.w3.org/2002/xforms"

	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:exslt="http://exslt.org/common"
	xmlns:str="http://exslt.org/strings"
	xmlns:date="http://exslt.org/dates-and-times"

	xmlns:ui="http://imyui.cn/xslui"
>

	<xsl:import href="../src/modules/libdc.xsl" />
	<xsl:import href="../src/widget/xforms2.xsl" />
	<xsl:import href="default.xsl" />

	<xsl:template match="/">
		<xsl:apply-templates select="." mode="default" />
	</xsl:template>

	<xsl:template match="xforms:instance/rdf:Description">
		<xsl:apply-templates select="dc:title" mode="ui:input" />
		<xsl:call-template name="ui:input">
			<xsl:with-param name="ref" select="dc:date" />
			<xsl:with-param name="type">xs:date</xsl:with-param>
		</xsl:call-template>
		<xsl:apply-templates select="dc:summary" mode="ui:textarea" />
		<xsl:apply-templates select="dc:description" mode="ui:textarea" />
	</xsl:template>

</xsl:stylesheet>
