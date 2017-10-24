-- FOR Interest 
IF NOT EXISTS(SELECT AC_NAME FROM AC_MAST WHERE ac_name ='Integrated GST Interest Payable A/C')
BEGIN
	INSERT INTO AC_MAST( [ac_name], [contact], [add1], [add2], [add3], [Ac_group_id], [group], [City_id], [city], [Ac_type_id], [typ], [zip], [phone], [phoner], [fax], [email], [cr_days], [i_tax], [notes], [type], [t_no], [t_rate], [t_amount], [i_rate], [i_days], [rate_level], [posting], [updown], [up_ledbal], [isgroup], [manadjust], [defa_ac], [cramount], [crallow], [salesman], [bankbr], [bankno], [st_type], [vend_type], [user_name], [sysdate], [sregn], [mailname], [state], [country], [t_pay], [designatio], [tds_accoun], [currency], [mobile], [Type1], [Exregno], [R_commis], [State_id], [Country_id], [Disc_ac], [Apgen], [Apgenby], [CompId], [SERAPL], [SEREXMPTD], [SERNOTI], [SERTY], [Area], [Zone], [COGROUP], [deactfrom], [ldeactive], [tds_code], [ded_type], [svc_cate], [Tds_lIgnRule], [Tds_lDedfrom], [Tds_lDedscto], [TDS_ExempLimit], [TDS_ReasonEL], [bsrcode], [tds_ex_tdt], [tds_ex_fdt], [Tds_Ex_Limit], [Tds_Tp], [Tds_Sc_Tp], [Tds_Ec_Tp], [FBTSEC], [FBEXPPER], [INTPAY], [DataExport], [DataImport], [iec_no], [appcostc], [SerDed_Type], [Ded_RefNo], [U_BKACTYPE], [U_MICRNO], [U_IFSCCODE], [AGRP_ID], [U_VENCODE], [Supp_type], [GSTIN], [District], [UID], [StateCode]) 
	VALUES ('Integrated GST Interest Payable A/C', '', '', '', '', 9, 'CURRENT LIABILITIES & PROVISIONS  ', 2, 'Mumbai', 66, 'IGST Payable', '', '  ', '  ', '  ', '  ', 0, '', '', 'B', '', 0.00, 0.000, 0.00, 0, 0, 'Entry by Entry ', 99, 0.00, 0, 0, 1, 0.00, 0, '', '', '', '  ', '', 'ADMIN ', '01/10/2015 16:39:23 ', '  ', 'Integrated GST Interest Payable A/C', 'Maharashtra   ', 'India ', ' ', '', '', '', '  ', '', '', 0, 15, 100, '', '  ', '', 399, ' ', 0, '', '', '', '', '  ', '01-01-1900 00:00:00', 0, '  ', '', '', 0, 0, 0, 0, '', '  ', '01-01-1900 00:00:00', '01-01-1900 00:00:00', 0, 0.00, 0.00, 0.00, '', 0.00, 0, '', '', '  ', 1, '', '', '', '', '', 0, '', '', '', null, null, null)
END 
IF NOT EXISTS(SELECT AC_NAME FROM AC_MAST WHERE ac_name ='Central GST Interest Payable A/C')
BEGIN
	INSERT INTO AC_MAST( [ac_name], [contact], [add1], [add2], [add3], [Ac_group_id], [group], [City_id], [city], [Ac_type_id], [typ], [zip], [phone], [phoner], [fax], [email], [cr_days], [i_tax], [notes], [type], [t_no], [t_rate], [t_amount], [i_rate], [i_days], [rate_level], [posting], [updown], [up_ledbal], [isgroup], [manadjust], [defa_ac], [cramount], [crallow], [salesman], [bankbr], [bankno], [st_type], [vend_type], [user_name], [sysdate], [sregn], [mailname], [state], [country], [t_pay], [designatio], [tds_accoun], [currency], [mobile], [Type1], [Exregno], [R_commis], [State_id], [Country_id], [Disc_ac], [Apgen], [Apgenby], [CompId], [SERAPL], [SEREXMPTD], [SERNOTI], [SERTY], [Area], [Zone], [COGROUP], [deactfrom], [ldeactive], [tds_code], [ded_type], [svc_cate], [Tds_lIgnRule], [Tds_lDedfrom], [Tds_lDedscto], [TDS_ExempLimit], [TDS_ReasonEL], [bsrcode], [tds_ex_tdt], [tds_ex_fdt], [Tds_Ex_Limit], [Tds_Tp], [Tds_Sc_Tp], [Tds_Ec_Tp], [FBTSEC], [FBEXPPER], [INTPAY], [DataExport], [DataImport], [iec_no], [appcostc], [SerDed_Type], [Ded_RefNo], [U_BKACTYPE], [U_MICRNO], [U_IFSCCODE], [AGRP_ID], [U_VENCODE], [Supp_type], [GSTIN], [District], [UID], [StateCode]) 
	VALUES ('Central GST Interest Payable A/C', '', '', '', '', 9, 'CURRENT LIABILITIES & PROVISIONS  ', 2, 'Mumbai', 66, 'CGST Payable', '', '  ', '  ', '  ', '  ', 0, '', '', 'B', '', 0.00, 0.000, 0.00, 0, 0, 'Entry by Entry ', 99, 0.00, 0, 0, 1, 0.00, 0, '', '', '', '  ', '', 'ADMIN ', '01/10/2015 16:39:23 ', '  ', 'Central GST Interest Payable A/C', 'Maharashtra   ', 'India ', ' ', '', '', '', '  ', '', '', 0, 15, 100, '', '  ', '', 399, ' ', 0, '', '', '', '', '  ', '01-01-1900 00:00:00', 0, '  ', '', '', 0, 0, 0, 0, '', '  ', '01-01-1900 00:00:00', '01-01-1900 00:00:00', 0, 0.00, 0.00, 0.00, '', 0.00, 0, '', '', '  ', 1, '', '', '', '', '', 0, '', '', '', null, null, null)
END 
IF NOT EXISTS(SELECT AC_NAME FROM AC_MAST WHERE ac_name ='State GST Interest Payable A/C')
BEGIN
	INSERT INTO AC_MAST( [ac_name], [contact], [add1], [add2], [add3], [Ac_group_id], [group], [City_id], [city], [Ac_type_id], [typ], [zip], [phone], [phoner], [fax], [email], [cr_days], [i_tax], [notes], [type], [t_no], [t_rate], [t_amount], [i_rate], [i_days], [rate_level], [posting], [updown], [up_ledbal], [isgroup], [manadjust], [defa_ac], [cramount], [crallow], [salesman], [bankbr], [bankno], [st_type], [vend_type], [user_name], [sysdate], [sregn], [mailname], [state], [country], [t_pay], [designatio], [tds_accoun], [currency], [mobile], [Type1], [Exregno], [R_commis], [State_id], [Country_id], [Disc_ac], [Apgen], [Apgenby], [CompId], [SERAPL], [SEREXMPTD], [SERNOTI], [SERTY], [Area], [Zone], [COGROUP], [deactfrom], [ldeactive], [tds_code], [ded_type], [svc_cate], [Tds_lIgnRule], [Tds_lDedfrom], [Tds_lDedscto], [TDS_ExempLimit], [TDS_ReasonEL], [bsrcode], [tds_ex_tdt], [tds_ex_fdt], [Tds_Ex_Limit], [Tds_Tp], [Tds_Sc_Tp], [Tds_Ec_Tp], [FBTSEC], [FBEXPPER], [INTPAY], [DataExport], [DataImport], [iec_no], [appcostc], [SerDed_Type], [Ded_RefNo], [U_BKACTYPE], [U_MICRNO], [U_IFSCCODE], [AGRP_ID], [U_VENCODE], [Supp_type], [GSTIN], [District], [UID], [StateCode]) 
	VALUES ('State GST Interest Payable A/C', '', '', '', '', 9, 'CURRENT LIABILITIES & PROVISIONS  ', 2, 'Mumbai', 66, 'SGST Payable', '', '  ', '  ', '  ', '  ', 0, '', '', 'B', '', 0.00, 0.000, 0.00, 0, 0, 'Entry by Entry ', 99, 0.00, 0, 0, 1, 0.00, 0, '', '', '', '  ', '', 'ADMIN ', '01/10/2015 16:39:23 ', '  ', 'State GST Interest Payable A/C', 'Maharashtra   ', 'India ', ' ', '', '', '', '  ', '', '', 0, 15, 100, '', '  ', '', 399, ' ', 0, '', '', '', '', '  ', '01-01-1900 00:00:00', 0, '  ', '', '', 0, 0, 0, 0, '', '  ', '01-01-1900 00:00:00', '01-01-1900 00:00:00', 0, 0.00, 0.00, 0.00, '', 0.00, 0, '', '', '  ', 1, '', '', '', '', '', 0, '', '', '', null, null, null)
END
-- FOR Late Fee 
IF NOT EXISTS(SELECT AC_NAME FROM AC_MAST WHERE ac_name ='Integrated GST Late Fee Payable A/C')
BEGIN
	INSERT INTO AC_MAST( [ac_name], [contact], [add1], [add2], [add3], [Ac_group_id], [group], [City_id], [city], [Ac_type_id], [typ], [zip], [phone], [phoner], [fax], [email], [cr_days], [i_tax], [notes], [type], [t_no], [t_rate], [t_amount], [i_rate], [i_days], [rate_level], [posting], [updown], [up_ledbal], [isgroup], [manadjust], [defa_ac], [cramount], [crallow], [salesman], [bankbr], [bankno], [st_type], [vend_type], [user_name], [sysdate], [sregn], [mailname], [state], [country], [t_pay], [designatio], [tds_accoun], [currency], [mobile], [Type1], [Exregno], [R_commis], [State_id], [Country_id], [Disc_ac], [Apgen], [Apgenby], [CompId], [SERAPL], [SEREXMPTD], [SERNOTI], [SERTY], [Area], [Zone], [COGROUP], [deactfrom], [ldeactive], [tds_code], [ded_type], [svc_cate], [Tds_lIgnRule], [Tds_lDedfrom], [Tds_lDedscto], [TDS_ExempLimit], [TDS_ReasonEL], [bsrcode], [tds_ex_tdt], [tds_ex_fdt], [Tds_Ex_Limit], [Tds_Tp], [Tds_Sc_Tp], [Tds_Ec_Tp], [FBTSEC], [FBEXPPER], [INTPAY], [DataExport], [DataImport], [iec_no], [appcostc], [SerDed_Type], [Ded_RefNo], [U_BKACTYPE], [U_MICRNO], [U_IFSCCODE], [AGRP_ID], [U_VENCODE], [Supp_type], [GSTIN], [District], [UID], [StateCode]) 
	VALUES ('Integrated GST Late Fee Payable A/C', '', '', '', '', 9, 'CURRENT LIABILITIES & PROVISIONS  ', 2, 'Mumbai', 66, 'IGST Payable', '', '  ', '  ', '  ', '  ', 0, '', '', 'B', '', 0.00, 0.000, 0.00, 0, 0, 'Entry by Entry ', 99, 0.00, 0, 0, 1, 0.00, 0, '', '', '', '  ', '', 'ADMIN ', '01/10/2015 16:39:23 ', '  ', 'Integrated GST Late Fee Payable A/C', 'Maharashtra   ', 'India ', ' ', '', '', '', '  ', '', '', 0, 15, 100, '', '  ', '', 399, ' ', 0, '', '', '', '', '  ', '01-01-1900 00:00:00', 0, '  ', '', '', 0, 0, 0, 0, '', '  ', '01-01-1900 00:00:00', '01-01-1900 00:00:00', 0, 0.00, 0.00, 0.00, '', 0.00, 0, '', '', '  ', 1, '', '', '', '', '', 0, '', '', '', null, null, null)
END
IF NOT EXISTS(SELECT AC_NAME FROM AC_MAST WHERE ac_name ='Central GST Late Fee Payable A/C')
BEGIN
	INSERT INTO AC_MAST( [ac_name], [contact], [add1], [add2], [add3], [Ac_group_id], [group], [City_id], [city], [Ac_type_id], [typ], [zip], [phone], [phoner], [fax], [email], [cr_days], [i_tax], [notes], [type], [t_no], [t_rate], [t_amount], [i_rate], [i_days], [rate_level], [posting], [updown], [up_ledbal], [isgroup], [manadjust], [defa_ac], [cramount], [crallow], [salesman], [bankbr], [bankno], [st_type], [vend_type], [user_name], [sysdate], [sregn], [mailname], [state], [country], [t_pay], [designatio], [tds_accoun], [currency], [mobile], [Type1], [Exregno], [R_commis], [State_id], [Country_id], [Disc_ac], [Apgen], [Apgenby], [CompId], [SERAPL], [SEREXMPTD], [SERNOTI], [SERTY], [Area], [Zone], [COGROUP], [deactfrom], [ldeactive], [tds_code], [ded_type], [svc_cate], [Tds_lIgnRule], [Tds_lDedfrom], [Tds_lDedscto], [TDS_ExempLimit], [TDS_ReasonEL], [bsrcode], [tds_ex_tdt], [tds_ex_fdt], [Tds_Ex_Limit], [Tds_Tp], [Tds_Sc_Tp], [Tds_Ec_Tp], [FBTSEC], [FBEXPPER], [INTPAY], [DataExport], [DataImport], [iec_no], [appcostc], [SerDed_Type], [Ded_RefNo], [U_BKACTYPE], [U_MICRNO], [U_IFSCCODE], [AGRP_ID], [U_VENCODE], [Supp_type], [GSTIN], [District], [UID], [StateCode]) 
	VALUES ('Central GST Late Fee Payable A/C', '', '', '', '', 9, 'CURRENT LIABILITIES & PROVISIONS  ', 2, 'Mumbai', 66, 'CGST Payable', '', '  ', '  ', '  ', '  ', 0, '', '', 'B', '', 0.00, 0.000, 0.00, 0, 0, 'Entry by Entry ', 99, 0.00, 0, 0, 1, 0.00, 0, '', '', '', '  ', '', 'ADMIN ', '01/10/2015 16:39:23 ', '  ', 'Central GST Late Fee Payable A/C', 'Maharashtra   ', 'India ', ' ', '', '', '', '  ', '', '', 0, 15, 100, '', '  ', '', 399, ' ', 0, '', '', '', '', '  ', '01-01-1900 00:00:00', 0, '  ', '', '', 0, 0, 0, 0, '', '  ', '01-01-1900 00:00:00', '01-01-1900 00:00:00', 0, 0.00, 0.00, 0.00, '', 0.00, 0, '', '', '  ', 1, '', '', '', '', '', 0, '', '', '', null, null, null)
END
IF NOT EXISTS(SELECT AC_NAME FROM AC_MAST WHERE ac_name ='State GST Late Fee Payable A/C')
BEGIN
	INSERT INTO AC_MAST( [ac_name], [contact], [add1], [add2], [add3], [Ac_group_id], [group], [City_id], [city], [Ac_type_id], [typ], [zip], [phone], [phoner], [fax], [email], [cr_days], [i_tax], [notes], [type], [t_no], [t_rate], [t_amount], [i_rate], [i_days], [rate_level], [posting], [updown], [up_ledbal], [isgroup], [manadjust], [defa_ac], [cramount], [crallow], [salesman], [bankbr], [bankno], [st_type], [vend_type], [user_name], [sysdate], [sregn], [mailname], [state], [country], [t_pay], [designatio], [tds_accoun], [currency], [mobile], [Type1], [Exregno], [R_commis], [State_id], [Country_id], [Disc_ac], [Apgen], [Apgenby], [CompId], [SERAPL], [SEREXMPTD], [SERNOTI], [SERTY], [Area], [Zone], [COGROUP], [deactfrom], [ldeactive], [tds_code], [ded_type], [svc_cate], [Tds_lIgnRule], [Tds_lDedfrom], [Tds_lDedscto], [TDS_ExempLimit], [TDS_ReasonEL], [bsrcode], [tds_ex_tdt], [tds_ex_fdt], [Tds_Ex_Limit], [Tds_Tp], [Tds_Sc_Tp], [Tds_Ec_Tp], [FBTSEC], [FBEXPPER], [INTPAY], [DataExport], [DataImport], [iec_no], [appcostc], [SerDed_Type], [Ded_RefNo], [U_BKACTYPE], [U_MICRNO], [U_IFSCCODE], [AGRP_ID], [U_VENCODE], [Supp_type], [GSTIN], [District], [UID], [StateCode]) 
	VALUES ('State GST Late Fee Payable A/C', '', '', '', '', 9, 'CURRENT LIABILITIES & PROVISIONS  ', 2, 'Mumbai', 66, 'SGST Payable', '', '  ', '  ', '  ', '  ', 0, '', '', 'B', '', 0.00, 0.000, 0.00, 0, 0, 'Entry by Entry ', 99, 0.00, 0, 0, 1, 0.00, 0, '', '', '', '  ', '', 'ADMIN ', '01/10/2015 16:39:23 ', '  ', 'State GST Late Fee Payable A/C', 'Maharashtra   ', 'India ', ' ', '', '', '', '  ', '', '', 0, 15, 100, '', '  ', '', 399, ' ', 0, '', '', '', '', '  ', '01-01-1900 00:00:00', 0, '  ', '', '', 0, 0, 0, 0, '', '  ', '01-01-1900 00:00:00', '01-01-1900 00:00:00', 0, 0.00, 0.00, 0.00, '', 0.00, 0, '', '', '  ', 1, '', '', '', '', '', 0, '', '', '', null, null, null)
END