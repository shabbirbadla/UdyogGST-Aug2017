set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


if exists(select * from sysobjects where [name] = 'USP_REP_DAYBOOK_ZOOM')
begin
drop procedure [dbo].[USP_REP_DAYBOOK_ZOOM]
end
go 



-- =============================================
-- Author:		Birendra Prasad
-- Create date: 03/11/2010
-- Description:	This Stored procedure is useful to generate Daybook Zoom In Report.
-- Modify date: 
-- Remark:
-- =============================================

Create PROCEDURE [dbo].[USP_REP_DAYBOOK_ZOOM]
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
SET QUOTED_IDENTIFIER OFF
DECLARE @FCON AS NVARCHAR(2000),@VSAMT DECIMAL(14,4),@VEAMT DECIMAL(14,4)

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
,@VMAINFILE='a',@VITFILE='b',@VACFILE=' '
,@VDTFLD ='DATE'
,@VLYN=@LYN
,@VEXPARA=NULL
,@VFCON =@FCON OUTPUT

DECLARE @SQLCOMMAND NVARCHAR(4000),@VCOND NVARCHAR(1000)


SET @SQLCOMMAND = 'Select distinct a.Date,a.Tran_Cd,a.Entry_ty,a.inv_no,a.inv_sr,a.net_amt,a.u_pinvno'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+ ',d.ac_name,Ac_Name1=d.Ac_Name,Amount=a.net_amt,g.code_nm'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+ ',a.Dept,a.cate' 
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+ 'From Stkl_Vw_Main a '
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+ 'Inner Join Ac_Mast d on (a.Ac_Id=d.Ac_Id)'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+ 'Inner Join Lcode g on (g.ENTRY_TY=a.Entry_ty)'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+ ' WHERE a.Date >= ?_tmpvar.sdate and a.date <= ?_tmpvar.edate'


--SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+ @FCON

--PRINT @FCON
--PRINT @SQLCOMMAND
EXECUTE SP_EXECUTESQL @SQLCOMMAND












