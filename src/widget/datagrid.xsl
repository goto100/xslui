<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:dc="http://purl.org/dc/elements/1.1/"

	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:exslt="http://exslt.org/common"
	xmlns:str="http://exslt.org/strings"
	xmlns:date="http://exslt.org/dates-and-times"
	xmlns:lang="http://imyui.cn/i18n-xsl"
	xmlns:ui="http://imyui.cn/xslui"
	xmlns:html="http://www.w3.org/1999/xhtml"
	xmlns="http://www.w3.org/1999/xhtml"
>

	<xsl:import href="../function.xsl" />
	<xsl:import href="../exslt/date/difference.xsl" />
	<xsl:import href="../exslt/date/add-duration.xsl" />
	<xsl:import href="../exslt/date/format-date.xsl" />
	<xsl:import href="../i18n.xsl" />
	<xsl:import href="pagebar.xsl" />
	<xsl:import href="format-duration.xsl" />

	<xsl:template name="ui:datagrid">
		<xsl:param name="segment-total" select="0" />
		<xsl:param name="segment-start" select="0" />
		<xsl:param name="segment-end" select="0" />
		<xsl:param name="selectable" select="false()" />
		<xsl:param name="cols-node" select="/.." />
		<xsl:param name="operations-node" select="/.." />
		<xsl:param name="rows-node" select="/.." />

		<xsl:variable name="cols" select="exslt:node-set($cols-node)/ui:col" />
		<xsl:variable name="operations" select="exslt:node-set($operations-node)/ui:operation" />
		<xsl:variable name="rows" select="exslt:node-set($rows-node)/ui:row" />

		<form class="datagrid" action="">
			<xsl:if test="$segment-total">
				<xsl:call-template name="ui:pagebar" />
			</xsl:if>
			<xsl:for-each select="$operations">
				<button type="submit" name="__action" value="{@name}.do">
					<xsl:call-template name="label">
						<xsl:with-param name="name" select="@name" />
					</xsl:call-template>
				</button>
			</xsl:for-each>
			<table class="list">
				<xsl:if test="$selectable">
					<col class="selection" />
				</xsl:if>
				<xsl:for-each select="$cols">
					<col class="{@name} {@class}" />
				</xsl:for-each>
				<thead>
					<tr>
						<xsl:if test="$selectable">
							<th class="selection">
								<input type="checkbox" name="id" value="{@id}" />
							</th>
						</xsl:if>
						<xsl:for-each select="$cols">
							<th><xsl:value-of select="@name" /></th>
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
										<xsl:if test="@selectable = 'false'">
											<xsl:attribute name="disabled">disabled</xsl:attribute>
										</xsl:if>
									</input>
								</th>
							</xsl:if>
							<xsl:variable name="row" select="." />
							<xsl:for-each select="$cols">
								<xsl:variable name="cell" select="($row/ui:cell | $row/ui:operation)[@name = current()/@name]" />
								<td>
									<xsl:copy-of select="$cell/@title" />
									<xsl:value-of select="$cell" />
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

		<ui:row selectable="{$selectable}">
			<xsl:copy-of select="$operations-node" />
			<xsl:copy-of select="$cells-node" />
		</ui:row>
	</xsl:template>

	<xsl:template match="node()" mode="ui:datagrid-cell">
		<ui:cell name="{local-name()}"><xsl:value-of select="." /></ui:cell>
	</xsl:template>

	<xsl:template match="dc:date" mode="ui:datagrid-cell">
		<ui:cell name="{local-name()}">
			<xsl:attribute name="title">
				<xsl:call-template name="date:format-date">
					<xsl:with-param name="date-time" select="." />
					<xsl:with-param name="pattern">yyyy-MM-dd HH:mm:ss</xsl:with-param>
				</xsl:call-template>
			</xsl:attribute>
			<xsl:apply-templates select="." mode="duration" />
		</ui:cell>
	</xsl:template>

	<xsl:template match="dc:date" mode="duration">
		<xsl:param name="now">2008-08-08T20:08:08Z</xsl:param>
		<xsl:param name="duration">
			<xsl:call-template name="date:difference">
				<xsl:with-param name="start" select="." />
				<xsl:with-param name="end" select="$now" />
			</xsl:call-template>
		</xsl:param>
		<xsl:param name="range">P365D</xsl:param>

		<xsl:variable name="result">
			<xsl:call-template name="date:add-duration">
				<xsl:with-param name="duration1" select="concat('-', $range)" />
				<xsl:with-param name="duration2" select="$duration" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="substring($result, 1, 1) != '-'">
				<xsl:call-template name="date:format-date">
					<xsl:with-param name="date-time" select="." />
					<xsl:with-param name="pattern">yyyy-MM-dd HH:mm:ss</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="ui:format-duration">
					<xsl:with-param name="duration" select="$duration" />
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
