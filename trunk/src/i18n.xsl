<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:exslt="http://exslt.org/common"
	xmlns:str="http://exslt.org/strings"
	xmlns:date="http://exslt.org/dates-and-times"
	xmlns:lang="http://imyui.cn/i18n-xsl"
>

	<xsl:param name="lang:labels-path">i18n/</xsl:param>
	<xsl:param name="lang:lang-name">en</xsl:param>

	<xsl:template match="lang:label">
		<xsl:param name="param" select="/.." />
		<xsl:param name="labels" select="/.." />

		<xsl:variable name="hasAllParams">
			<xsl:for-each select="lang:label">
				<xsl:variable name="pa" select="$param[name() = current()/@name]" />
				<xsl:choose>
					<xsl:when test="$pa = '' or not($pa)">0</xsl:when>
				</xsl:choose>
			</xsl:for-each>
		</xsl:variable>

		<xsl:if test="not(lang:label/@name) or not(contains($hasAllParams, '0'))">
			<xsl:apply-templates>
				<xsl:with-param name="param" select="$param" />
				<xsl:with-param name="labels" select="$labels" />
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>

	<xsl:template match="lang:label[@ref]">
		<xsl:param name="param" select="/.." />
		<xsl:param name="labels" select="/.." />

		<xsl:apply-templates select="$labels/lang:label[@id = current()/@ref]">
			<xsl:with-param name="param" select="$param" />
			<xsl:with-param name="labels" select="$labels" />
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="lang:label[@name]">
		<xsl:param name="param" />
		<xsl:param name="labels" />

		<xsl:value-of select="$param[name() = current()/@name]" />
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
		<xsl:param name="lang-name" select="$lang:lang-name" />
		<xsl:param name="labels-name" />
		<xsl:param name="labels-path" select="$lang:labels-path" />
		<xsl:param name="debug" select="false()" />

		<xsl:param name="i" select="1" />
		<xsl:param name="perfixIndex" select="1" />
		<xsl:param name="labels" select="document(concat($labels-path, $lang-name, '.xml'))/*" />
		<xsl:param name="prefix-nodes" select="ancestor-or-self::*[namespace-uri() = $labels/lang:item/@namespace-uri]" />
		<xsl:param name="prefix-node" select="$prefix-nodes[$perfixIndex]" />
		<xsl:param name="prefix" select="$labels/lang:item[@namespace-uri = namespace-uri($prefix-node)]/@prefix" />
		<xsl:param name="label-node" select="ancestor::*[count(ancestor::*) &gt; count($prefix-node/ancestor::*)] | ." />
		<xsl:param name="label">
			<xsl:apply-templates select="$label-node[position() &gt;= $i]" mode="lang:name">
				<xsl:with-param name="attribute" select="$attribute" />
			</xsl:apply-templates>
		</xsl:param>
		<xsl:param name="name" />
		<xsl:param name="param" />

		<xsl:choose>
			<xsl:when test="$name">
				<xsl:apply-templates select="($labels/lang:label[@id = $name])[last()]">
					<xsl:with-param name="param" select="$param" />
					<xsl:with-param name="labels" select="$labels" />
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="count($prefix-node) = 0 and $i &gt; count($label-node)" />
			<xsl:when test="$i &lt;= count($label-node)">
				<xsl:variable name="fullname">
					<xsl:if test="$prefix">
						<xsl:value-of select="$prefix" />
						<xsl:text>:</xsl:text>
					</xsl:if>
					<xsl:value-of select="$label" />
					<xsl:value-of select="$suffix" />
				</xsl:variable>

				<xsl:variable name="text">
					<xsl:apply-templates select="($labels/lang:label[@id = $fullname])[last()]">
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

	<xsl:template name="lang:format-date">
		<xsl:param name="labels-path" />
		<xsl:param name="lang-name" />
		<xsl:param name="labels" select="document(concat($labels-path, $lang-name, '.xml'))/*" />
		<xsl:param name="date" />

		<xsl:call-template name="date:format-date">
			<xsl:with-param name="date-time" select="$date" />
			<xsl:with-param name="pattern" select="$labels/lang:date-format-long" />
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="lang:format-duration">
		<xsl:param name="labels-path" />
		<xsl:param name="lang-name" />
		<xsl:param name="duration" />

		<xsl:variable name="date">
			<xsl:choose>
				<xsl:when test="contains($duration, 'T')">
					<xsl:value-of select="substring(substring-before($duration, 'T'), 2)" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="substring($duration, 2)" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="time">
			<xsl:value-of select="substring-after($duration, 'T')" />
		</xsl:variable>

		<xsl:variable name="param">
			<xsl:call-template name="lang:date-duration">
				<xsl:with-param name="date" select="$date" />
			</xsl:call-template>
			<xsl:call-template name="lang:time-duration">
				<xsl:with-param name="time" select="$time" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:call-template name="lang:label">
			<xsl:with-param name="labels-path" select="$labels-path" />
			<xsl:with-param name="lang-name" select="$lang-name" />
			<xsl:with-param name="name">duration</xsl:with-param>
			<xsl:with-param name="param" select="exslt:node-set($param)/*/@*" />
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="lang:date-duration">
		<xsl:param name="date" />
		<xsl:param name="year" />
		<xsl:param name="month" />
		<xsl:param name="day" />

		<xsl:choose>
			<xsl:when test="contains($date, 'Y')">
				<xsl:call-template name="lang:date-duration">
					<xsl:with-param name="date" select="substring-after($date, 'Y')" />
					<xsl:with-param name="year" select="substring-before($date, 'Y')" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($date, 'M')">
				<xsl:call-template name="lang:date-duration">
					<xsl:with-param name="date" select="substring-after($date, 'M')" />
					<xsl:with-param name="year" select="$year" />
					<xsl:with-param name="month" select="substring-before($date, 'M')" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($date, 'D')">
				<xsl:call-template name="lang:date-duration">
					<xsl:with-param name="year" select="$year" />
					<xsl:with-param name="month" select="$month" />
					<xsl:with-param name="day" select="substring-before($date, 'D')" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<duration year="{$year}" month="{$month}" day="{$day}" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="lang:time-duration">
		<xsl:param name="time" />
		<xsl:param name="hour" />
		<xsl:param name="minute" />
		<xsl:param name="second" />

		<xsl:choose>
			<xsl:when test="contains($time, 'H')">
				<xsl:call-template name="lang:time-duration">
					<xsl:with-param name="time" select="substring-after($time, 'H')" />
					<xsl:with-param name="hour" select="substring-before($time, 'H')" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($time, 'M')">
				<xsl:call-template name="lang:time-duration">
					<xsl:with-param name="time" select="substring-after($time, 'M')" />
					<xsl:with-param name="hour" select="$hour" />
					<xsl:with-param name="minute" select="substring-before($time, 'M')" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($time, 'S')">
				<xsl:call-template name="lang:time-duration">
					<xsl:with-param name="hour" select="$hour" />
					<xsl:with-param name="minute" select="$minute" />
					<xsl:with-param name="second" select="substring-before($time, 'S')" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<duration hour="{$hour}" minute="{$minute}" second="{$second}" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>