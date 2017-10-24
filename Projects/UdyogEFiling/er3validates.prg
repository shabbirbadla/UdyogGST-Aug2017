
PROCEDURE BeforeRawXMLUpdates
SET STEP ON 
_errmessage = ''
IF !USED('lst_exc')
	_errmessage = 'Unable to find output table'
Endif
IF !EMPTY(_errmessage)
	RETURN _errmessage
Endif	

*DELETE FROM lst_exc WHERE qm = '3' AND EMPTY(entry_ty)	&&vasant251010
SELECT entry_ty FROM lst_exc WHERE qm='3' INTO CURSOR _lst_exc1
IF USED('_lst_exc1')	
	SELECT _lst_exc1
	IF RECCOUNT() = 1 AND EMPTY(_lst_exc1.entry_ty)
		_errmessage = 'Details of the Manufacture, Clearance And Duty Payable Not Found'
	Endif
	USE IN _lst_exc1
ELSE
	_errmessage = 'Excise Table Checking Error'
ENDIF
IF !EMPTY(_errmessage)
	RETURN _errmessage
Endif	

DO Case
Case mProduct = 'VU8'
	SELECT e_name,e_name as newe_name FROM lst_exc WHERE !EMPTY(e_name) GROUP BY e_name INTO CURSOR _lst_exc1 readwrite
Case mProduct = 'VU9'
	SELECT e_name,e_name as newe_name  FROM lst_exc WHERE !EMPTY(e_name) GROUP BY e_name INTO CURSOR _lst_exc1 readwrite ;
		Union All ;
		SELECT shortnm as e_name,shortnm as newe_name  FROM lst_exc WHERE !EMPTY(shortnm) GROUP BY shortnm
ENDCASE	
IF USED('_lst_exc1')	
	SELECT _lst_exc1
	SCAN
		_mnewe_name = ALLTRIM(_lst_exc1.newe_name)
		DO WHILE .t.
			IF ISDIGIT(LEFT(_mnewe_name,1)) = .t.
				_mnewe_name = ALLTRIM(SUBSTR(_mnewe_name,2))
			ELSE
				exit	
			Endif
		ENDDO
		IF ALLTRIM(_lst_exc1.newe_name) == _mnewe_name
			_mnewe_name = SUBSTR(_mnewe_name,2)
		Endif 
		REPLACE newe_name WITH _mnewe_name IN _lst_exc1
		SELECT _lst_exc1
	ENDSCAN

	SELECT DISTINCT newe_name FROM _lst_exc1 WHERE newe_name NOT in (SELECT DISTINCT Name FROM ExciseMap) INTO CURSOR _lst_exc2
	IF USED('_lst_exc2')	
		SELECT _lst_exc2
		IF RECCOUNT() > 0
			_errmessage = 'Following Duties not found in DE Tool'
			Scan
				_errmessage = _errmessage + CHR(13) + STR(RECNO(),2)+'. - '+ALLTRIM(_lst_exc2.newe_name)
			Endscan
		Endif
		USE IN _lst_exc2
	ELSE
		_errmessage = 'Excise Table Checking Error'
	ENDIF

	IF EMPTY(_errmessage)
		Update lst_exc SET e_name = STR(excisemap.srno,2)+excisemap.efiletag from lst_exc ,excisemap,_lst_exc1 ;
			WHERE ALLTRIM(lst_exc.e_name) == ALLTRIM(_lst_exc1.e_name) ;
			AND ALLTRIM(_lst_exc1.newe_name) == ALLTRIM(excisemap.name)
		IF mProduct = 'VU9'
			Update lst_exc SET shortnm = STR(excisemap.srno,2)+excisemap.efiletag from lst_exc ,excisemap,_lst_exc1 ;
				WHERE ALLTRIM(lst_exc.shortnm) == ALLTRIM(_lst_exc1.e_name) ;
				AND ALLTRIM(_lst_exc1.newe_name) == ALLTRIM(excisemap.name)
		ENDIF 
	Endif		
	USE IN _lst_exc1
ELSE
	_errmessage = 'Excise Table Checking Error'
ENDIF

SELECT lst_exc
IF TYPE('lst_exc.exmclearty') != 'C'
	_errmessage = 'Please update New ER3 Format'
ELSE
	UPDATE lst_exc SET exmclearty = UPPER(exmclearty) WHERE qm = '3'	
Endif	

IF _RepoSDate >= CTOD('01/10/2012') AND ALLTRIM(_RepList.rep_nm) != 'ER3OCT13'
	_errmessage = 'Please update New ER3 Format'
Endif

IF !EMPTY(_errmessage)
	RETURN _errmessage
Endif	

DO Case
Case mProduct = 'VU8'
	SELECT * FROM excisemap WHERE STR(srno,2)+efiletag NOT in (SELECT e_name FROM lst_exc WHERE qm = '6') INTO CURSOR _lst_exc1
Case mProduct = 'VU9'
	SELECT * FROM excisemap WHERE STR(srno,2)+efiletag NOT in (SELECT shortnm FROM lst_exc WHERE qm = '6') INTO CURSOR _lst_exc1
ENDCASE

SELECT _lst_exc1
scan
	SELECT lst_exc
	APPEND BLANK IN lst_exc
	REPLACE e_name with STR(_lst_exc1.srno,2)+_lst_exc1.efiletag,qm with '6',srno with 'A' IN lst_exc
	SELECT _lst_exc1
ENDSCAN

IF USED('_lst_exc1')	
	USE IN _lst_exc1
Endif	

SELECT lst_exc	
SELECT e_name FROM lst_exc WHERE qm = '3' AND !EMPTY(e_name) GROUP BY e_name INTO CURSOR _lst_exc1

SELECT _lst_exc1
GO top
_me_name = _lst_exc1.e_name

_repotrigoldengine = SET("EngineBehavior")
SET ENGINEBEHAVIOR 70
DO CASE 
Case mProduct = 'VU8'
	&&vasant191010
	_msr = 0
	&&vasant071210
	*SELECT e_name FROM lst_exc WHERE qm = '3' ORDER BY e_name GROUP BY e_name INTO CURSOR _lst_exc1
	SELECT e_name FROM lst_exc WHERE qm = '3' AND srno != 'A' ORDER BY e_name GROUP BY e_name INTO CURSOR _lst_exc1
	&&vasant071210
	IF USED('_lst_exc1')
		_msr = _msr + 10
		SELECT _lst_exc1
		SCAN
			&&vasant071210
			*SELECT e_per FROM lst_exc WHERE qm = '3' AND e_name = _lst_exc1.e_name INTO CURSOR _lst_exc2
			SELECT e_per FROM lst_exc WHERE qm = '3' AND srno != 'A' AND e_name = _lst_exc1.e_name INTO CURSOR _lst_exc2
			&&vasant071210
			IF USED('_lst_exc2')
				SELECT _lst_exc2
				Scan
					_msr = _msr + 1
					&&vasant071210
					*UPDATE lst_exc SET Inv_no = ALLTRIM(str(_msr)) WHERE e_name = _lst_exc1.e_name AND e_per = _lst_exc2.e_per
					UPDATE lst_exc SET Inv_no = ALLTRIM(str(_msr)) WHERE e_name = _lst_exc1.e_name AND e_per = _lst_exc2.e_per AND qm = '3' AND srno != 'A'
					&&vasant071210
					SELECT _lst_exc2
				Endscan	
			ENDIF
			SELECT _lst_exc1
		ENDSCAN 
			
		IF USED('_lst_exc2')
			USE IN _lst_exc2
		Endif	
		USE IN _lst_exc1
	ENDIF
	
	SELECT entry_ty,date,doc_no,item_no,SUM(VAL(inv_no)) as inv_no FROM lst_exc GROUP BY entry_ty,date,doc_no,item_no INTO CURSOR _lst_exc1
	IF USED('_lst_exc1')
		&&vasant071210
		*update lst_exc set e_name = LEFT(ALLTRIM(STR(_lst_exc1.inv_no)),2)+SUBSTR(lst_exc.e_name,3),inv_no = allt(STR(_lst_exc1.inv_no)) from lst_exc,_lst_exc1 where lst_exc.entry_ty = _lst_exc1.entry_ty and lst_exc.date = _lst_exc1.date and lst_exc.doc_no = _lst_exc1.doc_no and lst_exc.item_no = _lst_exc1.item_no AND lst_exc.qm = '3'
		update lst_exc set e_name = LEFT(ALLTRIM(STR(_lst_exc1.inv_no)),2)+SUBSTR(lst_exc.e_name,3),inv_no = allt(STR(_lst_exc1.inv_no)) from lst_exc,_lst_exc1 where lst_exc.entry_ty = _lst_exc1.entry_ty and lst_exc.date = _lst_exc1.date and lst_exc.doc_no = _lst_exc1.doc_no and lst_exc.item_no = _lst_exc1.item_no AND lst_exc.qm = '3' AND lst_exc.srno != 'A'
		&&vasant071210
	Endif
	&&vasant071210		
	*SELECT u_chapno,eit_name,rateunit,rule,e_name,inv_no FROM lst_exc WHERE qm = '3' AND srno != 'A' AND e_duty > 0 GROUP BY u_chapno,eit_name,rateunit,rule,e_name INTO CURSOR _lst_exc1
	SELECT u_chapno,eit_name,rateunit,rule,e_name,e_per,inv_no FROM lst_exc WHERE qm = '3' AND srno != 'A' GROUP BY u_chapno,eit_name,rateunit,rule,e_name,e_per INTO CURSOR _lst_exc1
	IF USED('_lst_exc1')
		update lst_exc set e_name = _lst_exc1.e_name,inv_no = _lst_exc1.inv_no from lst_exc,_lst_exc1 ;
			where lst_exc.u_chapno = _lst_exc1.u_chapno and lst_exc.eit_name = _lst_exc1.eit_name and lst_exc.rateunit = _lst_exc1.rateunit ;
				And lst_exc.rule = _lst_exc1.rule and SUBSTR(lst_exc.e_name,3) = SUBSTR(_lst_exc1.e_name,3) ;
				And lst_exc.e_per = _lst_exc1.e_per ;
				AND lst_exc.qm = '3' AND lst_exc.srno = 'A'
	Endif
	&&vasant071210
*!*		select * from lst_exc group by entry_ty,date,doc_no,item_no where qm = '3' and e_name = _me_name into cursor _lst_exc1
*!*		update lst_exc set e_name = str(_lst_exc1.e_per,2)+SUBSTR(lst_exc.e_name,3),inv_no = str(_lst_exc1.e_per,2) from lst_exc,_lst_exc1 where lst_exc.entry_ty = _lst_exc1.entry_ty and lst_exc.date = _lst_exc1.date and lst_exc.doc_no = _lst_exc1.doc_no and lst_exc.item_no = _lst_exc1.item_no AND lst_exc.qm = '3'
*!*		update lst_exc set e_per = _lst_exc1.e_per from lst_exc,_lst_exc1 where lst_exc.entry_ty = _lst_exc1.entry_ty and lst_exc.date = _lst_exc1.date and lst_exc.doc_no = _lst_exc1.doc_no and lst_exc.item_no = _lst_exc1.item_no AND lst_exc.e_duty = 0 AND lst_exc.qm = '3'
	&&vasant191010
Case mProduct = 'VU9'
	*select * from lst_exc group by entry_ty,date,doc_no,itserial where qm = '3' and e_name = _me_name into cursor _lst_exc1	&&vasant191010
	update lst_exc set shortnm = e_name from lst_exc where qm = '3'
	&&vasant191010
	UPDATE lst_exc SET u_arrears = '1' WHERE qm = '3' AND srno = 'A'
	
	SELECT ChapNo,RateUnit FROM lst_exc WHERE qm = '3' AND srno = 'A' ORDER BY ChapNo,RateUnit GROUP BY ChapNo,RateUnit INTO CURSOR _lst_exc1
	IF USED('_lst_exc1')
		_msr = 1
		SELECT _lst_exc1
		SCAN
			UPDATE lst_exc SET u_arrears = ALLTRIM(u_arrears)+Padr('0',3,ALLTRIM(STR(_msr))) WHERE ChapNo = _lst_exc1.ChapNo AND RateUnit = _lst_exc1.RateUnit AND qm = '3' AND srno = 'A'
			_msr = _msr + 1
			SELECT _lst_exc1
		Endscan	
		USE IN _lst_exc1
	ENDIF

	SELECT Eit_Name FROM lst_exc WHERE qm = '3' AND srno = 'A' ORDER BY Eit_Name GROUP BY Eit_Name INTO CURSOR _lst_exc1
	IF USED('_lst_exc1')
		_msr = 1
		SELECT _lst_exc1
		SCAN
			UPDATE lst_exc SET u_arrears = ALLTRIM(u_arrears)+Padr('0',2,ALLTRIM(STR(_msr))) WHERE Eit_Name = _lst_exc1.Eit_Name AND qm = '3' AND srno = 'A'
			_msr = _msr + 1
			SELECT _lst_exc1
		Endscan	
		USE IN _lst_exc1
	ENDIF

	SELECT ExmClearTy FROM lst_exc WHERE qm = '3' AND srno = 'A' ORDER BY ExmClearTy GROUP BY ExmClearTy INTO CURSOR _lst_exc1
	IF USED('_lst_exc1')
		_msr = 1
		SELECT _lst_exc1
		SCAN
			UPDATE lst_exc SET u_arrears = ALLTRIM(u_arrears)+Padr('0',2,ALLTRIM(STR(_msr))) WHERE ExmClearTy = _lst_exc1.ExmClearTy AND qm = '3' AND srno = 'A'
			_msr = _msr + 1
			SELECT _lst_exc1
		Endscan	
		USE IN _lst_exc1
	ENDIF

	SELECT E_Name,Rule FROM lst_exc WHERE qm = '3' AND srno = 'A' ORDER BY E_Name,Rule GROUP BY E_Name,Rule INTO CURSOR _lst_exc1
	IF USED('_lst_exc1')
		_msr = 1
		SELECT _lst_exc1
		SCAN
			UPDATE lst_exc SET u_arrears = ALLTRIM(u_arrears)+Padr('0',2,ALLTRIM(STR(_msr))) WHERE E_Name = _lst_exc1.E_Name AND Rule  = _lst_exc1.Rule AND qm = '3' AND srno = 'A'
			_msr = _msr + 1
			SELECT _lst_exc1
		Endscan	
		USE IN _lst_exc1
	ENDIF

	SELECT srno FROM lst_exc WHERE qm = '3' AND srno <> 'A' ORDER BY srno GROUP BY srno INTO CURSOR _lst_exc1
	IF USED('_lst_exc1')
		SELECT _lst_exc1
		SCAN
			_msrno = _lst_exc1.srno
			SELECT E_Per FROM lst_exc WHERE qm = '3' AND srno = _msrno ORDER BY E_Per GROUP BY E_Per INTO CURSOR _lst_exc2
			IF USED('_lst_exc2')
				_msr = 1
				SELECT _lst_exc2
				SCAN
					UPDATE lst_exc SET u_arrears = ALLTRIM(u_arrears)+Padr('0',2,ALLTRIM(STR(_msr))) WHERE qm = '3' AND srno = 'A' AND ;
						entry_ty+STR(tran_cd)+itserial in (select entry_ty+STR(tran_cd)+itserial from lst_exc WHERE qm = '3' AND srno = _msrno AND e_per = _lst_exc2.e_per)
					_msr = _msr + 1
					SELECT _lst_exc2
				Endscan	
				USE IN _lst_exc2
			ENDIF

			SELECT _lst_exc1
		Endscan	
		USE IN _lst_exc1
	ENDIF

*!*		SELECT E_Per FROM lst_exc WHERE qm = '3' AND srno = 'A' ORDER BY E_Per GROUP BY E_Per INTO CURSOR _lst_exc1
*!*		IF USED('_lst_exc1')
*!*			_msr = 1
*!*			SELECT _lst_exc1
*!*			SCAN
*!*				UPDATE lst_exc SET u_arrears = ALLTRIM(u_arrears)+Padr('0',2,ALLTRIM(STR(_msr))) WHERE E_Per = _lst_exc1.E_Per AND qm = '3' AND srno = 'A'
*!*				_msr = _msr + 1
*!*				SELECT _lst_exc1
*!*			Endscan	
*!*			USE IN _lst_exc1
*!*		ENDIF

*!*		SELECT U_Pfor,TarrifSrNo FROM lst_exc WHERE qm = '3' AND srno = 'A' ORDER BY U_Pfor,TarrifSrNo GROUP BY U_Pfor,TarrifSrNo INTO CURSOR _lst_exc1
*!*		IF USED('_lst_exc1')
*!*			_msr = 1
*!*			SELECT _lst_exc1
*!*			SCAN
*!*				UPDATE lst_exc SET u_arrears = ALLTRIM(u_arrears)+Padr('0',2,ALLTRIM(STR(_msr))) WHERE U_Pfor = _lst_exc1.U_Pfor AND TarrifSrNo = _lst_exc1.TarrifSrNo AND qm = '3' AND srno = 'A'
*!*				_msr = _msr + 1
*!*				SELECT _lst_exc1
*!*			Endscan	
*!*			USE IN _lst_exc1
*!*		ENDIF

	UPDATE lst_exc SET u_arrears = ALLTRIM(u_arrears)+'1' WHERE qm = '3' AND srno = 'A'
	
	SELECT entry_ty,tran_cd,itserial,Max(u_arrears) as u_arrears FROM lst_exc WHERE qm = '3' AND srno = 'A' ;
		GROUP BY entry_ty,tran_cd,itserial INTO CURSOR _lst_exc1
	IF USED('_lst_exc1')
		update lst_exc set e_name = SUBSTR(_lst_exc1.u_arrears,1,15)+SUBSTR(lst_exc.e_name,3),u_arrears = _lst_exc1.u_arrears from lst_exc,_lst_exc1 ;
			where lst_exc.entry_ty = _lst_exc1.entry_ty and lst_exc.tran_cd = _lst_exc1.tran_cd and lst_exc.itserial = _lst_exc1.itserial ;
			AND lst_exc.qm = '3' &&AND lst_exc.srno != 'A'
	Endif

*!*		update lst_exc set e_name = str(_lst_exc1.e_per,2)+SUBSTR(lst_exc.e_name,3),u_arrears = str(_lst_exc1.e_per,2) from lst_exc,_lst_exc1 where lst_exc.entry_ty = _lst_exc1.entry_ty and lst_exc.date = _lst_exc1.date and lst_exc.doc_no = _lst_exc1.doc_no and lst_exc.itserial = _lst_exc1.itserial AND lst_exc.qm = '3'
*!*		update lst_exc set e_per = _lst_exc1.e_per from lst_exc,_lst_exc1 where lst_exc.entry_ty = _lst_exc1.entry_ty and lst_exc.date = _lst_exc1.date and lst_exc.doc_no = _lst_exc1.doc_no and lst_exc.itserial = _lst_exc1.itserial AND lst_exc.e_duty = 0 AND lst_exc.qm = '3'
	&&vasant191010
	SELECT ShortNm FROM lst_exc where qm = '6' AND Receipt+Issue > 0;
		GROUP BY ShortNm into cursor _lst_exc2
	IF USED('_lst_exc2')		
		SELECT _lst_exc2
		Scan
			_mShortNm  = _lst_exc2.ShortNm
			
			Select TOP 1 U_ChalNo,U_ChalDt,BSRCode from lst_exc ;
				where qm = '6' AND CurAc = 1 AND Receipt+Issue > 0 AND !EMPTY(U_ChalNo) AND ShortNm = _mShortNm ;
				ORDER BY CDate into cursor _lst_exc1
			IF USED('_lst_exc1')	
				_mU_ChalNo = _lst_exc1.U_ChalNo
				_mU_ChalDt = _lst_exc1.U_ChalDt
				_mBSRCode  = _lst_exc1.BSRCode
				UPDATE lst_exc SET U_ChalNo = _mU_ChalNo,U_ChalDt = _mU_ChalDt,BSRCode  = _mBSRCode;
					where qm = '6' AND Receipt+Issue > 0 AND ShortNm = _mShortNm
				USE IN _lst_exc1
			ELSE
				_errmessage = 'Excise Table Checking Error'
			Endif

			SELECT _lst_exc2
		Endscan
		USE IN _lst_exc2
	ELSE
		_errmessage = 'Excise Table Checking Error'
	Endif

	select * from lst_exc group by entry_ty,tran_cd where qm = '9' into cursor _lst_exc1
	IF USED('_lst_exc1')	
		nhandle = 0
		SELECT _lst_exc1
		SCAN
			_mu_pfor = ''
			mexecquery = 'select top 1 entry_ty,tran_cd,u_plasr from stkl_vw_main where entry_ty = ?_lst_exc1.entry_ty and tran_cd = ?_lst_exc1.tran_cd'
			nretval = _screenactiveform.sqlconobj.dataconn('EXE',_screenactiveform.CompanyDb,mexecquery,'_lst_exc2','nhandle')
			If nretval<=0 AND !USED('_lst_exc2')
				_errmessage = 'Connection Error'
			ELSE
				_mu_pfor = _lst_exc2.u_plasr
			Endif	
			IF EMPTY(_mu_pfor)
				mexecquery = 'select top 1 entry_ty,tran_cd,u_rg23no from stkl_vw_main where entry_ty = ?_lst_exc1.entry_ty and tran_cd = ?_lst_exc1.tran_cd'
				nretval = _screenactiveform.sqlconobj.dataconn('EXE',_screenactiveform.CompanyDb,mexecquery,'_lst_exc2','nhandle')
				If nretval<=0 AND !USED('_lst_exc2')
					_errmessage = 'Connection Error'
				ELSE
					_mu_pfor = _lst_exc2.u_rg23no
				Endif	
			Endif	
			IF !EMPTY(_mu_pfor)
				update lst_exc set u_pfor = _mu_pfor from lst_exc,_lst_exc2 where lst_exc.entry_ty = _lst_exc2.entry_ty and lst_exc.tran_cd = _lst_exc2.tran_cd AND lst_exc.qm = '9'
			ENDIF

			SELECT _lst_exc1
		Endscan
		USE IN _lst_exc1
		USE IN _lst_exc2
		nsq = _screenactiveform.sqlconobj.sqlconnclose('nhandle')
		If nsq<=0
			_errmessage = 'Connection Closing Error'
		ENDIF
	ELSE
		_errmessage = 'Excise Table Checking Error'
	Endif
ENDCASE
SET ENGINEBEHAVIOR _repotrigoldengine
IF USED('_lst_exc1')	
	USE IN _lst_exc1
Endif	

_firstname = ''
SELECT excisemap
SCAN
	IF !EMPTY(excisemap.efiletag)
		_firstname = STR(excisemap.srno,2)+excisemap.efiletag
	ENDIF
	IF excisemap.srno = 1 AND !EMPTY(_firstname)
		EXIT
	Endif	
ENDSCAN
SELECT lst_exc
REPLACE ALL e_name WITH _firstname FOR EMPTY(e_name) AND qm = '3' IN lst_exc

SELECT lst_exc
DO Case
Case mProduct = 'VU8'
	SELECT e_name FROM lst_exc WHERE EMPTY(e_name) AND qm = '6' INTO CURSOR _lst_exc1
Case mProduct = 'VU9'
	SELECT shortnm FROM lst_exc WHERE EMPTY(shortnm) AND qm = '6' AND !EMPTY(Entry_ty) INTO CURSOR _lst_exc1
Endcase	

IF USED('_lst_exc1')	
	SELECT _lst_exc1
	IF RECCOUNT() > 0
		_errmessage = 'Blank Duty Names Not Allowed'
	Endif
	USE IN _lst_exc1
ELSE
	_errmessage = 'Output Table Checking Error'
ENDIF
IF !EMPTY(_errmessage)
	RETURN _errmessage
Endif	

If mProduct = 'VU9'
	SELECT lst_exc 
	GO Top
	DELETE FOR ALLTRIM(QM) == '6' AND EMPTY(ShortNm) AND (Issue+Receipt) = 0
	GO Top
	DELETE FOR ALLTRIM(QM) == '9' AND EMPTY(ShortNm) AND (Issue+Receipt) = 0	
	GO Top
	LOCATE FOR ALLTRIM(QM) == '6' AND ALLTRIM(SRNo) == 'A'
	IF !FOUND()
		APPEND BLANK IN lst_exc
		REPLACE QM WITH '6',SRNo WITH 'A' IN lst_exc
	Endif	
	LOCATE FOR ALLTRIM(QM) == '9' AND 'ARREARS' $ UPPER(U_Arrears)
	IF !FOUND()
		APPEND BLANK IN lst_exc
		REPLACE QM WITH '9',SRNo WITH 'A',U_Arrears WITH 'OTHERS ARREARS OF DUTY' IN lst_exc
	Endif	
	LOCATE FOR ALLTRIM(QM) == '9' AND 'INTEREST' $ UPPER(U_Arrears)
	IF !FOUND()
		APPEND BLANK IN lst_exc
		REPLACE QM WITH '9',SRNo WITH 'B',U_Arrears WITH 'OTHERS INTEREST PAYMENTS' IN lst_exc
	Endif	
	LOCATE FOR ALLTRIM(QM) == '9' AND 'MISC.' $ UPPER(U_Arrears)
	IF !FOUND()
		APPEND BLANK IN lst_exc
		REPLACE QM WITH '9',SRNo WITH 'C',U_Arrears WITH 'Misc. payments - Others' IN lst_exc
	Endif	
	LOCATE FOR ALLTRIM(QM) == '9A'
	IF !FOUND()
		APPEND BLANK IN lst_exc
		REPLACE QM WITH '9A',SRNo WITH 'A',TR6 WITH 'ABCDE',TR6DT WITH DATE() IN lst_exc
	Endif	
	LOCATE FOR ALLTRIM(QM) == '9B'
	IF !FOUND()
		APPEND BLANK IN lst_exc
		REPLACE QM WITH '9B',SRNo WITH 'A',INV_SR WITH 'ABCDE' IN lst_exc
	Endif	
	SELECT lst_exc
	GO Top
ENDIF 

If mProduct = 'VU9'
	SELECT IIF(UPPER(RULE)='MODVATABLE' OR EMPTY(Rule),'A','Z') AS NEWRULE,* FROM lst_exc WHERE QM = '3' INTO CURSOR _lst_exc1 READWRITE ;
		ORDER BY QM,CHAPNO,EIT_NAME,RATEUNIT,NEWRULE,RULE,U_Arrears,u_pfor,TarrifSrNo,SHORTNM,E_NAME,E_PER	&&TarrifSrNo field has been added. Done by vasant on 24/01/2013 as per Bug-8471 (In Excise Manufacturing the records of ER1 which are present in Input XML file and Input PDF file Value of "ISOBORNYL KG CYCLOHEXANOL (EXPORT)"Qty Cleared and Assessable value are not getting Generated in the output xml and html 
	SELECT * FROM lst_exc WHERE QM != '3' ORDER BY QM INTO CURSOR _lst_exc2 readwrite
	IF USED('_lst_exc1') AND USED('_lst_exc2')	
		DELETE from lst_exc
		SELECT lst_exc
		GO Top
		APPEND FROM DBF('_lst_exc1')
		GO Top		
		APPEND FROM DBF('_lst_exc2')		
		USE IN _lst_exc1
		USE IN _lst_exc2
		SELECT lst_exc
		GO Top
	ELSE
		_errmessage = 'Output Table Checking Error'
	ENDIF
ENDIF

RETURN _errmessage




PROCEDURE XMLGroupFinder
LPARAMETERS _trigtbl
IF TYPE('_trigtbl') <> 'C'
	_trigtbl = ''
Endif
_trigretvalue = ''
_oldtrigdatasession = SET("Datasession")
_trigtotsession = ASESSIONS(_trigsessionarr)
IF EMPTY(_trigretvalue) AND _trigretvalue <> '0'
	FOR _trigstartsession = 1 TO _trigtotsession
		SET DATASESSION TO _trigsessionarr(_trigstartsession)
		IF USED(JUSTSTEM(_trigtbl)) AND !EMPTY(_trigtbl)
			IF TYPE(_trigtbl) = 'N'
				_trigretvalue = str(&_trigtbl,1)
			Else
				_trigretvalue = TRANSFORM(&_trigtbl)
			Endif	
		Endif	
	ENDFOR
Endif	
SET DATASESSION TO (_oldtrigdatasession)
RETURN ALLTRIM(_trigretvalue)


PROCEDURE eFileDefaValidations
_oldAlias = ALIAS()
SELECT XmlData_vw
_thismthodsuccessdone = .t.
REPLACE ALL RateUnit3 WITH UPPER(XMLData_Vw.RateUnit3),;
	CompRegNo1 WITH STRTRAN(XMLData_Vw.CompRegNo1,' ','') IN XMLData_Vw
&&vasant251010
LOCATE FOR ALLTRIM(Taggroup) == '3'
IF !FOUND()
	REPLACE ErrMsg WITH ErrLog.ErrMsg +;
		CHR(13)+'Details of the Manufacture, Clearance And Duty Payable Not Found' IN ErrLog
	_thismthodsuccessdone = .f.	
Endif

*!*	SELECT ALLTRIM(Left(chapno3,255)) As ChapNo,ALLTRIM(Left(RateUnit3,255)) As RateUnit FROM XmlData_vw ;
*!*		WHERE INLIST(TagGroup,'3') INTO CURSOR _lst_exc1
SELECT ALLTRIM(Left(chapno3,255)) As ChapNo,ALLTRIM(Left(RateUnit3,255)) As RateUnit,;
	ALLTRIM(Left(ItemDes_A3,255)) As ItemDes FROM XmlData_vw ;
	WHERE INLIST(TagGroup,'3') INTO CURSOR _lst_exc1
&&vasant251010	
IF USED('_lst_exc1')	
	&&vasant251010
	*SELECT dist ChapNo FROM _lst_exc1 WHERE ChapNo NOT in (SELECT cetsh FROM cetsh) INTO CURSOR _lst_exc2
	SELECT dist ChapNo,ItemDes FROM _lst_exc1 WHERE ChapNo NOT in (SELECT cetsh FROM cetsh) INTO CURSOR _lst_exc2
	&&vasant251010
	IF USED('_lst_exc2')	
		SELECT _lst_exc2
		IF RECCOUNT() > 0
			SCAN
				&&vasant251010
				*REPLACE ErrMsg WITH ErrLog.ErrMsg +;
					CHR(13)+'Unable to find Chap. No. '+ALLTRIM(_lst_exc2.ChapNo) IN ErrLog
				REPLACE ErrMsg WITH ErrLog.ErrMsg +;
					CHR(13)+'Unable to find Chap. No. '+IIF(EMPTY(STRTRAN(_lst_exc2.ChapNo,'0','')),'<BLANK>',ALLTRIM(_lst_exc2.ChapNo)) + ;
					' in ACES List for Item : '+ALLTRIM(_lst_exc2.Itemdes) IN ErrLog	&&vasant081210
				&&vasant251010	
			Endscan		
			_thismthodsuccessdone = .f.	
		Endif	
		USE IN _lst_exc2
	ELSE
		_thismthodsuccessdone = .f.	
	ENDIF

	SELECT dist a.ChapNo,a.RateUnit as UOM_Cur,b.RateUnit as UOM_Org FROM _lst_exc1 a,cetsh b WHERE ;
		ALLTRIM(a.ChapNo) == ALLTRIM(b.cetsh) ;
		AND a.rateunit NOT in (SELECT Dist RateUnit FROM cetsh) INTO CURSOR _lst_exc2
	IF USED('_lst_exc2')	
		SELECT _lst_exc2
		IF RECCOUNT() > 0
			SCAN
				IF !(UPPER(ALLTRIM(_lst_exc2.UOM_Cur)) == UPPER(ALLTRIM(_lst_exc2.UOM_Org)))
					REPLACE ErrMsg WITH ErrLog.ErrMsg +;
						CHR(13) + 'Current Value : '+IIF(EMPTY(_lst_exc2.UOM_Cur),'<BLANK>',ALLTRIM(_lst_exc2.UOM_Cur)) IN ErrLog
					REPLACE ErrMsg WITH ErrLog.ErrMsg +;
						' --> '+'UOM for the Chap. No. '+ALLTRIM(_lst_exc2.ChapNo)+' should be '+ALLTRIM(_lst_exc2.UOM_Org) IN ErrLog
					_thismthodsuccessdone = .f.	
				Endif		
			Endscan		
		Endif	
		USE IN _lst_exc2
	ELSE
		_thismthodsuccessdone = .f.	
	ENDIF

	USE IN _lst_exc1
ELSE
	_thismthodsuccessdone = .f.	
ENDIF

SELECT ALLTRIM(Left(chapno3,255)) As ChapNo,ALLTRIM(Left(DutyHead3,255)) As DutyHead,;
	ALLTRIM(Left(ItemDes_A3,255)) As Itemdes,ALLTRIM(Left(Rule3,255)) As Rule,;
	VAL(RatDutyAd3) As DutyPer,VAL(DtyPyable3) As DutyAmt,DtyPyable3 FROM XmlData_vw ;
	WHERE INLIST(TagGroup,'3') And VAL(DtyPyable3) > 0 AND VAL(RatDutyAd3) = 0 INTO CURSOR _lst_exc1	&&vasant071210
IF USED('_lst_exc1')	
	SELECT _lst_exc1
	IF RECCOUNT() > 0
		SCAN
			REPLACE ErrMsg WITH ErrLog.ErrMsg +;
				CHR(13)+'Duty Head : '+ALLTRIM(_lst_exc1.DutyHead)+', Duty Amount : '+ALLTRIM(Trans(_lst_exc1.DtyPyable3))+', Duty Rate can not be 0.00 for Chap. No. : '+ALLTRIM(_lst_exc1.ChapNo);
				+ ', Item : '+ALLTRIM(_lst_exc1.Itemdes) +  ', Rule : '+ALLTRIM(_lst_exc1.Rule) IN ErrLog		&&vasant071210
		Endscan		
		_thismthodsuccessdone = .f.
	Endif	
	USE IN _lst_exc1
ELSE
	_thismthodsuccessdone = .f.	
ENDIF

&&vasant011011
SELECT lst_exc
*IF DToC(_RepoSDate) >= '01/10/2011'
IF _RepoSDate >= CTOD('01/10/2011')
	UPDATE XmlData_vw SET ClearType3 = IIF(inli(Rule3,'CT-1','CT-3','EOU EXPORT'),'EXPORT/BOND','HOME CLEARANCE') ;
		WHERE INLIST(TagGroup,'3') AND VAL(QtyClear3) > 0 AND EMPTY(ClearType3)
	SELECT XmlData_vw
	GO Top
	UPDATE XmlData_vw SET ClearType3 = UPPER(ClearType3) WHERE INLIST(TagGroup,'3')
	_mClearType3 = "'HOME CLEARANCE','EXPORT/REBATE','SEZ/REBATE','EXPORT/BOND','EXPORT/LUT','SEZ/BOND','SEZ/LUT'"
*!*		IF Main_vw.IsLTU
*!*			_mClearType3 = "'HOME CLEARANCE','EXPORT/REBATE','SEZ/REBATE','EXPORT/BOND','EXPORT/LUT','SEZ/BOND','SEZ/LUT','INTERUNITTRANSFER'"
*!*		Endif	
	SELECT ALLTRIM(Left(chapno3,255)) As ChapNo,ALLTRIM(Left(Rule3,255)) As Rule,;
		ALLTRIM(Left(Itemdes_a3,255)) As Itemdes,ALLTRIM(Left(ClearType3,255)) As ClearType FROM XmlData_vw ;
		WHERE INLIST(TagGroup,'3') AND VAL(QtyClear3) > 0 AND ;
		(!INLIST(ClearType3,&_mClearType3) OR EMPTY(ClearType3)) INTO CURSOR _lst_exc2
	IF USED('_lst_exc2')	
		SELECT _lst_exc2
		IF RECCOUNT() > 0
			Scan
				IF EMPTY(_lst_exc2.ClearType)
					REPLACE ErrMsg WITH ErrLog.ErrMsg +;
						CHR(13)+'Clearance Type can not be Blank' IN ErrLog
				else
					REPLACE ErrMsg WITH ErrLog.ErrMsg +;
						CHR(13)+'Unable to find Clearance Type '+ALLTRIM(_lst_exc2.ClearType)+' in ACES List' IN ErrLog						
				Endif	
				REPLACE ErrMsg WITH ErrLog.ErrMsg +;
					' for Chap. No. : '+ALLTRIM(_lst_exc2.ChapNo);
					+ ', Item : '+ALLTRIM(_lst_exc2.Itemdes) +  ', Rule : '+ALLTRIM(_lst_exc2.Rule) IN ErrLog
			Endscan		
			_thismthodsuccessdone = .f.	
		Endif	
		USE IN _lst_exc2
	ELSE
		_thismthodsuccessdone = .f.	
	ENDIF
ELSE
	UPDATE XmlData_vw SET ClearType3 = IIF(inli(Rule3,'CT-1','CT-3','EOU EXPORT'),'EXPORT/BOND','HOME CLEARANCE') ;
		WHERE INLIST(TagGroup,'3') AND VAL(QtyClear3) > 0
ENDIF

*!*	SELECT ALLTRIM(Left(chapno3,255)) As ChapNo,ALLTRIM(Left(Rule3,255)) As Rule,;
*!*		ALLTRIM(Left(Itemdes_a3,255)) As Itemdes,ALLTRIM(Left(SNoNotify3,255)) As SNoNotify,ALLTRIM(Left(TariffSNo3,255)) As TariffSNo FROM XmlData_vw ;
*!*		WHERE INLIST(TagGroup,'3') AND inli(Rule3,'CT-1','CT-3','EOU EXPORT') AND VAL(QtyClear3) > 0 INTO CURSOR _lst_exc1
SELECT ALLTRIM(Left(chapno3,255)) As ChapNo,ALLTRIM(Left(Rule3,255)) As Rule,;
	ALLTRIM(Left(Itemdes_a3,255)) As Itemdes,ALLTRIM(Left(SNoNotify3,255)) As SNoNotify,ALLTRIM(Left(TariffSNo3,255)) As TariffSNo FROM XmlData_vw ;
	WHERE INLIST(TagGroup,'3') AND INLIST(ClearType3,'EXPORT/BOND','EXPORT/LUT','SEZ/BOND','SEZ/LUT') AND VAL(QtyClear3) > 0 INTO CURSOR _lst_exc1
&&vasant011011
IF USED('_lst_exc1')	
	SELECT ChapNo,Rule,Itemdes,SNoNotify FROM _lst_exc1 ;
		WHERE SNoNotify NOT in (SELECT DISTINCT NotifName FROM NonTariffNotif) INTO CURSOR _lst_exc2
	IF USED('_lst_exc2')	
		SELECT _lst_exc2
		IF RECCOUNT() > 0
			Scan
				IF EMPTY(_lst_exc2.SNoNotify)
					REPLACE ErrMsg WITH ErrLog.ErrMsg +;
						CHR(13)+'Notification No. can not be Blank' IN ErrLog
				else
					REPLACE ErrMsg WITH ErrLog.ErrMsg +;
						CHR(13)+'Unable to find Notification No. '+ALLTRIM(_lst_exc2.SNoNotify)+' in ACES List' IN ErrLog	&&vasant081210
						
				Endif	
				REPLACE ErrMsg WITH ErrLog.ErrMsg +;
					' for Chap. No. : '+ALLTRIM(_lst_exc2.ChapNo);
					+ ', Item : '+ALLTRIM(_lst_exc2.Itemdes) +  ', Rule : '+ALLTRIM(_lst_exc2.Rule) IN ErrLog
			Endscan		
			_thismthodsuccessdone = .f.	
		Endif	
		USE IN _lst_exc2
	ELSE
		_thismthodsuccessdone = .f.	
	ENDIF

	SELECT ChapNo,Rule,Itemdes,TariffSNo FROM _lst_exc1 ;
		WHERE EMPTY(TariffSNo) INTO CURSOR _lst_exc2
	IF USED('_lst_exc2')	
		SELECT _lst_exc2
		IF RECCOUNT() > 0
			Scan
				REPLACE ErrMsg WITH ErrLog.ErrMsg +;
					CHR(13)+'Notification Sr. No. can not be Blank' IN ErrLog
				REPLACE ErrMsg WITH ErrLog.ErrMsg +;
					' for Chap. No. : '+ALLTRIM(_lst_exc2.ChapNo);
					+ ', Item : '+ALLTRIM(_lst_exc2.Itemdes) +  ', Rule : '+ALLTRIM(_lst_exc2.Rule) IN ErrLog
			Endscan		
			_thismthodsuccessdone = .f.	
		Endif	
		USE IN _lst_exc2
	ELSE
		_thismthodsuccessdone = .f.	
	ENDIF
	
	USE IN _lst_exc1
ELSE
	_thismthodsuccessdone = .f.	
ENDIF

&&vasant011011	
*!*	SELECT ALLTRIM(Left(chapno3,255)) As ChapNo,ALLTRIM(Left(Rule3,255)) As Rule,;
*!*		ALLTRIM(Left(Itemdes_a3,255)) As Itemdes,ALLTRIM(Left(SNoNotify3,255)) As SNoNotify FROM XmlData_vw ;
*!*		WHERE INLIST(TagGroup,'3') AND !inli(Rule3,'CT-1','CT-3','EOU EXPORT') AND !EMPTY(SNoNotify3) INTO CURSOR _lst_exc1
SELECT ALLTRIM(Left(chapno3,255)) As ChapNo,ALLTRIM(Left(Rule3,255)) As Rule,;
	ALLTRIM(Left(Itemdes_a3,255)) As Itemdes,ALLTRIM(Left(SNoNotify3,255)) As SNoNotify,ALLTRIM(Left(TariffSNo3,255)) As TariffSNo FROM XmlData_vw ;
	WHERE INLIST(TagGroup,'3') AND !INLIST(ClearType3,'EXPORT/BOND','EXPORT/LUT','SEZ/BOND','SEZ/LUT') AND !EMPTY(SNoNotify3) INTO CURSOR _lst_exc1
&&vasant011011	
IF USED('_lst_exc1')	
	SELECT ChapNo,Rule,Itemdes,SNoNotify FROM _lst_exc1 ;
		WHERE (SNoNotify NOT in (SELECT DISTINCT NotifName FROM TariffNotif) ;
		And SNoNotify NOT in (SELECT DISTINCT NotifName FROM NonTariffNotif)) ;
		INTO CURSOR _lst_exc2
	IF USED('_lst_exc2')	
		SELECT _lst_exc2
		IF RECCOUNT() > 0
			Scan
				REPLACE ErrMsg WITH ErrLog.ErrMsg +;
					CHR(13)+'Unable to find Notification No. '+ALLTRIM(_lst_exc2.SNoNotify)+' in ACES List' IN ErrLog	&&vasant081210
				REPLACE ErrMsg WITH ErrLog.ErrMsg +;
					' for Chap. No. : '+ALLTRIM(_lst_exc2.ChapNo);
					+ ', Item : '+ALLTRIM(_lst_exc2.Itemdes) +  ', Rule : '+ALLTRIM(_lst_exc2.Rule) IN ErrLog
			Endscan		
			_thismthodsuccessdone = .f.	
		Endif	
		USE IN _lst_exc2
	ELSE
		_thismthodsuccessdone = .f.	
	ENDIF

	SELECT ChapNo,Rule,Itemdes,TariffSNo FROM _lst_exc1 ;
		WHERE EMPTY(TariffSNo) AND SNoNotify in (SELECT DISTINCT NotifName FROM NonTariffNotif) ;
		INTO CURSOR _lst_exc2
	IF USED('_lst_exc2')	
		SELECT _lst_exc2
		IF RECCOUNT() > 0
			Scan
				REPLACE ErrMsg WITH ErrLog.ErrMsg +;
					CHR(13)+'Notification Sr. No. can not be Blank' IN ErrLog
				REPLACE ErrMsg WITH ErrLog.ErrMsg +;
					' for Chap. No. : '+ALLTRIM(_lst_exc2.ChapNo);
					+ ', Item : '+ALLTRIM(_lst_exc2.Itemdes) +  ', Rule : '+ALLTRIM(_lst_exc2.Rule) IN ErrLog
			Endscan		
			_thismthodsuccessdone = .f.	
		Endif	
		USE IN _lst_exc2
	ELSE
		_thismthodsuccessdone = .f.	
	ENDIF
	
	USE IN _lst_exc1
ELSE
	_thismthodsuccessdone = .f.	
ENDIF

UPDATE xmldata_Vw SET BlankTag = .t. WHERE ALLTRIM(taggroup) == '6' AND VAL(ALLTRIM(MLINE(acctcur6,1)))  = 0  AND VAL(ALLTRIM(MLINE(cracct6,1)))  = 0                
UPDATE xmldata_Vw SET BlankTag = .t. WHERE ALLTRIM(taggroup) == '9' AND VAL(ALLTRIM(MLINE(DtyPayCur9,1)))  = 0  AND VAL(ALLTRIM(MLINE(DutyPayCr9,1)))  = 0                
UPDATE xmldata_Vw SET BlankTag = .t. WHERE ALLTRIM(taggroup) == '9A' AND VAL(ALLTRIM(MLINE(Amount9a,1)))  = 0
UPDATE xmldata_Vw SET BlankTag = .t. WHERE ALLTRIM(taggroup) == '9B' AND Empty(ALLTRIM(MLINE(FInvoice9B,1))) 

IF !EMPTY(_oldAlias)
	SELECT (_oldAlias)
Endif	
RETURN _thismthodsuccessdone


PROCEDURE DtyPayTyp9Chk
LPARAMETERS _mDtyPayTyp9Para
_mDtyPayTyp9Chk = ''
_mDtyPayTyp9Val = ALLTRIM(left(xmldata_vw.DtyPayTyp9,100))
_mDtyPayTyp9Val = UPPER(IIF(EMPTY(_mDtyPayTyp9Val),'zzzzzzzzzzz',_mDtyPayTyp9Val))

IF _mDtyPayTyp9Para = 1
	DO Case
	CASE INLIST(_mDtyPayTyp9Val,'ARREARS OF DUTY UNDER RULE 8','ARREARS OF DUTY UNDER SECTION 11A','ARREARS OF DUTY UNDER SECTION 11A2[B]','ARREARS OF DUTY UNDER SECTION 11D','OTHERS ARREARS OF DUTY','OTHER ARREARS OF DUTY')
		_mDtyPayTyp9Chk = 'Other Payments Made-Arrears'
	CASE INLIST(_mDtyPayTyp9Val,'INTEREST PAYMENT UNDER RULE 8','INTEREST PAYMENT UNDER SECTION 11A2[B]','INTEREST PAYMENT UNDER SECTION 11A','INTEREST PAYMENT UNDER SECTION 11D','OTHERS INTEREST PAYMENTS','OTHER INTEREST PAYMENTS')
		_mDtyPayTyp9Chk = 'Other Payments Made-Interest'
	CASE INLIST(_mDtyPayTyp9Val,'MISC. PAYMENTS - FINE','MISC. PAYMENTS - PENALTY','MISC. PAYMENTS - OTHERS','MISC. PAYMENTS')	
		_mDtyPayTyp9Chk = 'Other Payments Made-Miscellaneous'
	Endcase
Endif	
IF _mDtyPayTyp9Para = 2
	DO Case
	CASE INLIST(_mDtyPayTyp9Val,'ARREARS OF DUTY UNDER RULE 8','INTEREST PAYMENT UNDER RULE 8')
		_mDtyPayTyp9Chk = 'Rule 8'
	CASE INLIST(_mDtyPayTyp9Val,'ARREARS OF DUTY UNDER SECTION 11A','OTHER ARREARS OF DUTY','OTHERS ARREARS OF DUTY','INTEREST PAYMENT UNDER SECTION 11A','OTHER INTEREST PAYMENTS','OTHERS INTEREST PAYMENTS')
		_mDtyPayTyp9Chk = 'Section 11A'
	CASE INLIST(_mDtyPayTyp9Val,'ARREARS OF DUTY UNDER SECTION 11A2[B]','INTEREST PAYMENT UNDER SECTION 11A2[B]')
		_mDtyPayTyp9Chk = 'Section 11A2[B]'
	CASE INLIST(_mDtyPayTyp9Val,'ARREARS OF DUTY UNDER SECTION 11D','INTEREST PAYMENT UNDER SECTION 11D')
		_mDtyPayTyp9Chk = 'Section 11D'
	CASE INLIST(_mDtyPayTyp9Val,'MISC. PAYMENTS - FINE')	
		_mDtyPayTyp9Chk = 'Fine'
	CASE INLIST(_mDtyPayTyp9Val,'MISC. PAYMENTS - PENALTY')	
		_mDtyPayTyp9Chk = 'Penalty'
	CASE INLIST(_mDtyPayTyp9Val,'MISC. PAYMENTS - OTHERS','MISC. PAYMENTS')	
		_mDtyPayTyp9Chk = 'Others'
	Endcase	
Endif	

RETURN _mDtyPayTyp9Chk

