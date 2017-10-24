IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Usp_Rep_Emp_TDS_Form27A]') AND type in (N'P', N'PC'))
Begin
	DROP PROCEDURE [dbo].[Usp_Rep_Emp_TDS_Form27A]
end
go
-- =============================================
-- Author:Rupesh		
-- Create date: 16/09/2012
-- Description:	This Stored procedure is useful to generate TDS Form 27A Annexure Report.
-- Modified By:Date:Reason: Rupesh. 17/03/2010. TKT-589. Changes done because it was giving wrong output. Refrence SP USP_REP_FORM26Q,USP_REP_FORM16.
-- Remark:
-- =============================================
CREATE Procedure [dbo].[Usp_Rep_Emp_TDS_Form27A]
@TMPAC NVARCHAR(60),@TMPIT NVARCHAR(60),@SPLCOND NVARCHAR(500),  
 @SDATE SMALLDATETIME,@EDATE SMALLDATETIME,  
 @SNAME NVARCHAR(60),@ENAME NVARCHAR(60),  
 @SITEM NVARCHAR(60),@EITEM NVARCHAR(60),  
 @SAMT NUMERIC,@EAMT NUMERIC,  
 @SDEPT NVARCHAR(60),@EDEPT NVARCHAR(60),  
 @SCAT NVARCHAR(60),@ECAT NVARCHAR(60),  
 @SWARE NVARCHAR(60),@EWARE NVARCHAR(60),  
 @SINVSR NVARCHAR(60),@EINVSR NVARCHAR(60),  
 @FINYR NVARCHAR(20), @EXPARA NVARCHAR(60)  
AS
begin

	Declare @FCON as NVARCHAR(4000),@SQLCOMMAND as NVARCHAR(4000)
	 EXECUTE USP_REP_FILTCON   
	  @VTMPAC=@TMPAC,@VTMPIT=null,@VSPLCOND=@SPLCOND,  
	  @VSDATE=@SDATE,@VEDATE=@EDATE,  
	  @VSAC =@SNAME,@VEAC =@ENAME,  
	  @VSIT=null,@VEIT=null,  
	  @VSAMT=@SAMT,@VEAMT=@EAMT,  
	  @VSDEPT=@SDEPT,@VEDEPT=@EDEPT,  
	  @VSCATE =@SCAT,@VECATE =@ECAT,  
	  @VSWARE =null,@VEWARE  =null,  
	  @VSINV_SR =@SINVSR,@VEINV_SR =@EINVSR,  
	  @VMAINFILE='M',@VITFILE=null,@VACFILE=NULL,  
	  @VDTFLD = 'U_CLDT',@VLYN=null,@VEXPARA='',  
	  @VFCON =@FCON OUTPUT  
	 PRINT @FCON  
	 SET @SQLCOMMAND = ''  

	Declare @tot_anne numeric(3),@RcNo varchar(15),@CntEmpCode int 
	set @RcNo=''
	if charindex('RCNO1=',@EXPARA)>0
	begin	
		set @RcNo=substring(@EXPARA,charindex('RCNO1=',@EXPARA)+6,15)
	end 

	SELECT DISTINCT SVC_CATE,SECTION=SEC_CODE INTO #TDSMASTER FROM TDSMASTER 

	Select ac_mast.ac_id,m.u_chalno,tm.SECTION
	,tdspay=m.net_amt
	,dTDSAmt=mall.new_all,TotTDSAmt=mall.new_all
	,m.Entry_Ty,m.Tran_Cd--,TotDeductee=3
	--,mall.entry_all,mall.main_tran,mall.acseri_all
	into #table1
	from tdsmain_vw m
	inner join lac_vw ac on (m.entry_ty=ac.entry_ty and m.tran_cd=ac.tran_cd) 
	inner join mainall_vw mall on (ac.entry_ty=mall.entry_ty and ac.tran_cd=mall.tran_cd and ac.acserial=mall.acserial)
	inner join ac_mast on (ac_mast.ac_id=ac.ac_id)
	inner join #TDSMASTER tm on (m.svc_cate=tm.svc_cate)
	where 1=2
	
	set @SqlCommand = 'insert into #table1 Select ac_mast.ac_id,m.u_chalno,tm.SECTION'
	set @SqlCommand=RTRIM(@SqlCommand)+' '+',tdspay=m.net_amt'
	set @SqlCommand=RTRIM(@SqlCommand)+' '+',dTDSAmt=0'
	set @SqlCommand=RTRIM(@SqlCommand)+' '+',TotTDSAmt=sum(case when AC_MAST1.TYP IN (''TDS'',''TDS-SUR'',''TDS-ECESS'',''TDS-HCESS'') then ac.Amount else 0 end) '
	set @SqlCommand=RTRIM(@SqlCommand)+' '+',m.Entry_Ty,m.Tran_Cd'
	set @SqlCommand=RTRIM(@SqlCommand)+' '+'from BpMain m '
	set @SqlCommand=RTRIM(@SqlCommand)+' '+'inner join BpAcDet ac on (m.entry_ty=ac.entry_ty and m.tran_cd=ac.tran_cd)' 
	set @SqlCommand=RTRIM(@SqlCommand)+' '+'inner join ac_mast ac_mast1 on (ac_mast1.ac_id=ac.ac_id)' 
	set @SqlCommand=RTRIM(@SqlCommand)+' '+'inner join ac_mast on (ac_mast.ac_id=m.ac_id)' 
	set @SqlCommand=RTRIM(@SqlCommand)+' '+'inner join TDSMASTER tm on (''"''+rtrim(ac.Ac_Name)+''"''=tm.TdsPosting)'  
	set @SqlCommand=RTRIM(@SqlCommand)+' '+rtrim(@fcon)
	set @SqlCommand=RTRIM(@SqlCommand)+' '+' and AC_MAST1.TYP IN (''TDS'',''TDS-ECESS'',''TDS-HCESS'',''TDS-SUR'')'
	set @SqlCommand=RTRIM(@SqlCommand)+' '+' group by ac_mast.ac_id,m.u_chalno,tm.section,m.net_amt,m.Entry_Ty,m.Tran_Cd'
	
	PRINT @SQLCOMMAND  
	EXECUTE SP_EXECUTESQL @SQLCOMMAND 


	select distinct section,u_chalno  into #t4 from #table1 /*Dont Change Row position*/
	set @tot_anne=@@rowcount /*Dont Change Row position*/
	/*Update Deduction Amount--->*/
	Select Entry_Ty=Th_Ent_Ty,Tran_Cd=Th_Trn_Cd,TDSAmt=Sum(TDSAmt)--,TotDeductee=count(EmployeeCode) 
	into #TDSDed
	From Emp_Monthly_Payroll 
	Where Th_Ent_Ty+Cast(Th_Trn_Cd as Varchar) in (Select Distinct Entry_Ty+Cast(Tran_Cd as Varchar) From #table1)
	Group By Th_Ent_Ty,Th_Trn_Cd 
	--Select * From #TDSDed
	
	Select Distinct EmployeeCode into #TotEmpCode From Emp_Monthly_Payroll Where Th_Ent_Ty+Cast(Th_Trn_Cd as Varchar) in (Select Distinct Entry_Ty+Cast(Tran_Cd as Varchar) From #table1)
	
	Select @CntEmpCode=Count(EmployeeCode) From #TotEmpCode
	
	update a set a.dTDSAmt=b.TDSAmt From #table1 a inner join #TDSDed b on ( a.Entry_ty=b.Entry_ty and a.Tran_Cd=b.Tran_Cd)
	
	/*<---Update Deduction Amount*/
	
	
		
	select  CntEmpCode=@CntEmpCode,ac_id,tdspay,dtdsamt,tottdsamt=sum(tottdsamt),tot_anne=@tot_anne,RcNo=isnull(@RcNo,0) from #table1 group by ac_id,tdspay,dtdsamt order by ac_id

	drop table #table1
	drop table #TDSDed 
End	
