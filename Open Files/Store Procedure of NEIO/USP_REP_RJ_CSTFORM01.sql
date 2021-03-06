IF EXISTS(SELECT XTYPE,NAME FROM SYSOBJECTS WHERE XTYPE='P' AND name='USP_REP_RJ_CSTFORM01')
BEGIN
	DROP PROCEDURE USP_REP_RJ_CSTFORM01
END
/****** Object:  StoredProcedure [dbo].[USP_REP_RJ_CSTFORM01]    Script Date: 03/17/2015 12:14:02 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
 CREATE PROCEDURE [dbo].[USP_REP_RJ_CSTFORM01]
 @TMPAC NVARCHAR(50),@TMPIT NVARCHAR(50),@SPLCOND VARCHAR(8000),@SDATE  SMALLDATETIME,@EDATE SMALLDATETIME
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
 DECLARE @RATE NUMERIC(12,2),@AMTA1 NUMERIC(12,2),@AMTA2 NUMERIC(12,2),@AMTB1 NUMERIC(12,2),@AMTC1 NUMERIC(12,2),@AMTD1 NUMERIC(12,2),@AMTE1 NUMERIC(12,2),@AMTE2 NUMERIC(12,2),@AMTF1 NUMERIC(12,2),@AMTG1 NUMERIC(12,2),@AMTH1 NUMERIC(12,2),@AMTI1 NUMERIC(12,2),@AMTJ1 NUMERIC(12,2),@AMTK1 NUMERIC(12,2),@AMTL1 NUMERIC(12,2),@AMTM1 NUMERIC(12,2),@AMTN1 NUMERIC(12,2),@AMTO1 NUMERIC(12,2) ,@AMTK11 NUMERIC(12,2),@char varchar(50),@PER  NUMERIC(12,2)
 DECLARE @AMTSL_OUT NUMERIC(18,2),@AMTSL_LOC NUMERIC(18,2),@BALANCE5 NUMERIC(18,2),@BALAMT62A  NUMERIC(18,2) ,@BALAMT62B  NUMERIC(18,2),@LSTTHREEMTHDATE DATETIME ,@BALAMT  NUMERIC(18,2),@INVNO VARCHAR(250),@CHLN_NO VARCHAR(250),@CHLN_DATE DATETIME ,@AMTB2 NUMERIC(12,2),@AMTc2 NUMERIC(12,2),@AMTd2 NUMERIC(12,2),@Bank_nm varchar(250)
 SET @AMTK11 = 0

Declare @NetEff as numeric (12,2), @NetTax as numeric (12,2)
---Temporary Cursor2
SELECT PART=3,PARTSR='AAA',SRNO='AAA',RATE=99.999,AMT1=NET_AMT,AMT2=M.TAXAMT,AMT3=M.TAXAMT,
M.INV_NO,M.DATE,PARTY_NM=AC1.AC_NAME,ADDRESS=Ltrim(AC1.Add1)+' '+Ltrim(AC1.Add2)+' '+Ltrim(AC1.Add3),STM.FORM_NM,AC1.S_TAX
INTO #FORM221
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
		 EXECUTE USP_REP_MULTI_CO_DATA
		  @TMPAC, @TMPIT, @SPLCOND, @SDATE, @EDATE
		 ,@SAC, @EAC, @SIT, @EIT, @SAMT, @EAMT
		 ,@SDEPT, @EDEPT, @SCATE, @ECATE,@SWARE
		 ,@EWARE, @SINV_SR, @EINV_SR, @LYN, @EXPARA
		 ,@MFCON = @MCON OUTPUT

		--SET @SQLCOMMAND='Select * from '+@MCON
		---EXECUTE SP_EXECUTESQL @SQLCOMMAND
		SET @SQLCOMMAND='Insert InTo  #FORM221_1 Select * from '+@MCON
		EXECUTE SP_EXECUTESQL @SQLCOMMAND
		---Drop Temp Table 
		SET @SQLCOMMAND='Drop Table '+@MCON
		EXECUTE SP_EXECUTESQL @SQLCOMMAND
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

/* 1.Gross amount received/receivable  */
SET @AMTA1 = 0
SET  @BALAMT = 0 
Select @AMTA1=isnulL(Sum(CASE WHEN BHENT='ST' THEN gro_Amt ELSE -GRO_AMT END),0) From VATTBL where (Date Between @Sdate and @Edate) And Bhent in('ST','CN')
Set @BALAMT = @BALAMT + ISNULL(@AMTA1,0)
INSERT INTO #FORM221 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES (1,'1','A',0,@AMTA1,0,0,'')

/*Deduct */
INSERT INTO #FORM221 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES (1,'1','B',0,0,0,0,'')

/*1.(i) Sales of goods outside the state */
SET @AMTA1 = 0
Select @AMTA1=ISNULL(Sum(CASE WHEN BHENT='ST' THEN gro_Amt ELSE -GRO_AMT END),0) From VATTBL where (Date Between @Sdate 
and @Edate) And Bhent in('ST','CN')  And St_Type = 'OUT OF STATE' 
AND (U_IMPORM IN('BRANCH TRANSFER','CONSIGNMENT TRANSFER'))
Set @BALAMT = @BALAMT - @AMTA1
INSERT INTO #FORM221 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES (1,'1','BA',0,@AMTA1,0,0,'')

/*1.(ii) Sales of goods in course of export outside India(as defined in sec(5) of Central Act) */
SET @AMTA1 = 0
Select @AMTA1=ISNULL(Sum(CASE WHEN BHENT='ST' THEN gro_Amt ELSE -GRO_AMT END),0) From VATTBL where (Date Between @Sdate
and @Edate) And Bhent in('ST','CN')  And St_Type = 'OUT OF COUNTRY'
Set @BALAMT = @BALAMT - @AMTA1
INSERT INTO #FORM221 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES (1,'1','BB',0,@AMTA1,0,0,'')


/*2.(i).Balance-Turnover on inter-State sales and sales within the state*/
INSERT INTO #FORM221(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES(1,'1','C',0,@BALAMT,0,0,'')

/*2.(ii)Deduction for (02)*/
INSERT INTO #FORM221 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES	(1,'1','CA',0,0,0,0,'')

/*2.(ii)Turnover of sales within the state */
SET @AMTA1 = 0
Select @AMTA1=ISNULL(Sum(CASE WHEN BHENT='ST' THEN gro_Amt ELSE -GRO_AMT END),0) From vattbl where (Date Between @Sdate and @Edate) 
And Bhent in('ST','CN') And St_Type in('LOCAL','')
Set @BALAMT = @BALAMT - @AMTA1 
INSERT INTO #FORM221 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES	(1,'1','CB',0,@AMTA1,0,0,'')

 /*3.(i)Balance-Turnover of inter-State Sales*/
INSERT INTO #FORM221 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES (1,'1','D',0,@BALAMT,0,0,'') 

/*3.(ii)Deduction for (03)*/
INSERT INTO #FORM221 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES (1,'1','DA',0,0,0,0,'')

/*3.(ii)Cost of Freight,Delivery or Installation  when such cost is seperately charged turnover of Inter-State saels */
SET @AMTA1 = 0
SET @AMTA2 = 0
SET @BALAMT =@BALAMT - (@AMTA2 + @AMTA1)
INSERT INTO #FORM221 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES (1,'1','DB',0,(@AMTA1+@AMTA2),0,0,'')

/*4.Balance-Total Turnover on inter-State Sales*/

INSERT INTO #FORM221(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES (1,'1','E',0,@BALAMT,0,0,'')

/*4.Deduct*/
INSERT INTO #FORM221 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES (1,'1','EA',0,0,0,0,'')
/*4.(i) Subequensales not taxable under Section 6(2) of the Act*/
SET @AMTA1=0
Select @AMTA1=ISNULL(Sum(CASE WHEN BHENT='ST' THEN gro_Amt ELSE -GRO_AMT END),0) From VATTBL 
where (Date Between @Sdate and @Edate) And Bhent in('ST','CN') AND ST_TYPE='OUT OF STATE'
AND rform_nm IN('E-II','Form E-II','E-II Form','E - 2', 'Form E - 2','E - 2 Form','E-2','Form E-2','E-2 Form','E2','E2 Form','Form E2')
AND TAX_NAME IN('E-II','Form E-II','E-II Form','E - 2', 'Form E - 2','E - 2 Form','E-2','Form E-2','E-2 Form','E2','E2 Form','Form E2')

SET @BALAMT = @BALAMT - @AMTA1 
INSERT INTO #FORM221 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES (1,'1','EB',0,@AMTA1,0,0,'')


/* 5.Goodswise Breakup */
INSERT INTO #FORM221 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES (1,'1','G',0,@BALAMT,0,0,'')

/* 5.A.Declared Goods-*/
INSERT INTO #FORM221(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES(1,'1','GA',0,0,0,0,'')
/* 5.A(i) Sold to registered dealers on prescribed declaration,- vide declarations attached*/
Set @AMTA1 = 0
INSERT INTO #FORM221(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES(1,'1','GB',0,@AMTA1,0,0,'')
/* 5.A(ii) Sold otherwise*/
Set @AMTA1 = 0
INSERT INTO #FORM221(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES(1,'1','GC',0,@AMTA1,0,0,'')

/* 5.B.Other Goods-*/
INSERT INTO #FORM221(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES(1,'1','GD',0,0,0,0,'')
/* 5.B.(i) Sold to registered dealers on prescribed declaration,- vide declarations attached*/
SET @BALAMT62A = 0
SET @BALAMT62B = 0
SET  @AMTA1 = 0  
-- SALES OUT OF STATE WITH TIN AND WITOUT TIN (POINT 6 PART(B))
Select @AMTA1=isnull(Sum(CASE WHEN BHENT='ST' THEN gro_Amt ELSE -GRO_AMT END),0) From VATTBL 
where (Date Between @Sdate and @Edate) And Bhent  in('ST','CN') And s_tax <> ''  And St_Type = 'OUT OF STATE'
AND U_IMPORM NOT IN ('BRANCH TRANSFER','CONSIGNMENT TRANSFER') 
SET @BALAMT62A = ISNULL(@AMTA1,0)
PRINT @AMTA1
SET  @AMTA1 = 0
Select @AMTA1=isnull(Sum(CASE WHEN BHENT='ST' THEN gro_Amt ELSE -GRO_AMT END),0) From VATTBL 
where (Date Between @Sdate and @Edate) And Bhent  IN( 'ST','CN') And s_tax = ''  And St_Type = 'OUT OF STATE'
AND U_IMPORM NOT IN ('BRANCH TRANSFER','CONSIGNMENT TRANSFER') 
SET @BALAMT62B = ISNULL(@AMTA1,0)

SET @AMTA1=0
Select @AMTA1=ISNULL(Sum(CASE WHEN BHENT='ST' THEN gro_Amt ELSE -GRO_AMT END),0) From VATTBL 
where (Date Between @Sdate and @Edate) And Bhent in('ST','CN') and s_tax <>''  AND ST_TYPE='OUT OF STATE'
AND rform_nm IN('E-II','Form E-II','E-II Form','E - 2', 'Form E - 2','E - 2 Form','E-2','Form E-2','E-2 Form','E2','E2 Form','Form E2')
and TAX_NAME IN('E-II','Form E-II','E-II Form','E - 2', 'Form E - 2','E - 2 Form','E-2','Form E-2','E-2 Form','E2','E2 Form','Form E2')
SET @BALAMT62A = @BALAMT62A - @AMTA1

SET @AMTA1=0
Select @AMTA1=ISNULL(Sum(CASE WHEN BHENT='ST' THEN gro_Amt ELSE -GRO_AMT END),0) From VATTBL 
where (Date Between @Sdate and @Edate) And Bhent in('ST','CN') and s_tax ='' AND ST_TYPE='OUT OF STATE'
AND rform_nm IN('E-II','Form E-II','E-II Form','E - 2', 'Form E - 2','E - 2 Form','E-2','Form E-2','E-2 Form','E2','E2 Form','Form E2')
and TAX_NAME IN('E-II','Form E-II','E-II Form','E - 2', 'Form E - 2','E - 2 Form','E-2','Form E-2','E-2 Form','E2','E2 Form','Form E2')
SET @BALAMT62B = @BALAMT62B - ISNULL(@AMTA1,0)
/* 5.B.(i)Sold to registered dealers on prescribed declaration,- vide declarations attached*/
INSERT INTO #FORM221(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES (1,'1','GE',0,@BALAMT62A,0,0,'')

/* 5.B.(ii) Sold otherwise*/
INSERT INTO #FORM221(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES(1,'1','GF',0,@BALAMT62B,0,0,'')
 ---TOTAL--
Select @AMTA1=Sum(Amt1) from #Form221 Where Partsr = '1' and srno in('GB','GC','GD','GE','GF')
INSERT INTO #FORM221 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES(1,'1','GG',0,@AMTA1,0,0,'')

 --Tax & Taxable Amount of Sales for the period
print ' T 1'
 SELECT @AMTA1=0,@AMTB1=0,@AMTC1=0,@AMTD1=0,@AMTE1=0,@AMTF1=0,@AMTG1=0,@AMTH1=0,@AMTI1=0,@AMTJ1=0,@AMTK1=0,@AMTL1=0,@AMTM1=0,@AMTN1=0,@AMTO1=0
 SET @CHAR=65
 DECLARE  CUR_FORM221 CURSOR FOR 
 select distinct level1 from stax_mas 
 OPEN CUR_FORM221
 FETCH NEXT FROM CUR_FORM221 INTO @PER
 WHILE (@@FETCH_STATUS=0)
 BEGIN
		begin
			SET @AMTA1 = 0
			SET @AMTA2 = 0
			SET @AMTD1 = 0
			SET @AMTD2 = 0
			SELECT @AMTA1=ISNULL(SUM(CASE WHEN BHENT='ST' THEN GRO_AMT-TAXAMT ELSE -GRO_AMT+TAXAMT END),0),
			@AMTA2=ISNULL(SUM(CASE WHEN BHENT='ST' THEN TAXAMT ELSE -TAXAMT END),0) FROM VATTBL 
			where Bhent  IN( 'ST','CN') AND (DATE BETWEEN @SDATE AND @EDATE) AND PER=@PER And St_Type = 'OUT OF STATE'
			AND U_IMPORM NOT IN ('BRANCH TRANSFER','CONSIGNMENT TRANSFER')
			
			
			Select @AMTD1=ISNULL(Sum(CASE WHEN BHENT='ST' THEN GRO_Amt-TAXAMT ELSE -GRO_Amt+TAXAMT END),0),@AMTD2=ISNULL(Sum(CASE WHEN BHENT='ST' THEN TAXAMT ELSE -TAXAMT END),0) From VATTBL 
			where (Date Between @Sdate and @Edate) And Bhent in('ST','CN')  AND PER=@PER   AND ST_TYPE='OUT OF STATE'
			AND rform_nm IN('E-II','Form E-II','E-II Form','E - 2', 'Form E - 2','E - 2 Form','E-2','Form E-2','E-2 Form','E2','E2 Form','Form E2')
			and TAX_NAME IN('E-II','Form E-II','E-II Form','E - 2', 'Form E - 2','E - 2 Form','E-2','Form E-2','E-2 Form','E2','E2 Form','Form E2')
		end
  --Net Effect
  Set @NetEFF = @AMTA1-(@AMTD1)
  Set @NetTAX = @AMTA2-(@AMTD2)
  if @NetEFF <> 0
	  begin
		print 'T 5'
		  INSERT INTO #FORM221
		  (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES
		  (1,'2',CHAR(@CHAR),@PER,@NETEFF,@NETTAX,(round(@NETTAX,0)-(@NETTAX)),'') 
 		  SET @AMTJ1=@AMTJ1+@NETEFF --TOTAL TAXABLE AMOUNT
		  SET @AMTK1=@AMTK1+@NETTAX --TOTAL TAX
		  --SET @AMTK1=@AMTK1+((@NETEFF *@PER)/100)
		  SET @AMTK11=@AMTK11+(round(@NETTAX,0)-(@NETTAX))
		  SET @CHAR=@CHAR+1
	  end
  FETCH NEXT FROM CUR_FORM221 INTO @PER
 END
 CLOSE CUR_FORM221
 DEALLOCATE CUR_FORM221
if not exists(select * from #FORM221 where PARTSR ='2') 
begin
	INSERT INTO #FORM221(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES  (1,'2',' ',0,0,0,0,'') 
end
---TOATAL--
 INSERT INTO #FORM221  (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES  (1,'3',' ',0,@AMTJ1,@AMTK1,0,'') 

declare cr_castPayable cursor FOR
select B.u_chALNO,b.u_chALdt,A.Gro_amt,b.bank_nm
from VATTBL A
Inner join Bpmain B on (A.Bhent = B.Entry_ty and A.Tran_cd = B.Tran_cd)
where BHENT = 'BP' And (B.Date Between @sdate and @edate ) And B.Party_nm like '%CST Payable%' ORDER BY B.u_chALdt
SET @INVNO =''
SET @CHLN_DATE =NULL
SET @AMTA1 = 0.00
set @Bank_nm = ''
OPEN cr_castPayable
FETCH NEXT FROM cr_castPayable INTO @INVNO,@CHLN_DATE,@AMTA1,@Bank_nm
 WHILE (@@FETCH_STATUS=0)
 BEGIN
		begin
		  INSERT INTO #form221(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm,DATE,INV_NO) VALUES
		  (1,'4','HH',0,0,@AMTA1,0,@Bank_nm,@CHLN_DATE,@INVNO)
		  PRINT @CHLN_DATE
		  PRINT @INVNO
		END
	FETCH NEXT FROM cr_castPayable INTO @INVNO,@CHLN_DATE,@AMTA1,@Bank_nm
END
CLOSE cr_castPayable
DEALLOCATE cr_castPayable
IF NOT EXISTS (SELECT SRNO FROM #FORM221 WHERE PART=1 AND PARTSR='4' )
BEGIN
	 INSERT INTO #FORM221(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES
		  (1,'4','HH',0,0,0,0,'')
END
SET @AMTA1 = 0
select @AMTA1 = isnull(sum(case when PARTSR='3' then AMT2 else -AMT2 end),0) from #FORM221 where PARTSR IN('3','4')
		  INSERT INTO #FORM221(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES
		  (1,'5','',0,0,@AMTA1,0,'')
PRINT @AMTA1
--Updating Null Records  
Update #form221 set  PART = isnull(Part,0) , Partsr = isnull(PARTSR,''), SRNO = isnull(SRNO,''),
		             RATE = isnull(RATE,0), AMT1 = isnull(AMT1,0), AMT2 = isnull(AMT2,0), 
					 AMT3 = isnull(AMT3,0), INV_NO = isnull(INV_NO,''), DATE = isnull(Date,''), 
					 PARTY_NM = isnull(Party_nm,''), ADDRESS = isnull(Address,''),
					 FORM_NM = isnull(form_nm,''), S_TAX = isnull(S_tax,'')
 SELECT * FROM #FORM221 order by cast(substring(partsr,1,case when (isnumeric(substring(partsr,1,2))=1) then 2 else 1 end) as int)

  END
