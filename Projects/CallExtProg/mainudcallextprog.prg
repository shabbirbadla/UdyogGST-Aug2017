*:********************************************************************************************************************
*:        Program: Main
*:         System: Udyog Software
*:		 Added by: Vasant on 27/04/12
*:		  Purpose: To call any external program of USquare/VU10 Products
*:		Parameter details : 1st Paramets is EXE Name,last parameter is Range,others will be as per user requirement
*:********************************************************************************************************************
LPARAMETERS Para1,Para2,Para3,Para4,Para5,Para6,Para7,Para8,Para9,Para10,Para11,Para12,Para13,Para14,Para15
_LParaCnt = PARAMETERS()
_LError	= .f.
_Lparas = ''
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
tcCompdb = Company.Dbname
tcCompNm = Company.co_name

SqlConObj = NEWOBJECT('SqlConnUdObj','SqlConnection',xapps)
mvu_user1 = SqlConObj.dec(SqlConObj.ondecrypt(mvu_user))
mvu_pass1 = SqlConObj.dec(SqlConObj.ondecrypt(mvu_pass))
vicopath  =STRTRAN(icopath,' ','<*#*>')
pApplCaption=STRTRAN(vumess,' ','<*#*>')
_prodcode 	= ''
_PassRoute1 = Alltrim(Company.PassRoute1)
For i = 1 To Len(_PassRoute1)
	_prodcode = _prodcode + Chr(Asc(Substr(_PassRoute1,i,1))/2)
Next i
_prodcode = _prodcode+','

appNm		=""
pRange		=""
FOR i1 = 1 TO _LParaCnt
	_ParaVal = EVALUATE('Para'+ALLTRIM(STR(i1)))
	DO Case
	Case i1 = 1
		IF TYPE('_ParaVal') = 'C'
			appNm = _ParaVal
		Endif	
	Case i1 = _LParaCnt
		IF TYPE('_ParaVal') = 'C'	
			pRange = _ParaVal
		Endif	
	OTHERWISE
		_Lparas	= _Lparas+" "+STRTRAN(TRANSFORM(_ParaVal),' ','<*#*>')
	EndCase
ENDFOR 

IF EMPTY(appNm)
	=MESSAGEBOX("Check first parameter of the program",16,VuMess)
	_LError	= .t.
ENDIF 
IF EMPTY(pRange)
	=MESSAGEBOX("Check last parameter of the program",16,VuMess)
	_LError	= .t.	
ENDIF

IF _LError	= .f.
	Try
		_ShellExec = appNm+" "+TRANSFORM(tcCompId)+" "+ALLTRIM(tcCompdb)
		_ShellExec = _ShellExec+" "+ALLTRIM(mvu_server)+" "+ALLTRIM(mvu_user1)+" "+ALLTRIM(mvu_pass1) 
		_ShellExec = _ShellExec+" "+ALLTRIM(pRange)+" "+ALLTRIM(musername)+" "+ALLTRIM(vicopath)+" "+ALLTRIM(pApplCaption)
		_ShellExec = _ShellExec+" "+ALLTRIM(pApplName)+" "+ALLTRIM(STR(pApplId))  +" "+ALLTRIM(pApplCode)+" "+_prodcode+" "+_Lparas
		oWSHELL.EXEC(_ShellExec)
	CATCH TO _ErrMsg	
		=MESSAGEBOX(_ErrMsg.Message,16,VuMess)
	EndTry
ENDIF 

SqlConObj = NULL
mvu_user1 = NULL
mvu_pass1 = NULL
_prodcode = NULL
RELEASE SqlConObj,mvu_user1,mvu_pass1
