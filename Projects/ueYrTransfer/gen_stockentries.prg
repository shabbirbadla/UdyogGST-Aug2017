Lparameters SqlConObj,_ndatasessionid,oHandle,ccDbName,ndbname,cdSta_Dt,cdEnd_Dt,noofunit

************************************************************************************************
*!*	** 		Generating Opening Stock Entries (ManuFacturing)
*!*	**		Method By : Shrikant S.
*!*	**		Use 	  : Used for Generating Opening Stock Entries(Manufacturing)
************************************************************************************************

Local nHandle, lcSqlStr, nRetVal,ncompid,sumGross,sumNetAmt
sumGross=0
sumNetAmt=0
ncompid=0
If Used('_newyeardet')
	Select _newyeardet
	ncompid=_newyeardet.compid
Endif

mAc_Name1="OPENING STOCK"
mAc_Name2="OPENING BALANCES"
mAc_Id1=0
mAc_Id2=0

minvsr=""
mcate=""
mdept=""

retString=""
*Do Form uefrm_select With _ndatasessionid,&oHandle To retString
Do Form form1 With _ndatasessionid,&oHandle To retString

oPBar.ProgStatus("Processing Stock Entries: "+ Alltrim(Transform(15))+ "%"  ,15)
If Len(retString)>2
	minvsr=Getwordnum(retString,1,"|")
	mcate=Getwordnum(retString,2,"|")
	mdept=Getwordnum(retString,3,"|")
Endif
lcSqlStr =	" SELECT * FROM LCODE WHERE ENTRY_TY = 'OS' "
nRetVal= SqlConObj.DataConn([EXE],ccDbName,lcSqlStr,[Tmp_Lcode],oHandle,_ndatasessionid,.T.)
If nRetVal<0
	Return .F.
Endif

Select Tmp_Lcode
Go Top
Entry_Tbl=Alltrim(Iif(!Empty(Tmp_Lcode.Bcode_nm),ALLTRIM(Tmp_Lcode.Bcode_nm),IIF(Tmp_Lcode.ext_vou=.t.,"",Tmp_Lcode.Entry_ty)))


lcSqlStr = "Select Top 1 ac_id from ac_mast where ac_name = ?mAc_Name1"
nRetVal= SqlConObj.DataConn([EXE],ccDbName,lcSqlStr,[_Tmp_acid],oHandle,_ndatasessionid,.T.)
If nRetVal<0
	Return .F.
Endif
If Used('_Tmp_acid')
	Select _Tmp_acid
	mAc_Id1=_Tmp_acid.ac_Id
	Use In _Tmp_acid
Endif
lcSqlStr = " Select Top 1 ac_id from ac_mast where ac_name = ?mAc_Name2"
nRetVal= SqlConObj.DataConn([EXE],ccDbName,lcSqlStr,[_Tmp_acid],oHandle,_ndatasessionid,.T.)
If nRetVal<0
	Return .F.
Endif
If Used('_Tmp_acid')
	Select _Tmp_acid
	mAc_Id2=_Tmp_acid.ac_Id
	Use In _Tmp_acid
Endif

lcSqlStr =	" SELECT GETDATE() as SysDate "
*lcSqlStr =	"SELECT convert(varchar(50),getdate(),103)+' '+convert(varchar(50),getdate(),108) as SysDate "
nRetVal= SqlConObj.DataConn([EXE],ccDbName,lcSqlStr,[_TmpSysDate],oHandle,_ndatasessionid,.T.)
If nRetVal<0
	Return .F.
Endif
cSysDate = Ttoc(_TmpSysDate.SysDate)
*cSysDate = _TmpSysDate.SysDate


lcSqlStr =	" SELECT * FROM OSMAIN WHERE 1=2 "			&& Temporary Main Table
nRetVal= SqlConObj.DataConn([EXE],ccDbName,lcSqlStr,[Tmp_Main],oHandle,_ndatasessionid,.T.)
If nRetVal<0
	Return .F.
Endif

lcSqlStr =	" SELECT * FROM OSITEM WHERE 1=2 "			&& Temporary Item Table
nRetVal= SqlConObj.DataConn([EXE],ccDbName,lcSqlStr,[Tmp_Item],oHandle,_ndatasessionid,.T.)
If nRetVal<0
	Return .F.
Endif

lcSqlStr =	" SELECT * FROM OSACDET WHERE 1=2 "			&& Temporary Acdet Table
nRetVal= SqlConObj.DataConn([EXE],ccDbName,lcSqlStr,[Tmp_AcDet],oHandle,_ndatasessionid,.T.)
If nRetVal<0
	Return .F.
Endif
If !Used('_actStk')
	Return
Endif

Upd_itbal=0
oPBar.ProgStatus("Processing Stock Entries: "+ Alltrim(Transform(20))+ "%"  ,20)

Select _actStk
reccnt=Reccount()
If reccnt <> 0
	oPBar.Show()
	lnIncVal = 80 / reccnt
	lninc=0
ENDIF

Select _actStk
Locate
Do While !Eof()
	Upd_itbal=1
	lninc=lninc+1
	oPBar.ProgStatus("Processing Opening Stock Entries: "+ Alltrim(Transform(Round((lninc /reccnt) *100,0)))+ "%"  ,(lninc * lnIncVal)+20)

	mWare_nm=_actStk.ware_nm
	mRule=_actStk.Rules
	mItemType=_actStk.ItType
	lmu_gcssr=""
	IF !TYPE('_actStk.u_gcssr')='U'
		mu_gcssr=Iif(_actStk.u_gcssr=1,.T.,.F.)			&& against Sales Return
	endif
	Select Tmp_Main
	Append Blank
	cInvNo=GenerateInvNo('OS', '', '', cdSta_Dt, '', '',Tmp_Lcode.invno_size,SqlConObj,_ndatasessionid,'OS',oHandle,ccDbName,cdSta_Dt,cdEnd_Dt,ndbname)
	cdocno=GenerateDocNo('OS',cdSta_Dt,'OS',SqlConObj,_ndatasessionid,oHandle,ccDbName,cdSta_Dt,cdEnd_Dt,ndbname)
	Replace entry_ty With 'OS', Tran_cd With 0, Date With cdSta_Dt, doc_no With cdocno, inv_no With cInvNo, ;
		Lock With .F., l_yn With Alltr(Str(Year(cdSta_Dt)))+"-"+Alltr(Str(Year(cdEnd_Dt))),u_choice With .T., ;
		party_nm With mAc_Name1, ac_Id With mAc_Id1,SysDate With cSysDate, user_name With musername, apgentime With cSysDate, apledtime With cSysDate, ;
		rule With mRule,  compid With ncompid ;
		,apgen With "YES",apled With "YES",apgenby With musername,apledby With musername ;
		,inv_sr With minvsr,Cate With mcate,Dept With mdept In Tmp_Main

	IF !TYPE('_actStk.u_gcssr')='U'
		REPLACE u_gcssr With mu_gcssr IN Tmp_Main
*		lmu_gcssr= "AND (_actStk.u_gcssr == 0)"
		lmu_gcssr= "AND mu_gcssr"
	ENDIF
	Sele Max(Val(itserial)) As citserial From Tmp_Item Into Cursor curItSerial		&& Generating itserial
	If curItSerial.citserial>0
		genitserial=curItSerial.citserial+1
	Else
		genitserial=1
	Endif
	If Used('curItSerial')
		Use In curItSerial
	ENDIF
*!*		MESSAGEBOX(lmu_gcssr)
*!*			MESSAGEBOX(&lmu_gcssr)
	Select _actStk
	Do While mWare_nm=_actStk.ware_nm And mRule=_actStk.Rules And mItemType=_actStk.ItType And mu_gcssr=Iif(_actStk.u_gcssr=1,.T.,.F.) And !Eof()
*!*		Do While mWare_nm=_actStk.ware_nm And mRule=_actStk.Rules And mItemType=_actStk.ItType And !Eof() &lmu_gcssr
		i=1
		Select Tmp_Item
		Append Blank

		Replace entry_ty With 'OS',Date With Tmp_Main.Date, doc_no With Tmp_Main.doc_no, inv_no With Tmp_Main.inv_no, ;
			l_yn With Tmp_Main.l_yn, ;
			it_code With _actStk.it_code,Item With _actStk.It_name, qty With _actStk.balqty, rate With _actStk.rate,;
			ware_nm With mWare_nm,party_nm With Tmp_Main.party_nm,doc_no With Tmp_Main.doc_no;
			,ac_Id With Tmp_Main.ac_Id,gro_amt With Round(_actStk.balqty * _actStk.rate,2),u_asseamt With  Round(_actStk.balqty * _actStk.rate,2);
			,pmkey With Tmp_Lcode.Inv_stk,compid With ncompid In Tmp_Item
		If noofunit >1
			Do While i<noofunit
				mx="Replace Qty"+Alltrim(Str(i))+" With _actStk.balqty"+Alltrim(Str(i))
				&mx
				mx="Replace Re_Qty"+Alltrim(Str(i))+" With 0 "
				&mx
				i=i+1
			Enddo
		Endif
		If Empty(itserial)
			Replace itserial With Padl(Allt(Str(genitserial)),5,"0") In Tmp_Item		&& Updating itserial
			Replace Item_no With Str(genitserial,5) In Tmp_Item							&& Updating item_no
			genitserial = genitserial + 1
		Endif

		sumGross=sumGross+Round(_actStk.balqty * _actStk.rate,2)
		sumNetAmt=sumNetAmt+Round(_actStk.balqty * _actStk.rate,2)
		Select _actStk
		Replace updateFlg With .T.
		If !Eof()
			Skip
		Endif
	Enddo

	Select Tmp_AcDet
	Append Blan
	Replace entry_ty With 'OS',Date With Tmp_Main.Date, doc_no With Tmp_Main.doc_no, inv_no With Tmp_Main.inv_no, ;
		l_yn With Tmp_Main.l_yn, ac_Name With Tmp_Main.party_nm,doc_no With Tmp_Main.doc_no;
		,ac_Id With Tmp_Main.ac_Id,Amount With sumNetAmt,Dept With Tmp_Main.Dept, Cate With Tmp_Main.Cate,amt_ty With 'DR';
		,PostOrd With 'A',acserial With '00001',compid With ncompid In Tmp_AcDet

	Append Blan
	Replace entry_ty With 'OS',Date With Tmp_Main.Date, doc_no With Tmp_Main.doc_no, inv_no With Tmp_Main.inv_no, ;
		l_yn With Tmp_Main.l_yn, ac_Name With mAc_Name2,doc_no With Tmp_Main.doc_no;
		,ac_Id With mAc_Id2,Amount With sumNetAmt,Dept With Tmp_Main.Dept, Cate With Tmp_Main.Cate,amt_ty With 'CR';
		,PostOrd With 'B',acserial With '00002',compid With ncompid In Tmp_AcDet

	Replace All oac_name With ac_Name+Allt(Str(Amount,17,2))+amt_ty In Tmp_AcDet

	Select Tmp_Main
	Replace gro_amt With sumGross
	Replace net_amt With sumNetAmt
	lcSqlStr = SqlConObj.GenInsert("OSMAIN","'Tran_cd'","","Tmp_Main",1)
	lcSqlStr = Strtran(lcSqlStr,Entry_Tbl+"MAIN",Alltrim(ndbname)+".."+Entry_Tbl+"MAIN")
	nRetVal= SqlConObj.DataConn([EXE],ccDbName,lcSqlStr,[],oHandle,_ndatasessionid,.T.)
	If nRetVal<0
		Return .F.
	Endif
	mtran_cd=0
	If nRetVal > 0 And mtran_cd <= 0
*		nRetVal = SqlConObj.DataConn([EXE],ccDbName," Select IDENT_CURRENT('OSMAIN') as Tran_cd ",[tmptbl_vw],oHandle,_ndatasessionid,.T.)
		nRetVal = SqlConObj.DataConn([EXE],ccDbName," Select IDENT_CURRENT('"+Alltrim(ndbname)+".."+Entry_Tbl+"main"+"') as Tran_cd ",[tmptbl_vw],oHandle,_ndatasessionid,.T.)
		If nRetVal > 0 And Used('tmptbl_vw')
			Select tmptbl_vw
			If Reccount() > 0
				mtran_cd = tmptbl_vw.Tran_cd
			Endif
			Select Tmp_Main
			Replace Tran_cd With mtran_cd In Tmp_Main
			Select Tmp_Item
			Replace All Tran_cd With mtran_cd In Tmp_Item
			Scan
				lcSqlStr = SqlConObj.GenInsert("OSITEM","","","Tmp_Item",1)
				lcSqlStr = Strtran(lcSqlStr,Entry_Tbl+"ITEM",Alltrim(ndbname)+".."+Entry_Tbl+"ITEM")
				nRetVal= SqlConObj.DataConn([EXE],ccDbName,lcSqlStr,[],oHandle,_ndatasessionid,.T.)
				If nRetVal<0
					Return .F.
				Endif
				Select Tmp_Item
			Endscan

			If nRetVal > 0
				Select Tmp_AcDet
				Replace All Tran_cd With mtran_cd In Tmp_AcDet
				Scan
					lcSqlStr = SqlConObj.GenInsert("OSACDET","","","Tmp_AcDet",1)
					lcSqlStr = Strtran(lcSqlStr,Entry_Tbl+"ACDET",Alltrim(ndbname)+".."+Entry_Tbl+"ACDET")
					nRetVal= SqlConObj.DataConn([EXE],ccDbName,lcSqlStr,[],oHandle,_ndatasessionid,.T.)
					If nRetVal<0
						Return .F.
					Endif
					Select Tmp_AcDet
				Endscan
			Endif
		Endif
		Select Tmp_AcDet
		Zap
		Select Tmp_Item
		Zap
		Select Tmp_Main
		Zap
		sumGross=0
		sumNetAmt=0

	Endif
	If mtran_cd<=0
		Return .F.
	Endif
	Select _actStk
Enddo

oPBar.Release()
oPBar = .Null.
Release oPBar

If Upd_itbal=1
	lcSqlStr =	" Execute "+Alltrim(ndbname)+".."+"USP_ENT_UPDATE_ITBALW "			&& Updating It_BalW Table
	nRetVal= SqlConObj.DataConn([EXE],ccDbName,lcSqlStr,"",oHandle,_ndatasessionid,.T.)
	If nRetVal<0

		Return .F.
	Endif
	If nRetVal>0
		lcSqlStr =	" Execute "+Alltrim(ndbname)+".."+"USP_ENT_UPDATE_ITBAL "			&& Updating It_Bal Table
		nRetVal= SqlConObj.DataConn([EXE],ccDbName,lcSqlStr,"",oHandle,_ndatasessionid,.T.)
		If nRetVal<0
			Return .F.
		Endif

	ENDIF
*!*		lcstadt=cdSta_Dt
*!*		lcenddt=cdEnd_Dt
*!*		If nRetVal>0
*!*			lcSqlStr =	" Execute "+Alltrim(ndbname)+".."+"Usp_Ent_Renumber_Trans 'OS', ?lcstadt, ?lcenddt, ?musername"
*!*			nRetVal= SqlConObj.DataConn([EXE],ccDbName,lcSqlStr,"",oHandle,_ndatasessionid,.T.)
*!*			If nRetVal<0
*!*				Return .F.
*!*			Endif

*!*		Endif
Endif

Wait Clear

If Used('Tmp_AcDet')
	Select Tmp_AcDet
	Use In Tmp_AcDet
Endif
If Used('Tmp_Item')
	Select Tmp_Item
	Use In Tmp_Item
Endif
If Used('Tmp_Main')
	Select Tmp_Main
	Use In Tmp_Main
Endif
If Used('_actStk')
	Select _actStk
	Use In _actStk
Endif
