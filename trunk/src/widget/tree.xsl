<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:lang="huan-lang"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:exslt="http://exslt.org/common"
	xmlns:xul="http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul"
	xmlns="http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul"
>

	<xsl:import href="../xul2html.xsl" />

	<xsl:template name="tree">
		<xsl:param name="operations" select="true()" />
		<xsl:param name="items.node" select="*[local-name() = ../@id]" />

		<xsl:choose>
			<xsl:when test="$items.node">
				<xsl:variable name="tree">
					<tree seltype="single" style="width: 100%; height: 200px;">
						<treecols>
							<xsl:apply-templates select="$items.node[1]" mode="tree-cols" />
							<xsl:if test="$operations">
								<xsl:apply-templates select="$items.node[1]" mode="tree-operation-cols" />
							</xsl:if>
						</treecols>
						<treechildren>
							<xsl:apply-templates select="$items.node" mode="tree-item">
								<xsl:with-param name="operations" select="$operations" />
							</xsl:apply-templates>
							<xsl:apply-templates select="." mode="tree-statistics-item" />
						</treechildren>
					</tree>
				</xsl:variable>

				<xsl:apply-templates select="exslt:node-set($tree)/xul:tree" />
			</xsl:when>
			<xsl:otherwise>
				<div class="alert">
					<h2>没有结果</h2>
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="tree-col">
		<xsl:param name="primary" />
		<xsl:param name="cycler" />
		<xsl:param name="name" />
		<xsl:param name="attribute" />
		<treecol>
			<xsl:if test="$primary = true()">
				<xsl:attribute name="primary">true</xsl:attribute>
			</xsl:if>
			<xsl:if test="$cycler = true()">
				<xsl:attribute name="cycler">true</xsl:attribute>
			</xsl:if>
			<xsl:if test="$name">
				<xsl:attribute name="class">
					<xsl:value-of select="$name" />
				</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="label">
				<xsl:choose>
					<xsl:when test="$name">
						<xsl:value-of select="$lang[@id = $name]" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="." mode="lang:label">
							<xsl:with-param name="attribute" select="$attribute" />
						</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
		</treecol>
	</xsl:template>

	<xsl:template name="tree-cell">
		<xsl:param name="node" select="." />
		<xsl:param name="sum" />
		<xsl:param name="text" />
		<xsl:param name="empty" />
		<xsl:param name="href" />
		<xsl:param name="name" />

		<treecell>
			<xsl:choose>
				<xsl:when test="$empty" />
				<xsl:otherwise>
					<xsl:if test="$name">
						<xsl:attribute name="class">
							<xsl:value-of select="$name" />
						</xsl:attribute>
					</xsl:if>
					<xsl:if test="$href">
						<xsl:attribute name="href">
							<xsl:value-of select="$href" />
						</xsl:attribute>
					</xsl:if>
					<xsl:attribute name="label">
						<xsl:choose>
							<xsl:when test="$name">
								<xsl:value-of select="$lang[@id = $name]" />
							</xsl:when>
							<xsl:when test="$sum = true()">
								<xsl:value-of select="sum($node)" />
							</xsl:when>
							<xsl:when test="$text = true()">
								<xsl:apply-templates select="." mode="lang:text" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$node" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
		</treecell>
	</xsl:template>


	<xsl:template match="node()" mode="tree-statistics-item" />

	<xsl:template match="node() | @*" mode="tree-children">
		<xul:treechildren>
			<xsl:apply-templates select="." mode="tree-item" />
		</xul:treechildren>
	</xsl:template>

	<xsl:template match="node() | @*" mode="tree-item">
		<xsl:param name="operations" select="true()" />
		<xul:treeitem>
			<xsl:if test="position() mod 2 = 1">
				<xsl:attribute name="class">even</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select="." mode="tree-row">
				<xsl:with-param name="operations" select="$operations" />
			</xsl:apply-templates>
		</xul:treeitem>
	</xsl:template>

	<xsl:template match="node() | @*" mode="tree-row">
		<xsl:param name="operations" select="true()" />
		<xul:treerow>
			<xsl:apply-templates select="." mode="tree-row-content" />
			<xsl:if test="$operations">
				<xsl:apply-templates select="." mode="tree-operation-cells" />
			</xsl:if>
		</xul:treerow>
	</xsl:template>

	<xsl:template match="node() | @*" mode="tree-col">
		<xul:treecol>
			<xsl:attribute name="label">
				<xsl:apply-templates select="." mode="lang:label" />
			</xsl:attribute>
		</xul:treecol>
	</xsl:template>

	<xsl:template match="node() | @*" mode="tree-cell">
		<xul:treecell label="{.}" />
	</xsl:template>

	<xsl:template match="node()" mode="tree-edit-col">
		<xsl:call-template name="tree-col">
			<xsl:with-param name="cycler" select="true()" />
			<xsl:with-param name="name">edit</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="node()" mode="tree-delete-col">
		<xsl:call-template name="tree-col">
			<xsl:with-param name="cycler" select="true()" />
			<xsl:with-param name="name">delete</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="node()" mode="tree-moveUp-col">
		<xsl:call-template name="tree-col">
			<xsl:with-param name="cycler" select="true()" />
			<xsl:with-param name="name">moveUp</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="node()" mode="tree-moveDown-col">
		<xsl:call-template name="tree-col">
			<xsl:with-param name="cycler" select="true()" />
			<xsl:with-param name="name">moveDown</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="node()" mode="tree-operation-cols">
		<xsl:apply-templates select="." mode="tree-edit-col" />
		<xsl:apply-templates select="." mode="tree-delete-col" />
	</xsl:template>

	<xsl:template match="node()" mode="tree-operation-cells">
		<xsl:apply-templates select="." mode="tree-edit-cell" />
		<xsl:apply-templates select="." mode="tree-delete-cell" />
	</xsl:template>

	<xsl:template match="node()" mode="tree-edit-cell">
		<xsl:call-template name="tree-cell">
			<xsl:with-param name="name">edit</xsl:with-param>
			<xsl:with-param name="href">
				<xsl:apply-templates select="." mode="edit-href" />
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="node()" mode="tree-delete-cell">
		<xsl:call-template name="tree-cell">
			<xsl:with-param name="name">delete</xsl:with-param>
			<xsl:with-param name="href">
				<xsl:apply-templates select="." mode="delete-href" />
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

</xsl:stylesheet>
