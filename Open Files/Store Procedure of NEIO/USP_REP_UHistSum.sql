set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


-- =============================================
-- Author:		AJAY JAISWAL
-- Create date: 05/05/2010
-- Description:	This is useful for generating User History Date wise and Transaction wise Count (Summary Report)
-- Modify date: 
-- Modified By:  
-- Remark:
-- =============================================

ALTER PROCEDURE [dbo].[USP_REP_UHistSum]
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
Declare @sqlcommand nvarchar(4000)
set @sqlcommand = '
SELECT USERHIST_VW.[USER_NAME],USERHIST_VW.DATE,USERHIST_VW.ENTRY_TY,
COUNT(USERHIST_VW.ENTRY_TY) AS [NO. OF TRANSACTION],LCODE.CODE_NM 
FROM USERHIST_VW 
INNER JOIN LCODE ON USERHIST_VW.ENTRY_TY = LCODE.ENTRY_TY 
WHERE (USERHIST_VW.DATE BETWEEN '''+convert(varchar(50),@sdate)+''' AND '''+convert(varchar(50),@edate)+'''  )'
+@EXPARA+' 
GROUP BY USERHIST_VW.[USER_NAME],USERHIST_VW.DATE,USERHIST_VW.ENTRY_TY,LCODE.CODE_NM 
ORDER BY USERHIST_VW.DATE, LCODE.CODE_NM'

Execute sp_executesql @sqlcommand


