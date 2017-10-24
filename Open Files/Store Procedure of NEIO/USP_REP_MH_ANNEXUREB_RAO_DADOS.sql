If exists(Select * from sysobjects where [name]='USP_REP_MH_ANNEXUREB_RAO_DADOS' and xtype='P')
Begin
	Drop Procedure USP_REP_MH_ANNEXUREB_RAO_DADOS
End
go
-- =============================================
-- Author:		Pankaj M. Borse.
-- Create date: 29-10-2014
-- Description:	this procedure is for Maharashtra VAT Form 704 Annexure A dados report
-- =============================================
CREATE PROCEDURE [dbo].[USP_REP_MH_ANNEXUREB_RAO_DADOS]
@SDATE  SMALLDATETIME,@EDATE SMALLDATETIME
AS
BEGIN
SELECT ROWNO=ROW_NUMBER() OVER (ORDER BY NET_AMT DESC),RAOSNO,NET_AMT,RAODT
INTO #TEMPTBL
FROM JVMAIN  
WHERE ENTRY_TY='J4' AND (RAOSNO<>'' OR RAODT<>'') and VAT_ADJ='' AND PARTY_NM='CST PAYABLE' and (DATE BETWEEN @SDATE AND @EDATE)  ORDER BY NET_AMT DESC

SELECT * INTO #TEMPTBL1 FROM #TEMPTBL WHERE 1=2

IF EXISTS(SELECT ROWNO FROM #TEMPTBL WHERE ROWNO>15)
	BEGIN
		INSERT INTO #TEMPTBL1 SELECT * FROM #TEMPTBL WHERE ROWNO<15
		DELETE FROM #TEMPTBL WHERE ROWNO<15
		INSERT INTO #TEMPTBL1 SELECT 15,'',SUM(NET_AMT),'' FROM #TEMPTBL
		DROP TABLE #TEMPTBL
	END
ELSE
	BEGIN
		INSERT INTO #TEMPTBL1 SELECT * FROM #TEMPTBL 
		DROP TABLE #TEMPTBL
	END

SELECT ROWNO,RAOSNO,NET_AMT,RAODT FROM #TEMPTBL1
DROP TABLE #TEMPTBL1

END
