<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:exslt="http://exslt.org/common"
	xmlns:str="http://exslt.org/strings"
	xmlns:xforms="http://www.w3.org/2002/xforms"
	xmlns:html="http://www.w3.org/1999/xhtml"
	xmlns="http://www.w3.org/1999/xhtml"
>

	<xsl:template match="node()" mode="xforms:xpath">
		<xsl:param name="attribute" />
		<xsl:param name="isEnd" select="true()" />

		<xsl:if test="namespace-uri(../..) != 'http://www.w3.org/2002/xforms'">
			<xsl:apply-templates select=".." mode="xforms:xpath">
				<xsl:with-param name="attribute" select="$attribute" />
				<xsl:with-param name="isEnd" select="false()" />
			</xsl:apply-templates>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="$attribute and boolean(@*[count(.|$attribute) = count($attribute)])">
				<xsl:text>[</xsl:text>
				<xsl:value-of select="local-name()" />
				<xsl:text>=</xsl:text>
				<xsl:value-of select="$attribute" />
				<xsl:text>]</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="local-name()" />
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="not($isEnd)">/</xsl:if>
	</xsl:template>

	<xsl:template match="@*" mode="xforms:xpath">
		<xsl:param name="attribute" />

		<xsl:if test="namespace-uri(../..) != 'http://www.w3.org/2002/xforms'">
			<xsl:apply-templates select=".." mode="xforms:xpath">
				<xsl:with-param name="attribute" select="$attribute" />
				<xsl:with-param name="isEnd" select="false()" />
			</xsl:apply-templates>
		</xsl:if>
		<xsl:text>@</xsl:text>
		<xsl:value-of select="local-name()" />
	</xsl:template>

	<xsl:template match="xforms:instance" mode="xforms:ids">
		<xsl:param name="concat" />
		<xsl:param name="without" select="/.." />

		<xsl:for-each select=".//*[not(*) and . !=  '' and count($without | .) != count($without)] | .//@*[. !=  '']">
			<xsl:if test="$concat or position() != 1">&amp;</xsl:if>
			<xsl:apply-templates select="." mode="xforms:id" />
			<xsl:text>=</xsl:text>
			<xsl:value-of select="." />
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="node() | @*" mode="xforms:id">
		<xsl:param name="attribute" />

		<xsl:if test="namespace-uri(..) != 'http://www.w3.org/2002/xforms'">
			<xsl:apply-templates select=".." mode="xforms:id">
				<xsl:with-param name="attribute" select="$attribute" />
			</xsl:apply-templates>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="$attribute and boolean(text()[count(.|$attribute) = count($attribute)])">
				<xsl:value-of select="$attribute" />
				<xsl:call-template name="str:capitalize">
					<xsl:with-param name="text" select="local-name()" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$attribute and boolean(@*[count(.|$attribute) = count($attribute)])">
				<xsl:value-of select="$attribute" />
				<xsl:if test="name($attribute) != 'xml:lang'">
					<xsl:value-of select="local-name($attribute)" />
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
	</xsl:template>

	<xsl:template match="xforms:submission">
		<xsl:variable name="method">
			<xsl:choose>
				<xsl:when test="@method = 'form-data-post'">post</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@method" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<form class="xforms" action="{@action}" method="{$method}">
			<xsl:if test="@method = 'form-data-post'">
				 <xsl:attribute name="enctype">multipart/form-data</xsl:attribute>
			</xsl:if>

			<xsl:apply-templates select="../xforms:instance[1]" />

		</form>
	</xsl:template>

	<xsl:template match="xforms:label">
		<xsl:param name="for" />

		<label for="{$for}">
			<xsl:value-of select="." />
		</label>
	</xsl:template>

	<xsl:template match="
		xforms:select1[@appearance = 'full']/xforms:label |
		xforms:select/xforms:label
	">
		<dt class="label">
			<xsl:value-of select="." />
		</dt>
	</xsl:template>

	<xsl:template match="xforms:choices/xforms:label">
		<xsl:attribute name="label">
			<xsl:value-of select="." />
		</xsl:attribute>
	</xsl:template>

	<xsl:template match="xforms:hint">
		<p class="hint"><xsl:value-of select="." /></p>
	</xsl:template>

	<xsl:template match="xforms:alert">
		<p class="alert"><xsl:value-of select="." /></p>
	</xsl:template>

	<xsl:template match="xforms:input">
		<xsl:param name="model" />
		<xsl:param name="ref" />
		<xsl:param name="bind" />
		<xsl:param name="attribute" />
		<xsl:variable name="xpath">
			<xsl:apply-templates select="$ref" mode="xforms:xpath">
				<xsl:with-param name="attribute" select="$attribute" />
			</xsl:apply-templates>
		</xsl:variable>
		<xsl:variable name="id">
			<xsl:apply-templates select="$ref" mode="xforms:id">
				<xsl:with-param name="attribute" select="$attribute" />
			</xsl:apply-templates>
		</xsl:variable>

		<div>
			<xsl:attribute name="class">
				<xsl:value-of select="@class" /><xsl:text> </xsl:text>
				<xsl:if test="$bind/@type = 'xs:date'">datepicker </xsl:if>
				<xsl:text>input</xsl:text>
			</xsl:attribute>
			<xsl:apply-templates select="xforms:label">
				<xsl:with-param name="for" select="$id" />
			</xsl:apply-templates>
			<input id="{$id}" name="{$id}" type="text" value="{$ref}">
				<xsl:if test="$model/xforms:bind[starts-with($xpath, @nodeset) and @relevant='false()']">
					<xsl:attribute name="disabled">disabled</xsl:attribute>
				</xsl:if>
			</input>
			<xsl:apply-templates select="xforms:hint" />
			<xsl:apply-templates select="xforms:alert" />
		</div>
	</xsl:template>

	<xsl:template match="xforms:range">
		<xsl:param name="model" />
		<xsl:param name="ref" />
		<xsl:param name="attribute" />
		<xsl:variable name="xpath">
			<xsl:apply-templates select="$ref" mode="xforms:xpath">
				<xsl:with-param name="attribute" select="$attribute" />
			</xsl:apply-templates>
		</xsl:variable>
		<xsl:variable name="id">
			<xsl:apply-templates select="$ref" mode="xforms:id">
				<xsl:with-param name="attribute" select="$attribute" />
			</xsl:apply-templates>
		</xsl:variable>

		<div class="{@class} range">
			<xsl:apply-templates select="xforms:label">
				<xsl:with-param name="for" select="$id" />
			</xsl:apply-templates>
			<div id="{$id}-range">
				<div class="ui-slider-handle"></div>
			</div>
			<input id="{$id}" name="{$id}" type="text" value="{$ref}">
				<xsl:if test="$model/xforms:bind[starts-with($xpath, @nodeset) and @relevant='false()']">
					<xsl:attribute name="disabled">disabled</xsl:attribute>
				</xsl:if>
			</input>
			<p id="{$id}-value" class="hint"></p>
			<script type="text/javascript">
				var range = $('#<xsl:value-of select="$id" />-range');
				var input = $('#<xsl:value-of select="$id" />');
				var value = $('#<xsl:value-of select="$id" />-value');
				input.hide();
				var min = <xsl:value-of select="@start" />;
				var max = <xsl:value-of select="@end" />;
				var steps = (max - min) / <xsl:value-of select="@step" />;
				range.slider({
					steps: steps,
					min: min,
					max: max,
					change: function(event) {
						input.val(range.slider("value"));
						value.html(range.slider("value"));
					}
				});
				range.slider("moveTo", parseInt(input.val()));
			</script>
			<xsl:apply-templates select="xforms:hint" />
			<xsl:apply-templates select="xforms:alert" />
		</div>
	</xsl:template>

	<xsl:template match="xforms:secret">
		<xsl:param name="model" />
		<xsl:param name="ref" />
		<xsl:param name="attribute" />
		<xsl:variable name="xpath">
			<xsl:apply-templates select="$ref" mode="xforms:xpath">
				<xsl:with-param name="attribute" select="$attribute" />
			</xsl:apply-templates>
		</xsl:variable>
		<xsl:variable name="id">
			<xsl:apply-templates select="$ref" mode="xforms:id">
				<xsl:with-param name="attribute" select="$attribute" />
			</xsl:apply-templates>
		</xsl:variable>

		<div class="secret">
			<xsl:apply-templates select="xforms:label">
				<xsl:with-param name="for" select="$id" />
			</xsl:apply-templates>
			<input id="{$id}" name="{$id}" type="password" value="{$ref}">
				<xsl:if test="$model/xforms:bind[starts-with($xpath, @nodeset) and @relevant='false()']">
					<xsl:attribute name="disabled">disabled</xsl:attribute>
				</xsl:if>
			</input>
			<xsl:apply-templates select="xforms:hint" />
			<xsl:apply-templates select="xforms:alert" />
		</div>
	</xsl:template>

	<xsl:template match="xforms:textarea">
		<xsl:param name="model" />
		<xsl:param name="ref" />
		<xsl:param name="attribute" />
		<xsl:variable name="xpath">
			<xsl:apply-templates select="$ref" mode="xforms:xpath">
				<xsl:with-param name="attribute" select="$attribute" />
			</xsl:apply-templates>
		</xsl:variable>
		<xsl:variable name="id">
			<xsl:apply-templates select="$ref" mode="xforms:id">
				<xsl:with-param name="attribute" select="$attribute" />
			</xsl:apply-templates>

		</xsl:variable>

		<div class="textarea">
			<xsl:apply-templates select="xforms:label">
				<xsl:with-param name="for" select="$id" />
			</xsl:apply-templates>
			<textarea id="{$id}" name="{$id}">
				<xsl:if test="$model/xforms:bind[starts-with($xpath, @nodeset) and @relevant='false()']">
					<xsl:attribute name="disabled">disabled</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="$ref" />
			</textarea>
			<xsl:apply-templates select="xforms:hint" />
			<xsl:apply-templates select="xforms:alert" />
		</div>
	</xsl:template>

	<xsl:template match="xforms:choices">
		<xsl:param name="ref" />

		<optgroup>
			<xsl:apply-templates select="xforms:label | xforms:item">
				<xsl:with-param name="ref" select="$ref" />
			</xsl:apply-templates>
		</optgroup>
	</xsl:template>

	<xsl:template match="
		xforms:select1[@appearance = 'full'] |
		xforms:select[@appearance = 'full' or not(@appearance)]
	">
		<xsl:param name="model" />
		<xsl:param name="ref" />
		<xsl:param name="attribute" />
		<xsl:variable name="id">
			<xsl:apply-templates select="$ref" mode="xforms:id">
				<xsl:with-param name="attribute" select="$attribute" />
			</xsl:apply-templates>
		</xsl:variable>

		<dl class="{name()}">
			<xsl:apply-templates select="xforms:label" />
			<xsl:apply-templates select="xforms:item">
				<xsl:with-param name="model" select="$model" />
				<xsl:with-param name="ref" select="$ref" />
				<xsl:with-param name="attribute" select="$attribute" />
			</xsl:apply-templates>
		</dl>
	</xsl:template>

	<xsl:template match="
		xforms:select1[@appearance = 'full']/xforms:item |
		xforms:select[@appearance = 'full']/xforms:item
	">
		<xsl:param name="model" />
		<xsl:param name="ref" />
		<xsl:param name="attribute" />
		<xsl:variable name="xpath">
			<xsl:apply-templates select="$ref[1]" mode="xforms:xpath">
				<xsl:with-param name="attribute" select="$attribute" />
			</xsl:apply-templates>
		</xsl:variable>
		<xsl:variable name="id">
			<xsl:apply-templates select="$ref[1]" mode="xforms:id">
				<xsl:with-param name="attribute" select="$attribute" />
			</xsl:apply-templates>
		</xsl:variable>
		<xsl:variable name="value" select="xforms:value" />
		
		<dd class="item">
			<label>
				<input name="{$id}" value="{xforms:value}">
					<xsl:if test="$model/xforms:bind[starts-with($xpath, @nodeset) and @relevant='false()']">
						<xsl:attribute name="disabled">disabled</xsl:attribute>
					</xsl:if>
					<xsl:variable name="_values">
						<xsl:call-template name="str:split">
							<xsl:with-param name="string" select="$ref" />
							<xsl:with-param name="pattern" select="' '" />
						</xsl:call-template>
					</xsl:variable>
					<xsl:variable name="values" select="exslt:node-set($_values)/*" />
					<xsl:if test="$values[. = $value]">
						<xsl:attribute name="checked">checked</xsl:attribute>
					</xsl:if>
					<xsl:attribute name="type">
						<xsl:choose>
							<xsl:when test="parent::xforms:select1">radio</xsl:when>
							<xsl:when test="parent::xforms:select">checkbox</xsl:when>
						</xsl:choose>
					</xsl:attribute>
				</input>
				<xsl:value-of select="xforms:label" />
			</label>
			<xsl:apply-templates select="xforms:hint" />
		</dd>
	</xsl:template>

	<xsl:template match="
		xforms:select1[@appearance = 'minimal' or not(@appearance)]
	">
		<xsl:param name="model" />
		<xsl:param name="ref" />
		<xsl:param name="attribute" />
		<xsl:variable name="xpath">
			<xsl:apply-templates select="$ref" mode="xforms:xpath">
				<xsl:with-param name="attribute" select="$attribute" />
			</xsl:apply-templates>
		</xsl:variable>
		<xsl:variable name="id">
			<xsl:apply-templates select="$ref" mode="xforms:id">
				<xsl:with-param name="attribute" select="$attribute" />
			</xsl:apply-templates>
		</xsl:variable>

		<div class="select1">
			<xsl:apply-templates select="xforms:label">
				<xsl:with-param name="for" select="$id" />
			</xsl:apply-templates>
			<select id="{$id}" name="{$id}">
				<xsl:if test="$model/xforms:bind[starts-with($xpath, @nodeset) and @relevant='false()']">
					<xsl:attribute name="disabled">disabled</xsl:attribute>
				</xsl:if>
				<xsl:apply-templates select="xforms:item | xforms:choices">
					<xsl:with-param name="ref" select="$ref" />
				</xsl:apply-templates>
			</select>
			<xsl:apply-templates select="xforms:alert" />
		</div>
	</xsl:template>

	<xsl:template match="
		xforms:select1[@appearance = 'minimal' or not(@appearance)]//xforms:item
	">
		<xsl:param name="model" />
		<xsl:param name="ref" />
		<xsl:param name="attribute" />
		<xsl:variable name="xpath">
			<xsl:apply-templates select="$ref" mode="xforms:xpath">
				<xsl:with-param name="attribute" select="$attribute" />
			</xsl:apply-templates>
		</xsl:variable>

		<option value="{xforms:value}">
			<xsl:if test="$ref = xforms:value">
				<xsl:attribute name="selected">selected</xsl:attribute>
			</xsl:if>
			<xsl:value-of select="xforms:label" />
		</option>
	</xsl:template>

	<xsl:template match="xforms:upload">
		<xsl:param name="model" />
		<xsl:param name="ref" />
		<xsl:param name="attribute" />
		<xsl:variable name="xpath">
			<xsl:apply-templates select="$ref" mode="xforms:xpath">
				<xsl:with-param name="attribute" select="$attribute" />
			</xsl:apply-templates>
		</xsl:variable>
		<xsl:variable name="id">
			<xsl:apply-templates select="$ref" mode="xforms:id">
				<xsl:with-param name="attribute" select="$attribute" />
			</xsl:apply-templates>
		</xsl:variable>

		<div class="upload">
			<xsl:apply-templates select="xforms:label">
				<xsl:with-param name="for" select="$id" />
			</xsl:apply-templates>
			<input id="{$id}" name="{$id}" type="file" />
			<xsl:apply-templates select="xforms:hint" />
			<xsl:apply-templates select="xforms:alert" />
		</div>
	</xsl:template>

	<xsl:template match="xforms:submit">
		<input type="submit" value="{xforms:label}" />
	</xsl:template>
		

</xsl:stylesheet>
