<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format">

  <xsl:output method="xml" indent="yes"/>

  <xsl:template match="/root">
    <fo:root>
      <fo:layout-master-set>
        <fo:simple-page-master master-name="letter"
          page-width="210mm" page-height="297mm"
          margin-top="15mm" margin-bottom="20mm"
          margin-left="20mm" margin-right="20mm">
          <fo:region-body/>
        </fo:simple-page-master>
      </fo:layout-master-set>

      <xsl:apply-templates select="record"/>
    </fo:root>
  </xsl:template>

  <xsl:template match="record">
    <fo:page-sequence master-reference="letter">
      <fo:flow flow-name="xsl-region-body">

        <!-- Logo top-right -->
        <fo:block text-align="right">
          <fo:external-graphic src="logo.png"
            content-height="35mm" scaling="uniform"/>
        </fo:block>

        <fo:block space-after="5mm"/>

        <!-- Recipient (left) + Sender (right) -->
        <fo:table table-layout="fixed" width="170mm">
          <fo:table-column column-width="105mm"/>
          <fo:table-column column-width="65mm"/>
          <fo:table-body>
            <fo:table-row>
              <!-- Recipient -->
              <fo:table-cell>
                <fo:block font-family="Helvetica" font-size="11pt" line-height="1.5">
                  <xsl:value-of select="@first_name"/>
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="@last_name"/>
                </fo:block>
                <fo:block font-family="Helvetica" font-size="11pt" line-height="1.5">
                  <xsl:value-of select="@address"/>
                </fo:block>
                <fo:block font-family="Helvetica" font-size="11pt" line-height="1.5">
                  <xsl:value-of select="@city"/>
                  <xsl:text>, </xsl:text>
                  <xsl:value-of select="@state"/>
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="@zip"/>
                </fo:block>
              </fo:table-cell>

              <!-- Sender -->
              <fo:table-cell>
                <fo:block font-family="Helvetica" font-size="10pt"
                  line-height="1.5" text-align="right">
                  <xsl:text>Print Company &amp; Office</xsl:text>
                </fo:block>
                <fo:block font-family="Helvetica" font-size="10pt"
                  line-height="1.5" text-align="right">
                  <xsl:text>61556 W 20th Ave</xsl:text>
                </fo:block>
                <fo:block font-family="Helvetica" font-size="10pt"
                  line-height="1.5" text-align="right">
                  <xsl:text>Seattle King WA 98104</xsl:text>
                </fo:block>
                <fo:block font-family="Helvetica" font-size="10pt"
                  line-height="1.5" text-align="right" space-before="3mm">
                  <xsl:text>206-711-6498</xsl:text>
                </fo:block>
                <fo:block font-family="Helvetica" font-size="10pt"
                  line-height="1.5" text-align="right">
                  <xsl:text>206-395-6284</xsl:text>
                </fo:block>
                <fo:block font-family="Helvetica" font-size="10pt"
                  line-height="1.5" text-align="right" space-before="3mm">
                  <xsl:text>jbiddy@printcompany.com</xsl:text>
                </fo:block>
                <fo:block font-family="Helvetica" font-size="10pt"
                  line-height="1.5" text-align="right">
                  <xsl:text>www.printcompany.com</xsl:text>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-body>
        </fo:table>

        <!-- Datum -->
        <fo:block-container width="105mm" space-before="25mm">
          <fo:block font-family="Helvetica" font-size="11pt">
            <xsl:text>November 6, 2014</xsl:text>
          </fo:block>
        </fo:block-container>

        <!-- Salutation -->
        <fo:block-container width="105mm" space-before="8mm">
          <fo:block font-family="Helvetica" font-size="11pt">
            <xsl:text>Dear </xsl:text>
            <xsl:value-of select="@first_name"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="@last_name"/>
            <xsl:text>,</xsl:text>
          </fo:block>
        </fo:block-container>

        <!-- Letter body -->
        <fo:block-container width="105mm" space-before="5mm">
          <fo:block font-family="Helvetica" font-size="11pt" line-height="1.5"
            text-align="justify" hyphenate="true" language="en">
            but I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasure, but because those who do not know how to pursue pleasure rationally encounter consequences that are extremely painful. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. To take a trivial example, which of us ever undertakes laborious physical exercise, except to obtain some advantage from it? But who has any right to find fault with a man who chooses to enjoy a pleasure that has no annoying consequences, or one who avoids a pain that produces no resultant pleasure?
          </fo:block>
        </fo:block-container>

        <!-- Closing -->
        <fo:block-container width="105mm" space-before="5mm">
          <fo:block font-family="Helvetica" font-size="11pt">
            <xsl:text>Yours faithfully,</xsl:text>
          </fo:block>
        </fo:block-container>

        <!-- Name -->
        <fo:block-container width="105mm" space-before="10mm">
          <fo:block font-family="Helvetica" font-size="11pt">
            <xsl:text>Jani Biddy</xsl:text>
          </fo:block>
        </fo:block-container>

      </fo:flow>
    </fo:page-sequence>
  </xsl:template>

</xsl:stylesheet>
