*:*****************************************************************************
*:        Program: Main
*:         System: Udyog Software
*:         Author: Rupesh
*:  Last modified: 
*:			AIM  : Call Item Master Rate Update
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

&&Rup Bug-2471--->
rCount=0
nhandle     = 0
_etdatasessionid = _Screen.ActiveForm.DataSessionId
Set DataSession To _etdatasessionid
StrSql="usp_alert_List '"+ALLTRIM(musername)+"'"
etsql_con = sqlconobj.dataconn([EXE],company.dbname,StrSql,[tAlert_Vw],"nHandle",_etdatasessionid,.F.)
If etsql_con >0 AND Used("tAlert_Vw")
	SELECT tAlert_Vw
	rCount=RECCOUNT()
	etsql_con = 0
ENDIF 
&&<--- Bug-2471 Rup


IF (rCount>0)
	vicopath=STRTRAN(icopath,' ','<*#*>')
	pApplCaption=STRTRAN(vumess,' ','<*#*>')
	_ShellExec ="UdAlert.exe "+TRANSFORM(tcCompId)+" "+ALLTRIM(tcCompdb)+" "+ALLTRIM(mvu_server)+" "+ALLTRIM(mvu_user1)+" "+ALLTRIM(mvu_pass1)+" "+musername+" "+ALLTRIM(vicopath)+" "+pApplCaption+" "+pApplName+" "+ALLTRIM(STR(pApplId))  +" "+ALLTRIM(pApplCode)++" "+ALLTRIM(mvu_User_Roles)
	oWSHELL.Run(_ShellExec,1,.t.)
ENDIF 
SqlConObj = NULL
mvu_user1 = NULL
mvu_pass1 = NULL
RELEASE SqlConObj,mvu_user1,mvu_pass1


