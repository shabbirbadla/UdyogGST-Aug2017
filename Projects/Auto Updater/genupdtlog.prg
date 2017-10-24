LPARAMETERS _mCompany
_TmpTblNm1 = '_TmpBefUpdt'
_TmpTblNm2 = '_TmpAftUpdt'
IF USED(_TmpTblNm1)
	SELECT Co_Path,FName,FDate,FSize FROM (_TmpTblNm1) WHERE Co_Name == _mCompany INTO CURSOR _TmpTblNmA
	SELECT Co_Path,FName,FDate,FSize FROM (_TmpTblNm2) WHERE Co_Name == _mCompany INTO CURSOR _TmpTblNmB

	SELECT DISTINCT Co_Path,FName FROM _TmpTblNmA WHERE FName + 'A' NOT in (SELECT FName + 'A' FROM _TmpTblNmB) ;
		INTO CURSOR _TmpTblNm
	SELECT _TmpTblNm
	IF RECCOUNT() > 0
		=ErrLog('Files Deleted','A','Y')
		_OldPath = '*'
		SCAN
			IF _TmpTblNm.Co_Path != _OldPath
				=ErrLog('Path '+ALLTRIM(_TmpTblNm.Co_Path),'A','Y','B')
			Endif
			=ErrLog(_TmpTblNm.FName,'A')
			_OldPath = _TmpTblNm.Co_Path
			SELECT _TmpTblNm
		Endscan	
	Endif

	SELECT DISTINCT Co_Path,FName FROM _TmpTblNmB WHERE FName + 'A' NOT in (SELECT FName + 'A' FROM _TmpTblNmA) ;
		INTO CURSOR _TmpTblNm
	SELECT _TmpTblNm
	IF RECCOUNT() > 0
		=ErrLog('New Files Copied','A','Y')
		_OldPath = '*'
		SCAN
			IF _TmpTblNm.Co_Path != _OldPath
				=ErrLog('Path '+ALLTRIM(_TmpTblNm.Co_Path),'A','Y','B')
			Endif
			=ErrLog(_TmpTblNm.FName,'A')
			_OldPath = _TmpTblNm.Co_Path
			SELECT _TmpTblNm
		Endscan	
	Endif	

	SELECT a.Co_Path,a.FName,a.Fdate as aFdate,b.Fdate as bFdate,a.FSize as aFSize,b.FSize as bFSize FROM _TmpTblNmA a,_TmpTblNmB b WHERE a.FName + 'A' = b.FName + 'A';
		INTO CURSOR _TmpTblNm
	SELECT DISTINCT Co_Path,FName FROM _TmpTblNm WHERE (aFdate != bFdate Or aFSize != bFSize) INTO CURSOR _TmpTblNmA	
	SELECT _TmpTblNmA
	IF RECCOUNT() > 0
		=ErrLog('Files Updated','A','Y')
		_OldPath = '*'
		SCAN
			IF _TmpTblNm.Co_Path != _OldPath
				=ErrLog('Path '+ALLTRIM(_TmpTblNm.Co_Path),'A','Y','B')
			Endif
			=ErrLog(_TmpTblNmA.FName,'A')
			_OldPath = _TmpTblNm.Co_Path
			SELECT _TmpTblNmA
		Endscan	
	Endif
Endif

_TmpTblNm1 = '_TmpBefUpdt'+'T'
_TmpTblNm2 = '_TmpAftUpdt'+'T'
IF USED(_TmpTblNm1)	
	SELECT TName,Name,User_Type_Id,Max_Length,Precision,Scale FROM (_TmpTblNm1) WHERE Co_Name == _mCompany INTO CURSOR _TmpTblNmA
	SELECT TName,Name,User_Type_Id,Max_Length,Precision,Scale FROM (_TmpTblNm2) WHERE Co_Name == _mCompany INTO CURSOR _TmpTblNmB

	SELECT DISTINCT TName FROM _TmpTblNmA WHERE TName + 'A' NOT in (SELECT TName + 'A' FROM _TmpTblNmB) ;
		INTO CURSOR _TmpTblNm
	SELECT _TmpTblNm
	IF RECCOUNT() > 0
		=ErrLog('Tables Deleted','A','Y')
		SCAN
			=ErrLog(_TmpTblNm.TName,'A')
			SELECT _TmpTblNm
		Endscan	
	Endif


	SELECT DISTINCT TName FROM _TmpTblNmB WHERE TName + 'A' NOT in (SELECT TName + 'A' FROM _TmpTblNmA) ;
		INTO CURSOR _TmpTblNm
	SELECT _TmpTblNm
	IF RECCOUNT() > 0
		=ErrLog('New Tables Created','A','Y')
		SCAN
			=ErrLog(_TmpTblNm.TName,'A')
			SELECT _TmpTblNm
		Endscan	
	Endif

	SELECT Distinct TName FROM _TmpTblNmA INTO CURSOR _TmpTblNmC
	SELECT _TmpTblNmC
	SCAN
		_mTname = _TmpTblNmC.TName
		SELECT * FROM _TmpTblNmA WHERE TName = _mTname INTO CURSOR _TmpTblNmE
		SELECT * FROM _TmpTblNmB WHERE TName = _mTname INTO CURSOR _TmpTblNmF
		
		SELECT DISTINCT Name FROM _TmpTblNmE WHERE Name + 'A' NOT in (SELECT Name + 'A' FROM _TmpTblNmF) ;
			INTO CURSOR _TmpTblNm
		SELECT _TmpTblNm
		IF RECCOUNT() > 0
			=ErrLog('Fields Deleted in Table : '+_mTname,'A','Y')
			SCAN
				=ErrLog(_TmpTblNm.Name,'A')
				SELECT _TmpTblNm
			Endscan	
		Endif

		SELECT DISTINCT Name FROM _TmpTblNmF WHERE Name + 'A' NOT in (SELECT Name + 'A' FROM _TmpTblNmE) ;
			INTO CURSOR _TmpTblNm
		SELECT _TmpTblNm
		IF RECCOUNT() > 0
			=ErrLog('New Fields Created in Table : '+_mTname,'A','Y')
			SCAN
				=ErrLog(_TmpTblNm.Name,'A')
				SELECT _TmpTblNm
			Endscan	
		Endif

		SELECT a.Name,;
			a.User_Type_Id As aUser_Type_Id,b.User_Type_Id  As bUser_Type_Id,;
			a.Max_Length as aMax_Length,b.Max_Length as bMax_Length,;
			a.Precision as aPrecision,b.Precision as bPrecision,;
			a.Scale as aScale,b.Scale as bScale ;
			FROM _TmpTblNmE a,_TmpTblNmF b WHERE a.Name + 'A' = b.Name + 'A' ;
			INTO CURSOR _TmpTblNm
		SELECT Name FROM _TmpTblNm WHERE (aUser_Type_Id != bUser_Type_Id Or aMax_Length != bMax_Length Or aPrecision != bPrecision Or aScale != bScale) ;
			INTO CURSOR _TmpTblNmD
		SELECT _TmpTblNmD
		IF RECCOUNT() > 0
			=ErrLog('Fields Updated in Table : '+_mTname,'A','Y')
			SCAN
				=ErrLog(_TmpTblNmD.Name,'A')
				SELECT _TmpTblNmD
			Endscan	
		ENDIF
		
		SELECT _TmpTblNmC
	Endscan	
ENDIF

_TmpTblNm1 = '_TmpBefUpdt'+'P'
_TmpTblNm2 = '_TmpAftUpdt'+'P'
IF USED(_TmpTblNm1)
	SELECT Name,Modify_date FROM (_TmpTblNm1) WHERE Co_Name == _mCompany INTO CURSOR _TmpTblNmA
	SELECT Name,Modify_date FROM (_TmpTblNm2) WHERE Co_Name == _mCompany INTO CURSOR _TmpTblNmB

	SELECT DISTINCT Name FROM _TmpTblNmA WHERE Name + 'A' NOT in (SELECT Name + 'A' FROM _TmpTblNmB) ;
		INTO CURSOR _TmpTblNm
	SELECT _TmpTblNm
	IF RECCOUNT() > 0
		=ErrLog('Store Procedures Deleted','A','Y')
		SCAN
			=ErrLog(_TmpTblNm.Name,'A')
			SELECT _TmpTblNm
		Endscan	
	Endif

	SELECT DISTINCT Name FROM _TmpTblNmB WHERE Name + 'A' NOT in (SELECT Name + 'A' FROM _TmpTblNmA) ;
		INTO CURSOR _TmpTblNm
	SELECT _TmpTblNm
	IF RECCOUNT() > 0
		=ErrLog('Store Procedures Created','A','Y')
		SCAN
			=ErrLog(_TmpTblNm.Name,'A')
			SELECT _TmpTblNm
		Endscan	
	Endif

	SELECT a.Name,a.Modify_date as aModify_date,b.Modify_date as bModify_date FROM _TmpTblNmA a,_TmpTblNmB b WHERE a.Name + 'A' = b.Name + 'A' ;
		INTO CURSOR _TmpTblNm
	SELECT DISTINCT Name FROM _TmpTblNm WHERE (aModify_date != bModify_date Or aModify_date != bModify_date) INTO CURSOR _TmpTblNmA		
	SELECT _TmpTblNmA
	IF RECCOUNT() > 0
		=ErrLog('Store Procedures Updated','A','Y')
		SCAN
			=ErrLog(_TmpTblNmA.Name,'A')
			SELECT _TmpTblNmA
		Endscan	
	Endif
ENDIF

_TmpTblNm1 = '_TmpBefUpdt'+'V'
_TmpTblNm2 = '_TmpAftUpdt'+'V'
IF USED(_TmpTblNm1)
	SELECT Name,Modify_date FROM (_TmpTblNm1) WHERE Co_Name == _mCompany INTO CURSOR _TmpTblNmA
	SELECT Name,Modify_date FROM (_TmpTblNm2) WHERE Co_Name == _mCompany INTO CURSOR _TmpTblNmB

	SELECT DISTINCT Name FROM _TmpTblNmA WHERE Name + 'A' NOT in (SELECT Name + 'A' FROM _TmpTblNmB) ;
		INTO CURSOR _TmpTblNm
	SELECT _TmpTblNm
	IF RECCOUNT() > 0
		=ErrLog('View Files Deleted','A','Y')
		SCAN
			=ErrLog(_TmpTblNm.Name,'A')
			SELECT _TmpTblNm
		Endscan	
	Endif

	SELECT DISTINCT Name FROM _TmpTblNmB WHERE Name + 'A' NOT in (SELECT Name + 'A' FROM _TmpTblNmA) ;
		INTO CURSOR _TmpTblNm
	SELECT _TmpTblNm
	IF RECCOUNT() > 0
		=ErrLog('View Files Created','A','Y')
		SCAN
			=ErrLog(_TmpTblNm.Name,'A')
			SELECT _TmpTblNm
		Endscan	
	Endif

	SELECT a.Name,a.Modify_date as aModify_date,b.Modify_date as bModify_date FROM _TmpTblNmA a,_TmpTblNmB b WHERE a.Name + 'A' = b.Name + 'A' ;
		INTO CURSOR _TmpTblNm
	SELECT DISTINCT Name FROM _TmpTblNm WHERE (aModify_date != bModify_date Or aModify_date != bModify_date) INTO CURSOR _TmpTblNmA			
	SELECT _TmpTblNmA
	IF RECCOUNT() > 0
		=ErrLog('View Files Updated','A','Y')
		SCAN
			=ErrLog(_TmpTblNmA.Name,'A')
			SELECT _TmpTblNmA
		Endscan	
	Endif
Endif					
