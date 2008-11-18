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

	<xsl:param name="ui:selectable" select="true()" />

	<xsl:template match="rdf:RDF">
		<xsl:call-template name="ui:datagrid">
			<xsl:with-param name="segmental" select="true()" />
			<xsl:with-param name="selectable" select="$ui:selectable" />
			<xsl:with-param name="cols">
				<ui:col name="title" />
				<ui:col name="edit" class="operation" />
				<ui:col name="date" />
				<ui:col name="delete" class="operation" />
			</xsl:with-param>
			<xsl:with-param name="operations">
				<ui:operation name="update" action="?update" />
				<ui:operation name="delete" action="?delete" />
			</xsl:with-param>
			<xsl:with-param name="items">
				<xsl:apply-templates select="rdf:Description" />
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="rdf:Description">
		<xsl:call-template name="ui:datagrid-row">
			<xsl:with-param name="selectable" select="$ui:selectable" />
			<xsl:with-param name="operations">
				<ui:operation name="edit" action="?edit&amp;id={@id}" />
				<ui:operation name="delete" action="?delete&amp;id={@id}" />
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

</xsl:stylesheet>
