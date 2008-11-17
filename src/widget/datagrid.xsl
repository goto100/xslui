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
		<xsl:param name="operations" select="/.." />
		<xsl:param name="items" select="/.." />

		<form class="datagrid" action="">
			<xsl:if test="$segmental">
				<xsl:call-template name="ui:pagebar" />
			</xsl:if>
			<xsl:for-each select="exslt:node-set($operations)/*">
				<button type="submit" name="__action" value="{@name}.do"><xsl:value-of select="@name" /></button>
			</xsl:for-each>
			<table>
				<thead>
					<tr>
						<xsl:if test="$selectable">
							
						</xsl:if>
					</tr>
				</thead>
				<tfoot>
					<tr>
						<td colspan="10"></td>
					</tr>
				</tfoot>
				<tbody>
					<xsl:variable name="_tbody">
						<xsl:apply-templates select="$items" />
					</xsl:variable>
					<xsl:variable name="tbody" select="exslt:node-set($_tbody)" />
					<xsl:for-each select="$tbody/html:tr">
						<tr>
							<xsl:for-each select="html:td | html:th">
								<td><xsl:value-of select="." /></td>
							</xsl:for-each>
						</tr>
					</xsl:for-each>
				</tbody>
			</table>
		</form>
	</xsl:template>

	<xsl:template name="ui:datagrid-row">

	</xsl:template>

	<xsl:template name="ui:datagrid-cell">

	</xsl:template>

</xsl:stylesheet>
