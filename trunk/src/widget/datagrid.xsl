<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:exslt="http://exslt.org/common"
	xmlns:str="http://exslt.org/strings"
	xmlns:lang="http://imyui.cn/i18n-xsl"
	xmlns:ui="http://imyui.cn/xslui"
	xmlns:html="http://www.w3.org/1999/xhtml"
	xmlns="http://www.w3.org/1999/xhtml"
>

	<xsl:import href="../function.xsl" />
	<xsl:import href="pagebar.xsl" />

	<xsl:template name="ui:datagrid">
		<xsl:param name="segmental" select="false()" />
		<xsl:param name="selectable" select="false()" />
		<xsl:param name="cols" select="/.." />
		<xsl:param name="operations" select="/.." />
		<xsl:param name="items" select="/.." />

		<html>
			<head>
				<link type="text/css" rel="stylesheet" href="../../style/admin-huan.css" />
			</head>
			<body>
		<form class="datagrid" action="">
			<xsl:if test="$segmental">
				<xsl:call-template name="ui:pagebar" />
			</xsl:if>
			<xsl:for-each select="exslt:node-set($operations)/*">
				<button type="submit" name="__action" value="{@name}.do"><xsl:value-of select="@name" /></button>
			</xsl:for-each>
			<table class="list">
				<xsl:for-each select="exslt:node-set($cols)/ui:col">
					<col class="{@name} {@class}" />
				</xsl:for-each>
				<thead>
					<tr>
						<xsl:if test="$selectable">
							<th class="selection">
								<input type="checkbox" name="id" value="{@id}" />
							</th>
						</xsl:if>
						<xsl:for-each select="exslt:node-set($cols)/ui:col">
							<th><xsl:value-of select="@name" /></th>
						</xsl:for-each>
					</tr>
				</thead>
				<tfoot>
					<tr>
						<td colspan="10"></td>
					</tr>
				</tfoot>
				<tbody>
					<xsl:copy-of select="$items" />
				</tbody>
			</table>
		</form>
		</body>
		</html>
	</xsl:template>

	<xsl:template name="ui:datagrid-row">
		<xsl:param name="selectable" select="false()" />
		<xsl:param name="operations" select="/.." />

		<tr>
			<xsl:attribute name="class">
				<xsl:if test="position() mod 2 = 1">even</xsl:if>
			</xsl:attribute>
			<xsl:if test="$selectable">
				<th class="selection">
					<input type="checkbox" name="id" value="{@id}" />
				</th>
			</xsl:if>
			<td>fd</td>
			<td>fd</td>
			<xsl:for-each select="exslt:node-set($operations)/ui:operation">
				<td class="{@name} operation"><a href="{@action}"><xsl:value-of select="@name" /></a></td>
			</xsl:for-each>
		</tr>
	</xsl:template>

	<xsl:template name="ui:datagrid-cell">

	</xsl:template>

</xsl:stylesheet>
