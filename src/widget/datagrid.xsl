<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:exslt="http://exslt.org/common"
	xmlns:lang="http://imyui.cn/i18n-xsl"

	xmlns:ui="http://imyui.cn/xslui"
>

	<xsl:import href="../function.xsl" />
	<xsl:import href="../exslt/date/difference.xsl" />
	<xsl:import href="../exslt/date/add-duration.xsl" />
	<xsl:import href="../exslt/date/format-date.xsl" />
	<xsl:import href="../i18n.xsl" />
	<xsl:import href="pagebar.xsl" />

	<xsl:template name="ui:datagrid">
		<xsl:param name="segment-total" select="0" />
		<xsl:param name="segment-start" select="0" />
		<xsl:param name="segment-end" select="0" />
		<xsl:param name="selectable" select="false()" />
		<xsl:param name="cols-node" select="/.." />
		<xsl:param name="operations-node" select="/.." />
		<xsl:param name="rows-node" select="/.." />

		<xsl:variable name="cols" select="exslt:node-set($cols-node)/*" />
		<xsl:variable name="operations" select="exslt:node-set($operations-node)/*" />
		<xsl:variable name="rows" select="exslt:node-set($rows-node)/*" />

		<form class="datagrid" action="">
			<xsl:if test="$segment-total">
				<xsl:call-template name="ui:pagebar" />
			</xsl:if>
			<xsl:for-each select="$operations">
				<button type="submit" name="__action" value="{@ui:name}">
					<xsl:call-template name="ui:text">
						<xsl:with-param name="name" select="@ui:name" />
					</xsl:call-template>
				</button>
			</xsl:for-each>
			<table>
				<xsl:if test="$selectable">
					<col class="selection" />
				</xsl:if>
				<xsl:for-each select="$cols">
					<col class="{@ui:name} {@class}" />
				</xsl:for-each>
				<thead>
					<tr>
						<xsl:if test="$selectable">
							<th class="selection">
								<input type="checkbox" name="id" value="{@id}" />
							</th>
						</xsl:if>
						<xsl:for-each select="$cols">
							<th>
								<xsl:call-template name="ui:text">
									<xsl:with-param name="name" select="@ui:name" />
								</xsl:call-template>
							</th>
						</xsl:for-each>
					</tr>
				</thead>
				<tfoot>
					<tr>
						<td colspan="{number($selectable) + count($cols)}">
							<xsl:if test="exslt:object-type($segment-total) = 'number'"><xsl:value-of select="$segment-start" /> - <xsl:value-of select="$segment-end" /> / <xsl:value-of select="$segment-total" /></xsl:if>
						</td>
					</tr>
				</tfoot>
				<tbody>
					<xsl:for-each select="$rows">
						<tr>
							<xsl:if test="$selectable">
								<th class="selection">
									<input type="checkbox" name="id" value="{@id}">
										<xsl:if test="@ui:selectable = 'false'">
											<xsl:attribute name="disabled">disabled</xsl:attribute>
										</xsl:if>
									</input>
								</th>
							</xsl:if>
							<xsl:variable name="row" select="." />
							<xsl:for-each select="$cols">
								<xsl:variable name="cell" select="$row/*[@ui:name = current()/@ui:name]" />
								<td>
									<xsl:copy-of select="$cell/@title" />
									<xsl:choose>
										<xsl:when test="$cell/@ui:href">
											<a href="{$cell/@ui:href}"><xsl:value-of select="$cell" /></a>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$cell" />
										</xsl:otherwise>
									</xsl:choose>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:for-each>
				</tbody>
			</table>
		</form>
	</xsl:template>

	<xsl:template name="ui:datagrid-row">
		<xsl:param name="selectable" select="false()" />
		<xsl:param name="operations-node" select="/.." />
		<xsl:param name="cells-node" select="/.." />

		<tr ui:selectable="{$selectable}">
			<xsl:copy-of select="$operations-node" />
			<xsl:copy-of select="$cells-node" />
		</tr>
	</xsl:template>

	<xsl:template match="node()" mode="ui:datagrid-cell">
		<td ui:name="{local-name()}"><xsl:value-of select="." /></td>
	</xsl:template>

	<xsl:template match="node()" mode="ui:datagrid-cell.edit">
		<td ui:name="edit" ui:href="?">编辑</td>
	</xsl:template>

	<xsl:template match="node()" mode="ui:datagrid-cell.delete">
		<td ui:name="delete" ui:href="?">删除</td>
	</xsl:template>

</xsl:stylesheet>
