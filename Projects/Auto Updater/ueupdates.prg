_SCREEN.VISIBLE = .F.

DECLARE INTEGER GetPrivateProfileString IN Win32API AS GetPrivStr ;
	STRING cSection, STRING cKey, STRING cDefault, STRING @cBuffer, ;
	INTEGER nBufferSize, STRING cINIFile

LOCAL iniFilePath,lcExeName,ueapath,uexapps
PUBLIC _mVersion

_mVersion   = ''
ueapath     = ALLT(SYS(5) + CURD())
iniFilePath = ueapath+"visudyog.ini"

IF !FILE(iniFilePath)
	MESSAGEBOX("Configuration File Not found",16,'Udyog Admin')
	RETU .F.
ENDIF

mvu_one = SPACE(2000)
mvu_two = 0
mvu_two	= GetPrivStr([Settings],"XFile", "", @mvu_one, LEN(mvu_one), ueapath + "visudyog.ini")
uexapps = LEFT(mvu_one,mvu_two)

IF VARTYPE(uexapps) <> 'C' OR EMPTY(uexapps)
	=MESSAGEBOX('In Configuration file Xfile Path cannot be empty',16,[Udyog])
	RETURN .F.
ELSE
	IF !FILE(uexapps)
		=MESSAGEBOX('In Configuration file Specify application file is not found',16,[Udyog])
		RETURN .F.
	ENDIF
	
	lcExeName = ALLT(uexapps)
	=AGETFILEVERSION(_VersionArr,uexapps)
	IF TYPE('_VersionArr') = 'C'
		_mVersion = _VersionArr(1,4)
	Endif	
	IF OCCURS('.',_mVersion) = 2
		_mVersion = _mVersion + '.0'
	Endif
	
	DO &lcExeName WITH [U]
ENDIF






Define Class CustSqlConnUdObj As SqlConnUdObj

	PROCEDURE ShowError
		lparameters pmsg as string,_sqlconhandle,_logUser
		IF TYPE('_ShowErrMsgOrRetVal') != 'L'
			_ShowErrMsgOrRetVal = .f.
		Endif	
		_ShowErrMsgVal = ''
		
		local mret,merrmsg
		merrmsg = message()
		mret = sqlexec(&_sqlconhandle,"select @@error as Num", "_Error")
		IF !USED("_Error") OR mret <= 0
			RETURN .f.
		ENDIF
		sele _error
		do case
		case _error.num = 547
			if !empty(pmsg)
				IF _ShowErrMsgOrRetVal = .f.
					=messagebox(pmsg + chr(13) + chr(13) + alltr(merrmsg),64,vumess)
				ELSE
					_ShowErrMsgVal = pmsg + chr(13) + chr(13) + alltr(merrmsg)
				Endif	
			ELSE
				IF _ShowErrMsgOrRetVal = .f.
					=messagebox("Constraint violation Error" + chr(13) + chr(13) + alltr(merrmsg),64,vumess)
				ELSE
					_ShowErrMsgVal = "Constraint violation Error" + chr(13) + chr(13) + alltr(merrmsg)
				Endif						
			endif
		case _error.num = 2714 and 	_logUser = .t.
				IF _ShowErrMsgOrRetVal = .f.
					=messagebox(alltrim(pMsg),64,vumess)
				ELSE
					_ShowErrMsgVal = alltrim(pMsg)
				Endif						
		otherwise
			if !empty(pmsg)
				pmsg = pmsg + iif(!empty(pmsg), chr(13) + chr(13),"") + alltr(merrmsg)
			else
				pmsg = alltr(merrmsg)
			endif
			IF _ShowErrMsgOrRetVal = .f.
				=messagebox(pmsg,64,vumess)
			ELSE
				_ShowErrMsgVal = alltrim(pMsg)
			Endif					
			if type('statdesktop')='O'
				statdesktop.progressbar.visible = .f.
			endif
		endcase
		use
		return

Enddefine
