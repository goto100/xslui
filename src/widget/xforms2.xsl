<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY empty		"&#12288;">
	<!ENTITY v-line		"&#9474;">
	<!ENTITY i-line		"&#9500;">
	<!ENTITY lb-corner	"&#9492;">
]>
<xsl:stylesheet version="1.0"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:xforms="http://www.w3.org/2002/xforms"

	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:exslt="http://exslt.org/common"
	xmlns:lang="http://imyui.cn/i18n-xsl"

	xmlns:ui="http://imyui.cn/xslui"
	xmlns:html="http://www.w3.org/1999/xhtml"
	xmlns="http://www.w3.org/2002/xforms"
>

	<xsl:template name="xforms:input">
		<xsl:param name="ref" select="." />
			<input>
				<label>fads</label>
				<value>fad</value>
			</input>

		<xsl:variable name="config">
		</xsl:variable>

		<xsl:apply-templates select="exslt:node-set($config)/xforms:input">
			<xsl:with-param name="ref" select="$ref" />
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="node() | @*" mode="ui:input">
		<xsl:call-template name="xforms:input" />
	</xsl:template>

	<xsl:template match="node() | @*" mode="ui:textarea">
		<xsl:call-template name="xforms:input" />
	</xsl:template>

	<xsl:template match="xforms:submission">
		<form action="" method="post">
			<xsl:apply-templates select="../xforms:instance/*" />
		</form>
	</xsl:template>

</xsl:stylesheet>
