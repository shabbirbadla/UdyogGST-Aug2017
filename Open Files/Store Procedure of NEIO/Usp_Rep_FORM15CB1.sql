If Exists(Select [name] From SysObjects Where xType='P' and [Name]='Usp_Rep_FORM15CB1')
Begin
	Drop Procedure Usp_Rep_FORM15CB1
End
go
-- =============================================
-- Author: Priyanka Himane
-- Create date: 26/12/2011
-- Description:	This Stored procedure is useful to Generate data for Form 15 CB report in Foreign Expenses Document transaction.
-- Modification: Done by Nilesh on 12/08/2014 for Bug 23787
-- =============================================

create  PROCEDURE    [dbo].[Usp_Rep_FORM15CB1]
@ENTRYCOND NVARCHAR(254)
	AS
DECLARE @SQLCOMMAND AS NVARCHAR(4000),@TBLCON AS NVARCHAR(4000)
DECLARE @ENT VARCHAR(2),@TRN INT,@POS1 INT,@POS2 INT,@POS3 INT
		
		PRINT @ENTRYCOND
		SET @POS1=CHARINDEX('''',@ENTRYCOND,1)+1
		SET @ENT= SUBSTRING(@ENTRYCOND,@POS1,2)
		SET @POS2=CHARINDEX('=',@ENTRYCOND,CHARINDEX('''',@ENTRYCOND,@POS1))+1
		SET @POS3=CHARINDEX('=',@ENTRYCOND,CHARINDEX('''',@ENTRYCOND,@POS2))+1
		SET @TRN= SUBSTRING(@ENTRYCOND,@POS2,@POS2-@POS3)
		SET @TBLCON=RTRIM(@ENTRYCOND)
		
PRINT @ENT
PRINT @TRN

--Bug 23787 start
SELECT MAILNAME=(CASE WHEN ISNULL(AC_MAST.MAILNAME,'')='' THEN AC_MAST.AC_NAME ELSE AC_MAST.MAILNAME END),AC_MAST.ADD1,AC_MAST.ADD2,AC_MAST.ADD3,
ac_mast.country,
EPMAIN.fcnet_amt,EPMAIN.net_amt,EPMAIN.U_BANK,EPMAIN.U_BSRCODE,
EPMAIN.U_DT_OF_RE,EPMAIN.U_INAMTTDS, EPMAIN.u_fcamttds,EPMAIN.FCEXRATE,EPMAIN.U_DEDUDATE,
EPMAIN.U_REMNATUR,EPMAIN.U_NETTAX,EPMAIN.U_12,EPMAIN.U_12Ac,EPMAIN.U_12B,
EPMAIN.U_12C,EPMAIN.U_13,EPMAIN.U_13A,EPMAIN.U_13B,EPMAIN.U_13C,EPMAIN.U_13D,EPMAIN.U_14,EPMAIN.U_14A,EPMAIN.U_14B,
EPMAIN.U_14C,EPMAIN.U_15,EPMAIN.U_15A,EPMAIN.U_15B,EPMAIN.U_15C,EPMAIN.U_16CLAU,CURR_MAST.CURRDESC,EPMAIN.U_ITRATE,EPMAIN.U_DTAARATE,EPMAIN.U_CERTNO,EPMAIN.U_CANAME
FROM EPMAIN 
INNER JOIN EPITEM ON EPITEM.TRAN_CD=EPMAIN.TRAN_CD and EPITEM.ENTRY_TY = EPMAIN.ENTRY_TY
LEFT JOIN EPITREF ON EPITEM.TRAN_CD=EPITREF.TRAN_CD and EPITEM.ENTRY_TY = EPITREF.ENTRY_TY and EPITEM.ITSERIAL = EPITREF.ITSERIAL
INNER JOIN AC_MAST ON (AC_MAST.AC_ID=EPMAIN.AC_ID)
INNER JOIN IT_MAST ON (IT_MAST.IT_CODE=EPITEM.IT_CODE)
LEFT JOIN CURR_MAST ON (EPMAIN.FCID=CURR_MAST.CURRENCYID)
WHERE  EPMAIN.ENTRY_TY='FD' and EPMAIN.tran_cd=@TRN
--Bug 23787 End




--Execute Usp_Rep_FORM15CB1 'EPMAIN.ENTRY_TY=''FD'' AND EPMAIN.TRAN_CD=75'