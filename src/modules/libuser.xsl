<?xml version="1.0" encoding="gb2312"?>
<xsl:stylesheet version="1.0"
	xmlns:user="huan-user"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xforms="http://www.w3.org/2002/xforms"
	xmlns:xul="http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul"
	xmlns="http://www.w3.org/1999/xhtml"
>

	<xsl:template match="user:user" mode="tree-cols">
		<xsl:apply-templates select="user:username" mode="tree-col" />
		<xsl:apply-templates select="user:registrationDate" mode="tree-col" />
		<xsl:apply-templates select="user:lastLoggedIn" mode="tree-col" />
		<xsl:apply-templates select="user:account/user:integral" mode="tree-col" />
		<xsl:apply-templates select="@enabled" mode="tree-col" />
	</xsl:template>

	<xsl:template match="user:user" mode="tree-row-content">
		<xsl:attribute name="class">
			<xsl:choose>
				<xsl:when test="@enabled = 'true'">enabled</xsl:when>
				<xsl:otherwise>disabled</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
		<xsl:apply-templates select="user:username" mode="tree-cell" />
		<xsl:apply-templates select="user:registrationDate" mode="tree-cell" />
		<xsl:apply-templates select="user:lastLoggedIn" mode="tree-cell" />
		<xsl:apply-templates select="user:account/user:integral" mode="tree-cell" />
		<xsl:apply-templates select="@enabled" mode="tree-cell" />
	</xsl:template>

	<xsl:template match="user:username" mode="tree-col">
		<xsl:call-template name="tree-col">
			<xsl:with-param name="primary" select="true()" />
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="user:user/@enabled" mode="tree-col">
		<xsl:call-template name="tree-col">
			<xsl:with-param name="cycler" select="true()" />
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="user:user/@enabled" mode="tree-cell">
		<xsl:call-template name="tree-cell">
			<xsl:with-param name="name">state</xsl:with-param>
			<xsl:with-param name="href" select="concat('openClose.do?userid=', ../@id, '&amp;open=true')" />
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="user:user/@enabled[. = 'true']" mode="tree-cell">
		<xsl:call-template name="tree-cell">
			<xsl:with-param name="name">state</xsl:with-param>
			<xsl:with-param name="href" select="concat('openClose.do?userid=', ../@id, '&amp;open=false')" />
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="user:user" mode="xforms:item">
		<xsl:call-template name="xforms:item">
			<xsl:with-param name="label.content" select="user:username" />
			<xsl:with-param name="value.content" select="user:username" />
			<xsl:with-param name="hint.content" select="user:username" />
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="xforms:instance//user:username">
		<xsl:call-template name="xforms:input" />
	</xsl:template>

</xsl:stylesheet>
