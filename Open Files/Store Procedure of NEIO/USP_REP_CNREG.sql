set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




ALTER PROCEDURE [dbo].[USP_REP_CNREG]  
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

DECLARE @AC_ID NUMERIC(9),@AC_GROUP_ID1 NUMERIC(9),@GNAME1 VARCHAR(60),@AC_GROUP_ID2 NUMERIC(9),@GNAME2 VARCHAR(60),@AC_GROUP_ID3 NUMERIC(9),@GNAME3 VARCHAR(60)
SELECT DISTINCT AC_ID=AC_GROUP_ID,AC_GROUP_ID1=AC_GROUP_ID,AC_GROUP_ID2=AC_GROUP_ID,AC_GROUP_ID3=AC_GROUP_ID,GNAME1=[GROUP],GNAME2=[GROUP],GNAME3=[GROUP] INTO #1JRTMP FROM AC_MAST WHERE 1=2


DECLARE  C1JRTMP CURSOR FOR 
SELECT  DISTINCT AC_ID FROM CNACDET
ORDER BY AC_ID
OPEN C1JRTMP
FETCH NEXT FROM C1JRTMP INTO @AC_ID
WHILE @@FETCH_STATUS=0
BEGIN
	SELECT @AC_GROUP_ID1=AC_GROUP_ID,@GNAME1=[GROUP] FROM AC_MAST WHERE AC_ID=@AC_ID
	SELECT @AC_GROUP_ID2=GAC_ID,@GNAME2=[GROUP] FROM AC_GROUP_MAST WHERE AC_GROUP_ID=@AC_GROUP_ID1
	SELECT @AC_GROUP_ID3=GAC_ID,@GNAME3=[GROUP] FROM AC_GROUP_MAST WHERE AC_GROUP_ID=@AC_GROUP_ID2
	INSERT INTO #1JRTMP ( AC_ID,AC_GROUP_ID1,AC_GROUP_ID2,AC_GROUP_ID3,GNAME1,GNAME2,GNAME3) VALUES (@AC_ID,@AC_GROUP_ID1,@AC_GROUP_ID2,@AC_GROUP_ID3,@GNAME1,@GNAME2,@GNAME3)
	FETCH NEXT FROM C1JRTMP INTO @AC_ID
END
CLOSE C1JRTMP
DEALLOCATE C1JRTMP

SELECT M.TRAN_CD,M.date, A.AC_NAME,M.Date,M.Inv_no,T.gname1 as [Group Level1],T.gname2 as [Group Level2],T.gname3 as [Group Level3]
,M.net_amt ,CONVERT(VARCHAR(2000),M.Narr) AS Narr ,m.dept,m.cate,m.inv_sr
,AC.AC_NAME AS ACDET_NM,AC.AMOUNT AS AC_AMT,AC.AMT_TY  
FROM CNMAIN M 
INNER JOIN CNACDET AC ON (M.ENTRY_TY=AC.ENTRY_TY AND M.TRAN_CD=AC.TRAN_CD)
INNER JOIN AC_MAST A ON (M.AC_ID=A.AC_ID) 
INNER JOIN #1JRTMP T ON (M.AC_ID=T.AC_ID)
WHERE (M.DATE BETWEEN @SDATE AND @EDATE) AND (A.AC_NAME BETWEEN @SAC AND @EAC)
ORDER BY M.DATE,M.TRAN_CD,AC.AMT_TY







