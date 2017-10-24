DECLARE INTEGER GetPrivateProfileString IN Win32API AS GetPrivStr ;
	STRING cSection, STRING cKey, STRING cDefault, STRING @cBuffer, ;
	INTEGER nBufferSize, STRING cINIFile

LOCAL iniFilePath,lcExeName,ueapath,uexapps

ueapath = ALLT(SYS(5) + CURD())
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
	=MESSAGEBOX('In Configuration file Xfile Path cannot be empty',16,[Udyog ERP])
	RETURN .F.
ELSE
	IF !FILE(uexapps)
		=MESSAGEBOX('In Configuration file Specify application file is not found',16,[Udyog ERP])
		RETURN .F.
	ENDIF
	lcExeName = ALLT(uexapps)
	DO &lcExeName WITH [C]		
ENDIF
