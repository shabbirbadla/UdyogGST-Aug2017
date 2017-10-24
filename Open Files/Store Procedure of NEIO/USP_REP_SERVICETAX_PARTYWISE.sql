If Exists(Select [Name] from Sysobjects where xType='P' and Id=Object_Id(N'USP_REP_SERVICETAX_PARTYWISE'))
Begin
	Drop Procedure USP_REP_SERVICETAX_PARTYWISE
End
Go
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

-- =============================================
-- Author:		Sanjay/Lokesh.
-- Create date: 11/02/2012
-- Description:	This Stored procedure is useful to Service Tax Partywise Report.
-- Modification Date/By/Reason: New report added / 11/02/2012 / Requirement from Adaequare
-- Remark:
-- =============================================
--EXECUTE USP_REP_SERVICETAX_PARTYWISE '','','','07/29/2011','07/29/2011','','','','',0,0,'','','','','','','','','2011-2012',''
CREATE PROCEDURE [dbo].[USP_REP_SERVICETAX_PARTYWISE]  
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
Declare @FCON as NVARCHAR(2000),@SQLCOMMAND as NVARCHAR(4000)

EXECUTE   USP_REP_FILTCON 
@VTMPAC =@TMPAC,@VTMPIT =@TMPIT,@VSPLCOND =@SPLCOND
,@VSDATE=@SDATE,@VEDATE=@EDATE
,@VSAC =@SAC,@VEAC =@EAC
,@VSIT=@SIT,@VEIT=@EIT
,@VSAMT=@SAMT,@VEAMT=@EAMT
,@VSDEPT=@SDEPT,@VEDEPT=@EDEPT
,@VSCATE =@SCATE,@VECATE =@ECATE
,@VSWARE =@SWARE,@VEWARE  =@EWARE
,@VSINV_SR =@SINV_SR,@VEINV_SR =@SINV_SR
,@VMAINFILE='SBMAIN',@VITFILE=Null,@VACFILE=''
,@VDTFLD ='DATE'
,@VLYN=Null
,@VEXPARA=@EXPARA
,@VFCON =@FCON OUTPUT

PRINT @FCON

SET @SQLCOMMAND ='
SELECT BRMALL.ENTRY_ALL,SBMAIN.TRAN_CD,SBMAIN.TRAN_CD,SBMAIN.DATE,SBMAIN.INV_NO,SBMAIN.PARTY_NM,SBMAIN.U_VEHNO,
SBMAIN.[RULE],SBMAIN.CATE,SBMAIN.INV_SR,SBMAIN.TOT_EXAMT,SBMAIN.GRO_AMT,
SBMAIN.NET_AMT,BRMALL.NEW_ALL AS ALLOC_AMT, (SBMAIN.NET_AMT - ISNULL(BRMALL.NEW_ALL,0)) AS BALANCE 
FROM SBMAIN 
INNER JOIN AC_MAST ON (AC_MAST.AC_ID=SBMAIN.AC_ID) 
LEFT JOIN BRMALL ON (SBMAIN.ENTRY_TY=BRMALL.ENTRY_ALL AND SBMAIN.TRAN_CD=BRMALL.MAIN_TRAN)'
 
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+RTRIM(@FCON)

PRINT @SQLCOMMAND 
EXECUTE SP_EXECUTESQL @SQLCOMMAND
