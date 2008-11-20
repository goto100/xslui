<?xml version="1.0" encoding="gb2312"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xforms="http://www.w3.org/2002/xforms"
>

	<xsl:import href="../../src/widget/xforms.xsl" />
	<xsl:import href="../../src/i18n.xsl" />

	<xsl:output method="html" />

	<xsl:template match="/category">
		<a href="tree-select.xsl">XSL</a>
		<xsl:call-template name="xforms:select1">
			<xsl:with-param name="items.tree" select="descendant-or-self::category | descendant-or-self::subcategory" />
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="category | subcategory" mode="xforms:item">
		<xsl:call-template name="xforms:item">
			<xsl:with-param name="label.content" select="title" />
		</xsl:call-template>
	</xsl:template>

</xsl:stylesheet>
