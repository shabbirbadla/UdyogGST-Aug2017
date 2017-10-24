set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


-- =============================================
-- Author:		Ruepesh Prajapati.
-- Create date: 11/07/2008
-- Description:	This Stored procedure is useful to generate Output Service Tax Report.
-- Modify date: 16/05/2007
-- Modified By: 
-- Modify date: 
-- Remark:
-- =============================================
ALTER procedure [dbo].[USP_REP_OUTPUT_SERVICETAX]
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
Begin
	Declare @FCON as NVARCHAR(2000),@SQLCOMMAND as NVARCHAR(4000)
	
	EXECUTE USP_REP_FILTCON 
	@VTMPAC =@TMPAC,@VTMPIT =@TMPIT,@VSPLCOND =@SPLCOND
	,@VSDATE=@SDATE,@VEDATE=@EDATE
	,@VSAC =@SAC,@VEAC =@EAC
	,@VSIT=@SIT,@VEIT=@EIT
	,@VSAMT=@SAMT,@VEAMT=@EAMT
	,@VSDEPT=@SDEPT,@VEDEPT=@EDEPT
	,@VSCATE =@SCATE,@VECATE =@ECATE
	,@VSWARE =@SWARE,@VEWARE  =@EWARE
	,@VSINV_SR =@SINV_SR,@VEINV_SR =@SINV_SR
	,@VMAINFILE='m',@VITFILE=Null,@VACFILE='AC'
	,@VDTFLD ='DATE'
	,@VLYN=Null
	,@VEXPARA=@EXPARA
	,@VFCON =@FCON OUTPUT

	set @sqlcommand='select m.entry_ty,m.tran_cd,m.date,m.inv_no,m.serty'
	set @sqlcommand=rtrim(@sqlcommand)+' '+',a.ac_name,a.add1,a.add2,a.add3,a.SREGN,m.net_amt,taxable_amt=m.gro_amt+m.tot_deduc+m.tot_tax'
	set @sqlcommand=rtrim(@sqlcommand)+' '+',bSrTax=sum(case when aa.typ='+'''Output Service Tax'''+' then amount else 0 end)'
	set @sqlcommand=rtrim(@sqlcommand)+' '+',bESrTax=sum(case when aa.typ='+'''Output Service Tax-Ecess'''+' then amount else 0 end)'
	set @sqlcommand=rtrim(@sqlcommand)+' '+',bHSrTax=sum(case when aa.typ='+'''Output Service Tax-Hcess'''+' then amount else 0 end)'
	set @sqlcommand=rtrim(@sqlcommand)+' '+'from sbacdet ac'
	set @sqlcommand=rtrim(@sqlcommand)+' '+'inner join sbmain m on (ac.entry_ty=m.entry_ty and ac.tran_cd=m.tran_cd)'
	set @sqlcommand=rtrim(@sqlcommand)+' '+'inner join ac_mast a on (m.ac_id=a.ac_id)'
	set @sqlcommand=rtrim(@sqlcommand)+' '+'inner join ac_mast aa on (ac.ac_id=aa.ac_id)'
	set @sqlcommand=rtrim(@sqlcommand)+' '+rtrim(@fcon)
	set @sqlcommand=rtrim(@sqlcommand)+' '+'and aa.typ like '+'''%out%serv%'''+' and ac.amt_ty='+'''CR'''
	set @sqlcommand=rtrim(@sqlcommand)+' '+'group by m.entry_ty,m.tran_cd,m.date,m.inv_no,m.serty'
	set @sqlcommand=rtrim(@sqlcommand)+' '+',a.ac_name,a.add1,a.add2,a.add3,a.SREGN,m.net_amt,m.gro_amt,m.tot_deduc,m.tot_tax'
	set @sqlcommand=rtrim(@sqlcommand)+' '+'order by m.serty,m.date,m.tran_cd'
	print @sqlcommand
	execute sp_executesql @sqlcommand 
END



