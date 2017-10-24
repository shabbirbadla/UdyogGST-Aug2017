set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

-- =============================================
-- Author:		Ruepesh Prajapati.
-- Create date: 11/08/2009
-- Description:	This Stored procedure is useful to generate Excise  Service Tax Report From EP,BP,CP,VR entries.
-- Modification Date/By/Reason: 11/08/2009 Rupesh Prajapati. Modified for NewAll-->TDS field in EP part.
-- Modification Date/By/Reason: 09/10/2009 Rupesh Prajapati. Modified in Final Query For Ac_mast Join and OB entry Type.
-- Modification Date/By/Reason: 22/04/2010 Rupesh Prajapati. Modified for TKT-1023. Add Bank Payment Advance Entry also.
-- Remark:
-- =============================================
ALTER PROCEDURE [dbo].[USP_REP_SERTAX_ACCOUNTS] 
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
SET QUOTED_IDENTIFIER OFF 
DECLARE @FDATE CHAR(10),@OBACID INT
SELECT @FDATE=CASE WHEN DBDATE=1 THEN 'U_CLDT' ELSE 'U_CLDT' END FROM MANUFACT

SET @FDATE='U_CLDT'

SELECT @OBACID=AC_ID FROM AC_MAST WHERE AC_NAME='OPENING BALANCES'
Declare @FCON as NVARCHAR(2000),@VSAMT DECIMAL(14,2),@VEAMT DECIMAL(14,2)

EXECUTE   USP_REP_FILTCON 
@VTMPAC =@TMPAC,@VTMPIT =@TMPIT,@VSPLCOND =' '
,@VSDATE=NULL
,@VEDATE=@EDATE
,@VSAC =@SAC,@VEAC =@EAC
,@VSIT=@SIT,@VEIT=@EIT
,@VSAMT=@SAMT,@VEAMT=@EAMT
,@VSDEPT=@SDEPT,@VEDEPT=@EDEPT
,@VSCATE =@SCATE,@VECATE =@ECATE
,@VSWARE =@SWARE,@VEWARE  =@EWARE
,@VSINV_SR =@SINV_SR,@VEINV_SR =@SINV_SR
,@VMAINFILE='m',@VITFILE='',@VACFILE='ac'
,@VDTFLD =@FDATE
,@VLYN =NULL
,@VEXPARA=@EXPARA
,@VFCON =@FCON OUTPUT

IF  CHARINDEX('m.U_CLDT', @FCON)<>0
BEGIN
	SET @FCON=REPLACE(@FCON, 'm.U_CLDT','ac.U_CLDT')
END


DECLARE @ENTRY_TY CHAR(2),@DATE SMALLDATETIME,@DOC_NO CHAR(5),@AC_ID INT,@AMOUNT NUMERIC(15,2),@AMT_TY CHAR(2),@U_CLDT SMALLDATETIME,@U_RG23NO CHAR(10),@U_RG23CNO CHAR(10),@U_PLASR CHAR(10),@TRAN_CD INT,@TTRAN_CD INT,@OPBAL1 NUMERIC(15,2),@RECEIPT1 NUMERIC(15,2),@ISSUE1 NUMERIC(15,2),@BALANCE1 NUMERIC(15,2),@OPBAL2 NUMERIC(15,2),@RECEIPT2 NUMERIC(15,2),@ISSUE2 NUMERIC(15,2),@BALANCE2 NUMERIC(15,2),@OPBAL3 NUMERIC(15,2),@RECEIPT3 NUMERIC(15,2),@ISSUE3 NUMERIC(15,2),@BALANCE3 NUMERIC(15,2),@OPBAL4 NUMERIC(15,2),@RECEIPT4 NUMERIC(15,2) ,@ISSUE4 NUMERIC(15,2),@BALANCE4 NUMERIC(15,2),@AC_ID5 NUMERIC(15,2),@OPBAL5 NUMERIC(15,2),@RECEIPT5 NUMERIC(15,2) ,@ISSUE5 NUMERIC(15,2),@BALANCE5 NUMERIC(15,2),@OPBAL6 NUMERIC(15,2),@RECEIPT6 NUMERIC(15,2) ,@ISSUE6 NUMERIC(15,2),@BALANCE6 NUMERIC(15,2),@OPBAL7 NUMERIC(15,2),@RECEIPT7 NUMERIC(15,2) ,@ISSUE7 NUMERIC(15,2),@BALANCE7 NUMERIC(15,2),@OPBAL8 NUMERIC(15,2),@RECEIPT8 NUMERIC(15,2) ,@ISSUE8 NUMERIC(15,2),@BALANCE8 NUMERIC(15,2),@OPBAL9 NUMERIC(15,2),@RECEIPT9 NUMERIC(15,2) ,@ISSUE9 NUMERIC(15,2),@BALANCE9 NUMERIC(15,2),@EXDATE SMALLDATETIME,@acserial varchar(5),@m1entry_ty varchar(2),@M1TRAN_CD INT
DECLARE @MAC_ID INT,@MDATE SMALLDATETIME,@OPBAL NUMERIC(15,2),@RECEIPT NUMERIC(15,2),@ISSUE NUMERIC(15,2),@BALANCE NUMERIC(15,2),@V1 NUMERIC(10)
DECLARE @FINAC NVARCHAR(500)
DECLARE @SQLCOMMAND NVARCHAR(4000)
DECLARE @FCOND CHAR(1)
DECLARE @CACID INT,@ACID1 INT,@ACID2 INT,@ACID3 INT,@ACID4 INT,@ACID5 INT,@ACID6 INT,@ACID7 INT,@ACID8 INT,@ACID9 INT,@ACID10 INT, @TRAW NUMERIC(10),@CAC_NAME VARCHAR(60),@AC_NAME1 VARCHAR(60),@AC_NAME2 VARCHAR(60),@AC_NAME3 VARCHAR(60),@AC_NAME4 VARCHAR(60),@AC_NAME5 VARCHAR(60),@AC_NAME6 VARCHAR(60),@AC_NAME7 VARCHAR(60),@AC_NAME8 VARCHAR(60),@AC_NAME9 VARCHAR(60)
DECLARE @VCOND VARCHAR(1000),@VST INT,@VEND INT,@FACNM VARCHAR(500),@I INT 

SET @SPLCOND=REPLACE(@SPLCOND, '`','''')
SET @VCOND=@SPLCOND
SET @VST= CHARINDEX(RTRIM('AC_NAME IN'), @VCOND ,1)
SET @FACNM=SUBSTRING(@VCOND,@VST,2000)
SET @VST= CHARINDEX(RTRIM('('), @FACNM ,1)+1
SET @VEND= CHARINDEX(RTRIM(')'), @FACNM ,1)
SET @FACNM=SUBSTRING(@FACNM,@VST,@VEND-@VST)
SET @FACNM= LTRIM(RTRIM(@FACNM))+', '
SET QUOTED_IDENTIFIER ON


SET @FINAC=CHAR(39)+@FACNM+CHAR(39)

SELECT ex_vw_acdet.ENTRY_TY,ex_vw_acdet.DATE,ex_vw_acdet.DOC_NO,ex_vw_acdet.AMT_TY,ex_vw_acdet.U_CLDT,ex_vw_acdet.U_RG23NO,ex_vw_acdet.U_RG23CNO,ex_vw_acdet.U_PLASR,AC_ID=ex_vw_acdet.AC_ID,AC_ID1=ex_vw_acdet.AC_ID,OPBAL1 =ex_vw_acdet.AMOUNT,RECEIPT1=ex_vw_acdet.AMOUNT,ISSUE1=ex_vw_acdet.AMOUNT,BALANCE1=ex_vw_acdet.AMOUNT,AC_ID2=ex_vw_acdet.AC_ID,OPBAL2 =ex_vw_acdet.AMOUNT,RECEIPT2=ex_vw_acdet.AMOUNT,ISSUE2=ex_vw_acdet.AMOUNT,BALANCE2=AMOUNT,AC_ID3=ex_vw_acdet.AC_ID,OPBAL3 =ex_vw_acdet.AMOUNT,RECEIPT3=ex_vw_acdet.AMOUNT,ISSUE3=ex_vw_acdet.AMOUNT,BALANCE3=ex_vw_acdet.AMOUNT,AC_ID4=ex_vw_acdet.AC_ID,OPBAL4 =ex_vw_acdet.AMOUNT,RECEIPT4=ex_vw_acdet.AMOUNT,ISSUE4=ex_vw_acdet.AMOUNT,BALANCE4=ex_vw_acdet.AMOUNT,AC_ID5=ex_vw_acdet.AC_ID,OPBAL5 =ex_vw_acdet.AMOUNT,RECEIPT5=ex_vw_acdet.AMOUNT,ISSUE5=ex_vw_acdet.AMOUNT,BALANCE5=ex_vw_acdet.AMOUNT,AC_ID6=ex_vw_acdet.AC_ID,OPBAL6 =ex_vw_acdet.AMOUNT,RECEIPT6=ex_vw_acdet.AMOUNT,ISSUE6=ex_vw_acdet.AMOUNT,BALANCE6=ex_vw_acdet.AMOUNT,AC_ID7=ex_vw_acdet.AC_ID,OPBAL7 =ex_vw_acdet.AMOUNT,RECEIPT7=ex_vw_acdet.AMOUNT,ISSUE7=ex_vw_acdet.AMOUNT,BALANCE7=ex_vw_acdet.AMOUNT,AC_ID8=ex_vw_acdet.AC_ID,OPBAL8 =ex_vw_acdet.AMOUNT,RECEIPT8=ex_vw_acdet.AMOUNT,ISSUE8=ex_vw_acdet.AMOUNT,BALANCE8=ex_vw_acdet.AMOUNT,AC_ID9=ex_vw_acdet.AC_ID,OPBAL9 =ex_vw_acdet.AMOUNT,RECEIPT9=ex_vw_acdet.AMOUNT,ISSUE9=ex_vw_acdet.AMOUNT,BALANCE9=ex_vw_acdet.AMOUNT,TRAN_CD=ex_vw_acdet.TRAN_CD,TTRAN_CD=ex_vw_acdet.TRAN_CD,EXDATE=ex_vw_acdet.DATE,ex_vw_acdet.acserial,m1entry_ty=ex_vw_acdet.entry_ty,m1tran_cd=ex_vw_acdet.tran_cd  INTO  #ACDET FROM ex_vw_acdet JOIN STKL_VW_MAIN ON (ex_vw_acdet.TRAN_CD=STKL_VW_MAIN.TRAN_CD) WHERE 1=2
SELECT mac_id=STKL_VW_MAIN.ac_id,ex_vw_acdet.ENTRY_TY,ex_vw_acdet.DATE,ex_vw_acdet.DOC_NO,ex_vw_acdet.AC_ID,ex_vw_acdet.AMOUNT,ex_vw_acdet.AMT_TY,ex_vw_acdet.U_CLDT,ex_vw_acdet.U_RG23NO,ex_vw_acdet.U_RG23CNO,ex_vw_acdet.U_PLASR,STKL_VW_MAIN.U_INT,AC_MAST.AC_NAME,TRAN_CD=ex_vw_acdet.TRAN_CD,EXDATE=ex_vw_acdet.DATE,ex_vw_acdet.acserial,m1entry_ty=ex_vw_acdet.entry_ty,m1tran_cd=ex_vw_acdet.tran_cd  INTO #ACDET1  FROM ex_vw_acdet JOIN STKL_VW_MAIN ON (ex_vw_acdet.TRAN_CD=STKL_VW_MAIN.TRAN_CD)  JOIN AC_MAST ON (AC_MAST.AC_ID =ex_vw_acdet.AC_ID) WHERE 1=2


/*SET @SQLCOMMAND=' INSERT INTO #ACDET1 SELECT AC.ENTRY_TY,AC.DATE,AC.DOC_NO,AC.AC_ID,AMOUNT=(case when isnull(mall.new_all,0)=0 then ac.amount else mall.new_all end)'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+ ',AC.AMT_TY,AC.U_CLDT,U_RG23NO=SPACE(1),U_RG23CNO=SPACE(1),U_PLASR=SPACE(1),U_INT=0,AC_MAST.AC_NAME,AC.TRAN_CD,AC.'+@FDATE+',ac.acserial,m1.entry_ty,m1.tran_cd'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+ ' from lmain_vw m'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+ ' inner JOIN AC_MAST A  ON (m.AC_ID =a.AC_ID)'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+ ' left join ex_vw_acdet ac on (m.entry_ty=ac.entry_ty and m.tran_cd=ac.tran_cd)'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+ ' left JOIN AC_MAST  ON (ac.AC_ID =AC_MAST.AC_ID)'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+ ' left join mainall_vw mall on (ac.entry_ty=mall.entry_ty and ac.tran_cd=mall.tran_cd and ac.acserial<>mall.acserial)'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+ ' left join lmain_vw m1 on (mall.entry_all=m1.entry_ty and mall.main_tran=m1.tran_cd)'
--SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+RTRIM(@FCON)
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' ORDER BY ac.'+ @FDATE+',CASE WHEN ac.AMT_TY='+'''DR'''+' THEN 0 ELSE 1 END,ac.tran_cd,m1.tran_cd'*/
/* --->EP*/
SET @SQLCOMMAND=''
SET @SQLCOMMAND=' INSERT INTO #ACDET1 '
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+ 'select m.ac_id,e.entry_ty,e.date,e.doc_no,a.ac_id,amount=mall.tds'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+ ',amt_ty=''DR'',U_CLDT=ac.date,U_RG23NO=SPACE(1),U_RG23CNO=SPACE(1),U_PLASR=SPACE(1),U_INT=0'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+ ',ac_name=case '
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+ 'when a.ac_name=''Input Service Tax'' then ''BALANCE WITH SERVICE TAX A/C'''
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+ 'when a.ac_name=''Edu. Cess on Input Service Tax'' then ''BALANCE WITH SERVICE TAX CESS A/C'''
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+ 'when a.ac_name=''S & H Cess on Input Service Tax'' then ''BALANCE WITH SERVICE TAX HCESS A/C'''
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+ 'else '''' end'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+ ',e.tran_cd,U_CLDT=ac.date,ac.acserial,m.entry_ty,m.tran_cd'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+ 'from lac_vw ac'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+ 'inner join lmain_vw m on (ac.entry_ty=m.entry_ty and ac.tran_cd=m.tran_cd)'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+ 'inner join mainall_vw mall on (ac.entry_ty=mall.entry_ty and ac.tran_cd=mall.tran_cd and ac.acserial=mall.acserial)'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+ 'inner join epmain e on (mall.entry_all=e.entry_ty and mall.main_tran=e.tran_cd)'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+ 'inner join ac_mast a on (ac.ac_id=a.ac_id)'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+ 'inner join ac_mast a1 on (e.ac_id=a1.ac_id)'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+ 'inner join lcode l on (m.entry_ty=l.entry_ty)'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+RTRIM(@FCON)
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+ 'and e.seravail=''EXCISE'' '
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+ 'and a.ac_name in (''Input Service Tax'',''Edu. Cess on Input Service Tax'',''S & H Cess on Input Service Tax'')'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+ 'and (  l.entry_ty in (''BP'',''CP'') or l.bcode_nm in (''BP'',''CP'')  )'
PRINT @SQLCOMMAND
EXEC SP_EXECUTESQL  @SQLCOMMAND
update a set a.ac_id=b.ac_id from #ACDET1 a inner join ac_mast b on (a.ac_name=b.ac_name)

/*<---EP*/

/*Dont Change below line position*/
SELECT ENTRY_ALL,MAIN_TRAN,ACSERI_ALL,entry_ty,tran_cd,acserial,NEW_ALL=SUM(NEW_ALL) INTO #MALL FROM mainall_vw WHERE ENTRY_TY IN ('BP','CP') and Entry_all in ('EP') AND (DATE BETWEEN @SDATE AND @EDATE) AND AC_ID IN (SELECT DISTINCT MAC_ID FROM #ACDET1) GROUP BY ENTRY_ALL,MAIN_TRAN,ACSERI_ALL,entry_ty,tran_cd,acserial
/*select 'a',* from #MALL*/

/*--->Advance Payment*/
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
,@VMAINFILE='m',@VITFILE='',@VACFILE='ac'
,@VDTFLD ='Date'
,@VLYN =NULL
,@VEXPARA=@EXPARA
,@VFCON =@FCON OUTPUT

SET @SQLCOMMAND='INSERT INTO #ACDET1'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+ 'select m.ac_id,m.entry_ty,m.date,ac.doc_no,a.ac_id,ac.amount,ac.amt_ty,m.date,u_rg23no='''',u_rg23cno='''',u_palsr='''',u_int=0,a.ac_name,m.tran_cd,m.date,ac.acserial,m1entry_ty='''',m1tran_cd=0'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+ 'from lac_vw ac '
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+ 'inner join sertaxmain_vw m on (ac.entry_ty=m.entry_ty and ac.tran_cd=m.tran_cd) '
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+ 'inner join ac_mast on (ac.ac_id=ac_mast.ac_id)' 
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+ 'inner join ac_mast a on (ac.ac_id=a.ac_id)' 
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+ 'inner join lcode l on (m.entry_ty=l.entry_ty)  '
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+RTRIM(@FCON)
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+ 'and m.tdspaytype=2' 
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+ 'AND a.AC_NAME IN (''BALANCE WITH SERVICE TAX A/C'',''BALANCE WITH SERVICE TAX CESS A/C'',''BALANCE WITH SERVICE TAX HCESS A/C'')'
PRINT @SQLCOMMAND
EXEC SP_EXECUTESQL  @SQLCOMMAND
/*<--- Advance Payment*/



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
,@VMAINFILE='STKL_VW_MAIN',@VITFILE='',@VACFILE='ac'
,@VDTFLD =@FDATE
,@VLYN =NULL
,@VEXPARA=@EXPARA
,@VFCON =@FCON OUTPUT
IF  CHARINDEX('STKL_VW_MAIN.U_CLDT', @FCON)<>0
BEGIN
	SET @FCON=REPLACE(@FCON, 'STKL_VW_MAIN.U_CLDT','EX_VW_ACDET.U_CLDT')
END
SET @SQLCOMMAND=' INSERT INTO #ACDET1 SELECT STKL_VW_MAIN.ac_id,EX_VW_ACDET.ENTRY_TY,EX_VW_ACDET.DATE,EX_VW_ACDET.DOC_NO,EX_VW_ACDET.AC_ID,EX_VW_ACDET.AMOUNT'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+ ',EX_VW_ACDET.AMT_TY,EX_VW_ACDET.U_CLDT,EX_VW_ACDET.U_RG23NO,EX_VW_ACDET.U_RG23CNO,EX_VW_ACDET.U_PLASR,STKL_VW_MAIN.U_INT'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+ ',AC_MAST.AC_NAME,EX_VW_ACDET.TRAN_CD,EX_VW_ACDET.'+@FDATE+',acserial='''','''','''' FROM EX_VW_ACDET '
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+ ' INNER JOIN STKL_VW_MAIN ON (EX_VW_ACDET.TRAN_CD=STKL_VW_MAIN.TRAN_CD AND EX_VW_ACDET.ENTRY_TY=STKL_VW_MAIN.ENTRY_TY)   JOIN AC_MAST ON (AC_MAST.AC_ID =EX_VW_ACDET.AC_ID) '
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+ 'inner join lcode l on (STKL_VW_MAIN.entry_ty=l.entry_ty)'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+ 'and (  l.entry_ty in (''VR'',''OB'') or l.bcode_nm in (''OB''))'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+RTRIM(@FCON)
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' ORDER BY EX_VW_ACDET.'+ @FDATE+',EX_VW_ACDET.U_RG23NO '
PRINT @SQLCOMMAND
EXEC SP_EXECUTESQL  @SQLCOMMAND




SET @TTRAN_CD=0

SET  @ACID1=0
SET  @ACID2=0
SET  @ACID3=0
SET  @ACID4=0
SET  @ACID5=0
SET  @ACID6=0
SET  @ACID7=0
SET  @ACID8=0
SET  @ACID9=0


SET @FACNM=REPLACE(@FACNM,'''',' ')
PRINT @FACNM
SET @VST=1
SET @I=0
SET @VEND= CHARINDEX(',',@FACNM,1)

WHILE CHARINDEX(',',@FACNM,1)<>0
BEGIN
	SET @I=@I+1
	IF @I=1
	BEGIN
		SET @AC_NAME1= SUBSTRING(@FACNM,@VST,@VEND-@VST)
		SELECT  @ACID1 =AC_ID FROM AC_MAST WHERE LTRIM(RTRIM(AC_NAME))=LTRIM(RTRIM(@AC_NAME1))
		
	END
	IF @I=2
	BEGIN
		
		SET @AC_NAME2= SUBSTRING(@FACNM,@VST,@VEND-@VST)
		SELECT  @ACID2 =AC_ID FROM AC_MAST WHERE LTRIM(RTRIM(AC_NAME))=LTRIM(RTRIM(@AC_NAME2))
	END
	IF @I=3
	BEGIN
		SET @AC_NAME3= SUBSTRING(@FACNM,@VST,@VEND-@VST)
		SELECT  @ACID3 =AC_ID FROM AC_MAST WHERE LTRIM(RTRIM(AC_NAME))=LTRIM(RTRIM(@AC_NAME3))
	END
	IF @I=4
	BEGIN
		SET @AC_NAME4= SUBSTRING(@FACNM,@VST,@VEND-@VST)
		SELECT  @ACID4 =AC_ID FROM AC_MAST WHERE LTRIM(RTRIM(AC_NAME))=LTRIM(RTRIM(@AC_NAME4))
	END
	IF @I=5
	BEGIN
          		SET @AC_NAME5= SUBSTRING(@FACNM,@VST,@VEND-@VST)
		SELECT  @ACID5 =AC_ID FROM AC_MAST WHERE LTRIM(RTRIM(AC_NAME))=LTRIM(RTRIM(@AC_NAME5))
	END
	IF @I=6
	BEGIN
		SET @AC_NAME6= SUBSTRING(@FACNM,@VST,@VEND-@VST)
		SELECT  @ACID6 =AC_ID FROM AC_MAST WHERE AC_NAME=@AC_NAME6

	END
	IF @I=7
	BEGIN
        SET @AC_NAME7= SUBSTRING(@FACNM,@VST,@VEND-@VST)
		SELECT  @ACID7=AC_ID FROM AC_MAST WHERE AC_NAME=@AC_NAME7

	END
	IF @I=8
	BEGIN
		SET @AC_NAME8= SUBSTRING(@FACNM,@VST,@VEND-@VST)
		SELECT  @ACID8 =AC_ID FROM AC_MAST WHERE AC_NAME=@AC_NAME8

	END
	IF @I=9
	BEGIN
		 SET @AC_NAME9= SUBSTRING(@FACNM,@VST,@VEND-@VST)
		SELECT  @ACID9 =AC_ID FROM AC_MAST WHERE AC_NAME=@AC_NAME9
	END
	
	SET @FACNM=SUBSTRING(@FACNM,@VEND+1,500)
	SET @VEND= CHARINDEX(',',@FACNM,1)

END

--SELECT *
--FROM #ACDET1 WHERE ((EXDATE<@SDATE AND ENTRY_TY<>'OB') OR (EXDATE<=@SDATE AND ENTRY_TY='OB')) 

SELECT
@OPBAL1     =SUM(CASE WHEN AC_ID=@ACID1 THEN  (CASE WHEN AMT_TY='DR' THEN AMOUNT ELSE -AMOUNT END) ELSE 0 END) ,
@BALANCE1=SUM(CASE WHEN AC_ID=@ACID1 THEN  (CASE WHEN AMT_TY='DR' THEN AMOUNT ELSE -AMOUNT END) ELSE 0 END),@OPBAL2     =SUM(CASE WHEN AC_ID=@ACID2 THEN  (CASE WHEN AMT_TY='DR' THEN AMOUNT ELSE -AMOUNT END) ELSE 0 END) ,
@BALANCE2=SUM(CASE WHEN AC_ID=@ACID2 THEN  (CASE WHEN AMT_TY='DR' THEN AMOUNT ELSE -AMOUNT END) ELSE 0 END) ,
@OPBAL3     =SUM(CASE WHEN AC_ID=@ACID3 THEN  (CASE WHEN AMT_TY='DR' THEN AMOUNT ELSE -AMOUNT END) ELSE 0 END) ,
@BALANCE3=SUM(CASE WHEN AC_ID=@ACID3 THEN  (CASE WHEN AMT_TY='DR' THEN AMOUNT ELSE -AMOUNT END) ELSE 0 END),
@OPBAL4     =SUM(CASE WHEN AC_ID=@ACID4 THEN  (CASE WHEN AMT_TY='DR' THEN AMOUNT ELSE -AMOUNT END) ELSE 0 END) ,
@BALANCE4=SUM(CASE WHEN AC_ID=@ACID4 THEN  (CASE WHEN AMT_TY='DR' THEN AMOUNT ELSE -AMOUNT END) ELSE 0 END),
@OPBAL5     =SUM(CASE WHEN AC_ID=@ACID5 THEN  (CASE WHEN AMT_TY='DR' THEN AMOUNT ELSE -AMOUNT END) ELSE 0 END) ,
@BALANCE5=SUM(CASE WHEN AC_ID=@ACID5 THEN  (CASE WHEN AMT_TY='DR' THEN AMOUNT ELSE -AMOUNT END) ELSE 0 END),
@OPBAL6     =SUM(CASE WHEN AC_ID=@ACID6 THEN  (CASE WHEN AMT_TY='DR' THEN AMOUNT ELSE -AMOUNT END) ELSE 0 END) ,
@BALANCE6=SUM(CASE WHEN AC_ID=@ACID6 THEN  (CASE WHEN AMT_TY='DR' THEN AMOUNT ELSE -AMOUNT END) ELSE 0 END),
@OPBAL7     =SUM(CASE WHEN AC_ID=@ACID7 THEN  (CASE WHEN AMT_TY='DR' THEN AMOUNT ELSE -AMOUNT END) ELSE 0 END) ,
@BALANCE7=SUM(CASE WHEN AC_ID=@ACID7 THEN  (CASE WHEN AMT_TY='DR' THEN AMOUNT ELSE -AMOUNT END) ELSE 0 END),
@OPBAL8     =SUM(CASE WHEN AC_ID=@ACID8 THEN  (CASE WHEN AMT_TY='DR' THEN AMOUNT ELSE -AMOUNT END) ELSE 0 END) ,
@BALANCE8=SUM(CASE WHEN AC_ID=@ACID8 THEN  (CASE WHEN AMT_TY='DR' THEN AMOUNT ELSE -AMOUNT END) ELSE 0 END),
@OPBAL9     =SUM(CASE WHEN AC_ID=@ACID9 THEN  (CASE WHEN AMT_TY='DR' THEN AMOUNT ELSE -AMOUNT END) ELSE 0 END) ,
@BALANCE9=SUM(CASE WHEN AC_ID=@ACID9 THEN  (CASE WHEN AMT_TY='DR' THEN AMOUNT ELSE -AMOUNT END) ELSE 0 END)
FROM #ACDET1 WHERE ((EXDATE<@SDATE AND ENTRY_TY<>'OB') OR (EXDATE<=@SDATE AND ENTRY_TY='OB')) 


SET @OPBAL1=CASE WHEN @OPBAL1 IS NULL THEN 0 ELSE @OPBAL1 END
SET @BALANCE1=CASE WHEN @BALANCE2 IS NULL THEN 0 ELSE @BALANCE1 END
SET @OPBAL2=CASE WHEN @OPBAL2 IS NULL THEN 0 ELSE @OPBAL2 END
SET @BALANCE2=CASE WHEN @BALANCE2 IS NULL THEN 0 ELSE @BALANCE2 END
SET @OPBAL3=CASE WHEN @OPBAL3 IS NULL THEN 0 ELSE @OPBAL3 END
SET @BALANCE3=CASE WHEN @BALANCE3 IS NULL THEN 0 ELSE @BALANCE3 END
SET @OPBAL4=CASE WHEN @OPBAL4 IS NULL THEN 0 ELSE @OPBAL4 END
SET @BALANCE4=CASE WHEN @BALANCE4 IS NULL THEN 0 ELSE @BALANCE4 END
SET @OPBAL5=CASE WHEN @OPBAL5 IS NULL THEN 0 ELSE @OPBAL5 END
SET @BALANCE5=CASE WHEN @BALANCE5 IS NULL THEN 0 ELSE @BALANCE5 END
SET @OPBAL6=CASE WHEN @OPBAL6 IS NULL THEN 0 ELSE @OPBAL6 END
SET @BALANCE6=CASE WHEN @BALANCE6 IS NULL THEN 0 ELSE @BALANCE6 END
SET @OPBAL7=CASE WHEN @OPBAL7 IS NULL THEN 0 ELSE @OPBAL7 END
SET @BALANCE7=CASE WHEN @BALANCE7 IS NULL THEN 0 ELSE @BALANCE7 END
SET @OPBAL8=CASE WHEN @OPBAL8 IS NULL THEN 0 ELSE @OPBAL8 END
SET @BALANCE8=CASE WHEN @BALANCE8 IS NULL THEN 0 ELSE @BALANCE8 END
SET @OPBAL9=CASE WHEN @OPBAL9 IS NULL THEN 0 ELSE @OPBAL9 END
SET @BALANCE9=CASE WHEN @BALANCE9 IS NULL THEN 0 ELSE @BALANCE9 END



SET @RECEIPT1=0
SET @ISSUE1=0
SET @RECEIPT2=0
SET @ISSUE2=0
SET @RECEIPT3=0
SET @ISSUE3=0
SET @RECEIPT4=0
SET @ISSUE4=0
SET @RECEIPT5=0
SET @ISSUE5=0
SET @RECEIPT6=0
SET @ISSUE6=0
SET @RECEIPT7=0
SET @ISSUE7=0
SET @RECEIPT8=0
SET @ISSUE8=0
SET @RECEIPT9=0
SET @ISSUE9=0

SET @TTRAN_CD=@TTRAN_CD+1
IF ABS(@OPBAL1)+ABS(@BALANCE1)+ABS(@OPBAL2)+ABS(@BALANCE2)+ABS(@OPBAL3)+ABS(@BALANCE3)+ABS(@OPBAL4)+ABS(@BALANCE4)+ABS(@OPBAL5)+ABS(@BALANCE5)+ABS(@OPBAL6)+ABS(@BALANCE6)+ABS(@OPBAL7)+ABS(@BALANCE7)+ABS(@OPBAL8)+ABS(@BALANCE8)+ABS(@OPBAL9)+ABS(@BALANCE9)<>0
BEGIN
	INSERT INTO #ACDET (ENTRY_TY,DATE,DOC_NO,AMT_TY,U_CLDT,U_RG23NO,U_RG23CNO,U_PLASR,AC_ID,TRAN_CD,
	AC_ID1,OPBAL1,RECEIPT1,ISSUE1,BALANCE1,
	AC_ID2,OPBAL2,RECEIPT2,ISSUE2,BALANCE2,
	AC_ID3,OPBAL3,RECEIPT3,ISSUE3,BALANCE3,
	AC_ID4,OPBAL4,RECEIPT4,ISSUE4,BALANCE4,
	AC_ID5,OPBAL5,RECEIPT5,ISSUE5,BALANCE5,
	AC_ID6,OPBAL6,RECEIPT6,ISSUE6,BALANCE6,
	AC_ID7,OPBAL7,RECEIPT7,ISSUE7,BALANCE7,
	AC_ID8,OPBAL8,RECEIPT8,ISSUE8,BALANCE8,
	AC_ID9,OPBAL9,RECEIPT9,ISSUE9,BALANCE9,
	TTRAN_CD,EXDATE,acserial,M1ENTRY_TY,M1TRAN_CD
	)
	VALUES('OB',@SDATE,' ',' ',@SDATE,' ',' ',' ',@OBACID,0,
	@ACID1,@OPBAL1,@RECEIPT1,@ISSUE1,@BALANCE1,
	@ACID2,@OPBAL2,@RECEIPT2,@ISSUE2,@BALANCE2,
	@ACID3,@OPBAL3,@RECEIPT3,@ISSUE3,@BALANCE3,
	@ACID4,@OPBAL4,@RECEIPT4,@ISSUE4,@BALANCE4,
	@ACID5,@OPBAL5,@RECEIPT5,@ISSUE5,@BALANCE5,
	@ACID6,@OPBAL6,@RECEIPT6,@ISSUE6,@BALANCE6,
	@ACID7,@OPBAL7,@RECEIPT7,@ISSUE7,@BALANCE7,
	@ACID8,@OPBAL8,@RECEIPT8,@ISSUE8,@BALANCE8,
	@ACID9,@OPBAL9,@RECEIPT9,@ISSUE9,@BALANCE9,
	@TTRAN_CD,@SDATE,'','',0
	)
END


DECLARE RG23II_CURSOR CURSOR FORWARD_ONLY  FOR 
SELECT ENTRY_TY,DATE,DOC_NO,AC_ID,AMOUNT,AMT_TY,U_CLDT,U_RG23NO,U_RG23CNO,U_PLASR,TRAN_CD,EXDATE,acserial,m1entry_ty,M1TRAN_CD 
FROM #ACDET1  
WHERE (((EXDATE>=@SDATE  AND ENTRY_TY<>'OB') OR (EXDATE>@SDATE  AND ENTRY_TY='OB'))) 
ORDER BY EXDATE,(CASE WHEN AMT_TY='DR' THEN 0 ELSE 1 END),tran_cd,m1tran_cd


OPEN RG23II_CURSOR
FETCH NEXT FROM RG23II_CURSOR INTO
@ENTRY_TY,@DATE,@DOC_NO,@AC_ID,@AMOUNT,@AMT_TY,@U_CLDT,@U_RG23NO,@U_RG23CNO,@U_PLASR,@TRAN_CD,@EXDATE,@acserial,@M1ENTRY_TY,@M1TRAN_CD
while(@@FETCH_STATUS=0)
BEGIN
	SET @RECEIPT1=0
	SET @ISSUE1=0
	SET @RECEIPT2=0
	SET @ISSUE2=0
	SET @RECEIPT3=0
	SET @ISSUE3=0
	SET @RECEIPT4=0
	SET @ISSUE4=0
	SET @RECEIPT5=0
	SET @ISSUE5=0
	SET @RECEIPT6=0
	SET @ISSUE6=0
	SET @RECEIPT7=0
	SET @ISSUE7=0
	SET @RECEIPT8=0
	SET @ISSUE8=0
	SET @RECEIPT9=0
	SET @ISSUE9=0
	print 'Ac_id'
	print @ac_id
	print @AMT_TY

	IF @AMT_TY='DR'
	BEGIN
	
		IF @AC_ID=@ACID1
		BEGIN
			SET @RECEIPT1=@AMOUNT	
		END
		ELSE
		BEGIN
			IF @AC_ID=@ACID2
			BEGIN
				SET @RECEIPT2=@AMOUNT	
			END 		
			ELSE
			BEGIN
				IF @AC_ID=@ACID3
				BEGIN
					SET @RECEIPT3=@AMOUNT	
				END 	
				ELSE
				BEGIN
					IF @AC_ID=@ACID4
					BEGIN
						SET @RECEIPT4=@AMOUNT	
					END 	
					ELSE	
					BEGIN
						IF @AC_ID=@ACID5
						BEGIN
							SET @RECEIPT5=@AMOUNT	
						END 	
						ELSE
						BEGIN
							IF @AC_ID=@ACID6
							BEGIN
								SET @RECEIPT6=@AMOUNT	
							END 	
							ELSE
							BEGIN
								IF @AC_ID=@ACID7
								BEGIN
									SET @RECEIPT7=@AMOUNT	
								END 	
								ELSE
								BEGIN
									IF @AC_ID=@ACID8
									BEGIN
										SET @RECEIPT8=@AMOUNT	
									END 	
									ELSE
									BEGIN
										IF @AC_ID=@ACID9
										BEGIN
											SET @RECEIPT9=@AMOUNT	
										END 	
									END
								END
							END
						END
					END
				END
			END
		END
	END

	IF @AMT_TY='CR'
	BEGIN

		IF @AC_ID=@ACID1
		BEGIN
			SET @ISSUE1=@AMOUNT	
		END
		ELSE
		BEGIN
			IF @AC_ID=@ACID2
			BEGIN
				SET @ISSUE2=@AMOUNT	
			END 		
			ELSE
			BEGIN
				IF @AC_ID=@ACID3
				BEGIN
					SET @ISSUE3=@AMOUNT	
				END 	
				ELSE
				BEGIN
					IF @AC_ID=@ACID4
					BEGIN
						SET @ISSUE4=@AMOUNT	
					END 	
					ELSE
					BEGIN
						IF @AC_ID=@ACID5
						BEGIN
							SET @ISSUE5=@AMOUNT	
						END 	
						ELSE
						BEGIN
							IF @AC_ID=@ACID6
							BEGIN
								SET @ISSUE6=@AMOUNT	
							END 	
							ELSE
							BEGIN
								IF @AC_ID=@ACID7
								BEGIN
									SET @ISSUE7=@AMOUNT	
								END 	
								ELSE
								BEGIN
									IF @AC_ID=@ACID8
									BEGIN
										SET @ISSUE8=@AMOUNT	
									END 	
									ELSE
									BEGIN
										IF @AC_ID=@ACID9		
										BEGIN	
											SET @ISSUE9=@AMOUNT	
										END 	
									END
								END
							END
						END
					END
				END
			END
		END
	END

	SET @BALANCE1=@BALANCE1+@RECEIPT1-@ISSUE1
	SET @BALANCE2=@BALANCE2+@RECEIPT2-@ISSUE2
	SET @BALANCE3=@BALANCE3+@RECEIPT3-@ISSUE3
	SET @BALANCE4=@BALANCE4+@RECEIPT4-@ISSUE4
	SET @BALANCE5=@BALANCE5+@RECEIPT5-@ISSUE5
	SET @BALANCE6=@BALANCE6+@RECEIPT6-@ISSUE6
	SET @BALANCE7=@BALANCE7+@RECEIPT7-@ISSUE7
	SET @BALANCE8=@BALANCE8+@RECEIPT8-@ISSUE8
	SET @BALANCE9=@BALANCE9+@RECEIPT9-@ISSUE9

	
	SET @TTRAN_CD=@TTRAN_CD+1
	INSERT INTO #ACDET (ENTRY_TY,DATE,DOC_NO,AMT_TY,U_CLDT,U_RG23NO,U_RG23CNO,U_PLASR,AC_ID,TRAN_CD,
	AC_ID1,OPBAL1,RECEIPT1,ISSUE1,BALANCE1,
	AC_ID2,OPBAL2,RECEIPT2,ISSUE2,BALANCE2,
	AC_ID3,OPBAL3,RECEIPT3,ISSUE3,BALANCE3,	AC_ID4,OPBAL4,RECEIPT4,ISSUE4,BALANCE4,
	AC_ID5,OPBAL5,RECEIPT5,ISSUE5,BALANCE5,
	AC_ID6,OPBAL6,RECEIPT6,ISSUE6,BALANCE6,
	AC_ID7,OPBAL7,RECEIPT7,ISSUE7,BALANCE7,
	AC_ID8,OPBAL8,RECEIPT8,ISSUE8,BALANCE8,
	AC_ID9,OPBAL9,RECEIPT9,ISSUE9,BALANCE9,
	TTRAN_CD,EXDATE,acserial,M1ENTRY_TY,M1TRAN_CD
	)
	VALUES(@ENTRY_TY,@DATE,@DOC_NO,@AMT_TY,@U_CLDT,@U_RG23NO,@U_RG23CNO,@U_PLASR,@AC_ID,@TRAN_CD,
	@ACID1,@OPBAL1,@RECEIPT1,@ISSUE1,@BALANCE1,
	@ACID2,@OPBAL2,@RECEIPT2,@ISSUE2,@BALANCE2,
	@ACID3,@OPBAL3,@RECEIPT3,@ISSUE3,@BALANCE3,
	@ACID4,@OPBAL4,@RECEIPT4,@ISSUE4,@BALANCE4,
	@ACID5,@OPBAL5,@RECEIPT5,@ISSUE5,@BALANCE5,
	@ACID6,@OPBAL6,@RECEIPT6,@ISSUE6,@BALANCE6,
	@ACID7,@OPBAL7,@RECEIPT7,@ISSUE7,@BALANCE7,
	@ACID8,@OPBAL8,@RECEIPT8,@ISSUE8,@BALANCE8,
	@ACID9,@OPBAL9,@RECEIPT9,@ISSUE9,@BALANCE9,
	@TTRAN_CD,@EXDATE,@acserial,@M1ENTRY_TY,@M1TRAN_CD
	)

	SET @OPBAL1=@BALANCE1
	SET @OPBAL2=@BALANCE2
	SET @OPBAL3=@BALANCE3
	SET @OPBAL4=@BALANCE4
	SET @OPBAL5=@BALANCE5
	SET @OPBAL6=@BALANCE6
	SET @OPBAL7=@BALANCE7
	SET @OPBAL8=@BALANCE8
	SET @OPBAL9=@BALANCE9

	FETCH NEXT FROM RG23II_CURSOR INTO
	@ENTRY_TY,@DATE,@DOC_NO,@AC_ID,@AMOUNT,@AMT_TY,@U_CLDT,@U_RG23NO,@U_RG23CNO,@U_PLASR,@TRAN_CD,@EXDATE,@acserial,@M1ENTRY_TY,@M1TRAN_CD
END ---@@FETCH_STATUS=0
CLOSE  RG23II_CURSOR
DEALLOCATE RG23II_CURSOR

/*select 'b',tran_cd,* from #ACDET*/
SELECT ENTRY_TY,TRAN_CD,m1entry_ty,m1tran_cd,RECEIPT=SUM(RECEIPT1+RECEIPT2+RECEIPT3+RECEIPT4+RECEIPT5+RECEIPT6+RECEIPT7+RECEIPT8+RECEIPT9) INTO #RECEIPT FROM #ACDET where entry_ty='EP' GROUP BY ENTRY_TY,TRAN_CD,m1entry_ty,m1tran_cd
/*select 'c',* from #RECEIPT*/
SELECT A.ENTRY_TY,A.TRAN_CD,m1entry_ty,m1tran_cd,taxableamt=B.NEW_ALL-A.RECEIPT INTO #TAXABLE FROM #RECEIPT A INNER JOIN #MALL B ON (A.ENTRY_TY=B.ENTRY_ALL AND A.TRAN_CD=B.MAIN_TRAN and a.m1entry_ty=b.entry_ty and a.m1tran_cd=b.tran_cd)
/*select 'e',* from #TAXABLE*/
SELECT distinct cgrp=1,ttran_Cd,
A.ENTRY_TY,a.tran_cd,A.DOC_NO,A.AMT_TY,A.U_CLDT,A.U_RG23NO,A.U_RG23CNO,A.U_PLASR,A.AC_ID,A.Exdate,
AC_NAME1=@AC_NAME1,A.AC_ID1,A.OPBAL1,A.RECEIPT1,A.ISSUE1,A.BALANCE1,
AC_NAME2=@AC_NAME2,A.AC_ID2,A.OPBAL2,A.RECEIPT2,A.ISSUE2,A.BALANCE2,
AC_NAME3=@AC_NAME3,A.AC_ID3,A.OPBAL3,A.RECEIPT3,A.ISSUE3,A.BALANCE3,
AC_NAME4=@AC_NAME4,A.AC_ID4,A.OPBAL4,A.RECEIPT4,A.ISSUE4,A.BALANCE4,
AC_NAME5=@AC_NAME5,A.AC_ID5,A.OPBAL5,A.RECEIPT5,A.ISSUE5,A.BALANCE5,
AC_NAME6=@AC_NAME6,A.AC_ID6,A.OPBAL6,A.RECEIPT6,A.ISSUE6,A.BALANCE6,
AC_NAME7=@AC_NAME7,A.AC_ID7,A.OPBAL7,A.RECEIPT7,A.ISSUE7,A.BALANCE7,
AC_NAME8=@AC_NAME8,A.AC_ID8,A.OPBAL8,A.RECEIPT8,A.ISSUE8,A.BALANCE8,
AC_NAME9=@AC_NAME9,A.AC_ID9,A.OPBAL9,A.RECEIPT9,A.ISSUE9,A.BALANCE9
,ac_mast.ECCNO,ac_mast.DIVISION,ac_mast.RANGE,ac_mast.COLL,party_nm=ac_mast.AC_NAME
--,m1entry_ty=isnull(m1.entry_ty,''),m1tran_Cd=isnull(a.m1tran_Cd,0)
--,inv_no=(case when isnull(m1.inv_no,'')<>'' then m1.inv_no else m.inv_no end)
--,U_PINVNO=isnull(m1.U_PINVNO,''),U_PINVDT=isnull(m1.U_PINVDT,'')
,m.inv_no,m.date,m.u_pinvno,m.u_pinvdt
/*,taxableamt=m1.gro_amt*/
,taxableamt=(case when m.entry_ty in ('BP','CP') then m.gro_amt else T.taxableamt end)
,m.serty,narr=cast(m.narr as varchar(4000))
FROM #ACDET A
--left JOIN stkl_vw_main m on (a.entry_ty=m.entry_ty and a.tran_cd=m.tran_cd)
left JOIN lmain_vw m on (a.entry_ty=m.entry_ty and a.tran_cd=m.tran_cd)
left JOIN AC_MAST  ON (m.AC_id =ac_mast.AC_ID)
LEFT JOIN #TAXABLE T ON (A.ENTRY_TY=T.ENTRY_TY AND A.TRAN_CD=T.TRAN_CD and a.m1entry_ty=t.m1entry_ty and a.m1tran_cd=t.m1tran_cd)
--left join mainall_vw mall on (a.entry_ty=mall.entry_ty and a.tran_cd=mall.tran_cd and a.acserial=mall.acserial)
left join stkl_vw_main m1 on (a.m1entry_ty=m1.entry_ty and a.m1tran_cd=m1.tran_cd)
order by ttran_Cd

DROP TABLE #ACDET1
DROP TABLE #ACDET
drop table #RECEIPT
drop table #TAXABLE
SET QUOTED_IDENTIFIER ON

















