*IF !([vuent] $ vchkprod) AND INLIST(.pcvtype,'IP','ST','PT','P1','VI','SR','OS','OB','GI','GR','HI','HR','DP','DR','BI','FP','FR','RP','RR','VR','BC','BD','BP','CP','JV') OR INLIST(.pcvtype,'J2','J3','B3','B4')&&Sandeep S. for TKT-7147 ON 05/04/2011
&&If Inlist(.pcvtype,'IP','ST','PT','P1','VI','SR','OS','OB','GI','GR','HI','HR','DP','DR','BI','FP','FR','RP','RR','VR','BC','BD','BP','CP','JV') Or Inlist(.pcvtype,'J2','J3','B3','B4')&&Sandeep S. for TKT-7147 ON 05/04/2011
*!*	IF INLIST(.pcvtype,'IP','ST','PT','P1','VI','SR','OS','OB','GI','GR','HI','HR','DP','DR','BI','FP','FR','RP','RR','VR','BC','BD','BP','CP','JV') OR INLIST(.pcvtype,'J2','J3','B3','B4','EI') && Changes done by Ajay Jaiswal on 24/01/2012 for EXIM
&& IF INLIST(.pcvtype,'IP','ST','PT','P1','VI','SR','OS','OB','GI','GR','HI','HR','DP','DR','BI','FP','FR','RP','RR','VR','BC','BD','BP','CP','JV') OR INLIST(.pcvtype,'J2','J3','B3','B4')&&Rup: entry_ty=J2 TKT-2647 &&TKT-794 GTA Add J3 &&TCS TKT-5692 Add B3,B4
&&IF INLIST(.pcvtype,'IP','ST','PT','P1','VI','SR','OS','OB','GI','GR','HI','HR','DP','DR','BI','FP','FR','RP','RR','VR','BC','BD','BP','CP','JV') &&changed by Ajay Jaiswal - Activate Excise Detail Button. Related to exbtn.vcx in Vouclass.scx
&& Inlist(.pcVtype,'EoldP','SoldB','ST','PT','VI','IP','OP','SR','OS','OB','GI','GR','HI','HR','DP','DR','BI','FP','FR','RP','RR','VR','BC','BD') &&Rup: Activate Excise Detail Button. Related to exbtn.vcx in Vouclass.scx
*!*	If Inlist(.pcvtype,'IP','ST','PT','P1','VI','SR','OS','OB','GI','GR','HI','HR','DP','DR','BI','FP','FR','RP','RR','VR','BC','BD','BP','CP','JV') Or Inlist(.pcvtype,'J2','J3','B3','B4','EI','PP','TH','RH','FH','EH')&& 'PP','TH','PH','FH','EH' Added By Rup for Bug-4885 on 21/09/2012  &&Commented by Priyanka for Export LC on 10022014 for Bug-21466,21467,21468
*!*	If Inlist(.pcvtype,'IP','ST','PT','P1','VI','SR','OS','OB','GI','GR','HI','HR','DP','DR','BI','FP','FR','RP','RR','VR','BC','BD','BP','CP','JV') Or Inlist(.pcvtype,'J2','J3','B3','B4','EI','PP','TH','RH','FH','EH','SI')&& 'PP','TH','PH','FH','EH' Added By Rup for Bug-4885 on 21/09/2012  &&Added by Priyanka for Export LC on 10022014  for Bug-21466,21467,21468		&&Commented by vasant on 18/07/2014 as per Bug 23384 - (Issue In Service Tax Credit Register).
*!*	If Inlist(.pcvtype,'IP','ST','PT','P1','VI','SR','OS','OB','GI','GR','HI','HR','DP','DR','BI','FP','FR','RP','RR','VR','BC','BD','BP','CP','JV') Or Inlist(.pcvtype,'J2','J3','B3','B4','EI','PP','TH','RH','FH','EH','SI','E1')&& 'PP','TH','PH','FH','EH' Added By Rup for Bug-4885 on 21/09/2012  &&Added by Priyanka for Export LC on 10022014  for Bug-21466,21467,21468		&&E1 Added by vasant on 18/07/2014 as per Bug 23384 - (Issue In Service Tax Credit Register).		&& commented by nilesh for Bug 25772 on 07/04/2015
*!*	If Inlist(.pcvtype,'IP','ST','PT','P1','VI','SR','OS','OB','GI','GR','HI','HR','DP','DR','BI','FP','FR','RP','RR','VR','BC','BD','BP','CP','JV') Or Inlist(.pcvtype,'J2','J3','B3','B4','EI','PP','TH','RH','FH','EH','SI','E1','PL')  && added by nilesh for bug 25772 on 07/04/2015 && Commented by Shrikant S. on 28/09/2016  for GST

*!*	If Inlist(.pcvtype,'IP','VI','ST','OS','OB','DP','DR','BI','FP','FR','VR','BC','BD','BP','CP','JV') Or Inlist(.pcvtype,'J2','J3','B3','B4','EI','PP','TH','RH','FH','EH','SI','PL','GA','J5','GB','GC','GD','C6','D6')  && Added by Shrikant S. on 28/09/2016 for GST && Commented by Shrikant S. on 06/02/2017 for GST
*!*	If Inlist(.pcvtype,'IP','VI','ST','OS','OB','DP','DR','BI','FP','FR','VR','BC','BD','BP','CP','JV') Or Inlist(.pcvtype,'J2','J3','B3','B4','EI','PP','TH','RH','FH','EH','SI','PL','GA','J5','GB')  && Added by Shrikant S. on 06/02/2017 for GST		&& Commented by Shrikant S. on 20/04/2017 for GST
*!*	If Inlist(.pcvtype,'IP','VI','ST','OS','OB','DP','DR','BI','FP','FR','VR','BC','BD','JV') Or Inlist(.pcvtype,'J2','J3','B3','B4','EI','PP','TH','RH','FH','EH','SI','PL','GA','J5','GB')  && Added by Shrikant S. on 20/04/2017 for GST	&& Commented  by Shrikant S. on 26/04/2017 for GST
If Inlist(.pcvtype,'IP','VI','ST','OS','DP','DR','BI','FP','FR','VR','JV') Or Inlist(.pcvtype,'J2','J3','B3','B4','EI','PP','TH','RH','FH','EH','SI','PL','GA','J5','GB','UB')  && Added  by Shrikant S. on 26/04/2017 for GST
	If "VOUCLASS" $ Upper(Set('classlib'))
	Else
		Set Classlib To vouclass Additive
	Endif
	.AddObject("cmdexdetail","VOUCLASS.cmdexbtn")
	.cmdexdetail.Visible=.T.
	.cmdexdetail.Enabled=.T.
	.cmdexdetail.Picture=apath+"bmp\additional_info.gif"
	.cmdexdetail.PicturePosition=1
	.cmdexdetail.Height=.cmdpickup.Height
	.cmdexdetail.Width=.cmdnarration.Width	&&+30
	.cmdexdetail.Top = .cmdnarration.Top+.cmdnarration.Height+5
	.cmdexdetail.Left = .cmdnarration.Left &&-.cmdexdetail.width-5
	.cmdexdetail.SpecialEffect=2
	.AddProperty("exclicked",.F.)
	Do Case

*		 Case !([vuent] $ vchkprod) AND Inlist(.pcvtype,'ST','PT','P1','VI','SR','OS','OB','GI','GR','HI','HR','DP','DR','BI','FP','FR','RP','RR','VR','BC','BD','JV')&&Sandeep S. for TKT-7147 ON 05/04/2011
*!*			CASE  INLIST(.pcvtype,'ST','PT','P1','VI','SR','OS','OB','GI','GR','HI','HR','DP','DR','BI','FP','FR','RP','RR','VR','BC','BD','JV')&&changed by Ajay Jaiswal		&&Commented by vasant on 18/07/2014 as per Bug 23384 - (Issue In Service Tax Credit Register).
*!*		Case  Inlist(.pcvtype,'PT','P1','VI','OS','OB','GI','GR','HI','HR','DP','DR','BI','FP','FR','RP','RR','VR','BC','BD','JV','E1')&&changed by Ajay Jaiswal			&&E1 Added by vasant on 18/07/2014 as per Bug 23384 - (Issue In Service Tax Credit Register).		&& Commented by Shrikant S. on 16/01/2017 for GST
		Case  Inlist(.pcvtype,'PT','P1','VI','OB','GI','GR','HI','HR','DP','DR','BI','FP','FR','RP','RR','VR','BC','BD','JV','E1')&&changed by Ajay Jaiswal			&& Added by Shrikant S. on 16/01/2017 for GST

*/Case Inlist(.pcVtype,'ST','PT','VI','IP','OP','SR','OS','OB','GI','GR','HI','HR','DP','DR','BI','FP','FR','RP','RR','VR','BC','BD')
*!*			If ([vuent] $ vchkprod) &&Sandeep for TKT-7147
*!*					.cmdexdetail.Visible=.F.
*!*			Endif
		.cmdexdetail.Caption = '\<Excise'
&&--->TKT-2647
	Case Inlist(.pcvtype,'J2','J3') &&TKT-2647 &&TKT-794 GTA Add J3
		.cmdexdetail.Caption = '\<Service Tax'
&&--->TKT-8320 GTA
		.cmdexdetail.AutoSize=.T.
&&<---TKT-8320 GTA

&&<---TKT-2647
&& Added By Rup For Bug-4885 on 21/09/2012 ---->
	Case Inlist(.pcvtype,'PP')
		.cmdexdetail.Caption = 'Payroll Details'
		.cmdexdetail.AutoSize=.T.
		.CmdServiceTax.Visible=.F.
	Case Inlist(.pcvtype,'TH')
		.cmdexdetail.Caption = 'TDS Details'
		.cmdexdetail.AutoSize=.T.
		.CmdServiceTax.Visible=.F.
	Case Inlist(.pcvtype,'RH')
		.cmdexdetail.Caption = 'PT Details'
		.cmdexdetail.AutoSize=.T.
		.CmdServiceTax.Visible=.F.
	Case Inlist(.pcvtype,'FH')
		.cmdexdetail.Caption = 'PF Details'
		.cmdexdetail.AutoSize=.T.
		.CmdServiceTax.Visible=.F.
	Case Inlist(.pcvtype,'EH')
		.cmdexdetail.Caption = 'ESIC Details'
		.cmdexdetail.AutoSize=.T.
		.CmdServiceTax.Visible=.F.
&& Added By Rup For Bug-4885 on 21/09/2012 <----

*!*		Case Inlist(.pcvtype,'BP','CP',"B3","B4") &&-->Rup 16/06/2009 TDS Payment Entry &&TCS TKT-5692 Add B3,B4		&& Commented by Shrikant S. on 20/04/2017 for GST
	Case Inlist(.pcvtype,"B3","B4") &&-->Rup 16/06/2009 TDS Payment Entry &&TCS TKT-5692 Add B3,B4		&& Added by Shrikant S. on 20/04/2017 for GST

		If ([vutds] $ vchkprod) &&-->Rup 02/08/2009
		
			.cmdexdetail.Caption = Iif(Inlist(.pcvtype,"B4"),'\<TCS Details','\<TDS Details') &&TCS TKT-5692 Add B3,B4
			.cmdexdetail.Width=.cmdnarration.Width
			.cmdexdetail.AutoSize=.T.&&<--Rup 16/06/2009 TDS Payment Entry
		Else
			.cmdexdetail.Visible=.F.
		Endif
&& Added by Shrikant S. on 05/10/2016 for GST 		&& Start
*!*		Case Inlist(.pcvtype,'GB')
*!*			.cmdexdetail.Caption = 'GST Details exc'
*!*			.cmdexdetail.AutoSize=.T.
*!*			.cmdexdetail.Width=.cmdnarration.Width
	Case Inlist(.pcvtype,'GA','J5','GB')
		.cmdexdetail.Caption = 'GST Details'
		.cmdexdetail.AutoSize=.T.
		.cmdexdetail.ToolTipText = 'GST Details'
		If .pcvtype="GB"
			.CmdServiceTax.Visible=.T.
		Else
			.CmdServiceTax.Visible=.F.
		Endif
	Case Inlist(.pcvtype,'ST')
		.cmdexdetail.Caption = 'Invoice Details'
		.cmdexdetail.AutoSize=.T.
		.CmdServiceTax.Visible=.F.

&& Commented by Shrikant S. on 06/02/2017 for GST		&& Start
*!*		Case Inlist(.pcvtype,'GC','GD','C6','D6')
*!*			.cmdexdetail.Caption = 'Supp. Details'
*!*			.cmdexdetail.AutoSize=.T.
&& Commented by Shrikant S. on 06/02/2017 for GST		&& End


&& Added by Shrikant S. on 05/10/2016 for GST 		&& End

&& added by Shrikant S. on 15/06/2017 for GST		&& Start
	Case Inlist(.pcvtype,'UB')
		.cmdexdetail.Caption = '\<Unreg. Bills'
		.cmdexdetail.AutoSize=.T.
		.CmdServiceTax.Visible=.F.
&& added by Shrikant S. on 15/06/2017 for GST		&& End
		
	Otherwise

		.cmdexdetail.Caption = '\<Other Details'
		.cmdexdetail.AutoSize= .T.
	Endcase
* Birendra : On 10 June 2011 :Start:
&&--->Rup TKT-9742 Add TDS Module Checking
*!*		If !([vuexc] $ vchkprod Or  [vuexp] $ vchkprod Or [vutex] $ vchkprod Or [vuser] $ vchkprod)
*!*		IF !([vuexc] $ vchkprod or  [vuexp] $ vchkprod or [vutex] $ vchkprod or [vuser] $ vchkprod OR [vutds] $ vchkprod) 					&& Commented By Shrikant S. on 07/08/2012 for Bug-5779
	If !([vuexc] $ vchkprod Or  [vuexp] $ vchkprod Or [vutex] $ vchkprod Or [vuser] $ vchkprod Or [vutds] $ vchkprod Or [vuisd] $ vchkprod Or [HRPay] $ vchkprod Or [vugst] $ vchkprod) 		&& Added By Shrikant S. on 07/08/2012 for Bug-5779
&&<---Rup TKT-9742 Add TDS Module Checking	Rup 4885 Add HRPay

		.cmdexdetail.Visible=.F.
	Endif
* Birendra : On 10 June 2011 :Start:

*	If (.pcvtype="JV" And !([vuser] $ vchkprod)) &&Rup 13Sep09
*!*		IF (.pcvtype="JV" AND [vutex] $ vchkprod)  OR (.pcvtype="JV" AND !([vuser] $ vchkprod)) && Birendra : On 10 June 2011		&& Commented By Shrikant S. on 07/08/2012 for Bug-5779
	If (.pcvtype="JV" And [vutex] $ vchkprod)  Or (.pcvtype="JV" And !([vuser] $ vchkprod Or [vuisd] $ vchkprod))  && Added By Shrikant S. on 07/08/2012 for Bug-5779
		.cmdexdetail.Visible=.F.
	ENDIF
	&& Added by Shrikant S. on 16/01/2017 for GST			&& Start
	If (.pcvtype="OS" )
		.cmdexdetail.Caption="\<Addl. Info."
		.cmdexdetail.Picture= apath+'bmp\Additional_Info.gif'
		.cmdexdetail.DisabledPicture 	= apath+'bmp\Additional_Info_off.gif'
		.cmdexdetail.ToolTipText 		= "Additional Info"
	ENDIF
	&& Added by Shrikant S. on 16/01/2017 for GST			&& End
		
Endif

&& Added by Shrikant S. on 05/10/2016 for GST 	&& Start

If Inlist(.pcvtype,'IB')
	.CmdServiceTax.Caption="Service Details"
	.CmdServiceTax.ToolTipText ="Service Details"
Endif

*!*	If Inlist(.pcvtype,'J7')
*!*		.txtpartyname.Enabled=.F.
*!*		.cmdacsearch.Enabled=.F.
*!*		.lblpartyname.Enabled=.F.
*!*		.cmdConsName.Enabled=.F.
*!*		.cmdpnsearch.Enabled=.F.
*!*	Endif


If Inlist(.pcvtype,'J5','GA','GB')
	.txtpartyname.Visible=.F.
	.cmdacsearch.Visible=.F.
	.lblpartyname.Visible=.F.
	.cmdConsName.Visible=.F.
	.cmdpnsearch.Visible=.F.
*!*		.CmdServiceTax.Caption="GST Rev. Details"			&& Commented by Shrikant S. on 24/07/2017 for GST
	.CmdServiceTax.Caption="GST RCM Details"				&& Added by Shrikant S. on 24/07/2017 for GST
	.CmdServiceTax.ToolTipText 		="GST RCM Details"
	If .addmode =.T. And Empty(Main_vw.party_nm)
		sql_con = .SqlConObj.DataConn([CHK],Company.DbName,"select Ac_id,ac_name from ac_mast where Ac_name='Central GST Payable A/C'",[tmpac],"This.Parent.nHandle",.DataSessionId,.F.)
		If sql_con >0
			Replace ac_id With tmpac.ac_id,party_nm With tmpac.ac_name In Main_vw
		Endif
	Endif
Endif


&& Added by Shrikant S. on 05/10/2016 for GST 	&& End


&&-->Ipop(Rup)
*IF INLIST(.pcvtype,'IP','OP') AND (([vuexc] $ vchkprod) OR ([vuinv] $ vchkprod))
*Birendra Bug-4543 on 31/07/2012 : Commented and modified with Below one:
If Inlist(.pcvtype,'IP','OP','WI','WO') And (([vuexc] $ vchkprod) Or ([vuinv] $ vchkprod))
	If Inlist(.pcvtype,'WI','WO') And ![procinv] $ vchkprod &&Birendra Bug-4543 on 31/07/2012
	Else

		If "VOUCLASS" $ Upper(Set('classlib'))
		Else
			Set Classlib To vouclass Additive
		Endif
		.AddObject("cmdBom","VOUCLASS.cmdBom")
		.cmdbom.Picture = apath+Iif(Inlist(.pcvtype,'ST','OP'),'bmp\finish_item.gif','bmp\raw_material.gif')
*	.cmdbom.CAPTION=IIF(INLIST(.pcvtype,'IP','OP'),' Work Order','BOM')
*Birendra Bug-4543 on 31/07/2012 : Commented and modified with Below one:
		.cmdbom.Caption=Iif(Inlist(.pcvtype,'IP','OP','WI','WO'),' Work Order','BOM')
		.cmdbom.Visible=.T.
		.cmdbom.Enabled=.T.
		.cmdbom.Width=.cmdnarration.Width
		.cmdbom.Top = .cmdnarration.Top+.cmdnarration.Height+60
		.cmdbom.Left = .cmdnarration.Left
		.cmdbom.SpecialEffect=2
	Endif
Endif
&&<--Ipop(Rup)
If 'trnamend' $ vchkprod
*	Do VouInit In MainPrg && Birendra : 22 mar 2011
* The above referencing is erroneous so commented by Amrendra for Bug-1994 On 07-02-2012
	Do vouinit In ueamendment.App  && Added By Amrendra for Bug-1994 On 07-02-2012
Endif

****** Added By Sachin N. S. on 13/02/2012 for TKT-9411 and Bug-660 Batchwise/Serialize Inventory ****** Start
If Vartype(oglblprdfeat)="O"
	If oglblprdfeat.udchkprod('serialinv')
		If Type('Lcode_vw.lCrtBatInv')='L' And Type('Lcode_vw.lPickBatInv')='L'
			If (lcode_vw.lcrtbatinv Or lcode_vw.lpickbatinv) And lcode_vw.v_item
				If Type('Thisform._BatchSerialStk')!='O'
					If File('ueSerializeInv.app')
						If !("BATCHSERIALSTK" $ Upper(Set('classlib')))
							Set Classlib To batchserialstk In "ueSerializeInv.app" Additive
						Endif
						.AddObject("_BatchSerialStk","BatchSerialStk.BatchSerialStk")
					Endif
				Endif
			Endif
		Endif
	Endif
Endif
****** Added By Sachin N. S. on 13/02/2012 for TKT-9411 and Bug-660 Batchwise/Serialize Inventory ****** End

****** Added by Raghu on 07/10/2011 for EXIM ---> Start
_mexim = .F.                              && Added by Ajay Jaiswal on 22/02/2012 for EXIM
_mdbk = .F.                               && Added by Ajay Jaiswal on 03/04/2012 for DBK
_mexim = oglblprdfeat.udchkprod('exim')   && Added by Ajay Jaiswal on 22/02/2012 for EXIM
_mdbk = oglblprdfeat.udchkprod('dbk')     && Added by Ajay Jaiswal on 03/04/2012 for DBK
If _mexim  Or _mdbk                                 && Added by Ajay Jaiswal on 21/02/2012 for EXIM & DBK
	If Inlist(.pcvtype,'LB')
		If !("UDEXIMCLASS" $ Upper(Set('classlib')))
			Set Classlib To UdEximClass.vcx Additive
		Endif
		.AddObject("oAqualibs","UdEximClass.clslibs")
	Endif
Endif
****** Added by Raghu on 07/10/2011 for EXIM ---> End

****** Added by Priyanka H. on 06/06/2012 for BUG-3807 ---> Start
If Inlist(.pcvtype,'FE','FD')
	.CmdServiceTax.Visible=.F.
Endif
****** Added by Priyanka H. on 06/06/2012 for BUG-3807 ---> End

&& Added by Shrikant S. on 27/06/2014 for Bug-23280		&& Start
If Vartype(oglblindfeat)='O'
	If oglblindfeat.udchkind('pharmaind')
		If Inlist(.pcvtype,'IP')
			.cmdbom.Enabled=.F.
		Endif
	Endif
Endif
&& Added by Shrikant S. on 27/06/2014 for Bug-23280		&& End

&& Added by Shrikant S. on 09/05/2016 FOR BUG-28289		&& Start
If Inlist(.pcvtype,'RN') And (([vuexc] $ vchkprod) Or ([vuinv] $ vchkprod))
	If "VOUCLASS" $ Upper(Set('classlib'))
	Else
		Set Classlib To vouclass Additive
	Endif
	.AddObject("cmdSelectBom","VOUCLASS.cmdBom")
	.cmdSelectBom.Picture = apath+'bmp\raw_material.gif'
	.cmdSelectBom.Caption="Work Order"
	.cmdSelectBom.Visible=.T.
	.cmdSelectBom.Enabled=.T.
	.cmdSelectBom.Width=.cmdnarration.Width
	.cmdSelectBom.Top = .cmdnarration.Top+.cmdnarration.Height+60
	.cmdSelectBom.Left = .cmdnarration.Left
	.cmdSelectBom.SpecialEffect=2
ENDIF
&& Added by Shrikant S. on 09/05/2016 FOR BUG-28289		&& End

***** Added by Sachin N. S. on 01/04/2016 for Bug-27503 -- Start
If Vartype(oglblprdfeat)="O"
	If oglblprdfeat.udchkprod('pos')
		If .pcvtype = 'PS'
			If Type('Thisform._udClsPointOfSale')!='O'
				If File('udVouPointOfSale.app')
					If !("UDCLSPOINTOFSALE" $ Upper(Set('classlib')))
						Set Classlib To udClsPointOfSale In "udVouPointOfSale.app" Additive
					Endif
					.AddObject("_udClsPointOfSale","udClsPointOfSale.udClsPointOfSale")
				Endif
			Endif
		Endif
	Endif
Endif
***** Added by Sachin N. S. on 01/04/2016 for Bug-27503 -- End
