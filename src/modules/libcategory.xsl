<?xml version="1.0" encoding="gb2312"?>
<xsl:stylesheet version="1.0"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:cate="huan-category"

	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xforms="http://www.w3.org/2002/xforms"
	xmlns:xul="http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul"
	xmlns="http://www.w3.org/1999/xhtml"
>

	<xsl:template match="cate:category" mode="tree-cols">
		<xsl:apply-templates select="dc:title" mode="tree-col" />
		<xsl:apply-templates select="dc:description" mode="tree-col" />
		<xsl:apply-templates select="." mode="tree-moveUp-col" />
		<xsl:apply-templates select="." mode="tree-moveDown-col" />
		<xsl:apply-templates select="." mode="tree-add-col" />
	</xsl:template>

	<xsl:template match="cate:category" mode="tree-add-col">
		<xsl:call-template name="tree-col">
			<xsl:with-param name="cycler" select="true()" />
			<xsl:with-param name="name">add</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="cate:category[cate:category]" mode="tree-item">
		<xul:treeitem container="true">
			<xul:treerow>
				<xsl:apply-templates select="." mode="tree-row-content" />
				<xsl:apply-templates select="." mode="tree-operation-cells" />
			</xul:treerow>
			<xsl:apply-templates select="cate:category" mode="tree-children" />
		</xul:treeitem>
	</xsl:template>

	<xsl:template match="cate:category" mode="tree-row-content">
		<xsl:apply-templates select="dc:title" mode="tree-cell" />
		<xsl:apply-templates select="dc:description" mode="tree-cell" />
		<xsl:call-template name="tree-cell">
			<xsl:with-param name="empty" select="not(count(preceding-sibling::cate:category))" />
			<xsl:with-param name="name">moveUp</xsl:with-param>
			<xsl:with-param name="href">
				<xsl:apply-templates select="." mode="moveUp-href" />
			</xsl:with-param>
		</xsl:call-template>
		<xsl:call-template name="tree-cell">
			<xsl:with-param name="empty" select="not(count(following-sibling::cate:category))" />
			<xsl:with-param name="name">moveDown</xsl:with-param>
			<xsl:with-param name="href">
				<xsl:apply-templates select="." mode="moveDown-href" />
			</xsl:with-param>
		</xsl:call-template>
		<xsl:choose>
			<xsl:when test="not(ancestor::cate:category/@maxDepth) or count(ancestor::cate:category) &lt; number(ancestor::cate:category/@maxDepth)">
				<xsl:call-template name="tree-cell">
					<xsl:with-param name="name">add</xsl:with-param>
					<xsl:with-param name="href">
						<xsl:apply-templates select="." mode="add-href" />
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xul:treecell />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="cate:category" mode="moveUp-href">
		<xsl:text>increaseCategory.do?categoryid=</xsl:text>
		<xsl:value-of select="@id" />
	</xsl:template>

	<xsl:template match="cate:category" mode="moveDown-href">
		<xsl:text>decreaseCategory.do?categoryid=</xsl:text>
		<xsl:value-of select="@id" />
	</xsl:template>

	<xsl:template match="cate:category" mode="add-href">
		<xsl:text>category-add.jsp?categoryparentid=</xsl:text>
		<xsl:value-of select="@id" />
	</xsl:template>

	<xsl:template match="cate:category" mode="edit-href">
		<xsl:text>preUpdateCategory.do?categoryid=</xsl:text>
		<xsl:value-of select="@id" />
	</xsl:template>

	<xsl:template match="cate:category" mode="delete-href">
		<xsl:text>removeCategory.do?categoryid=</xsl:text>
		<xsl:value-of select="@id" />
	</xsl:template>

	<xsl:template match="xforms:instance//cate:category | xforms:instance//cate:parent">
		<xsl:call-template name="xforms:select1">
			<xsl:with-param name="ref" select="(@id | cate:url)[last()]" />
			<xsl:with-param name="items.form">category</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="xforms:instance/cate:category">
		<xsl:apply-templates select="cate:parent" />
		<xsl:apply-templates select="dc:title" />
		<xsl:apply-templates select="cate:url" mode="xforms:input" />
	</xsl:template>

	<xsl:template match="cate:category" mode="xforms:item">
		<xsl:param name="root" select="." />
		<xsl:param name="child-prefix" />
		<xsl:param name="caller" />

		<xsl:choose>
			<xsl:when test="local-name($caller) = 'category' and number($root/@maxDepth) = 2 and $root/@leafContainer = 'true'">
				<xsl:for-each select="cate:category">
					<xsl:call-template name="xforms:choices">
						<xsl:with-param name="label.content" select="dc:title" />
						<xsl:with-param name="items">
							<xsl:for-each select="cate:category">
								<xsl:call-template name="xforms:item">
									<xsl:with-param name="label.content" select="dc:title" />
									<xsl:with-param name="value.content" select="(@id | cate:url)[last()]" />
								</xsl:call-template>
							</xsl:for-each>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="xforms:item">
					<xsl:with-param name="label.content">
						<xsl:value-of select="$child-prefix" />
						<xsl:choose>
							<xsl:when test="not(parent::cate:category)" />
							<xsl:when test="position() = last()">└ </xsl:when>
							<xsl:otherwise>├ </xsl:otherwise>
						</xsl:choose>
						<xsl:value-of select="dc:title" />
					</xsl:with-param>
					<xsl:with-param name="value.content" select="(@id | cate:url)[last()]" />
				</xsl:call-template>
		
				<xsl:if test="not($root/@maxDepth) or count(ancestor::cate:category) &lt; number($root/@maxDepth) - 1">
					<xsl:apply-templates select="cate:category" mode="xforms:item">
						<xsl:with-param name="caller" select="$caller" />
						<xsl:with-param name="root" select="$root" />
						<xsl:with-param name="child-prefix">
							<xsl:value-of select="$child-prefix" />
							<xsl:choose>
								<xsl:when test="not(parent::cate:category)" />
								<xsl:when test="position() = last()">　</xsl:when>
								<xsl:otherwise>│</xsl:otherwise>
							</xsl:choose>
						</xsl:with-param>
					</xsl:apply-templates>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

</xsl:stylesheet>
