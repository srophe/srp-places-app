<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
 xmlns:xs="http://www.w3.org/2001/XMLSchema"
 xmlns:t="http://www.tei-c.org/ns/1.0" 
 xmlns:s="http://syriaca.org"
 xmlns:saxon="http://saxon.sf.net/" 
 xmlns="http://www.w3.org/1999/xhtml"
 exclude-result-prefixes="xs t s" version="2.0">

 <!-- =================================================================== -->
 <!-- import component stylesheets for HTML page portions -->
 <!-- =================================================================== -->

 <xsl:import href="boilerplate-head.xsl"/>
 <xsl:import href="boilerplate-bottom.xsl"/>
 <xsl:import href="boilerplate-badbrowser.xsl"/>
 <xsl:import href="boilerplate-nav.xsl"/>
 <xsl:import href="boilerplate-footer.xsl"/>


 <!-- =================================================================== -->
 <!-- set output so we get (mostly) indented HTML -->
 <!-- =================================================================== -->

 <xsl:output name="html" encoding="UTF-8" method="html" indent="yes"/>


 <!-- =================================================================== -->
 <!-- initialize top-level variables and transform parameters -->
 <!--  sourcedir: where to look for XML files to summarize/link to -->
 <!--  description: a meta description for the HTML page we will output -->
 <!--  name-app: name of the application (for use in head/title) -->
 <!--  name-page-short: short name of the page (for use in head/title) -->
 <!--  colquery: constructed variable with query for collection fn. -->
 <!-- =================================================================== -->

 <xsl:param name="sourcedir">../../places/xml/</xsl:param>
 <xsl:param name="destdir">../places/</xsl:param>
 <xsl:param name="name-app">The Syriac Gazetteer</xsl:param>
 <xsl:param name="copyright-holders">CHANGE THE COPYRIGHT HOLDERS PARAMETER</xsl:param>
 <xsl:param name="copyright-year">2013</xsl:param>
 <xsl:param name="xmlbase">https://github.com/srophe/places/blob/master/xml/</xsl:param>
 <xsl:param name="uribase">http://syriaca.org/place/</xsl:param>
 <xsl:param name="normalization">NFKC</xsl:param>
 <xsl:variable name="colquery"><xsl:value-of select="$sourcedir"/>?select=*.xml</xsl:variable>


 <!-- =================================================================== -->
 <!-- TEMPLATES -->
 <!-- =================================================================== -->


 <!-- ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| -->
 <!-- |||| do-places: creates all individual place pages -->
 <!-- ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| -->

 <xsl:template name="do-places">
  
  <!-- loop through all page XML and write a corresponding HTML page -->
  <xsl:for-each select="collection($colquery)">
   
   <!-- determine descriptions and page names -->
   <xsl:variable name="headword-ele" as="element()*">
    <xsl:call-template name="get-headword-ele"/>
   </xsl:variable>
   <xsl:variable name="headword">
    <xsl:apply-templates select="$headword-ele[1]" mode="out-normal"/>
   </xsl:variable>
   <xsl:variable name="headword-lang" select="$headword-ele[1]/ancestor-or-self::*[@xml:lang][1]/@xml:lang"/>
   <xsl:variable name="description-ele" as="element()*">
    <xsl:call-template name="get-description-ele"/>
   </xsl:variable>
   <xsl:variable name="description">
    <xsl:apply-templates select="$description-ele[1]" mode="out-normal"/>
   </xsl:variable>
   <xsl:variable name="name-page-short" select="$headword"/>
   <xsl:variable name="description-page" select="$description"/>
   <xsl:variable name="name-page-long" select="$headword"/>
   <xsl:variable name="placenum" select="normalize-space(substring-after(./descendant-or-self::t:listPlace/t:place[1]/@xml:id, 'place-'))"/>
   <xsl:choose>
    
    <!-- make sure we have a valid placeid -->
    <xsl:when test="matches($placenum, '^\d+$')">
     
     <!-- determine what the output filename will be -->
     <xsl:variable name="outfilename">
      <xsl:value-of select="$placenum"/>
      <xsl:text>.html</xsl:text>
     </xsl:variable>
     
     <!-- open a new output document for reading -->
     <xsl:result-document format="html" href="{$destdir}{$outfilename}">
      
      <!-- write the opening of the HTML page -->
      <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html></xsl:text>
      <xsl:comment>[if lt IE 7]>      &lt;html class="no-js lt-ie9 lt-ie8 lt-ie7"> &lt;![endif]</xsl:comment>
      <xsl:comment>[if IE 7]>         &lt;html class="no-js lt-ie9 lt-ie8"> &lt;![endif]</xsl:comment>
      <xsl:comment>[if IE 8]>         &lt;html class="no-js lt-ie9"> &lt;![endif]</xsl:comment>
      <xsl:comment>[if gt IE 8]></xsl:comment>
      <html class="no-js">
       <xsl:comment>&lt;![endif]</xsl:comment>
    
       <!-- write the page head element and its contents -->
       <xsl:call-template name="boilerplate-head">
        <xsl:with-param name="description" select="$description"/>
        <xsl:with-param name="name-app" select="$name-app"/>
        <xsl:with-param name="name-page-short" select="$name-page-short"/>
        <xsl:with-param name="basepath">..</xsl:with-param>
       </xsl:call-template>
    
       <!-- write the body element and its contents -->
       <body>
        
        <!-- add an upgrade urging for users of old IE versions -->
        <xsl:call-template name="boilerplate-badbrowser"/>
        
        <xsl:call-template name="boilerplate-nav">
         <xsl:with-param name="active">browse</xsl:with-param>
         <xsl:with-param name="app-name" select="$name-app"/>
         <xsl:with-param name="basepath">..</xsl:with-param>
        </xsl:call-template>
        
        <!-- ADD: breadcrumbs -->
        <xsl:message>WARNING: TEMPLATE NEEDS TO HAVE BREADCRUMBS CODE ADDED</xsl:message>
        <p>BREADCRUMBS HERE</p>
        
        <!-- create the main content portion of the page -->
        <div class="container-fluid">
         <div class="row-fluid">
          <div class="span7">
           <h2>
            <i><xsl:value-of select="$name-app"/>:</i>
            <xsl:text> </xsl:text>
            <xsl:value-of select="$name-page-long"/>
           </h2>
           <p><xsl:value-of select="$description-page"/></p>
    
           <!-- ADD: page content here -->
           <p>PAGE CONTENT HERE</p>
           
          </div>
         </div>
         
         <!-- write the standard page footer -->
         <xsl:call-template name="boilerplate-footer">
          <xsl:with-param name="copyright-year" select="$copyright-year"/>
          <xsl:with-param name="copyright-holders" select="$copyright-holders"/>
         </xsl:call-template>
         
        </div>
    
        <!-- write scripts etc. that belong at the bottom of the body -->
        <xsl:call-template name="boilerplate-bottom"/> 
       </body>
      </html>
     </xsl:result-document>
     
    </xsl:when>
    <xsl:otherwise>
     <xsl:message>WARNING: placepage.xsl didn't find proper place id in file <xsl:value-of select="document-uri(.)"/></xsl:message>
    </xsl:otherwise>
   </xsl:choose>
   
  </xsl:for-each>
 </xsl:template>

 <!-- ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| -->
 <!-- |||| match=t:*: suppress all TEI elements not otherwise handled -->
 <!-- ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| -->
 
 <xsl:template match="t:*"/>
 
 <xsl:template name="get-headword-ele" as="element()*">
  <xsl:choose>
   <xsl:when test="./descendant-or-self::t:listPlace/t:place/t:placeName[@syriaca-tags='#syriaca-headword']">
    <xsl:sequence select="./descendant-or-self::t:listPlace/t:place/t:placeName[@syriaca-tags='#syriaca-headword']"/>
   </xsl:when>
   <xsl:otherwise>
    <xsl:message>WARNING: placepage.xsl unable to find placeName tagged with '#syriaca-headword' in <xsl:value-of select="document-uri(.)"/></xsl:message>
    <xsl:sequence select="./descendant-or-self::t:listPlace/t:place/t:placeName[1]"/>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>
 
 <xsl:template name="get-description-ele" as="element()*">
  <xsl:choose>
   <xsl:when test="./descendant-or-self::t:listPlace/t:place/t:desc[starts-with(@xml:id, 'abstract-en')]">
    <xsl:sequence select="./descendant-or-self::t:listPlace/t:place/t:desc[starts-with(@xml:id, 'abstract-en')]"/>
   </xsl:when>
   <xsl:otherwise>
    <xsl:message>WARNING: placepage.xsl unable to find desc with id that starts with 'abstract-en' in <xsl:value-of select="document-uri(.)"/></xsl:message>
    <xsl:sequence select="./descendant-or-self::t:listPlace/t:place/t:desc[1]"/>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>
 
 <xsl:template match="t:*" mode="out-normal">
  <xsl:value-of select="normalize-space(normalize-unicode(., $normalization))"/>
 </xsl:template>
 
</xsl:stylesheet>