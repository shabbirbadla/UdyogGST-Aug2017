IF EXISTS(SELECT XTYPE FROM SYSOBJECTS WHERE XTYPE='P' AND name ='USP_ORDER_ZOOM_IN')
BEGIN
 DROP PROCEDURE USP_ORDER_ZOOM_IN
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*:*****************************************************************************
*:       Program: USP BALANCE LISTING
*:        System: UDYOG Software (I) Ltd.
*:    Programmer: RAGHAVENDRA B. JOSHI
*: Last modified: 19/11/2009
*:		AIM		: Order Zoom-In Report
**:******************************************************************************
*: Changes done on 19/11/2009 : Rateunit Column added
Modified by :Shrikant S. on 31/05/2013 for Bug-548
Modified by :Sumit Gavate. on 16/02/2016 for Bug - 26995
**:******************************************************************************/
CREATE PROCEDURE [dbo].[USP_ORDER_ZOOM_IN]
 @TMPAC NVARCHAR(50),@TMPIT NVARCHAR(50),@SPLCOND VARCHAR(8000)
,@SDATE SMALLDATETIME,@EDATE SMALLDATETIME
,@SAC AS VARCHAR(60),@EAC AS VARCHAR(60)
,@SIT AS VARCHAR(60),@EIT AS VARCHAR(60),@SAMT FLOAT
,@EAMT FLOAT,@SDEPT AS VARCHAR(60),@EDEPT AS VARCHAR(60)
,@SCATE AS VARCHAR(60),@ECATE AS VARCHAR(60)
,@SWARE AS VARCHAR(60),@EWARE AS VARCHAR(60)
,@SINV_SR AS VARCHAR(60),@EINV_SR AS VARCHAR(60)
,@LYN VARCHAR(20),@ReportType As Varchar(2)
,@ZoomType As Varchar(1),@C_St_Date SmalldateTime
,@XTRAFLDS VARCHAR(8000)
AS
IF @ZoomType IS NULL OR @ZoomType = ''
BEGIN 
	RAISERROR ('Please Pass Zoom Type...', 16,1) 
	Return 
END

IF @ReportType IS NULL OR @ReportType = ''
BEGIN 
	RAISERROR ('Please Pass Report Type...', 16,1) 
	Return 
END

/* Internale Variable declaration and Assigning [Start] */
DECLARE @Balance Numeric(17,2),@TBLNM VARCHAR(50),@TBLNAME1 Varchar(50),
	@TBLNAME2 Varchar(50),@TBLNAME3 Varchar(50),@TBLNAME4 Varchar(50),
	@SQLCOMMAND as NVARCHAR(4000),@PrimaryFld As Int,@Stop_Loop Bit,
	@ParmDefinition nvarchar(500),@LevelCode Int,@CaseSQL nvarchar(500),
	@Expand Bit

SELECT @ParmDefinition = '',@CaseSQL = '',@Expand = 1
DECLARE @FCON as NVARCHAR(2000),@VSAMT DECIMAL(14,2),@VEAMT DECIMAL(14,2),@nLength Int

SELECT @TBLNM = (SELECT substring(rtrim(ltrim(str(RAND( (DATEPART(mm, GETDATE()) * 100000 )
		+ (DATEPART(ss, GETDATE()) * 1000 )+ DATEPART(ms, GETDATE())) , 20,15))),3,20) as No),
		@Balance = 0,@SQLCOMMAND = ''

SELECT @nLength = COLUMNPROPERTY(Object_Id('ORDZM_VW_ITREF'),'RItserial','Precision')
SELECT @TBLNAME1 = '##TMP1'+@TBLNM,@TBLNAME2 = '##TMP2'+@TBLNM
SELECT @TBLNAME3 = '##TMP3'+@TBLNM,@TBLNAME4 = '##TMP4'+@TBLNM
/* Internale Variable declaration and Assigning [End] */

/* Standard Condition String Maker [Start] */
EXECUTE USP_REP_FILTCON @VTMPAC =@TMPAC,@VTMPIT =@TMPIT,@VSPLCOND =@SPLCOND
	,@VSDATE=@SDATE,@VEDATE=@EDATE,@VSAC =@SAC,@VEAC =@EAC,@VSIT=@SIT,@VEIT=@EIT
	,@VSAMT=@SAMT,@VEAMT=@EAMT,@VSDEPT=@SDEPT,@VEDEPT=@EDEPT,@VSCATE =@SCATE,@VECATE =@ECATE
	,@VSWARE =@SWARE,@VEWARE  =@EWARE,@VSINV_SR =@SINV_SR,@VEINV_SR =@SINV_SR
	,@VMAINFILE='d',@VITFILE='a',@VACFILE=' ',@VDTFLD ='DATE',@VLYN=NULL
	,@VEXPARA=NULL,@VFCON=@FCON OUTPUT
SELECT @FCON = CASE WHEN @FCON IS NULL THEN 'WHERE 1 = 2' ELSE @FCON END
/* Standard Condition String Maker [End] */

/* Main Table Creation [Start] */
IF @ZoomType = 'I'				/* Itemwise */
BEGIN
	-- Modified by :Sumit Gavate. on 16/02/2016 for Bug - 26995 ** Start **
	SET @SQLCOMMAND = 'SELECT A.*,ISNULL(ROUND(((A.Qty * A.TOT_ADD_CHRGS) / B.Sum_QTY),2) + A.Gro_amt,0) as Amount,
		ISNULL((((A.Qty * A.TOT_ADD_CHRGS / B.Sum_QTY)) + A.Gro_amt) / A.Qty,0) as RRate INTO '+@TBLNAME1+' FROM 
		(Select a.Entry_Ty+Space(1)+CONVERT(VARCHAR(20),a.Tran_Cd)+Space(1)+a.itserial As ETI,a.Entry_Ty As rentry_ty,
		a.Tran_cd As Itref_Tran,a.itserial As Ritserial,a.Entry_Ty,a.Date,a.Tran_cd,a.itserial,a.Cate,a.Dept,a.INV_SR,a.Party_nm,
		a.Item,a.Qty,a.Rate,it_mast.rateunit,1 As levelcode,00 As sublevel,a.Inv_no,ISNULL(a.gro_amt,0) as Gro_amt,
		ISNULL((SOH.Tot_tax + SOH.Tot_nontax + SOH.tot_add) - (SOH.Tot_fdisc + SOH.Tot_deduc),0) as TOT_ADD_CHRGS'+@XTRAFLDS+' FROM Ordzm_vw_Item a 
		JOIN Ordzm_vw_Main d On (a.Entry_Ty = d.Entry_Ty And a.Tran_cd = d.Tran_cd) JOIN '
	SET @SQLCOMMAND = @SQLCOMMAND + RTRIM(LTRIM(@ReportType))
	SET @SQLCOMMAND = @SQLCOMMAND + 'MAIN SOH On (a.Entry_Ty = SOH.Entry_Ty And a.Tran_cd = SOH.Tran_cd) JOIN AC_MAST  On (AC_MAST.Ac_id = d.ac_Id)
		JOIN IT_MAST  On (IT_MAST.IT_CODE = a.IT_CODE)'
	SET @SQLCOMMAND = @SQLCOMMAND+@FCON
	SET @SQLCOMMAND = @SQLCOMMAND+' AND a.Entry_Ty In (Select Entry_Ty From LCode Where (Entry_Ty = '+CHAR(39)+@ReportType+CHAR(39)+'))) A INNER JOIN'
	SET @SQLCOMMAND = @SQLCOMMAND+' (SELECT Tran_cd,Entry_ty,ISNULL(SUM(qty),0) as Sum_qty from Ordzm_vw_Item WHERE Entry_Ty = '+CHAR(39)+@ReportType+CHAR(39)
	SET @SQLCOMMAND = @SQLCOMMAND+' GROUP BY Tran_cd,Entry_ty) B on (A.rentry_ty = B.Entry_ty AND A.TRAN_CD = B.TRAN_CD) '
	-- Modified by :Sumit Gavate. on 16/02/2016 for Bug - 26995 ** End **
	EXEC Sp_executeSQL @SQLCOMMAND
END

IF  @ZoomType = 'P'				/* Party wise */
BEGIN
	SELECT @ParmDefinition = N'@nLength Int'

	SET @SQLCOMMAND = 'SELECT a.Entry_Ty,a.Tran_cd,Sum(a.Qty) as Qty
		INTO '+@TBLNAME2+' FROM Ordzm_vw_Item a
		JOIN Ordzm_vw_Main d On (a.Entry_Ty = d.Entry_Ty And a.Tran_cd = d.Tran_cd)
		JOIN AC_MAST  On (AC_MAST.AC_ID = d.AC_ID)
		JOIN IT_MAST  On (IT_MAST.IT_CODE = a.IT_CODE)'
		SET @SQLCOMMAND = @SQLCOMMAND+@FCON
		SET @SQLCOMMAND = @SQLCOMMAND+' AND a.Entry_Ty In (Select Entry_Ty From LCode Where (Entry_Ty = '+CHAR(39)+@ReportType+CHAR(39)+'))'
		SET @SQLCOMMAND = @SQLCOMMAND+' GROUP BY a.Entry_Ty,a.Tran_cd'
		EXEC Sp_executeSQL @SQLCOMMAND

	SET @SQLCOMMAND = 'Select a.Entry_Ty+Space(1)+CONVERT(VARCHAR(20),a.Tran_Cd)+Space(1)+Space(@nLength) As ETI,
		a.Entry_Ty As rentry_ty,a.Tran_cd As Itref_Tran,Space(5) As Ritserial,
		a.Entry_Ty,d.Date,a.Tran_cd,Space(5) as itserial,d.Cate,d.Dept,d.INV_SR,d.Party_nm,
		SPACE(50) as Item,a.Qty,0 as Rate,space(10) as Rateunit,1 As levelcode,00 As sublevel,d.Inv_no'+@XTRAFLDS+'
		INTO '+@TBLNAME1+' FROM '+@TBLNAME2+' a
		JOIN Ordzm_vw_Main d On (a.Entry_Ty = d.Entry_Ty And a.Tran_cd = d.Tran_cd)'
	EXEC Sp_executeSQL @SQLCOMMAND,@ParmDefinition,@nLength = @nLength


	SET @SQLCOMMAND = 'DROP TABLE '+@TBLNAME2
	EXECUTE sp_executesql @SQLCOMMAND

END
/* Main Table Creation [Start] */

/* Find Sub Level Records and Insert That Into Final Temp Table [Start] */
SELECT @ParmDefinition = N'@nLength Int, @LevelCode Int'
SELECT @LevelCode = 1,@Stop_Loop = 1
IF  @ZoomType = 'I'				/* Item wise */
BEGIN
	WHILE @Stop_Loop <> 0 
	BEGIN 
		SET @LevelCode = @LevelCode + 1

		SET @SQLCOMMAND = 'SELECT a.ENTRY_TY+SPACE(1)+CONVERT(VARCHAR(10),a.TRAN_CD)+SPACE(1)+a.Itserial as ETI,
			a.Entry_Ty,a.Tran_cd,a.Itserial,a.RENTRY_TY,a.ITREF_TRAN,a.RItserial,
			a.RQty INTO '+@TBLNAME2+' FROM ORDZM_VW_ITREF a WHERE TRAN_CD <> 0 AND a.ITREF_TRAN <> 0
			AND a.RENTRY_TY+SPACE(1)+CONVERT(VARCHAR(10),a.ITREF_TRAN)+SPACE(1)+a.RItserial IN 
				(SELECT ETI FROM '+@TBLNAME1+' )'
		EXECUTE sp_executesql @SQLCOMMAND,@ParmDefinition
				,@nLength = @nLength,@LevelCode = @LevelCode

/* Commented By Shrikant S. on 31/05/2013 for Bug-548		Start */
		--SET @SQLCOMMAND = 'INSERT INTO '+@TBLNAME1+' SELECT e.ETI,e.rentry_ty,e.Itref_Tran,e.RItserial,
		--		e.Entry_Ty,d.Date,e.Tran_cd,e.itserial,d.Cate,d.Dept,d.INV_SR,d.Party_nm,
		--		a.Item,e.RQty as QTY,a.Rate,it_mast.rateunit,@LevelCode As levelcode,
		--		00 As sublevel,d.Inv_no '+@XTRAFLDS+' FROM '+@TBLNAME2+' E
		--		JOIN Ordzm_vw_Main d On (e.Entry_Ty = d.Entry_Ty And e.Tran_cd = d.Tran_cd)
		--		JOIN Ordzm_vw_Item a On (e.Entry_Ty = a.Entry_Ty And e.Tran_cd = a.Tran_cd And e.itserial = a.itserial)
		--		JOIN IT_MAST ON (IT_MAST.IT_CODE = a.IT_CODE)
		--		WHERE e.ETI NOT IN (SELECT ETI FROM '+@TBLNAME1+' )'
		--EXECUTE sp_executesql @SQLCOMMAND,@ParmDefinition
		--		,@nLength = @nLength,@LevelCode = @LevelCode
/* Commented By Shrikant S. on 31/05/2013 for Bug-548		End */

	/* Added By Shrikant S. on 31/05/2013 for Bug-548		Start */
	-- Modified by :Sumit Gavate. on 16/02/2016 for Bug - 26995 ** Start **
		SET @SQLCOMMAND = 'INSERT INTO '+@TBLNAME1+' SELECT e.ETI,e.rentry_ty,e.Itref_Tran,e.RItserial,
			e.Entry_Ty,d.Date,e.Tran_cd,e.itserial,d.Cate,d.Dept,d.INV_SR,d.Party_nm,
			Item=Isnull(a.Item,''''),e.RQty as QTY,Rate=Isnull(a.Rate,0),rateunit=Isnull(it_mast.rateunit,''''),@LevelCode As levelcode,00 As sublevel,
			d.Inv_no,000000.00 as Gro_amt,000000000.00 as TOT_ADD_CHRGS '+@XTRAFLDS+',000000000.00 as Amount,000000.000 as RRate FROM '+@TBLNAME2+' E
			LEFT JOIN Ordzm_vw_Main d On (e.Entry_Ty = d.Entry_Ty And e.Tran_cd = d.Tran_cd)
			LEFT JOIN Ordzm_vw_Item a On (e.Entry_Ty = a.Entry_Ty And e.Tran_cd = a.Tran_cd And e.itserial = a.itserial)
			LEFT JOIN IT_MAST ON (IT_MAST.IT_CODE = a.IT_CODE)
			WHERE e.ETI NOT IN (SELECT ETI FROM '+@TBLNAME1+' )'
	-- Modified by :Sumit Gavate. on 16/02/2016 for Bug - 26995 ** End **
		EXECUTE sp_executesql @SQLCOMMAND,@ParmDefinition
				,@nLength = @nLength,@LevelCode = @LevelCode
	/* Added By Shrikant S. on 31/05/2013 for Bug-548		End */			
		IF @@Rowcount = 0 
		BEGIN	
			SET @Stop_Loop = 0
		END
		SET @SQLCOMMAND = 'DROP TABLE '+@TBLNAME2
		EXECUTE sp_executesql @SQLCOMMAND
	END
END

IF  @ZoomType = 'P'				/* Party wise */
BEGIN
	WHILE @Stop_Loop <> 0 
	BEGIN 
		SET @LevelCode = @LevelCode + 1

		SET @SQLCOMMAND = 'SELECT a.ENTRY_TY+SPACE(1)+CONVERT(VARCHAR(10),a.TRAN_CD)+SPACE(1)+SPACE(@nLength) as ETI,
			a.Entry_Ty,a.Tran_cd,SPACE(@nLength) As Itserial,a.RENTRY_TY,a.ITREF_TRAN,SPACE(@nLength) As RItserial,
			SUM(a.RQty) As RQty INTO '+@TBLNAME2+' FROM ORDZM_VW_ITREF a WHERE TRAN_CD <> 0 AND a.ITREF_TRAN <> 0
			AND a.RENTRY_TY+SPACE(1)+CONVERT(VARCHAR(10),a.ITREF_TRAN)+SPACE(1)+SPACE(@nLength) IN 
				(SELECT ETI FROM '+@TBLNAME1+' ) GROUP BY a.Entry_Ty,a.Tran_cd,a.RENTRY_TY,a.ITREF_TRAN'
		EXECUTE sp_executesql @SQLCOMMAND,@ParmDefinition
				,@nLength = @nLength,@LevelCode = @LevelCode


		SET @SQLCOMMAND = 'INSERT INTO '+@TBLNAME1+' SELECT a.ETI,a.rentry_ty,a.Itref_Tran,a.RItserial,
				a.Entry_Ty,d.Date,a.Tran_cd,a.itserial,d.Cate,d.Dept,d.INV_SR,d.Party_nm,
				SPACE(50) as Item,a.RQty as QTY,0 as Rate,space(10) as rateunit,@LevelCode As levelcode,
				00 As sublevel,d.Inv_no '+@XTRAFLDS+' FROM '+@TBLNAME2+' a
				JOIN Ordzm_vw_Main d On (a.Entry_Ty = d.Entry_Ty And a.Tran_cd = d.Tran_cd)
				WHERE a.ETI NOT IN (SELECT ETI FROM '+@TBLNAME1+' )'
		EXECUTE sp_executesql @SQLCOMMAND,@ParmDefinition
				,@nLength = @nLength,@LevelCode = @LevelCode


		IF @@Rowcount = 0 
		BEGIN	
			SET @Stop_Loop = 0
		END
		SET @SQLCOMMAND = 'DROP TABLE '+@TBLNAME2
		EXECUTE sp_executesql @SQLCOMMAND
	END
END

SET @SQLCOMMAND = 'SELECT CHAR(a.LevelCode+64)+Space(10) As CharLevel,
	a.RENTRY_TY+SPACE(1)+CONVERT(VARCHAR(10),a.ITREF_TRAN)+SPACE(1)+a.RItserial as RFETI,
	a.QTY as RQTY,* INTO '+@TBLNAME2+' FROM '+@TBLNAME1+' a ORDER BY Itref_tran,Item,CharLevel,Date'
EXECUTE sp_executesql @SQLCOMMAND


SET @SQLCOMMAND = 'SELECT a.RFETI,SUM(a.QTY) AS RQTY,COUNT(a.RFETI) as Sublevel INTO '+@TBLNAME3+' 
	FROM '+@TBLNAME2+' a WHERE a.ETI <> a.RFETI GROUP BY a.RFETI'
EXECUTE sp_executesql @SQLCOMMAND

SET @SQLCOMMAND = 'UPDATE '+@TBLNAME2+' SET RQTY = 0
	FROM '+@TBLNAME2+' a'
EXECUTE sp_executesql @SQLCOMMAND


SET @SQLCOMMAND = 'UPDATE '+@TBLNAME2+' SET RQty = b.RQty,Sublevel = b.Sublevel
	FROM '+@TBLNAME2+' a, '+@TBLNAME3+' b WHERE a.ETI = b.RFETI'
EXECUTE sp_executesql @SQLCOMMAND


SELECT @ParmDefinition = N'@Expand Bit'
-- Modified by :Sumit Gavate. on 16/02/2016 for Bug - 26995 ** Start **
SET @SQLCOMMAND = 'SELECT a.*,a.QTY-a.RQty as Balqty,@Expand as Expand,''Y'' as Expanded,
	Space(99) as UnderLevel,Space(1) as RepType,Space(25) as ColorCode,
	a.date as RDate,ISNULL((a.RQty * ROUND(a.RRate,2)),0) as RAmount,ISNULL((a.Qty * ROUND(a.RRate,2)) - (a.RQty * ROUND(a.RRate,2)),0) as BalAmt FROM '+@TBLNAME2+' a'
-- Modified by :Sumit Gavate. on 16/02/2016 for Bug - 26995 ** End **
EXECUTE sp_executesql @SQLCOMMAND,@ParmDefinition,@Expand = @Expand
/* Find Sub Level Records and Insert That Into Final Temp Table [End] */



/* Droping Temp tables [Start] */
SET @SQLCOMMAND = 'DROP TABLE '+@TBLNAME1
EXECUTE sp_executesql @SQLCOMMAND
SET @SQLCOMMAND = 'DROP TABLE '+@TBLNAME2
EXECUTE sp_executesql @SQLCOMMAND
SET @SQLCOMMAND = 'DROP TABLE '+@TBLNAME3
EXECUTE sp_executesql @SQLCOMMAND
/* Droping Temp tables [End] */

