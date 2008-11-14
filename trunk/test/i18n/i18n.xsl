<?xml version="1.0" encoding="gb2312"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:exslt="http://exslt.org/common"
	xmlns:lang="http://imyui.cn/i18n-xsl"
	xmlns="http://www.w3.org/1999/xhtml"
>

	<xsl:import href="../../src/widget/pagebar.xsl" />
	<xsl:import href="../../src/i18n.xsl" />

	<xsl:output method="html" />

	<lang:lang xml:lang="zh-cn">
		<lang:label id="hello">你好<lang:label name="name" />，</lang:label>
		<lang:label id="welcome.to.china">欢迎来到<lang:label ref="china" />。</lang:label>
		<lang:label id="china">中国</lang:label>
	</lang:lang>

	<lang:lang xml:lang="en">
		<lang:label id="hello">Hello <lang:label name="name" />, </lang:label>
		<lang:label id="welcome.to.china">Welcome to <lang:label ref="china" />.</lang:label>
		<lang:label id="china">China</lang:label>
	</lang:lang>

	<xsl:template match="node() | @*" mode="label">
		<xsl:param name="labels" select="/.." />
		<xsl:call-template name="lang:label">
			<xsl:with-param name="labels" select="exslt:node-set($labels) | document('')/*/lang:lang[lang('zh-cn')]" />
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="/i18n">
		<xsl:apply-templates select="hello" mode="label">
			<xsl:with-param name="labels">
				<lang:label name="name">tom</lang:label>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:apply-templates select="welcome/to/china" mode="label" />
	</xsl:template>

</xsl:stylesheet>
