<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="calendar" mode="mini">
	<xsl:param name="caption" />

	<table class="calendar">
		<xsl:if test="$caption">
			<caption><xsl:value-of select="$caption" /></caption>
		</xsl:if>

		<thead>
			<tr>
				<th colspan="1"><a href="#"><xsl:value-of select="number(month/@month) - 1" /></a></th>
				<th colspan="5"><xsl:value-of select="@year" />年<xsl:value-of select="month/@month" />月</th>
				<th colspan="1"><a href="#"><xsl:value-of select="number(month/@month) + 1" /></a></th>
			</tr>
			<tr class="week">
				<th class="sunday weekend" abbr="星期日">日</th>
				<th class="monday" abbr="星期一">一</th>
				<th class="tuesday" abbr="星期二">二</th>
				<th class="wednesday" abbr="星期三">三</th>
				<th class="thursday" abbr="星期四">四</th>
				<th class="friday" abbr="星期五">五</th>
				<th class="saturday weekend" abbr="星期六">六</th>
			</tr>
		</thead>
		<tbody>

			<xsl:apply-templates select="month" mode="mini.week" />

		</tbody>
	</table>

</xsl:template>


<xsl:template match="calendar/month" mode="mini.week">
	<xsl:param name="i" select="0" />

	<xsl:variable name="days" select="number(@days)" />
	<xsl:variable name="startWeek" select="number(@startWeek)" />
	<xsl:variable name="previousMonthDays" select="number(@previousMonthDays)" />
	<xsl:variable name="weeks" select="ceiling(($days + $startWeek) div 7)" />

	<xsl:if test="$i &lt; $weeks">

		<tr>
			<xsl:choose>
				<xsl:when test="$i = 0">
					<xsl:call-template name="calendar.day">
						<xsl:with-param name="mode">previousWeek</xsl:with-param>
						<xsl:with-param name="start" select="$previousMonthDays - $startWeek + 1" />
						<xsl:with-param name="i" select="$startWeek" />
					</xsl:call-template>
					<xsl:call-template name="calendar.day">
						<xsl:with-param name="start" select="1" />
						<xsl:with-param name="i" select="7 - $startWeek" />
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="$i = $weeks - 1">
					<xsl:call-template name="calendar.day">
						<xsl:with-param name="start" select="$i * 7 - $startWeek + 1" />
						<xsl:with-param name="i" select="$days - ($i * 7 - $startWeek)" />
					</xsl:call-template>
					<xsl:call-template name="calendar.day">
						<xsl:with-param name="mode">nextWeek</xsl:with-param>
						<xsl:with-param name="i" select="7 - ($days - ($i * 7 - $startWeek))" />
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="calendar.day">
						<xsl:with-param name="start" select="$i * 7 - $startWeek + 1" />
						<xsl:with-param name="i" select="7" />
					</xsl:call-template>
				</xsl:otherwise>			
			</xsl:choose>
	
		</tr>

		<xsl:apply-templates select="." mode="mini.week">
			<xsl:with-param name="i" select="$i + 1" />
		</xsl:apply-templates>
	</xsl:if>
</xsl:template>

<xsl:template name="calendar.day">
	<xsl:param name="mode" />
	<xsl:param name="start" select="1" />
	<xsl:param name="i" select="0" />
	<xsl:variable name="day" select="$start + $i - 1" />

	<xsl:if test="$i &gt; 0">

		<xsl:call-template name="calendar.day">
			<xsl:with-param name="mode" select="$mode" />
			<xsl:with-param name="start" select="$start" />
			<xsl:with-param name="i" select="$i - 1" />
		</xsl:call-template>

		<td>
			<xsl:attribute name="class">
				<xsl:if test="$mode"><xsl:value-of select="$mode" /> </xsl:if>
			</xsl:attribute>

			<xsl:if test="not($mode)">
				<xsl:apply-templates select="day[@day = $day]" />
			</xsl:if>

			<xsl:value-of select="$day" />
		</td>

	</xsl:if>
</xsl:template>

</xsl:stylesheet>
