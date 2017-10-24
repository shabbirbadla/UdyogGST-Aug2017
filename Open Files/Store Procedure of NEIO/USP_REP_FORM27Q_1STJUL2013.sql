if exists (select [name] from sysobjects where [name]='USP_REP_FORM27Q_1STJUL2013' AND XTYPE='P')
BEGIN 
DROP PROCEDURE USP_REP_FORM27Q_1STJUL2013
END
GO
/****** Object:  StoredProcedure [dbo].[USP_REP_FORM27Q_1STJUL2013]    Script Date: 07/06/2015 13:03:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shrikant S.
-- Create date: 15/07/2013
-- Description:	This Stored procedure is useful to generate TDS Form 27Q Challan and Annexure both Report effective from 1st Jul 2013.
-- Remark:
-- Modified By Kishor A. for Bug-26391 on 02/07/2015
-- =============================================
CREATE PROCEDURE [dbo].[USP_REP_FORM27Q_1STJUL2013]
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
,@VMAINFILE='M',@VITFILE='',@VACFILE='AC'
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

--SELECT DISTINCT SVC_CATE,SECTION=SEC_CODE INTO #TDSMASTER FROM TDSMASTER	WHERE TDSMASTER.SVC_CATE='Other Payment made to NRI'

select svc_cate
		,(Select top 1 sec_code from TDSMASTER where svc_cate=a.svc_cate and fromdt <=@SDATE Order by fromdt desc) as Section
	Into #TDSMASTER from TDSMASTER a Where a.SVC_CATE IN ('Other Payment made to NRI','Interest by infrastructure debt fund','Interest on approved long infrastructure bond','Interest on rupee denominated bond')
				group by a.svc_cate




Select tan=space(15),AddressChange=space(2),RAddressChange=space(2),IsReturnFiled=space(3),TDSAcknowNo=space(15) --Added by Kishor A. for Bug-26391 on 02/07/2015
,ac_mast.ac_id,m.cheq_no,m.u_chalno,m.u_chaldt,m.bsrcode  
,m.svc_cate,m.TDSonAmt,m.date,tm.section,tdspay=m.net_amt
,TDSAmt=mall.new_all,scamt=mall.new_all,ecamt=mall.new_all,hcamt=mall.new_all
,aTotAmt=mall.new_all,atdsamt=mall.new_all,ascamt=mall.new_all,aecamt=mall.new_all
,taTotAmt=mall.new_all,interest=mall.new_all,othersamt=mall.new_all
,DED_RATE=cast(0 as decimal(12,4))
,depbybook='N',paidbybook='N',reasonfor=space(90)
,mall.entry_all,mall.main_tran 
,csrno=99999,dsrno=99999
,m.TDSRATEACT,m.NAT_REM,m.ACK15CA
into #etds26q
from tdsmain_vw m
inner join lac_vw ac on (m.entry_ty=ac.entry_ty and m.tran_cd=ac.tran_cd) 
inner join mainall_vw mall on (ac.entry_ty=mall.entry_ty and ac.tran_cd=mall.tran_cd and ac.acserial=mall.acserial)
inner join ac_mast on (ac_mast.ac_id=ac.ac_id)
inner join #TDSMASTER tm on (m.svc_cate=tm.svc_cate)
where 1=2

-- tan='''',AddressChange='''',RAddressChange='''',IsReturnFiled='''',TDSAcknowNo='''' --Added by Kishor A. for Bug-26391 on 02/07/2015
set @SqlCommand = 'insert into #etds26q Select tan='''',AddressChange='''',RAddressChange='''',IsReturnFiled='''',TDSAcknowNo='''' , ac_mast.ac_id,m.cheq_no,m.u_chalno,m.u_chaldt,m.bsrcode' 
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
set @SqlCommand=RTRIM(@SqlCommand)+' '+',csrno=0,dsrno=0,m1.TDSRATEACT,m1.NAT_REM,m1.ACK15CA'
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
set @SqlCommand=RTRIM(@SqlCommand)+' '+',mall.entry_all,mall.main_tran,m1.TDSRATEACT,m1.NAT_REM,m1.ACK15CA'/*,mall.acseri_all*/
EXECUTE SP_EXECUTESQL @SQLCOMMAND 

-- tan='''',AddressChange='''',RAddressChange='''',IsReturnFiled='''',TDSAcknowNo='''' --Added by Kishor A. for Bug-26391 on 02/07/2015
set @SqlCommand = 'insert into #etds26q Select tan='''',AddressChange='''',RAddressChange='''',IsReturnFiled='''',TDSAcknowNo='''',ac_mast.ac_id,m.cheq_no,m.u_chalno,u_chaldt='''+Convert(Varchar(50),@edate)+''',m.bsrcode' 
set @SqlCommand=RTRIM(@SqlCommand)+' '+',m.svc_cate,m.net_amt,m.date,tm.section,tdspay=m.net_amt'
set @SqlCommand=RTRIM(@SqlCommand)+' '+',TDSAmt=0,scamt=0,ecamt=0,hcamt=0'
set @SqlCommand=RTRIM(@SqlCommand)+' '+',aTotAmt=0,aTDSAmt=0,ascamt=0,aecamt=0'
set @SqlCommand=RTRIM(@SqlCommand)+' '+',taTotAmt=0,interest=0,othersamt=0'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+',DED_RATE=0.00'
set @SqlCommand=RTRIM(@SqlCommand)+' '+',depbybook='''',paidbybook='''',reasonfor='''' '
set @SqlCommand=RTRIM(@SqlCommand)+' '+',entry_all=m.Entry_ty,main_tran=m.Tran_cd'
set @SqlCommand=RTRIM(@SqlCommand)+' '+',csrno=0,dsrno=0,m.TDSRATEACT,m.NAT_REM,m.ACK15CA'
set @SqlCommand=RTRIM(@SqlCommand)+' '+'from tdsmain_vw m'
set @SqlCommand=RTRIM(@SqlCommand)+' '+'inner join ac_mast on (ac_mast.ac_id=m.ac_id)'
set @SqlCommand=RTRIM(@SqlCommand)+' '+'inner join #TDSMASTER tm on (m.svc_cate=tm.svc_cate)'
set @SqlCommand=RTRIM(@SqlCommand)+' '+rtrim(@fcon)
set @SqlCommand=RTRIM(@SqlCommand)+' '+'and m.svc_cate<>'''' and m.tdsamt=0 and scamt=0 and ecamt=0 and hcamt=0 '
EXECUTE SP_EXECUTESQL @SQLCOMMAND 


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



select @u_chalno1='0' ,@section1='',@mentry_ty1='',@mtran_cd1=0
select @csrno=0,@dsrno=0
declare cur_etds26q cursor for select u_chaldt,date,u_chalno,section from #etds26q order by u_chaldt,u_chalno,section


open cur_etds26q
fetch next from cur_etds26q into @u_chaldt,@date,@u_chalno,@section
while(@@fetch_status=0)
begin
--	if (@u_chalno1<>@u_chalno or @section1<>@section)	
if (@u_chalno1<>@u_chalno )		
	begin
		set @csrno=@csrno+1
		select @u_chalno1=@u_chalno,@section1=@section
	end

	update #etds26q set csrno=@csrno where (u_chalno=@u_chalno) and (section=@section)
	
	fetch next from cur_etds26q into @u_chaldt,@date,@u_chalno,@section
end
close cur_etds26q
deallocate cur_etds26q
print 'r1--------'
select @mentry_ty=' ',@mtran_cd1=0

declare cur_etds26q cursor for select csrno,entry_all,main_tran from #etds26q order by csrno,entry_all,main_tran 
open cur_etds26q
fetch next from cur_etds26q into @csrno,@mentry_ty,@mtran_cd
set @csrno1=@csrno
set @dsrno=0
while(@@fetch_status=0)
begin
	print @csrno
	if (   @csrno1=@csrno )
	begin
		if not ( @mentry_ty1=@mentry_ty and @mtran_cd1=@mtran_cd )
		begin
			set @dsrno=@dsrno+1
			print 'chg'
			select @mentry_ty1=@mentry_ty,@mtran_cd1=@mtran_cd
		end 
	end
	else
	begin
		set @dsrno=1
		set @csrno1=@csrno
		if not ( @mentry_ty1=@mentry_ty and @mtran_cd1=@mtran_cd )
		begin
			print 'chg1'
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


Select m.Entry_all,m.main_tran,m.svc_cate,AC_MAST.ded_type
,b.section
,(case when isnull(d.Ac_Id,0)<>0 then (Case when LEN(RTRIM(d.TDS_ExempLimit))>1 Or d.Tds_Tp>0  then 1 else 0 end) else 0 end ) as actdsexempted
,(Select case when len(rtrim(exemplimit))>1 then 1 else 0 end from TDSMASTER Where svc_cate=b.svc_cate and ded_type=b.ded_type and fromdt=b.fromdt and SVC_CATE<>'Other Payment made to NRI')  as tdsexempted 
Into #tmpTdsTbl From #etds26q m 
Inner Join AC_MAST on (AC_MAST.Ac_id=m.ac_id)
Left Join (Select section,svc_cate,ded_type,fromdt=max(fromdt) From TDSMASTER where SVC_CATE IN ('Other Payment made to NRI','Interest by infrastructure debt fund','Interest on approved long infrastructure bond','Interest on rupee denominated bond') group by section,svc_cate,ded_type) b on (b.svc_cate=m.svc_cate and b.ded_type=AC_MAST.ded_type)
left Join Ac_Mast_TDS d on (d.Ac_Id=AC_MAST.Ac_id and m.date between d.Tds_Ex_FDt and d.Tds_Ex_TDt)
Where m.svc_cate<>'' 
	--and (m.tdsamt=0 and m.scamt=0 and m.ecamt=0 and hcamt=0)

--Update #etds26q set reasonfor=
--	 Case when b.section= '197' then 'A' else 
--	 (Case when b.section in ('194J') then 'S' else 
--	 (Case when b.section in ('193','194','194A','194EE') AND (a.tdsamt+a.scamt+a.ecamt+a.hcamt)=0 then 'B' else '' End )
--	 end )
--	 end
--	from  #tmpTdsTbl b Inner join #etds26q a on (b.main_tran=a.main_tran and b.Entry_all=a.Entry_all)

Update #etds26q set reasonfor=
	 Case when b.svc_cate like '%Transport%' then 'T' else 
	 (Case when b.actdsexempted=1 AND (a.tdsamt+a.scamt+a.ecamt+a.hcamt) >0 then 'A' else  
	 (Case when b.section in('193','194','194A','194B','194BB','194C','194D','194EE','194G','194H','194I','194J','194LA') AND b.tdsexempted=1 and (a.tdsamt+a.scamt+a.ecamt+a.hcamt)=0 then 'Y' else 
	 (Case when b.section in ('194J') then 'S' else 
	 (Case when b.section in ('193','194','194A','194EE') AND (a.tdsamt+a.scamt+a.ecamt+a.hcamt)=0 then 'B' else 
		(Case when b.actdsexempted=0 and tdsexempted=0 and (a.tdsamt+a.scamt+a.ecamt+a.hcamt)=0 then 'Z' else '' End )
		end )
	 end )
	 end) 
	 end)
	 end
	from  #tmpTdsTbl b Inner join #etds26q a on (b.main_tran=a.main_tran and b.Entry_all=a.Entry_all)

Select fees=SUM(case when u_nature='Late Fees' Or u_nature='Penalty' then net_amt else 0 end )
	,Interest=SUM(case when u_nature='Interest' then net_amt else 0 end )
	,Otheramt=SUM(case when rtrim(u_nature) not in ('','Interest','Late Fees','Penalty') then net_amt else 0 end),
		u_chalno,u_chaldt Into #Feetable from TdsMain_vw 
	where u_cldt between @sdate and @edate and svc_cate='' and u_nature<>''
		group by u_chalno,u_chaldt


select RcNo=isnull(@RcNo,0),EDATE=@EDATE
,a.*
,DED_CODE=(CASE WHEN ac_mast.ded_type='Company' THEN 1 ELSE 2 END)
,ddate=Case when Tdsamt=0 then @EDATE else a.date end,net_amt=tdspay			
,party_nm=ac_mast.ac_name,ac_mast.add1,ac_mast.add2,ac_mast.add3,ac_mast.city,ac_mast.zip,ac_mast.i_tax
,Fees=Isnull(b.Fees,0),minor_Head=(case when (Isnull(b.Fees,0)<>0 OR Isnull(b.Otheramt,0)<>0) then 400 else 200 end),certino=case when reasonfor<>'' then Isnull(c.TDS_ReasonEL,'') else '' end ,ded_refno
,d.tds_code,natrem_code=e.code
,Interest2=Isnull(b.Interest,0),Otheramt2=Isnull(b.Otheramt,0)
Into #etds26q_2		
from #etds26q a
inner join ac_mast on (a.ac_id=ac_mast.ac_id)
left Join ac_mast_tds c on (c.Ac_Id=AC_MAST.Ac_id)
left Join #Feetable b On(b.u_chalno=a.u_chalno and b.u_chaldt=a.u_chaldt )		
Left Join country d on (d.country=AC_MAST.country)
Left Join TDS_NATREM e on (e.nat_rem=a.nat_rem)
ORDER BY csrno,dsrno

Update #etds26q_2 set reasonfor='C' where len(i_tax)=0 or i_tax='PANNOTAVBL' OR I_TAX='PANAPPLIED'	
--Update #etds26q_2 set atotamt=atotamt+Fees+Interest2+Otheramt2,interest=Interest2,othersamt=Otheramt2
Update #etds26q_2 set interest=Interest2,othersamt=Otheramt2

Select * from #etds26q_2 Order by csrno,dsrno			

drop table #TDSMASTER
drop table #etds26q
drop table #lac1
drop table #t3
drop table #tmpTdsTbl				
drop table #etds26q_2				


