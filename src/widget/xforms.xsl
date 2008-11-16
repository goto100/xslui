<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY empty		"&#12288;">
	<!ENTITY v-line		"&#9474;">
	<!ENTITY i-line		"&#9500;">
	<!ENTITY lb-corner	"&#9492;">
]>
<xsl:stylesheet version="1.0"
	xmlns:lang="http://imyui.cn/i18n-xsl"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:exslt="http://exslt.org/common"
	xmlns:html="http://www.w3.org/1999/xhtml"
	xmlns:xforms="http://www.w3.org/2002/xforms"
	xmlns="http://www.w3.org/2002/xforms"
>

	<xsl:import href="../xforms2html.xsl" />

	<xsl:template match="node() | @*" mode="xforms:input">
		<xsl:call-template name="xforms:input" />
	</xsl:template>

	<xsl:template match="node() | @*" mode="xforms:secret">
		<xsl:call-template name="xforms:secret" />
	</xsl:template>

	<xsl:template match="node() | @*" mode="xforms:textarea">
		<xsl:call-template name="xforms:textarea" />
	</xsl:template>

	<xsl:template match="node() | @*" mode="xforms:upload">
		<xsl:call-template name="xforms:upload" />
	</xsl:template>

	<xsl:template match="node() | @*" mode="xforms:select">
		<xsl:param name="attribute" />
		<xsl:param name="items.boolean" />
		<xsl:param name="items.node" />
		<xsl:param name="items.text" />
		<xsl:param name="items.form" />
		<xsl:param name="items" />
		<xsl:call-template name="xforms:select">
			<xsl:with-param name="ref" select="." />
			<xsl:with-param name="attribute" select="$attribute" />
			<xsl:with-param name="items.boolean" select="$items.boolean" />
			<xsl:with-param name="items.node" select="$items.node" />
			<xsl:with-param name="items.text" select="$items.text" />
			<xsl:with-param name="items.form" select="$items.form" />
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="node() | @*" mode="xforms:select1">
		<xsl:call-template name="xforms:select1">
			<xsl:with-param name="ref" select="." />
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="node() | @*" mode="xforms:item">
		<xsl:call-template name="xforms:item">
			<xsl:with-param name="label.content" select="." />
			<xsl:with-param name="value.content" select="." />
		</xsl:call-template>	
	</xsl:template>

	<xsl:template name="xforms:submit">
		<xsl:param name="label.name">submit</xsl:param>
		<xsl:variable name="config">
			<submit>
				<label><xsl:value-of select="$lang[@id = $label.name]" /></label>
			</submit>
		</xsl:variable>

		<xsl:apply-templates select="exslt:node-set($config)/xforms:submit" />
	</xsl:template>

	<xsl:template name="xforms:label">
		<xsl:param name="name" />
		<xsl:param name="attribute" />
		<xsl:param name="ref" select="." />
		<xsl:param name="content">
			<xsl:call-template name="lang:label">
				<xsl:with-param name="name" select="$name" />
				<xsl:with-param name="attribute" select="$attribute" />
			</xsl:call-template>
		</xsl:param>

		<xsl:if test="$content != ''">
			<label><xsl:value-of select="$content" />: </label>
		</xsl:if>
	</xsl:template>

	<xsl:template name="xforms:hint">
		<xsl:param name="attribute" />
		<xsl:variable name="value">
			<xsl:apply-templates select="." mode="lang:hint">
				<xsl:with-param name="attribute" select="$attribute" />
			</xsl:apply-templates>
		</xsl:variable>

		<xsl:if test="$value != ''">
			<hint><xsl:value-of select="$value" /></hint>
		</xsl:if>
	</xsl:template>

	<xsl:template name="xforms:alert">
		<xsl:param name="attribute" />
		<xsl:variable name="id">
			<xsl:apply-templates select="." mode="xforms:id">
				<xsl:with-param name="attribute" select="$attribute" />
			</xsl:apply-templates>
		</xsl:variable>
		<xsl:variable name="element" select="ancestor::xforms:model[1]/xforms:instance[@id = 'errors']/errors/error[@for = $id]" />

		<xsl:if test="$element">
			<alert><xsl:value-of select="$element" /></alert>
		</xsl:if>
	</xsl:template>

	<xsl:template name="xforms:item">
		<xsl:param name="label.content" />
		<xsl:param name="value.content" />
		<xsl:param name="hint.content" />
		<item>
			<xsl:if test="$label.content != ''">
				<label><xsl:value-of select="$label.content" /></label>
			</xsl:if>
			<xsl:if test="$value.content != ''">
				<value><xsl:value-of select="$value.content" /></value>
			</xsl:if>
			<xsl:if test="$hint.content != ''">
				<hint><xsl:value-of select="$hint.content" /></hint>
			</xsl:if>
		</item>
	</xsl:template>

	<xsl:template match="*" mode="xforms:item.tree">
		<xsl:param name="tree" select="/.." />
		<xsl:param name="child-prefix" />
		<xsl:variable name="_item">
			<xsl:apply-templates select="." mode="xforms:item" />
		</xsl:variable>
		<xsl:variable name="item" select="exslt:node-set($_item)/xforms:item" />

		<item>
			<xsl:if test="$item/xforms:label">
				<label>
					<xsl:value-of select="$child-prefix" />
					<xsl:choose>
						<xsl:when test="not(parent::*[count(.|$tree) = count($tree)])" />
						<xsl:when test="position() = last()">&lb-corner; </xsl:when>
						<xsl:otherwise>&i-line; </xsl:otherwise>
					</xsl:choose>
					<xsl:value-of select="$item/xforms:label" />
				</label>
			</xsl:if>
			<xsl:copy-of select="$item/xforms:value" />
			<xsl:copy-of select="$item/xforms:hint" />
		</item>

		<xsl:apply-templates select="*[count(.|$tree) = count($tree)]" mode="xforms:item.tree">
			<xsl:with-param name="tree" select="$tree" />
			<xsl:with-param name="child-prefix">
				<xsl:value-of select="$child-prefix" />
				<xsl:choose>
					<xsl:when test="not(parent::*[count(.|$tree) = count($tree)])" />
					<xsl:when test="position() = last()">&empty;</xsl:when>
					<xsl:otherwise>&v-line;</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:apply-templates>

	</xsl:template>

	<xsl:template name="xforms:choices">
		<xsl:param name="label.content" />
		<xsl:param name="items.node" />
		<xsl:param name="items">
			<xsl:choose>
				<xsl:when test="$items.node">
					<xsl:apply-templates select="$items.node" mode="xforms:item">
						<xsl:with-param name="caller" select="." />
					</xsl:apply-templates>
				</xsl:when>
			</xsl:choose>
		</xsl:param>

		<choices>
			<xsl:if test="$label.content != ''">
				<label><xsl:value-of select="$label.content" /></label>
				<xsl:copy-of select="$items" />
			</xsl:if>
		</choices>
	</xsl:template>

	<xsl:template name="xforms:input">
		<xsl:param name="attribute" />
		<xsl:param name="spinner" />
		<xsl:param name="bind" select="/.." />
		<xsl:param name="label.name" />
		<xsl:param name="label">
			<xsl:call-template name="xforms:label">
				<xsl:with-param name="attribute" select="$attribute" />
				<xsl:with-param name="name" select="$label.name" />
			</xsl:call-template>
		</xsl:param>
		<xsl:param name="hint">
			<xsl:call-template name="xforms:hint">
				<xsl:with-param name="attribute" select="$attribute" />
			</xsl:call-template>
		</xsl:param>
		<xsl:param name="alert">
			<xsl:call-template name="xforms:alert">
				<xsl:with-param name="attribute" select="$attribute" />
			</xsl:call-template>
		</xsl:param>

		<xsl:variable name="config">
			<input>
				<xsl:if test="$spinner">
					<xsl:attribute name="class">spinner</xsl:attribute>
				</xsl:if>
				<xsl:copy-of select="$label" />
				<xsl:copy-of select="$hint" />
				<xsl:copy-of select="$alert" />
			</input>
		</xsl:variable>

		<xsl:apply-templates select="exslt:node-set($config)/xforms:input">
			<xsl:with-param name="model" select="/xforms:model" />
			<xsl:with-param name="ref" select="." />
			<xsl:with-param name="bind" select="exslt:node-set($bind)/xforms:bind" />
			<xsl:with-param name="attribute" select="$attribute" />
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template name="xforms:range">
		<xsl:param name="attribute" />
		<xsl:param name="start" />
		<xsl:param name="end" />
		<xsl:param name="step" select="1" />
		<xsl:param name="label.name" />
		<xsl:param name="label">
			<xsl:call-template name="xforms:label">
				<xsl:with-param name="attribute" select="$attribute" />
				<xsl:with-param name="name" select="$label.name" />
			</xsl:call-template>
		</xsl:param>
		<xsl:param name="hint">
			<xsl:call-template name="xforms:hint">
				<xsl:with-param name="attribute" select="$attribute" />
			</xsl:call-template>
		</xsl:param>
		<xsl:param name="alert">
			<xsl:call-template name="xforms:alert">
				<xsl:with-param name="attribute" select="$attribute" />
			</xsl:call-template>
		</xsl:param>

		<xsl:variable name="config">
			<range start="{$start}" end="{$end}" step="{$step}">
				<xsl:copy-of select="$label" />
				<xsl:copy-of select="$hint" />
				<xsl:copy-of select="$alert" />
			</range>
		</xsl:variable>

		<xsl:apply-templates select="exslt:node-set($config)/xforms:range">
			<xsl:with-param name="model" select="/xforms:model" />
			<xsl:with-param name="ref" select="." />
			<xsl:with-param name="attribute" select="$attribute" />
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template name="xforms:secret">
		<xsl:param name="attribute" />

		<xsl:variable name="config">
			<secret>
				<xsl:call-template name="xforms:label">
					<xsl:with-param name="attribute" select="$attribute" />
				</xsl:call-template>
				<xsl:call-template name="xforms:hint">
					<xsl:with-param name="attribute" select="$attribute" />
				</xsl:call-template>
				<xsl:call-template name="xforms:alert">
					<xsl:with-param name="attribute" select="$attribute" />
				</xsl:call-template>
			</secret>
		</xsl:variable>

		<xsl:apply-templates select="exslt:node-set($config)/xforms:secret">
			<xsl:with-param name="model" select="/xforms:model" />
			<xsl:with-param name="ref" select="." />
			<xsl:with-param name="attribute" select="$attribute" />
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template name="xforms:textarea">
		<xsl:param name="attribute" />

		<xsl:variable name="config">
			<textarea>
				<xsl:call-template name="xforms:label">
					<xsl:with-param name="attribute" select="$attribute" />
				</xsl:call-template>
				<xsl:call-template name="xforms:hint">
					<xsl:with-param name="attribute" select="$attribute" />
				</xsl:call-template>
				<xsl:call-template name="xforms:alert">
					<xsl:with-param name="attribute" select="$attribute" />
				</xsl:call-template>
			</textarea>
		</xsl:variable>

		<xsl:apply-templates select="exslt:node-set($config)/xforms:textarea">
			<xsl:with-param name="model" select="/xforms:model" />
			<xsl:with-param name="ref" select="." />
			<xsl:with-param name="attribute" select="$attribute" />
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template name="xforms:select1">
		<xsl:param name="attribute" />
		<xsl:param name="ref" select="." />
		<xsl:param name="with-none" />
		<xsl:param name="items.boolean" />
		<xsl:param name="items.node" />
		<xsl:param name="items.text" />
		<xsl:param name="items.form" />
		<xsl:param name="items.tree" />
		<xsl:param name="items">
			<xsl:if test="$with-none">
				<xforms:item>
					<xforms:label>
						<xsl:variable name="label">
							<xsl:apply-templates select="$ref" mode="lang:text">
								<xsl:with-param name="text" select="$with-none" />
							</xsl:apply-templates>
						</xsl:variable>
						<xsl:choose>
							<xsl:when test="$label != ''">
								<xsl:value-of select="$label" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$lang[@id = 'all']" />
							</xsl:otherwise>
						</xsl:choose>
					</xforms:label>			
					<xforms:value>
						<xsl:if test="$with-none != true()">
							<xsl:value-of select="$with-none" />
						</xsl:if>
					</xforms:value>
				</xforms:item>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="$items.boolean">
					<xsl:call-template name="xforms:item">
						<xsl:with-param name="label.content">
							<xsl:apply-templates select="." mode="lang:label" />
						</xsl:with-param>
						<xsl:with-param name="value.content">true</xsl:with-param>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="$items.text">
					<xsl:for-each select="$items.text">
						<xsl:call-template name="xforms:item">
							<xsl:with-param name="label.content">
								<xsl:apply-templates select="." mode="lang:text" />
							</xsl:with-param>
							<xsl:with-param name="value.content" select="." />
						</xsl:call-template>
					</xsl:for-each>
				</xsl:when>
				<xsl:when test="$items.tree">
					<xsl:apply-templates select="." mode="xforms:item.tree">
						<xsl:with-param name="tree" select="$items.tree" />
					</xsl:apply-templates>
				</xsl:when>
				<xsl:when test="$items.node">
					<xsl:apply-templates select="$items.node" mode="xforms:item">
						<xsl:with-param name="caller" select="." />
					</xsl:apply-templates>
				</xsl:when>
				<xsl:when test="$items.form">
					<xsl:apply-templates select="document(following::xforms:instance[@id = local-name(current())][last()]/@src)/*/*[name() = $items.form]" mode="xforms:item">
						<xsl:with-param name="caller" select="." />
					</xsl:apply-templates>
				</xsl:when>
			</xsl:choose>
		</xsl:param>
		<xsl:param name="appearance">
			<xsl:choose>
				<xsl:when test="$items.boolean">full</xsl:when>
				<xsl:otherwise>minimal</xsl:otherwise>
			</xsl:choose>
		</xsl:param>

		<xsl:variable name="config">
			<select1>
				<xsl:if test="$appearance">
					<xsl:attribute name="appearance">
						<xsl:value-of select="$appearance" />
					</xsl:attribute>
				</xsl:if>
				<xsl:call-template name="xforms:label">
					<xsl:with-param name="ref" select="$ref" />
					<xsl:with-param name="attribute" select="$attribute" />
				</xsl:call-template>
				<xsl:copy-of select="$items" />
				<xsl:call-template name="xforms:hint">
					<xsl:with-param name="attribute" select="$attribute" />
				</xsl:call-template>
				<xsl:call-template name="xforms:alert">
					<xsl:with-param name="attribute" select="$attribute" />
				</xsl:call-template>
			</select1>
		</xsl:variable>

		<xsl:apply-templates select="exslt:node-set($config)/xforms:select1">
			<xsl:with-param name="model" select="/xforms:model" />
			<xsl:with-param name="ref" select="$ref" />
			<xsl:with-param name="attribute" select="$attribute" />
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template name="xforms:select">
		<xsl:param name="attribute" />
		<xsl:param name="ref" select="." />
		<xsl:param name="items.boolean" />
		<xsl:param name="items.node" />
		<xsl:param name="items.text" />
		<xsl:param name="items.form" />
		<xsl:param name="items">
			<xsl:choose>
				<xsl:when test="$items.boolean">
					<xsl:call-template name="xforms:item">
						<xsl:with-param name="label.content">
							<xsl:apply-templates select="." mode="lang:label" />
						</xsl:with-param>
						<xsl:with-param name="value.content">true</xsl:with-param>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="$items.text">
					<xsl:for-each select="$items.text">
						<xsl:call-template name="xforms:item">
							<xsl:with-param name="label.content">
								<xsl:apply-templates select="." mode="lang:text" />
							</xsl:with-param>
							<xsl:with-param name="value.content" select="." />
						</xsl:call-template>
					</xsl:for-each>
				</xsl:when>
				<xsl:when test="$items.node">
					<xsl:apply-templates select="$items.node" mode="xforms:item">
						<xsl:with-param name="caller" select="." />
					</xsl:apply-templates>
				</xsl:when>
				<xsl:when test="$items.form">
					<xsl:variable name="local-name" select="local-name()" />
					<xsl:apply-templates select="document(following::xforms:instance[@id = local-name(current())][last()]/@src)/*/*[name() = $items.form]" mode="xforms:item">
						<xsl:with-param name="caller" select="." />
					</xsl:apply-templates>
				</xsl:when>
			</xsl:choose>
		</xsl:param>
		<xsl:param name="appearance">
			<xsl:choose>
				<xsl:when test="$items.boolean">full</xsl:when>
				<xsl:otherwise>minimal</xsl:otherwise>
			</xsl:choose>
		</xsl:param>

		<xsl:variable name="config">
			<select>
				<xsl:if test="$appearance">
					<xsl:attribute name="appearance">
						<xsl:value-of select="$appearance" />
					</xsl:attribute>
				</xsl:if>
				<xsl:call-template name="xforms:label">
					<xsl:with-param name="ref" select="$ref" />
					<xsl:with-param name="attribute" select="$attribute" />
				</xsl:call-template>
				<xsl:copy-of select="$items" />
				<xsl:call-template name="xforms:hint">
					<xsl:with-param name="attribute" select="$attribute" />
				</xsl:call-template>
				<xsl:call-template name="xforms:alert">
					<xsl:with-param name="attribute" select="$attribute" />
				</xsl:call-template>
			</select>
		</xsl:variable>

		<xsl:apply-templates select="exslt:node-set($config)/xforms:select">
			<xsl:with-param name="model" select="/xforms:model" />
			<xsl:with-param name="ref" select="$ref" />
			<xsl:with-param name="attribute" select="$attribute" />
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template name="xforms:upload">
		<xsl:param name="attribute" />
		<xsl:variable name="config">
			<upload>
				<xsl:call-template name="xforms:label">
					<xsl:with-param name="attribute" select="$attribute" />
				</xsl:call-template>
				<xsl:call-template name="xforms:hint">
					<xsl:with-param name="attribute" select="$attribute" />
				</xsl:call-template>
				<xsl:call-template name="xforms:alert">
					<xsl:with-param name="attribute" select="$attribute" />
				</xsl:call-template>
			</upload>
		</xsl:variable>

		<xsl:apply-templates select="exslt:node-set($config)/xforms:upload">
			<xsl:with-param name="model" select="/xforms:model" />
			<xsl:with-param name="ref" select="." />
			<xsl:with-param name="attribute" select="$attribute" />
		</xsl:apply-templates>
	</xsl:template>

</xsl:stylesheet>
