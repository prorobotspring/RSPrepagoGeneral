<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:rtbs="http://comverse-in.com/prepaid/ccws">
	<!-- Version transformacion RTBS -->
	<xsl:output method="text" />
	<!-- CONSTANTS -->

	<xsl:variable name="coreBName" select="'Core'" />
	<xsl:decimal-format name="espaniol" decimal-separator="," grouping-separator="." />

	<!-- MAIN -->
	<xsl:template match="/">
		<xsl:apply-templates select="//rtbs:RetrieveSubscriberWithIdentityNoHistoryResult"></xsl:apply-templates>
	</xsl:template>

	<xsl:template match="rtbs:RetrieveSubscriberWithIdentityNoHistoryResult">
		<xsl:apply-templates select="rtbs:SubscriberData"></xsl:apply-templates>
	</xsl:template>

	<xsl:template match="rtbs:SubscriberData">
		<!-- SALDO -->
		<xsl:variable name="BS" select="sum(rtbs:Balances/rtbs:Balance[rtbs:BalanceName=$coreBName]/rtbs:Balance)" />

		<!-- BONO -->
		<xsl:variable name="BONO" select="sum(rtbs:Balances/rtbs:Balance[rtbs:BalanceName='F_BS']/rtbs:Balance)" />

		<!-- SEGUNDOS 412 -->
		<xsl:variable name="SEC_412"
			select="sum(rtbs:Balances/rtbs:Balance[rtbs:BalanceName='NF_SEC_M2MF_ON-NET' or rtbs:BalanceName='F_SEC_M2MF_ON-NET']/rtbs:Balance)" />

		<!-- SEGUNDOS OTRAS -->
		<xsl:variable name="SEC_OTRAS"
			select="sum(rtbs:Balances/rtbs:Balance[rtbs:BalanceName='NF_SEC_M2MF_OFF-NET' or rtbs:BalanceName='F_SEC_M2MF_OFF-NET']/rtbs:Balance)" />

		<!-- SEGUNDOS TODAS -->
		<xsl:variable name="SEC_TODAS"
			select="sum(rtbs:Balances/rtbs:Balance[rtbs:BalanceName='NF_SEC_M2MF_ON-OFF-NET'or rtbs:BalanceName='NF_SEC_F2MF_ON-OFF-NET' or rtbs:BalanceName='F_SEC_M2MF_ON-OFF-NET' or rtbs:BalanceName='F_SEC_F2MF_ON-OFF-NET' or rtbs:BalanceName='NF_SEC_LDI']/rtbs:Balance)" />

		<!-- MMS -->
		<xsl:variable name="MMS"
			select="sum(rtbs:Balances/rtbs:Balance[rtbs:BalanceName='NF_MMS' or
rtbs:BalanceName='F_MMS']/rtbs:Balance)" />

		<!-- MB -->
		<xsl:variable name="MB"
			select="(sum(rtbs:Balances/rtbs:Balance[rtbs:BalanceName='F_KB' or rtbs:BalanceName='NF_KB']/rtbs:Balance)) div 1024" />

		<!-- SMS -->
		<xsl:variable name="SMS"
			select="sum(rtbs:Balances/rtbs:Balance[rtbs:BalanceName='NF_SMS' or
rtbs:BalanceName='NF_SMS_PREMIUM' or rtbs:BalanceName='F_SMS' or
rtbs:BalanceName='F_SMS_PREMIUM']/rtbs:Balance)" />

		<xsl:variable name="ExpiryDate" select="rtbs:Balances/rtbs:Balance[rtbs:BalanceName=$coreBName]/rtbs:AccountExpiration" />

		<!-- *************************************************************************************************** -->
		<!-- MENSAJE RETORNADO -->
		<xsl:value-of select="format-number($BS,'###.###.##0,00','espaniol')" />
		<xsl:value-of select="';'" />

		<xsl:variable name="day" select="substring($ExpiryDate,9,2)" />
		<xsl:variable name="month" select="substring($ExpiryDate,6,2)" />
		<xsl:variable name="year" select="substring($ExpiryDate,3,2)" />
		<xsl:value-of select="concat($day,'/',$month,'/',$year)" />
		<xsl:value-of select="';'" />

		<xsl:value-of select="format-number($BONO,'###.###.##0,00','espaniol')" />
		<xsl:value-of select="';'" />

		<xsl:value-of select="format-number($SEC_412,'####','espaniol')" />
		<xsl:value-of select="';'" />

		<xsl:value-of select="format-number($SEC_OTRAS,'####','espaniol')" />
		<xsl:value-of select="';'" />

		<xsl:value-of select="format-number($SEC_TODAS,'####','espaniol')" />
		<xsl:value-of select="';'" />

		<xsl:value-of select="format-number($SMS,'####','espaniol')" />
		<xsl:value-of select="';'" />

		<xsl:value-of select="format-number($MB,'########0,00','espaniol')" />
		<xsl:value-of select="';'" />

		<xsl:value-of select="format-number($MMS,'####','espaniol')" />
		<xsl:value-of select="';'" />

		<xsl:choose>
			<xsl:when test="contains(rtbs:COSName,'ZF')">
				<xsl:value-of select="substring-before(rtbs:COSName,' ZF')" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="rtbs:COSName" />
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>
</xsl:stylesheet>