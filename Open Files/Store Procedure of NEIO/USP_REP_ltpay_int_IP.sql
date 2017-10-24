set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go
if exists (select [name] from sysobjects where [name]='USP_REP_ltpay_int_IP' and xtype='p')
begin
drop procedure USP_REP_ltpay_int_IP
end  
go
-- =============================================
-- Author:		Birendra Prasad
-- Create date: 17/08/2011
-- Description:	This Stored procedure is useful to INTEREST ON LATE PAYMENT (INT. PAYING PARTIES) Report.
-- Modify date: 
-- Modified By: 
-- Modify date: 
-- Remark:
-- =============================================


Create PROCEDURE [dbo].[USP_REP_ltpay_int_IP]
@TMPAC NVARCHAR(50),@TMPIT NVARCHAR(50),@SPLCOND VARCHAR(8000),@SDATE  SMALLDATETIME,@EDATE DATETIME
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
Declare @brENTRIES as VARCHAR(50),@brENTRY_TY as VARCHAR(50)
Set @BRENTRY_TY = '"BR"'+'"CR"'




DECLARE BR_cursor CURSOR FOR
		SELECT entry_ty FROM lcode
		WHERE bcode_nm in ('BR','CR')
	OPEN br_cursor
	FETCH NEXT FROM br_cursor into @brentries
	WHILE @@FETCH_STATUS = 0
	BEGIN
	   Set @brENTRY_TY = @brENTRY_TY +',"'+@brentries+'"'
	   FETCH NEXT FROM br_cursor into @brentries
	END
	CLOSE br_cursor
	DEALLOCATE br_cursor

select ac_mast.mailname,ac_mast.intpay,stmain.inv_no as sbillno,'Interest' as item ,mainall_vw.new_all as recdamt,
stmain.date as sbdate,stmain.due_dt as sbduedt ,lmain_vw.date as brdate,stmain.net_amt as sbillamt,
--lmain_vw.net_amt,ROUND(((mainall_vw.new_all*(stmain.u_intr_per/100))/AC_MAST.I_DAYS)*convert(int,(lmain_vw.date-stmain.due_dt)),0) as int_amount,
--Birendra:Bug-2460 on 25/02/2012(commented above line and added below line)
lmain_vw.net_amt,case when isnull(ac_mast.i_days,0)<>0 then ROUND(((mainall_vw.new_all* (stmain.u_intr_per/100))/AC_MAST.I_DAYS) *convert(int,(lmain_vw.date-stmain.due_dt)),0) else 0 end as int_amount,
ltdays=convert(int,(lmain_vw.date-stmain.due_dt)),stmain.U_INTR_PER as u_intper 
,dninv_no=isnull(di.inv_no,''),dndate=isnull(di.date,'')
into #Lt_pay 
from lmain_vw inner join mainall_vw on lmain_vw.tran_cd=mainall_vw.tran_cd and lmain_vw.entry_ty=mainall_vw.entry_ty
inner join lac_vw on lac_vw.tran_cd=mainall_vw.main_tran and lac_vw.acserial=mainall_vw.acseri_all and lac_vw.entry_ty=mainall_vw.entry_all
inner join stmain on stmain.tran_cd=lac_vw.tran_cd and stmain.entry_ty=lac_vw.entry_ty
inner join ac_mast on ac_mast.ac_id=stmain.ac_id 
left join dnitem di on (stmain.inv_no=di.sbillno and stmain.inv_sr=di.sinvsr and di.ENTRY_TY='D3')
where lmain_vw.entry_ty IN ('BR','CR') and stmain.date between @sdate and @edate and ac_mast.mailname between @sac and @eac
 
----PRINT  @brENTRY_TY

select *  from #lt_pay where INTPAY=1 AND ltdays>0
group by mailname,intpay,sbdate,sbillno,item,recdamt,sbduedt,brdate,sbillamt,net_amt,int_amount,ltdays,u_intper,dninv_no,dndate


drop table #lt_pay















