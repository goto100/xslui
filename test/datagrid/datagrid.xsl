<?xml version="1.0" encoding="gb2312"?>
<xsl:stylesheet version="1.0"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:dc="http://purl.org/dc/elements/1.1/"

	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:exslt="http://exslt.org/common"
	xmlns:ui="http://imyui.cn/xslui"
	xmlns="http://www.w3.org/1999/xhtml"
>

	<xsl:import href="../../src/widget/datagrid.xsl" />
	<xsl:import href="../../src/i18n.xsl" />

	<xsl:output method="html" />

	<xsl:template match="/rdf:RDF">
		<xsl:call-template name="ui:datagrid">
			<xsl:with-param name="config">
				<datagrid segmental="true">
					<operation name="delete" />
					<operation name="close" />
				</datagrid>
			</xsl:with-param>
			<xsl:with-param name="items" select="rdf:Description" />
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="rdf:Description">
		<tr>
			<th><xsl:value-of select="dc:title" /></th>
		</tr>
	</xsl:template>

</xsl:stylesheet>
