<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:exslt="http://exslt.org/common"
	xmlns:str="http://exslt.org/strings"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
>

	<msxsl:script implements-prefix="exslt" language="JScript">
		this['node-set'] = function(x) {
			return x;
		}
		this['object-type'] = function(x) {
			var objectType = typeof x;
			if (objectType == 'object') return 'node-set';
			return objectType;
		}
	</msxsl:script>

	<xsl:template name="str:capitalize">
		<xsl:param name="text" />
		<xsl:variable name="uppercase">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
		<xsl:variable name="lowercase">abcdefghijklmnopqrstuvwxyz</xsl:variable>

		<xsl:value-of select="translate(substring($text, 1, 1), $lowercase, $uppercase)" />
		<xsl:value-of select="substring($text, 2)" />
	</xsl:template>

</xsl:stylesheet>