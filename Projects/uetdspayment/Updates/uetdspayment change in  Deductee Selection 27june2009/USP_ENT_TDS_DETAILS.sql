IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_ENT_TDS_DETAILS]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_ENT_TDS_DETAILS]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ruepesh Prajapati
-- Create date: 18/06/2009
-- Description:	This Stored procedure is useful in Auto TDS BILL SELECTION  project uetdspayment.app.
-- Modified By: Rupesh Prajapati
-- Modify date/Reason: 25/06/2008 For Deductee Type Selection
-- Remark:
-- =============================================


CREATE procedure [dbo].[USP_ENT_TDS_DETAILS]
@entry_ty varchar(2),@tran_cd int ,@date smalldatetime,@dedtype varchar(3)
as
begin
	declare @sqlcommand nvarchar(4000),@whcon nvarchar(1000)
	set @whcon=''
	if not (@dedtype='' or @dedtype='CFI') and (@dedtype<>'1=2')
	begin
		if charindex('C',@dedtype,1)>0
		begin
			set @whcon=rtrim(@whcon)+','+char(39)+'Company'+char(39)  
		end 
		if charindex('F',@dedtype,1)>0
		begin
			set @whcon=rtrim(@whcon)+','+char(39)+'Partnership Firm'+char(39)  
		end
		if charindex('I',@dedtype,1)>0
		begin
			set @whcon=rtrim(@whcon)+','+char(39)+'Individual'+char(39)  
		end
		print @whcon
		set @whcon=substring(@whcon,2,len(@whcon)-1)
		set @whcon=' and a1.ded_type in ('+@whcon+')'	
	end
	if @dedtype='1=2'
	begin
		set @whcon='and 1=2'
	end

	SELECT DISTINCT SECTION,AC_NAME=RTRIM(SUBSTRING(TDSPOSTING,2,CHARINDEX('"',TDSPOSTING,2)-2)) 
	INTO #TDSMASTER
	FROM TDSMASTER WHERE ISNULL(SECTION,SPACE(1))<>SPACE(1)
	UNION
	SELECT DISTINCT SECTION,AC_NAME=RTRIM(SUBSTRING(SCPOSTING,2,CHARINDEX('"',SCPOSTING,2)-2)) 
	FROM TDSMASTER WHERE ISNULL(SECTION,SPACE(1))<>SPACE(1)
	UNION
	SELECT DISTINCT SECTION,AC_NAME=RTRIM(SUBSTRING(ECPOSTING,2,CHARINDEX('"',ECPOSTING,2)-2)) 
	FROM TDSMASTER WHERE ISNULL(SECTION,SPACE(1))<>SPACE(1)
	UNION
	SELECT DISTINCT SECTION,AC_NAME=RTRIM(SUBSTRING(HCPOSTING,2,CHARINDEX('"',hCPOSTING,2)-2)) 
	FROM TDSMASTER WHERE ISNULL(SECTION,SPACE(1))<>SPACE(1)

	

	select entry_all,main_tran,acseri_all,new_all=sum(new_all) 
	into #mall 
	from mainall_vw 
	where ( entry_ty+rtrim(cast(tran_cd as varchar)) ) <> ( @entry_ty+rtrim(cast(@tran_cd as varchar)) )
	group by entry_all,main_tran,acseri_all

	select sel=cast(0 as bit),t.section,ac.entry_ty,ac.tran_cd,ac.acserial,a.ac_name,ac.amount,new_all=ac.amount
	,ac.amt_ty,a.typ
	,party_nm=a.ac_name,m.u_pinvno,m.u_pinvdt,m.inv_no,m.date,tpayment=cast(0 as decimal(17,2))
	,m.l_yn,ac.ac_id,m.compid,m.inv_sr,m.net_amt
	,a.ded_type,isused=3
	into #tdsdetails
	from lac_vw ac 
	inner join ac_mast a on (a.ac_id=ac.ac_id)
	inner join lmain_vw m on (ac.entry_ty=m.entry_ty and ac.tran_cd=m.tran_cd)
--	inner join ac_mast a1 on (a1.ac_id=m.ac_id)
	LEFT JOIN #TDSMASTER T on (T.AC_NAME=A.AC_NAME)   
--	left join #mall mall on(ac.entry_ty=mall.entry_all and ac.tran_cd=main_tran and ac.acserial=acseri_all)
	where 1=2

	set @sqlcommand='insert into #tdsdetails'
	set @sqlcommand=rtrim(@sqlcommand)+' '+'select sel=cast(0 as bit),t.section,ac.entry_ty,ac.tran_cd,ac.acserial,a.ac_name,ac.amount,new_all=isnull(mall.new_all,0)'
	set @sqlcommand=rtrim(@sqlcommand)+' '+',ac.amt_ty,a.typ'
	set @sqlcommand=rtrim(@sqlcommand)+' '+',party_nm=a1.ac_name,m.u_pinvno,m.u_pinvdt,m.inv_no,m.date,tpayment=cast(0 as decimal(17,2))'
	set @sqlcommand=rtrim(@sqlcommand)+' '+',m.l_yn,ac.ac_id,m.compid,m.inv_sr,m.net_amt'
	set @sqlcommand=rtrim(@sqlcommand)+' '+',a1.ded_type,isused=0'
	set @sqlcommand=rtrim(@sqlcommand)+' '+'from lac_vw ac '
	set @sqlcommand=rtrim(@sqlcommand)+' '+'inner join ac_mast a on (a.ac_id=ac.ac_id)'
	set @sqlcommand=rtrim(@sqlcommand)+' '+'inner join lmain_vw m on (ac.entry_ty=m.entry_ty and ac.tran_cd=m.tran_cd)'
	set @sqlcommand=rtrim(@sqlcommand)+' '+'inner join ac_mast a1 on (a1.ac_id=m.ac_id)'
	set @sqlcommand=rtrim(@sqlcommand)+' '+'LEFT JOIN #TDSMASTER T on (T.AC_NAME=A.AC_NAME)'
	set @sqlcommand=rtrim(@sqlcommand)+' '+'left join #mall mall on(ac.entry_ty=mall.entry_all and ac.tran_cd=main_tran and ac.acserial=acseri_all)'
	set @sqlcommand=rtrim(@sqlcommand)+' '+'where a.typ in (''TDS'',''TDS-SUR'',''TDS-ECESS'',''TDS-HCESS'')'
	set @sqlcommand=rtrim(@sqlcommand)+' '+'and ac.amt_ty=''CR'' '
	set @sqlcommand=rtrim(@sqlcommand)+' '+'and ac.amount<>isnull(mall.new_all,0)'
	set @sqlcommand=rtrim(@sqlcommand)+' '+'and ac.date<='+char(39)+cast(@date as varchar)+char(39)
	set @sqlcommand=rtrim(@sqlcommand)+' '+@whcon
	print @sqlcommand
	execute sp_executesql @sqlcommand
	select entry_all,main_tran into #tm from mainall_vw where entry_ty+cast(tran_cd as varchar) in (@entry_ty+cast(@tran_cd as varchar))
	update a set a.isused=1 from #tdsdetails a inner join #tm b on (a.entry_ty=b.entry_all and a.tran_cd=b.main_tran)
	
	select * from #tdsdetails 
	--where entry_ty+cast(tran_cd) in (select * from main_all vw )
	
	drop table #tdsdetails
end






