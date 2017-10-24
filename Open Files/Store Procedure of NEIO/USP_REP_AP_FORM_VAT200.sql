If Exists(Select [name] From SysObjects Where xtype='P' and [Name]='USP_REP_AP_FORM_VAT200')
Begin
	Drop Procedure USP_REP_AP_FORM_VAT200
End
GO
-- =============================================  
-- Author   : Hetal L Patel
-- Create date: 16/05/2007  
-- Description: This Stored procedure is useful to generate AP VAT Form 200
-- Modify date: 16/08/2011
-- Modified By: Add the Jv Transaction for VAT & CST Adjustment for TKT-9064
-- Modify date: 23/11/2011
-- Modified By: chagnes done in Exempt or non-creditable Purchases and Others (CST Sales ) for TKT-9064
-- Modified By: Changes has been done by sandeep on 23/11/2011 for BUG-146 
-- Modify date: Changes has been done by sandeep on 31/12/2011 for bug-1266    
-- Modified By: Changes has been done by Gaurav Tanna on 07/10/2014 for BUG-23933
-- Remark:  
-- =============================================  
CREATE Procedure [dbo].[USP_REP_AP_FORM_VAT200]
@TMPAC NVARCHAR(50),@TMPIT NVARCHAR(50),@SPLCOND VARCHAR(8000),@SDATE SMALLDATETIME,@EDATE SMALLDATETIME  
,@SAC AS VARCHAR(60),@EAC AS VARCHAR(60)  
,@SIT AS VARCHAR(60),@EIT AS VARCHAR(60)  
,@SAMT FLOAT,@EAMT FLOAT  
,@SDEPT AS VARCHAR(60),@EDEPT AS VARCHAR(60)  
,@SCATE AS VARCHAR(60),@ECATE AS VARCHAR(60)  
,@SWARE AS VARCHAR(60),@EWARE AS VARCHAR(60)  
,@SINV_SR AS VARCHAR(60),@EINV_SR AS VARCHAR(60)  
,@LYN VARCHAR(20)  
,@EXPARA  AS VARCHAR(60)= null  
AS  
BEGIN  
Declare @FCON as NVARCHAR(2000),@VSAMT DECIMAL(14,2),@VEAMT DECIMAL(14,2)  
EXECUTE   USP_REP_FILTCON   
@VTMPAC =@TMPAC,@VTMPIT =@TMPIT,@VSPLCOND =@SPLCOND  
,@VSDATE=NULL  
,@VEDATE=@EDATE  
,@VSAC =@SAC,@VEAC =@EAC  
,@VSIT=@SIT,@VEIT=@EIT  
,@VSAMT=@SAMT,@VEAMT=@EAMT  
,@VSDEPT=@SDEPT,@VEDEPT=@EDEPT  
,@VSCATE =@SCATE,@VECATE =@ECATE  
,@VSWARE =@SWARE,@VEWARE  =@EWARE  
,@VSINV_SR =@SINV_SR,@VEINV_SR =@SINV_SR  
,@VMAINFILE='M',@VITFILE=NULL,@VACFILE=NULL  
,@VDTFLD ='DATE'  
,@VLYN=NULL  
,@VEXPARA=@EXPARA  
,@VFCON =@FCON OUTPUT  
  
DECLARE @SQLCOMMAND NVARCHAR(4000)  
DECLARE @RATE NUMERIC(12,2),@AMTA1 NUMERIC(12,2),@AMTB1 NUMERIC(12,2),@AMTC1 NUMERIC(12,2),@AMTD1 NUMERIC(12,2),@AMTE1 NUMERIC(12,2),@AMTF1 NUMERIC(12,2),@AMTG1 NUMERIC(12,2),@AMTH1 NUMERIC(12,2),@AMTI1 NUMERIC(12,2),@AMTJ1 NUMERIC(12,2),@AMTK1 NUMERIC(12,2),@AMTL1 NUMERIC(12,2),@AMTM1 NUMERIC(12,2),@AMTN1 NUMERIC(12,2),@AMTO1 NUMERIC(12,2)  
DECLARE @AMTA2 NUMERIC(12,2),@AMTB2 NUMERIC(12,2),@AMTC2 NUMERIC(12,2),@AMTD2 NUMERIC(12,2),@AMTE2 NUMERIC(12,2),@AMTF2 NUMERIC(12,2),@AMTG2 NUMERIC(12,2),@AMTH2 NUMERIC(12,2),@AMTI2 NUMERIC(12,2),@AMTJ2 NUMERIC(12,2),@AMTK2 NUMERIC(12,2),@AMTL2 NUMERIC(12,2),@AMTM2 NUMERIC(12,2),@AMTN2 NUMERIC(12,2),@AMTO2 NUMERIC(12,2)  
DECLARE @AMTA3 NUMERIC(12,2),@M1 NUMERIC(2),@M2 NUMERIC (2),@SDATE1 SMALLDATETIME,@EDATE1 SMALLDATETIME  
DECLARE @PER NUMERIC(12,2),@TAXAMT NUMERIC(12,2),@CHAR INT,@LEVEL NUMERIC(12,2)--, @S_Tax VARCHAR(20)
  
SELECT DISTINCT AC_NAME=SUBSTRING(AC_NAME1,2,CHARINDEX('"',SUBSTRING(AC_NAME1,2,100))-1) INTO #VATAC_MAST FROM STAX_MAS WHERE AC_NAME1 NOT IN ('"SALES"','"PURCHASES"') AND ISNULL(AC_NAME1,'')<>''
--INSERT INTO #VATAC_MAST SELECT DISTINCT AC_NAME=SUBSTRING(AC_NAME1,2,CHARINDEX('"',SUBSTRING(AC_NAME1,2,100))-1) FROM STAX_MAS WHERE AC_NAME1 NOT IN ('"SALES"','"PURCHASES"') AND ISNULL(AC_NAME1,'')<>''
 
Declare @NetEff as numeric (12,2), @NetTax as numeric (12,2)

Declare @PSDate SMALLDATETIME, @PEDate SMALLDATETIME
		  
Set @PSDate = DATEADD(MONTH, DATEDIFF(MONTH, 0, @SDATE) - 1, 0)
Set @PEDate = (DATEADD(DAY, -(DAY(@SDATE)), @SDATE))

-- bug-23933 - start
----Temporary Cursor1
/*
SELECT BHENT='PT',M.INV_NO,M.Date,A.AC_NAME,A.AMT_TY,STM.TAX_NAME,SET_APP=ISNULL(SET_APP,0),STM.ST_TYPE,M.NET_AMT,M.GRO_AMT,TAXONAMT=M.GRO_AMT+M.TOT_DEDUC+M.TOT_TAX+M.TOT_EXAMT+M.TOT_ADD,PER=STM.LEVEL1,MTAXAMT=M.TAXAMT,TAXAMT=A.AMOUNT,STM.FORM_NM,PARTY_NM=AC1.AC_NAME,AC1.S_TAX,M.U_IMPORM
,ADDRESS=LTRIM(AC1.ADD1)+ ' ' + LTRIM(AC1.ADD2) + ' ' + LTRIM(AC1.ADD3),M.TRAN_CD,VATONAMT=99999999999.99,Dbname=space(20),ItemType=space(1),It_code=999999999999999999-999999999999999999,ItSerial=Space(5)
INTO #FORMVAT_200_A
FROM PTACDET A 
INNER JOIN PTMAIN M ON (A.ENTRY_TY=M.ENTRY_TY AND A.TRAN_CD=M.TRAN_CD)
INNER JOIN STAX_MAS STM ON (M.TAX_NAME=STM.TAX_NAME)
INNER JOIN AC_MAST AC ON (A.AC_NAME=AC.AC_NAME)
INNER JOIN AC_MAST AC1 ON (M.AC_ID=AC1.AC_ID)
WHERE 1=2 --A.AC_NAME IN ( SELECT AC_NAME FROM #VATAC_MAST)

alter table #FORMVAT_200_A add recno int identity
*/
---Temporary Cursor2
/*
SELECT PART=3,PARTSR='AAA',SRNO='AAA',RATE=9999999999.999,AMT1=NET_AMT,AMT2=M.TAXAMT,AMT3=M.TAXAMT,
M.INV_NO,M.DATE,PARTY_NM=AC1.AC_NAME,ADDRESS=Ltrim(AC1.Add1)+' '+Ltrim(AC1.Add2)+' '+Ltrim(AC1.Add3),STM.FORM_NM,AC1.S_TAX
INTO #FORMVAT_200
FROM PTACDET A 
INNER JOIN STMAIN M ON (A.ENTRY_TY=M.ENTRY_TY AND A.TRAN_CD=M.TRAN_CD)
INNER JOIN STAX_MAS STM ON (M.TAX_NAME=STM.TAX_NAME)
INNER JOIN AC_MAST AC ON (A.AC_NAME=AC.AC_NAME)
INNER JOIN AC_MAST AC1 ON (M.AC_ID=AC1.AC_ID)
WHERE 1=2
*/

SELECT PART=3,PARTSR='AAA',SRNO='AAA',RATE=9999999999.999,AMT1=NET_AMT,AMT2=M.TAXAMT,AMT3=M.TAXAMT,
M.INV_NO,M.DATE,PARTY_NM=AC1.AC_NAME,ADDRESS=Ltrim(AC1.Add1)+' '+Ltrim(AC1.Add2)+' '+Ltrim(AC1.Add3),STM.FORM_NM,AC1.S_TAX
INTO #FORMVAT_200
FROM PTACDET A 
INNER JOIN STMAIN M ON (A.ENTRY_TY=M.ENTRY_TY AND A.TRAN_CD=M.TRAN_CD)
INNER JOIN STAX_MAS STM ON (M.TAX_NAME=STM.TAX_NAME)
INNER JOIN AC_MAST AC ON (A.AC_NAME=AC.AC_NAME)
INNER JOIN AC_MAST AC1 ON (M.AC_ID=AC1.AC_ID)
WHERE 1=2
  
 SET @AMTA1=0
 
IF NOT EXISTS (SELECT 1 
           FROM INFORMATION_SCHEMA.TABLES 
           WHERE TABLE_NAME='FORMVAT_201') 
	begin
		 SELECT PART=3,PARTSR='AAA',SRNO='AAA',RATE=9999999999.999,AMT1=NET_AMT,AMT2=M.TAXAMT,AMT3=M.TAXAMT,
		 M.INV_NO,M.DATE,PARTY_NM=AC1.AC_NAME,ADDRESS=Ltrim(AC1.Add1)+' '+Ltrim(AC1.Add2)+' '+Ltrim(AC1.Add3),STM.FORM_NM,AC1.S_TAX
		 INTO FORMVAT_201
		 FROM PTACDET A 
		 INNER JOIN STMAIN M ON (A.ENTRY_TY=M.ENTRY_TY AND A.TRAN_CD=M.TRAN_CD)
		 INNER JOIN STAX_MAS STM ON (M.TAX_NAME=STM.TAX_NAME)
		 INNER JOIN AC_MAST AC ON (A.AC_NAME=AC.AC_NAME)
		 INNER JOIN AC_MAST AC1 ON (M.AC_ID=AC1.AC_ID)
		 WHERE 1=2
		 print 'Previous month credit'
		 insert into FORMVAT_201 EXECUTE USP_REP_AP_FORM_VAT200 '','','',@PSDate,@PEDate,'','','','',0,0,'','','','','','','','','2014-2015',''
		
		 SELECT @AMTA1 = RATE FROM FORMVAT_201 WHERE PARTSR = '23A' AND SRNO = 'A'

		 DROP TABLE FORMVAT_201
	end

SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
INSERT INTO #FORMVAT_200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (0,'0','A',0,@AMTA1,0,0,'')  
-- bug-23933 - end here

Declare @MultiCo	VarChar(3)
Declare @MCON as NVARCHAR(2000)

IF Exists(Select A.ID From SysObjects A Inner Join SysColumns B On(A.ID = B.ID) Where A.[Name] = 'STMAIN' And B.[Name] = 'DBNAME')
	
	Begin	------Fetch Records from Multi Co. Data
		 Set @MultiCo = 'YES'
		 EXECUTE USP_REP_MULTI_CO_DATA
		  @TMPAC, @TMPIT, @SPLCOND, @SDATE, @EDATE
		 ,@SAC, @EAC, @SIT, @EIT, @SAMT, @EAMT
		 ,@SDEPT, @EDEPT, @SCATE, @ECATE,@SWARE
		 ,@EWARE, @SINV_SR, @EINV_SR, @LYN, @EXPARA
		 ,@MFCON = @MCON OUTPUT

		--SET @SQLCOMMAND='Select * from '+@MCON
		---EXECUTE SP_EXECUTESQL @SQLCOMMAND
		
		-- bug-23933 - start here 
		--SET @SQLCOMMAND='Insert InTo  #FORMVAT_200_A Select * from '+@MCON		
		SET @SQLCOMMAND='Insert InTo  VATTBL Select * from '+@MCON
		-- bug-23933 - end here 
		EXECUTE SP_EXECUTESQL @SQLCOMMAND
		
		---Drop Temp Table 
		SET @SQLCOMMAND='Drop Table '+@MCON
		EXECUTE SP_EXECUTESQL @SQLCOMMAND
	End
	
	
else
	Begin ------Fetch Single Co. Data
		 Set @MultiCo = 'NO'
		 	 
		-- bug-23933 - start here 
		--EXECUTE USP_REP_SINGLE_CO_DATA
		 EXECUTE USP_REP_SINGLE_CO_DATA_VAT		  
		  @TMPAC, @TMPIT, @SPLCOND, @SDATE, @EDATE
		 ,@SAC, @EAC, @SIT, @EIT, @SAMT, @EAMT
		 ,@SDEPT, @EDEPT, @SCATE, @ECATE,@SWARE
		 ,@EWARE, @SINV_SR, @EINV_SR, @LYN, @EXPARA
		 ,@MFCON = @MCON OUTPUT
		/*
		--SET @SQLCOMMAND='Select * from '+@MCON
		---EXECUTE SP_EXECUTESQL @SQLCOMMAND
		SET @SQLCOMMAND='Insert InTo  #FORMVAT_200_A Select * from '+@MCON
		EXECUTE SP_EXECUTESQL @SQLCOMMAND
		---Drop Temp Table 
		SET @SQLCOMMAND='Drop Table '+@MCON
		EXECUTE SP_EXECUTESQL @SQLCOMMAND
		*/		
		-- bug-23933 - end here 
	End
-----
--SELECT * from #FORMVAT_200_A where (Date Between @Sdate and @Edate) and Bhent in('PT') AND S_tAX='' --and TAX_NAME In('','NO-TAX') and U_imporm = ''
-----

--Exempted or Non-Creditable Purchases  

SET @AMTA1=0
SET @AMTA2=0
SET @PER  =0

--SELECT @AMTA1=sum(GRO_AMT),@AMTA2=sum(TAXAMT)  FROM (SELECT DISTINCT GRO_AMT,TAXAMT FROM vattbl 
--WHERE ((ST_TYPE = 'LOCAL' AND TAX_NAME IN ('EXEMPTED')) OR (ST_TYPE = 'OUT OF STATE') OR (ST_TYPE = 'OUT OF COUNTRY')) AND BHENT in ('PT') AND (DATE BETWEEN @SDATE AND @EDATE)) B
-- Exclude 'VAT' and 'Special VAT' text in TAX_NAME field
SELECT @AMTA1=sum(GRO_AMT),@AMTA2=sum(TAXAMT)  FROM PTITEM where tax_name like '[^VS]%' AND (DATE BETWEEN @SDATE AND @EDATE) 
--WHERE (tax_name like'[^VS ]%') AND BHENT in ('PT') AND (DATE BETWEEN @SDATE AND @EDATE)) B
--WHERE TAX_NAME LIKE 'C.S.T.%' AND BHENT in ('PT') AND (DATE BETWEEN @SDATE AND @EDATE)) B
-- SELECT *  FROM #FORMVAT_200_A  WHERE TAX_NAME LIKE 'C.S.T.%' AND (DATE BETWEEN @SDATE AND @EDATE) 
--(st_type in ('OUT OF STATE' ) OR ( ST_TYPE in ('OUT OF STATE','OUT OF COUNTRY','LOCAL' ) AND TAX_NAME='EXEMPTED')  OR S_TAX='') 
SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
SET @AMTA2=CASE WHEN @AMTA2 IS NULL THEN 0 ELSE @AMTA2 END
INSERT INTO #FORMVAT_200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'1','A',@PER,@AMTA1-@AMTA2,0,0,'')  

---VAT 4% Purchases
SET @AMTA1=0
SET @AMTA2=0
SET @PER  =0

-- bug-23933 - start here
/*
SELECT DISTINCT @AMTA1=SUM(NET_AMT),@AMTA2=SUM(TAXAMT),@Per=Per FROM #FORMVAT_200_A 
WHERE (BHENT='PT') AND PER = 4 AND (DATE BETWEEN @SDATE AND @EDATE) and Tax_Name like '%VAT%' and s_tax<>'' Group by per
*/
SELECT DISTINCT @AMTA1=SUM(GRO_AMT),@AMTA2=SUM(TAXAMT),@Per=Per FROM vattbl
WHERE (BHENT In ('PT', 'EP', 'SR', 'CN')) AND ST_TYPE='LOCAL' AND PER = 4 AND (DATE BETWEEN @SDATE AND @EDATE) and Tax_Name like '%VAT%' and s_tax<>'' Group by per
-- bug-23933 - end here

SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
SET @AMTA2=CASE WHEN @AMTA2 IS NULL THEN 0 ELSE @AMTA2 END
INSERT INTO #FORMVAT_200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'1','B',@PER,@AMTA1-@AMTA2,@AMTA2,0,'')  

---VAT 5% Purchases
SET @AMTA1=0
SET @AMTA2=0
SET @PER  =0

-- bug-23933 - start here
/*
--SELECT DISTINCT @AMTA1=SUM(NET_AMT),@AMTA2=SUM(TAXAMT),@Per=Per FROM #FORMVAT_200_A 
--WHERE (BHENT='PT') AND PER = 5 AND (DATE BETWEEN @SDATE AND @EDATE) and Tax_Name like '%VAT%' and s_tax<>'' Group by per

-- As per Andhra Pradesh Govt.site, no column and raw found for tax % 5
SELECT DISTINCT @AMTA1=SUM(NET_AMT),@AMTA2=SUM(TAXAMT),@Per=Per FROM vattbl
WHERE (BHENT='PT') AND PER = 5 AND (DATE BETWEEN @SDATE AND @EDATE) and Tax_Name like '%VAT%' and s_tax<>'' Group by per

SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
SET @AMTA2=CASE WHEN @AMTA2 IS NULL THEN 0 ELSE @AMTA2 END
INSERT INTO #FORMVAT_200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'1','B5',@PER,@AMTA1-@AMTA2,@AMTA2,0,'')  

---VAT 14.5% Purchases
SET @AMTA1=0
SET @AMTA2=0
SET @PER=0

--SELECT DISTINCT @AMTA1=SUM(NET_AMT),@AMTA2=SUM(TAXAMT),@Per=Per FROM #FORMVAT_200_A 
--WHERE (BHENT='PT') AND PER = 14.5 AND (DATE BETWEEN @SDATE AND @EDATE) and Tax_Name like '%VAT%' and s_tax<>'' Group by per

-- As per Andhra Pradesh Govt.site, no column and raw found for tax % 14.5

SELECT DISTINCT @AMTA1=SUM(NET_AMT),@AMTA2=SUM(TAXAMT),@Per=Per FROM vattbl
WHERE (BHENT='PT') AND PER = 14.5 AND (DATE BETWEEN @SDATE AND @EDATE) and Tax_Name like '%VAT%' and s_tax<>'' Group by per

--SELECT * FROM #FORMVAT_200_A
SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
SET @AMTA2=CASE WHEN @AMTA2 IS NULL THEN 0 ELSE @AMTA2 END
SET @Per=CASE WHEN @Per IS NULL THEN 0 ELSE @Per END
INSERT INTO #FORMVAT_200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'1','C',@PER,@AMTA1-@AMTA2,@AMTA2,0,'')  
*/
-- bug-23933 - end here

---VAT 12.5% Purchases
SET @AMTA1=0
SET @AMTA2=0
SET @PER=0
-- bug-23933 - start here
/*
SELECT DISTINCT @AMTA1=SUM(NET_AMT),@AMTA2=SUM(TAXAMT),@Per=Per FROM #FORMVAT_200_A 
WHERE (BHENT='PT') AND PER = 12.5 AND (DATE BETWEEN @SDATE AND @EDATE) and Tax_Name like '%VAT%' and s_tax<>'' Group by per
*/
SELECT DISTINCT @AMTA1=SUM(GRO_AMT),@AMTA2=SUM(TAXAMT),@Per=Per FROM vattbl
WHERE (BHENT In ('PT', 'EP', 'SR', 'CN')) AND ST_TYPE='LOCAL' AND PER = 12.5 AND (DATE BETWEEN @SDATE AND @EDATE) and Tax_Name like '%VAT%' and s_tax<>'' Group by per
-- bug-23933 - end here

--SELECT * FROM #FORMVAT_200_A
SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
SET @AMTA2=CASE WHEN @AMTA2 IS NULL THEN 0 ELSE @AMTA2 END
SET @Per=CASE WHEN @Per IS NULL THEN 0 ELSE @Per END
INSERT INTO #FORMVAT_200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'1','C1',@PER,@AMTA1-@AMTA2,@AMTA2,0,'')  ---- Changes deone by sandeep for bug-1266 on 31/12/2011

---VAT 1% Purchases
SET @AMTA1=0
SET @AMTA2=0
SET @PER=0
-- bug-23933 - start here
/*
SELECT DISTINCT @AMTA1=SUM(NET_AMT),@AMTA2=SUM(TAXAMT),@Per=Per FROM #FORMVAT_200_A 
WHERE (BHENT='PT') AND PER = 1 AND (DATE BETWEEN @SDATE AND @EDATE) and Tax_Name like '%VAT%' and s_tax<>'' Group by per
*/
SELECT DISTINCT @AMTA1=SUM(GRO_AMT),@AMTA2=SUM(TAXAMT),@Per=Per FROM vattbl
WHERE (BHENT In ('PT', 'EP', 'SR', 'CN')) AND ST_TYPE='LOCAL' AND PER = 1 AND (DATE BETWEEN @SDATE AND @EDATE) and Tax_Name like '%VAT%' and s_tax<>'' Group by per
-- bug-23933 - end here

SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
SET @AMTA2=CASE WHEN @AMTA2 IS NULL THEN 0 ELSE @AMTA2 END
SET @Per=CASE WHEN @Per IS NULL THEN 0 ELSE @Per END
INSERT INTO #FORMVAT_200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'1','D',@PER,@AMTA1-@AMTA2,@AMTA2,0,'')  

declare @S_tax as varchar(15)

---Special Rates of VAT Purchases
SET @AMTA1=0
SET @AMTA2=0
SET @PER=0
--Set @S_tax = ''
--SELECT @AMTA1=SUM(NET_AMT),@AMTA2=SUM(TAXAMT),@Per=Per FROM #FORMVAT_200_A WHERE (BHENT='PT') AND (PER = 0 And TaxAmt <> 0)  AND (DATE BETWEEN @SDATE AND @EDATE) AND TAX_NAME <> 'Exempted' Group by per
--SELECT @AMTA1=SUM(NET_AMT),@AMTA2=SUM(TAXAMT),@per = per,@S_Tax = Tax_Name FROM #FORMVAT_200_A WHERE (BHENT='PT') and (TaxAmt <> 0 and per = 0) AND (DATE BETWEEN @SDATE AND @EDATE) and Tax_Name like '%VAT%' Group by per, Tax_name

-- bug-23933 - start here
/*
SELECT @AMTA1=SUM(NET_AMT),@AMTA2=SUM(TAXAMT),@per = per FROM #FORMVAT_200_A 
WHERE (BHENT='PT') AND ST_TYPE='LOCAL' AND TAX_NAME LIKE '%SPECIAL%' AND (DATE BETWEEN @SDATE AND @EDATE)and s_tax<>''  Group by per, Tax_name

SELECT @AMTA1=SUM(NET_AMT),@AMTA2=SUM(TAXAMT),@Per=Per FROM vattbl
*/
SELECT @AMTA1=SUM(GRO_AMT),@AMTA2=SUM(TAXAMT),@Per=Per FROM vattbl
WHERE (BHENT In ('PT', 'EP', 'SR', 'CN')) AND ST_TYPE='LOCAL' AND TAX_NAME LIKE '%SPECIAL%' AND (DATE BETWEEN @SDATE AND @EDATE) and s_tax<>'' Group by per, Tax_name
-- bug-23933 - end here

SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
SET @AMTA2=CASE WHEN @AMTA2 IS NULL THEN 0 ELSE @AMTA2 END
SET @Per=CASE WHEN @Per IS NULL THEN 0 ELSE @Per END
INSERT INTO #FORMVAT_200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,S_tax,Party_nm) VALUES  (1,'1','Y',@PER,@AMTA1-@AMTA2,0,0,@S_tax,'')  

---Total of Tax Amount B,C,D of Purchases
SET @AMTA1=0
SET @AMTA2=0
SET @AMTA3=0
SET @PER=0
--SELECT @AMTA1=SUM(AMT1),@AMTA2=SUM(AMT2) FROM #FORMVAT_200 WHERE PARTSR = '1' and SRNO <> 'A'
--SELECT @AMTA1=SUM(AMT1),@AMTA2=SUM(AMT2) FROM #FORMVAT_200 WHERE PARTSR = '1' and SRNO in ( 'A','B','B5','C','D')


SELECT @AMTA1=SUM(AMT1),@AMTA2=SUM(AMT2) FROM #FORMVAT_200 WHERE SRNO in ( 'B','C1','D')

SELECT @AMTA3=SUM(AMT1) FROM #FORMVAT_200 WHERE PARTSR = '0' -- and SRNO in ( 'A','B','B5','C','D')


SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
SET @AMTA2=CASE WHEN @AMTA2 IS NULL THEN 0 ELSE @AMTA2 END
SET @AMTA3=CASE WHEN @AMTA3 IS NULL THEN 0 ELSE @AMTA3 END

INSERT INTO #FORMVAT_200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'1','Z',@PER,0,@AMTA2+@AMTA3,0,'') 


--Sales Details Total Exempted Sales
SET @AMTA1=0
SET @AMTA2=0
SET @AMTA3=0
SET @PER=0

-- bug-23933 - start here
/*
SELECT @AMTA1=SUM(NET_AMT),@AMTA2=SUM(TAXAMT) FROM #FORMVAT_200_A WHERE (BHENT='ST') and Per = 0 
AND (DATE BETWEEN @SDATE AND @EDATE) and tax_name = 'Exempted'
*/
SELECT @AMTA1=SUM(GRO_AMT),@AMTA2=SUM(TAXAMT) FROM vattbl WHERE (BHENT IN ('ST')) and Per = 0
AND (DATE BETWEEN @SDATE AND @EDATE) and tax_name = 'EXEMPTED'
-- bug-23933 - end here

SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
SET @AMTA2=CASE WHEN @AMTA2 IS NULL THEN 0 ELSE @AMTA2 END
INSERT INTO #FORMVAT_200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'2','A',0,@AMTA1,0,0,'')  


---International sales with 0 percent sale
---Export Sales
SET @AMTA1=0
SET @AMTA2=0
SET @PER=0

-- bug-23933 - start here
/*
SELECT @AMTA1=SUM(NET_AMT),@AMTA2=SUM(TAXAMT) FROM #FORMVAT_200_A WHERE (DATE BETWEEN @SDATE AND @EDATE) and St_type = 'Out of Country' and BHENT = 'ST'
*/
SELECT @AMTA1=SUM(GRO_AMT),@AMTA2=SUM(TAXAMT) FROM vattbl WHERE (DATE BETWEEN @SDATE AND @EDATE) and St_type = 'Out of Country' and (BHENT IN ('ST')) and Per = 0
-- bug-23933 - end here

SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
SET @AMTA2=CASE WHEN @AMTA2 IS NULL THEN 0 ELSE @AMTA2 END
--INSERT INTO #FORMVAT_200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'2','B',@PER,@AMTA1-@AMTA2,@AMTA2,0,'')  
INSERT INTO #FORMVAT_200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'2','B',@PER,@AMTA1-@AMTA2,0,0,'')  


---Inter States/CST Sales with 0 percent sale
SET @AMTA1=0
SET @AMTA2=0
SET @PER=0

-- bug-23933 - start here
/*
SELECT @AMTA1=SUM(VATONAMT),@AMTA2=SUM(TAXAMT) FROM #FORMVAT_200_A  WHERE ST_TYPE='OUT OF STATE' AND BHENT='ST'--(st_type = 'Out of State') AND BHENT='ST' AND TAXAMT=0 AND (DATE BETWEEN @SDATE AND @EDATE)
*/
SELECT @AMTA1=SUM(GRO_AMT),@AMTA2=SUM(TAXAMT) FROM vattbl  WHERE ST_TYPE='OUT OF STATE' AND (BHENT IN ('ST')) and Per = 0  --(st_type = 'Out of State') AND BHENT='ST' AND TAXAMT=0 AND (DATE BETWEEN @SDATE AND @EDATE)
-- bug-23933 - end here


--SELECT * FROM #FORMVAT_200_A  WHERE ST_TYPE='OUT OF STATE' AND BHENT='ST'
SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
SET @AMTA2=CASE WHEN @AMTA2 IS NULL THEN 0 ELSE @AMTA2 END
INSERT INTO #FORMVAT_200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'2','C',@PER,@AMTA1-@AMTA2,@AMTA2,0,'')  


---Tax Due on Purchases
SET @AMTA1=0
SET @AMTA2=0
SET @PER=0

-- bug-23933 - start here
/*
SELECT @AMTA1=SUM(VATONAMT),@per = per FROM (select distinct tran_cd,bhent,VATONAMT,dbname,PER  FROM #FORMVAT_200_A WHERE (BHENT='PT') AND S_TAX=''AND TAXAMT<>0 AND (DATE BETWEEN @SDATE AND @EDATE))B GROUP BY B.PER
SELECT @AMTA2=SUM(TAXAMT),@per = per FROM (select distinct tran_cd,bhent,TAXAMT,dbname,PER  FROM #FORMVAT_200_A WHERE (BHENT='PT') AND S_TAX=''AND TAXAMT<>0 AND (DATE BETWEEN @SDATE AND @EDATE))B GROUP BY B.PER
*/
SELECT @AMTA1=SUM(GRO_AMT),@per = per FROM (select distinct tran_cd,bhent,GRO_AMT,dbname,PER  FROM vattbl WHERE (BHENT='PT') AND S_TAX=''AND TAXAMT<>0 AND (DATE BETWEEN @SDATE AND @EDATE))B GROUP BY B.PER
SELECT @AMTA2=SUM(TAXAMT),@per = per FROM (select distinct tran_cd,bhent,TAXAMT,dbname,PER  FROM vattbl WHERE (BHENT='PT') AND S_TAX=''AND TAXAMT<>0 AND (DATE BETWEEN @SDATE AND @EDATE))B GROUP BY B.PER
-- bug-23933 - end here


SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
SET @AMTA2=CASE WHEN @AMTA2 IS NULL THEN 0 ELSE @AMTA2 END
INSERT INTO #FORMVAT_200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'2','D',0,@AMTA1,@AMTA2,0,'')  



---Local 4% VAT Sales
SET @AMTA1=0
SET @AMTA2=0
SET @PER=0
-- bug-23933 - start here
/*
SELECT @AMTA1=SUM(NET_AMT),@AMTA2=SUM(TAXAMT),@per = per FROM #FORMVAT_200_A WHERE (BHENT='ST') and Tax_name like '%VAT%' and Per = 4 AND (DATE BETWEEN @SDATE AND @EDATE) group by Per
*/
SELECT @AMTA1=SUM(GRO_AMT),@AMTA2=SUM(TAXAMT),@per = per FROM vattbl WHERE (BHENT IN ('ST','PR', 'DN'))  AND ST_TYPE='LOCAL' and Tax_name like '%VAT%' and Per = 4 AND (DATE BETWEEN @SDATE AND @EDATE) group by Per
-- bug-23933 - end here

SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
SET @AMTA2=CASE WHEN @AMTA2 IS NULL THEN 0 ELSE @AMTA2 END
INSERT INTO #FORMVAT_200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'2','E',@PER,@AMTA1-@AMTA2,@AMTA2,0,'')  

/*
-- As per Andhra Pradesh Govt. site no provision for 5%, 14.5% taxrate

---Local 5% VAT Sales
SET @AMTA1=0
SET @AMTA2=0
SET @PER=0

--SELECT @AMTA1=SUM(NET_AMT),@AMTA2=SUM(TAXAMT),@per = per FROM #FORMVAT_200_A WHERE (BHENT='ST') and Tax_name like '%VAT%' and Per = 5 AND (DATE BETWEEN @SDATE AND @EDATE) group by Per

SELECT @AMTA1=SUM(GRO_AMT),@AMTA2=SUM(TAXAMT),@per = per FROM vattbl WHERE (BHENT='ST') and Tax_name like '%VAT%' and Per = 5 AND (DATE BETWEEN @SDATE AND @EDATE) group by Per
-- bug-23933 - end here

SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
SET @AMTA2=CASE WHEN @AMTA2 IS NULL THEN 0 ELSE @AMTA2 END
INSERT INTO #FORMVAT_200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'2','E5',@PER,@AMTA1-@AMTA2,@AMTA2,0,'')  

---Lcoal 14.5% VAT Sales
SET @AMTA1=0
SET @AMTA2=0
SET @PER=0

--SELECT @AMTA1=SUM(NET_AMT),@AMTA2=SUM(TAXAMT),@per = per FROM #FORMVAT_200_A WHERE (BHENT='ST') and Tax_name like '%VAT%' and Per = 14.50 AND (DATE BETWEEN @SDATE AND @EDATE) group by Per

SELECT @AMTA1=SUM(GRO_AMT),@AMTA2=SUM(TAXAMT),@per = per FROM vattbl WHERE (BHENT='ST') and Tax_name like '%VAT%' and Per = 14.50 AND (DATE BETWEEN @SDATE AND @EDATE) group by Per

SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
SET @AMTA2=CASE WHEN @AMTA2 IS NULL THEN 0 ELSE @AMTA2 END
INSERT INTO #FORMVAT_200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'2','F',@PER,@AMTA1-@AMTA2,@AMTA2,0,'')  
*/
--bug-23933 - end here


---Lcoal 12.5% VAT Sales
SET @AMTA1=0
SET @AMTA2=0
SET @PER=0

--bug-23933 - start here
/*
SELECT @AMTA1=SUM(NET_AMT),@AMTA2=SUM(TAXAMT),@per = per FROM #FORMVAT_200_A WHERE (BHENT='ST') and Tax_name like '%VAT%' and Per = 12.50 AND (DATE BETWEEN @SDATE AND @EDATE) group by Per
*/
SELECT @AMTA1=SUM(GRO_AMT),@AMTA2=SUM(TAXAMT),@per = per FROM vattbl WHERE (BHENT IN ('ST','PR', 'DN'))  AND ST_TYPE='LOCAL' and Tax_name like '%VAT%' and Per = 12.50 AND (DATE BETWEEN @SDATE AND @EDATE) group by Per
--bug-23933 - end here

SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
SET @AMTA2=CASE WHEN @AMTA2 IS NULL THEN 0 ELSE @AMTA2 END
INSERT INTO #FORMVAT_200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'2','F12',@PER,@AMTA1-@AMTA2,@AMTA2,0,'')  


---Local Special Rate VAT Sales
SET @AMTA1=0
SET @AMTA2=0
SET @PER=0
--Set @S_Tax = ''
--SELECT @AMTA1=SUM(NET_AMT),@AMTA2=SUM(TAXAMT),@per = per,@S_tax=Tax_Name FROM #FORMVAT_200_A WHERE (BHENT='ST') and Tax_name like '%VAT%' and (TaxAmt <> 0 and per = 0) AND (DATE BETWEEN @SDATE AND @EDATE) group by Per, Tax_Name

--bug-23933 - start here
/*
SELECT @AMTA1=SUM(NET_AMT),@AMTA2=SUM(TAXAMT),@per = per FROM #FORMVAT_200_A WHERE (BHENT='ST') and Tax_name like '%SPECIAL%' AND ST_TYPE='LOCAL'  AND (DATE BETWEEN @SDATE AND @EDATE) group by Per, Tax_Name,ST_TYPE
*/
SELECT @AMTA1=SUM(GRO_AMT),@AMTA2=SUM(TAXAMT),@per = per FROM vattbl WHERE (BHENT IN ('ST','PR', 'DN'))  AND ST_TYPE='LOCAL' and Tax_name like '%SPECIAL%' AND ST_TYPE='LOCAL'  AND (DATE BETWEEN @SDATE AND @EDATE) group by Per, Tax_Name,ST_TYPE
--bug-23933 - end here

SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
SET @AMTA2=CASE WHEN @AMTA2 IS NULL THEN 0 ELSE @AMTA2 END
--INSERT INTO #FORMVAT_200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,S_tax,Party_nm) VALUES  (1,'2','G',@PER,@AMTA1-@AMTA2,@AMTA2,0,@S_Tax,'')  

-- As per govt. site format don't show and also not include in total this special rate amount and tax
INSERT INTO #FORMVAT_200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,S_tax,Party_nm) VALUES  (1,'2','G',@PER,0,0,0,@S_Tax,'')  


---Local 1% VAT Sales
SET @AMTA1=0
SET @AMTA2=0
SET @PER=0

--bug-23933 - start here
/*
SELECT @AMTA1=SUM(NET_AMT),@AMTA2=SUM(TAXAMT),@per = per FROM #FORMVAT_200_A WHERE (BHENT='ST') and Per = 1 and Tax_name like '%VAT%' AND (DATE BETWEEN @SDATE AND @EDATE) group by Per
*/
SELECT @AMTA1=SUM(GRO_AMT),@AMTA2=SUM(TAXAMT),@per = per FROM vattbl WHERE (BHENT IN ('ST','PR', 'DN'))  AND ST_TYPE='LOCAL' and Per = 1  and Tax_name like '%VAT%' AND (DATE BETWEEN @SDATE AND @EDATE) group by Per
--bug-23933 - end here

SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
SET @AMTA2=CASE WHEN @AMTA2 IS NULL THEN 0 ELSE @AMTA2 END
INSERT INTO #FORMVAT_200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'2','H',@PER,@AMTA1-@AMTA2,@AMTA2,0,'')  


---Total Tax Amount D,E,F12,H Sales

SET @AMTA1=0
SET @AMTA2=0
SET @PER=0
--SELECT @AMTA1=SUM(AMT1),@AMTA2=SUM(AMT2) FROM #FORMVAT_200 WHERE PARTSR = '2' and SRNO not In ('A','B','C')
--SELECT @AMTA1=SUM(AMT1),@AMTA2=SUM(AMT2) FROM #FORMVAT_200 WHERE PARTSR = '2' and SRNO In ('D','E','E5','F', 'F12', 'G','H')

SELECT @AMTA1=SUM(AMT1),@AMTA2=SUM(AMT2) FROM #FORMVAT_200 WHERE PARTSR = '2' and SRNO In ('D','E','F12','H')
SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
SET @AMTA2=CASE WHEN @AMTA2 IS NULL THEN 0 ELSE @AMTA2 END
INSERT INTO #FORMVAT_200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'2','Z',@PER,0,@AMTA2,0,'')  


----

INSERT INTO #FORMVAT_200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'22','A',0,0,0,0,'')  

---VAT Payable From Bank Payment Details
Declare @TAXONAMT as numeric(12,2),@TAXAMT1 as numeric(12,2),@ITEMAMT as numeric(12,2),@INV_NO as varchar(10),
	    @DATE as smalldatetime,@PARTY_NM as varchar(50),@ADDRESS as varchar(100),
		@FORM_NM as varchar(30) ---,@S_TAX as varchar(30)


SELECT @TAXONAMT=0,@TAXAMT =0,@ITEMAMT =0,@INV_NO ='',@DATE ='',@PARTY_NM ='',@ADDRESS ='',@FORM_NM='',@S_TAX =''

SET @CHAR=66

SET @PER = 0

declare Cur_VatPay cursor  for
Select A.vatonamt,A.taxamt,A.Gro_amt,A.inv_no,A.Date,B.Bank_nm,Address=B.U_BSRCODE,A.Form_nm,A.S_tax
--bug-23933 - start here
/*
From #formvat_200_A A
*/
From vattbl A
--bug-23933 - end here
Inner Join Bpmain B On(A.Bhent = B.Entry_Ty And A.Tran_cd = B.Tran_cd)
Where A.BHENT = 'BP' And (B.Date Between @sdate and @edate) And B.Party_nm = 'VAT PAYABLE'

Declare @Bank_Pymt NUMERIC(12,2)

set @Bank_Pymt =0

open Cur_VatPay
FETCH NEXT FROM Cur_VatPay INTO @TAXONAMT,@TAXAMT,@ITEMAMT,@INV_NO,@DATE,@PARTY_NM,@ADDRESS,@FORM_NM,@S_TAX
 WHILE (@@FETCH_STATUS=0)
 BEGIN

	SET @Per=CASE WHEN @Per IS NULL THEN 0 ELSE @Per END
	SET @TAXONAMT=CASE WHEN @TAXONAMT IS NULL THEN 0 ELSE @TAXONAMT END
	SET @TAXAMT=CASE WHEN @TAXAMT IS NULL THEN 0 ELSE @TAXAMT END
	SET @ITEMAMT=CASE WHEN @ITEMAMT IS NULL THEN 0 ELSE @ITEMAMT END
	SET @PARTY_NM=CASE WHEN @PARTY_NM IS NULL THEN '' ELSE @PARTY_NM END
	SET @INV_NO=CASE WHEN @INV_NO IS NULL THEN '' ELSE @INV_NO END
	SET @DATE=CASE WHEN @DATE IS NULL THEN '' ELSE @DATE END
	SET @ADDRESS=CASE WHEN @ADDRESS IS NULL THEN '' ELSE @ADDRESS END
	SET @S_TAX=CASE WHEN @S_TAX IS NULL THEN '' ELSE @S_TAX END
	SET @FORM_NM=CASE WHEN @FORM_NM IS NULL THEN '' ELSE @FORM_NM END
	
	set @Bank_Pymt = @Bank_Pymt + @TAXONAMT
	
	INSERT INTO #FORMVAT_200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,INV_NO,DATE,PARTY_NM,ADDRESS,FORM_NM,S_TAX)
 VALUES (1,'22',CHAR(@CHAR),@PER,@TAXONAMT,@TAXAMT,@ITEMAMT,@INV_NO,@DATE,@PARTY_NM,@ADDRESS,@FORM_NM,@S_TAX)

 SET @CHAR=@CHAR+1
 FETCH NEXT FROM CUR_VatPay INTO @TAXONAMT,@TAXAMT,@ITEMAMT,@INV_NO,@DATE,@PARTY_NM,@ADDRESS,@FORM_NM,@S_TAX
END
CLOSE CUR_VatPay
DEALLOCATE CUR_VatPay

----

--INSERT INTO #FORMVAT_200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'22','Z',0,0,0,0,'')  
--INSERT INTO #FORMVAT_200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'22','C',0,0,0,0,'')  


----23 Refund

--select distinct A.tran_cd,A.bhent,C.NET_AMT,dbname  FROM #FORMVAT_200_A A
-- INNER JOIN JVMAIN C ON A.TRAN_cD=C.TRAN_cD WHERE A.BHENT IN ('JV','J4') 
--AND C.VAT_ADJ='Refund Claim' AND (A.DATE BETWEEN @SDATE AND @EDATE)

SET @AMTA1=0
SET @AMTA2=0
SET @PER=0

--bug-23933 - start here
/*
SELECT @AMTA1=SUM(NET_AMT) FROM (select distinct A.tran_cd,A.bhent,C.NET_AMT,dbname  FROM #FORMVAT_200_A A
 INNER JOIN JVMAIN C ON A.TRAN_cD=C.TRAN_cD WHERE A.BHENT IN ('JV','J4') 
AND C.VAT_ADJ='Refund Claim' AND (A.DATE BETWEEN @SDATE AND @EDATE))B 
*/
SELECT @AMTA1=SUM(NET_AMT) FROM (select distinct A.tran_cd,A.bhent,C.NET_AMT,dbname  FROM vattbl A
 INNER JOIN JVMAIN C ON A.TRAN_cD=C.TRAN_cD WHERE A.BHENT IN ('JV','J4') 
AND C.VAT_ADJ='Refund Claim' AND (A.DATE BETWEEN @SDATE AND @EDATE))B 
--bug-23933 - end here

SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
SET @AMTA2=CASE WHEN @AMTA2 IS NULL THEN 0 ELSE @AMTA2 END


INSERT INTO #FORMVAT_200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'23','A',0,@AMTA1,0,0,'')  

--24(b) Net credit carried forward
SET @AMTA1=0
SET @AMTA2=0
SET @AMTA3=0
SET @PER=0

--bug-23933 - start here
/*
SELECT @AMTA1=SUM(NET_AMT) FROM (select distinct A.tran_cd,A.bhent,C.NET_AMT,dbname  FROM #FORMVAT_200_A A 
INNER JOIN JVMAIN C ON A.TRAN_cD=C.TRAN_cD WHERE A.BHENT IN ('JV','J4') AND C.VAT_ADJ='VAT' 
AND (A.DATE BETWEEN @SDATE AND @EDATE))B 
*/
SELECT @AMTA1=SUM(NET_AMT) FROM (select distinct A.tran_cd,A.bhent,C.NET_AMT,dbname  FROM vattbl A 
INNER JOIN JVMAIN C ON A.TRAN_cD=C.TRAN_cD WHERE A.BHENT IN ('JV','J4') AND C.VAT_ADJ='VAT' 
AND (A.DATE BETWEEN @SDATE AND @EDATE))B 
--bug-23933 - end here

SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
SET @AMTA2=CASE WHEN @AMTA2 IS NULL THEN 0 ELSE @AMTA2 END
	INSERT INTO #FORMVAT_200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'23','C',@PER,@AMTA1,@AMTA2,@AMTA3,'')  
--INSERT INTO #FORMVAT_200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'23','C',0,@AMTA1,0,0,'')  

--24 Credit Carried Forward
--SET @AMTA1=0
--SET @AMTA2=0
--SET @AMTA3=0
--SET @PER=0
--SELECT @AMTA1=SUM(AMT1) FROM #FORMVAT_200 WHERE PARTSR IN ( '23') and SRNO In ('B')
--SELECT @AMTA2=SUM(AMT1) FROM #FORMVAT_200 WHERE PARTSR IN ( '23') and SRNO In ('C')
--SELECT @PER=SUM(AMT1) FROM #FORMVAT_200 WHERE PARTSR IN ( '23') and SRNO In ('A')
--SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
--SET @AMTA2=CASE WHEN @AMTA2 IS NULL THEN 0 ELSE @AMTA2 END
--SET @PER=CASE WHEN @PER IS NULL THEN 0 ELSE @PER END
--SET @AMTA3=@AMTA1+@AMTA2
--INSERT INTO #FORMVAT_200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'23','Z',@PER,@AMTA1,@AMTA2,@AMTA3,'')  

SET @AMTA1=0
SET @AMTA2=0
SET @PER=0
--bug-23933 - start here
/*
SELECT @AMTA1=SUM(NET_AMT) FROM (select distinct A.tran_cd,A.bhent,C.NET_AMT,dbname  FROM #FORMVAT_200_A A 
INNER JOIN JVMAIN C ON A.TRAN_cD=C.TRAN_cD WHERE A.BHENT IN ('JV','J4') AND C.VAT_ADJ='CST' 
AND (A.DATE BETWEEN @SDATE AND @EDATE))B 
*/
SELECT @AMTA1=SUM(NET_AMT) FROM (select distinct A.tran_cd,A.bhent,C.NET_AMT,dbname  FROM vattbl A 
INNER JOIN JVMAIN C ON A.TRAN_cD=C.TRAN_cD WHERE A.BHENT IN ('JV','J4') AND C.VAT_ADJ='CST' 
AND (A.DATE BETWEEN @SDATE AND @EDATE))B 
--bug-23933 - end here

SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
SET @AMTA2=CASE WHEN @AMTA2 IS NULL THEN 0 ELSE @AMTA2 END
INSERT INTO #FORMVAT_200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'23','Z',0,@AMTA1,0,0,'')  

--24(a) If you want to adjust the excess amount against the liability under the CST Act please fill in the boxes 24(a) and 24(b). Tax due under the CST Act and adjusted against the excess amount in box 24
--SET @AMTA1=0
--SET @AMTA2=0
--SET @PER=0
--SELECT @AMTA1=SUM(NET_AMT) FROM (select distinct A.tran_cd,A.bhent,C.NET_AMT,dbname  FROM #FORMVAT_200_A A INNER JOIN JVMAIN C ON A.TRAN_cD=C.TRAN_cD WHERE (A.BHENT='J4') AND C.VAT_ADJ='CST' AND (A.DATE BETWEEN @SDATE AND @EDATE))B 
--SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
--SET @AMTA2=CASE WHEN @AMTA2 IS NULL THEN 0 ELSE @AMTA2 END
--
--INSERT INTO #FORMVAT_200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'23','B',0,@AMTA1,0,0,'')  

SET @AMTA1=0
SET @AMTA2=0
SET @AMTA3=0
SET @PER=0

SELECT @AMTA1=SUM(AMT1) FROM #FORMVAT_200 WHERE PARTSR IN ( '23') and SRNO In ('C')
SELECT @AMTA2=SUM(AMT1) FROM #FORMVAT_200 WHERE PARTSR IN ( '23') and SRNO In ('Z')
SELECT @PER=SUM(AMT1) FROM #FORMVAT_200 WHERE PARTSR IN ( '23') and SRNO In ('A')

SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
SET @AMTA2=CASE WHEN @AMTA2 IS NULL THEN 0 ELSE @AMTA2 END
SET @PER=CASE WHEN @PER IS NULL THEN 0 ELSE @PER END
SET @AMTA3=@AMTA1-@AMTA2
INSERT INTO #FORMVAT_200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) 
VALUES  (1,'23','B',0,@AMTA3,0,0,'')  

SET @AMTA1=0
SET @AMTA2=0
SET @AMTA3=0

Declare @AMTP NUMERIC(12,2), @AMTS NUMERIC(12,2), @AMTNET NUMERIC(12,2)
SET @AMTP =0
SET @AMTS = 0
SET @AMTnet = 0 

SELECT @PER=SUM(AMT1) FROM #FORMVAT_200 WHERE PARTSR IN ( '23') and SRNO In ('A')
--SELECT @AMTA1=SUM(AMT1) FROM #FORMVAT_200 WHERE PARTSR IN ( '23') and SRNO In ('C') 
SELECT @AMTA2=SUM(AMT1) FROM #FORMVAT_200 WHERE PARTSR IN ( '23') and SRNO In ('Z')
--SELECT @AMTA3=SUM(AMT1) FROM #FORMVAT_200 WHERE PARTSR IN ( '23') and SRNO In ('B')

SELECT @AMTA3=SUM(AMT1) FROM #FORMVAT_200 WHERE PARTSR IN ( '2') and SRNO In ('B')
SELECT @AMTP=SUM(AMT2) FROM #FORMVAT_200 WHERE PARTSR IN ( '1') and SRNO In ('Z')
SELECT @AMTS=SUM(AMT2) FROM #FORMVAT_200 WHERE PARTSR IN ( '2') and SRNO In ('Z')

SET @PER=CASE WHEN @PER IS NULL THEN 0 ELSE @PER END -- Refund Claim
SET @AMTA2=CASE WHEN @AMTA2 IS NULL THEN 0 ELSE @AMTA2 END -- CST Adjustment
SET @AMTA3=CASE WHEN @AMTA3 IS NULL THEN 0 ELSE @AMTA3 END -- Export sale with 0 percent 
SET @AMTP=CASE WHEN @AMTP IS NULL THEN 0 ELSE @AMTP END -- Total Purchase
SET @AMTS=CASE WHEN @AMTS IS NULL THEN 0 ELSE @AMTS END -- Total Sales
SET @Bank_Pymt=CASE WHEN @Bank_Pymt IS NULL THEN 0 ELSE @Bank_Pymt END -- Bank Vat Payment


IF @AMTA3 >= 0 And @AMTA2 = 0 -- If Export sales is there and no CST Adjustment
	IF @AMTP > @AMTS -- If Purchase tax credit exceeds sales tax payable
		    SET @AMTA1 = (@AMTP - @AMTS)
		    
	-- If Sales Tax Payable exceeds Purchase Tax Credit and Paid more through bank then its difference   
	ELSE IF ((@AMTS - @AMTP) >= 0) And ((@Bank_Pymt) > (@AMTS - @AMTP))
		    SET @AMTA1 = ((@Bank_Pymt) - (@AMTS - @AMTP))

SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END -- Credit Carry Forward
    
IF @Per > 0 And @AMTA1 > 0
   IF @AMTA1 >= @PER
      SET @AMTA1 = (@AMTA1 - @PER)
   ELSE
      SET @AMTA1 = 0

INSERT INTO #FORMVAT_200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) 
--VALUES  (1,'23A','A',@PER,@AMTA1,@AMTA2,@AMTA3,'')  
VALUES  (1,'23A','A',@AMTA1,@PER,@AMTA2,@AMTA3,'')  

/*
--VALUES  (1,'23A','A',0,0,0,0,'')  

-->Added by  sandeep on 06/03/2011 for bug-1682--Start
---5.
SET @AMTA1=0
SET @AMTA2=0
SET @AMTA3=0


SET @AMTA1=0
SET @AMTA2=0
SET @AMTA3=0
SET @PER=0

--bug-23933 - start here

SELECT @AMTA3=SUM(NET_AMT) FROM (select distinct A.tran_cd,A.bhent,C.NET_AMT,dbname  FROM vattbl A 
INNER JOIN JVMAIN C ON A.TRAN_cD=C.TRAN_cD WHERE A.BHENT IN ('JV','J4') AND C.VAT_ADJ='VAT' 
--AND (A.DATE BETWEEN @SDATE AND @EDATE) 
and a.date< @SDATE )B 
--bug-23933 - end here

SELECT @AMTA2=SUM(AMT2) FROM #FORMVAT_200 WHERE PARTSR = '1' and SRNO not in ( 'Z') --added for the bug-4832 by sandeep on 29-jun-12

SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
SET @AMTA2=CASE WHEN @AMTA2 IS NULL THEN 0 ELSE @AMTA2 END
SET @AMTA3=CASE WHEN @AMTA3 IS NULL THEN 0 ELSE @AMTA3 END
SET @AMTA1=@AMTA3+@AMTA2
--SET @AMTA3=@AMTA1-@AMTA2 
--INSERT INTO #FORMVAT_200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'11','A',0,0,0,@AMTA3,'')  
Update #FORMVAT_200 Set AMT3 = @AMTA3 where Partsr = '1' and Srno = 'A'
Update #FORMVAT_200 Set AMT3 =@AMTA3 where Partsr = '1' and Srno = 'Z'
 Update #FORMVAT_200 Set AMT2 =@AMTA1 where Partsr = '1' and Srno = 'Z'
--Update #FORMVAT_200 Set AMT2 =@AMTA2+AMT3 where Partsr = '1' and Srno = 'Z'
--<added by  sandeep on 06/03/2011 for bug-1682--End 

INSERT INTO #FORMVAT_200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'22','AB',0,0,0,0,'')  
INSERT INTO #FORMVAT_200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'22','AC',0,0,0,0,'')  

INSERT INTO #FORMVAT_200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'22A','A',0,0,0,0,'')  
INSERT INTO #FORMVAT_200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'22A','B',0,0,0,0,'')  
INSERT INTO #FORMVAT_200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'22A','C',0,0,0,0,'')  
*/

---Updating Null Values with spaces or Zeros
Update #FORMVAT_200 set  PART = isnull(Part,0) , Partsr = isnull(PARTSR,''), SRNO = isnull(SRNO,''),
		             RATE = isnull(RATE,0), AMT1 = isnull(AMT1,0), AMT2 = isnull(AMT2,0), 
					 AMT3 = isnull(AMT3,0), INV_NO = isnull(INV_NO,''), DATE = isnull(Date,''), 
					 PARTY_NM = isnull(Party_nm,''), ADDRESS = isnull(Address,''), 
					 FORM_NM = isnull(form_nm,''), S_TAX = isnull(S_tax,'')

SELECT * FROM #FORMVAT_200 order by cast(substring(partsr,1,case when (isnumeric(substring(partsr,1,2))=1) then 2 else 1 end) as int)  

 
END  
--Print 'AP VAT FORM 200'
