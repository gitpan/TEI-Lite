<!-- ==================================================================== -->
<!-- TEILite XLST for HTML                                                -->
<!-- ==================================================================== -->
<xsl:stylesheet version="1.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >

<!-- Output Method -->
<xsl:output method="html" 
			indent="yes"
			omit-xml-declaration="yes"
            doctype-public="-//W3C//DTD HTML 4.0 Transitional//EN" />

<!-- Document Root -->
<xsl:template match="/">
	<html>
	<xsl:apply-templates/>
	</html>
</xsl:template>

<!-- ******************************************************************** -->
<!-- ****************  OUTPUT CONSTRUCTION FUNCTIONS  ******************* -->
<!-- ******************************************************************** -->

<xsl:template name="htmlTitle">
	<title>
	<xsl:choose>
		<xsl:when test="ancestor-or-self::TEI.2/text/front//docTitle">
			<xsl:value-of select="ancestor-or-self::TEI.2/text/front//docTitle"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="ancestor-or-self::TEI.2/teiHeader/fileDesc/titleStmt/title"/>
		</xsl:otherwise>
	</xsl:choose>
	</title>
</xsl:template>

<xsl:template name="htmlKeywords">
	<meta name="keywords" content="{ancestor-or-self::TEI.2/teiHeader/profileDesc/textClass/keywords}"/>
</xsl:template>


<!-- ******************************************************************** -->
<!-- ***************************  ELEMENTS ****************************** -->
<!-- ******************************************************************** -->

<xsl:template match="address">
 <blockquote>
     <xsl:apply-templates/>
 </blockquote>
</xsl:template>

<xsl:template match="addrLine">
     <xsl:apply-templates/><br/>
</xsl:template>

<xsl:template match="anchor">
   <a name="{@id}"/>
</xsl:template>

<xsl:template match="cell">
	<td><xsl:apply-templates/></td>
</xsl:template>

<xsl:template match="cit">
	<cite><xsl:apply-templates/></cite>
</xsl:template>

<xsl:template match="code">
	<code><xsl:apply-templates/></code>
</xsl:template>

<xsl:template match="div|div0|div1|div2|div3|div4|div5|div6|div7">
	<div><xsl:apply-templates/></div>
</xsl:template>

<xsl:template match="eg">
	<pre><xsl:apply-templates/></pre>
</xsl:template>

<xsl:template match="emph">
	<strong><xsl:apply-templates/></strong>
</xsl:template>

<xsl:template match="epigraph">
	<div class="epigraph"><xsl:apply-templates/></div>
</xsl:template>

<xsl:template match="gap">
	[...]<xsl:apply-templates/>
</xsl:template>

<xsl:template match="head">
	<h1><xsl:apply-templates/></h1>
</xsl:template>

<xsl:template match="hi">
	<strong><xsl:apply-templates/></strong>
</xsl:template>

<xsl:template match="ident">
	<strong><xsl:apply-templates/></strong>
</xsl:template>

<xsl:template match="item">
	<li><xsl:apply-templates/></li>
</xsl:template>

<xsl:template match="kw">
	<em><xsl:apply-templates/></em>
</xsl:template>

<xsl:template match="l">
	<xsl:apply-templates/><br/>
</xsl:template>

<xsl:template match="label">
	<xsl:apply-templates/>
</xsl:template>

<xsl:template match="lb">
	<br/>
</xsl:template>

<xsl:template match="lg">
	<xsl:apply-templates select="l"/>
</xsl:template>

<xsl:template match="list">
	<ul><xsl:apply-templates select="item"/></ul>
</xsl:template>

<xsl:template match="mentioned">
	<xsl:apply-templates/>
</xsl:template>

<xsl:template match="name">
	<xsl:apply-templates/>
</xsl:template>

<xsl:template match="p">
	<p><xsl:apply-templates/></p>
</xsl:template>

<xsl:template match="q">
	<quote><xsl:apply-templates/></quote>
</xsl:template>

<xsl:template match="row">
	<tr><xsl:apply-templates select="cell"/></tr>
</xsl:template>

<xsl:template match="table">
	<table><xsl:apply-templates select="row"/></table>
</xsl:template>

<xsl:template match="TEI.2">
	<xsl:apply-templates/>
</xsl:template>

<xsl:template match="teiCorpus">
	<xsl:apply-templates/>
</xsl:template>

<xsl:template match="teiHeader">
	<head>
	<xsl:call-template name="htmlTitle"/>
	<xsl:call-template name="htmlKeywords"/>
	</head>
</xsl:template>

<xsl:template match="term">
	<xsl:apply-templates/>
</xsl:template>

<xsl:template match="text">
	<body>
		<xsl:apply-templates/>
	</body>
</xsl:template>

</xsl:stylesheet>
