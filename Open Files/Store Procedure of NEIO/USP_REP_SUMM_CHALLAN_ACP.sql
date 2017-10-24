
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_REP_SUMM_CHALLAN_ACP]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_REP_SUMM_CHALLAN_ACP]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Dinesh Sh.
-- Create date: 14/05/2012
-- Reference  : [--USP_REP_FORM26Q]
-- Description:	This Stored procedure is useful to generate TDS Form 26Q Challan and Annexure both Report.
-- Modified By:Date:Reason: Rupesh. 17/03/2010. TKT-590,599. Changes done because it was giving wrong output. Refrence SP USP_REP_FORM16,USP_REP_FORM27A.
-- Remark:
-- =============================================
CREATE PROCEDURE [dbo].[USP_REP_SUMM_CHALLAN_ACP]
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
SET NOCOUNT ON 

SET QUOTED_IDENTIFIER OFF
Declare @FCON as NVARCHAR(2000),@VSAMT DECIMAL(14,2),@VEAMT DECIMAL(14,2)

DECLARE @SQLCOMMAND NVARCHAR(4000),@VCOND NVARCHAR(2000),@FDATE VARCHAR(10),@RcNo varchar(15)

EXECUTE   USP_REP_FILTCON 
@VTMPAC =@TMPAC,@VTMPIT =@TMPIT,@VSPLCOND =@SPLCOND
,@VSDATE=@SDATE
,@VEDATE=@EDATE
,@VSAC =@SAC,@VEAC =@EAC
,@VSIT=@SIT,@VEIT=@EIT
,@VSAMT=@SAMT,@VEAMT=@EAMT
,@VSDEPT=@SDEPT,@VEDEPT=@EDEPT
,@VSCATE =@SCATE,@VECATE =@ECATE
,@VSWARE =@SWARE,@VEWARE  =@EWARE
,@VSINV_SR =@SINV_SR,@VEINV_SR =@SINV_SR
,@VMAINFILE='M1',@VITFILE='',@VACFILE='AC'
,@VDTFLD ='U_CLDT'
,@VLYN =NULL
,@VEXPARA=@EXPARA
,@VFCON =@FCON OUTPUT

declare @date smalldatetime,@u_chalno varchar(10),@u_chaldt smalldatetime,@section varchar(10),@mentry_ty varchar(10),@mtran_cd varchar(10),@csrno numeric(10),@dsrno numeric(10),@csrno1 numeric(10)
declare @date1 smalldatetime,@u_chalno1 varchar(10),@section1 varchar(10),@mentry_ty1 varchar(10),@mtran_cd1 varchar(10)
set @RcNo=''
if charindex('RCNO1=',@EXPARA)>0
begin	
	set @RcNo=substring(@EXPARA,charindex('RCNO1=',@EXPARA)+6,15)
end 

SELECT DISTINCT SVC_CATE,SECTION=SEC_CODE INTO #TDSMASTER FROM TDSMASTER 


Select ac_mast.ac_id,m.cheq_no,m.u_chalno,m.u_chaldt,m.bsrcode  /*m.entry_ty,m.tran_cd,ac.acserial,mall.new_all,*/
,m.svc_cate,m.TDSonAmt,m.date,tm.section,tdspay=m.net_amt
,TDSAmt=mall.new_all,scamt=mall.new_all,ecamt=mall.new_all,hcamt=mall.new_all
,aTotAmt=mall.new_all,atdsamt=mall.new_all,ascamt=mall.new_all,aecamt=mall.new_all
,taTotAmt=mall.new_all,interest=mall.new_all,othersamt=mall.new_all
,DED_RATE=cast(0 as decimal(12,4))
,depbybook='N',paidbybook='N',reasonfor=space(90)
,mall.entry_all,mall.main_tran /*,mall.acseri_all*/
,csrno=99999,dsrno=99999
into #etds26q
from tdsmain_vw m
inner join lac_vw ac on (m.entry_ty=ac.entry_ty and m.tran_cd=ac.tran_cd) 
inner join mainall_vw mall on (ac.entry_ty=mall.entry_ty and ac.tran_cd=mall.tran_cd and ac.acserial=mall.acserial)
inner join ac_mast on (ac_mast.ac_id=ac.ac_id)
inner join #TDSMASTER tm on (m.svc_cate=tm.svc_cate)
where 1=2
 
set @SqlCommand = 'insert into #etds26q Select ac_mast.ac_id,m.cheq_no,m.u_chalno,m.u_chaldt,m.bsrcode' /*m.entry_ty,m.tran_cd,ac.acserial,mall.new_all,*/
set @SqlCommand=RTRIM(@SqlCommand)+' '+',m1.svc_cate,m1.TDSonAmt,m1.date,tm.section,tdspay=m1.net_amt'
set @SqlCommand=RTRIM(@SqlCommand)+' '+',TDSAmt=0'
set @SqlCommand=RTRIM(@SqlCommand)+' '+',scamt=0'
set @SqlCommand=RTRIM(@SqlCommand)+' '+',ecamt=0'
set @SqlCommand=RTRIM(@SqlCommand)+' '+',hcamt=0'
set @SqlCommand=RTRIM(@SqlCommand)+' '+',aTotAmt=sum(case when AC_MAST1.TYP IN (''TDS'',''TDS-SUR'',''TDS-ECESS'',''TDS-HCESS'') then new_all else 0 end)'
set @SqlCommand=RTRIM(@SqlCommand)+' '+',aTDSAmt=sum(case when AC_MAST1.TYP IN (''TDS'') then new_all else 0 end)'
set @SqlCommand=RTRIM(@SqlCommand)+' '+',ascamt=sum(case when  AC_MAST1.TYP IN (''TDS-SUR'') then new_all else 0 end)'
set @SqlCommand=RTRIM(@SqlCommand)+' '+',aecamt=sum(case when  AC_MAST1.TYP IN (''TDS-ECESS'',''TDS-HCESS'') then new_all else 0 end)'
set @SqlCommand=RTRIM(@SqlCommand)+' '+',taTotAmt=0,interest=0,othersamt=0'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+',DED_RATE=cast(   (M1.tds_tp)+   ( (M1.tds_tp*M1.sc_tp)/100 ) + ( (( (M1.tds_tp*M1.sc_tp)/100 )*M1.ec_tp)/100  ) + ( (( (M1.tds_tp*M1.sc_tp)/100 )*M1.hc_tp)/100  ) as numeric(17,2))'
set @SqlCommand=RTRIM(@SqlCommand)+' '+',depbybook=''N'',paidbybook=''N'',reasonfor='''' '
set @SqlCommand=RTRIM(@SqlCommand)+' '+',mall.entry_all,mall.main_tran'/*,mall.acseri_all*/
set @SqlCommand=RTRIM(@SqlCommand)+' '+',csrno=0,dsrno=0'
set @SqlCommand=RTRIM(@SqlCommand)+' '+'from tdsmain_vw m'
set @SqlCommand=RTRIM(@SqlCommand)+' '+'inner join lac_vw ac on (m.entry_ty=ac.entry_ty and m.tran_cd=ac.tran_cd) '
set @SqlCommand=RTRIM(@SqlCommand)+' '+'inner join mainall_vw mall on (ac.entry_ty=mall.entry_ty and ac.tran_cd=mall.tran_cd and ac.acserial=mall.acserial)'
set @SqlCommand=RTRIM(@SqlCommand)+' '+'inner join ac_mast ac_mast1 on (ac_mast1.ac_id=ac.ac_id)'
set @SqlCommand=RTRIM(@SqlCommand)+' '+'inner join tdsmain_vw m1 on (m1.entry_ty=mall.entry_all and m1.tran_cd=mall.main_tran)'
set @SqlCommand=RTRIM(@SqlCommand)+' '+'inner join ac_mast on (ac_mast.ac_id=m1.ac_id)'
set @SqlCommand=RTRIM(@SqlCommand)+' '+'inner join #TDSMASTER tm on (m1.svc_cate=tm.svc_cate)'
set @SqlCommand=RTRIM(@SqlCommand)+' '+rtrim(@fcon)
set @SqlCommand=RTRIM(@SqlCommand)+' '+' and isnull(mall.new_all,0)>0 '
set @SqlCommand=RTRIM(@SqlCommand)+' '+' and AC_MAST1.TYP IN (''TDS'',''TDS-ECESS'',''TDS-HCESS'',''TDS-SUR'')'
set @SqlCommand=RTRIM(@SqlCommand)+' '+' group by ac_mast.ac_id,m.cheq_no,m.u_chalno,m.u_chaldt,m.bsrcode'
set @SqlCommand=RTRIM(@SqlCommand)+' '+',m1.svc_cate,m1.TDSonAmt,m1.date,tm.section,m1.net_amt,m1.tds_tp,m1.sc_tp,m1.ec_tp,m1.hc_tp'
set @SqlCommand=RTRIM(@SqlCommand)+' '+',mall.entry_all,mall.main_tran'/*,mall.acseri_all*/
--print @SQLCOMMAND  
EXECUTE SP_EXECUTESQL @SQLCOMMAND 
--print @SQLCOMMAND  

Select m.Entry_ty,m.Tran_cd
,TDSAmt=sum(case when AC_MAST1.TYP IN ('TDS') then amount else 0 end)
,scamt=sum(case when AC_MAST1.TYP IN ('TDS-SUR') then amount else 0 end)
,ecamt=sum(case when AC_MAST1.TYP IN ('TDS-ECESS') then amount else 0 end)
,hcamt=sum(case when AC_MAST1.TYP IN ('TDS-HCESS') then amount else 0 end)
into #lac1
from tdsmain_vw m 
inner join lac_vw ac on (m.entry_ty=ac.entry_ty and m.tran_cd=ac.tran_cd)
inner join ac_mast ac_mast1 on (ac_mast1.ac_id=ac.ac_id)
where ac.date<=@edate and ac.amt_ty='CR'
group by m.Entry_ty,m.Tran_cd

update a set a.tdsamt=b.tdsamt,a.scamt=b.scamt,a.ecamt=b.ecamt,a.hcamt=b.hcamt
from #etds26q a inner join #lac1 b on (b.entry_ty=a.entry_all and b.tran_cd=a.main_tran)


/*select  
a.*
,ac_mast.ac_name,ac_mast.add1,ac_mast.add2,ac_mast.add3,ac_mast.city,ac_mast.zip,ac_mast.i_tax
from #etds26q a
inner join ac_mast on (a.ac_id=ac_mast.ac_id)
ORDER BY Ac_mast.AC_NAME,A.SVC_CATE,A.DATE,a.entry_all,a.main_tran*/



/*SELECT DISTINCT SECTION=SEC_CODE,AC_NAME=RTRIM(SUBSTRING(TDSPOSTING,2,CHARINDEX('"',TDSPOSTING,2)-2)) 
INTO #TDSMASTER
FROM TDSMASTER WHERE ISNULL(SECTION,SPACE(1))<>SPACE(1)
UNION
SELECT DISTINCT SECTION=SEC_CODE,AC_NAME=RTRIM(SUBSTRING(SCPOSTING,2,CHARINDEX('"',SCPOSTING,2)-2)) 
FROM TDSMASTER WHERE ISNULL(SECTION,SPACE(1))<>SPACE(1)
UNION
SELECT DISTINCT SECTION=SEC_CODE,AC_NAME=RTRIM(SUBSTRING(ECPOSTING,2,CHARINDEX('"',ECPOSTING,2)-2)) 
FROM TDSMASTER WHERE ISNULL(SECTION,SPACE(1))<>SPACE(1)
UNION
SELECT DISTINCT SECTION=SEC_CODE,AC_NAME=RTRIM(SUBSTRING(HCPOSTING,2,CHARINDEX('"',HCPOSTING,2)-2)) 
FROM TDSMASTER WHERE ISNULL(SECTION,SPACE(1))<>SPACE(1)

select t.section,ac.ac_name,ac_mast.typ,ac.amount
,DED_CODE=2,party_nm=ac.ac_name,ac_mast.i_tax
,ac.date,m.net_amt
,damt=ac.amount
,amt=ac.amount
,m.bsrcode,m.u_chalno,m.u_chaldt,m.cheq_no
,m.u_arrears,ddate=ac.date
,depbybook='N',paidbybook='N',reasonfor=space(90)
,ac.entry_ty,ac.tran_cd,ac.acserial,csrno=99999
,mentry_ty=ac.entry_ty,mtran_cd=ac.tran_cd,macserial=ac.acserial,mac_id=m.ac_id,dsrno=99999
,DED_RATE=cast(0 as decimal(12,4))
,tdsamt=ac.amount,scamt=ac.amount,ecamt=ac.amount,interest=ac.amount,othersamt=ac.amount,totamt=ac.amount
,atdsamt=ac.amount,ascamt=ac.amount,aecamt=ac.amount,ainterest=ac.amount,aothersamt=ac.amount,atotamt=ac.amount
,dedtdsamt=ac.amount,dedscamt=ac.amount,dedecamt=ac.amount,dedtotamt=ac.amount
into #etds26q
from lac_vw ac
inner join TdsMain_vw m on (m.entry_ty=ac.entry_ty and m.tran_cd=ac.tran_cd)
INNER JOIN AC_MAST ON (AC_MAST.AC_ID=ac.AC_ID)
inner JOIN #TDSMASTER T on (RTRIM(T.AC_NAME)=RTRIM(AC_MAST.AC_NAME))
where 1=2

SET @SQLCOMMAND='insert into #etds26q'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+'select t.section,ac.ac_name,ac_mast.typ,ac.amount'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+',DED_CODE=(CASE WHEN a1.ded_type=''Company'' THEN 1 ELSE 2 END),party_nm=a1.ac_name,a1.i_tax'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+',ac.date,net_amt=m1.net_amt'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+',damt=ac1.amount'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+',amt=mall.new_all'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+',m.bsrcode,m.u_chalno,m.u_chaldt,m.cheq_no'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+',isnull(m.u_arrears,''''),ddate=ac1.date'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+',depbybook=''N'',paidbybook=''N'',reasonfor='''' '
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+',ac.entry_ty,ac.tran_cd,ac.acserial,csrno=0'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+',mentry_ty=ac1.entry_ty,mtran_cd=ac1.tran_cd,macserial=ac1.acserial,mac_id=m1.ac_id,dsrno=0'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+',DED_RATE=cast(   (M1.tds_tp)+   ( (M1.tds_tp*M1.sc_tp)/100 ) + ( (( (M1.tds_tp*M1.sc_tp)/100 )*M1.ec_tp)/100  ) + ( (( (M1.tds_tp*M1.sc_tp)/100 )*M1.hc_tp)/100  ) as numeric(17,2))'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+',tdsamt=0,scamt=0,ecamt=0,interest=0,othersamt=0,totamt=0'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+',atdsamt=0,ascamt=0,aecamt=0,ainterest=0,aothersamt=0,atotamt=0'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+',dedtdsamt=0,dedscamt=0,dedecamt=0,dedtotamt=0'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+'from lac_vw ac'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+'inner join TdsMain_vw m on (m.entry_ty=ac.entry_ty and m.tran_cd=ac.tran_cd)'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+'INNER JOIN AC_MAST ON (AC_MAST.AC_ID=ac.AC_ID)'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+'inner JOIN #TDSMASTER T on (RTRIM(T.AC_NAME)=RTRIM(AC_MAST.AC_NAME))'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+'left JOIN mainall_vw MALL ON (mall.ENTRY_ty=ac.ENTRY_TY AND ac.TRAN_CD=MALL.TRAN_cd and ac.acserial=mall.acserial)'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+'left join lac_vw ac1 on (MALL.ENTRY_ALL=ac1.ENTRY_TY AND MALL.MAIN_TRAN=ac1.TRAN_CD and ac1.acserial=mall.acseri_all)'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+'left JOIN TdsMain_vw M1 ON (m1.entry_ty=ac1.entry_ty and m1.tran_cd=ac1.tran_cd)'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+'left JOIN AC_MAST a1 ON (A1.AC_ID=m1.AC_ID)'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+'left join lcode l on (ac.entry_ty=l.entry_ty)'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+RTRIM(@FCON)
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+'and AC_MAST.TYP IN (''TDS'',''TDS-ECESS'',''TDS-HCESS'',''TDS-SUR'') and ac.amt_ty=''DR'' '
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+'and ( l.entry_ty in (''BP'',''CP'') or bcode_nm in (''BP'',''CP'') ) '
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+'order by ac.date,m.u_chaldt,m.u_chalno,ac.entry_ty,ac.tran_cd,ac.acserial,ac1.entry_ty,ac1.tran_cd,ac1.acserial '
--print @SQLCOMMAND
EXECUTE SP_EXECUTESQL @SQLCOMMAND*/
--print 'r'

select @u_chalno1='' ,@section1='',@mentry_ty1='',@mtran_cd1=0
select @csrno=0,@dsrno=0
declare cur_etds26q cursor for select u_chaldt,date,u_chalno,section from #etds26q order by u_chaldt,u_chalno,section


open cur_etds26q
fetch next from cur_etds26q into @u_chaldt,@date,@u_chalno,@section
while(@@fetch_status=0)
begin
	if (@u_chalno1<>@u_chalno or @section1<>@section)	
	begin
		set @csrno=@csrno+1
		select @u_chalno1=@u_chalno,@section1=@section
	end

	update #etds26q set csrno=@csrno where (u_chalno=@u_chalno) and (section=@section)
	
	fetch next from cur_etds26q into @u_chaldt,@date,@u_chalno,@section
end
close cur_etds26q
deallocate cur_etds26q
--print 'r1--------'
select @mentry_ty=' ',@mtran_cd1=0

declare cur_etds26q cursor for select csrno,entry_all,main_tran from #etds26q order by csrno,entry_all,main_tran 
open cur_etds26q
fetch next from cur_etds26q into @csrno,@mentry_ty,@mtran_cd
set @csrno1=@csrno
set @dsrno=0
while(@@fetch_status=0)
begin
	--print @csrno
	if (   @csrno1=@csrno )
	begin
		if not ( @mentry_ty1=@mentry_ty and @mtran_cd1=@mtran_cd )
		begin
			set @dsrno=@dsrno+1
			--print 'chg'
			select @mentry_ty1=@mentry_ty,@mtran_cd1=@mtran_cd
		end 
	end
	else
	begin
		set @dsrno=1
		set @csrno1=@csrno
		if not ( @mentry_ty1=@mentry_ty and @mtran_cd1=@mtran_cd )
		begin
			--print 'chg1'
			select @mentry_ty1=@mentry_ty,@mtran_cd1=@mtran_cd
		end 
	end
	update #etds26q set dsrno=@dsrno where entry_all=@mentry_ty and main_tran=@mtran_cd and csrno=@csrno
	fetch next from cur_etds26q into @csrno,@mentry_ty,@mtran_cd
end
close cur_etds26q
deallocate cur_etds26q


select csrno,tatotamt=sum(atotamt) into #t3 from #etds26q group by csrno

update a set a.tatotamt=b.tatotamt from #etds26q a inner join #t3 b on (a.csrno=b.csrno)


select RcNo=isnull(@RcNo,0),EDATE=@EDATE
,a.*
,DED_CODE=(CASE WHEN ac_mast.ded_type='Company' THEN 1 ELSE 2 END)
,ddate=a.date,net_amt=tdspay
,party_nm=ac_mast.ac_name,ac_mast.add1,ac_mast.add2,ac_mast.add3,ac_mast.city,ac_mast.zip,ac_mast.i_tax
INTO #FINAL
from #etds26q a
inner join ac_mast on (a.ac_id=ac_mast.ac_id)
ORDER BY csrno,dsrno

--**--> DINESH SH: CHANGES STARTS FOR SUMMARY
SELECT 
QTR_NM = CASE WHEN (MONTH(DATE) BETWEEN 4 AND 6)	THEN 'QTR 1'
			WHEN (MONTH(DATE) BETWEEN 7 AND 9)		THEN 'QTR 2'
			WHEN (MONTH(DATE) BETWEEN 10 AND 12)	THEN 'QTR 3'
		ELSE 'QTR 4' END 
,TDS_CODE = SECTION
,Svc_Cate
,date_of_pay = date
,BSRCODE
,U_CHALNO
,DED_CODE
,Com_NonCom = CASE DED_CODE 
			WHEN 1 THEN 'Companies' 
			WHEN 2 THEN 'Other than Companies'
			else '' end
,Cheq_No
,TDSAMT,scamt,ecamt,hcamt
,Amt_pay = aTotAmt
,Amt_paid = aTdsAmt
,Diff = aTotAmt-aTdsAmt
FROM #FINAL
Order by date,bsrcode,U_CHALNO,ded_code
--**--< DINESH SH: CHANGES STARTS FOR SUMMARY

drop table #TDSMASTER
drop table #etds26q
drop table #lac1
drop table #t3
DROP TABLE #FINAL

SET NOCOUNT OFF

GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

EXECUTE [USP_REP_SUMM_CHALLAN_ACP] '','','','04/01/2011','06/30/2011','','','','',0,0,'','','','','','','','','2011-2012',''






