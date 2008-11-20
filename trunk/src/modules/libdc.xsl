<?xml version="1.0" encoding="gb2312"?>
<xsl:stylesheet version="1.0"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:search="huan-search"

	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xforms="http://www.w3.org/2002/xforms"
	xmlns:xul="http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul"
	xmlns="http://www.w3.org/1999/xhtml"
>

	<xsl:template match="dc:title" mode="tree-col">
		<xsl:call-template name="tree-col">
			<xsl:with-param name="primary" select="true()" />
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="dc:type" mode="tree-cell">
		<xsl:call-template name="tree-cell">
			<xsl:with-param name="text" select="true()" />
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="xforms:instance//dc:date | xforms:instance//dc:date/@search:start | xforms:instance//dc:date/@search:end">
		<xsl:call-template name="xforms:input">
			<xsl:with-param name="bind">
				<xforms:bind type="xs:date" />
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="xforms:instance//dc:title">
		<xsl:call-template name="xforms:input" />
	</xsl:template>

	<xsl:template match="xforms:instance//dc:description">
		<xsl:call-template name="xforms:textarea" />
	</xsl:template>

	<xsl:template match="xforms:instance//dc:summary">
		<xsl:call-template name="xforms:textarea" />
	</xsl:template>

</xsl:stylesheet>
