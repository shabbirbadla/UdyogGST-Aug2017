IF EXISTS(SELECT XTYPE,NAME FROM SYSOBJECTS WHERE XTYPE='P' AND name ='USP_REP_UP_ANNEXURE_E')
BEGIN
	DROP PROCEDURE USP_REP_UP_ANNEXURE_E
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--EXECUTE USP_REP_UP_ANNEXURE_E'','','','04/01/2015','03/31/2016','','','','',0,0,'','','','','','','','','2015-2016',''

-- =============================================
-- Author:		Sumit S Gavate
-- Create date: 29/08/2015
--modify by : Suraj Kumawat
--modifyed date : 07-09-2015

-- Description:	This Stored procedure is useful to generate VAT Annexure - E For Utter Pradesh
-- =============================================
CREATE PROCEDURE [dbo].[USP_REP_UP_ANNEXURE_E]
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

BEGIN
DECLARE @FCON AS NVARCHAR(2000)
EXECUTE   USP_REP_FILTCON 

@VTMPAC =@TMPAC,@VTMPIT =@TMPIT,@VSPLCOND =@SPLCOND
,@VSDATE=NULL,@VEDATE=@EDATE
,@VSAC =@SAC,@VEAC =@EAC
,@VSIT=@SIT,@VEIT=@EIT
,@VSAMT=@SAMT,@VEAMT=@EAMT
,@VSDEPT=@SDEPT,@VEDEPT=@EDEPT
,@VSCATE =@SCATE,@VECATE =@ECATE
,@VSWARE =@SWARE,@VEWARE  =@EWARE
,@VSINV_SR =@SINV_SR,@VEINV_SR =@SINV_SR
,@VMAINFILE='M',@VITFILE=Null,@VACFILE='AC'
,@VDTFLD ='DATE'
,@VLYN=Null
,@VEXPARA=@EXPARA
,@VFCON =@FCON OUTPUT

-------Temporary Cursor
----SELECT PART=3,PARTSR='AAA',SRNO='AAA'
----,party_nm =AC1.AC_NAME,tin=AC1.S_TAX,ADDRESS=Ltrim(AC1.Add1)+' '+Ltrim(AC1.Add2)+' '+Ltrim(AC1.Add3),
----AC1.STATE,M.u_pono,M.u_podt,M.u_chalno,M.u_chaldt,item=space(250),qty=m.net_amt,value=m.net_amt,
----ordno=m.inv_no,orddt=m.date,portnm=SPACE(250),m.u_vehno,prfno =m.inv_no,prfdate=m.date,tqty=m.net_amt,
----tvalue=m.net_amt


----INTO #AnnexE
----FROM PTACDET A 
----INNER JOIN STMAIN M ON (A.ENTRY_TY=M.ENTRY_TY AND A.TRAN_CD=M.TRAN_CD)
----INNER JOIN STAX_MAS STM ON (M.TAX_NAME=STM.TAX_NAME)
----INNER JOIN AC_MAST AC ON (A.AC_NAME=AC.AC_NAME)
----INNER JOIN AC_MAST AC1 ON (M.AC_ID=AC1.AC_ID)
----WHERE 1=2

Declare @MultiCo	VarChar(3)
Declare @MCON as NVARCHAR(2000)
--IF Exists(Select A.ID From SysObjects A Inner Join SysColumns B On(A.ID = B.ID) Where A.[Name] = 'STMAIN' And B.[Name] = 'DBNAME')
--	Begin	------Fetch Records from Multi Co. Data
--		 Set @MultiCo = 'YES'
--		 EXECUTE USP_REP_MULTI_CO_DATA
		 
--	End
--else
--	Begin ------Fetch Single Co. Data
		 Set @MultiCo = 'NO'
		 EXECUTE USP_REP_SINGLE_CO_DATA_VAT
		  @TMPAC, @TMPIT, @SPLCOND, @SDATE, @EDATE
		 ,@SAC, @EAC, @SIT, @EIT, @SAMT, @EAMT
		 ,@SDEPT, @EDEPT, @SCATE, @ECATE,@SWARE
		 ,@EWARE, @SINV_SR, @EINV_SR, @LYN, @EXPARA
		 ,@MFCON = @MCON OUTPUT
	--End
-----

----- PART 1
--INSERT INTO #AnnexE (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,INV_NO,DATE,S_INV_NO,S_DATE,PARTY_NM,S_TAX,ADDRESS,STATE,ITEM,Qty,FORM_NM) 
--SELECT 1,'1','A',A.PER,A.VATONAMT, A.TAXAMT, (A.VATONAMT+A.TAXAMT), A.INV_NO, A.DATE,PM.u_pinvno,PM.u_pinvdt, 
--A.AC_NAME, A.S_TAX, A.ADDRESS,AC.State,CASE WHEN CAST(I.IT_DESC AS VARCHAR(150)) <> '' THEN I.IT_DESC ELSE I.IT_NAME END , P.QTY, I.HSNCODE
--FROM VATTBL A
--INNER JOIN PTITEM P ON (P.ENTRY_TY = A.BHENT AND P.TRAN_CD = A.TRAN_CD AND P.IT_CODE = A.IT_CODE AND P.itserial = A.ItSerial)
--INNER JOIN PTMAIN PM ON (PM.entry_ty = A.BHENT AND PM.Tran_cd = A.TRAN_CD AND PM.entry_ty = P.entry_ty AND PM.Tran_cd = P.Tran_cd)
--INNER JOIN IT_MAST I ON (I.IT_CODE = P.IT_CODE AND I.It_code = A.It_code)
--INNER JOIN AC_Mast AC On (A.AC_ID = AC.Ac_id AND A.AC_ID = PM.Ac_id  AND A.Ac_id = P.AC_ID)
--WHERE A.BHENT IN ('PT') AND LTRIM(RTRIM(REPLACE(REPLACE(A.FORM_NM,'-',''),'FORM','')))='H'  --A.TAX_NAME = 'FORM H' 
--AND (A.DATE BETWEEN @SDATE AND @EDATE) ORDER BY a.INV_NO

-------------------------------------------------------------------------------------------------------------
--DECLARE @RCOUNT INT
--SELECT @RCOUNT = 0
--SET @RCOUNT = (SELECT COUNT(*) FROM #AnnexE WHERE PARTSR='1')
--IF (@RCOUNT=0)
--	INSERT INTO #AnnexE (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,party_nm,qty) VALUES (1,'1','A',0,0,0,0,'',0)

------- PART 2
--INSERT INTO #AnnexE (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,INV_NO,DATE,S_INV_NO,S_DATE,PARTY_NM,S_TAX,ADDRESS,STATE,ITEM,Qty,FORM_NM) 
--SELECT 1,'2','A',A.PER,A.VATONAMT, A.TAXAMT, (A.VATONAMT+A.TAXAMT), A.INV_NO, A.DATE,
--EI.U_LRNO,
--EI.U_LRDT,
--A.AC_NAME, A.S_TAX, EI.U_TRANSNM,EI.u_vehno,CASE WHEN CAST(I.IT_DESC AS VARCHAR(150)) <> '' THEN I.IT_DESC ELSE I.IT_NAME END , E.QTY, I.HSNCODE
--FROM VATTBL A
--INNER JOIN PTITEM E ON (E.ENTRY_TY = A.BHENT AND E.TRAN_CD = A.TRAN_CD AND E.IT_CODE = A.IT_CODE AND E.itserial = A.ItSerial)
--INNER JOIN PTMAIN EI ON (EI.entry_ty = A.BHENT AND EI.Tran_cd = A.TRAN_CD AND EI.entry_ty = E.entry_ty AND EI.Tran_cd = E.Tran_cd)
--INNER JOIN IT_MAST I ON (I.IT_CODE = E.IT_CODE AND I.It_code = A.It_code)
--INNER JOIN AC_Mast AC On (A.AC_ID = AC.Ac_id AND A.AC_ID = EI.Ac_id  AND A.Ac_id = E.AC_ID)
--WHERE A.BHENT IN ('P1') AND (A.DATE BETWEEN @SDATE AND @EDATE) AND LTRIM(RTRIM(REPLACE(REPLACE(A.FORM_NM,'-',''),'FORM','')))='H'  ORDER BY a.INV_NO

----SELECT 1,'2','A',A.PER,A.VATONAMT, A.TAXAMT, (A.VATONAMT+A.TAXAMT), A.INV_NO, A.DATE,
----CASE WHEN CAST(EI.Rail_Recno AS VARCHAR(150)) <> '' THEN EI.Rail_Recno ELSE EI.Lorr_recno END,
----CASE WHEN CAST(EI.Rail_Recno AS VARCHAR(150)) <> '' THEN EI.Rail_Recdt ELSE EI.lorr_recdt END,
----A.AC_NAME, A.S_TAX, EI.U_Port,EI.U_Deli,CASE WHEN CAST(I.IT_DESC AS VARCHAR(150)) <> '' THEN I.IT_DESC ELSE I.IT_NAME END , E.QTY, I.HSNCODE
----FROM VATTBL A
----INNER JOIN STITEM E ON (E.ENTRY_TY = A.BHENT AND E.TRAN_CD = A.TRAN_CD AND E.IT_CODE = A.IT_CODE AND E.itserial = A.ItSerial)
----INNER JOIN STMAIN EI ON (EI.entry_ty = A.BHENT AND EI.Tran_cd = A.TRAN_CD AND EI.entry_ty = E.entry_ty AND EI.Tran_cd = E.Tran_cd)
----INNER JOIN IT_MAST I ON (I.IT_CODE = E.IT_CODE AND I.It_code = A.It_code)
----INNER JOIN AC_Mast AC On (A.AC_ID = AC.Ac_id AND A.AC_ID = EI.Ac_id  AND A.Ac_id = E.AC_ID)
----WHERE A.BHENT IN ('EI') AND (A.DATE BETWEEN @SDATE AND @EDATE) ORDER BY a.INV_NO

-------------------------------------------------------------------------------------------------------------
--DECLARE @RCOUNT1 INT
--SELECT @RCOUNT1 = 0
--SET @RCOUNT1 = (SELECT COUNT(*) FROM #AnnexE WHERE PARTSR='2')
--IF (@RCOUNT1=0)
--	INSERT INTO #AnnexE (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,party_nm,qty) VALUES (1,'2','A',0,0,0,0,'',0)

--Update #AnnexE set  PART = isnull(Part,0) , Partsr = isnull(PARTSR,''), SRNO = isnull(SRNO,''),
--             RATE = isnull(RATE,0), AMT1 = isnull(AMT1,0), AMT2 = isnull(AMT2,0), 
--			 AMT3 = isnull(AMT3,0), INV_NO = isnull(INV_NO,''), DATE = isnull(Date,''), 
--		at	 PARTY_NM = isnull(Party_nm,''), ADDRESS = isnull(Address,''),
--			 FORM_NM = isnull(form_nm,''), S_TAX = isnull(S_tax,''), Qty = isnull(Qty,0),  ITEM =isnull(item,'')


---SELECT * FROM #AnnexE order by cast(substring(partsr,1,case when (isnumeric(substring(partsr,1,2))=1) then 2 else 1 end) as int)
--SELECT  '1' as PARTSR,C.AC_NAME,A.s_tax,A.address,C.state,B.u_pono,B.u_podt,B.U_PINVNO,B.U_PINVDT,E.IT_NAME,D.qty,A.gro_amt
-- FROM VATTBL  A INNER JOIN PTMAIN B ON( A.TRAN_CD =B.TRAN_CD AND A.BHENT=B.ENTRY_TY)  
--LEFT OUTER JOIN AC_MAST C ON B.AC_ID=C.AC_ID
--LEFT OUTER JOIN PTITEM D ON (A.IT_CODE =D.IT_CODE AND A.TRAN_CD=D.TRAN_CD AND A.BHENT=D.ENTRY_TY AND A.ITSERIAL=D.ITSERIAL)
--INNER JOIN IT_MAST E ON( D.IT_CODE=E.IT_CODE)
--WHERE A.BHENT='PT' AND A.U_IMPORM IN('High Seas Purchases','Import from Outside India')  AND LTRIM(RTRIM(REPLACE(REPLACE(A.FORM_NM,'-',''),'FORM','')))='H'
/*
SELECT  '1' as PARTSR,C.AC_NAME,A.s_tax,A.address,C.state,B.u_pono,B.u_podt,B.U_PINVNO,B.U_PINVDT,E.IT_NAME,D.qty,A.gro_amt
, stm.u_pono as s_u_pono,stm.u_podt as s_u_podt,stm.u_transnm as s_u_transnm,stm.u_vehno as s_u_vehno,stm.u_lrdt as s_u_lrdt ,stm.u_lrno as s_u_lrno,stm.u_vehno as S_u_vehno
, STITREF.item,stitem.qty as s_qty,vtst.gro_amt as s_gro_amt
  FROM VATTBL  A INNER JOIN PTMAIN B ON( A.TRAN_CD =B.TRAN_CD AND A.BHENT=B.ENTRY_TY)  
LEFT OUTER JOIN AC_MAST C ON B.AC_ID=C.AC_ID
LEFT OUTER JOIN PTITEM D ON (A.IT_CODE =D.IT_CODE AND A.TRAN_CD=D.TRAN_CD AND A.BHENT=D.ENTRY_TY AND A.ITSERIAL=D.ITSERIAL)
INNER JOIN IT_MAST E ON( D.IT_CODE=E.IT_CODE)
LEFT OUTER JOIN STITREF ON (STITREF.RENTRY_TY=D.ENTRY_TY AND STITREF.ITREF_TRAN=D.TRAN_CD AND STITREF.IT_CODE=D.IT_CODE AND STITREF.RITSERIAL=D.ITSERIAL )
left outer join stmain stm on(stm.entry_ty=STITREF.entry_ty and stm.tran_cd =STITREF.tran_cd)
left outer join stitem  on(stitem.entry_ty=STITREF.entry_ty and stitem.tran_cd=STITREF.tran_cd and stitem.it_code =STITREF.it_code and stitem.itserial=STITREF.itserial)
left outer join vattbl vtst  on(vtst.bhent=stitem.entry_ty and vtst.tran_cd=stitem.tran_cd and vtst.it_code =stitem.it_code and vtst.itserial=stitem.itserial)
WHERE A.BHENT='PT' AND A.U_IMPORM IN('High Seas Purchases','Import from Outside India')  AND LTRIM(RTRIM(REPLACE(REPLACE(A.FORM_NM,'-',''),'FORM','')))='H' 
AND (A.DATE BETWEEN @SDATE AND @EDATE)
*/
SELECT  '1' as PARTSR,C.AC_NAME,A.s_tax,A.address,C.state,B.u_pono,B.u_podt,B.U_PINVNO,B.U_PINVDT,E.IT_NAME,D.qty,A.gro_amt
, B.U_AGRNO as s_u_pono,B.U_AGRDT AS s_u_podt,b.u_transnm as s_u_transnm,b.u_vehno as s_u_vehno,b.u_lrdt as s_u_lrdt ,b.u_lrno as s_u_lrno
, e.it_name as item,(case when b.u_lrno <> '' then d.qty else 0 end) as s_qty,(case when b.u_lrno <> '' then a.gro_amt else 0 end) as s_gro_amt
  FROM VATTBL  A INNER JOIN PTMAIN B ON( A.TRAN_CD =B.TRAN_CD AND A.BHENT=B.ENTRY_TY)
LEFT OUTER JOIN AC_MAST C ON B.AC_ID=C.AC_ID
LEFT OUTER JOIN PTITEM D ON (A.IT_CODE =D.IT_CODE AND A.TRAN_CD=D.TRAN_CD AND A.BHENT=D.ENTRY_TY AND A.ITSERIAL=D.ITSERIAL)
INNER JOIN IT_MAST E ON( D.IT_CODE=E.IT_CODE)
WHERE A.BHENT in('PT','P1') AND A.U_IMPORM IN('High Seas Purchases','Import from Outside India','Direct Imports')  AND LTRIM(RTRIM(REPLACE(REPLACE(A.FORM_NM,'-',''),'FORM','')))='H' 
AND (A.DATE BETWEEN @SDATE AND @EDATE) 

END
--Print 'UP VAT Annexure E'
