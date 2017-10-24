IF EXISTS (SELECT XTYPE, NAME FROM SYSOBJECTS WHERE XTYPE = 'P' AND NAME = 'USP_REP_UP_ANNEXURE_B1')
BEGIN
	DROP PROCEDURE USP_REP_UP_ANNEXURE_B1
END
GO
set ANSI_NULLS ON
GO
set QUOTED_IDENTIFIER ON
go
-- =============================================
-- Author:		Rakesh Varma
-- Create date: May 13,2010
-- Description:	This Stored procedure is useful to generate VAT Computation Report.
-- Modify date: May 14,2010
-- Modified By: Rakesh Varma
-- Modify date: 07/07/2015
-- Modified By: Gaurav R. Tanna for the bug-
-- Remark:
-- =============================================
CREATE PROCEDURE [dbo].[USP_REP_UP_ANNEXURE_B1]
@TMPAC NVARCHAR(50),@TMPIT NVARCHAR(50),@SPLCOND VARCHAR(8000),@SDATE  SMALLDATETIME,@EDATE SMALLDATETIME
,@SAC AS VARCHAR(60),@EAC AS VARCHAR(60)
,@SIT AS VARCHAR(60),@EIT AS VARCHAR(60)
,@SAMT FLOAT,@EAMT FLOAT
,@SDEPT AS VARCHAR(60),@EDEPT AS VARCHAR(60)
,@SCATE AS VARCHAR(60),@ECATE AS VARCHAR(60)
,@SWARE AS VARCHAR(60),@EWARE AS VARCHAR(60)
,@SINV_SR AS VARCHAR(60),@EINV_SR AS VARCHAR(60)
,@LYN VARCHAR(20)
,@EXPARA  AS VARCHAR(60)= NULL
AS

BEGIN
DECLARE @FCON AS NVARCHAR(2000)
EXECUTE   USP_REP_FILTCON 

@VTMPAC =@TMPAC,@VTMPIT =@TMPIT,@VSPLCOND =@SPLCOND
,@VSDATE=NULL,@VEDATE=@EDATE
,@VSAC =@SAC,@VEAC =@EAC
,@VSIT=@SIT,@VEIT=@EIT
,@VSAMT=@SAMT,@VEAMT=@EAMT
,@VSDEPT=@SDEPT,@VEDEPT=@EDEPT
,@VSCATE =@SCATE,@VECATE =@ECATE
,@VSWARE =@SWARE,@VEWARE  =@EWARE
,@VSINV_SR =@SINV_SR,@VEINV_SR =@SINV_SR
,@VMAINFILE='M',@VITFILE=Null,@VACFILE='AC'
,@VDTFLD ='DATE'
,@VLYN=Null
,@VEXPARA=@EXPARA
,@VFCON =@FCON OUTPUT

DECLARE @SQLCOMMAND NVARCHAR(4000)
Declare @NetEff as numeric (12,2), @NetTax as numeric (12,2)

---Temporary Cursor
SELECT PART=3,PARTSR='AAA',SRNO='AAA',RATE=99.999,AMT1=NET_AMT,AMT2=M.TAXAMT,AMT3=M.TAXAMT,
M.INV_NO,M.DATE,PARTY_NM=AC1.AC_NAME,ADDRESS=Ltrim(AC1.Add1)+' '+Ltrim(AC1.Add2)+' '+Ltrim(AC1.Add3),
STM.FORM_NM,AC1.S_TAX,Item=space(150),qty=9999999999999999999.9999,MAIN_TY=M.ENTRY_TY, MAIN_CD = M.TRAN_CD, MAIN_INV=M.INV_NO,  MAIN_DATE = M.DATE
INTO #AnnexA
FROM PTACDET A 
INNER JOIN STMAIN M ON (A.ENTRY_TY=M.ENTRY_TY AND A.TRAN_CD=M.TRAN_CD)
INNER JOIN STAX_MAS STM ON (M.TAX_NAME=STM.TAX_NAME)
INNER JOIN AC_MAST AC ON (A.AC_NAME=AC.AC_NAME)
INNER JOIN AC_MAST AC1 ON (M.AC_ID=AC1.AC_ID)
WHERE 1=2

Declare @MultiCo	VarChar(3)
Declare @MCON as NVARCHAR(2000)
IF Exists(Select A.ID From SysObjects A Inner Join SysColumns B On(A.ID = B.ID) Where A.[Name] = 'STMAIN' And B.[Name] = 'DBNAME')
	Begin	------Fetch Records from Multi Co. Data
		 Set @MultiCo = 'YES'
	End
else
	Begin ------Fetch Single Co. Data
		 Set @MultiCo = 'NO'
		 EXECUTE USP_REP_SINGLE_CO_DATA_VAT
		  @TMPAC, @TMPIT, @SPLCOND, @SDATE, @EDATE
		 ,@SAC, @EAC, @SIT, @EIT, @SAMT, @EAMT
		 ,@SDEPT, @EDEPT, @SCATE, @ECATE,@SWARE
		 ,@EWARE, @SINV_SR, @EINV_SR, @LYN, @EXPARA
		 ,@MFCON = @MCON OUTPUT
	End

--select * from #annex_a

DECLARE @BHENT VARCHAR(200),@INV_NO VARCHAR(200),@DATE VARCHAR(200),@ST_TYPE VARCHAR(200),@CHAR INT,
         @NET_AMT NUMERIC(14,2),@PARTY_NM VARCHAR(200),@ITEM VARCHAR(200),@TAXAMT NUMERIC(14,2),@GRO_AMT NUMERIC(14,2),
         @S_TAX VARCHAR(200),@QTY VARCHAR(200),@ADDRESS VARCHAR(500),@PINV_NO VARCHAR(200),@PDATE VARCHAR(200),
         @PQTY NUMERIC(18,4),@PNET_AMT NUMERIC (14,2), @PTAX_AMT NUMERIC (14,2), @PGRO_AMT NUMERIC(14,2),@VATTYPE VARCHAR(50),
         @TRAN_CD NUMERIC(8)

 SET @CHAR=65
 SELECT @PINV_NO ='',@PDATE ='', @PQTY =0,@PNET_AMT =0, @PTAX_AMT =0, @PGRO_AMT =0, @VATTYPE = '',@BHENT = '',@TRAN_CD=0

 --DECLARE UP_ANN_A1 CURSOR FOR 
 --SELECT AA.PARTY_NM,AA.S_TAX,AA.INV_NO,AA.DATE,LV.ITEM,LV.QTY,AA.NET_AMT,AA.TAXAMT,AA.ADDRESS
 --FROM #Annex_A AA INNER JOIN LITEM_VW LV
 --ON (AA.BHENT = LV.ENTRY_TY AND AA.TRAN_CD = LV.TRAN_CD AND AA.IT_CODE = LV.IT_CODE And AA.ITSERIAL = LV.ITSERIAL)
 --WHERE AA.BHENT IN ('PR','DN') AND AA.TAX_NAME LIKE '%Vat%' AND (AA.DATE BETWEEN @SDATE AND @EDATE)
 
 DECLARE UP_ANNA1 CURSOR FOR 
SELECT A.AC_NAME, A.ADDRESS,A.S_TAX, A.INV_NO,A.DATE,
ITEM=CASE WHEN CAST(I.IT_DESC AS VARCHAR(150)) <> '' THEN CAST(I.IT_DESC AS VARCHAR(150)) ELSE I.IT_NAME END,D.QTY,A.VATONAMT,A.TAXAMT, (A.VATONAMT+A.TAXAMT),A.VATTYPE,
P.QTY AS PQTY,(P.GRO_AMT-P.TAXAMT-P.tot_nontax) AS PVATONAMT,P.TAXAMT AS PTAX_AMT, (P.GRO_AMT-P.tot_nontax) AS PGRO_AMT,P.INV_NO AS PINV_NO,P.DATE AS PDATE,
A.BHENT,A.TRAN_CD
FROM VATTBL A 
INNER JOIN SRITEM D ON (D.Tran_cd = A.TRAN_CD AND D.entry_ty = A.BHENT AND D.itserial = A.ItSerial)
INNER JOIN IT_MAST I ON (I.IT_CODE = D.IT_CODE)
LEFT JOIN SRITREF R ON (R.TRAN_CD = A.TRAN_CD AND R.ItSerial = A.ItSerial AND R.entry_ty = A.BHENT)
LEFT JOIN STITEM P ON (P.entry_ty = R.rentry_ty AND P.Tran_cd = R.Itref_tran AND P.ItSerial = R.RItSerial)
WHERE A.BHENT = 'SR' AND (A.DATE BETWEEN @SDATE AND @EDATE)
UNION
SELECT A.AC_NAME, A.ADDRESS,A.S_TAX, A.INV_NO,A.DATE,
ITEM=CASE WHEN CAST(I.IT_DESC AS VARCHAR(150)) <> '' THEN CAST(I.IT_DESC AS VARCHAR(150)) ELSE I.IT_NAME END,D.QTY,A.VATONAMT,A.TAXAMT, (A.VATONAMT+A.TAXAMT),A.VATTYPE,
P.QTY AS PQTY,(P.GRO_AMT-P.TAXAMT-P.tot_nontax) AS PVATONAMT,P.TAXAMT AS PTAX_AMT, (P.GRO_AMT-P.tot_nontax) AS PGRO_AMT,P.INV_NO AS PINV_NO,P.DATE AS PDATE,
A.BHENT,A.TRAN_CD
FROM VATTBL A 
INNER JOIN CNITEM D ON (D.Tran_cd = A.TRAN_CD AND D.entry_ty = A.BHENT AND D.itserial = A.ItSerial)
INNER JOIN IT_MAST I ON (I.IT_CODE = D.IT_CODE)
INNER JOIN CNMAIN M ON (M.Tran_cd = A.TRAN_CD AND M.entry_ty = A.BHENT)
LEFT JOIN CNITREF R ON (R.TRAN_CD = A.TRAN_CD AND R.ItSerial = A.ItSerial AND R.entry_ty = A.BHENT)
LEFT JOIN STITEM P ON (P.entry_ty = R.rentry_ty AND P.Tran_cd = R.Itref_tran AND P.ItSerial = R.RItSerial)
WHERE A.BHENT = 'CN'  AND M.U_GPRICE = 'Goods Sold returned'
AND (A.DATE BETWEEN @SDATE AND @EDATE)
ORDER BY A.INV_NO, A.DATE

 
 OPEN UP_ANNA1
 FETCH NEXT FROM UP_ANNA1 INTO @PARTY_NM,@ADDRESS,@S_TAX,@INV_NO,@DATE,@ITEM,@QTY,@NET_AMT,@TAXAMT, @GRO_AMT, @VATTYPE,
 @PQTY,@PNET_AMT,@PTAX_AMT,@PGRO_AMT,@PINV_NO,@PDATE,@BHENT,@TRAN_CD
 
 WHILE (@@FETCH_STATUS=0)
 BEGIN 
 
 SET @PQTY = ISNULL(@PQTY,0)
 SET @PNET_AMT= ISNULL(@PNET_AMT,0)
 SET @PTAX_AMT= ISNULL(@PTAX_AMT,0)
 SET @PGRO_AMT= ISNULL(@PGRO_AMT,0)
 SET @PINV_NO= ISNULL(@PINV_NO,'')
 SET @PDATE= ISNULL(@PDATE,'')--CASE WHEN ISNULL(@PDATE,'') = '' THEN @Date ELSE ISNULL(@PDATE,'') END
 
 PRINT @INV_NO
 PRINT @PDATE
 PRINT @DATE
 
 IF @VATTYPE = ''
    begin
		
		 INSERT INTO #AnnexA (PART,PARTSR,SRNO,RATE,INV_NO,DATE,ITEM,PARTY_NM,S_TAX,AMT1,AMT2,AMT3,QTY,ADDRESS,MAIN_TY,MAIN_CD,MAIN_INV,MAIN_DATE) 
					  VALUES (1,'3',CHAR(@CHAR),0,@INV_NO,@Date,@ITEM,@PARTY_NM,@S_TAX,@NET_AMT,@TAXAMT,@GRO_AMT,@QTY,@ADDRESS,@BHENT,@TRAN_CD,@INV_NO,@DATE)
		              
		 INSERT INTO #AnnexA (PART,PARTSR,SRNO,RATE,INV_NO,DATE,ITEM,PARTY_NM,S_TAX,AMT1,AMT2,AMT3,QTY,ADDRESS,MAIN_TY,MAIN_CD,MAIN_INV,MAIN_DATE) 
					  VALUES (1,'1',CHAR(@CHAR),0,@PINV_NO,@PDate,@ITEM,@PARTY_NM,@S_TAX,@PNET_AMT,@PTAX_AMT,@PGRO_AMT,@PQTY,@ADDRESS,@BHENT,@TRAN_CD,@INV_NO,@DATE) 
    
    end
 else if @VATTYPE = 'Non Vat'
	begin
		 INSERT INTO #AnnexA (PART,PARTSR,SRNO,RATE,INV_NO,DATE,ITEM,PARTY_NM,S_TAX,AMT1,AMT2,AMT3,QTY,ADDRESS,MAIN_TY,MAIN_CD,MAIN_INV,MAIN_DATE) 
					  VALUES (1,'4',CHAR(@CHAR),0,@INV_NO,@Date,@ITEM,@PARTY_NM,@S_TAX,@NET_AMT,@TAXAMT,@GRO_AMT,@QTY,@ADDRESS,@BHENT,@TRAN_CD,@INV_NO,@DATE)
		              
		 INSERT INTO #AnnexA (PART,PARTSR,SRNO,RATE,INV_NO,DATE,ITEM,PARTY_NM,S_TAX,AMT1,AMT2,AMT3,QTY,ADDRESS,MAIN_TY,MAIN_CD,MAIN_INV,MAIN_DATE) 
					  VALUES (1,'2',CHAR(@CHAR),0,@PINV_NO,@PDate,@ITEM,@PARTY_NM,@S_TAX,@PNET_AMT,@PTAX_AMT,@PGRO_AMT,@PQTY,@ADDRESS,@BHENT,@TRAN_CD,@INV_NO,@DATE)              
    
	end
	
 SET @CHAR = @CHAR + 1

 FETCH NEXT FROM UP_ANNA1 INTO @PARTY_NM,@ADDRESS,@S_TAX,@INV_NO,@DATE,@ITEM,@QTY,@NET_AMT,@TAXAMT, @GRO_AMT, @VATTYPE,
 @PQTY,@PNET_AMT,@PTAX_AMT,@PGRO_AMT,@PINV_NO,@PDATE,@BHENT,@TRAN_CD
 
 END 

 CLOSE UP_ANNA1
 DEALLOCATE UP_ANNA1
--------------------------------------------------------------------------------------------------------

DECLARE @RCOUNT INT

SELECT @RCOUNT = 0

SET @RCOUNT = (SELECT COUNT(*) FROM #AnnexA WHERE PARTSR='1')

IF (@RCOUNT=0)
INSERT INTO #AnnexA (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,party_nm,qty,MAIN_TY,MAIN_CD,MAIN_INV,MAIN_DATE) VALUES (1,'1','A',0,0,0,0,'',0,'',0,'','')

--------------------------------------------------------------------------------------------------------

SELECT @RCOUNT = 0

SET @RCOUNT = (SELECT COUNT(*) FROM #AnnexA WHERE PARTSR='2')

IF (@RCOUNT=0)
INSERT INTO #AnnexA (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,party_nm,qty,MAIN_TY,MAIN_CD,MAIN_INV,MAIN_DATE) VALUES (1,'2','A',0,0,0,0,'',0,'',0,'','')
--------------------------------------------------------------------------------------------------------

SELECT @RCOUNT = 0

SET @RCOUNT = (SELECT COUNT(*) FROM #AnnexA WHERE PARTSR='3')

IF (@RCOUNT=0)
INSERT INTO #AnnexA (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,party_nm,qty,MAIN_TY,MAIN_CD,MAIN_INV,MAIN_DATE) VALUES (1,'3','A',0,0,0,0,'',0,'',0,'','')
--------------------------------------------------------------------------------------------------------

SELECT @RCOUNT = 0

SET @RCOUNT = (SELECT COUNT(*) FROM #AnnexA WHERE PARTSR='4')

IF (@RCOUNT=0)
INSERT INTO #AnnexA (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,party_nm,qty,MAIN_TY,MAIN_CD,MAIN_INV,MAIN_DATE) VALUES (1,'4','A',0,0,0,0,'',0,'',0,'','')

-------------------------------------------------------------------------------------------------------------

	
Update #AnnexA set  PART = isnull(Part,0) , Partsr = isnull(PARTSR,''), SRNO = isnull(SRNO,''),
		             RATE = isnull(RATE,0), AMT1 = isnull(AMT1,0), AMT2 = isnull(AMT2,0), 
					 AMT3 = isnull(AMT3,0), INV_NO = isnull(INV_NO,''), DATE = isnull(Date,''), 
					 PARTY_NM = isnull(Party_nm,''), ADDRESS = isnull(Address,''),
					 FORM_NM = isnull(form_nm,''), S_TAX = isnull(S_tax,''), Qty = isnull(Qty,0),  ITEM =isnull(item,'')

SELECT * FROM #AnnexA order by cast(substring(partsr,1,case when (isnumeric(substring(partsr,1,2))=1) then 2 else 1 end) as int), Main_ty,main_cd,main_inv,main_date
END
-----
----Print 'UP VAT FORM 24A'
--Go
-------
----Print 'UP STORED PROCEDURE UPDATION COMPLETED'
--Go

