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
		<xsl:param name="config">
			<datagrid segmental="false">
				<operation name="edit" />
				<operation name="delete" />
			</datagrid>
		</xsl:param>
		<xsl:param name="cfg" select="exslt:node-set($config)/*" />
		<xsl:param name="segmental" select="$cfg/@segmental = 'true'" />
		<xsl:param name="operations" select="$cfg/operation" />
		<xsl:param name="items" select="/.." />

		<xsl:variable name="tbody">
			<xsl:variable name="__tbody">
				<xsl:apply-templates select="$items" />
			</xsl:variable>
			<xsl:variable name="_tbody" select="exslt:node-set($__tbody)" />
			<xsl:for-each select="$_tbody/html:tr">
				<tr>
					<xsl:for-each select="html:td | html:th">
						<td><xsl:value-of select="." /></td>
					</xsl:for-each>
				</tr>
			</xsl:for-each>
		</xsl:variable>

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

					</tr>
				</thead>
				<tfoot>
					<tr>
						<td colspan="10"></td>
					</tr>
				</tfoot>
				<tbody>
					<xsl:copy-of select="$tbody" />
				</tbody>
			</table>
		</form>
	</xsl:template>

	<xsl:template name="ui:datagrid-row">

	</xsl:template>

	<xsl:template name="ui:datagrid-cell">

	</xsl:template>

</xsl:stylesheet>
