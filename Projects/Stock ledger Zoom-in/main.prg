PARAMETERS vDataSessionId,vit_name,vexecquery,vStkLstCall	&& Changed By Sachin N. S. on 30/08/2010 for TKT-3663
*!*	PARAMETERS vDataSessionId,vit_name,vexecquery
****Versioning**** && Added By Amrendra for TKT 8121 on 13-06-2011
	LOCAL _VerValidErr,_VerRetVal,_CurrVerVal
	_VerValidErr = ""
	_VerRetVal  = 'NO'
_CurrVerVal='10.0.0.0' &&[VERSIONNUMBER]
	TRY
		_VerRetVal = AppVerChk('ZOOMINSTOCKLEDGER',_CurrVerVal,JUSTFNAME(SYS(16)))
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
SET DATASESSION TO vDataSessionId
If !('CONFA2.VCX' $ Upper(Set("Classlib")))
	Set Classlib To confa2.vcx Additive
Endif

DO FORM uefrm_stk_ledger_zoom WITH vDataSessionId,vit_name,vexecquery,vStkLstCall	&& Changed By Sachin N. S. on 30/08/2010 for TKT-3663
*!*	DO FORM uefrm_stk_ledger_zoom WITH vDataSessionId,vit_name,vexecquery
