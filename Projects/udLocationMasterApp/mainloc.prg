*:*****************************************************************************
*:        Program: Main
*:         System: Udyog Software
*:         Added By: Rupesh
*:  Last modified: 
*:			AIM  : Call Location Master
*:*****************************************************************************
PARAMETERS pRange
IF VARTYPE(Company) <> "O"
	RETURN .F.
ENDIF

oWSHELL = CREATEOBJECT("WScript.Shell")
IF VARTYPE(oWSHELL) <> "O"
	MESSAGEBOX("WScript.Shell Object Creation Error...",16,VuMess)
	RETURN .F.
ENDIF

DECLARE INTEGER GetCurrentProcessId  IN kernel32

tcCompId = Company.CompId
tcCompdb =Company.Dbname
tcCompNm=Company.co_name
SqlConObj = NEWOBJECT('SqlConnUdObj','SqlConnection',xapps)
mvu_user1 = SqlConObj.dec(SqlConObj.ondecrypt(mvu_user))
mvu_pass1 = SqlConObj.dec(SqlConObj.ondecrypt(mvu_pass))
vicopath=STRTRAN(icopath,' ','<*#*>')
pApplCaption=STRTRAN(vumess,' ','<*#*>')
_ShellExec ="udLocationMaster.exe "+TRANSFORM(tcCompId)+" "+ALLTRIM(tcCompdb)+" "+ALLTRIM(mvu_server)+" "+ALLTRIM(mvu_user1)+" "+ALLTRIM(mvu_pass1) +" "+ALLTRIM(pRange)+" "+ALLTRIM(musername)+" "+ALLTRIM(vicopath)+" "+ALLTRIM(pApplCaption)+" "+ALLTRIM(pApplName)+" "+ALLTRIM(STR(pApplId))  +" "+ALLTRIM(pApplCode)+" "
oWSHELL.EXEC(_ShellExec)
*oWSHELL.Run(_ShellExec,1,.t.)
SqlConObj = NULL
mvu_user1 = NULL
mvu_pass1 = NULL
RELEASE SqlConObj,mvu_user1,mvu_pass1
