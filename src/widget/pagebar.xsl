<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY laquo		"&#171;">
	<!ENTITY lsaquo		"&#8249;">
	<!ENTITY rsaquo		"&#8250;">
]>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:str="http://exslt.org/strings"
	xmlns:lang="http://imyui.cn/i18n-xsl"
	xmlns:ui="http://imyui.cn/xslui"
	xmlns="http://www.w3.org/1999/xhtml"
>
	<xsl:template name="ui:pagebar">
		<!-- 总页数 -->
		<xsl:param name="total" select="1" />
		<!-- 当前页 -->
		<xsl:param name="current" select="1" />
		<!-- 分页链接附加参数 -->
		<xsl:param name="param" />
		<!-- 分页参数名 -->
		<xsl:param name="param-name">page</xsl:param>
		<!-- 显示的页码数量 -->
		<xsl:param name="shows" select="15" />
		<!-- 当前页左边页面数量 -->
		<xsl:param name="left" select="floor($shows div 2)" />
		<xsl:param name="lang" select="/.." />
		<xsl:variable name="right" select="$shows - $left" />
		<!-- 显示页码数 -->
		<xsl:variable name="count">
			<xsl:choose>
				<xsl:when test="$total &lt; $shows">
					<xsl:value-of select="$total" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$shows" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!-- 第一个显示的页码 -->
		<xsl:variable name="start">
			<xsl:choose>
				<xsl:when test="$current &lt; $left + 1">1</xsl:when>
				<xsl:when test="$current + $right &gt; $total">
					<xsl:value-of select="$total - $count + 1" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$current - $left" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<div class="pagebar">
			<ul>
				<xsl:if test="$start &gt; 1">
					<li class="first">
						<a title="{$lang[@id = 'page.first']}" href="?{$param-name}=1{$param}">&laquo;</a>
					</li>
				</xsl:if>
				<xsl:if test="$current &gt; 1">
					<li class="previous">
						<a title="{$lang[@id = 'page.previous']}" href="?{$param-name}={$current - 1}{$param}">&lsaquo;</a>
					</li>
				</xsl:if>
				<xsl:call-template name="ui:pagebar-item">
					<xsl:with-param name="total" select="$count" />
					<xsl:with-param name="start" select="$start" />
					<xsl:with-param name="param-name" select="$param-name" />
					<xsl:with-param name="param" select="$param" />
					<xsl:with-param name="current" select="$current" />
					<xsl:with-param name="lang" select="$lang" />
				</xsl:call-template>
				<xsl:if test="$current &lt; $total">
					<li class="next">
						<a title="{$lang[@id = 'page.next']}" href="?{$param-name}={$current + 1}{$param}">&rsaquo;</a>
					</li>
				</xsl:if>
				<xsl:if test="$start + $count &lt; $total + 1">
					<li class="last">
						<a title="{$lang[@id = 'page.last']}" href="?{$param-name}={$total}{$param}"><xsl:value-of select="$total" /></a>
					</li>
				</xsl:if>
			</ul>
		</div>
	</xsl:template>

	<xsl:template name="ui:pagebar-item">
		<xsl:param name="start" select="1" />
		<xsl:param name="total" select="1" />
		<xsl:param name="param-name" />
		<xsl:param name="param" />		
		<xsl:param name="current" select="1" />
		<xsl:param name="lang" select="/.." />

		<xsl:if test="$total &gt; 0">
			<xsl:choose>
				<xsl:when test="$start = $current">
					<li class="current"><xsl:value-of select="$start" /></li>
				</xsl:when>
				<xsl:otherwise>
					<li class="item">
						<a href="?{$param-name}={$start}{$param}">
							<xsl:attribute name="title">
								<xsl:apply-templates select="$lang[@id = 'page.nth']">
									<xsl:with-param name="labels">
										<lang:label name="index"><xsl:value-of select="$start" /></lang:label>
									</xsl:with-param>
								</xsl:apply-templates>
							</xsl:attribute>
							<xsl:value-of select="$start" />
						</a>
					</li>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:call-template name="ui:pagebar-item">
				<xsl:with-param name="total" select="$total - 1" />
				<xsl:with-param name="start" select="$start + 1" />
				<xsl:with-param name="param-name" select="$param-name" />
				<xsl:with-param name="param" select="$param" />
				<xsl:with-param name="current" select="$current" />
				<xsl:with-param name="lang" select="$lang" />
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
