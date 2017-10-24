If Exists(Select [Name] From Sysobjects Where xtype='P' and [name]='Usp_Ent_GetBatchPickupRcrds')
Begin
	Drop Procedure Usp_Ent_GetBatchPickupRcrds
End
Go
-- =============================================
-- Author		: Sachin .N. Sapaliga
-- Create date	: 20/07/2011
-- Description	: This Stored procedure is used in populating Batchwise/Serialize Split Quantity.
-- Modification Date/By/Reason: Shrikant S. on 22/05/2012 for Bug-4064
-- Modification Date/By/Reason: Sachin N. S. on 12/06/2014 for Bug-22228
-- Remark		:
-- =============================================
Create PROCEDURE [Usp_Ent_GetBatchPickupRcrds]
@ITCODE INT, @ENTRY_TY  VARCHAR(2), @DATE SMALLDATETIME, @TRAN_CD INT, @ITSERIAL VARCHAR(5), @RENTRY_TY VARCHAR(2), @ITREF_TRAN INT, @RITSERIAL VARCHAR(5)
AS
DECLARE @SQLCOMMAND NVARCHAR(4000)

SELECT A.RENTRY_TY AS ENTRY_TY, A.RDATE AS DATE, A.RTRAN_CD AS TRAN_CD, A.RINV_NO AS INV_NO, A.RITSERIAL AS ITSERIAL, 
	A.ENTRY_TY AS RENTRY_TY, A.DATE AS RDATE, A.TRAN_CD AS RTRAN_CD, A.ITSERIAL AS RITSERIAL, A.INV_NO AS RINV_NO, 
	A.DC_NO, A.RQTY AS RRQTY, B.* INTO #_TMPIT_SRTRN_A		-- Changed by Sachin N. S. on 11/06/2014 for Bug-22228
--	A.DC_NO, B.* INTO #_TMPIT_SRTRN_A
	FROM IT_SRTRN A
		INNER JOIN IT_SRSTK B ON A.ITRAN_CD = B.ITRAN_CD					--Added By Shrikant S. on 22/05/2012 for Bug-4064
		--INNER JOIN IT_SRSTK B ON A.ITRAN_CD = B.ITRAN_CD AND A.ENTRY_TY=B.INENTRY_TY AND A.TRAN_CD=B.INTRAN_CD AND A.ITSERIAL=B.INITSERIAL		--Commented by Shrikant S. on 22/05/2012 for Bug-4064
		WHERE A.ENTRY_TY=@RENTRY_TY AND A.TRAN_CD=@ITREF_TRAN AND A.ITSERIAL=@RITSERIAL AND 
			A.IT_CODE=@ITCODE 

SELECT A.RENTRY_TY, A.RTRAN_CD, A.RINV_NO, A.RITSERIAL, A.ITRAN_CD, SUM(ISNULL(A.RQTY,0)) AS RQTY INTO #_TMPIT_SRTRN_B
		FROM IT_SRTRN A 
			WHERE A.RENTRY_TY=@RENTRY_TY AND A.RTRAN_CD=@ITREF_TRAN AND A.RITSERIAL=@RITSERIAL AND 
			A.DC_NO='' AND NOT (A.ENTRY_TY=@ENTRY_TY AND A.TRAN_CD=@TRAN_CD AND A.ITSERIAL=@ITSERIAL)		-- Changed by Sachin N. S. on 11/06/2014 for Bug-22228
--			A.DC_NO<>'' AND NOT (A.ENTRY_TY=@ENTRY_TY AND A.TRAN_CD=@TRAN_CD AND A.ITSERIAL=@ITSERIAL)
			GROUP BY A.RENTRY_TY, A.RTRAN_CD, A.RINV_NO, A.RITSERIAL, A.ITRAN_CD


--SELECT A.*, SPACE(1) AS PMKEY, 'A' As Mode, A.QTY*0 AS RQTY, A.QTY-ISNULL(B.RQTY,0) AS BALQTY, DTG_RQTY=A.QTY*0
SELECT A.*, SPACE(1) AS PMKEY, 'A' As Mode, A.QTY*0 AS RQTY, A.RRQTY-ISNULL(B.RQTY,0) AS BALQTY, DTG_RQTY=A.QTY*0		-- Changed by Sachin N. S. on 11/06/2014 for Bug-22228
	FROM #_TMPIT_SRTRN_A A
		LEFT JOIN #_TMPIT_SRTRN_B B ON A.RENTRY_TY=B.RENTRY_TY AND A.RTRAN_CD=B.RTRAN_CD AND 
			A.RINV_NO=B.RINV_NO AND A.RITSERIAL=B.RITSERIAL AND A.ITRAN_CD=B.ITRAN_CD
	



