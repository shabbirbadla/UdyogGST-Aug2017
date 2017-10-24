set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go
IF EXISTS(SELECT [NAME] FROM SYS.PROCEDURES WHERE [NAME]='USP_REP_STKRESRN_SRINV_SUBDET_TRACKER')
BEGIN
	DROP PROCEDURE USP_REP_STKRESRN_SRINV_SUBDET_TRACKER
END
GO

--****************************************************************************--
-- Procedure Name :	USP_REP_STKRESRN_SRINV_SUBDET_TRACKER
-- Description	  : Procedure to get the Split Quantity details of the Stock reserved Qty
-- Created By/On/For : Sachin N. S. on 02/04/2014 for Bug-22207
--****************************************************************************--
CREATE PROCEDURE [dbo].[USP_REP_STKRESRN_SRINV_SUBDET_TRACKER]
AS
DECLARE @SQLCOMMAND NVARCHAR(4000)

SET @SQLCOMMAND='SELECT G.CODE_NM,D.DATE,D.PARTY_NM,D.INV_NO,D.ITEM,E.BATCHNO,E.SERIALNO,E.SPLITNO,E.LOTNO,C.RQTY AS ALLOCQTY, '
SET @SQLCOMMAND=@SQLCOMMAND+' '+'ISNULL(F.RQTY,0) AS RQTY,B.ENTRY_TY,B.TRAN_CD,B.ITSERIAL,A.ENTRY_TY+LTRIM(RTRIM(CAST(A.TRAN_CD AS VARCHAR)))+A.ITSERIAL AS FORG_KEY '
SET @SQLCOMMAND=@SQLCOMMAND+' '+'FROM STKRESRVSUM A '
SET @SQLCOMMAND=@SQLCOMMAND+' '+'INNER JOIN STKRESRVDET B ON A.ENTRY_TY=B.RENTRY_TY AND A.TRAN_CD=B.RTRAN_CD AND A.ITSERIAL=B.RITSERIAL '
SET @SQLCOMMAND=@SQLCOMMAND+' '+'INNER JOIN STKRESRVSRTRN C ON B.ENTRY_TY=C.RENTRY_TY AND B.TRAN_CD=C.RTRAN_CD AND B.ITSERIAL=C.RITSERIAL AND B.RENTRY_TY=C.ENTRY_TY AND B.RTRAN_CD=C.TRAN_CD AND B.RITSERIAL=C.ITSERIAL '
SET @SQLCOMMAND=@SQLCOMMAND+' '+'INNER JOIN LITEM_VW D ON B.ENTRY_TY=D.ENTRY_TY AND B.TRAN_CD=D.TRAN_CD AND B.ITSERIAL=D.ITSERIAL '
SET @SQLCOMMAND=@SQLCOMMAND+' '+'INNER JOIN IT_SRSTK E ON C.ITRAN_CD=E.ITRAN_CD '
SET @SQLCOMMAND=@SQLCOMMAND+' '+'LEFT JOIN IT_SRTRN F ON E.ITRAN_CD=F.ITRAN_CD AND F.DC_NO='''' AND A.ENTRY_TY=F.RENTRY_TY AND A.TRAN_CD=F.RTRAN_CD AND A.ITSERIAL=F.RITSERIAL '
SET @SQLCOMMAND=@SQLCOMMAND+' '+'INNER JOIN LCODE G ON C.RENTRY_TY=G.ENTRY_TY '
SET @SQLCOMMAND=@SQLCOMMAND+' '+'ORDER BY D.DATE,D.INV_NO,E.BATCHNO,E.SERIALNO,E.SPLITNO,E.LOTNO '

PRINT @SQLCOMMAND
EXECUTE SP_EXECUTESQL @SQLCOMMAND


