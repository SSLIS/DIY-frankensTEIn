<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:html="http://www.w3.org/1999/xhtml" exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="html"/>

    <!-- transform the root element (TEI) into an HTML template -->
    <xsl:template match="tei:TEI">
        <html lang="en" xml:lang="en">
            <head>
                <title>
                    <!-- add the title from the metadata. This is what will be shown
                    on your browsers tab-->
                    frankensTEIn: Mary Diplomatic
                </title>
                <!-- load bootstrap css (requires internet!) so you can use their pre-defined css classes to style your html -->
                <link rel="stylesheet"
                    href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
                    integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T"
                    crossorigin="anonymous"/>
                <!-- load the stylesheets in the assets/css folder, where you can modify the styling of your website -->
                <link rel="stylesheet" href="../assets/css/main.css"/>
                <link rel="stylesheet" href="../assets/css/desktop.css"/>
                <!-- add additional css to overrule the (generic) bootstrap stylesheet -->
                <style>
                    .Mary{
                        color: red;
                    }
                    .Percy{
                    color: black;
                    }
                </style>
            </head>
            <body>
                <header>
                    <h1>
                        <xsl:apply-templates select="//tei:TEI//tei:title"/>
                    </h1>
                </header>
                <nav id="sitenav">
                    <a href="index.html">Home</a> |
                    <a href="diplomatic.html">Diplomatic Transcription</a> |
                    <a href="reading.html">Reading Text</a> |
                    <a href="toplayer.html">Top Layer</a> |
                    <a href="mary.html">Mary's Text</a> |
                    <a href="percy.html">Percy's Modifications</a>
                </nav>
                <main id="manuscript">
                    <!-- bootstrap "container" class makes the columns look pretty -->
                    <div class="container">
                        <!-- define a row layout with bootstrap's css classes (two columns) -->
                        <div class="row">
                            <!-- first column: load the image based on the IIIF link in the graphic above -->
                            <div class="col-sm">
                                <article id="facsimile">
                                    <img width="600">
                                        <xsl:attribute name="src">
                                            <xsl:value-of select="//tei:facsimile/tei:surface//tei:graphic[@xml:id='f21r_full']/@url"/>
                                        </xsl:attribute>
                                        <xsl:attribute name="title">
                                            <xsl:value-of select="//tei:facsimile/tei:surface[@xml:id='f21r']//tei:label"/>
                                        </xsl:attribute>
                                        <xsl:attribute name="alt">
                                            <xsl:value-of select="//tei:facsimile/tei:surface[@xml:id='f21r']//tei:figDesc"/>
                                        </xsl:attribute>
                                    </img>
                                </article>
                            </div>
                            <!-- second column: apply matching templates for anything nested underneath the tei:text element -->
                            <div class="col-sm">
                                <article id="transcription">
                                    <xsl:apply-templates select="//tei:TEI//tei:text"/>
                                </article>
                            </div>
                        </div>
                    </div>
                </main>
            </body>
        </html>
    </xsl:template>

    <!-- by default all text nodes are printed out, unless something else is defined.
    We don't want to show the metadata. So we write a template for the teiHeader that
    stops the text nodes underneath (=nested in) teiHeader from being printed into our
    html-->
    <xsl:template match="tei:teiHeader"/>

    <!-- turn tei linebreaks (lb) into html linebreaks (br) -->
    <xsl:template match="tei:lb">
        <br/>
    </xsl:template>
    <!-- not: in the previous template there is no <xsl:apply-templates/>. This is because there is nothing to
    process underneath (nested in) tei lb's. Therefore the XSLT processor does not need to look for templates to
    apply to the nodes nested within it.-->


    <!-- we turn the tei head element (headline) into an html h1 element-->
    <xsl:template match="tei:head">
        <h1>
            <xsl:apply-templates/>
        </h1>
    </xsl:template>


    <!-- transform tei paragraphs into html paragraphs -->
    <xsl:template match="tei:p">
        <p class="Mary">
            <!-- apply matching templates for anything that was nested in tei:p -->
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <!-- transform tei del into html strike -->
    <xsl:template match="tei:del">
        <strike>
            <xsl:apply-templates/>
        </strike>
    </xsl:template>

    <!-- transform tei add into html sup -->
    <xsl:template match="tei:add">
        <sup>
            <xsl:apply-templates/>
        </sup>
    </xsl:template>


    <!-- transform tei hi (highlighting) with the attribute @rend="u" into html u elements -->
    <!-- how to read the match? "For all tei:hi elements that have a rend attribute with the value "u", do the following" -->
    <xsl:template match="tei:hi[@rend = 'u']">
        <u>
            <xsl:apply-templates/>
        </u>
    </xsl:template>

    <!-- transform tei hi (highlighting) with the attribute @rend="sup" into superscript -->
    <xsl:template match="tei:hi[@rend = 'sup']">
        <span style="vertical-align:super; font-size:80%;">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!-- transform tei hi (highlighting) with the attribute @rend="u" into html u elements -->
    <xsl:template match="tei:hi[@rend = 'circled']">
        <span style="border:1px solid black;border-radius:50%">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!-- make PBS's additions red -->
    <xsl:template match="tei:add[@hand = '#PBS']">
        <sup class="Percy">
            <xsl:apply-templates/>
        </sup>
    </xsl:template>

    <!-- make PBS's deletions red -->
    <!-- the extra span makes sure that only the strikethrough line is red,
         since the words underneath may be written by MS.
    -->
    <xsl:template match="tei:del[@hand = '#PBS']">
        <strike style="color:black;">
            <span style="color:red">
                <xsl:apply-templates/>
            </span>
        </strike>
    </xsl:template>

</xsl:stylesheet>
