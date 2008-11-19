<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:dc="http://purl.org/dc/elements/1.1/"

	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:exslt="http://exslt.org/common"
	xmlns:ui="http://imyui.cn/xslui"
	xmlns="http://www.w3.org/1999/xhtml"
>

	<xsl:output method="html" />

	<xsl:template match="/">
		<xsl:variable name="xml" select="document('src/i18n/zh-CN.xml')/*" />
		<xsl:for-each select="$xml">
			<xsl:value-of select="id('date')" />
		</xsl:for-each>
	</xsl:template>

</xsl:stylesheet>
