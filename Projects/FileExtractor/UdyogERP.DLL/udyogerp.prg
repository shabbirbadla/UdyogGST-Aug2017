DEFINE CLASS udyogerp as Custom OLEPUBLIC 
	mvu_backend=''
	mvu_server=''
	mvu_user=''
	mvu_pass=''
	PROTECTED FUNCTION enc (mcheck As String)
*:*****************************************************************************
*:         Method: Dec
*:         System: Udyog Software
*:         Author: RND
*:  Last modified: 01/03/2008
*:			AIM  : Encrypt String
*:*****************************************************************************
*:*****************************************************************************
*:	mCheck 		 : 	Encrypted String
*:*****************************************************************************
*:  Usage lcIns = Dec()
*:*****************************************************************************
		d=1
		F=Len(mcheck)
		lcRepl=""
		rep=0
		Do While F > 0
			r=Substr(mcheck,d,1)
			lcChange = Asc(r)+rep
			If lcChange>255
				Wait Window Str(lcChange)
			Endi
			two = Chr(lcChange)
			lcRepl=lcRepl+two
			d=d+01
			rep=rep+1
			F=F-1
		Enddo
		Return lcRepl

	PROTECTED FUNCTION dec(mcheck As String)
*:*****************************************************************************
*:         Method: Dec
*:         System: Udyog Software
*:         Author: RND
*:  Last modified: 01/03/2008
*:			AIM  : Decrypt Encrypted String
*:*****************************************************************************
*:*****************************************************************************
*:	mCheck 		 : Encrypted String
*:*****************************************************************************
*:  Usage lcIns  = Dec()
*:*****************************************************************************
		d=1
		F=Len(mcheck)
		lcRepl=""
		rep=0
		Do While F > 0
			r=Subs(mcheck,d,1)
			lcChange = Asc(r)-rep
			If lcChange>0
				two = Chr(lcChange)
			Endif
			lcRepl=lcRepl+two
			d=d+01
			F=F-1
			rep=rep+1
		Enddo
		Return lcRepl

	PROTECTED FUNCTION ondecrypt (lcvariable as string)
		lcreturn = ""
		for i=1 to len(lcvariable)
			lcreturn=lcreturn+chr(asc(substr(lcvariable,i,1))/2)
		endfor
		return lcreturn

	PROTECTED FUNCTION onencrypt (lcvariable as string)

		lcreturn = ""
		for i=1 to len(lcvariable)
			lcreturn=lcreturn+chr(asc(substr(lcvariable,i,1))+asc(substr(lcvariable,i,1)))
		endfor
		return lcreturn

	FUNCTION GetVal (aPath as String,aValue as String )
	declare integer GetPrivateProfileString in Win32API as GetPrivStr ;
		string cSection, string cKey, string cDefault, string @cBuffer, ;
		integer nBufferSize, string cINIFile
	declare integer WritePrivateProfileString in Win32API as WritePrivStr ;
		string cSection, string cKey, string cValue, string cINIFile

	IF aValue="Encrypt"
		RETURN this.onencrypt(this.enc(aPath))
	ENDIF 
	IF  aValue="Decrypt"
		RETURN THIS.dec(THIS.ondecrypt(aPath))
	ENDIF 
	
	public mvu_backend,mvu_server,mvu_user,mvu_pass,oneKey_Server,oneKey_user,oneKey_Pass
	*public oneKey_Server,oneKey_user,oneKey_Pass
		apath=STRTRAN(aPath,'\\','\')
		apath=ADDBS(aPath)
	if !file(aPath + "visudyog.ini")
		*messagebox("Configuration File Not found",32,vumess)
		retu "File Not Found"
	ENDIF
		mvu_one     = space(2000)
		mvu_two     = 0
	DO CASE
	CASE aValue="Name"
		mvu_two     = GetPrivStr([DataServer],"Name", "", @mvu_one, len(mvu_one), aPath + "visudyog.ini")
		*this.mvu_server  = left(mvu_one,mvu_two)
		RETURN left(mvu_one,mvu_two)
	CASE aValue="XFile"
		mvu_two     = GetPrivStr([Settings],"XFile", "", @mvu_one, len(mvu_one), aPath + "visudyog.ini")
		*this.mvu_server  = left(mvu_one,mvu_two)
		*MESSAGEBOX(left(mvu_one,mvu_two))
		RETURN left(mvu_one,mvu_two)
	CASE aValue="User"
		mvu_two     = GetPrivStr([DataServer],this.onencrypt(this.enc("User")), "", @mvu_one, len(mvu_one), aPath + "visudyog.ini")
		mvu_user    = left(mvu_one,mvu_two)
		RETURN THIS.dec(THIS.ondecrypt(mvu_user))
	CASE aValue="Pass"
		mvu_two     = GetPrivStr([DataServer],this.onencrypt(this.enc("Pass")), "", @mvu_one, len(mvu_one), aPath + "visudyog.ini")
		mvu_pass    = left(mvu_one,mvu_two)
		RETURN THIS.dec(THIS.ondecrypt(mvu_pass))
	ENDCASE

ENDDEFINE
