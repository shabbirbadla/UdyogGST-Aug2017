Parameters vDataSessionId ,vexecquery,vdorepo
****Versioning**** && Added By Amrendra for TKT 8121 on 13-06-2011
	LOCAL _VerValidErr,_VerRetVal,_CurrVerVal
	_VerValidErr = ""
	_VerRetVal  = 'NO'
_CurrVerVal='10.0.0.0' &&[VERSIONNUMBER]
	TRY
		_VerRetVal = AppVerChk('ZOOMINSTOCKLIST',_CurrVerVal,JUSTFNAME(SYS(16)))
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

****** Added By Sachin N. S. on 19/01/2012 for BUG-1141 ****** Start
If !('CONFA3.VCX' $ Upper(Set("Classlib")))
	Set Classlib To Confa3.vcx Additive
Endif
****** Added By Sachin N. S. on 19/01/2012 for BUG-1141 ****** End

Select _Tmpvar
Scatter Name _oTmpvar
*!*	Do Form uefrm_stk_zoom With vDataSessionId ,0,vexecquery,vdorepo,_oTmpvar
Do Form uefrm_stk_zoom With vDataSessionId ,0,vexecquery,vdorepo,'',_oTmpvar	&& Changed By Sachin N. S. on 31/03/2010 for TKT-435
