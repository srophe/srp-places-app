<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:t="http://www.tei-c.org/ns/1.0"
  xmlns="http://www.tei-c.org/ns/1.0"
  exclude-result-prefixes="xs t"
  version="2.0">
  
  <!-- ================================================================== 
       Copyright 2013 New York University
       
       This file is part of the Syriac Reference Portal Places Application.
       
       The Syriac Reference Portal Places Application is free software: 
       you can redistribute it and/or modify it under the terms of the GNU 
       General Public License as published by the Free Software Foundation, 
       either version 3 of the License, or (at your option) any later 
       version.
       
       The Syriac Reference Portal Places Application is distributed in 
       the hope that it will be useful, but WITHOUT ANY WARRANTY; without 
       even the implied warranty of MERCHANTABILITY or FITNESS FOR A 
       PARTICULAR PURPOSE.  See the GNU General Public License for more 
       details.
       
       You should have received a copy of the GNU General Public License
       along with the Syriac Reference Portal Places Application.  If not,
       see (http://www.gnu.org/licenses/).
       
       ================================================================== --> 
  
  <!-- ================================================================== 
       bibliography.xsl
       
       This XSLT provides templates for output of bibliographic material. 
       
       parameters:
       
       assumptions and dependencies:
        + transform has been tested with Saxon PE 9.4.0.6 with initial
          template (-it) option set to "do-index" (i.e., there is no 
          single input file)
        
       code by: 
        + Tom Elliott (http://www.paregorios.org) 
          for the Institute for the Study of the Ancient World, New York
          University, under contract to Vanderbilt University for the
          NEH-funded Syriac Reference Portal project.
          
       funding provided by:
        + National Endowment for the Humanities (http://www.neh.gov). Any 
          views, findings, conclusions, or recommendations expressed in 
          this code do not necessarily reflect those of the National 
          Endowment for the Humanities.
       
       ================================================================== -->
  
  
  <xsl:template match="t:bibl" mode="footnote">
    <xsl:param name="footnote-number">-1</xsl:param>
    <xsl:variable name="thisnum">
      <xsl:choose>
        <xsl:when test="$footnote-number='-1'">
          <xsl:value-of select="substring-after(@xml:id, '-')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$footnote-number"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <li xml:id="{@xml:id}">
      <span class="footnote-tgt"><xsl:value-of select="$thisnum"/></span>
      <span class="footnote-content">
        <!-- if the reference points at a master bibliographic record file, use it; otherwise, do 
     what you can with the contents of the present element -->
        <xsl:choose>
          <xsl:when test="t:ptr[@target and starts-with(@target, 'http://syriaca.org/bibl/')]">
            <xsl:variable name="biblfilepath">
              <xsl:value-of select="$biblsourcedir"/>
              <xsl:value-of select="substring-after(t:ptr/@target, 'http://syriaca.org/bibl/')"/>
              <xsl:text>.xml</xsl:text>
            </xsl:variable>
            <xsl:choose>
              <xsl:when test="doc-available($biblfilepath)">
                <xsl:apply-templates select="document($biblfilepath)/descendant::t:biblStruct[1]" mode="footnote"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="log">
                  <xsl:with-param name="msg">could not find referenced bibl document <xsl:value-of select="$biblfilepath"/></xsl:with-param>
                </xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates select="t:citedRange" mode="footnote"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates mode="footnote"/>
          </xsl:otherwise>
        </xsl:choose>
      </span>
    </li>
  </xsl:template>
  
  <xsl:template match="t:biblStruct[t:monogr and not(t:analytic)]" mode="footnote">
    <!-- this is a monograph/book -->
    <xsl:message>book</xsl:message>
  </xsl:template>
  
  
  <xsl:template match="t:author[ancestor::t:bibl or ancestor::t:biblStruct]" mode="footnote">
    <span class="author"><xsl:apply-templates select="." mode="out-normal"/></span>
    <xsl:text>. </xsl:text>
  </xsl:template>
  
  <xsl:template match="t:editor[ancestor::t:bibl or ancestor::t:biblStruct]" mode="footnote">
    <span class="editor"><xsl:apply-templates select="." mode="out-normal"/></span>
    <xsl:text>. </xsl:text>
  </xsl:template>
  
  <xsl:template match="t:title[ancestor::t:bibl or ancestor::t:biblStruct]" mode="footnote">
    <span class="title">
      <xsl:call-template name="langattr"/>
      <xsl:apply-templates select="." mode="out-normal"/>
      <xsl:text>. </xsl:text>
    </span>
  </xsl:template>
  
  <xsl:template match="t:citedRange[ancestor::t:bibl or ancestor::t:biblStruct]" mode="footnote">
    <xsl:choose>
      <xsl:when test="@unit='pp' and contains(., '-')">
        <xsl:text>pp. </xsl:text>
      </xsl:when>
      <xsl:when test="@unit='pp' and not(contains(., '-'))">
        <xsl:text>p. </xsl:text>
      </xsl:when>
    </xsl:choose>
    <xsl:apply-templates select="." mode="out-normal"/>
    <xsl:text>.</xsl:text>
  </xsl:template>
  
  <xsl:template match="t:*[ancestor::t:bibl or ancestor::t:biblStruct]" mode="footnote">
    <xsl:call-template name="log">
      <xsl:with-param name="msg">element suppressed in mode footnote</xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template match="t:bibl" mode="footnote-ref">
    <xsl:param name="footnote-number">1</xsl:param>
    <span class="footnote-ref">
      <a href="#{@xml:id}"><xsl:value-of select="$footnote-number"/></a>
    </span>
  </xsl:template>
  
</xsl:stylesheet>