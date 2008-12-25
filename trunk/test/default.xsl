<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:search="huan-search"

	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:exslt="http://exslt.org/common"
	xmlns:set="http://exslt.org/sets"
	xmlns:str="http://exslt.org/strings"
	xmlns:lang="http://imyui.cn/i18n-xsl"

	xmlns:xforms="http://www.w3.org/2002/xforms"
	xmlns:ui="http://imyui.cn/xslui"
>

	<xsl:import href="../src/function.xsl" />
	<xsl:import href="../src/i18n.xsl" />
	<xsl:import href="../src/xslui.xsl" />

	<xsl:output method="html" indent="yes" encoding="utf-8" />

	<xsl:variable name="ui:config" select="document('config.xml')/*" />

	<xsl:template match="/" mode="default">
		<xsl:param name="config" select="$ui:config" />

		<html>
			<head>
				<link type="text/css" rel="stylesheet" href="{$config/stylePath}default.css" />
				<script type="text/javascript" src="{$config/rootPath}src/base2.js"></script>
				<script type="text/javascript" src="{$config/rootPath}src/base2-dom.js"></script>
				<script type="text/javascript" src="{$config/rootPath}src/xslui.js"></script>
			</head>
			<body class="default">
				<div id="main">
					<div id="content">

						<xsl:apply-templates select="*/@msg" />

						<xsl:apply-templates />

					</div>
				</div>
			</body>
		</html>
	</xsl:template>

	<xsl:template match="xforms:model">
		<xsl:apply-templates select="xforms:submission" />
	</xsl:template>

	<xsl:template name="ui:label">
		<xsl:param name="name" />
		<xsl:param name="param" />
		<xsl:call-template name="lang:label">
			<xsl:with-param name="labels-path" select="$ui:config/languagePath" />
			<xsl:with-param name="lang-name" select="$ui:config/language" />
			<xsl:with-param name="name" select="$name" />
			<xsl:with-param name="param" select="$param" />
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="node() | @*" mode="ui:label">
		<xsl:call-template name="lang:label">
			<xsl:with-param name="labels-path" select="$ui:config/languagePath" />
			<xsl:with-param name="lang-name" select="$ui:config/language" />
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="page" mode="bar">
		<xsl:call-template name="ui:pagebar">
			<xsl:with-param name="shows" select="15" />
			<xsl:with-param name="left" select="5" />
			<xsl:with-param name="total" select="number(@total)" />
			<xsl:with-param name="current" select="number(@current)" />
			<xsl:with-param name="param">
				<xsl:variable name="form" select="../xforms:model/xforms:instance[1]/*" />
				<xsl:if test="$form/search:search = 'true'">&amp;search=<xsl:value-of select="$form/search:search" /></xsl:if>
				<xsl:apply-templates select="../xforms:model/xforms:instance[1]" mode="xforms:ids">
					<xsl:with-param name="concat" select="true()" />
					<xsl:with-param name="without" select="$form/search:search" />
				</xsl:apply-templates>
			</xsl:with-param>
			<xsl:with-param name="param-name">page</xsl:with-param>
			<xsl:with-param name="lang" select="$lang[starts-with(@id, 'page.')]" />
		</xsl:call-template>
		<xsl:if test="@count">
			<p><xsl:value-of select="@count" /></p>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
