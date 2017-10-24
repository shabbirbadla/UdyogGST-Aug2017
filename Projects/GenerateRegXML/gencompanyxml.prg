Set Safety Off
Set Multilocks On
Set Deleted On
Set Century On
Set Date To british
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
xapps2 = SYS(16,1)

PUBLIC _input,icoPath
_input = 1
apath = Allt(Fullpath(Curd()))
icopath = ""
icoPath = ADDBS(apath)+'bmp\ueicon.ico'
vumess		= ''

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


_Screen.Caption  = vumess

Set Procedure To sqlConnection Additive
Set Classlib To sqlConnection In &xapps2 Additive && Setting Class library
Set Classlib To UdGeneral.vcx In &xapps2 ADDITIVE && Setting Class library
GlobalObj = Createobject("UdGeneral")
If Type('GlobalObj') != 'O'
	Retu .F.
Endif
vumess = GlobalObj.getpropertyval("vumess")


If mvu_backend # "0"
	Do Case
	Case Empty(mvu_server)
		Messagebox("ERROR !!!, Data server not defined",32,vumess)
		Retu .F.
	Case Empty(mvu_user)
		Messagebox("ERROR !!!, User name not defined",32,vumess)
		Retu .F.
	Endcase
Endif

Close Data All	&& closing database invoice which is automatically opened with lmain

Local sqlconobj
sqlconobj=Newobject('sqlconnudobj',"sqlconnection",xapps2)

Do Form frmGetCompInfo WITH 0,.f.,.f.
READ events

Proc enc
********
Para mcheck
d=1
F=Len(mcheck)
Repl=""
rep=0
Do Whil F > 0
	r=Subs(mcheck,d,1)
	Change = Asc(r)+rep
	If Change>255
		Wait Wind Str(Change)
	Endi
	two = Chr(Change)
	Repl=Repl+two
	d=d+01
	rep=rep+1
	F=F-1
Endd
Retu Repl

Proc dec
********
Para mcheck
d=1
F=Len(mcheck)
Repl=""
rep=0
Do Whil F > 0
	r=Subs(mcheck,d,1)
	Change = Asc(r)-rep
	If Change>0
		two = Chr(Change)
	Endi
	Repl=Repl+two
	d=d+01
	F=F-1
	rep=rep+1
Endd
Retu Repl

Procedure onencrypt
*****************
Lpara lcvariable
lcreturn = ""
For i=1 To Len(lcvariable)
	lcreturn=lcreturn+Chr(Asc(Substr(lcvariable,i,1))+Asc(Substr(lcvariable,i,1)))
Endfor
Return lcreturn

Procedure ondecrypt
*****************
Lpara lcvariable
lcreturn = ""
For i=1 To Len(lcvariable)
	lcreturn=lcreturn+Chr(Asc(Substr(lcvariable,i,1))/2)
Endfor
Return lcreturn


PROCEDURE NewENCRY
LPARAMETERS _NewEncryValue,_NewEncryPass
LOCAL lcVFPEncryptionFile,_FileValidErr,_EncRetValue
_EncRetValue = '*1*'
_FileValidErr = ''
IF !FILE('UECON.EXE')
	Messagebox("UECON.EXE file not found",16,vumess)
	quit
Endif
TRY 
	IF !('UECON.EXE' $ UPPER(SET("Library")))
		lcVFPEncryptionFile = FileToStr("uecon.exe")
		SET LIBRARY TO uecon.exe Addi
		if Len(lcVFPEncryptionFile) = 122880 ;
		   and StrConv(Hash(lcVFPEncryptionFile,5),15) == '20A7D4AF02E62A362CE44FCBAB6EB5FE';
		   and StrConv(Hash(lcVFPEncryptionFile,4),15) == 'DBD1EC320842ED0DB1A4DAE26F0513E4DF1F9D1C65FB93D896E553940ACFA408479EDFBE78FCEA9901915384E5FBC1C50CCD00709C0CD870CA8A4C8BC40676EF'
		Else 
		   	_FileValidErr = 'Error'
		ENDIF
	ENDIF 
	IF EMPTY(_FileValidErr)
		_EncRetValue = ENCRYPT(_NewEncryValue,_NewEncryPass,1024) 
	ENDIF
CATCH TO _FileValidErr	
	_EncRetValue = '*1*'
ENDTRY
RETURN _EncRetValue


PROCEDURE NewDECRY
LPARAMETERS _NewDecryValue,_NewDecryPass
LOCAL lcVFPEncryptionFile,_FileValidErr,_DecRetValue
_DecRetValue = '+1+'
_FileValidErr = ''
IF !FILE('UECON.EXE')
	Messagebox("UECON.EXE file not found",16,vumess)
	quit
Endif
TRY 
	IF !('UECON.EXE' $ UPPER(SET("Library"))) 
		lcVFPEncryptionFile = FileToStr("uecon.exe")
		SET LIBRARY TO uecon.exe Addi
		if Len(lcVFPEncryptionFile) = 122880 ;
		   and StrConv(Hash(lcVFPEncryptionFile,5),15) == '20A7D4AF02E62A362CE44FCBAB6EB5FE';
		   and StrConv(Hash(lcVFPEncryptionFile,4),15) == 'DBD1EC320842ED0DB1A4DAE26F0513E4DF1F9D1C65FB93D896E553940ACFA408479EDFBE78FCEA9901915384E5FBC1C50CCD00709C0CD870CA8A4C8BC40676EF'	   
		Else 
		   	_FileValidErr = 'Error'
		ENDIF
	ENDIF 
	IF EMPTY(_FileValidErr)
		_DecRetValue = DECRYPT(_NewDecryValue,_NewDecryPass,1024)
	ENDIF
CATCH TO _FileValidErr	
	_DecRetValue = '+2+'
ENDTRY
RETURN _DecRetValue
