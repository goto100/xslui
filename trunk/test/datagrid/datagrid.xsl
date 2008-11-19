<?xml version="1.0" encoding="utf-8"?>
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

	<xsl:template match="/">
		<html>
			<head>
				<link type="text/css" rel="stylesheet" href="../../style/admin-huan.css" />
			<meta http-equiv="Content-Type" content="text/html; charset=utf-8" /></head>
		<body>
			<xsl:apply-templates />
		</body>
		</html>
	</xsl:template>

	<xsl:template match="rdf:RDF">
		<xsl:call-template name="ui:datagrid">
			<xsl:with-param name="segment-start" select="1" />
			<xsl:with-param name="segment-end" select="20" />
			<xsl:with-param name="segment-total" select="300" />
			<xsl:with-param name="selectable" select="true()" />
			<xsl:with-param name="cols-node">
				<ui:col name="title" />
				<ui:col name="edit" class="operation" />
				<ui:col name="date" />
				<ui:col name="delete" class="operation" />
			</xsl:with-param>
			<xsl:with-param name="operations-node">
				<ui:operation name="update" action="?update" />
				<ui:operation name="delete" action="?delete" />
			</xsl:with-param>
			<xsl:with-param name="rows-node">
				<xsl:apply-templates select="rdf:Description" mode="ui:datagrid-rows" />
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="rdf:Description" mode="ui:datagrid-rows">
		<xsl:call-template name="ui:datagrid-row">
			<xsl:with-param name="selectable" select="position() mod 2 = 1" />
			<xsl:with-param name="operations-node">
				<ui:operation name="edit" action="?edit&amp;id={@id}" />
				<ui:operation name="delete" action="?delete&amp;id={@id}" />
			</xsl:with-param>
			<xsl:with-param name="cells-node">
				<xsl:apply-templates select="dc:title" mode="ui:datagrid-cell" />
				<xsl:apply-templates select="dc:date" mode="ui:datagrid-cell" />
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

</xsl:stylesheet>
