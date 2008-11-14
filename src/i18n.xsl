<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:exslt="http://exslt.org/common"
	xmlns:str="http://exslt.org/strings"
	xmlns:lang="http://imyui.cn/i18n-xsl"
>

	<xsl:template match="lang:label">
		<xsl:param name="labels" select="/.." />

		<xsl:apply-templates>
			<xsl:with-param name="labels" select="exslt:node-set($labels)" />
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="lang:label[@ref]">
		<xsl:param name="labels" select="/.." />

		<xsl:apply-templates select="$labels/lang:label[@id = current()/@ref]">
			<xsl:with-param name="labels" select="$labels" />
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="lang:label[@name]">
		<xsl:param name="labels" />

		<xsl:value-of select="$labels/lang:label[@name = current()/@name]" />
	</xsl:template>

	<xsl:template match="node() | @*" mode="lang:name">
		<xsl:param name="attribute" />

		<xsl:choose>
			<xsl:when test="$attribute and boolean(current()/text()[count(. | $attribute) = count($attribute)])">
				<xsl:value-of select="$attribute" />
				<xsl:call-template name="str:capitalize">
					<xsl:with-param name="text" select="local-name()" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$attribute and boolean(current()/@*[count(. | $attribute) = count($attribute)])">
				<xsl:value-of select="$attribute" />
				<xsl:if test="name($attribute) != 'xml:lang'">
					<xsl:call-template name="str:capitalize">
						<xsl:with-param name="text" select="local-name($attribute)" />
					</xsl:call-template>
				</xsl:if>
				<xsl:call-template name="str:capitalize">
					<xsl:with-param name="text" select="local-name()" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="count(../*[local-name() = local-name(current())]) &gt; 1">
				<xsl:value-of select="local-name()" />
				<xsl:choose>
					<xsl:when test="$attribute and boolean(current()[count(.|$attribute) = count($attribute)])" />
					<xsl:otherwise>
						<xsl:text>[</xsl:text>
						<xsl:value-of select="count(../*[local-name() = local-name(current())]) - count(following-sibling::*[local-name() = local-name(current())])" />
						<xsl:text>]</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="local-name()" />
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="position() != last()">.</xsl:if>
	</xsl:template>

	<xsl:template name="lang:label">
		<xsl:param name="attribute" />
		<xsl:param name="suffix" />
		<xsl:param name="lang-name" />
		<xsl:param name="labels-name" />
		<xsl:param name="labels-path" />
		<xsl:param name="debug" select="false()" />

		<xsl:param name="i" select="1" />
		<xsl:param name="perfixIndex" select="1" />
		<xsl:param name="labels" select="document(concat($labels-path, $lang-name, '.xml'))/* | document(concat($labels-path, $labels-name, '.', $lang-name, '.xml'))/*" />
		<xsl:param name="prefix-nodes" select="ancestor-or-self::*[namespace-uri() = $labels/lang:item/@namespace-uri]" />
		<xsl:param name="prefix-node" select="$prefix-nodes[$perfixIndex]" />
		<xsl:param name="prefix" select="$labels/lang:item[@namespace-uri = namespace-uri($prefix-node)]/@prefix" />
		<xsl:param name="label-node" select="ancestor::*[count(ancestor::*) &gt; count($prefix-node/ancestor::*)] | ." />
		<xsl:param name="label">
			<xsl:apply-templates select="$label-node[position() &gt;= $i]" mode="lang:name">
				<xsl:with-param name="attribute" select="$attribute" />
			</xsl:apply-templates>
		</xsl:param>

		<xsl:choose>
			<xsl:when test="count($prefix-node) = 0 and $i &gt; count($label-node)" />
			<xsl:when test="$i &lt;= count($label-node)">
				<xsl:variable name="name">
					<xsl:if test="$prefix">
						<xsl:value-of select="$prefix" />
						<xsl:text>:</xsl:text>
					</xsl:if>
					<xsl:value-of select="$label" />
					<xsl:value-of select="$suffix" />
				</xsl:variable>

				<xsl:variable name="text">
					<xsl:apply-templates select="($labels/lang:label[@id = $name])[last()]">
						<xsl:with-param name="labels" select="$labels" />
					</xsl:apply-templates>
				</xsl:variable>

				<xsl:choose>
					<xsl:when test="$text != ''">
						<xsl:value-of select="$text" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="lang:label">
							<xsl:with-param name="attribute" select="$attribute" />
							<xsl:with-param name="suffix" select="$suffix" />
							<xsl:with-param name="debug" select="$debug" />
							<xsl:with-param name="i" select="$i + 1" />
							<xsl:with-param name="perfixIndex" select="$perfixIndex" />
							<xsl:with-param name="labels" select="$labels" />
							<xsl:with-param name="prefix-nodes" select="$prefix-nodes" />
							<xsl:with-param name="prefix-node" select="$prefix-node" />
							<xsl:with-param name="prefix" select="$prefix" />
							<xsl:with-param name="label-node" select="$label-node" />
							<xsl:with-param name="label" select="substring-after($label, '.')" />
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$i &gt; count($label-node)">
				<xsl:call-template name="lang:label">
					<xsl:with-param name="attribute" select="$attribute" />
					<xsl:with-param name="suffix" select="$suffix" />
					<xsl:with-param name="i" select="1" />
					<xsl:with-param name="perfixIndex" select="$perfixIndex + 1" />
					<xsl:with-param name="labels" select="$labels" />
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>