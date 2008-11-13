<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:exslt="http://exslt.org/common"
	xmlns:xul="http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul"
	xmlns="http://www.w3.org/1999/xhtml"
>

	<xsl:template match="xul:tree">
		<xsl:variable name="_maxDepth">
			<xsl:for-each select=".//xul:treeitem[not(@container)]">
				<xsl:sort select="count(ancestor::xul:treechildren)" data-type="number" order="descending" />
				<xsl:if test="position() = 1">
					<xsl:value-of select="count(ancestor::xul:treechildren)" />
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="maxDepth" select="number($_maxDepth)" />

		<xsl:apply-templates select="." mode="script" />
		<table class="tree">
			<thead>
				<tr class="treecols">

					<xsl:apply-templates select="xul:treecols/xul:treecol">
						<xsl:with-param name="maxDepth" select="$maxDepth" />
					</xsl:apply-templates>

				</tr>
			</thead>

			<xsl:apply-templates select="xul:treechildren">
				<xsl:with-param name="maxDepth" select="$maxDepth" />
			</xsl:apply-templates>

		</table>
	</xsl:template>

	<xsl:template match="xul:treecol">
		<xsl:param name="maxDepth" />

		<th>
			<xsl:attribute name="class">
				<xsl:if test="@class">
					<xsl:value-of select="@class" />
					<xsl:text> </xsl:text>
				</xsl:if>
				<xsl:if test="@cycler = 'true'">cycler </xsl:if>
				<xsl:text>treecol</xsl:text>
			</xsl:attribute>

			<xsl:variable name="depth" select="count(../../../xul:treeitem/ancestor::xul:treeitem[@container = 'true'])" />
			<xsl:variable name="colspan" select="$maxDepth - $depth" />

			<xsl:if test="position() = 1 and $colspan &gt; 1">
				<xsl:attribute name="colspan">
					<xsl:value-of select="$colspan" />
				</xsl:attribute>
			</xsl:if>

			<xsl:value-of select="@label" />
		</th>
	</xsl:template>

	<xsl:template match="xul:treecol[@sort]">
		<th>
			<xsl:attribute name="class">
				<xsl:if test="@class">
					<xsl:value-of select="@class" />
					<xsl:text> </xsl:text>
				</xsl:if>
				<xsl:if test="@cycler = 'true'">cycler </xsl:if>
				<xsl:text>treecol</xsl:text>
			</xsl:attribute>

			<a href="xul/sort={substring(@sort, 2)}">
				<xsl:if test="../../@sort = @name">
					<xsl:attribute name="class">selected</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="@label" />
			</a>
		</th>
	</xsl:template>

	<xsl:template match="xul:treechildren">
		<xsl:param name="maxDepth" />

		<tbody class="treechildren">

			<xsl:apply-templates select="xul:treeitem">
				<xsl:with-param name="maxDepth" select="$maxDepth" />
			</xsl:apply-templates>

		</tbody>
	</xsl:template>

	<xsl:template match="xul:treeitem[@container = 'true']/xul:treechildren">
		<xsl:param name="maxDepth" />
		
		<xsl:apply-templates select="xul:treeitem">
			<xsl:with-param name="maxDepth" select="$maxDepth" />
		</xsl:apply-templates>

	</xsl:template>

	<xsl:template match="xul:treeitem">
		<xsl:param name="maxDepth" />

		<xsl:apply-templates select="xul:treerow">
			<xsl:with-param name="maxDepth" select="$maxDepth" />
		</xsl:apply-templates>

		<xsl:if test="@container = 'true'">

			<xsl:apply-templates select="xul:treechildren">
				<xsl:with-param name="maxDepth" select="$maxDepth" />
			</xsl:apply-templates>
			

		</xsl:if>

	</xsl:template>

	<xsl:template match="xul:treerow">
		<xsl:param name="maxDepth" />

		<tr>
			<xsl:attribute name="class">
				<xsl:value-of select="../@class" />
				<xsl:text> </xsl:text>
				<xsl:value-of select="@class" />
				<xsl:text> treerow</xsl:text>
			</xsl:attribute>

			<xsl:variable name="depth" select="count(../../xul:treeitem/ancestor::xul:treeitem[@container = 'true'])" />

			<xsl:call-template name="xul:spacer">
				<xsl:with-param name="i" select="$depth" />
			</xsl:call-template>

			<xsl:apply-templates select="xul:treecell">
				<xsl:with-param name="maxDepth" select="$maxDepth" />
			</xsl:apply-templates>

		</tr>
	</xsl:template>

	<xsl:template match="xul:treecell">
		<xsl:param name="maxDepth" />
		<xsl:variable name="position" select="position()" />
		<xsl:variable name="col" select="ancestor::xul:tree[1]/xul:treecols/xul:treecol[position() = $position]" />
		<xsl:variable name="elementName">
			<xsl:choose>
				<xsl:when test="$col[@primary = 'true']">th</xsl:when>
				<xsl:otherwise>td</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="depth" select="count(../../../xul:treeitem/ancestor::xul:treeitem[@container = 'true'])" />
		<xsl:variable name="colspan" select="$maxDepth - $depth" />

		<xsl:element name="{$elementName}">
			<xsl:attribute name="class">
				<xsl:value-of select="@class" />
				<xsl:if test="$col[@primary = 'true'] and ../../xul:treechildren"> collapsible</xsl:if>
				<xsl:if test="$col[@cycler = 'true']"> cycler</xsl:if>
				<xsl:text> treecell</xsl:text>
			</xsl:attribute>

			<xsl:if test="position() = 1 and $colspan &gt; 1">
				<xsl:attribute name="colspan">
					<xsl:value-of select="$colspan" />
				</xsl:attribute>
			</xsl:if>

			<xsl:choose>
				<xsl:when test="@href">
					<a href="{@href}">
						<xsl:value-of select="@label" />
					</a>
				</xsl:when>
				<xsl:when test="$col[@type = 'checkbox']">
					<input name="id" type="checkbox" value="{@value}">
						<xsl:if test="not($col/@editable = 'true' and @editable = 'true')">
							<xsl:attribute name="disabled">disabled</xsl:attribute>
						</xsl:if>
					</input>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@label" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>

	<xsl:template name="xul:spacer">
		<xsl:param name="i" />

		<xsl:if test="$i &gt; 0">
			<td class="spacer" style="width: 20px;">
				<xsl:text> </xsl:text>
			</td>

			<xsl:call-template name="xul:spacer">
				<xsl:with-param name="i" select="$i - 1" />
			</xsl:call-template>

		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
