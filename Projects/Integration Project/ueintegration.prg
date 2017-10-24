Lparameters cRights

Local lcClassLib,lcProc,lcDirPath,lcDbName,lcCoName
lcClassLib=Set('Classlib')
lcProc=Set('proc')
lcDirPath=""
lcDbName=""
lcCoName=""

_screen.Visible=.f.

******************
If Type('company')='U'
	apath = Allt(Sys(5) + Curdir())
	Set Procedure To vu_udfs Additive
	SET PATH to apath+","+apath+"CLASS" additive

	Declare Integer GetPrivateProfileString In Win32API As GetPrivStr ;
		string cSection, String cKey, String cDefault, String @cBuffer, ;
		integer nBufferSize, String cINIFile

	mvu_one     = Space(2000)
	mvu_two     = 0

	mvu_two	    = GetPrivStr([Settings],"Backend", "", @mvu_one, Len(mvu_one), apath + "visudyog.ini")
	mvu_backend = Left(mvu_one,mvu_two)
	mvu_two     = GetPrivStr([DataServer],"Name", "", @mvu_one, Len(mvu_one), apath + "visudyog.ini")
	mvu_server  = Left(mvu_one,mvu_two)
	mvu_two     = GetPrivStr([DataServer],onencrypt(enc("User")), "", @mvu_one, Len(mvu_one), apath + "visudyog.ini")
	mvu_user    = Left(mvu_one,mvu_two)
	mvu_two     = GetPrivStr([DataServer],onencrypt(enc("Pass")), "", @mvu_one, Len(mvu_one), apath + "visudyog.ini")
	mvu_pass    = Left(mvu_one,mvu_two)
	mvu_backend = Iif(Empty(mvu_backend),"0",mvu_backend)
	*!*		mvu_two     = GetPrivStr([1KeyServer],"Name", "", @mvu_one, Len(mvu_one), apath + "visudyog.ini")
	*!*		OneKey_Server = Left(mvu_one,mvu_two)
	*!*		mvu_two     = GetPrivStr([1KeyServer],onencrypt(enc("User")), "", @mvu_one, Len(mvu_one), apath + "visudyog.ini")
	*!*		OneKey_user = Left(mvu_one,mvu_two)
	*!*		mvu_two     = GetPrivStr([1KeyServer],onencrypt(enc("Pass")), "", @mvu_one, Len(mvu_one), apath + "visudyog.ini")
	*!*		OneKey_Pass = Left(mvu_one,mvu_two)
	*!*		mvu_two		= GetPrivStr([Settings],"Title", "", @mvu_one, Len(mvu_one), apath + "visudyog.ini")
	vumess  	= Left(mvu_one,mvu_two)
	mvu_two		= GetPrivStr([Settings],"XFile", "", @mvu_one, Len(mvu_one), apath + "visudyog.ini")
	xapps	  	= Left(mvu_one,mvu_two)
	mvu_two		= GetPrivStr([Settings],"Split Table", "", @mvu_one, Len(mvu_one), apath + "visudyog.ini")
	mvu_Splittbl = Left(mvu_one,mvu_two)
	mvu_Splittbl = Iif(Vartype(mvu_Splittbl)<>"C","",mvu_Splittbl)
	*Set Classlib To apath+"\sqlconnudobj.vcx" In &xapps
	lcClass= 'Set Classlib To "sqlconnection.vcx" In &xapps Additive'
	&lcClass
Endif

******************
lcClass= 'Set Classlib To apath+"Class\Integration.vcx" ADDITIVE'
&lcClass


*!*	DO FORM frmIntegration 
oSession=CREATEOBJECT("session")
oObj=Createobject("Integration",oSession.datasessionid)
oObj.InitialProc()

STORE null TO oSession,oObj
RELEASE oObj,oSession

*!*	If Type("LoadObjSystray") = "O"
*!*		With LoadObjSystray
*!*			.cleariconlist()
*!*			.iconfile = apath+'Bmp\ueicon.ICO'
*!*			.addicontosystray()
*!*			.tiptext = vumess+" - Integration Solution"
*!*		Endwith
*!*	Endif
*!*	Read Events


*!*	oObj.dataconnect()

*!*	If Type('company')='U'
*!*		lcStr=" select * from Vudyog..co_mast "
*!*		nretval = oObj.sqlconobj.dataconn([EXE],"",lcStr,"TblCoMast","nHandle",1)
*!*		If nretval<=0
*!*			Return .F.
*!*		Endif

*!*		nretval=oObj.sqlconobj.sqlconnclose("nHandle")
*!*		If nretval<0
*!*			Return .F.
*!*		Endif
*!*		If Used('TblCoMast')
*!*			Select TblCoMast
*!*			*--------------*
*!*			Scan
*!*				lcDirPath=TblCoMast.dir_nm
*!*				lcDbName=TblCoMast.dbName
*!*				lcCoName=TblCoMast.co_Name
*!*				oObj.runFile(lcDirPath,lcDbName,lcCoName)
*!*			Endscan
*!*		Endif
*!*	Else
*!*		lcDirPath=company.dir_nm
*!*		lcDbName=company.dbName
*!*		lcCoName=company.co_Name
*!*		oObj.runFile(lcDirPath,lcDbName,lcCoName)
*!*	Endif

*!*	IF TYPE('oObj.prgressBar')<>'U'
*!*		oObj.removeobject('prgressBar')
*!*	endif

*!*	If Type('company')<>'U'
*!*		keyboard("Enter")
*!*		=MESSAGEBOX("Uploading of Records Completed"+CHR(13)+;
*!*					"Please check the Upload Status File in the respective Company Folder.",64,vumess)
*!*	endif

*!*	If !Empty(lcClassLib)
*!*		Set Classlib To &lcClassLib
*!*	Endif
*!*	If !Empty(lcProc)
*!*		Set Procedure To &lcProc
*!*	Endif


*!*	PROCEDURE Siconrightclickevent
*!*	WAIT WINDOW "Reach UDay"
*!*	IF TYPE("LoadObjSystray") = "O"
*!*		LoadObjSystray.txtSystrayEvent.Value = "Right-Click"
*!*		LoadObjSystray.Paint
*!*		LoadObjSystray.ShowMenu(this.genmenu)
*!*	ENDIF
*!*	RETURN

Procedure Selectpopup
	Lparameters tnbar,oObj
	Do Case
		Case tnbar = 1
			oObj.InitialProc()
		Case tnbar = 2
			oObj.removeiconfromsystray()
			oObj.RemoveObject('LoadObjSystray')
			Clear Events
	Endcase
	Deactivate Popup gridpopup
	Return
