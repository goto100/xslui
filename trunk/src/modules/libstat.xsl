<?xml version="1.0" encoding="gb2312"?>
<xsl:stylesheet version="1.0"
	xmlns:stat="huan-statistics"

	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xforms="http://www.w3.org/2002/xforms"
	xmlns:xul="http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul"
>

	<xsl:template match="xforms:instance//stat:views/@total">
		<xsl:call-template name="xforms:input" />
	</xsl:template>

</xsl:stylesheet>
