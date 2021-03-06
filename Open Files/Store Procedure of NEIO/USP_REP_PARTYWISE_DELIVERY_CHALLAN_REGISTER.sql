if exists(select * from sysobjects where [name] = 'USP_REP_PARTYWISE_DELIVERY_CHALLAN_REGISTER' and xtype = 'P')
begin
drop procedure [dbo].[USP_REP_PARTYWISE_DELIVERY_CHALLAN_REGISTER]
end 
go 
/****** Object:  StoredProcedure [dbo].[USP_REP_PARTYWISE_DELIVERY_CHALLAN_REGISTER]    Script Date: 05/31/2011 11:33:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE  [dbo].[USP_REP_PARTYWISE_DELIVERY_CHALLAN_REGISTER]
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

DECLARE @FCON AS NVARCHAR(2000)

EXECUTE   USP_REP_FILTCON 
@VTMPAC =@TMPAC,@VTMPIT =@TMPIT,@VSPLCOND =@SPLCOND
,@VSDATE=@SDATE,@VEDATE=@EDATE
,@VSAC =@SAC,@VEAC =@EAC
,@VSIT=@SIT,@VEIT=@EIT
,@VSAMT=@SAMT,@VEAMT=@EAMT
,@VSDEPT=@SDEPT,@VEDEPT=@EDEPT
,@VSCATE =@SCATE,@VECATE =@ECATE
,@VSWARE =@SWARE,@VEWARE  =@EWARE
,@VSINV_SR =@SINV_SR,@VEINV_SR =@SINV_SR
,@VMAINFILE='M',@VITFILE='I',@VACFILE='AC'
,@VDTFLD ='date'
,@VLYN=Null
,@VEXPARA=@EXPARA
,@VFCON =@FCON OUTPUT


DECLARE @SQLCOMMAND NVARCHAR(4000)
PRINT @FCON
SET @SQLCOMMAND='Select M.Party_nm as [Party Name],m.tran_cd,M.Date,M.inv_no as [Invoice No.]'--,M.u_pono as [Order No.]'
--SET @SQLCOMMAND=@SQLCOMMAND+' '+',(case when year(M.u_podt)<=1900 then null else M.u_podt end) as [PO Date],M.u_lrno as [LR No.]'
--SET @SQLCOMMAND=@SQLCOMMAND+' '+',(case when year(M.u_lrdt)<=1900 then null else M.u_lrdt end) as [LR Date]'
SET @SQLCOMMAND=@SQLCOMMAND+' '+',M.gro_amt as [Gross Amount],M.tot_deduc as [Deduction],m.tot_tax as [Taxable Charges],m.Examt as [ExciseAmt]'
SET @SQLCOMMAND=@SQLCOMMAND+' '+',m.u_cessamt as [CessAmt],m.u_hcesamt as [S&H Cess] '
SET @SQLCOMMAND=@SQLCOMMAND+' '+',M.tot_add as [Additional Charges],M.tax_name as [Tax Name]'
SET @SQLCOMMAND=@SQLCOMMAND+' '+',M.taxamt as [Tax Amount],M.tot_nontax as [Non-Taxable Charges],M.tot_fdisc as [Final Discount]'
SET @SQLCOMMAND=@SQLCOMMAND+' '+',m.net_amt as [Net Amount],M.Salesman,M.[rule] as [Rule],M.cate As [Category]'
SET @SQLCOMMAND=@SQLCOMMAND+' '+',M.dept as [Department],M.inv_sr as [Invoice Series]'--,M.u_choice As [Diff. Rate Inv.]'
SET @SQLCOMMAND=@SQLCOMMAND+' '+',M.tran_cd,M.entry_ty,m.ac_id'
SET @SQLCOMMAND=@SQLCOMMAND+' '+',it.it_name as [Item Description] ,it.[group] as [Group],i.Qty ,it.Rateper ,it.RateUnit as [Unit],it.chapno as [Chapter No.],i.Rate, (i.Qty*i.rate) as [Amount],i.ware_nm as [Warehouse],it.Type     '
SET @SQLCOMMAND=@SQLCOMMAND+' '+',(case when AC.amt_ty=''DR'' then AC.amount else 0 end) as [Debit Amount],(case when AC.amt_ty=''CR'' then AC.amount else 0 end) as [Credit Amount],AC.Narr as [Narration],AC.amt_ty,AC.entry_ty as [Transaction Type]'
SET @SQLCOMMAND=@SQLCOMMAND+' '+',ac.acserial,i.itserial,ac.ac_name'
SET @SQLCOMMAND=@SQLCOMMAND+' '+'FROM DCMAIN m'
SET @SQLCOMMAND=@SQLCOMMAND+' '+'inner join DCITEM i ON (i.tran_cd=m.tran_Cd and i.entry_ty=m.entry_ty)'
SET @SQLCOMMAND=@SQLCOMMAND+' '+'INNER JOIN AC_MAST ON (AC_MAST.AC_ID=m.AC_ID)'
SET @SQLCOMMAND=@SQLCOMMAND+' '+'inner join it_mast it on (i.it_code=it.it_code)'
SET @SQLCOMMAND=@SQLCOMMAND+' '+'Left join DCacdet ac on (m.tran_cd=ac.tran_cd and m.entry_ty=ac.entry_ty)'
SET @SQLCOMMAND=@SQLCOMMAND+' '+@FCON
--WHERE (M.date BETWEEN @SDATE AND @EDATE)  and (M.Party_nm BETWEEN @SAC AND @EAC)  
SET @SQLCOMMAND=@SQLCOMMAND+' '+'ORDER BY M.Date,m.tran_cd'
PRINT @SQLCOMMAND
EXECUTE SP_EXECUTESQL @SQLCOMMAND














