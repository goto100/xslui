<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:exslt="http://exslt.org/common"
>

	<xsl:template name="list">
		<xsl:param name="selectable" />
		<xsl:param name="items.node" select="/.." />

		<dl class="list">
			<xsl:for-each select="$items.node">
				<xsl:call-template name="list.items">
					<xsl:with-param name="selectable" select="$selectable" />
				</xsl:call-template>
			</xsl:for-each>
		</dl>
	</xsl:template>

	<xsl:template name="list.items">
		<xsl:param name="selectable" />

		<dt>
			<xsl:if test="$selectable">
				<input type="checkbox" name="id" value="{@id}" />
			</xsl:if>
			<xsl:apply-templates select="." mode="list.items.title" />
		</dt>
		<dd>
			<xsl:apply-templates select="." mode="list.items.description" />
		</dd>
		<dd class="operation">
			<xsl:apply-templates select="." mode="list.items.operation" />
		</dd>
	</xsl:template>

</xsl:stylesheet>
