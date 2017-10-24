If Exists (Select [Name] From SysObjects Where xType='P' and [Name]='USP_REP_STKLST_UOM_WISE')
Begin
	Drop Procedure USP_REP_STKLST_UOM_WISE
End
Go
Create PROCEDURE [dbo].[USP_REP_STKLST_UOM_WISE]
	@TMPAC NVARCHAR(60),@TMPIT NVARCHAR(60),@SPLCOND NVARCHAR(500),
	@SDATE SMALLDATETIME,@EDATE SMALLDATETIME,
	@SNAME NVARCHAR(60),@ENAME NVARCHAR(60),
	@SITEM NVARCHAR(60),@EITEM NVARCHAR(60),
	@SAMT NUMERIC,@EAMT NUMERIC,
	@SDEPT NVARCHAR(60),@EDEPT NVARCHAR(60),
	@SCAT NVARCHAR(60),@ECAT NVARCHAR(60),
	@SINVSR NVARCHAR(60),@EINVSR NVARCHAR(60),
	@SWARE NVARCHAR(60),@EWARE NVARCHAR(60),
	@FINYR NVARCHAR(20),@EXTPAR NVARCHAR(60)
	,@SFLDNM VARCHAR(10)
	AS
SET NOCOUNT ON
--Select * from ptmain
Declare @uom_desc as Varchar(100),@len int,@fld_nm varchar(10),@fld_desc Varchar(10),@count int,@stkl_qty Varchar(100)
Declare @FCON as NVARCHAR(4000),@SQLCOMMAND as NVARCHAR(4000)
Declare @OPENTRIES as VARCHAR(50),@OPENTRY_TY as VARCHAR(50)
Declare @TBLNM as VARCHAR(50),@TBLNAME1 as VARCHAR(50),@TBLNAME2 as VARCHAR(50)
	
	Set @OPENTRY_TY = '''OS'''
	Set @TBLNM = (SELECT substring(rtrim(ltrim(str(RAND( (DATEPART(mm, GETDATE()) * 100000 )
					+ (DATEPART(ss, GETDATE()) * 1000 )
					+ DATEPART(ms, GETDATE())) , 20,15))),3,20) as No)
	Set @TBLNAME1 = '##TMP1'+@TBLNM
	Set @TBLNAME2 = '##TMP2'+@TBLNM

--DECLARE openingentry_cursor CURSOR FOR
--		SELECT entry_ty FROM lcode
--		WHERE bcode_nm = 'OS'
--	OPEN openingentry_cursor
--	FETCH NEXT FROM openingentry_cursor into @opentries
--	WHILE @@FETCH_STATUS = 0
--	BEGIN
--	   Set @OPENTRY_TY = @OPENTRY_TY +','''+@opentries+''''
--	   FETCH NEXT FROM openingentry_cursor into @opentries
--	END
--	CLOSE openingentry_cursor
--	DEALLOCATE openingentry_cursor
Select @OPENTRY_TY=@OPENTRY_TY+isnull(substring((Select ', ' +Entry_ty From Lcode Where Bcode_nm='OS' For XML Path('')),2,500),'')


	EXECUTE USP_REP_FILTCON 
		@VTMPAC=null,@VTMPIT=@TMPIT,@VSPLCOND=@SPLCOND,
		@VSDATE=null,@VEDATE=@EDATE,
		@VSAC =null,@VEAC =null,
		@VSIT=@SITEM,@VEIT=@EITEM,
		@VSAMT=null,@VEAMT=null,
		@VSDEPT=@SDEPT,@VEDEPT=@EDEPT,
		@VSCATE =@SCAT,@VECATE =@ECAT,
		@VSWARE =@SWARE,@VEWARE  =@EWARE,
		@VSINV_SR =@SINVSR,@VEINV_SR =@EINVSR,
		@VMAINFILE='STKL_VW_MAIN',@VITFILE='STKL_VW_ITEM',@VACFILE=null,
		@VDTFLD = 'DATE',@VLYN=null,@VEXPARA=@EXTPAR,
		@VFCON =@FCON OUTPUT

select @uom_desc=isnull(uom_desc,'') from vudyog..co_mast where dbname =rtrim(db_name())
Create Table #qty_desc (fld_nm varchar(10),fld_desc varchar(10))
set @len=len(@uom_desc)
set @stkl_qty=''
If @len>0 
Begin
	while @len>0
	Begin
		set @fld_nm=substring(@uom_desc,1,charindex(':',@uom_desc)-1)
		set @uom_desc=substring(@uom_desc,charindex(':',@uom_desc)+1,@len)
		--PRINT @uom_desc
		--print @fld_nm
		if Exists(Select a.[Name] from Syscolumns a Inner Join SysObjects b On (a.Id=b.Id) Where a.[Name]=@fld_nm and b.[Name]='stkl_vw_item')
		Begin
			set @stkl_qty= @stkl_qty +', '+'IVW.'+@fld_nm
		End
		if @len>0 and charindex(';',@uom_desc)=0
		begin
			set @uom_desc=@uom_desc
			set @fld_desc=@uom_desc
			SET @len=0
			
		End
		else
		begin
				set @fld_desc=substring(@uom_desc,1,charindex(';',@uom_desc)-1)
				set @uom_desc=substring(@uom_desc,charindex(';',@uom_desc)+1,@len)
				set @len=len(@uom_desc)
		End
		--print @fld_desc
		insert into #qty_desc values (@fld_nm,@fld_desc)		
	End
End
Else
Begin
	set @stkl_qty=',IVW.QTY'
End
--print @stkl_qty

SELECT  STKL_VW_ITEM.ENTRY_TY,BEH='  ',STKL_VW_ITEM.DATE,STKL_VW_ITEM.DOC_NO,STKL_VW_ITEM.AC_ID,STKL_VW_ITEM.IT_CODE,STKL_VW_ITEM.QTY,STKL_VW_ITEM.U_LQTY,STKL_VW_ITEM.ITSERIAL,STKL_VW_ITEM.PMKEY,IT_MAST.ITGRID,IT_MAST.[GROUP],IT_MAST.IT_NAME,IT_MAST.CHAPNO,IT_MAST.[TYPE],IT_MAST.RATEUNIT,UNIT=IT_MAST.RATEUNIT 
INTO #TITEM FROM STKL_VW_ITEM 
INNER JOIN STKL_VW_MAIN  ON (STKL_VW_ITEM.TRAN_CD=STKL_VW_MAIN.TRAN_CD )
INNER JOIN IT_MAST  ON (IT_MAST.IT_CODE=STKL_VW_ITEM.IT_CODE)
INNER JOIN AC_MAST  ON (AC_MAST.AC_ID=STKL_VW_MAIN.AC_ID)
INNER JOIN LCODE  ON (STKL_VW_ITEM.ENTRY_TY=LCODE.ENTRY_TY)
WHERE 1=2

	Select @count=count(*) from #qty_desc
	set @Fld_nm='Qty'
	set @len=0
IF @count>0
Begin
	While @count>0
	Begin
		Select @fld_desc=fld_desc from #qty_desc where fld_nm=@fld_nm	
		--print @fld_desc
		SET @SQLCOMMAND = ''
		SET @SQLCOMMAND='INSERT INTO  #TITEM SELECT  STKL_VW_ITEM.ENTRY_TY,BEH=(CASE WHEN LCODE.EXT_VOU=1 THEN LCODE.BCODE_NM ELSE LCODE.ENTRY_TY END),STKL_VW_ITEM.DATE,STKL_VW_ITEM.DOC_NO,STKL_VW_ITEM.AC_ID,STKL_VW_ITEM.IT_CODE,STKL_VW_ITEM.'+@fld_nm+',STKL_VW_ITEM.U_LQTY,STKL_VW_ITEM.ITSERIAL,STKL_VW_ITEM.PMKEY,IT_MAST.ITGRID,IT_MAST.[GROUP],IT_MAST.IT_NAME,IT_MAST.CHAPNO,IT_MAST.TYPE,IT_MAST.RATEUNIT ,UNIT='''+@fld_desc+''' '
		SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+'  FROM STKL_VW_ITEM '
		SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+' INNER JOIN STKL_VW_MAIN  ON (STKL_VW_ITEM.TRAN_CD=STKL_VW_MAIN.TRAN_CD AND STKL_VW_ITEM.ENTRY_TY=STKL_VW_MAIN.ENTRY_TY)'
		SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+' INNER JOIN IT_MAST  ON (IT_MAST.IT_CODE=STKL_VW_ITEM.IT_CODE)'
		SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+' INNER JOIN AC_MAST  ON (AC_MAST.AC_ID=STKL_VW_MAIN.AC_ID)'
		SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+' INNER JOIN LCODE  ON (STKL_VW_ITEM.ENTRY_TY=LCODE.ENTRY_TY)'
		SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+RTRIM(@FCON)
		--SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+' AND NONSTK='+CHAR(39)+'Stockable'+CHAR(39) check it from Special Conditions
		SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+' AND STKL_VW_MAIN.APGEN='+CHAR(39)+'YES'+CHAR(39)
		SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+' AND STKL_VW_ITEM.DC_NO='+CHAR(39)+' '+CHAR(39)
		PRINT @SQLCOMMAND
		EXECUTE SP_EXECUTESQL @SQLCOMMAND	

		set @len=@len + 1
		set @Fld_nm='Qty'+CONVERT(VARCHAR(2),@len)
		set @count=@count-1
	End
End
Else
Begin
		SET @SQLCOMMAND = ''
		SET @SQLCOMMAND='INSERT INTO  #TITEM SELECT  STKL_VW_ITEM.ENTRY_TY,BEH=(CASE WHEN LCODE.EXT_VOU=1 THEN LCODE.BCODE_NM ELSE LCODE.ENTRY_TY END),STKL_VW_ITEM.DATE,STKL_VW_ITEM.DOC_NO,STKL_VW_ITEM.AC_ID,STKL_VW_ITEM.IT_CODE,STKL_VW_ITEM.'+@fld_nm+',STKL_VW_ITEM.U_LQTY,STKL_VW_ITEM.ITSERIAL,STKL_VW_ITEM.PMKEY,IT_MAST.ITGRID,IT_MAST.[GROUP],IT_MAST.IT_NAME,IT_MAST.CHAPNO,IT_MAST.TYPE,IT_MAST.RATEUNIT ,UNIT=it_mast.rateunit '
		SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+'  FROM STKL_VW_ITEM '
		SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+' INNER JOIN STKL_VW_MAIN  ON (STKL_VW_ITEM.TRAN_CD=STKL_VW_MAIN.TRAN_CD AND STKL_VW_ITEM.ENTRY_TY=STKL_VW_MAIN.ENTRY_TY)'
		SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+' INNER JOIN IT_MAST  ON (IT_MAST.IT_CODE=STKL_VW_ITEM.IT_CODE)'
		SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+' INNER JOIN AC_MAST  ON (AC_MAST.AC_ID=STKL_VW_MAIN.AC_ID)'
		SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+' INNER JOIN LCODE  ON (STKL_VW_ITEM.ENTRY_TY=LCODE.ENTRY_TY)'
		SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+RTRIM(@FCON)
		--SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+' AND NONSTK='+CHAR(39)+'Stockable'+CHAR(39) check it from Special Conditions
		SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+' AND STKL_VW_MAIN.APGEN='+CHAR(39)+'YES'+CHAR(39)
		SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+' AND STKL_VW_ITEM.DC_NO='+CHAR(39)+' '+CHAR(39)
		PRINT @SQLCOMMAND
		EXECUTE SP_EXECUTESQL @SQLCOMMAND	

End 

SET @SQLCOMMAND='SELECT DESCRIPTION=A.'+@SFLDNM+',A.RATEUNIT,A.UNIT'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+',OPBAL =SUM(CASE WHEN (A.BEH ='+'''OS'''+' OR A.DATE<'+CHAR(39)+CAST(@SDATE AS VARCHAR)+CHAR(39)+') THEN (CASE WHEN A.PMKEY='+'''+'''+' THEN A.QTY ELSE -A.QTY END) ELSE 0 END)'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+',RQTY_PT =SUM(CASE WHEN A.BEH ='+'''PT'''+' AND A.PMKEY='+'''+'''+' AND A.DATE>='+CHAR(39)+CAST(@SDATE AS VARCHAR)+CHAR(39)+' THEN A.QTY ELSE 0 END)'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+',RQTY_OP=SUM(CASE WHEN A.BEH ='+'''OP'''+' AND A.PMKEY='+'''+'''+' AND A.DATE>='+CHAR(39)+CAST(@SDATE AS VARCHAR)+CHAR(39)+' THEN A.QTY ELSE 0 END)'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+',RQTY_IR=SUM(CASE WHEN A.BEH ='+'''IR'''+' AND A.PMKEY='+'''+'''+' AND A.DATE>='+CHAR(39)+CAST(@SDATE AS VARCHAR)+CHAR(39)+' THEN A.QTY ELSE 0 END)'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+',RQTY_SR=SUM(CASE WHEN A.BEH ='+'''SR'''+' AND A.PMKEY='+'''+'''+' AND A.DATE>='+CHAR(39)+CAST(@SDATE AS VARCHAR)+CHAR(39)+' THEN A.QTY ELSE 0 END)'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+',RQTY_AR=SUM(CASE WHEN A.BEH ='+'''AR'''+' AND A.PMKEY='+'''+'''+' AND A.DATE>='+CHAR(39)+CAST(@SDATE AS VARCHAR)+CHAR(39)+' THEN A.QTY ELSE 0 END)'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+',RQTY_OT=SUM(CASE WHEN A.BEH NOT IN ('+'''OS'''+','+'''PT'''+','+'''OP'''+','+'''IR'''+','+'''SR'''+','+'''AR'''+') AND A.PMKEY='+'''+'''+' AND A.DATE>='+CHAR(39)+CAST(@SDATE AS VARCHAR)+CHAR(39)+' THEN A.QTY ELSE 0 END)'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+',IQTY_ST=SUM(CASE WHEN A.BEH ='+'''ST'''+' AND A.PMKEY='+'''-'''+' AND A.DATE>='+CHAR(39)+CAST(@SDATE AS VARCHAR)+CHAR(39) +'THEN A.QTY ELSE 0 END)'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+',IQTY_IP=SUM(CASE WHEN A.BEH ='+'''IP'''+' AND A.PMKEY='+'''-'''+' AND A.DATE>='+CHAR(39)+CAST(@SDATE AS VARCHAR)+CHAR(39)+' THEN A.QTY ELSE 0 END)'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+',IQTY_II=SUM(CASE WHEN A.BEH ='+'''II'''+' AND A.PMKEY='+'''-'''+' AND A.DATE>='+CHAR(39)+CAST(@SDATE AS VARCHAR)+CHAR(39)+' THEN A.QTY ELSE 0 END)'
SET	@SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+',IQTY_PR=SUM(CASE WHEN A.BEH ='+'''PR'''+' AND A.PMKEY='+'''-'''+' AND A.DATE>='+CHAR(39)+CAST(@SDATE AS VARCHAR)+CHAR(39)+' THEN A.QTY ELSE 0 END)'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+',IQTY_OT=SUM(CASE WHEN A.BEH NOT IN ('+'''ST'''+','+'''IP'''+','+'''II'''+','+'''PR'''+') AND A.PMKEY='+'''-'''+' AND A.DATE>='+CHAR(39)+CAST(@SDATE AS VARCHAR)+CHAR(39)+' THEN A.QTY ELSE 0 END)'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+',CLBAL =SUM(CASE WHEN  A.PMKEY='+'''+'''+' THEN A.QTY ELSE -A.QTY END)'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+'  FROM #TITEM A'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+'  GROUP BY A.'+@SFLDNM+',A.UNIT,A.RATEUNIT'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+'  ORDER BY A.'+@SFLDNM+',A.UNIT,A.RATEUNIT'
PRINT @SQLCOMMAND
EXECUTE SP_EXECUTESQL @SQLCOMMAND

DROP TABLE #qty_desc

