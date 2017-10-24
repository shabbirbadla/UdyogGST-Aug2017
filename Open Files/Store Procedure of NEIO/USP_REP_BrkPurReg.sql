set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

-- =============================================
-- Author:		Ruepesh Prajapati
-- Create date: 03/06/2010
-- Description:	This SP is useful for Brokerwise Purchase Register report.
-- Modification Date/By/Reason:
-- Remark:
-- =============================================
ALTER PROCEDURE [dbo].[USP_REP_BrkPurReg]
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

Declare @FCON as NVARCHAR(2000),@VSAMT DECIMAL(14,2),@VEAMT DECIMAL(14,2)
EXECUTE   USP_REP_FILTCON 
@VTMPAC =@TMPAC,@VTMPIT =@TMPIT,@VSPLCOND =@SPLCOND
,@VSDATE=@sDate
,@VEDATE=@EDATE
,@VSAC =@SAC,@VEAC =@EAC
,@VSIT=@SIT,@VEIT=@EIT
,@VSAMT=@SAMT,@VEAMT=@EAMT
,@VSDEPT=@SDEPT,@VEDEPT=@EDEPT
,@VSCATE =@SCATE,@VECATE =@ECATE
,@VSWARE =@SWARE,@VEWARE  =@EWARE
,@VSINV_SR =@SINV_SR,@VEINV_SR =@SINV_SR
,@VMAINFILE='PTMAIN',@VITFILE='',@VACFILE=''
,@VDTFLD ='DATE'
,@VLYN=NULL
,@VEXPARA=@EXPARA
,@VFCON =@FCON OUTPUT



DECLARE @SQLCOMMAND NVARCHAR(4000),@VCOND NVARCHAR(4000)

set @EXPARA=replace(@EXPARA,'`','''')

SET @SQLCOMMAND='SELECT PTMAIN.INV_NO,PTMAIN.DATE,PTMAIN.U_BROKER,PTMAIN.U_PINVNO,PTMAIN.U_PINVDT,PTMAIN.PARTY_NM,PTMAIN.NET_AMT'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+' FROM PTMAIN '
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+RTRIM(@FCON)
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+RTRIM(@EXPARA)
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' AND isnull(ptmain.u_broker,'''') <> '''' '
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+' Order	By U_BROKER,ptmain.date  '
print @SQLCOMMAND

EXECUTE SP_EXECUTESQL @SQLCOMMAND



