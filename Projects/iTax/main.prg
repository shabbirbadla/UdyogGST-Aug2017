Lparameters lcMenuFind As String,lcDateFunc As String,llLoginfrm As Logical
*Birendra: for Installer 10.4(version change in Exe) with ref.bug-2315
&& For Login form required/not Raghu 160609
If Pcount() <> 3
	llLoginfrm = .T.
Endif
&& For Login form required/not Raghu 160609


Set Safety Off
Set Multilocks On
Set Deleted On
Set Century On
Set Date To british
Set Procedure To vu_udfs Additive
Set Procedure To sqlConnection Additive
Set Resource Off
Set Talk Off
Set Scoreboard Off
Set Escape Off
Set Exclusive Off
Set Exact Off
Set Clock Status
Set Multilocks On
Set Resource Off
Set Help On

Application.Visible = .F.
_vfp.Visible        = .F.
_Screen.Visible     = .F.

&&Changes done by vasant on 28/01/2012 as per Bug 1760 - The Application is Opeing Default New Company Master page even when Companies are already Created. (start)
_CopyUeConFile = .T.
_muecon = "uecon.uxe"
If File(_muecon)
	Try
		lcVFPEncryptionFile = Filetostr(_muecon)
		Set Library To &_muecon AddI
		If Len(lcVFPEncryptionFile) = 122880 ;
				and Strconv(Hash(lcVFPEncryptionFile,5),15) == '20A7D4AF02E62A362CE44FCBAB6EB5FE';
				and Strconv(Hash(lcVFPEncryptionFile,4),15) == 'DBD1EC320842ED0DB1A4DAE26F0513E4DF1F9D1C65FB93D896E553940ACFA408479EDFBE78FCEA9901915384E5FBC1C50CCD00709C0CD870CA8A4C8BC40676EF'
			_CopyUeConFile = .F.
		Else
			Release Library &_muecon
		Endif
	Catch To errObj
		*	=Messagebox(errObj.Message,16,'Udyog Admin')
	Endtry
Endif
If _CopyUeConFile = .T.
	Try
		_mFileContents = Filetostr("ueconexe.uxe")
		If Type('_mFileContents') <> 'C'
			=Messagebox(_muecon+" file not found",0+16,'Udyog Admin')
		Else
			=Strtofile(_mFileContents,_muecon)
		Endif
	Catch To errObj
		=Messagebox(errObj.Message,16,'Udyog Admin')
	Endtry
	If File(_muecon)
		lcVFPEncryptionFile = Filetostr(_muecon)
		Set Library To &_muecon AddI
		If Len(lcVFPEncryptionFile) = 122880 ;
				and Strconv(Hash(lcVFPEncryptionFile,5),15) == '20A7D4AF02E62A362CE44FCBAB6EB5FE';
				and Strconv(Hash(lcVFPEncryptionFile,4),15) == 'DBD1EC320842ED0DB1A4DAE26F0513E4DF1F9D1C65FB93D896E553940ACFA408479EDFBE78FCEA9901915384E5FBC1C50CCD00709C0CD870CA8A4C8BC40676EF'
			_CopyUeConFile = .F.
		Endif
	Endif
	If _CopyUeConFile = .T.
		=Messagebox("Unable to copy file "+_muecon,16,'Udyog Admin')
		Retu .F.
	Endif
Endif
&&Changes done by vasant on 28/01/2012 as per Bug 1760 - The Application is Opeing Default New Company Master page even when Companies are already Created. (end)

*!*	*!*	IF DATE() <> CTOD('30/09/08')
*!*	*!*		MESSAGEBOX("Demo version...",0,[UDYOG i-TAX])
*!*	*!*		QUIT
*!*	*!*		RETURN .F.
*!*	*!*	ENDIF

Declare Integer GetPrivateProfileString In Win32API As GetPrivStr ;
	string cSection, String cKey, String cDefault, String @cBuffer, ;
	integer nBufferSize, String cINIFile
Declare Integer WritePrivateProfileString In Win32API As WritePrivStr ;
	string cSection, String cKey, String cValue, String cINIFile
Declare Integer GetProfileString In Win32API As GetProStr ;
	string cSection, String cKey, String cDefault, ;
	string @cBuffer, Integer nBufferSize
Declare Integer Beep In kernel32 Integer pn_Freq,Integer pn_Duration

Declare Integer GetCurrentProcessId In kernel32  && get Application Process ID

Public mvu_Checkint,mvu_Splittbl,mvu_MenuType 				&& DTS Releated Public Variables

Public apath,mvu_backend,mvu_server,mvu_user,mvu_pass,chqcon,musername,ousername,ocompany_name,ocompany_year,vchkprod,;
	icopath,msgsvr,killapp,ProcessID,varyear,namecomp,vfromwherelogin,loginsuccess,nameuser,co_yr,company,coadditional,;
	passreturn,forceexit,yvariable,tbrdesktop,statdesktop,cmenuname,exitclick,exitonce,rptfilename,vumess,treedesktop,;
	addbutton1,editbutton1,printbutton1,deletebutton1,ctrlkey,xapps,applicationshutoff,appprocid,runinstanceapp,;
	AppSessionId,_StuffObj,nTrypassword,storeusername,OneKey_Server,OneKey_user,OneKey_Pass,mvu_MenuType,_Defaultdb,;
	mvu_Auto_object,mvu_User_Roles,iTaxAppPath,iTaxDbPath,GlobalObj,lrelogin,lLoginform,mvu_User_Name,SoftDbPath,UdNewTrigEnbl	&&vasant060410a	&&vasant041209	&&vasant16/11/2010	Changes done for VU 10 (Standard/Professional/Enterprise)
musername = '' &&Changes done by Vasant on 18/05/2011 as per TKT-8101 (Error coming while running  XML Integration Utility in scheduler)
&&TKT-6529 Rup 29/03/11--->
Public pApplCode,pApplName,pApplId &&TKT-6529 Rup 29/03/11
Declare Integer GetCurrentProcessId  In kernel32
pApplId =GetCurrentProcessId()
pApplName=Alltrim(Justfname(Sys(16)))
pApplCode="ud"+"PID"+Alltrim(Str(pApplId))+"DTM"+Dtos(Date())+Strtran(Time(),":","")
&&<---TKT-6529 Rup 29/03/11

&&For Integration - Capturing Company Id &&17/11/2009
Public	mvu_cDateFunc
mvu_cDateFunc = lcDateFunc
mvu_User_Roles = ''		&& Added By Sachin N. S. on 07/04/2010 for TKT-912
&&17/11/2009
UdNewTrigEnbl	= .F.	&&vasant16/11/2010	Changes done for VU 10 (Standard/Professional/Enterprise)
Local mudProdCode

Public mvu_Backimg,mvu_Position,CompanySetting		&&Changes done by Vasant on 30/04/2013 as per Bug 7303(Barcode Printing Details).			&& Wallpaper Related

appprocid = GetCurrentProcessId()
AppSessionId = 0

Public vu_s1,vu_p1,vu_sr1,vu_pr1,vu_so1,vu_po1,vu_ar1,vu_dc1,vu_cp1,vu_bp1,vu_jv1,vu_ip1,;
	vu_op1,vu_dn1,vu_cn1,vu_pc1,vu_ir1,vu_ii1,vu_es1,vu_b1,vu_ss1,vu_sq1,vu_br1,vu_cr1,;
	vu_ep1,vu_pl1,vu_sp1,vu_pi1,vu_li1,vu_lr1,vu_i1,vu_r1,vu_gi1,vu_gr1,vu_hi1,vu_hr1,;
	vu_bi1,vu_rp1,vu_fp1,vu_dp1,vu_rr1,vu_fr1,vu_dr1,vu_wi1,vu_wo1,vu_gt1,vu_st1,vu_bo1,;
	vu_ai1,vu_usercnt

Public vu_si1,vu_sd1,vu_sc1,vu_cd1,vu_cc1,vu_ed1,vu_sb1,vu_vi1,vu_ct1,vu_tr1,vu_eq1

Store .F. To vu_si1,vu_sd1,vu_sc1,vu_cd1,vu_cc1,vu_ed1,vu_sb1,vu_vi1,vu_ct1,vu_tr1,vu_eq1

Store .F. To vu_s1,vu_p1,vu_sr1,vu_pr1,vu_so1,vu_po1,vu_ar1,vu_dc1,vu_cp1,vu_bp1,vu_jv1,vu_ip1,;
	vu_op1,vu_dn1,vu_cn1,vu_pc1,vu_ir1,vu_ii1,vu_es1,vu_b1,vu_ss1,vu_sq1,vu_br1,vu_cr1,;
	vu_ep1,vu_pl1,vu_sp1,vu_pi1,vu_li1,vu_lr1,vu_i1,vu_r1,vu_gi1,vu_gr1,vu_hi1,vu_hr1,;
	vu_bi1,vu_rp1,vu_fp1,vu_dp1,vu_rr1,vu_fr1,vu_dr1,vu_wi1,vu_wo1,vu_gt1,vu_st1,vu_bo1,;
	vu_ai1

mvu_MenuType = Iif(Type('lcMenufind') = 'L',[M],lcMenuFind)		&& Menu Type
*!*	mudProdCode = enc('iTax')			&& Defining Product Code
*!*	mudProdCode = enc('USquare')
*!*	mudProdCode = enc('VudyogMFG')
*!*	mudProdCode = enc('VudyogTRD')
apath = Allt(Fullpath(Curd()))

*!*	icopath= apath + "bmp\ueIcon.ico"	&&	Commented By Sachin N. S. on 22/07/2009
icopath = ""

Store '' To varyear,namecomp,nameuser
Store '' To ocompany_name,ousername,killapp,ProcessID
chqcon      = 0
mvu_backend = []
mvu_server  = []
mvu_user    = []
mvu_pass    = []
passreturn  = 1
vumess		= ''
*!*	vumess = 'UDYOG iTAX'
*!*	vumess = 'USQUARE'
*!*	vumess = 'Vudyog MFG'
*!*	vumess = 'Vudyog TRD'

Local iniFilePath
iniFilePath = apath+"visudyog.ini"
If !File(iniFilePath)
	Messagebox("Configuration file not found",16,vumess)
	Retu .F.
Endif

mvu_one     = Space(2000)
mvu_two     = 0
mvu_two	    = GetPrivStr([Settings],"Backend", "", @mvu_one, Len(mvu_one), iniFilePath)
mvu_backend = Left(mvu_one,mvu_two)
mvu_two     = GetPrivStr([DataServer],"Name", "", @mvu_one, Len(mvu_one), iniFilePath)
mvu_server  = Left(mvu_one,mvu_two)
mvu_two     = GetPrivStr([DataServer],onencrypt(enc("User")), "", @mvu_one, Len(mvu_one), iniFilePath)
mvu_user    = Left(mvu_one,mvu_two)
mvu_two     = GetPrivStr([DataServer],onencrypt(enc("Pass")), "", @mvu_one, Len(mvu_one), iniFilePath)
mvu_pass    = Left(mvu_one,mvu_two)
mvu_backend = Iif(Empty(mvu_backend),"0",mvu_backend)
mvu_two     = GetPrivStr([1KeyServer],"Name", "", @mvu_one, Len(mvu_one), iniFilePath)
OneKey_Server = Left(mvu_one,mvu_two)
mvu_two     = GetPrivStr([1KeyServer],onencrypt(enc("User")), "", @mvu_one, Len(mvu_one), iniFilePath)
OneKey_user = Left(mvu_one,mvu_two)
mvu_two     = GetPrivStr([1KeyServer],onencrypt(enc("Pass")), "", @mvu_one, Len(mvu_one), iniFilePath)
OneKey_Pass = Left(mvu_one,mvu_two)
mvu_two		= GetPrivStr([Settings],"Title", "", @mvu_one, Len(mvu_one), iniFilePath)
lcvumess  	= Left(mvu_one,mvu_two)
vumess      = Iif(Empty(lcvumess),vumess,lcvumess)
mvu_two		= GetPrivStr([Settings],"XFile", "", @mvu_one, Len(mvu_one), iniFilePath)
xapps	  	= Left(mvu_one,mvu_two)
mvu_two 	= GetPrivStr([Settings],"iTaxAppPath", "", @mvu_one, Len(mvu_one), iniFilePath)
iTaxAppPath = Iif(Empty(Left(mvu_one,mvu_two)),apath,Left(mvu_one,mvu_two))
iTaxAppPath = Iif(Right(iTaxAppPath,1)='\',iTaxAppPath,iTaxAppPath+"\")
mvu_two 	= GetPrivStr([Settings],"iTaxDbPath", "", @mvu_one, Len(mvu_one), iniFilePath)
SoftDbPath	= Left(mvu_one,mvu_two)	&&vasant060410a
iTaxDbPath 	= Iif(Empty(Left(mvu_one,mvu_two)),apath+"Database\",Left(mvu_one,mvu_two))
iTaxDbPath 	= Iif(Right(iTaxDbPath,1)='\',iTaxDbPath,iTaxDbPath+"\")
mvu_Splittbl = ""
mvu_Checkint = "NO"

mvu_two		 = GetPrivStr([Settings],"Backimage", "", @mvu_one, Len(mvu_one), iniFilePath)
lcBackimg  	 = Left(mvu_one,mvu_two)
mvu_Backimg  = Iif(Empty(lcBackimg),'',lcBackimg)

mvu_two		 = GetPrivStr([Settings],"Position", "", @mvu_one, Len(mvu_one), iniFilePath)
lnPosition   = Left(mvu_one,mvu_two)
mvu_Position = Iif(Empty(lcBackimg),1,Val(lnPosition))

*!*	Backimage = Itaxback.Tif
*!*	Position  = 1

_Screen.Caption  = vumess

If Empty(xapps)
	=Messagebox('In configuration file Xfile path cannot be empty.',16,vumess)
	Return .F.
Else
	If !File(xapps)
		=Messagebox('In configuration file specify application file is not found.',16,vumess)
		Return .F.
	Endif
Endif

On Shutdown applicationshutoff.appshutoff
On Key Label Shift+f12 applicationshutoff.appshutoff

Set Classlib To sqlConnection In &xapps Additive && Setting Class library

applicationshutoff = Createobject("Onshutdown")
_StuffObj = Createobject("_stuff")

********* Added By Sachin N. S. on 16/05/2009 ********* Start
Set Classlib To UdGeneral.vcx Additive && Setting Class library
GlobalObj = Createobject("UdGeneral")
&&vasant060410
If Type('GlobalObj') != 'O'
	Retu .F.
Endif
&&vasant060410
vumess = GlobalObj.getpropertyval("vumess")
********* Added By Sachin N. S. on 16/05/2009 ********* End

If mvu_backend # "0"
	Do Case
		Case Empty(mvu_server)
			Messagebox("ERROR !!!, Data server not defined",32,vumess)
			Retu .F.
		Case Empty(mvu_user)
			Messagebox("ERROR !!!, User name not defined",32,vumess)
			Retu .F.
			*!*			Case Empty(OneKey_Server)
			*!*				Messagebox("ERROR !!!, 1Key server not defined",32,vumess)
			*!*				Retu .F.
			*!*			Case Empty(OneKey_user)
			*!*				Messagebox("ERROR !!!, 1Key user not defined",32,vumess)
			*!*				Retu .F.
	Endcase
Endif

m_sysvarv1 	= enc(Dtoc(Date()))
m_sysvar19 	= enc(Str(-1))
If File('Vudyog.Mem')
	Rest From vudyog AddI
Endif
m_sysvar19  = enc(Str(Val(dec(m_sysvar19))+1))
*Save To vudyog All Like m_*		&&Commented by vasant on 28/01/2012 as we are not using this file anywhere.

Close Data All	&& closing database invoice which is automatically opened with lmain

On Error Do errorprocformain With Error()
Local sqlconobj
sqlconobj=Newobject('sqlconnudobj',"sqlconnection",xapps)
applicationshutoff = Createobject("Onshutdown")
_StuffObj = Createobject("_stuff")

On Error
traperror = Createobject("traperrormsg")
On Error traperror.errorroutine(Error(), Message( ), Message(1), Program( ), Lineno( ))

lcdisplayvalue=[ ]

Do Form spl  &&ash Rpp
Read Events

If _StuffObj.GetPropAPI()=0
	=_StuffObj.appmutex() && Check Session and Set Property (API)
Else
	=_StuffObj.SetPropAPI() && Set Property ( API )
Endif

********* Added for Period Lock ********* Start
*!*	nhandle1=0
*!*	lcSqlstr = "SELECT getdate() as date"
*!*	nretval = sqlconobj.dataconn('EXE','master',lcSqlstr,"_sysdate","nhandle1")
*!*	If nretval<0
*!*		Return .F.
*!*	Endif
*!*	If _sysdate.Date>Ctod('26/07/2010')
*!*		Return .F.
*!*	Endif
*!*	nretval=sqlconobj.sqlconnclose("nHandle1") && Connection Close

nhandle1=0
lcSqlstr = "SELECT getdate() as date"
nretval = sqlconobj.dataconn('EXE','master',lcSqlstr,"_sysdate","nhandle1")
If nretval<0
	Return .F.
Endif
*!*	If _sysdate.Date>Ctod('26/07/2009')
*!*		=Messagebox("Hi, its time to upgrade your software. Please contact your registered software vendor.",0+16,vuMess)
*!*		nretval=sqlconobj.sqlconnclose("nHandle1")
*!*		Return .F.
*!*	Endif

*!*	If _sysdate.Date>Ctod('26/09/2009')
*!*		=Messagebox("Hi, its time to upgrade your software. Please contact your registered software vendor.",0+16,vumess)
*!*		nretval=sqlconobj.sqlconnclose("nHandle1")
*!*		Return .F.
*!*	Endif

*!*	If _sysDate.Date > Ctod('26/09/2009')
*!*		=Messagebox("It is for the purpose of testing.",0+16,vuMess)
*!*	*!*		Return .F.
*!*	Endif
*!*	nretval=sqlconobj.sqlconnclose("nHandle1")

nretval=sqlconobj.sqlconnclose("nHandle1") && Added By Sachin N. S. on 08/07/2010 for TKT-1473


********* Added for Period Lock ********* End

Local lcbuffer,llshowintro
lcbuffer = " " + Chr(0)
llshowintro = .T.
If GetPrivStr("Defaults", "ShowIntroForm", "", @lcbuffer, Len(lcbuffer), Curdir() + "visudyog.ini") > 0
	llshowintro = (Val(lcbuffer) = 0)
Endif

***** Added By Rupesh P. on 10/04/2010 for TKT-914 ***** Start
*!*	IF llshowintro=.t. &&ShowTips
*!*		DO uetipsapp.app
*!*	ENDIF
***** Added By Rupesh P. on 10/04/2010 for TKT-914 ***** End

Local lcontinue, lresume
lcontinue=.T.		&& its default must be .T.

_Defaultdb = "Vudyog"
nhandle =0
nhandle1 =0
msqlstr="SELECT [Name] FROM Master..sysDatabases WHERE [Name] = ?_Defaultdb"
nretval=sqlconobj.dataconn('EXE','master',msqlstr,"_co_mast","nHandle")
If nretval<0
	Return .F.
Endif
nretval=sqlconobj.sqlconnclose("nHandle")		&& Added By Sachin N. S. on 29/04/2010

If Reccount('_co_mast') = 0
	mvu_MenuType = Iif(mvu_MenuType = [L],[M],mvu_MenuType)
	Do Form defafrmdb
Else

	&&Rup 17/04/2010 TKT-914--->
	If llshowintro=.T. &&ShowTips
		nhandle =0
		msqlstr="SELECT [Name] from sysobjects where [name]='TipsMaster' and xtype='U'"
		nretval=sqlconobj.dataconn('EXE','vudyog',msqlstr,"chktips","nHandle1")
		If nretval<0
			Return .F.
		Endif
		nretval=sqlconobj.sqlconnclose("nHandle1") && Added By Sachin N. S. on 29/04/2010
		Select 	chktips
		If Reccount('chktips') > 0
			Use In chktips
			Do uetipsapp.App
		Endif
	Endif
	&&<---Rup 17/04/2010 TKT-914

	If mvu_MenuType = [L]			&& DTS Main
		lcSqlstr = "SELECT Co_Name FROM Vudyog..Co_Mast WHERE Import = 1"
		nretval = sqlconobj.dataconn('EXE',_Defaultdb,lcSqlstr,"_Import_cur","nhandle1")
		If nretval<0
			Return .F.
		Endif
		nretval=sqlconobj.sqlconnclose("nHandle1") && Connection Close
		Select _Import_cur
		If Reccount("_Import_cur") = 0
			exitclick = .T.
			Messagebox("Please create company before DTS...",64,vumess)
			Return
		Endif
		msqlstr = "SELECT [Name] FROM Master..sysdatabases WHERE [Name] = 'ITaxdts'"
		nretval = sqlconobj.dataconn('EXE','master',msqlstr,"_ITAX_DTS","nHandle")
		If nretval<0
			Return .F.
		Endif
		nretval=sqlconobj.sqlconnclose("nHandle") && Added By Sachin N. S. on 08/07/2010 for TKT-1473
		If Reccount("_ITAX_DTS") = 0
			Do Form defafrmdb
		Endif
	Endif
Endif

nretval=sqlconobj.sqlconnclose("nHandle") && Connection Close
If nretval<0
	Return .F.
Endif

If mvu_MenuType = [X]					  && Xml Generation [Start]
	nretval=sqlconobj.dataconn('EXE',_Defaultdb,"SELECT TOP 1 Co_Name FROM Tbl_Ui2uix","_Vu_Ui2ui","nHandle1")
	If nretval<0
		Return .F.
	Endif
	nretval=sqlconobj.sqlconnclose("nHandle1") && Added By Sachin N. S. on 29/04/2010

	Select _Vu_Ui2ui
	If Reccount("_Vu_Ui2ui") = 0
		Return .F.
	Endif
Endif									  && Xml Generation [End]

nretval=sqlconobj.sqlconnclose("nHandle") && Connection Close
If nretval<0
	Return .F.
Endif

&& For Login form required/not --- Raghu 160609
lLoginform = llLoginfrm									&& Login Form Show if the value is true
lLoginform = Icase(Alltrim(mvu_MenuType)=="B",.F.,Alltrim(mvu_MenuType)=="X",.F.,lLoginform)	&& Disable login form for Backup/Xml modules.
&& For Login form required/not --- Raghu 160609

_MainScrnDataSession = Set("Datasession") &&vasant16/11/2010	Changes done for VU 10 (Standard/Professional/Enterprise)
Do While .T.
	Set DataSession To _MainScrnDataSession 	&&vasant16/11/2010	Changes done for VU 10 (Standard/Professional/Enterprise)
	nhandle=0

	Release company,coadditional
	Release idleapplication,shutOffTimer && Added By Pankaj B. on 05-03-2015 for Bug-25365
	Public company,coadditional
	Public idleapplication,shutOffTimer  && Added By Pankaj B. on 05-03-2015 for Bug-25365


	Do Case
			&&Case Alltrim(mvu_MenuType) == [C]		&& Multi-company &&COMMENTED BY SATISH PAL DATED 21/03/2013 FOR BUG-8205
			*!*		Case INLIST(Alltrim(mvu_MenuType),[C],[U])			&& Multi-company &&&ADDED BY SATISH PAL DATED 21/03/2013 FOR BUG-8205
			*!*			nretval=sqlconobj.dataconn('EXE',_Defaultdb,"select * from co_mast where com_type = 'M'","_co_mast","nHandle")
		Case Alltrim(mvu_MenuType)==[U]			&& Multi-company &&&ADDED BY SATISH PAL DATED 21/03/2013 FOR BUG-8205
			nretval=sqlconobj.dataconn('EXE',_Defaultdb,"select * from co_mast","_co_mast","nHandle")
		Case Alltrim(mvu_MenuType)==[C]			&& Multi-company &&&ADDED BY SATISH PAL DATED 21/03/2013 FOR BUG-8205
			nretval=sqlconobj.dataconn('EXE',_Defaultdb,"select * from co_mast where com_type = 'M'","_co_mast","nHandle")
		Otherwise
			nretval=sqlconobj.dataconn('EXE',_Defaultdb,"select * from co_mast where com_type <> 'M'","_co_mast","nHandle")
	Endcase

	&& Commented By raghu - for in below inlist condition is not checking exact characters/string
	************ Changed By Rupesh on 03/01/2008 for Multicompany *********** Start
	*!*		if !inlist(alltrim(mvu_MenuType),[C]) &&Rup
	*!*			messagebox(mvu_MenuType,0,"if")
	*!*			nretval=sqlconobj.dataconn('EXE',_Defaultdb,"select * from co_mast where com_type <> 'M'","_co_mast","nHandle")
	*!*		else
	*!*			messagebox(mvu_MenuType,0,"else")
	*!*			nretval=sqlconobj.dataconn('EXE',_Defaultdb,"select * from co_mast where com_type = 'M'","_co_mast","nHandle")
	*!*		endif
	************ Changed By Rupesh on 03/01/2008 for Multicompany *********** End
	&& Commented By raghu - for in below inlist condition is not checking exact characters/string

	If nretval<0
		Return .F.
	Endif

	nretval=sqlconobj.sqlconnclose("nHandle") && Connection Close
	If nretval<0
		Return .F.
	Endif

	*********** Added By Sachin N. S. on 17/07/2009 *********** Start

	Select _co_Mast
	If Type('_co_Mast.prodCode')='U'
		&&Changes has been done as per TKT-6470 (Multilanguage support - Tested with English & Japanese Language) on 24/02/2011
		*lcSqlstr = " Alter Table co_mast Add prodCode Varchar(30) "
		lcSqlstr = " Alter Table co_mast Add prodCode Varbinary(30) "
		&&Changes has been done as per TKT-6470 (Multilanguage support - Tested with English & Japanese Language) on 24/02/2011
		Chqdb=sqlconobj.dataconn("EXE",_Defaultdb,lcSqlstr,"","nHandle")
		If Chqdb< 0
			Return .F.
		Endif
	Endif

	lcCondi = ""
	&&Changes has been done as per TKT-6470 (Multilanguage support - Tested with English & Japanese Language) on 24/02/2011
	*lcCondi = lcCondi + Iif(Type("_co_Mast.prodCode")="U",""," and (left(prodcode,15) = '"+Padr(Alltrim(GlobalObj.getpropertyval("udProdCode")),15,' ')+"'  ")		&& Added By Sachin N. S.
	_ProdCode = Cast(GlobalObj.getpropertyval("udProdCode") As Varbinary(250))
	lcCondi = lcCondi + Iif(Type("_co_Mast.prodCode")="U",""," and (prodcode = ?_ProdCode  ")		&& Added By Sachin N. S.
	&&Changes has been done as per TKT-6470 (Multilanguage support - Tested with English & Japanese Language) on 24/02/2011
	lcCondi = lcCondi + Iif(Type("_co_Mast.prodCode")="U",""," or prodCode is null or prodCode = '' ) ")		&& Added By Sachin N. S.
	Do Case
			&&Case Alltrim(mvu_MenuType) == [C]		&& Multi-company &&COMMENTED BY SATISH PAL DATED 21/03/2013 FOR BUG-8205
			*!*		Case INLIST(Alltrim(mvu_MenuType),[C],[U])			&& Multi-company &&&ADDED BY SATISH PAL DATED 21/03/2013 FOR BUG-8205
			*!*			nretval=sqlconobj.dataconn('EXE',_Defaultdb,"select * from co_mast where com_type = 'M'","_co_mast","nHandle")
		Case Alltrim(mvu_MenuType)==[U]			&& Multi-company &&&ADDED BY SATISH PAL DATED 21/03/2013 FOR BUG-8205
			nretval=sqlconobj.dataconn('EXE',_Defaultdb,"select * from co_mast","_co_mast","nHandle")
		Case Alltrim(mvu_MenuType)==[C]			&& Multi-company &&&ADDED BY SATISH PAL DATED 21/03/2013 FOR BUG-8205
			nretval=sqlconobj.dataconn('EXE',_Defaultdb,"select * from co_mast where com_type = 'M'","_co_mast","nHandle")
		Otherwise
			nretval=sqlconobj.dataconn('EXE',_Defaultdb,"select * from co_mast where com_type <> 'M' "+lcCondi,"_co_mast","nHandle")
	Endcase
	If nretval<0
		Return .F.
	Endif

	mRet=sqlconobj.sqlconnclose("nhandle")
	If mRet< 0
		Return .F.
	Endif

	*********** Added By Sachin N. S. on 17/07/2009 *********** End

	If exitclick = .F.
		Do doRegistration With sqlconobj			&& Added By Sachin N. S. on 22/01/2009
	Endif

	********** Added By Sachin N. S. on 24/06/2009 ********** Start

	If exitclick = .F. And !Eof('_co_mast')
		&&vasant16/11/2010	Changes done for VU 10 (Standard/Professional/Enterprise)
		*If Inlist(Upper(Alltrim(r_srvtype)),'PREMIUM','NORMAL') And reg_value = "DONE"
		*!If Inlist(Upper(Alltrim(ueReadRegMe.r_srvtype)),'PREMIUM','NORMAL') And reg_value = "DONE" && Commented by Archana K. on 21/02/13 for Bug-7899
		If Inlist(Upper(Alltrim(ueReadRegMe.r_srvtype)),'PREMIUM','NORMAL','VIEWER VERSION') And reg_value = "DONE" && Changed by Archana K. on 21/02/13 for Bug-7899&&vasant16/11/2010	Changes done for VU 10 (Standard/Professional/Enterprise)
			*!*	*!*				oSystemInfo = Createobject("SystemInfo.SysInformation")
			*!*	*!*				cMacId = oSystemInfo.getSystemInformation("M")

			********* To be uncommented After getting Proper solution commented by Sachin on 14/09/2009 ********* Start
			*!*				If Date() > Ctod('26/09/2009')
			*!*					cMacId = getMachineDetails(r_Apsrvname,"P")

			*!*					If !(cMacId $ r_MACId)
			*!*						=Messagebox("The machine is not registered with software vendor, cannot continue...!!!",0+16,vumess)
			*!*						exitclick = .T.
			*!*					Endif

			*!*				Endif
			********* To be uncommented After getting Proper solution commented by Sachin on 14/09/2009 ********* End

			*!*	*************** New Concept for checking the Machine Credentials *************** Start
			*!*	*!*				aFile = File("C:\WINDOWS\SYSTEM32\DRIV.EXT")
			*!*				r_MACId = 'BFEBFBFF00000F49'
			*!*	*!*				cFileExt = GETENV("windir")+"\system32\DRIV.EXT"
			*!*				cFileExt = "C:\WINDOWS\SYSTEM32\DRIV.EXT"
			*!*				cMacId = ''
			*!*				If FILE("C:\WINDOWS\SYSTEM32\DRIV.EXT")
			*!*					cFileStat = Filetostr(cFileExt)
			*!*					cMacId = Substr(Alltrim(cFileStat),At(',',cFileStat)+1,At(',',cFileStat,2)-At(',',cFileStat,1)-1)
			*!*				Else
			*!*					=Messagebox("Udyog System files missing, Please contact Udyog Administrator.",64,vumess)
			*!*					exitclick = .T.
			*!*					RETURN .F.
			*!*				Endif

			*!*				If !(cMacId $ r_MACId)
			*!*					=Messagebox("The machine is not registered with software vendor, cannot continue...!!!",0+16,vumess)
			*!*					exitclick = .T.
			*!*					RETURN .f.
			*!*				Else
			*!*					=Messagebox("Congratulations Logged-In successfully.",0+16,vumess)
			*!*				Endif
			*!*	*************** New Concept for checking the Machine Credentials *************** End

			********** Check for Wrong Registration file.
			&&vasant16/11/2010	Changes done for VU 10 (Standard/Professional/Enterprise)
			*mudProdCode = dec(GlobalObj.getpropertyval("UdProdCode"))
			*If ( (mudProdCode = 'iTax' And ('US ' $ xvalue1 Or 'VU ' $ xvalue1 Or 'VS ' $ xvalue1 )) Or (mudProdCode = 'USquare' And ('IT ' $ xvalue1 Or 'VU ' $ xvalue1 Or 'VS ' $ xvalue1)) Or (Inlist(mudProdCode,'VudyogMFG','VudyogTRD') And ('IT ' $ xvalue1 Or 'US ' $ xvalue1 Or 'VS ' $ xvalue1)) Or (mudProdCode = 'VudyogServiceTax' And ('IT ' $ xvalue1 Or 'VU ' $ xvalue1 Or 'US ' $ xvalue1)) ) And Inlist(Upper(Alltrim(r_srvtype)),'PREMIUM','NORMAL')

			******* Changed By Sachin N. S. on 10/04/2012 for Bug-2887 ******* Start
			*!*				mudProdCode = dec(NewDecry(GlobalObj.getpropertyval("UdProdCode"),'Ud*yog+1993'))
			*!*				If ( (mudProdCode = 'iTax' And ('US ' $ xvalue1 Or 'VU ' $ xvalue1 Or 'VS ' $ xvalue1 )) Or (mudProdCode = 'USquare' And ('IT ' $ xvalue1 Or 'VU ' $ xvalue1 Or 'VS ' $ xvalue1)) Or (Inlist(mudProdCode,'VudyogMFG','VudyogTRD') And ('IT ' $ xvalue1 Or 'US ' $ xvalue1 Or 'VS ' $ xvalue1)) Or (mudProdCode = 'VudyogServiceTax' And ('IT ' $ xvalue1 Or 'VU ' $ xvalue1 Or 'US ' $ xvalue1)) ) And Inlist(Upper(Alltrim(ueReadRegMe.r_srvtype)),'PREMIUM','NORMAL')
			*!*	&&vasant16/11/2010	Changes done for VU 10 (Standard/Professional/Enterprise)
			*!*					vuMessr = Iif((mudProdCode = 'iTax' And ('US ' $ xvalue1 Or 'VU ' $ xvalue1 Or 'VS ' $ xvalue1)),'iTax',Iif((mudProdCode = 'USquare' And ('IT ' $ xvalue1 Or 'VU ' $ xvalue1 Or 'VS ' $ xvalue1)),'USquare',Iif((mudProdCode = 'VudyogServiceTax' And ('IT ' $ xvalue1 Or 'VU ' $ xvalue1 Or 'US ' $ xvalue1)),'VudyogServiceTax',mudProdCode)))
			*!*					=Messagebox("Registration file not of "+vuMessr,32,vumess)
			*!*					exitclick = .T.
			*!*				Endif

			mudShortCode = dec(NewDecry(GlobalObj.getpropertyval("Udprodshortcode"),'Udyog_*Prod_Cd'))
			_ShrtCodeNtAlwd = GlobalObj.UdProdShrtCdNotAlwd+','
			_ShrtCodeNtAlwd = Strtran(_ShrtCodeNtAlwd,mudShortCode+',','')
			mudProdCode = dec(NewDecry(GlobalObj.getpropertyval("UdProdCode"),'Ud*yog+1993'))
			vuMessr=""
			Do While .T.
				If At(',',_ShrtCodeNtAlwd)>0
					_cshrtcode = Alltrim(Left(_ShrtCodeNtAlwd,At(',',_ShrtCodeNtAlwd)-1))+' '
					If _cshrtcode $ xValue1
						vuMessr = GlobalObj.ProductTitle
						Exit
					Endif
				Else
					Exit
				Endif
				_ShrtCodeNtAlwd = Strtran(_ShrtCodeNtAlwd,Alltrim(_cshrtcode)+',','')
			Enddo

			*!*				If !Empty(vuMessr) And Inlist(Upper(Alltrim(ueReadRegMe.r_srvtype)),'PREMIUM','NORMAL')&& Commented by Archana K. on 21/02/13 for Bug-7899
			If !Empty(vuMessr) And Inlist(Upper(Alltrim(ueReadRegMe.r_srvtype)),'PREMIUM','NORMAL','VIEWER VERSION')&& Changed by Archana K. on 21/02/13 for Bug-7899
				=Messagebox("Registration file not of "+vuMessr,32,vumess)
				exitclick = .T.
			Endif
			******* Changed By Sachin N. S. on 10/04/2012 for Bug-2887 ******* End
			&&Changes has been done by Sachin & Vasant on 30/10/2013 for Bug 20574 (VU Trader Installer required).
			If Inlist(dec(NewDecry(GlobalObj.getpropertyval("UdProdCode"),'Ud*yog+1993')),'VUTrader')
				If !(Upper(Alltrim(ueReadRegMe.r_Apsrvname)) $ Sys(0))
					=Messagebox("The machine is not registered with software vendor, cannot continue...!!!",0+16,vumess)
					exitclick = .T.
				Endif
			Endif
			&&Changes has been done by Sachin & Vasant on 30/10/2013 for Bug 20574 (VU Trader Installer required).
		Endif
	Endif

	********** Added By Sachin N. S. on 24/06/2009 ********** End

	If Eof('_co_mast') Or Bof('_co_mast')
		Do Form frmconndatabase
		Do Form frmudyogsdi With .T.
		Read Events
		Exit
	Else

		*!*			if not inlist(mvu_MenuType,[B],[X]) and exitclick <> .t. and llLoginfrm = .t.			&& Raghu 160609
		If exitclick <> .T. And lLoginform = .T.
			Do Form frmpassword
			Read Events
		Endif

		&&vasant060410
		If exitclick = .F.
			&&Changes done by vasant as per TKT-6525 on 05/03/2011 - Start
			*!*				Local m_LicenseServiceTimer
			*!*				m_LicenseServiceTimer = Createobject('iLicenseServiceTimer')
			&&Changes done by vasant as per TKT-6525 on 05/03/2011 - End

			Local m_LicenseServiceValidate
			m_LicenseServiceValidate = ''
			*If Type('getpem(GlobalObj,"LicenseValidate")') = 'O'		&&vasant16/11/2010	Changes done for VU 10 (Standard/Professional/Enterprise)
			If Type('pemstatus(GlobalObj,"LicenseValidate",3)') = 'C'	&&vasant16/11/2010	Changes done for VU 10 (Standard/Professional/Enterprise)
				m_LicenseServiceValidate = GlobalObj.LicenseValidate()
			Endif
			If Type('m_LicenseServiceValidate') <> 'C'
				m_LicenseServiceValidate = ''
			Endif
			If !m_LicenseServiceValidate == 'LVALID'
				exitclick=.T.
				Return .F.
			Endif
			Release m_LicenseServiceValidate

			Local m_LicenseServiceValidate
			m_LicenseServiceValidate = ''
			*If Type('getpem(GlobalObj,"LicenseVerify")') = 'O'		&&vasant16/11/2010	Changes done for VU 10 (Standard/Professional/Enterprise)
			If Type('pemstatus(GlobalObj,"LicenseVerify",3)') = 'C'	&&vasant16/11/2010	Changes done for VU 10 (Standard/Professional/Enterprise)
				m_LicenseServiceValidate = GlobalObj.LicenseVerify()
			Endif
			If Type('m_LicenseServiceValidate') <> 'C'
				m_LicenseServiceValidate = ''
			ENDIF

			If !m_LicenseServiceValidate == 'LVERIFY'
				exitclick=.T.
				*!*					Return .F.		&& Commented by Shrikant S. on 09/07/2013 for Bug-16557
			Endif
			Release m_LicenseServiceValidate
		Endif
		&&vasant060410
		
		If exitclick = .F.
			Do Form frmconndatabase

			*If AppSessionId = 1 And mvu_MenuType <> [B]	&&vasant041209
			If AppSessionId >= 1 And mvu_MenuType <> [B]	&&vasant041209
				Public ObjLoggedUser,MsgWind
				Try
					ObjLoggedUser=Newobject('frmloginusers',"frmloginusers.Vcx")
					With ObjLoggedUser
						If Type("ObjLoggedUser") = "O"
							.Systray1.cleariconlist()
							*.Systray1.iconfile = apath+'Bmp\ueicon.ico'	&&vasant041209
							.Systray1.iconfile = icopath	&&vasant041209
							.Systray1.addicontosystray()
							.Systray1.tiptext = vumess+" - Logon User Info"
						Endif
					Endwith
				Catch To errObj

				Endtry

				MsgWind=Newobject('frmMsgWindow',"frmMsgWindow.vcx")
			Endif

			Do Case
				Case Alltrim(mvu_MenuType) == [B]			&& backup
					pbar.cleaprogressbar()
					pbar = Null
					Release pbar
					mvu_Auto_object = Createobject("Empty")
					Set Path To (apath)
					Do uebackup.App With [B],lcDateFunc,[]	&& Changed By Sachin N. S. on 26/12/2008
				Case Alltrim(mvu_MenuType) == [R]			&& Restore
					pbar.cleaprogressbar()
					pbar = Null
					Release pbar
					Do uebackup.App With [R],[]
				Case Alltrim(mvu_MenuType) == [C]			&&Rup MultiCompany Creation
					Do Form frmudyogsdi With .F.
				Case Alltrim(mvu_MenuType) == [L]			&& DTS Main
					pbar.cleaprogressbar()
					pbar = Null
					Release pbar
					Do DTS.App
				Case Alltrim(mvu_MenuType) == [D]
					Do Form frmudyogsdi With .F.
				Case Alltrim(mvu_MenuType) == [I]			&& Integration Utility
					pbar.cleaprogressbar()
					pbar = Null
					Release pbar
					Do Integration.App
				Case Alltrim(mvu_MenuType) == [X]			&& XML Generation
					pbar.cleaprogressbar()
					pbar = Null
					Release pbar
					Do ui2uixgen.App With lcDateFunc,"A",.F.
				Case Alltrim(mvu_MenuType) == [M]			&& i-Tax MDI Window
					Do Form frmudyogsdi With .F.
				Case Alltrim(mvu_MenuType) == [U]			&& Update
					pbar.cleaprogressbar()
					pbar = Null
					Release pbar
					Do ueUpdatePkg
				Otherwise
					&&vasant16/11/2010	Changes done for VU 10 (Standard/Professional/Enterprise)
					If UdNewTrigEnbl
						If (File('UDAppMainAppl.App') Or File('UDTrigMainAppl.fxp'))
							pbar.cleaprogressbar()
							pbar = Null
							Release pbar
							If File('UDAppMainAppl.App')
								*!*								exitclick=UDAppMainAppl.App()   Tkt 3468 by Rupesh
								exitclick=UDAppMainAppl()
							Endif
							If File('UDTrigMainAppl.fxp')
								exitclick=UDTrigMainAppl()
							Endif
						Else
							=Messagebox("Please pass valid parameter...",64,vumess)
							exitclick = .T.
						Endif
					Else
						If File('ueTrigMainAppl.fxp')			&& Added By Raghu 160607
							pbar.cleaprogressbar()
							pbar = Null
							Release pbar
							exitclick=ueTrigMainAppl()
						Else
							=Messagebox("Please pass valid parameter...",64,vumess)
							exitclick = .T.
						Endif
					Endif
					*!*					If File('ueTrigMainAppl.fxp')			&& Added By Raghu 160607
					*!*						pbar.cleaprogressbar()
					*!*						pbar = Null
					*!*						Release pbar
					*!*						exitclick=ueTrigMainAppl()
					*!*					Else
					*!*						=Messagebox("Please pass valid parameter...",64,vumess)
					*!*						exitclick = .T.
					*!*					Endif
					&&vasant16/11/2010	Changes done for VU 10 (Standard/Professional/Enterprise)
			Endcase

			If exitclick = .F.
				&&vasant16/11/2010	Changes done for VU 10 (Standard/Professional/Enterprise)
				If UdNewTrigEnbl
					If File('UDAppActive.App')
						Do UDAppActive
					Endif
					If File('UDTrigActive.fxp')
						Do UDTrigActive
					Endif
				Else
					&&vasant16/11/2010	Changes done for VU 10 (Standard/Professional/Enterprise)
					If File('ueTrigActive.fxp')			&& Added By Vasant S. on 16/02/2009
						Do ueTrigActive
					Endif
				Endif	&&vasant16/11/2010		Changes done for VU 10 (Standard/Professional/Enterprise)
			Endif

			If exitclick = .T.
				Exit
			Else
				Read Events
			Endif
			If exitclick <> .T.
				Loop
			Endif
		Else
			Exit
		Endif
	Endif
Enddo
exitclick = .T.

&&vasant060410
If Type('GlobalObj') = 'O'
	Local m_LicenseServiceValidate
	m_LicenseServiceValidate = ''
	*If Type('getpem(GlobalObj,"LicenseClose")') = 'O'		&&vasant16/11/2010	Changes done for VU 10 (Standard/Professional/Enterprise)
	If Type('pemstatus(GlobalObj,"LicenseClose",3)') = 'C'	&&vasant16/11/2010	Changes done for VU 10 (Standard/Professional/Enterprise)
		m_LicenseServiceValidate = GlobalObj.LicenseClose()
	Endif
	If Type('m_LicenseServiceValidate') <> 'C'
		m_LicenseServiceValidate = ''
	ENDIF
	Release m_LicenseServiceValidate
Endif
&&vasant060410

On Shutdown
Close All
Clear All
Clear Dlls
Quit
Return

Procedure errorprocformain
	Lparameters lerror
	If lerror = 1
		=Messagebox("Application name has been changed!! Application name should be Udyog iTax.Exe",64,vumess)
		Quit
	Endif
	Return


Procedure doRegistration
	Lparameters oSqlConObj
	&&vasant16/11/2010	Changes done for VU 10 (Standard/Professional/Enterprise)
	*!*	Public 	reg_value,reg_prods,r_instdate,r_instdate1,unreg_msg,r_ExpDt,r_srvtype,r_coof,r_noof,r_MACId,r_Apsrvname,xvalue1,FirstReg,lRgMsg
	*!*	Public	r_ename,r_AmcStDt,r_AmcEdDt

	*!*	*!*		mSqlStr = "SELECT [Name] FROM Vudyog..Register WHERE [Name] = 'ITaxdts'"
	*!*	*!*		nRetVal = oSqlConObj.dataconn('EXE','master',msqlstr,"_ITAX_DTS","nHandle")
	*!*	*!*		If nRetVal<0
	*!*	*!*			Return .F.
	*!*	*!*		Endif


	*!*	r_compn     =   ''
	*!*	r_comp		=	''
	*!*	r_user		=	''
	*!*	r_add1		=	''
	*!*	r_add2		=	''
	*!*	r_add3		=	''
	*!*	r_city		=	''
	*!*	r_state		=	''
	*!*	r_location	=	''
	*!*	r_phone     =   ''
	*!*	r_servcent	=	''
	*!*	r_instdate	=	''
	*!*	xvalue		=   ''
	*!*	r_coof		=   0
	*!*	r_noof		=	0
	*!*	r_idno		=	''
	*!*	r_pid		=   ''
	*!*	r_servcont	=	''
	*!*	r_servadd1	=	''
	*!*	r_servadd2	=	''
	*!*	r_servadd3	=	''
	*!*	r_servcity	=	''
	*!*	r_servzip	=	''
	*!*	r_servphone	=	''
	*!*	r_servemail	=	''
	*!*	reg_value	=	'NOT DONE'		&& Changed By Sachin N. S. on 20/12/2008
	*!*	reg_prods   =   ''
	*!*	unreg_msg	=	'Un-registered'
	*!*	r_ExpDt		=	''
	*!*	r_MACId		=	''
	*!*	FirstReg	=	.F.
	*!*	r_srvtype	=	''
	*!*	r_Apsrvname	=	''
	*!*	xvalue1		=	''
	*!*	r_ename		=	''
	*!*	r_AmcStDt	=	''
	*!*	r_AmcEdDt	=	''

	Public 	reg_value,reg_prods,r_coof,r_noof,xvalue,unreg_msg,r_instdate1,FirstReg,lRgMsg,ueReadRegMe,xValue1

	xvalue		=   ''
	r_coof		=   0
	r_noof		=	0
	reg_value	=	''
	reg_prods   =   ''
	unreg_msg	=	'Un-registered'
	xValue1		=	''
	&&vasant16/11/2010	Changes done for VU 10 (Standard/Professional/Enterprise)

	lcMessg		= 	''

	If !Eof('_co_mast')

		********** To Removed ************ Start
		msqlstr = " Select getdate() as Date "
		nretval = oSqlConObj.dataconn("EXE","Vudyog",msqlstr,"_SrvDate","nHandle")
		If nretval<0
			Return .F.
		Endif
		mRet=oSqlConObj.sqlconnclose("nhandle")		&& Added By Sachin N. S. on 29/04/2010
		If mRet< 0
			Return .F.
		Endif

		dSrvDate = Ttod(_SrvDate.Date)

		*If dSrvDate >= Ctod('26-05-2010')				&&vasant060410
		*!*		If dSrvDate >= Ctod('31-03-2011')		&& Line To Be Removed && To use for Education Version
		&&vasant16/11/2010	Changes done for VU 10 (Standard/Professional/Enterprise)
		*Do ueRegistration With .F.			&& Comment To Be Removed

		mRet = ueRegistration(.F.)
		If mRet = .F.
			Return .F.
		Endif

		&&vasant16/11/2010	Changes done for VU 10 (Standard/Professional/Enterprise)

		&&vasant060410
		*!*		Else
		*!*			reg_value 	= 'OK'					&& Line To Be Removed
		*!*			r_ExpDt		= '26-05-2010'			&& Line To Be Removed
		*!*			*!*			r_ExpDt		= '31-03-2011'			&& Line To Be Removed && To use for Education Version
		*!*			unreg_msg	= ''					&& Line To Be Removed
		*!*			*!*			unreg_msg	= 'Fictitious - ( Training Purpose )'	&& To use for Education Version
		*!*			r_coof		= 999					&& Line To Be Removed
		*!*			r_noof		= 999					&& Line To Be Removed
		*!*		ENDIF
		&&vasant060410
		********** To Removed ************ End

		msqlstr = " Select getdate() as Date "
		nretval = oSqlConObj.dataconn("EXE","Vudyog",msqlstr,"_SrvDate","nHandle")
		If nretval<0
			Return .F.
		Endif
		dSrvDate = Ttod(_SrvDate.Date)

		If reg_value = 'NOT DONE'
			lnGrace = 0

			vuFile	= Sys(2000,apath+"*register.me")	&& Added By Sachin N. S. on 19/11/2008
			If !File(vuFile)
				lnGrace = 5
			Endif

			*!*			lnDays = Iif(lnGrace>0,Iif(dSrvDate > Ctod(r_instdate1)+lnGrace+1,dSrvDate - Ctod(r_instdate1)+1,dSrvDate - Ctod(r_instdate1) - lnGrace+1),(dSrvDate - Ctod(r_instdate1)+1))
			lnDays = (dSrvDate - Ctod(r_instdate1)+1)		&& Changed By Sachin N. S. on 15/08/2009 as said by vasant to remove grace period

			lnEvalPerd = 0

			*********** Changed By Sachin N. S. on 09/07/2010 for New Message Change *********** Start
			&&vasant16/11/2010	Changes done for VU 10 (Standard/Professional/Enterprise)
			*If !Inlist(Alltrim(dec(GlobalObj.getpropertyval("UdProdCode"))),'VudyogMFG','VudyogTRD','VudyogServiceTax')
			*If !Inlist(dec(NewDecry(GlobalObj.getPropertyval("UdProdCode"),'Ud*yog+1993')),'VudyogMFG','VudyogTRD','VudyogServiceTax','VudyogSTD','VudyogPRO','VudyogENT')		&&Changes done by Vasant on 22/02/2011 as per TKT-6371 for Changing Demo Days for VU10 (Standard/Professional/Enterprise)
			If !Inlist(dec(NewDecry(GlobalObj.getpropertyval("UdProdCode"),'Ud*yog+1993')),'VudyogMFG','VudyogTRD','VudyogServiceTax')		&&Changes done by Vasant on 22/02/2011 as per TKT-6371 for Changing Demo Days for VU10 (Standard/Professional/Enterprise)
				&&vasant16/11/2010	Changes done for VU 10 (Standard/Professional/Enterprise)
				lnEvalPerd = 27
			Else
				lnEvalPerd = 9
			Endif

			If lnDays <= lnEvalPerd
				lcMessg = "Dear User,"+Chr(13)+Chr(13)+;
					"You are using the "+Alltrim(Str(lnEvalPerd))+" days evaluation copy of the software, which would expire on "+Dtoc(Ctod(r_instdate1)+lnEvalPerd-1)+"."+;
					"You are required to register the software on or before the "+Dtoc(Ctod(r_instdate1)+lnEvalPerd-1)+" in order to avoid expiry."+Chr(13)+Chr(13)+;
					"For any assistance, please contact your nearest software vendor or visit us at www.udyogsoftware.com or email accounts@udyogsoftware.com."
			Else
				lcMessg = "Dear User,"+Chr(13)+Chr(13)+;
					"We regret to inform you that your evaluation period has been expired and you will not be able to use the software."+;
					"We hope you are satisfied with the software and enjoyed using it."+Chr(13)+Chr(13)+;
					"For any assistance, please contact your nearest software vendor or visit us at www.udyogsoftware.com or email accounts@udyogsoftware.com."
			Endif

			****** Added by Sachin N. S. on 17/05/2017 for GST -- Start
			If Inlist(dec(NewDecry(GlobalObj.getpropertyval("UdProdCode"),'Ud*yog+1993')),'VudyogGSSDK')
				lcMessg = "Dear User,"+Chr(13)+Chr(13)+;
					"Udyog GST SDK version is provided to Partners for internal usage, support on customization tasks and for "+;
					"product demonstrations. During the Evaluation Period, Udyog Software grants to Partners a non-exclusive, revocable "+;
					"and non-transferable right to use the Udyog GST solely for the purpose of product demonstrations and developing "+;
					"customizations. Partner may, using the functionality within the Udyog GST, configure and, modify certain available "+;
					"functionality of the Udyog GST. "+Chr(13)+Chr(13)+;
					"Udyog GST SDK license is not intended for Customer use and cannot be installed on Customer workstations. Any attempt "+;
					"to install or use this software on Customer workstations is strictly prohibited. If you have any questions on the same, please "+;
					"contact the support team at Udyog Software at support@udyogsoftware.com."
			Endif
			****** Added by Sachin N. S. on 17/05/2017 for GST -- End

			*!*			If !Inlist(Alltrim(dec(GlobalObj.getpropertyval("UdProdCode"))),'VudyogMFG','VudyogTRD','VudyogServiceTax')
			*!*				lnEvalPerd = 27
			*!*				Do Case
			*!*				Case  Between(lnDays,-5,10)
			*!*					lcMessg = "Dear User,"+Chr(13)+Chr(13)+;
			*!*						"You are using the "+Alltrim(Str(lnEvalPerd))+" days evaluation copy of the software."+;
			*!*						"This is to remind that your software needs to be registered before the software can be used fully."+;
			*!*						"To avail other features of the software register before the validity period."+Chr(13)+Chr(13)+;
			*!*						"Please contact your nearest software vendor for any assistance or visit us at www.udyogexcise.com or mail us at register@udyogsoftware.com."
			*!*				Case  Between(lnDays,11,20)
			*!*					lcMessg = "Dear User,"+Chr(13)+Chr(13)+;
			*!*						"This is the second reminder for the registration of the evaluation copy of software, "+;
			*!*						"without which you will not be able to use some of the statutory reports in the software."+;
			*!*						"So request you to register before the validity period."+Chr(13)+Chr(13)+;
			*!*						"Please contact your nearest software vendor for any assistance or visit us at www.udyogexcise.com or mail us at register@udyogsoftware.com."
			*!*				Case  Between(lnDays,21,24)
			*!*					lcMessg = "Dear User,"+Chr(13)+Chr(13)+;
			*!*						"After repeated reminder for last 20 days your evaluation copy of the software is still un-registered."+;
			*!*						"Only last "+Alltrim(Str(lnEvalPerd+1-(dSrvDate - Ctod(r_instdate1)+1)))+Iif(lnDays=lnEvalPerd," day"," days")+" to register your evaluation copy."+;
			*!*						"Register the software before the validity period, so that you could use the other features and reports."+Chr(13)+Chr(13)+;
			*!*						"Please contact your nearest software vendor for any assistance or visit us at www.udyogexcise.com or mail us at register@udyogsoftware.com."
			*!*				Case  Between(lnDays,25,lnEvalPerd)
			*!*					lcMessg = "Dear User,"+Chr(13)+Chr(13)+;
			*!*						"You have last "+Alltrim(Str(lnEvalPerd+1-(dSrvDate - Ctod(r_instdate1)+1)))+Iif(lnDays=lnEvalPerd," day"," days")+" to register your evaluation copy."+;
			*!*						"Register the software before the validity period gets over."+;
			*!*						"Hurry Up....!!!"+Chr(13)+Chr(13)+;
			*!*						"Please contact your nearest software vendor for any assistance or visit us at www.udyogexcise.com or mail us at register@udyogsoftware.com."
			*!*				Otherwise
			*!*					lcMessg = "Dear User,"+Chr(13)+Chr(13)+;
			*!*						"We regret to inform you that your evaluation period has been expired and you will not be able to use the software."+;
			*!*						"We hope you are satisfied with the software and enjoyed using it."+Chr(13)+Chr(13)+;
			*!*						"Please contact your nearest software vendor for any assistance or visit us at www.udyogexcise.com or mail us at register@udyogsoftware.com."
			*!*				Endcase
			*!*			Else	&& Condition for Visual Udyog 9.0 Version
			*!*				lnEvalPerd = 9
			*!*				Do Case
			*!*				Case  Between(lnDays,-5,5)
			*!*					lcMessg = "Dear User,"+Chr(13)+Chr(13)+;
			*!*						"You are using the "+Alltrim(Str(lnEvalPerd))+" days evaluation copy of the software."+;
			*!*						"This is to remind that your software needs to be registered before the software can be used fully."+;
			*!*						"To avail other features of the software, register before the validity period."+Chr(13)+Chr(13)+;
			*!*						"Please contact your nearest software vendor for any assistance or visit us at www.udyogexcise.com or mail us at register@udyogsoftware.com."
			*!*					*!*						Case  Between(lnDays,3,20)
			*!*					*!*							lcMessg = "Dear User,"+Chr(13)+Chr(13)+;
			*!*					*!*								"This is the second reminder for the registration of the evaluation copy of software, "+;
			*!*					*!*								"without which you will not be able to use some of the statutory reports in the software."+;
			*!*					*!*								"So request you to register before the validity period."+Chr(13)+Chr(13)+;
			*!*					*!*								"Please contact your nearest software vendor for any assistance."
			*!*					*!*						Case  Between(lnDays,21,24)
			*!*					*!*							lcMessg = "Dear User,"+Chr(13)+Chr(13)+;
			*!*					*!*								"After repeated reminder for last 20 days your evaluation copy of the software is still un-registered."+;
			*!*					*!*								"Only last "+Alltrim(Str(28-(dSrvDate - Ctod(r_instdate1))))+Iif(lnDays=27," day"," days")+" to register your evaluation copy."+;
			*!*					*!*								"Register the software before the validity period, so that you could use the other features and reports."+Chr(13)+Chr(13)+;
			*!*					*!*								"Please contact your nearest software vendor for any assistance."
			*!*				Case  Between(lnDays,6,9)
			*!*					lcMessg = "Dear User,"+Chr(13)+Chr(13)+;
			*!*						"You have last "+Alltrim(Str(lnEvalPerd+1-(dSrvDate - Ctod(r_instdate1)+1)))+Iif(lnDays=lnEvalPerd," day"," days")+" to register your evaluation copy."+;
			*!*						"Register the software before the validity period gets over."+;
			*!*						"Hurry Up....!!!"+Chr(13)+Chr(13)+;
			*!*						"Please contact your nearest software vendor for any assistance or visit us at www.udyogexcise.com or mail us at register@udyogsoftware.com."
			*!*				Otherwise
			*!*					lcMessg = "Dear User,"+Chr(13)+Chr(13)+;
			*!*						"We regret to inform you that your evaluation period has been expired and you will not be able to use the software."+;
			*!*						"We hope you are satisfied with the software and enjoyed using it."+Chr(13)+Chr(13)+;
			*!*						"Please contact your nearest software vendor for any assistance or visit us at www.udyogexcise.com or mail us at register@udyogsoftware.com."
			*!*				Endcase
			*!*			Endif
			*********** Changed By Sachin N. S. on 09/07/2010 for New Message Change *********** End

			If reg_value = 'NOT DONE' And (lnDays >= lnEvalPerd+1 Or dSrvDate < Ctod(r_instdate1))
				Do Form frmRegisterMsg With lcMessg,.T.,.T.,.F.
				Read Events
				If lRgMsg
					lRgMsg=.F.
					Do ueGetCompInfo With lnEvalPerd-(dSrvDate - Ctod(r_instdate1)),.F.,.F.,''
					Read Events
				Endif
				exitclick=.T.
				Return .F.
			Else
				Do Form frmRegisterMsg With lcMessg,.T.,.T.,.F.
				Read Events
				If lRgMsg
					lRgMsg=.F.
					Do ueGetCompInfo With lnEvalPerd-(dSrvDate - Ctod(r_instdate1)),.F.,.F.,''
					Read Events
				Endif
			Endif
		Endif

		If reg_value = 'DONE'
			lnGrace = 0
			*!*			lnDays = Iif(dSrvDate>Ctod(r_ExpDt),Ctod(r_AmcEdDt),Ctod(r_ExpDt)) - dSrvDate
			*lnDays = (Iif(dSrvDate>Ctod(r_ExpDt),Ctod(r_AmcEdDt),Ctod(r_ExpDt)) - dSrvDate) + Iif(dSrvDate<=Ctod(r_ExpDt),1,0)		&& Added By Sachin N. S. on 02/07/2010 for TKT-2823	&&vasant16/11/2010	Changes done for VU 10 (Standard/Professional/Enterprise)
			*!*			lnDays = (Iif(dSrvDate>Ctod(ueReadRegMe.r_ExpDt) ,Ctod(ueReadRegMe.r_AmcEdDt),Ctod(ueReadRegMe.r_ExpDt)) - dSrvDate) + Iif(dSrvDate<=Ctod(ueReadRegMe.r_ExpDt),1,0)		&& Added By Sachin N. S. on 02/07/2010 for TKT-2823	&&vasant16/11/2010	Changes done for VU 10 (Standard/Professional/Enterprise)
			lnDays = (Iif(dSrvDate>Ctod(ueReadRegMe.r_ExpDt),Ctod(ueReadRegMe.r_AmcEdDt),Iif(Ctod(ueReadRegMe.r_AmcEdDt)>Ctod(ueReadRegMe.r_ExpDt),Ctod(ueReadRegMe.r_AmcEdDt),Ctod(ueReadRegMe.r_ExpDt))) - dSrvDate) + Iif(dSrvDate<=Ctod(ueReadRegMe.r_ExpDt),1,0)		&& Changed by Sachin N. S. on 08/03/2015 for Bug-25375

			lcMesg1 = "If paid already, please inform your service center & get renewal certificate by sending the following information."+Chr(13)
			lcMesg1 = lcMesg1 + "Cheque / Demand Draft No. & Date, Bank Name, Paid to and Amount."
			If Between(lnDays,1,15)
				*********** Changed By Sachin N. S. on 09/07/2010 for New Message Change *********** Start
				*!*				Do Case
				*!*				Case  Between(lnDays,1,15)
				*!*					lcMessg = "Dear User,"+Chr(13)+Chr(13)+;
				*!*						"Please renew your Annual Upgradation License Pack. This will keep you updated to "+;
				*!*						"the latest version of the software. Software amendment will be automated through net."+Chr(13)+Chr(13)+;
				*!*						"Please contact "+Alltrim(r_ename)+" for any assistance or visit us at www.udyogexcise.com or mail us at register@udyogsoftware.com"+Chr(13)+Chr(13)+;
				*!*						"Only "+Transform(lnDays)+Iif(lnDays=1," Day "," Days ") + " to go."

				*!*					*!*							"You have last "+Alltrim(Str(31-(dSrvDate - Ctod(r_ExpDt))))+" days to use the evaluation copy."+;
				*!*					*!*							"Update your software for the new version before the validity period gets over."+Chr(13)+Chr(13)+;
				*!*					*!*							"Please contact your nearest software vendor for any assistance."
				*!*				Otherwise
				*!*					lcMessg = "Dear User,"+Chr(13)+Chr(13)+;
				*!*						"We regret to inform you that your evaluation period has been expired and you will not be able to use the software."+;
				*!*						"We hope you have enjoyed using the software."+Chr(13)+Chr(13)+;
				*!*						"Please contact your nearest software vendor for any assistance or visit us at www.udyogexcise.com or mail us at register@udyogsoftware.com."
				*!*				Endcase
				&&vasant16/11/2010	Changes done for VU 10 (Standard/Professional/Enterprise)
				*!*				lcMessg = "Dear User,"+Chr(13)+Chr(13)+;
				*!*					Transform(lnDays)+Iif(lnDays=1," Day "," Days ") + " to go."+;
				*!*					"Avail our latest updates on your software and our support for the next year. "+;
				*!*					"Contact "+Alltrim(r_ename)+" for any assistance or email accounts@udyogsoftware.com "+;
				*!*					"to avail Udyog's Annual Maintenance Contract (AMC)."
				lcMessg = "Dear User,"+Chr(13)+Chr(13)+;
					Transform(lnDays)+Iif(lnDays=1," Day "," Days ") + "to go. "+;
					"Avail our latest updates on your software and our support for the next year. "+;
					"Contact "+Chr(34)+Alltrim(ueReadRegMe.r_ename)+Chr(34)+" for any assistance or email accounts@udyogsoftware.com "+;
					"to avail Udyog's Annual Maintenance Contract (AMC)."
				&&vasant16/11/2010	Changes done for VU 10 (Standard/Professional/Enterprise)
				*********** Changed By Sachin N. S. on 09/07/2010 for New Message Change *********** End

				*If reg_value = 'DONE' And (lnDays >= 31 Or dSrvDate+lnGrace < Iif(dSrvDate>Ctod(r_ExpDt),Ctod(r_AmcEdDt),Ctod(r_ExpDt)))		&&vasant16/11/2010	Changes done for VU 10 (Standard/Professional/Enterprise)
				*!*				If reg_value = 'DONE' And (lnDays >= 31 Or dSrvDate+lnGrace < Iif(dSrvDate>Ctod(ueReadRegMe.r_ExpDt),Ctod(ueReadRegMe.r_AmcEdDt),Ctod(ueReadRegMe.r_ExpDt)))		&&vasant16/11/2010	Changes done for VU 10 (Standard/Professional/Enterprise)
				If reg_value = 'DONE' And (lnDays >= 31 Or dSrvDate+lnGrace < Iif(dSrvDate>Ctod(ueReadRegMe.r_ExpDt),Ctod(ueReadRegMe.r_AmcEdDt),Iif(Ctod(ueReadRegMe.r_AmcEdDt)>Ctod(ueReadRegMe.r_ExpDt),Ctod(ueReadRegMe.r_AmcEdDt),Ctod(ueReadRegMe.r_ExpDt))))		&& Changed by Sachin N. S. on 08/03/2015 for Bug-25375
					Do Form frmRegisterMsg With lcMessg+Chr(13)+Chr(13)+lcMesg1,.T.,.T.,.T.
					Read Events
					If lRgMsg
						lRgMsg=.F.
						Do ueGetCompInfo With 0,.F.,.T.,''
						Read Events
					Endif
				Else
					Do Form frmRegisterMsg With lcMessg+Chr(13)+Chr(13)+lcMesg1,.T.,.T.,.T.
					Read Events
					If lRgMsg
						lRgMsg=.F.
						Do ueGetCompInfo With 0,.F.,.T.,''
						Read Events
					Endif
				Endif
			Else
				lcMessg = ""
				If lnDays < 0		&& Added By Sachin N. S. on 02/07/2010 for TKT-2825

					*********** Changes done by Sachin N. S. on 09/07/2010 for New Message Change *********** Start
					If Between(Abs(lnDays),1,7) Or (!Between(Abs(lnDays),1,7) And Dow(dSrvDate)=4 And Between(Abs(lnDays),8,67)) Or ;
							(!Between(Abs(lnDays),1,67) And Inlist(Day(dSrvDate),12,18,27) And Between(Abs(lnDays),68,157)) Or ;
							(!Between(Abs(lnDays),1,157) And Inlist(Day(dSrvDate),16,28) And Between(Abs(lnDays),158,307)) Or ;
							(!Between(Abs(lnDays),1,307) And Day(dSrvDate)= 2)
						&&vasant16/11/2010	Changes done for VU 10 (Standard/Professional/Enterprise)
						*!*						lcMessg = "Dear User,"+Chr(13)+Chr(13)+;
						*!*							"Your Application may not be upgraded with the latest software patches or upgrades since "+Iif(dSrvDate>Ctod(r_ExpDt),r_AmcEdDt,r_ExpDt)+"."+;
						*!*							"You run the risk of not having the latest statutory updates in your software. "+Chr(13)+Chr(13)+;
						*!*							"Update your Annual Maintenenace Contract by contacting "+Alltrim(r_ename)+" or email accounts@udyogsoftware.com "+;
						*!*							"to avail the latest updates and our support."
						lcMessg = "Dear User,"+Chr(13)+Chr(13)+;
							"Your Application may not be upgraded with the latest software patches or upgrades since "+Alltrim(Iif(dSrvDate>Ctod(ueReadRegMe.r_ExpDt),ueReadRegMe.r_AmcEdDt,ueReadRegMe.r_ExpDt))+"."+;
							"You run the risk of not having the latest statutory updates in your software. "+Chr(13)+Chr(13)+;
							"Update your Annual Maintenenace Contract by contacting "+Chr(34)+Alltrim(ueReadRegMe.r_ename)+Chr(34)+" or email accounts@udyogsoftware.com "+;
							"to avail the latest updates and our support."
						&&vasant16/11/2010	Changes done for VU 10 (Standard/Professional/Enterprise)
					Endif

					*!*					Do Case
					*!*					Case  Between(Abs(lnDays),1,7)
					*!*						lcMessg = "Dear User,"+Chr(13)+Chr(13)+;
					*!*							"Annual Upgradation License Pack is not activated. You may not be able to download any "+;
					*!*							"software updates/patches. "+Chr(13)+Chr(13)+;
					*!*							"Please contact "+Alltrim(r_ename)+" for any assistance or visit us at www.udyogexcise.com or mail us at register@udyogsoftware.com"

					*!*					Case  !Between(Abs(lnDays),1,7) And Dow(dSrvDate)=4 And Between(Abs(lnDays),8,67)
					*!*						lcMessg = "Dear User,"+Chr(13)+Chr(13)+;
					*!*							"Annual Upgradation License Pack is not activated. You may not be able to download any "+;
					*!*							"software updates/patches. "+Chr(13)+Chr(13)+;
					*!*							"Please contact "+Alltrim(r_ename)+" for any assistance or visit us at www.udyogexcise.com or mail us at register@udyogsoftware.com"

					*!*					Case  !Between(Abs(lnDays),1,67) And Inlist(Day(dSrvDate),12,18,27) And Between(Abs(lnDays),68,157)
					*!*						lcMessg = "Dear User,"+Chr(13)+Chr(13)+;
					*!*							"Annual Upgradation License Pack is not activated. You may not be able to download any "+;
					*!*							"software updates/patches. "+Chr(13)+Chr(13)+;
					*!*							"Please contact "+Alltrim(r_ename)+" for any assistance or visit us at www.udyogexcise.com or mail us at register@udyogsoftware.com"

					*!*					Case  !Between(Abs(lnDays),1,157) And Inlist(Day(dSrvDate),16,28) And Between(Abs(lnDays),158,307)
					*!*						lcMessg = "Dear User,"+Chr(13)+Chr(13)+;
					*!*							"Annual Upgradation License Pack is not activated. You may not be able to download any "+;
					*!*							"software updates/patches. "+Chr(13)+Chr(13)+;
					*!*							"Please contact "+Alltrim(r_ename)+" for any assistance or visit us at www.udyogexcise.com or mail us at register@udyogsoftware.com"

					*!*					Case  !Between(Abs(lnDays),1,307) And Day(dSrvDate)= 2
					*!*						lcMessg = "Dear User,"+Chr(13)+Chr(13)+;
					*!*							"Annual Upgradation License Pack is not activated. You may not be able to download any "+;
					*!*							"software updates/patches. "+Chr(13)+Chr(13)+;
					*!*							"Please contact "+Alltrim(r_ename)+" for any assistance or visit us at www.udyogexcise.com or mail us at register@udyogsoftware.com"

					*!*					Endcase
					*********** Changes done by Sachin N. S. on 09/07/2010 for New Message Change *********** End

				Endif
				If !Empty(lcMessg)
					If reg_value = 'DONE'
						Do Form frmRegisterMsg With lcMessg+Chr(13)+Chr(13)+lcMesg1,.T.,.T.,.T.
						Read Events
						If lRgMsg
							lRgMsg=.F.
							Do ueGetCompInfo With 0,.F.,.T.,''
							Read Events
						Endif
					Else
						Do Form frmRegisterMsg With lcMessg+Chr(13)+Chr(13)+lcMesg1,.T.,.T.,.T.
						Read Events
						If lRgMsg
							lRgMsg=.F.
							Do ueGetCompInfo With 0,.F.,.T.,''
							Read Events
						Endif
					Endif
				Endif
			Endif

			*************** Added By Sachin N. S. on 15/07/2009 For Registration *************** Start
			*!*				If FirstReg
			*!*					If reg_value = 'DONE'
			*!*						lcMessg = "Dear User,"+Chr(13)+Chr(13)+;
			*!*							"We regret to inform you that your evaluation period has been expired and you will not be able to use the software."+;
			*!*							"We hope you have enjoyed using the software."+Chr(13)+Chr(13)+;
			*!*							"Please contact your nearest software vendor for any assistance."red And you will Not be able To Use the software."+;
			*!*
			*!*						Do Form frmRegisterMsg With lcMessg,.T.,.T.
			*!*						Read Events
			*!*					endif
			*!*				Endif
			*************** Added By Sachin N. S. on 15/07/2009 For Registration *************** End

			*************** Added By Sachin N. S. on 06/07/2009 *************** Start
			&&vasant16/11/2010	Changes done for VU 10 (Standard/Professional/Enterprise)
			*If Inlist(Upper(Alltrim(r_srvtype)),'PREMIUM','NORMAL')
			*!*			If Inlist(Upper(Alltrim(ueReadRegMe.r_srvtype)),'PREMIUM','NORMAL') && Commented by Archana K. on 21/02/13 for Bug-7899

			If Inlist(Upper(Alltrim(ueReadRegMe.r_srvtype)),'PREMIUM','NORMAL','VIEWER VERSION') && Changed by Archana K. on 21/02/13 for Bug-7899
				r_Compn = ueReadRegMe.r_Compn
				&&vasant16/11/2010	Changes done for VU 10 (Standard/Professional/Enterprise)
				***** Added by Sachin N. S. on 06/12/2016 for GST Vudyog Database Working -- Start
				_ProdCode = Cast(GlobalObj.getpropertyval("udProdCode") As Varbinary(250))
				lcCondi = ""
				lcCondi = lcCondi + " (prodCode = ?_ProdCode or prodCode is null or prodCode = '' ) "
				***** Added by Sachin N. S. on 06/12/2016 for GST Vudyog Database Working -- End

				*!*					msqlstr = " select [co_Name] from vUdyog..co_Mast where co_Name = ?r_Compn "
				msqlstr = " select [co_Name] from vUdyog..co_Mast where co_Name = ?r_Compn "+Iif(!Empty(lcCondi)," and "+lcCondi,"")		&& Changed by Sachin N. S. on 06/12/2016 for GST Vudyog Database Working
				nretval = oSqlConObj.dataconn("EXE","vUdyog",msqlstr,"_coExists","nHandle")
				If nretval<0
					Return .F.
				Endif

				Select _coExists
				If Reccount()=0			&& Company Registered or not Check
					=Messagebox("Company created doesnot match with the registered company.",0+16,vumess)
					reg_value = "NOT DONE"
					Do Unreg_data
					exitclick=.T.
					Return .F.
				Endif
			Endif
			*************** Added By Sachin N. S. on 06/07/2009 *************** End
			&&vasant060410a
			*!*			msqlstr = " Select COUNT(a.Co_name) as cnt1 from (select co_name from Vudyog..co_Mast where Co_Name Not Like 'Udyog Testing%' group by co_name) a "
			*!*			nretval = oSqlConObj.dataconn("EXE","Vudyog",msqlstr,"_CoCount","nHandle")
			*!*			If nretval<0
			*!*				Return .F.
			*!*			Endif
			*!*			lnCnt = _CoCount.cnt1

			lnvuentExempt=0				&& Added by Sachin N. S. on 24/08/2016 for Bug-28561
			lnmulticoiovtExempt=0		&& Added by Sachin N. S. on 24/08/2016 for Bug-28561

			*		If !Inlist(dec(NewDecry(GlobalObj.getpropertyval("UdProdCode"),'Ud*yog+1993')),'VudyogSTD','VudyogPRO','VudyogENT')	&& Added By Sachin N. S. on 01/04/2011 for TKT-6920
			*!*			If !Inlist(dec(NewDecry(GlobalObj.getpropertyval("UdProdCode"),'Ud*yog+1993')),'VudyogSTD','VudyogPRO','VudyogENT','10USquare','10iTax','VUTrader')	&&Changed For Bug-2286 USquare 10.0 Installer : By Amrendra on 15-02-2012	&&Changes has been done by Sachin & Vasant on 30/10/2013 for Bug 20574 (VU Trader Installer required).
			If !Inlist(dec(NewDecry(GlobalObj.getpropertyval("UdProdCode"),'Ud*yog+1993')),'VudyogSTD','VudyogPRO','VudyogENT','10USquare','10iTax','VUTrader','VudyogGST')		&& Changed by Sachin N. S. on 30/09/2016 for GST
				_cPassroute1 = Iif(Type('_co_mast.passroute1')!='U',',passroute1','')	&& Added By Sachin N. S. on 26/08/2011 for TKT-8128
				*!*				msqlstr = "Select co_name,passroute from co_Mast order by end_dt desc"		&& Changed By Sachin N. S. on 26/08/2011 for TKT-8128
				*!*				msqlstr = "Select co_name,passroute"+_cPassroute1+" from co_Mast order by end_dt desc"
				msqlstr = "Select co_name,passroute"+_cPassroute1+" from co_Mast where enddir='' order by end_dt desc"	&& Changed by Sachin N. S. on 29/08/2016 for Bug-28561
				nretval = oSqlConObj.dataconn("EXE","Vudyog",msqlstr,"_CoMaster","nHandle")
				If nretval<0
					Return .F.
				Endif
				lnCnt = 0
				lnExemptCount = 0
				Select _CoMaster
				Index On Co_name Tag Co_name Unique
				Scan
					If Left(Upper(_CoMaster.Co_name),13) = 'UDYOG TESTING'
						Loop
					Endif
					pvalue = Allt(_CoMaster.PassRoute)
					Buffer = ""
					For i = 1 To Len(pvalue)
						Buffer = Buffer + Chr(Asc(Substr(pvalue,i,1))/2)
					Next i

					***** Added By Sachin N. S. on 26/08/2011 for TKT-8128 ***** Start
					Buffer1 = ""
					If Type('_co_mast.Passroute1')!='U'
						pvalue1 = Allt(_CoMaster.PassRoute1)
						Buffer1 = ""
						For i = 1 To Len(pvalue1)
							Buffer1 = Buffer1 + Chr(Asc(Substr(pvalue1,i,1))/2)
						Next i
					Endif
					***** Added By Sachin N. S. on 26/08/2011 for TKT-8128 ***** End

					*!*					If "vuent" $ pvalue And !("vuent" $ reg_prods)
					*!*					If 	("vuent" $ Buffer And !("vuent" $ reg_prods) And "multicoiov" $ Buffer1) Or 			&& Changed by Sachin N. S. on 18/03/2013 for Bug-10672
					If 	("vuent" $ Buffer And !("vuent" $ reg_prods)) Or ;											&& Added by Sachin N. S. on 18/03/2013 for Bug-10672
						("vupro" $ Buffer And !("vupro" $ reg_prods) And "multicoiov" $ Buffer1) Or ;
							("vuinv" $ Buffer And !("vuinv" $ reg_prods) And "multicoiov" $ Buffer1) Or ;
							("vuord" $ Buffer And !("vuord" $ reg_prods) And "multicoiov" $ Buffer1) Or ;
							("vutds" $ Buffer And !("vutds" $ reg_prods) And "multicoiov" $ Buffer1)			&& Changes by Sachin N. S. on 25/05/2011 for TKT-8128 Multi-Company
						lnExemptCount = lnExemptCount + 1
					Endif
					******* Added by Sachin N. S. on 24/08/2016 for Bug-28561 -- Start
					If "vuent" $ Buffer
						lnvuentExempt = lnvuentExempt + 1
					Endif

					If (("vupro" $ Buffer Or "vuinv" $ Buffer Or "vuord" $ Buffer Or "vutds" $ Buffer) And "multicoiovt" $ Buffer1)
						lnmulticoiovtExempt = lnmulticoiovtExempt + 1
					Endif
					******* Added by Sachin N. S. on 24/08/2016 for Bug-28561 -- End

					Buffer = Strtran(Buffer,'vuent','')
					Buffer = Strtran(Buffer,'vupro','')		&& Added By Sachin N. S. on 23/05/2011 for TKT-8128 Multi-Company
					Buffer = Strtran(Buffer,'vuinv','')		&& Added By Sachin N. S. on 23/05/2011 for TKT-8128 Multi-Company
					Buffer = Strtran(Buffer,'vuord','')		&& Added By Sachin N. S. on 23/05/2011 for TKT-8128 Multi-Company
					Buffer = Strtran(Buffer,'vutds','')		&& Added By Sachin N. S. on 23/05/2011 for TKT-8128 Multi-Company

					***** Added by Sachin N. S. on 29/08/2016 for Bug-28561 -- Start
					Buffer = removemodcode(Buffer,lnmulticoiovtExempt,"tdsgen")
					Buffer = removemodcode(Buffer,lnmulticoiovtExempt,"vatgen")
					***** Added by Sachin N. S. on 29/08/2016 for Bug-28561 -- End

					If Empty(Buffer)
						Loop
					Endif
					lnCnt = lnCnt + 1
				Endscan
				lnCnt = lnCnt + lnExemptCount
				&&vasant060410a

				If lnCnt > r_coof
					=Messagebox("Number of company registered is less than the company created."+Chr(13)+;
						"Please contact your service center for upgrading.",0+16,vumess)
					exitclick=.T.
					Return .F.
				Endif
				******* Added By Sachin N. S. on 19/04/2011 for TKT-6920 ******* Start
			Else

				*!*				If Inlist(Upper(Alltrim(ueReadRegMe.r_srvtype)),'PREMIUM','NORMAL') && Commented by Archana K. on 21/02/13 for Bug-7899
				If Inlist(Upper(Alltrim(ueReadRegMe.r_srvtype)),'PREMIUM','NORMAL','VIEWER VERSION')&& Changed by Archana K. on 21/02/13 for Bug-7899
					_CompFound = .F.
					cProd_cd = ""
					***** Added by Sachin N. S. on 06/12/2016 for GST Vudyog Database Working -- Start
					_ProdCode = Cast(GlobalObj.getpropertyval("udProdCode") As Varbinary(250))
					lcCondi = ""
					lcCondi = lcCondi + " (prodCode = ?_ProdCode or prodCode is null or prodCode = '' ) "
					***** Added by Sachin N. S. on 06/12/2016 for GST Vudyog Database Working -- End

					*!*					msqlstr = "Select co_name,passroute from co_Mast order by end_dt desc"

					_cPassroute1 = Iif(Type('_co_mast.passroute1')!='U',',passroute1','')	&& Added by Sachin N. S. on 29/08/2016 for Bug-28561
					*!*						msqlstr = "Select co_name,passroute"+_cPassroute1+" from co_Mast where enddir='' order by Compid,end_dt desc"	&& Changed by Sachin N. S. on 29/08/2016 for Bug-28561
					msqlstr = "Select co_name,passroute"+_cPassroute1+" from co_Mast where enddir='' "++Iif(!Empty(lcCondi)," and "+lcCondi,"")+" order by Compid,end_dt desc"		&& Changed by Sachin N. S. on 06/12/2016 for GST Vudyog Database Working
					mRet=oSqlConObj.dataconn("EXE","Vudyog",msqlstr,"_CoMaster","nhandle")
					If mRet <= 0
						Return .F.
					Endif
					mRet=oSqlConObj.sqlconnclose("nhandle")
					If mRet <= 0
						Return .F.
					Endif
					lnExempt=0
					lnvuent=0
					lnCnt=0
					Select _CoMaster
					*!*					Index On Co_name Tag Co_name Unique			&& Commented by Sachin N. S. on 29/08/2016 for Bug-28561
					Scan
						Select _CoMaster
						If Left(Upper(_CoMaster.Co_name),13) = 'UDYOG TESTING'
							Loop
						Endif
						pvalue = Allt(_CoMaster.PassRoute)
						Buffer = ""
						For i = 1 To Len(pvalue)
							Buffer = Buffer + Chr(Asc(Substr(pvalue,i,1))/2)
						Next i

						***** Added By Sachin N. S. on 26/08/2011 for TKT-8128 ***** Start
						Buffer1 = ""
						If Type('_CoMaster.PassRoute1')!='U'
							pvalue1 = Allt(_CoMaster.PassRoute1)
							Buffer1 = ""
							For i = 1 To Len(pvalue1)
								Buffer1 = Buffer1 + Chr(Asc(Substr(pvalue1,i,1))/2)
							Next i
						Endif
						***** Added By Sachin N. S. on 26/08/2011 for TKT-8128 ***** End

						*!*						If "vuent" $ Buffer
						If "vuent" $ Buffer Or (("vupro" $ Buffer Or "vuinv" $ Buffer Or "vuord" $ Buffer Or "vutds" $ Buffer) And "multicoiov" $ Buffer1)		&& Changes by Sachin N. S. on 25/05/2011 for TKT-8128 Multi-Company
							lnvuent=1
							lnExempt = lnExempt + 1
						Endif
						******* Added by Sachin N. S. on 24/08/2016 for Bug-28561 -- Start
						If "vuent" $ Buffer
							lnvuentExempt = lnvuentExempt + 1
						Endif

						If (("vupro" $ Buffer Or "vuinv" $ Buffer Or "vuord" $ Buffer Or "vutds" $ Buffer) And "multicoiovt" $ Buffer1)
							lnmulticoiovtExempt = lnmulticoiovtExempt + 1
						Endif
						******* Added by Sachin N. S. on 24/08/2016 for Bug-28561 -- End

						Buffer = Strtran(Buffer,'vuent','')
						Buffer = Strtran(Buffer,'vupro','')		&& Added By Sachin N. S. on 23/05/2011 for TKT-8128 Multi-Company
						Buffer = Strtran(Buffer,'vuinv','')		&& Added By Sachin N. S. on 23/05/2011 for TKT-8128 Multi-Company
						Buffer = Strtran(Buffer,'vuord','')		&& Added By Sachin N. S. on 23/05/2011 for TKT-8128 Multi-Company
						Buffer = Strtran(Buffer,'vutds','')		&& Added By Sachin N. S. on 23/05/2011 for TKT-8128 Multi-Company

						***** Added by Sachin N. S. on 29/08/2016 for Bug-28561 -- Start
						Buffer = removemodcode(Buffer,lnmulticoiovtExempt,"tdsgen")
						Buffer = removemodcode(Buffer,lnmulticoiovtExempt,"vatgen")
						***** Added by Sachin N. S. on 29/08/2016 for Bug-28561 -- End

						If Empty(Buffer)
							Loop
						Endif
						*!*						lnCnt = lnCnt + Icase("vupro" $ Buffer,1,"vuexc" $ Buffer,1,"vuexp" $ Buffer,1,"vuinv" $ Buffer,1,"vuord" $ Buffer,1,"vubil" $ Buffer,1,"vutex" $ Buffer,1,"vuser" $ Buffer,1,"vuisd" $ Buffer,1,"vumcu" $ Buffer,1,"vutds" $ Buffer,1,0)
						*!*						lnCnt = lnCnt + Icase("vuexc" $ Buffer,1,"vuexp" $ Buffer,1,"vubil" $ Buffer,1,"vutex" $ Buffer,1,"vuser" $ Buffer,1,"vuisd" $ Buffer,1,"vumcu" $ Buffer,1,Iif(lnvuent<=0,1,0)) 		&& Changed By Sachin N. S. on 23/05/2011 for TKT-8128 Multi-Company
						lnCnt = lnCnt + Icase("vuexc" $ Buffer,1,"vuexp" $ Buffer,1,"vubil" $ Buffer,1,"vutex" $ Buffer,1,"vuser" $ Buffer,1,"vuisd" $ Buffer,1,"vumcu" $ Buffer,1,"vugst" $ Buffer,1,Iif(lnvuent<=0,1,0)) 		&& Changed By Sachin N. S. on 30/09/2016 for GST

						Select _CoMaster
					Endscan

					If lnCnt>r_coof
						=Messagebox("Number of company registered is less than the company created."+Chr(13)+;
							"Please contact your service center for upgrading.",0+16,vumess)
						exitclick=.T.
						Return .F.
					Endif
				Endif
			Endif
			******* Added By Sachin N. S. on 19/04/2011 for TKT-6920 ******* End
		Endif
		mRet=oSqlConObj.sqlconnclose("nhandle")		&& Added By Sachin N. S. on 29/04/2010
		If mRet< 0
			Return .F.
		Endif
	Endif
Endproc

&&vasant060410
Define Class iLicenseServiceTimer As Timer
	Interval = 60000
	Enabled = .T.
	Visible = .T.
	lastrun = Seconds()

	Func Timer
		Local m_LicenseServiceValidate
		m_LicenseServiceValidate = ''
		*If Type('getpem(GlobalObj,"LicenseRenew")') = 'O'	&&vasant16/11/2010	Changes done for VU 10 (Standard/Professional/Enterprise)
		If Type('pemstatus(GlobalObj,"LicenseRenew",3)') = 'C'	&&vasant16/11/2010	Changes done for VU 10 (Standard/Professional/Enterprise)
			m_LicenseServiceValidate = GlobalObj.LicenseRenew()
		Endif
		If Type('m_LicenseServiceValidate') <> 'C'
			m_LicenseServiceValidate = ''
		Endif
		If !m_LicenseServiceValidate == 'LRENEW'
			If Type('statdesktop') = 'O'
				statdesktop.Message = 'Terminating.....'
				statdesktop.terminatetimer.Interval = 1
				statdesktop.terminatetimer.Enabled  = .T.
			Endif
		Else
			lastrun = Seconds()
		Endif
		Release m_LicenseServiceValidate
	Endfunc

Enddefine

***** Added by Sachin N. S. on 29/08/2016 for Bug-28561 -- Start
Procedure removemodcode
	Lparameters cBuffer,lnmulticoiovtExempt,_cProdCode
	Local nrecno
	If lnmulticoiovtExempt>0
		If !Used('_curProdList')
			sqlconobj1=Newobject('sqlconnudobj',"sqlconnection",xapps)
			_nHandle1Rem=0
			Create Cursor _curProdList (lSel L, cProdName c(100), cProdCode c(15), cCmbNotAlwd c(250), cModDep c(250), cMainProdCode c(250), nProdType N(2), nOrder c(30))
			Index On nOrder Tag nOrder
			cPdCd = GlobalObj.getpropertyval("UdProdCode")

			msqlstr = " select ENC1, ENC2 FROM MODULEMAST WHERE ENC1 = ?cPdCd "
			nretval=sqlconobj1.dataconn('EXE',"Vudyog",msqlstr,"_tmpProduct","_nHandle1Rem")
			If nretval <= 0
				Return .F.
			Endif
			nretval=sqlconobj1.sqlconnclose("_nHandle1Rem")

			Select _tmpProduct
			Scan
				Select _tmpProduct

				cDec = NewDecry(Alltrim(Cast(_tmpProduct.Enc2 As Blob)),'Udyog!Module!Mast')

				cModCd = Strextract(cDec,'~*1*~','~*1*~')
				cModNm = Strextract(cDec,'~*2*~','~*2*~')
				cModDp = Strextract(cDec,'~*3*~','~*3*~')
				cModEx = Strextract(cDec,'~*4*~','~*4*~')
				cPrdCd = Strextract(cDec,'~*5*~','~*5*~')
				_norder = Strextract(cDec,'~*6*~','~*6*~')
				_nOrder1 = Alltrim(Iif(At('.',_norder) > 0,Substr(_norder,1,At('.',_norder)-1),_norder))
				_nOrder2 = Alltrim(Iif(At('.',_norder) > 0,Substr(_norder,At('.',_norder)+1),''))
				_norder = Iif(Val(_nOrder1) > 0,'A','Z')+Padl(_nOrder1,10,'0')+Iif(Empty(cModDp),'A','Z')+Iif(Val(_nOrder2) > 0,'A','Z')+Padl(_nOrder2,10,'0')

				If !Inlist(Upper(cModCd),'OTHERS')
					Insert Into _curProdList Values(.F., cModNm, cModCd, cModEx, cModDp, cPrdCd, Iif(!Empty(cModDp),2,1),_norder)
				Endif
				Select _tmpProduct
			Endscan

			Select _curProdList
			Go Top
		Endif

		Select _curProdList
		Scan For Alltrim(cModDep)==_cProdCode
			Select _curProdList
			cBuffer = Strtran(cBuffer,_cProdCode,'')
			cBuffer = Strtran(cBuffer,Alltrim(_curProdList.cProdCode),'')
			If Empty(cBuffer)
				Exit
			Endif
			removemodcode(cBuffer,lnmulticoiovtExempt,Alltrim(_curProdList.cProdCode))
			Select _curProdList
		Endscan
	Endif
	Return cBuffer
Endproc
***** Added by Sachin N. S. on 29/08/2016 for Bug-28561 -- End
