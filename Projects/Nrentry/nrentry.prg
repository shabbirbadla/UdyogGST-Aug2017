parameters left1,top1,fieldname,addmode,editmode,lcNam,lccaption,lccolor,lclisting,lclistcon,lcsplchk,cQuery	
****Versioning**** Added By Amrendra On 01/06/2011
	LOCAL _VerValidErr,_VerRetVal,_CurrVerVal
	_VerValidErr = ""
	_VerRetVal  = 'NO'
_CurrVerVal='10.0.0.0' &&[VERSIONNUMBER]
	TRY
		_VerRetVal = AppVerChk('NRENTRY',_CurrVerVal,JUSTFNAME(SYS(16)))
	CATCH TO _VerValidErr
		_VerRetVal  = 'NO'
	Endtry	
	IF TYPE("_VerRetVal")="L"
		cMsgStr="Version Error occured!"
		cMsgStr=cMsgStr+CHR(13)+"Kindly update latest version of "+GlobalObj.getPropertyval("ProductTitle")
		Messagebox(cMsgStr,64,VuMess)
		Return .F.
	ENDIF
	IF _VerRetVal  = 'NO'
		Return .F.
	Endif
****Versioning****
_oldnaralias = alias()
do form NrEntry with left1,top1,fieldname,addmode,editmode,lcNam,lccaption,lccolor,lclisting,lclistcon,lcsplchk,cQuery	
IF !EMPTY(_oldnaralias)
	SELECT (_oldnaralias)
Endif
