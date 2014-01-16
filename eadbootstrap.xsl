<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:ead="urn:isbn:1-931666-22-9" exclude-result-prefixes="xs xsl xd xlink ead" version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Oct 7, 2013</xd:p>
            <xd:p><xd:b>Author:</xd:b> Mark Custer</xd:p>
            <xd:ul>
                <xd:li>Table of contents:</xd:li>
                <xd:li>1: Framework</xd:li>
                <xd:li>2: Called templates (for rest of framework)</xd:li>
                <xd:li>3: EAD elements to HTML</xd:li>
                <xd:li>4: DSC container list templates</xd:li>
                <xd:li>5: Global variables / parameters</xd:li>
            </xd:ul>
        </xd:desc>
    </xd:doc>

    <!-- to output HTML 5 with Saxon, generally all that you need to do is set the method="html" and the version="5.0".
        the processor will then set the doctype automatically-->
    <xsl:output method="html" indent="no" encoding="UTF-8" omit-xml-declaration="yes"/>
    
    <xsl:strip-space elements="*"/>

    <!--
        1: Framework
     -->
    <xsl:template match="ead:ead">
        <!--the next two lines of code are an alternative way to output the HTML doctype declaration if your XSLT processor does not yet support HTML 5.  
            Though both Saxon and BaseX support outputting HTML 5, I ran into a bug when trying to use the two together (hence the next two lines of code)-->
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html></xsl:text>
        <xsl:value-of select="$newline"/>
        <html lang="en">
            <head>
                <meta http-equiv="X-UA-Compatible" content="IE=edge"/> 
                <title>
                    <xsl:value-of select="$collectionTitle-as-text"/>
                </title>
                <xsl:call-template name="metatags"/>
                <xsl:call-template name="css"/>
                <xsl:if test="$includeAnalytics eq true()">
                    <xsl:call-template name="analytics"/>
                </xsl:if>
            </head>
            <!-- note that schema.org metadata is not used anywhere else, but this is a start (itemscope and itemtype) -->
            <body id="top" itemscope="itemscope" itemtype="http://schema.org/CollectionPage">
                <a class="sr-only" href="#content">Skip navigation</a>
                <xsl:call-template name="header"/>
                <xsl:call-template name="page-content"/>
                <xsl:call-template name="footer"/>
                <xsl:call-template name="javascript"/>
            </body>
        </html>
    </xsl:template>
     
    <!--
        2: Called templates (for rest of framework)
     -->
    <xsl:template name="metatags">
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <meta name="dc.title" content="{$collectionTitle-as-text}"/>
        <meta name="dc.description"
            content="{ead:archdesc/ead:did/ead:abstract[1]/normalize-space()}"/>
        <meta name="dc.publisher"
            content="{ead:eadheader/ead:filedesc/ead:publicationstmt/ead:publisher[1]/normalize-space()}"/>
        <meta name="robots" content="index, follow"/>
    </xsl:template>
    
    <xsl:template name="css">
        <!-- when ready for production, change to minified versions-->
        <link href="static/bootstrap/css/bootstrap.css" rel="stylesheet"/>
        <link href="static/local/css/docs.css" rel="stylesheet"/>
        <link href="static/style.css" rel="stylesheet"/>
        <xsl:comment>HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries</xsl:comment>
        <xsl:text disable-output-escaping="yes">
               &lt;!--[if lt IE 9]>
             &lt;script src="./static/dependencies/js/html5shiv.js">&lt;/script>
             &lt;script src="./static/dependencies/js/respond-min.js">&lt;/script>
    &lt;![endif]--></xsl:text>
    </xsl:template>
       
    <xsl:template name="analytics">
        <script>
            (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
            (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
            m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
            })(window,document,'script','//www.google-analytics.com/analytics.js','ga');
            
            ga('create', 'UA-7847108-13', 'nyam.org');
            ga('send', 'pageview');
            
        </script>
        <!--<script type="text/javascript">
            var _gaq = _gaq || [];
            _gaq.push(['_setAccount', 'UA-7847108-13']);
            _gaq.push(['_trackPageview']);     
            (function() {
            var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
            ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
            var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
            })();
        </script>-->
    </xsl:template>
    
    <xsl:template name="header">
        <header class="navbar navbar-default navbar-static-top" role="banner">
            <div class="container">
                <div class="navbar-header">
                    <button type="button" class="navbar-toggle" data-toggle="collapse"
                        data-target=".navbar-collapse">
                        <span class="icon-bar"/>
                        <span class="icon-bar"/>
                        <span class="icon-bar"/>
                    </button>
                    <!--<a class="navbar-brand" href="http://www.nyam.org/library/collections-and-resources/archives/"> Finding Aids Portal </a>-->
                    <a href="http://www.nyam.org/library/collections-and-resources/archives/"> <span class="glyphicon glyphicon-home"></span> Return to manuscripts and archives </a>
                </div>
                <div class="collapse navbar-collapse">
                    <!--<ul class="nav navbar-nav">
                        <li>
                            <a href="#about">About</a>
                        </li>
                        <li class="active">
                            <a href="#">Collections</a>
                        </li>
                        <li class="dropdown">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown">Dropdown <b
                                    class="caret"/></a>
                            <ul class="dropdown-menu">
                                <li>
                                    <a href="#">Action</a>
                                </li>
                                <li>
                                    <a href="#">Another action</a>
                                </li>
                                <li>
                                    <a href="#">Something else here</a>
                                </li>
                                <li class="divider"/>
                                <li class="dropdown-header">Nav header</li>
                                <li>
                                    <a href="#">Separated link</a>
                                </li>
                                <li>
                                    <a href="#">One more separated link</a>
                                </li>
                            </ul>
                        </li>
                    </ul>-->
                </div>
                <xsl:comment>/ .nav-collapse</xsl:comment>
            </div>
            <xsl:comment>/ header .container </xsl:comment>
        </header>
    </xsl:template>

    <xsl:template name="page-content">
        <xsl:comment> Begin page content </xsl:comment>
        <div class="container">
            
            <div class="page-header container">
                <div class="row">
                    <div class="col-md-3">
                        <img class="logo" src="ar-nyambug.png"/>
                    </div>
                    <div class="col-md-9">
                         <h1>
                             <xsl:apply-templates select="ead:eadheader/ead:filedesc/ead:titlestmt/ead:titleproper"/>
                             <xsl:if test="ead:eadheader/ead:filedesc/ead:titlestmt/ead:subtitle">
                                 <!--<xsl:text>: </xsl:text>-->
                                 <xsl:apply-templates select="ead:eadheader/ead:filedesc/ead:titlestmt/ead:subtitle"/>
                             </xsl:if>
                         </h1>
                    </div>
                </div>
            </div>
            <div class="container">
                <div class="row"> 
                    <!--<span class="author">
                        <xsl:apply-templates select="ead:eadheader/ead:filedesc/ead:titlestmt/ead:author"/>
                    </span>-->
                </div>  
            </div>
           
            <div class="container bs-docs-container">
                <div class="row">
                    <xsl:call-template name="toc"/>
                    <xsl:call-template name="archdesc"/>
                </div>
                <xsl:comment> /.row </xsl:comment>
            </div>
            <xsl:comment> / .container .bs-docs </xsl:comment>
        </div>
        <xsl:comment> / page-content .container (minus header and footer) </xsl:comment>
    </xsl:template>

    <xsl:template name="toc">
        <xsl:comment> Table of contents navigation </xsl:comment>
        <div class="col-md-3">
            <nav class="bs-sidebar hidden-print" role="navigation">
                <ul class="nav bs-sidenav">
                    <li>
                        <h4>
                            <xsl:apply-templates
                                select="ead:archdesc/ead:did/ead:unittitle/*[not(self::ead:unitdate)] | 
                                ead:archdesc/ead:did/ead:unittitle/text()"
                            />
                        </h4>
                    </li>
                    <li class="active"> <!-- Start overview on active by default -->
                        <a href="#overview">Collection Summary</a>
                    </li>
                    <xsl:if test="$includeBioghistSection eq true()">
                        <li>
                            <a href="#bioghist">
                                <xsl:value-of select="$bioghist-title"/>
                            </a>
                        </li>
                    </xsl:if>
                    <xsl:if test="$includeDescriptionSection eq true()">
                        <li>
                            <a href="#desc">Collection Description</a>
                        </li>
                    </xsl:if>
                    <xsl:if test="$includeUsingThisCollectionSection eq true()">
                        <li>
                            <a href="#use">Administrative Info</a>
                        </li>
                    </xsl:if>
                    <xsl:if test="$includesDSC eq true()">
                        <li>
                            <a href="#dsc">Collection Contents</a>
                            <!--the following template just pulls series and suberies at the c01-c03 level-->
                            <xsl:call-template name="toc-series"/>
                        </li>
                    </xsl:if>
                    <xsl:if test="$includeFindSimilarSection eq true()">
                        <li>
                            <a href="#find">Find Similar Resources</a>
                        </li>
                    </xsl:if>
                    <li>
                        <xsl:call-template name="returntotop"/>
                    </li>
                </ul>
            </nav>
        </div>
    </xsl:template>

    <xsl:template name="toc-series">
        <ul class="nav">
            <xsl:apply-templates
                select="ead:archdesc/ead:dsc/ead:c01[@level='series'] | ead:archdesc/ead:dsc/ead:c[@level='series'] |
                *[@level='subseries']"
                mode="toc"/>
        </ul>
    </xsl:template>

    <xsl:template match="ead:c | ead:c01 | ead:c02 | ead:c03" mode="toc">
        <li>
            <a>
                <xsl:attribute name="href">
                    <xsl:value-of
                        select=" if ($locationOfIDs = 'c') then concat('#', @id) else concat('#', translate(translate(translate(translate(translate(ead:did/ead:unittitle, ' ', '_'), &quot;,.&apos;&quot;, ''), '(', ''), ')', ''), '/', ''))"
                    />
                </xsl:attribute>
                <xsl:apply-templates select="ead:did/ead:unittitle"/>
            </a>
            <xsl:if
                test="ead:c03[@level='subseries']|ead:c02[@level='subseries']|ead:c[@level='subseries']">
                <xsl:call-template name="toc-series"/>
            </xsl:if>
        </li>
    </xsl:template>
    
    <xsl:template name="archdesc">
        <xsl:comment> main body of page </xsl:comment>
        <div class="col-md-9" role="main">
            <div class="bs-docs-section">
                <div class="page-header overview">
                    <h2 id="overview">Collection Summary</h2>
                    <div class="row">
                        <div class="col-md-9">
                            <dl class="dl-horizontal">
                                <dt>Title</dt>
                                <dd>
                                    <xsl:apply-templates
                                        select="ead:archdesc/ead:did/ead:unittitle/*[not(self::ead:unitdate)] | ead:archdesc/ead:did/ead:unittitle/text()"/>
                                </dd>
                                <dt>Date Span</dt>
                                <dd>
                                    <xsl:apply-templates select="ead:archdesc/ead:did//ead:unitdate"/>
                                </dd>
                                <xsl:if test="ead:archdesc/ead:did/ead:unitid">
                                    <dt>Call Number</dt>
                                    <dd>
                                        <xsl:apply-templates select="ead:archdesc/ead:did/ead:unitid"/>
                                    </dd>
                                </xsl:if>
                                <xsl:if test="ead:archdesc/ead:did/ead:origination">
                                    <dt>
                                        <xsl:value-of
                                            select="if (count(ead:archdesc/ead:did/ead:origination) eq 1) then 'Creator' else 'Creators'"/>
                                    </dt>
                                    <dd>
                                        <xsl:apply-templates select="ead:archdesc/ead:did/ead:origination"/>
                                    </dd>
                                </xsl:if>
                                <xsl:if test="ead:archdesc/ead:did/ead:abstract"> <!--NYAM MOD - sometimes theres no summary -->
                                <dt>Summary</dt>
                                <dd>
                                    <xsl:apply-templates select="ead:archdesc/ead:did/ead:abstract"/>
                                </dd>
                                </xsl:if>
                                
                                <xsl:if test="ead:archdesc/ead:did/ead:physdesc"> <!--NYAM MOD - if no physical description -->
                                <dt>Collection Size</dt>
                                <dd>
                                    <xsl:apply-templates select="ead:archdesc/ead:did/ead:physdesc"/>
                                </dd>
                                </xsl:if>
                                <xsl:if test="ead:archdesc/ead:did/ead:langmaterial"> <!--NYAM MOD - sometimes theres no language -->
                                <dt>Language</dt> 
                                <dd>
                                    <xsl:apply-templates select="ead:archdesc/ead:did/ead:langmaterial"/>
                                </dd>
                                </xsl:if>
                            </dl>
                        </div>
                        <div class="col-md-3">
                            <address>
                                   <strong>Repository</strong>
                                   <div>
                                   <xsl:apply-templates select="ead:archdesc[1]/ead:did[1]/ead:repository"/>
                                   </div>
                            </address>
                            <xsl:if test="/ead:ead/ead:eadheader[1]/ead:filedesc[1]/ead:notestmt[1]/ead:note/ead:p[1][starts-with(., 'Contact')]">
                                <a href="{/ead:ead/ead:eadheader[1]/ead:filedesc[1]/ead:notestmt[1]/ead:note/ead:p[1][starts-with(., 'Contact')]/ead:extref[1]/@xlink:href}"
                                    class="btn btn-default">
                                    Contact Us
                                </a>
                            </xsl:if>
                        </div>
                    </div>

                    
                    <!--this should be accounted for in the CSS.  for now, I'm just adding an HTML break-->
                    <!--<br/>-->
                    <!-- NYAM MOD - move this to admin section-->
                    <!--<xsl:apply-templates select="/ead:ead/ead:eadheader[1]/ead:filedesc[1]/ead:titlestmt[1]/ead:sponsor[1]"/>-->
                    <!--<xsl:apply-templates select="ead:archdesc/ead:did/ead:note"/>-->
                    <!--<xsl:apply-templates select="ead:archdesc/ead:acqinfo | /ead:ead/ead:archdesc/ead:descgrp/ead:acqinfo "/>-->
                    <!-- to make this next apply-templates useful, we'd need to add a template for materialspec that pulls out the @label attribute-->
                    <!--<xsl:apply-templates select="ead:archdesc/ead:did/ead:materialspec"/>-->
                    <!--<xsl:apply-templates select="ead:archdesc/ead:phystech"/>-->
                </div>
                <xsl:comment>  / .page-header  </xsl:comment>
            </div>
            <xsl:comment>  /overview  </xsl:comment>

            <xsl:if test="$includeBioghistSection eq true()">
                <div class="bs-docs-section">
                    <h2 id="bioghist">
                        <xsl:value-of select="$bioghist-title"/>
                    </h2>
                    <xsl:apply-templates select="ead:archdesc/ead:bioghist"/>
                </div>
                <xsl:comment>  /bioghist  </xsl:comment>
            </xsl:if>

            <xsl:if test="$includeDescriptionSection eq true()">
                <div class="bs-docs-section">
                    <h2 id="desc">Collection Description</h2>
                    <!--rearrange the order, if desired-->
                    <xsl:apply-templates select="ead:archdesc/ead:scopecontent"/>
                    <xsl:apply-templates select="ead:archdesc/ead:arrangement | ead:archdesc/ead:descgrp/ead:arrangement"/>
                    <xsl:apply-templates select="ead:archdesc/ead:processinfo | ead:archdesc/ead:descgrp/ead:processinfo"/>
                    <xsl:apply-templates select="ead:archdesc/ead:custodhist"/>
                    <xsl:apply-templates select="ead:archdesc/ead:accruals | ead:archdesc/ead:descgrp/ead:accruals"/>
                    <xsl:apply-templates select="ead:archdesc/ead:appraisal"/>
                    <xsl:apply-templates select="ead:archdesc/ead:bibliography"/>
                    <xsl:apply-templates select="ead:archdesc/ead:fileplan"/>
                    <xsl:apply-templates select="ead:archdesc/ead:separatedmaterial | ead:archdesc/ead:descgrp/ead:separatedmaterial"/>
                    <xsl:apply-templates select="ead:archdesc/ead:index"/>
                    <xsl:apply-templates select="ead:archdesc/ead:odd"/>
                </div>
                <xsl:comment>  /scopecontent  </xsl:comment>
            </xsl:if>

            <xsl:if test="$includeUsingThisCollectionSection eq true()">
                <div class="bs-docs-section">
                    <h2 id="use">Administrative Info</h2>
                    <xsl:apply-templates select="ead:eadheader/ead:filedesc/ead:titlestmt/ead:author"/><br/>
                    <xsl:apply-templates select="ead:archdesc/ead:accessrestrict | ead:archdesc/ead:descgrp/ead:accessrestrict"/>
                    <xsl:apply-templates select="ead:archdesc/ead:userestrict | ead:archdesc/ead:descgrp/ead:userestrict"/>
                    <xsl:apply-templates select="ead:archdesc/ead:prefercite  | ead:archdesc/ead:descgrp/ead:prefercite"/>
                    <xsl:apply-templates select="ead:archdesc/ead:did/ead:physloc | ead:archdesc/ead:descgrp/ead:physloc"/>
                    <xsl:apply-templates select="ead:archdesc/ead:originalsloc | ead:archdesc/ead:descgrp/ead:originalsloc"/>
                    <xsl:apply-templates select="ead:archdesc/ead:altformavail | ead:archdesc/ead:descgrp/ead:altformavail"/>
                    <xsl:apply-templates select="/ead:ead/ead:eadheader[1]/ead:filedesc[1]/ead:titlestmt[1]/ead:sponsor[1]"/>
                    <xsl:apply-templates select="ead:archdesc/ead:did/ead:note"/>
                    <xsl:apply-templates select="ead:archdesc/ead:acqinfo | /ead:ead/ead:archdesc/ead:descgrp/ead:acqinfo "/>
                    <!-- to make this next apply-templates useful, we'd need to add a template for materialspec that pulls out the @label attribute-->
                    <xsl:apply-templates select="ead:archdesc/ead:did/ead:materialspec"/>
                    <xsl:apply-templates select="ead:archdesc/ead:phystech"/>
                </div>
                <xsl:comment>  /use  </xsl:comment>
            </xsl:if>

            <xsl:if test="$includesDSC eq true()">
                <div class="bs-docs-section">
                    <h2 id="dsc">Collection Contents</h2>
                    <!--takes care of the entire container list-->
                    <xsl:apply-templates select="ead:archdesc/ead:dsc"/>
                </div>
                <xsl:comment>  /dsc  </xsl:comment>
            </xsl:if>

            <xsl:if test="$includeFindSimilarSection eq true()">
                <div class="bs-docs-section">
                    <h2 id="find">Find Similar Resources</h2>
                    <xsl:apply-templates select="ead:archdesc/ead:relatedmaterial | ead:archdesc/ead:descgrp/ead:relatedmaterial"/>
                    <xsl:apply-templates select="ead:archdesc/ead:controlaccess"/>
                </div>
                <xsl:comment>  /find  </xsl:comment>
            </xsl:if>
        </div>
        <xsl:comment>  /main </xsl:comment>
    </xsl:template>

    <xsl:template name="footer">
        <footer id="footer">
            <div class="container">
                <div class="row">
                    <div class="col-md-6">
                        <a href="http://www.nyam.org/library/collections-and-resources/archives/" style="font-size:12px;"><span class="glyphicon glyphicon-home"></span> Return to Archives and Manuscripts</a>
                        <!--<p>Footer / Contact information, etc.</p>-->
                    </div>
                    <div class="col-md-6">
                        <p class="text-right">
                            <!--<span>
                               <a href="{$LOC-eadid/normalize-space()}">View LOC HTML</a>
                                | <a href="{$LOC-MARC-link}">View MARC</a> 
                                | <a href="{$EAD-link}">View XML</a> 
                            </span>-->
                        </p>
                    </div>
                </div>
            </div>
        </footer>
    </xsl:template>

    <xsl:template name="javascript">
        <xsl:comment> Bootstrap core JavaScript
    ================================================== </xsl:comment>
        <xsl:comment>  Placed at the end of the document so the pages load faster </xsl:comment>
        <xsl:comment>  jQuery (necessary for Bootstrap's JavaScript plugins) </xsl:comment>
        <script src="static/dependencies/js/jquery.js"/>
        <xsl:comment>  Include all compiled plugins (below), or include individual files as needed </xsl:comment>
        <script src="static/bootstrap/js/bootstrap.js"/>
        <xsl:comment>  Include local javascript files or extentions </xsl:comment>
        <script src="static/local/js/application.js"/>
    </xsl:template>

    <!--
        3: EAD elements to HTML 
     -->
    <xsl:template match="ead:dsc">
        <!-- see section "4:" -->
        <xsl:call-template name="DSC-Router-HTMLSECTION-or-HTMLTABLE"/>
    </xsl:template>

    <xsl:template match="ead:geogname">
        <xsl:apply-templates/>
        <!-- See "gm001001.xml" for why this is necessary-->
        <xsl:if test="following-sibling::ead:geogname">
            <xsl:text> </xsl:text>
        </xsl:if>
    </xsl:template>

    <xsl:template match="ead:sponsor">
        <div class="well">
            <em>
                <xsl:apply-templates/>
            </em>
        </div>
    </xsl:template>

    <xsl:template match="ead:lb">
        <br/>
    </xsl:template>

    <xsl:template match="ead:physdesc">
        <xsl:if test="position() gt 1">
            <br/>
        </xsl:if>
        <xsl:if test="@label">
            <em>
                <xsl:value-of select="@label"/>
                <xsl:text>: </xsl:text>
            </em>
        </xsl:if>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="ead:unitdate">
        <xsl:choose>
            <!--See gc006001.xml, rs011001.xml for why this is required (and how they differ from mu012003.xml)-->
            <xsl:when test="@type='bulk' and not(contains(., 'bulk'))">
                <xsl:text>, bulk </xsl:text>
                <xsl:value-of select="."/>
            </xsl:when>    
            <!-- See rs011001.xml, series 4, book 1, as an example for  why this "hack" is required.
    Without the following otherwise statement, there would be no space before the date-->
            <xsl:when test="preceding-sibling::*[1][not(matches(., '(\s)$'))]">
                <xsl:text> </xsl:text>
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="ead:extent">
        <xsl:apply-templates/>
        <xsl:if test="following-sibling::ead:extent">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>

    <!-- the next 3 (admittedly awkward) templates deal with the "repository" section -->
    <xsl:template match="ead:addressline">
        <br/>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="ead:address">
        <xsl:apply-templates/>
        <br/>
    </xsl:template> 
    <!-- see pp002004 -->
    <xsl:template match="ead:subarea">
        <xsl:apply-templates/>
        <xsl:if test="following-sibling::text()[1][not(matches(., '^(\s)'))]">
            <xsl:text> </xsl:text>
        </xsl:if>
    </xsl:template>

    <xsl:template match="ead:p">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template match="ead:daoloc">
        <xsl:param name="dao-link" select="@xlink:href"/>
        <xsl:apply-templates>
            <xsl:with-param name="dao-link" select="$dao-link"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="ead:daodesc/ead:p">
        <xsl:param name="dao-link"/>
        <p>
            <a class="btn btn-primary" href="{$dao-link}">
                <xsl:apply-templates/>
            </a>
        </p>
    </xsl:template>

    <xsl:template match="ead:head">
        <xsl:choose>
            <xsl:when test="parent::ead:bioghist and (. eq $bioghist-title)"/>
            <!-- <xsl:when test="parent::ead:acqinfo and (. eq 'Provenance')"/>  don't show provenance title -->

            <xsl:otherwise>
                <h3 class="head-info" id="{generate-id(.)}">
                    <xsl:apply-templates/>
                </h3>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!--controlaccess stuff-->
    <xsl:template match="ead:controlaccess/ead:controlaccess">
        <xsl:apply-templates select="ead:head"/>
        <table class="table">
            <col style="width:80%"/>
            <col style="width:20%"/>
            <tbody>
                <xsl:apply-templates mode="controlaccess-table" select="*[not(self::ead:head)]"/>
            </tbody>
        </table>
    </xsl:template>
    <xsl:template
        match="ead:corpname | ead:famname | ead:function |  ead:genreform |  ead:geogname |  ead:occupation | 
        ead:persname |  ead:subject |  ead:title |  ead:name"
        mode="controlaccess-table">
        <xsl:variable name="subject-string">
            <xsl:value-of select="normalize-space()"/>
        </xsl:variable>
        <tr>
            <td>
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="concat($NYAM-URL-start, replace($subject-string, '(--|\s)', '+'))"/>
                        <!--<xsl:value-of select="concat($LOC-URL-start, replace($subject-string, '(\-\-|\s)', '+'), $LOC-URL-end)"/>-->
                    </xsl:attribute>
                    <xsl:value-of select="$subject-string"/>
                </a>
            </td>
            <td>
                <a class="btn btn-default">
                    <xsl:attribute name="href">
                        <xsl:value-of select="concat($ArchiveGrid-URL, encode-for-uri((replace($subject-string, '--', '+'))), '&amp;p=0&amp;label=', replace($subject-string, ' ', '+'))"/>
                    </xsl:attribute>
                    <xsl:value-of select="'Search ArchiveGrid'"/>
                </a>
            </td>
        </tr>
    </xsl:template>

    <!-- The following templates are borrowed (and sometimes modified) from the default AT stylesheet by Winona Salesky -->
    <xsl:template match="ead:bibref">
        <xsl:choose>
            <xsl:when test="@xlink:href">
                <a href="{@xlink:href}">
                    <xsl:apply-templates/>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="ead:list">
        <xsl:if test="ead:head">
            <h5>
                <xsl:value-of select="ead:head"/>
            </h5>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="descendant::ead:defitem">
                <dl>
                    <xsl:apply-templates select="ead:defitem"/>
                </dl>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="@type='ordered' and @numeration">
                        <ol>
                            <xsl:attribute name="class">
                                <xsl:value-of select="@numeration"/>
                            </xsl:attribute>
                            <xsl:apply-templates/>
                        </ol>
                    </xsl:when>
                    <xsl:when test="@type='simple'">
                        <ul class="unstyled">
                            <xsl:apply-templates/>
                        </ul>
                    </xsl:when>
                    <xsl:otherwise>
                        <ul>
                            <xsl:apply-templates/>
                        </ul>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="ead:list/ead:head"/>
    <xsl:template match="ead:list/ead:item">
        <li>
            <xsl:apply-templates/>
        </li>
    </xsl:template>
    <xsl:template match="ead:defitem">
        <dt>
            <xsl:apply-templates select="ead:label"/>
        </dt>
        <dd>
            <xsl:apply-templates select="ead:item"/>
        </dd>
    </xsl:template>

    <xsl:template match="ead:chronlist">
        <table class="table table-striped table-bordered table-condensed">
            <col style="width:20%"/>
            <col style="width:80%"/>
            <thead>
                <xsl:if test="not(ead:listhead | ead:head)">
                    <tr>
                        <th>Date</th>
                        <th>Event</th>
                    </tr>
                </xsl:if>
                <xsl:apply-templates select="ead:listhead"/>
            </thead>
            <tbody>
                <xsl:apply-templates select="*[not(self::ead:listhead)]"/>
            </tbody>
        </table>
    </xsl:template>
    <xsl:template match="ead:chronlist/ead:listhead">
        <tr>
            <th>
                <xsl:apply-templates select="ead:head01"/>
            </th>
            <th>
                <xsl:apply-templates select="ead:head02"/>
            </th>
        </tr>
    </xsl:template>
    <xsl:template match="ead:chronlist/ead:head">
        <tr>
            <th colspan="2">
                <xsl:apply-templates/>
            </th>
        </tr>
    </xsl:template>
    <xsl:template match="ead:chronitem">
        <tr>
            <td>
                <xsl:apply-templates select="ead:date"/>
            </td>
            <td>
                <xsl:apply-templates select="ead:event | ead:eventgrp"/>
            </td>
        </tr>
    </xsl:template>
    <xsl:template match="ead:eventgrp">
        <ul>
            <xsl:apply-templates select="ead:event" mode="li"/>
        </ul>
    </xsl:template>
    <xsl:template match="ead:event" mode="li">
        <li>
            <xsl:apply-templates/>
        </li>
    </xsl:template>

    <xsl:template match="ead:table">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="ead:tgroup">
        <table class="table table-striped table-bordered">
            <xsl:apply-templates/>
        </table>
    </xsl:template>
    <xsl:template match="ead:thead">
        <thead>
            <xsl:apply-templates/>
        </thead>
    </xsl:template>
    <xsl:template match="ead:tbody">
        <tbody>
            <xsl:apply-templates/>
        </tbody>
    </xsl:template>
    <xsl:template match="ead:row">
        <tr>
            <xsl:apply-templates/>
        </tr>
    </xsl:template>
    <xsl:template match="ead:thead/ead:row/ead:entry">
        <th>
            <xsl:apply-templates/>
        </th>
    </xsl:template>
    <xsl:template match="ead:entry">
        <td>
            <xsl:apply-templates/>
        </td>
    </xsl:template>

    <!--Render elements (change to title and emph and see if that speeds up processing)-->
    <xsl:template match="*[@render = 'bold'] | *[@altrender = 'bold'] ">
        <strong>
            <xsl:apply-templates/>
        </strong>
    </xsl:template>
    <xsl:template match="*[@render = 'bolddoublequote'] | *[@altrender = 'bolddoublequote']">
        <strong>"<xsl:apply-templates/>"</strong>
    </xsl:template>
    <xsl:template match="*[@render = 'boldsinglequote'] | *[@altrender = 'boldsinglequote']">
        <strong>'<xsl:apply-templates/>'</strong>
    </xsl:template>
    <xsl:template match="*[@render = 'bolditalic'] | *[@altrender = 'bolditalic']">
        <strong>
            <em>
                <xsl:apply-templates/>
            </em>
        </strong>
    </xsl:template>
    <xsl:template match="*[@render = 'boldsmcaps'] | *[@altrender = 'boldsmcaps']">
        <strong>
            <span class="smcaps">
                <xsl:apply-templates/>
            </span>
        </strong>
    </xsl:template>
    <xsl:template match="*[@render = 'boldunderline'] | *[@altrender = 'boldunderline']">
        <strong>
            <span class="underline">
                <xsl:apply-templates/>
            </span>
        </strong>
    </xsl:template>
    <xsl:template match="*[@render = 'doublequote'] | *[@altrender = 'doublequote']">
        <xsl:text>"</xsl:text>
            <xsl:apply-templates/>
        <xsl:text>"</xsl:text>
    </xsl:template>
    <xsl:template match="*[@render = 'italic'] | *[@altrender = 'italic']">
        <em>
            <xsl:apply-templates/>
        </em>
    </xsl:template>
    <xsl:template match="*[@render = 'singlequote'] | *[@altrender = 'singlequote']">
        <xsl:text>'</xsl:text>
            <xsl:apply-templates/>
        <xsl:text>'</xsl:text>
    </xsl:template>
    <xsl:template match="*[@render = 'smcaps'] | *[@altrender = 'smcaps']">
        <span class="smcaps">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="*[@render = 'sub'] | *[@altrender = 'sub']">
        <sub>
            <xsl:apply-templates/>
        </sub>
    </xsl:template>
    <xsl:template match="*[@render = 'super'] | *[@altrender = 'super']">
        <sup>
            <xsl:apply-templates/>
        </sup>
    </xsl:template>
    <xsl:template match="*[@render = 'underline'] | *[@altrender = 'underline']">
        <span class="underline">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!--linking templates -->
    <xsl:template match="ead:ref | ead:archref">
        <xsl:choose>
            <xsl:when test="@target">
                <a href="#{@target}">
                    <xsl:apply-templates/>
                </a>
            </xsl:when>
            <xsl:when test="@xlink:href">
                <a href="{@xlink:href}">
                    <xsl:apply-templates/>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="ead:extptr">
        <xsl:choose>
            <xsl:when test="@xlink:href">
                <a href="{@xlink:href}">
                    <xsl:value-of select="@title"/>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="@title"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="ead:extref">
        <xsl:choose>
            <xsl:when test="@xlink:href">
                <a href="{@xlink:href}">
                    <xsl:apply-templates/>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- the next template deals with trailing commas in the collection title (see rb999001.xml).-->
    <xsl:template match="ead:archdesc/ead:did/ead:unittitle/text()">
        <xsl:choose>
            <xsl:when test="ends-with(./normalize-space(), ',')">
                <xsl:value-of select="replace(./normalize-space(), ',$', '')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- 
        4: DSC container list templates 
    -->
    <xsl:template name="DSC-Router-HTMLSECTION-or-HTMLTABLE">
        <xsl:param name="css-padding" select="0" as="xs:double"/>
        <xsl:for-each-group
            select="ead:c | ead:c01 | ead:c02 | ead:c03 | ead:c04 | ead:c05 | ead:c06 | ead:c07 | ead:c08 | ead:c09 | ead:c10 | ead:c11 | ead:c12"
            group-adjacent="boolean(.[@level='series'] or
            .[@level='subseries'] or
            .[@level='subgrp'])">
            <xsl:choose>
                <!-- when the group above = true (i.e. the level is a series, subseries, or subgrp), do the following-->
                <xsl:when test="current-grouping-key()">
                    <xsl:for-each select="current-group()">
                        <xsl:apply-templates select="." mode="section-components"/>
                    </xsl:for-each>
                </xsl:when>
                <!-- when it's false, construct the HTML table below-->
                <xsl:otherwise>
                    <table class="table table-striped table-hover">
                        <xsl:choose>
                            <xsl:when test=".//ead:container">
                                <col style="width:25%"/>
                                <col style="width:75%"/>
                                <thead>
                                    <tr>
                                        <th>Container</th>
                                        <th>Description</th>
                                    </tr>
                                </thead>   
                            </xsl:when>
                            <xsl:otherwise>
                                <thead>
                                    <tr>
                                        <th>Description</th>
                                    </tr>
                                </thead>  
                            </xsl:otherwise>
                        </xsl:choose>
                        <tbody>
                            <xsl:for-each select="current-group()">
                                <xsl:apply-templates select="." mode="table-components"/>
                            </xsl:for-each>
                        </tbody>
                    </table>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each-group>
    </xsl:template>
    
    <!--Main components-->
    <xsl:template
        match="ead:c | ead:c01 | ead:c02 | ead:c03 | ead:c04 | ead:c05 | ead:c06 | ead:c07 | ead:c08 | ead:c09 | ead:c10 | ead:c11 | ead:c12"
        mode="section-components">
        <xsl:param name="css-padding" select="0" as="xs:double"/>
        <xsl:if test="@level='series'">
            <section>
                <!--I prefer to use the IDs attached to the component levels, but sometimes the narrative descriptions have references that
                    use the @id attribute on the unititle.  This is why I sometimes create anchors for both (whether an empty HTML <a> element, or 
                    an id attribute on a HTML header element (<h3> below) -->
                <xsl:if test="$locationOfIDs = 'c' and  ead:did/ead:unittitle/@id">
                    <a id="{ead:did/ead:unittitle/@id}"/>
                </xsl:if>
                <h3 class="special-h3">
                    <xsl:attribute name="id">
                        <xsl:value-of select=" if ($locationOfIDs = 'c') then @id else translate(translate(translate(translate(translate(ead:did/ead:unittitle, ' ', '_'), &quot;,.&apos;&quot;, ''), '(', ''), ')', ''), '/', '')"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="ead:did/ead:unitid"/><xsl:text>: </xsl:text>
                    <xsl:apply-templates select="ead:did/ead:unittitle"/>
                    <xsl:if test="ead:did/ead:physdesc">
                        <br/>
                        <small>
                            <xsl:apply-templates select="ead:did/ead:physdesc" mode="series-header"/>
                        </small>
                    </xsl:if>
                </h3>
                <xsl:apply-templates select="ead:did/ead:* except (ead:did/ead:unittitle | ead:did/ead:physdesc | ead:did/ead:unitid)"/>
                <xsl:apply-templates select="ead:* except (ead:did | ead:c | ead:c02 | ead:c03 | ead:c04 | ead:c05 | ead:c06 | ead:c07 | ead:c08 | ead:c09 | ead:c10 | ead:c11 | ead:c12)"/>
                <!-- group and go through the next level of components with the following called template -->
                <xsl:if test="ead:c | ead:c02 | ead:c03 | ead:c04 | ead:c05 | ead:c06 | ead:c07 | ead:c08 | ead:c09 | ead:c10 | ead:c11 | ead:c12">
                    <xsl:call-template name="DSC-Router-HTMLSECTION-or-HTMLTABLE"/>
                </xsl:if>
            </section>
        </xsl:if>
        
        <xsl:if test="@level='subseries' or @level='subgrp'">
            <div class="subseries">
                <xsl:if test="$locationOfIDs = 'c' and  ead:did/ead:unittitle/@id">
                    <a id="{ead:did/ead:unittitle/@id}"/>
                </xsl:if>
                <h4>
                    <xsl:attribute name="id">
                        <xsl:value-of select=" if ($locationOfIDs = 'c') then @id else translate(translate(translate(translate(translate(ead:did/ead:unittitle, ' ', '_'), &quot;,.&apos;&quot;, ''), '(', ''), ')', ''), '/', '')"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="ead:did/ead:unitid"/><xsl:text>: </xsl:text>
                    <xsl:apply-templates select="ead:did/ead:unittitle"/>
                    <xsl:if test="ead:did/ead:physdesc">
                        <br/>
                        <small>
                            <xsl:apply-templates select="ead:did/ead:physdesc" mode="series-header"/>
                        </small>
                    </xsl:if>
                </h4>
                <xsl:apply-templates select="ead:did/ead:* except (ead:did/ead:unittitle | ead:did/ead:physdesc | ead:did/ead:unitid)"/>
                <xsl:apply-templates select="* except (ead:did | ead:c | ead:c02 | ead:c03 | ead:c04 | ead:c05 | ead:c06 | ead:c07 | ead:c08 | ead:c09 | ead:c10 | ead:c11 | ead:c12)"/>
                <!-- group and go through the next level of components with the following called template -->
                <xsl:if
                    test="ead:c | ead:c02 | ead:c03 | ead:c04 | ead:c05 | ead:c06 | ead:c07 | ead:c08 | ead:c09 | ead:c10 | ead:c11 | ead:c12">
                    <xsl:call-template name="DSC-Router-HTMLSECTION-or-HTMLTABLE"/>
                </xsl:if>
            </div>
        </xsl:if>
    </xsl:template>
    
    <!-- Table-esque components -->
    <xsl:template
        match="ead:c | ead:c01 | ead:c02 | ead:c03 | ead:c04 |ead:c05 | ead:c06 | ead:c07 | ead:c08 | ead:c09 | ead:c10 | ead:c11 | ead:c12"
        mode="table-components">
        <xsl:param name="css-padding" select="0" as="xs:double"/>
        <tr>
            <xsl:if test="ancestor::ead:c01//ead:container or ancestor::ead:c//ead:container or .//ead:container">
                <td> <!-- BOX CELL -->
                    <xsl:apply-templates select="ead:did/ead:container"/>
                </td>
            </xsl:if>
            <td> <!-- DESCRIPTION CELL -->
                <xsl:if test="$css-padding gt 0">
                    <xsl:attribute name="class">
                        <xsl:value-of select="concat('padding', '-', $css-padding)"/>
                    </xsl:attribute>
                </xsl:if>
                <xsl:if test="ead:did/ead:unittitle/@id">
                    <a id="{ead:did/ead:unittitle/@id}"/>
                </xsl:if>
                <xsl:apply-templates select="ead:did/ead:unittitle"/>
                <xsl:if test="ead:did/ead:unitid">
                    <br/> 
                    <xsl:apply-templates select="ead:did/ead:unitid"/>
                </xsl:if>
                <xsl:if test="ead:did/ead:physdesc">
                    <br/>
                    <xsl:apply-templates select="ead:did/ead:physdesc"/>
                </xsl:if>
                <!-- does this work for all of the container lists, or will I need to add a break element before each?-->
                <xsl:apply-templates select="ead:did/ead:* except (ead:did/ead:unittitle | ead:did/ead:physdesc | ead:did/ead:unitid | ead:did/ead:container)"/>
                <xsl:apply-templates select="* except (ead:did | ead:c | ead:c02 | ead:c03 | ead:c04 | ead:c05 | ead:c06 | ead:c07 | ead:c08 | ead:c09 | ead:c10 | ead:c11 | ead:c12)"/>
            </td>
        </tr>
        <xsl:apply-templates
            select="ead:c | ead:c02 | ead:c03 | ead:c04 |ead:c05 | ead:c06 | ead:c07 | ead:c08 | ead:c09 | ead:c10 | ead:c11 | ead:c12"
            mode="#current">
            <xsl:with-param name="css-padding" select="$css-padding + 1"/>
        </xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="ead:container">
        <xsl:value-of select="concat(@type, ' ')"/>
        <xsl:apply-templates/>
        <!--I haven't checked yet to see if the following attribute appears in the 15 test documents, but it is part of the LoC EAD Best Practices PDF document-->
        <!--<xsl:if test="@label">-->
            <!--<xsl:value-of select="concat('(', ., ')')"/>--> <!--NYAM MOD do not want this as repeats container number in parans-->
        <!--</xsl:if>-->
        <!--<br/>--> <!--<span class="indenter"></span>--> &#160;&#160;
        <!-- uncomment, remove the break element above, and see the effect that this has on 
            Vincent Price Papers, series 5 !
        <xsl:if test="following-sibling::ead:container and (position() lt last())">
            <xsl:text>, </xsl:text>
        </xsl:if>
        -->
    </xsl:template>


    <!--
        5: Global variables / parameters
     -->
    <xsl:param name="includeAnalytics" select="true()" as="xs:boolean"/>

    <xsl:param name="locationOfIDs" as="xs:string">
        <xsl:value-of select="if (/ead:ead/ead:archdesc[1]/ead:dsc[1]/ead:c01[1]/@id) then 'c' else 'title'"/>
    </xsl:param>

    <xsl:param name="includesDSC" as="xs:boolean">
        <xsl:value-of select="if (/ead:ead/ead:archdesc[1]/ead:dsc/ead:*) then true() else false()"/>
    </xsl:param>

    <xsl:param name="includeBioghistSection" as="xs:boolean">
        <xsl:value-of select="if (/ead:ead/ead:archdesc[1]/ead:bioghist) then true() else false()"/>
    </xsl:param>

    <xsl:param name="includeDescriptionSection" as="xs:boolean">
        <xsl:value-of
            select="if (/ead:ead/ead:archdesc[1]/ead:scopecontent
            or /ead:ead/ead:archdesc[1]/ead:arrangement
            or /ead:ead/ead:archdesc[1]/ead:accruals
            or /ead:ead/ead:archdesc[1]/ead:appraisal
            or /ead:ead/ead:archdesc[1]/ead:bibliography
            or /ead:ead/ead:archdesc[1]/ead:custodhist
            or /ead:ead/ead:archdesc[1]/ead:fileplannote
            or /ead:ead/ead:archdesc[1]/ead:odd
            or /ead:ead/ead:archdesc[1]/ead:index
            or /ead:ead/ead:archdesc[1]/ead:processinfo
            or /ead:ead/ead:archdesc[1]/ead:separatedmaterial) 
            then true() 
            else false()"
        />
    </xsl:param>
    
    <xsl:param name="includeUsingThisCollectionSection" as="xs:boolean">
        <xsl:value-of
            select="if (/ead:ead/ead:archdesc[1]/ead:accessrestrict
            or /ead:ead/ead:archdesc[1]/ead:userestrict
            or /ead:ead/ead:archdesc[1]/ead:prefercite
            or /ead:ead/ead:archdesc[1]/ead:altformavail
            or /ead:ead/ead:archdesc[1]/ead:originalsloc
            or /ead:ead/ead:archdesc[1]/ead:location 
            or
            /ead:ead/ead:archdesc[1]/ead:descgrp/ead:accessrestrict
            or /ead:ead/ead:archdesc[1]/ead:descgrp/ead:userestrict
            or /ead:ead/ead:archdesc[1]/ead:descgrp/ead:prefercite
            or /ead:ead/ead:archdesc[1]/ead:descgrp/ead:altformavail
            or /ead:ead/ead:archdesc[1]/ead:descgrp/ead:originalsloc
            or /ead:ead/ead:archdesc[1]/ead:descgrp/ead:location) 
            then true() 
            else false()"
        />
    </xsl:param>

    <xsl:param name="includeFindSimilarSection" as="xs:boolean">
        <xsl:value-of
            select="if (/ead:ead/ead:archdesc[1]/ead:controlaccess
            or /ead:ead/ead:archdesc[1]/ead:relatedmaterial or /ead:ead/ead:archdesc[1]/ead:descgrp/ead:relatedmaterial) 
            then true() 
            else false()"
        />
    </xsl:param>

    <!--If there are any children elements (like title, emph, etc.), the text is still printed out, but any italicizations, etc., 
        are ignored when the "collectionTitle" variable is invoked.  Therefore, this variable should only be used for things like the HTML title element.-->
    <xsl:variable name="collectionTitle-as-text" as="xs:string*">
        <xsl:choose>
            <!-- work-around for the encoding encountered in the King Lear Archive (which is slightly different than the archdesc/did/unititle encoding elsewhere)-->
            <xsl:when test="ends-with(/ead:ead/ead:archdesc[1]/ead:did[1]/ead:unittitle[1]/text()[last()]/normalize-space(), ',')">
                <xsl:value-of
                    select="replace(/ead:ead/ead:archdesc[1]/ead:did[1]/ead:unittitle[1]/text()/normalize-space(), ',$', '')"/>
            </xsl:when>
            <xsl:when test="ends-with(/ead:ead/ead:archdesc[1]/ead:did[1]/ead:unittitle[1]/text()[last()]/normalize-space(), ',&quot;')">
                <xsl:value-of
                    select="replace(/ead:ead/ead:archdesc[1]/ead:did[1]/ead:unittitle[1]/text()/normalize-space(), ',&quot;$', '&quot;')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="/ead:ead/ead:archdesc[1]/ead:did[1]/ead:unittitle[1]/text()/normalize-space()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="LOC-eadid" select="/ead:ead/ead:eadheader/ead:eadid"/>

    <xsl:variable name="LOC-MARC-link"
        select="/ead:ead/ead:eadheader[1]/ead:filedesc[1]/ead:notestmt/ead:note[@id='lccnNote']/ead:p[1]/ead:extref[1]/@xlink:href"/>

    <xsl:variable name="LOC-dept">
        <xsl:value-of select="substring-after(substring-before($LOC-eadid/@identifier, '/'), '.')"/>
    </xsl:variable>
    
    <xsl:variable name="LOC-FA-year-online">
        <xsl:analyze-string
            select="/ead:ead/ead:eadheader/ead:profiledesc[1]/ead:creation[1]/ead:date[1]/text()" regex="\d{{4}}">
            <xsl:matching-substring>
                <xsl:value-of select="."/>
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:variable>
    
    <xsl:variable name="EAD-link">
        <xsl:value-of
            select="concat('http://rs5.loc.gov/findingaids/master/', $LOC-dept, '/eadxml', $LOC-dept, '/', $LOC-FA-year-online, '/',
        replace($LOC-eadid/@identifier, 'hdl:loc.\w+/\w+.', ''), '.xml')"/>
    </xsl:variable>

    <xsl:variable name="newline">
        <xsl:text>
        </xsl:text>
    </xsl:variable>
    
    
    <xsl:variable name="NYAM-URL-start">http://nyam.waldo.kohalibrary.com/cgi-bin/koha/opac-search.pl?idx=subject&amp;q=</xsl:variable>
    <!--<xsl:variable name="LOC-URL-start">http://catalog.loc.gov/cgi-bin/Pwebrecon.cgi?db=local&amp;SA=</xsl:variable>
    <xsl:variable name="LOC-URL-end">&amp;SC=SUBJ&amp;CNT=25</xsl:variable>-->
    <xsl:variable name="ArchiveGrid-URL">http://beta.worldcat.org/archivegrid/?q=</xsl:variable>

    <xsl:variable name="bioghist-title" as="xs:string">
        <xsl:choose>
            <xsl:when
                test="(/ead:ead/ead:archdesc[1]/ead:did[1]/ead:origination/ead:persname or /ead:ead/ead:archdesc[1]/ead:did[1]/ead:origination/ead:famname) 
                and /ead:ead/ead:archdesc[1]/ead:did[1]/ead:origination/ead:corpname">Biographical/Historical Note</xsl:when>
            <xsl:when test="/ead:ead/ead:archdesc[1]/ead:did[1]/ead:origination/ead:corpname">Historical Note</xsl:when>
            <xsl:otherwise>Biographical Note</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <!--this should be suppressed on mobile views (add a class and update the docs.css file) -->
    <xsl:template name="returntotop">
        <xsl:comment>back to top link</xsl:comment>
        <div>
            <a href="#top" class="btn btn-default btn-xs">return to top</a>
        </div>
        <xsl:comment>back to top link</xsl:comment>
        <xsl:value-of select="$newline"/>
    </xsl:template>
    
</xsl:stylesheet>
