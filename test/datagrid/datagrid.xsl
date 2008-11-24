<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:dc="http://purl.org/dc/elements/1.1/"

	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:exslt="http://exslt.org/common"
	xmlns:str="http://exslt.org/strings"
	xmlns:date="http://exslt.org/dates-and-times"

	xmlns:ui="http://imyui.cn/xslui"
>

	<xsl:import href="../../src/modules/libdc.xsl" />
	<xsl:import href="../../src/widget/datagrid.xsl" />
	<xsl:import href="../default.xsl" />

	<xsl:template match="/">
		<xsl:apply-templates select="." mode="default" />
	</xsl:template>

	<xsl:template match="rdf:RDF">
		<xsl:call-template name="ui:datagrid">
			<xsl:with-param name="segment-start" select="1" />
			<xsl:with-param name="segment-end" select="20" />
			<xsl:with-param name="segment-total" select="300" />
			<xsl:with-param name="selectable" select="true()" />
			<xsl:with-param name="cols-node">
				<ui:col name="title" />
				<ui:col name="date" />
				<ui:col name="edit" class="operation" />
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
			<xsl:with-param name="cells-node">
				<xsl:apply-templates select="dc:title" mode="ui:datagrid-cell" />
				<xsl:apply-templates select="dc:date" mode="ui:datagrid-cell" />
				<xsl:apply-templates select="." mode="ui:datagrid-cell.edit" />
				<xsl:apply-templates select="." mode="ui:datagrid-cell.delete" />
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="dc:date" mode="ui:datagrid-cell">
		<ui:cell name="{local-name()}">
			<xsl:attribute name="title">
				<xsl:call-template name="date:format-date">
					<xsl:with-param name="date-time" select="." />
					<xsl:with-param name="pattern">yyyy-MM-dd HH:mm:ss</xsl:with-param>
				</xsl:call-template>
			</xsl:attribute>
			<xsl:apply-templates select="." mode="ui:duration" />
		</ui:cell>
	</xsl:template>

</xsl:stylesheet>
