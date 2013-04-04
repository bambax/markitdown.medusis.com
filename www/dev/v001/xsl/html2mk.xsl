<?xml version="1.0" encoding="ISO-8859-1" ?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:saxon="http://saxon.sf.net/"

	xmlns:ixsl="http://saxonica.com/ns/interactiveXSLT"
	xmlns:js="http://saxonica.com/ns/globalJS"
	xmlns:prop="http://saxonica.com/ns/html-property"
	xmlns:style="http://saxonica.com/ns/html-style-property"

	exclude-result-prefixes="#all">


<xsl:variable name="line-break" select="'&#x000A;'"/>
<xsl:variable name="double-line-break" select="concat($line-break, $line-break)"/>
<xsl:variable name="force-line-break" select="concat('&#160;', $line-break)"/>

<xsl:template match="__nothing__" name="start">
	<!-- does nothing -->
	</xsl:template>

<xsl:template match="input[@name='convert_html2mk']" mode="ixsl:onclick">
	<xsl:variable name="p1">
		<xsl:for-each select="//div[@id='converter_source']">
			<xsl:apply-templates/>
			</xsl:for-each>
		</xsl:variable>

	<xsl:variable name="p2">
		<xsl:analyze-string regex="\n\n+" select="string-join($p1, '')">
			<xsl:matching-substring>
				<xsl:value-of select="$double-line-break"/>
				</xsl:matching-substring>
			<xsl:non-matching-substring>
				<xsl:value-of select="."/>
				</xsl:non-matching-substring>
			</xsl:analyze-string>
		</xsl:variable>

	<xsl:variable name="p3">
		<xsl:analyze-string regex="^\s+|\s+$" select="string-join($p2, '')">
			<xsl:matching-substring/>
			<xsl:non-matching-substring>
				<xsl:value-of select="."/>
				</xsl:non-matching-substring>
			</xsl:analyze-string>
		</xsl:variable>

	<xsl:result-document href="#converter_result" method="ixsl:replace-content">
		<xsl:sequence select="$p3"/>
		</xsl:result-document>
	</xsl:template>


<xsl:template match="*">
	<xsl:message>
		<xsl:text>Converter -- unknown elt: </xsl:text>
		<xsl:value-of select="name()"/>
		</xsl:message>
	<xsl:value-of select="$double-line-break"/>
	<xsl:apply-templates/>
	</xsl:template>

<!--
todo create emphasize elements cut at br
like this: <i>toto<br/>titi</i> => <i>toto</i><br/><i>titi</i>
-->
<xsl:template match="i/br|em/br|b/br|strong/br" priority="30">
	<xsl:text> </xsl:text>
	</xsl:template>

<xsl:template match="br" priority="20">
	<xsl:text>  </xsl:text>
	<xsl:value-of select="$line-break"/>
	</xsl:template>

<xsl:template match="hr" priority="20">
	<xsl:value-of select="concat($double-line-break, '* * *', $double-line-break)"/>
	</xsl:template>

<xsl:template match="object/embed" priority="21">
	<xsl:value-of select="@src"/>
	</xsl:template>

<xsl:template match="img" priority="20">
	<xsl:variable name="alt" select="if (string-length(@alt) &gt; 0) then @alt else 'Image'"/>
	<xsl:variable name="title" select="if (string-length(@title) &gt; 0) then concat(' &quot;', @title, '&quot;') else ''"/>
	<xsl:text>![</xsl:text>
	<xsl:value-of select="$alt"/>
	<xsl:text>]</xsl:text>
	<xsl:value-of select="concat('(', @src, ')', $title)"/>
	</xsl:template>

<xsl:template match="a[@name and not(@href)]" priority="20"/>
<xsl:template match="a" priority="20">
	<xsl:text>[</xsl:text>
	<xsl:apply-templates/>
	<xsl:text>]</xsl:text>
	<xsl:value-of select="concat('(', @href, ')')"/>
	</xsl:template>

<xsl:template match="*" priority="15">
	<xsl:choose>
		<xsl:when test="not(node()) or string-length(normalize-space(.)) = 0"/>
		<xsl:otherwise>
			<xsl:next-match/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

<xsl:template match="div|p|blockquote|h1|h2|h3|h4|h5|h6" priority="7">
	<xsl:choose>
		<xsl:when test="ancestor::a or ancestor::li">
			<xsl:apply-templates/>
			<xsl:text> </xsl:text>
			</xsl:when>
		<xsl:otherwise>
			<xsl:next-match/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

<xsl:template match="div|p|blockquote|h1|h2|h3|h4|h5|h6|object/embed" priority="5">
	<xsl:value-of select="$double-line-break"/>
	<xsl:next-match/>
	<xsl:value-of select="$double-line-break"/>
	</xsl:template>

<xsl:template match="div|p">
	<xsl:apply-templates/>
	</xsl:template>

<xsl:template match="ul|ol">
	<xsl:if test="not(ancestor::ul or ancestor::ol)">
		<xsl:value-of select="$double-line-break"/>
		</xsl:if>
	<xsl:apply-templates/>
	<xsl:value-of select="$line-break"/>
	</xsl:template>

<xsl:template match="blockquote/p|blockquote/div|blockquote/span|blockquote[not(*)]">
	<xsl:variable name="quoteAncestors" select="count(ancestor-or-self::blockquote) - 1"/>
	<xsl:variable name="result">
		<xsl:for-each select="0 to $quoteAncestors">_n_</xsl:for-each>
		</xsl:variable>
	<xsl:value-of select="replace($result, '_n_', '> ')"/>
	<xsl:apply-templates/>
	</xsl:template>

<xsl:template match="li" priority="10">
	<xsl:value-of select="$line-break"/>
	<xsl:variable name="listAncestors" select="count(ancestor::ul) + count(ancestor::ol)"/>
	<xsl:variable name="result">
		<xsl:for-each select="0 to $listAncestors - 2">_n_</xsl:for-each>
		</xsl:variable>
	<xsl:value-of select="replace($result, '_n_', '    ')"/>
	<xsl:next-match/>
	</xsl:template>
<xsl:template match="ul/li">
	<xsl:text>- </xsl:text>
	<xsl:apply-templates/>
	</xsl:template>
<xsl:template match="ol/li">
	<xsl:value-of select="concat(count(preceding-sibling::li) + 1, '. ')"/>
	<xsl:apply-templates/>
	</xsl:template>

<xsl:template match="span">
	<xsl:apply-templates/>
	</xsl:template>

<xsl:template match="form|button|fieldset|legend|input|label|select|optgroup|option|textarea">
	<xsl:apply-templates/>
	</xsl:template>
<xsl:template match="table|thead|tbody|tfoot|th|td">
	<xsl:apply-templates/>
	</xsl:template>
<xsl:template match="tr">
	<xsl:value-of select="$double-line-break"/>
	<xsl:apply-templates/>
	</xsl:template>
<xsl:template match="td">
	<xsl:text> </xsl:text>
	<xsl:apply-templates/>
	</xsl:template>
<xsl:template match="object|font|blockquote">
	<xsl:apply-templates/>
	</xsl:template>

<xsl:template match="b|strong">
	<xsl:text>**</xsl:text>
	<xsl:apply-templates/>
	<xsl:text>**</xsl:text>
	</xsl:template>

<xsl:template match="i|em">
	<xsl:text>_</xsl:text>
	<xsl:apply-templates/>
	<xsl:text>_</xsl:text>
	</xsl:template>

<xsl:template match="h1|h2|h3|h4|h5|h6">
	<xsl:choose>
		<xsl:when test="not(ancestor::a or ancestor::li)">
			<xsl:variable name="level" select="xs:integer(substring(local-name(), 2,1))"/>
			<xsl:variable name="prefix">
				<xsl:for-each select="0 to $level">#</xsl:for-each>
				<xsl:text> </xsl:text>
				</xsl:variable>
			<xsl:value-of select="$prefix"/>
			<xsl:apply-templates/>
			</xsl:when>
		<xsl:otherwise>
			<xsl:text>**</xsl:text>
			<xsl:apply-templates/>
			<xsl:text>**</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

<xsl:template match="text()">
	<xsl:variable name="text" select="."/>
	<xsl:analyze-string regex="^\s+$" select="string-join($text, '')" flags="m">
		<xsl:matching-substring/>
		<xsl:non-matching-substring>
			<xsl:value-of select="replace(replace($text, '&gt;', '&amp;gt;'), '&lt;', '&amp;lt;')"/>
			</xsl:non-matching-substring>
		</xsl:analyze-string>
	</xsl:template>



</xsl:stylesheet>