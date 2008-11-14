<?xml version="1.0" encoding="gb2312"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:ui="http://imyui.cn/xslui"
	xmlns="http://www.w3.org/1999/xhtml"
>

	<xsl:import href="../../src/widget/pagebar.xsl" />
	<xsl:import href="../../src/i18n.xsl" />

	<xsl:output method="html" />

	<xsl:template match="/root">
	<style type="text/css">
		div.pagebar {
			height:16px;
			margin-bottom: 2px;
		}
		div.pagebar li.current {
			font-weight: bold;
		}
		div.pagebar a {
			color: #990000;
		}
		div.pagebar * {
			margin: 0;
			padding: 0;
		}
		div.pagebar ul {
			float: left;
		}
		div.pagebar li {
			float:left;
			height: 16px;
			margin-left: 4px;
			padding: 0 2px;
			font-size: 10.5pt;
			text-align: center;
			list-style-type: none;
			border: 1px solid #CCCCCC;
		}
		div.pagebar li a {
			display: block;
			text-decoration: none;
		}
		div.pagebar p.previous,
		div.pagebar p.next {
			display:block;
			float:left;
			text-indent:-9999px;
		}
		div.pagebar p.total {
			float:right;
			color:#666;
		}
	</style>
		
		<h2>默认</h2>
		<pre><![CDATA[
			<xsl:call-template name="ui:pagebar">
				<xsl:with-param name="total" select="page[1]/@total" />
				<xsl:with-param name="current" select="page[1]/@current" />
			</xsl:call-template>
		]]>
		</pre>
		<xsl:call-template name="ui:pagebar">
			<xsl:with-param name="total" select="page[1]/@total" />
			<xsl:with-param name="current" select="page[1]/@current" />
		</xsl:call-template>
		<hr />
		<h2>自定义当前页位置</h2>
		<pre><![CDATA[
			<xsl:call-template name="ui:pagebar">
				<xsl:with-param name="total" select="page[1]/@total" />
				<xsl:with-param name="current" select="page[1]/@current" />
				<xsl:with-param name="left" select="2" />
			</xsl:call-template>
		]]>
		</pre>
		<xsl:call-template name="ui:pagebar">
			<xsl:with-param name="total" select="page[1]/@total" />
			<xsl:with-param name="current" select="page[1]/@current" />
			<xsl:with-param name="left" select="2" />
		</xsl:call-template>
		<hr />
		<h2>自定义长度</h2>
		<pre><![CDATA[
			<xsl:call-template name="ui:pagebar">
				<xsl:with-param name="total" select="page[1]/@total" />
				<xsl:with-param name="current" select="page[1]/@current" />
				<xsl:with-param name="shows" select="20" />
			</xsl:call-template>
		]]>
		</pre>
		<xsl:call-template name="ui:pagebar">
			<xsl:with-param name="total" select="page[1]/@total" />
			<xsl:with-param name="current" select="page[1]/@current" />
			<xsl:with-param name="shows" select="20" />
		</xsl:call-template>
		<hr />
		<h2>自定义参数名</h2>
		<pre><![CDATA[
			<xsl:call-template name="ui:pagebar">
				<xsl:with-param name="total" select="page[2]/@total" />
				<xsl:with-param name="current" select="page[2]/@current" />
				<xsl:with-param name="param-name">page2</xsl:with-param>
			</xsl:call-template>
		]]>
		</pre>
		<xsl:call-template name="ui:pagebar">
			<xsl:with-param name="total" select="page[2]/@total" />
			<xsl:with-param name="current" select="page[2]/@current" />
			<xsl:with-param name="param-name">page2</xsl:with-param>
		</xsl:call-template>
		<h2>附加参数</h2>
		<pre><![CDATA[
			<xsl:call-template name="ui:pagebar">
				<xsl:with-param name="total" select="page[2]/@total" />
				<xsl:with-param name="current" select="page[2]/@current" />
				<xsl:with-param name="param-name">page2</xsl:with-param>
				<xsl:with-param name="param">&amp;page=50</xsl:with-param>
			</xsl:call-template>
		]]>
		</pre>
		<xsl:call-template name="ui:pagebar">
			<xsl:with-param name="total" select="page[2]/@total" />
			<xsl:with-param name="current" select="page[2]/@current" />
			<xsl:with-param name="param-name">page2</xsl:with-param>
			<xsl:with-param name="param">&amp;page=50</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

</xsl:stylesheet>
