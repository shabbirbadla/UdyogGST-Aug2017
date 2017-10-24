If Exists(Select [name] From SysObjects Where xType='P' and [Name]='USP_REP_SERVICETAX_ABSTRACT_MULTISERVICE')
Begin
	Drop Procedure USP_REP_SERVICETAX_ABSTRACT_MULTISERVICE
End
Go

-- =============================================
-- Author:		Ruepesh Prajapati.
-- Create date: 22/05/2010
-- Description:	This Stored procedure is useful for [Service Tax Self Assessment Audit] Report.
-- Modification Date/By/Reason: 26/07/2010. Rupesh. TKT-794 Add GTA 
-- Modification Date/By/Reason: 09/02/2015. Pankaj B. Bug-24957 (Functionality not available for Credit Note / Debit Note under Service Tax Module)
-- Modification Date/By/Reason: Shrikant S. on 01-06-2016 for Bug-28132(Krishi Kalyan Cess)
-- Remark:
-- =============================================
CREATE PROCEDURE [dbo].[USP_REP_SERVICETAX_ABSTRACT_MULTISERVICE]  
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
,@VSDATE=null,@VEDATE=@EDATE
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


select m.entry_ty,m.date,m.tran_cd,m.inv_no,typ
,serty=cast('' as varchar(250))
,ac_mast.ac_name,ac.amt_ty,amount,inout=2,m.l_yn
,ser_adj=cast('' as varchar(200)) --Bug-24957
into #serabs1
from bpmain m
inner join lac_vw ac on (m.entry_ty=ac.entry_ty and m.tran_cd=ac.tran_cd)
inner join ac_mast on (ac.ac_id=ac_mast.ac_id)
inner join lcode l  on (m.entry_ty=l.entry_ty)
where 1=2

SET @SQLCOMMAND='insert into #serabs1'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+'select m.entry_ty,m.date,m.tran_cd,m.inv_no,typ'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+',CASE WHEN AC.ENTRY_TY IN (''J1'',''JV'') THEN M.SERTY ELSE AC.serty END'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+',ac_mast.ac_name,ac.amt_ty,amount,inout=1,m.l_yn'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+',m.ser_adj'--Bug-24957
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+'from SerTaxMain_vw m'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+'inner join SerTaxAcDet_vw ac on (m.entry_ty=ac.entry_ty and m.tran_cd=ac.tran_cd)'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+'inner join ac_mast on (ac.ac_id=ac_mast.ac_id)'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+'inner join lcode l  on (m.entry_ty=l.entry_ty)'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+RTRIM(@FCON)
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+'and typ in (''Service Tax Payable'',''Service Tax Payable-Ecess'',''Service Tax Payable-Hcess'',''GTA Service Tax Payable'',''GTA Service Tax Payable-Ecess''
		,''GTA Service Tax Payable-Hcess'',''Krishi Kalyan Cess Payable'',''GTA Krishi Kalyan Cess Payable'')' /*TKT-794 Add GTA*/		--Changed by Shrikant S. on 26/05/2016 for Bug-28132
PRINT @SQLCOMMAND
EXECUTE SP_EXECUTESQL @SQLCOMMAND
SET @SQLCOMMAND='insert into #serabs1'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+'select m.entry_ty,m.date,m.tran_cd,m.inv_no,typ'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+',CASE WHEN AC.ENTRY_TY in (''J1'',''JV'') THEN M.SERTYI when AC.ENTRY_TY=''J3'' then m.serty  ELSE ac.serty END'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+',ac_mast.ac_name,ac.amt_ty,amount,inout=2,m.l_yn'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+',m.ser_adj'--Bug-24957
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+'from SerTaxMain_vw m'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+'inner join SerTaxAcDet_vw ac on (m.entry_ty=ac.entry_ty and m.tran_cd=ac.tran_cd)'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+'inner join ac_mast on (ac.ac_id=ac_mast.ac_id)'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+'inner join lcode l  on (m.entry_ty=l.entry_ty)'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+RTRIM(@FCON)
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+'and typ in (''Service Tax Available'',''Service Tax Available-Ecess'',''Service Tax Available-Hcess'',''Krishi Kalyan Cess Available'')'		--Changed by Shrikant S. on 26/05/2016 for Bug-28132
PRINT @SQLCOMMAND
EXECUTE SP_EXECUTESQL @SQLCOMMAND

DELETE FROM #serabs1 WHERE 
DATE < (SELECT TOP 1 DATE FROM #serabs1 WHERE ENTRY_TY IN ('OB') AND L_YN = @LYN)
AND AC_NAME IN (SELECT AC_NAME FROM #serabs1 WHERE ENTRY_TY IN ('OB') AND L_YN = @LYN GROUP BY AC_NAME) 



--select * from #serabs1
SELECT 
OPBAL=SUM(CASE WHEN (ENTRY_TY='OB' OR DATE<@SDATE) AND INOUT=2  THEN (CASE WHEN AMT_TY='DR' THEN AMOUNT WHEN AMT_TY='CR' THEN -AMOUNT ELSE 0 END) 
			   WHEN (ENTRY_TY='OB' OR DATE<@SDATE) AND INOUT=1  THEN (CASE WHEN AMT_TY='CR' THEN AMOUNT WHEN AMT_TY='DR' THEN -AMOUNT ELSE 0 END)
		ELSE 0 END)
-- Commented By Pankaj B. on 05-01-2014 for Bug-24957 start
--,DAMT=SUM(CASE WHEN NOT (ENTRY_TY= 'OB' OR DATE<@SDATE) AND AMT_TY='DR' THEN AMOUNT ELSE 0 END)
--,CAMT=SUM(CASE WHEN NOT (ENTRY_TY='OB' OR DATE<@SDATE) AND AMT_TY='CR' THEN AMOUNT ELSE 0 END)
--,BALAMT=SUM(CASE WHEN AMT_TY='DR' THEN AMOUNT ELSE -AMOUNT END)
-- Commented By Pankaj B. on 05-01-2014 for Bug-24957 End
-- Added By Pankaj B. on 05-01-2014 for Bug-24957 start
--,DAMT=SUM(CASE WHEN INOUT=1 THEN (CASE WHEN NOT (ENTRY_TY in ('OB','JV','J1') OR DATE<@SDATE) AND AMT_TY='DR' THEN AMOUNT ELSE 0 END)
--	  ELSE (CASE WHEN NOT (ENTRY_TY IN ('OB','JV','J1') OR DATE<@SDATE) AND AMT_TY='DR'  THEN AMOUNT  
--				 WHEN ENTRY_TY IN ('JV','J1') and  (DATE between @SDATE and @edate) AND AMT_TY='DR' and SER_ADJ<>'' then AMOUNT  
--				 else 0 END) END)
,PAYABLE=SUM(CASE WHEN NOT (ENTRY_TY IN ('OB','JV','J1') OR DATE<@SDATE) AND AMT_TY='DR' AND INOUT=2 THEN AMOUNT
				  WHEN NOT (ENTRY_TY IN ('OB','JV','J1') OR DATE<@SDATE) AND AMT_TY='CR' AND INOUT=1 THEN AMOUNT ELSE 0 END)
,DAMT=SUM(CASE WHEN ENTRY_TY IN ('JV','J1','B2') and  (DATE between @SDATE and @edate) and SER_ADJ<>'' AND INOUT=2  then (CASE WHEN AMT_TY='DR' THEN AMOUNT WHEN AMT_TY='CR' THEN -AMOUNT ELSE 0 END)  
				WHEN ENTRY_TY IN ('JV','J1','B2') and  (DATE between @SDATE and @edate) and SER_ADJ<>'' AND INOUT=1  then (CASE WHEN AMT_TY='CR' THEN AMOUNT WHEN AMT_TY='DR' THEN -AMOUNT ELSE 0 END)  
				WHEN ENTRY_TY='B2' and  (DATE between @SDATE and @edate) AND INOUT=1  then (CASE WHEN AMT_TY='CR' THEN AMOUNT WHEN AMT_TY='DR' THEN -AMOUNT ELSE 0 END)  
				WHEN ENTRY_TY='B2' and  (DATE between @SDATE and @edate) AND INOUT=2  then (CASE WHEN AMT_TY='DR' THEN AMOUNT WHEN AMT_TY='CR' THEN -AMOUNT ELSE 0 END)  
				 else 0 END)
				 ,CAMT=0
--,CAMT=SUM(CASE WHEN NOT (ENTRY_TY IN ('OB','JV','J1') OR DATE<@SDATE) AND AMT_TY='CR'  THEN AMOUNT  
--				 WHEN ENTRY_TY IN ('JV','J1') and  (DATE between @SDATE and @edate) AND AMT_TY='CR' and SER_ADJ<>'' then AMOUNT  
--				 else 0 END)
,ADJAMT=SUM(CASE WHEN ENTRY_TY IN ('JV','J1') and  (DATE between @SDATE and @edate) and SER_ADJ='' AND INOUT=2  then (CASE WHEN AMT_TY='DR' THEN AMOUNT WHEN AMT_TY='CR' THEN -AMOUNT ELSE 0 END)  
				 WHEN ENTRY_TY IN ('JV','J1') and  (DATE between @SDATE and @edate) and SER_ADJ='' AND INOUT=1  then (CASE WHEN AMT_TY='CR' THEN AMOUNT WHEN AMT_TY='DR' THEN -AMOUNT ELSE 0 END)  
				 else 0 END)
,BALAMT=CAST(0 AS DECIMAL(12,2))--SUM(CASE WHEN AMT_TY='DR' THEN AMOUNT ELSE -AMOUNT END)
-- Added By Pankaj B. on 05-01-2014 for Bug-24957 End
,SERTY,inout
--,OPAMT_TY=SPACE(2)
--,CLAMT_TY=SPACE(2)
,typ,srno=0
into #serabs
FROM #serabs1
where date<=@EDATE
GROUP BY SERTY,inout,typ
UPDATE #serabs SET BALAMT=(OPBAL+PAYABLE)+(ADJAMT+DAMT)
--UPDATE  #serabs SET OPAMT_TY=(CASE WHEN OPBAL<0 THEN 'Cr' ELSE 'Dr' END),CLAMT_TY=(CASE WHEN BALAMT<0 THEN 'Cr' ELSE 'Dr' END)
select * from #serabs ORDER BY inout,SERTY,srno,typ




