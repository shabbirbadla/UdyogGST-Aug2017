If Exists(Select [Name] from Sysobjects where xType='P' and Id=Object_Id(N'USP_REP_WORK_ORDER'))
Begin
	Drop Procedure USP_REP_WORK_ORDER
End
Go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

-- =============================================
-- Author:		Lokesh.
-- Create date: 25/04/2012
-- Description:	This Stored procedure is useful to generate Sales vs Purchase details.
-- Modify :by/date/Remark - Chnages done by Sandeep on 19-Aug-2013 for Bug-18724 
-- =============================================

--EXECUTE USP_REP_WORK_ORDER '','','','04/01/2012','03/31/2013','','','','',0,0,'','','','','','','','','2012-2013',''

Create procedure [dbo].[USP_REP_WORK_ORDER]
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
---Added by sandeep on 19-Aug-2013 for Bug-18724-->Start
Declare @FCON as NVARCHAR(2000),@SQLCOMMAND as NVARCHAR(4000)

EXECUTE   USP_REP_FILTCON 

 @VTMPAC =@TMPAC,@VTMPIT =@TMPIT,@VSPLCOND =@SPLCOND
,@VSDATE=@SDATE
,@VEDATE=@EDATE
,@VSAC =@SAC,@VEAC =@EAC
,@VSIT=@SIT,@VEIT=@EIT
,@VSAMT=@SAMT,@VEAMT=@EAMT
,@VSDEPT=@SDEPT,@VEDEPT=@EDEPT
,@VSCATE =@SCATE,@VECATE =@ECATE
,@VSWARE =@SWARE,@VEWARE  =@EWARE
,@VSINV_SR =@SINV_SR,@VEINV_SR =@SINV_SR
,@VMAINFILE='MAIN',@VITFILE='IT_MAST',@VACFILE=NULL
,@VDTFLD ='DATE'
,@VLYN=NULL
,@VEXPARA=@EXPARA
,@VFCON =@FCON OUTPUT
---Added by sandeep on 19-Aug-2013 for Bug-18724-->End 

---Commeted by sandeep on 19-Aug-2013 for Bug-18724-->start
--begin
--SELECT main.TRAN_CD,main.DATE,main.INV_NO,main.[rule],cast(main.narr as varchar(1000)) ,AC_MAST.MAILNAME,
--IT_MAST.[GROUP],item.QTY,
--item.RATE,item.GRO_AMT,item.ITEM,item.batchno,item.bomid FROM main INNER JOIN item ON 
--(main.TRAN_CD=item.TRAN_CD)INNER JOIN AC_MAST ON (AC_MAST.AC_ID=main.AC_ID)
--INNER JOIN IT_MAST ON (IT_MAST.IT_CODE=item.IT_CODE)
--ORDER BY main.DATE,main.INV_NO
--End
---Commeted by sandeep on 19-Aug-2013 for Bug-18724-->End
---Added by sandeep on 19-Aug-2013 for Bug-18724-->Start
SET @SQLCOMMAND='SELECT main.TRAN_CD,main.DATE,main.INV_NO,main.[rule],cast(main.narr as varchar(1000)) ,AC_MAST.MAILNAME,'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+'IT_MAST.[GROUP],item.QTY,item.RATE,item.GRO_AMT,item.ITEM,item.batchno,item.bomid'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+'FROM main '
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+'main INNER JOIN item ON (main.TRAN_CD=item.TRAN_CD)INNER JOIN AC_MAST ON (AC_MAST.AC_ID=main.AC_ID)'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+'INNER JOIN IT_MAST ON (IT_MAST.IT_CODE=item.IT_CODE)'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+RTRIM(@FCON)
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+'ORDER BY main.DATE,main.INV_NO'
--PRINT @SQLCOMMAND
EXECUTE SP_EXECUTESQL @SQLCOMMAND
---Added by sandeep on 19-Aug-2013 for Bug-18724-->End 
