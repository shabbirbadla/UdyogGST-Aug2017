set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

-- =============================================
 -- Author:  Hetal L. Patel
-- Create date: 16/05/2007
-- Description:	This Stored procedure is useful to generate TN CAPITAL APPENDIX
-- Modify date: 16/10/2008
-- Modified By: 
-- Modify date: 
-- Remark:
-- =============================================
ALTER procedure [dbo].[USP_REP_TN_CST_FORM1_Appendix]
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
Declare @FCON as NVARCHAR(2000)
Declare @SQLCOMMAND NVARCHAR(4000)
Declare @gro_amt decimal(12,2),@taxamt decimal(12,2),@fld_list NVARCHAR(2000)

EXECUTE   USP_REP_FILTCON 
@VTMPAC =@TMPAC,@VTMPIT =@TMPIT,@VSPLCOND =@SPLCOND
,@VSDATE=@SDATE --null
,@VEDATE=@EDATE
,@VSAC =@SAC,@VEAC =@EAC
,@VSIT=@SIT,@VEIT=@EIT
,@VSAMT=@SAMT,@VEAMT=@EAMT
,@VSDEPT=@SDEPT,@VEDEPT=@EDEPT
,@VSCATE =@SCATE,@VECATE =@ECATE
,@VSWARE =@SWARE,@VEWARE  =@EWARE
,@VSINV_SR =@SINV_SR,@VEINV_SR =@SINV_SR
,@VMAINFILE='m',@VITFILE='',@VACFILE=''
,@VDTFLD ='DATE'
,@VLYN =NULL
,@VEXPARA=@EXPARA
,@VFCON =@FCON OUTPUT

select part=3,srno1='a',srno2=space(1),srno3=space(1),it_desc=m.cate,itm.hsncode,st.level1
,taxable_amt=i.gro_amt
,i.taxamt,taxamt1=i.taxamt
,cheq_no=space(30),m.date,bank_nm=space(100),u_bsrcode=space(30)
into #tn_CST_FORM1_PART4
from ptitem i
inner join ptmain m on (m.entry_ty=i.entry_ty and m.tran_cd=i.tran_cd) 
inner join ac_mast acm on (i.ac_id=acm.ac_id) 
inner join it_mast itm on (i.it_code=itm.it_code) 
inner join stax_mas st on (st.tax_name=i.tax_name)
where 1=2

Declare @MultiCo	VarChar(3)
Declare @MCON as NVARCHAR(2000)
IF Exists(Select A.ID From SysObjects A Inner Join SysColumns B On(A.ID = B.ID) Where A.[Name] = 'STMAIN' And B.[Name] = 'DBNAME')
	Begin	------Fetch Records from Multi Co. Data
		Set @MultiCo = 'YES'

		if not exists(select * from #tn_CST_FORM1_PART4 where part=1)
		begin
			insert into #tn_CST_FORM1_PART4
			(part,srno1,it_desc,hsncode,level1,taxable_amt
			,taxamt,taxamt1
			,cheq_no,date,bank_nm,u_bsrcode)
			values
			(1,'','','',0,0
			,0,0
			,'','','','')
		end
		-->part-2
		execute usp_rep_Taxable_Amount_Itemwise 'ST','i',@fld_list =@fld_list OUTPUT
		set @fld_list=rtrim(@fld_list)
		set @sqlcommand='insert into #tn_CST_FORM1_PART4 select part=2,srno1='+'''0'''+',srno2=space(1),srno3=space(1),it_desc=m.cate,itm.hsncode,st.level1'
		set @sqlcommand=@sqlcommand+' '+',taxable_amt=isnull(sum(i.gro_amt'+@fld_list+'),0)'
		set @sqlcommand=@sqlcommand+' '+',taxamt=isnull(sum(i.taxamt),0),taxamt1=isnull(sum(i.taxamt),0)'
		set @sqlcommand=@sqlcommand+' '+',cheq_no=space(1),date='+''''''+',bank_nm=space(1),u_bsrcode=space(1)'
		set @sqlcommand=@sqlcommand+' '+'from stitem i '
		set @sqlcommand=@sqlcommand+' '+'inner join stmain m on (m.entry_ty=i.entry_ty and m.tran_cd=i.tran_cd And m.dbname = i.dbname)'
		set @sqlcommand=@sqlcommand+' '+'inner join ac_mast acm on (i.ac_id=acm.ac_id and i.dbname = acm.dbname)'
		set @sqlcommand=@sqlcommand+' '+'inner join it_mast itm on (i.it_code=itm.it_code and i.dbname = itm.dbname)'
		set @sqlcommand=@sqlcommand+' '+'inner join stax_mas st on (st.tax_name=i.tax_name and st.dbname = i.dbname)'
		set @sqlcommand=@sqlcommand+' '+rtrim(@fcon)
		set @sqlcommand=@sqlcommand+' '+'and isnull(st.st_type,'''')='+'''out of state'''+' and i.taxamt<>0'
		set @sqlcommand=@sqlcommand+' '+'group by m.cate,itm.hsncode,st.level1'

--		print @sqlcommand
		execute sp_executesql @sqlcommand

		--<--Part-2
		-->Part-3
		--
		set @taxamt=0
		select @taxamt=sum(taxamt) from #tn_CST_FORM1_PART4 where part=2
		insert into #tn_CST_FORM1_PART4
		(part,srno1,srno2,it_desc,hsncode,level1,taxable_amt
		,taxamt,taxamt1
		,cheq_no,date,bank_nm,u_bsrcode)
		values
		(3,'1','0','','',0,0
		,0,@taxamt
		,'','','','')
		--
		set @taxamt=0
		insert into #tn_CST_FORM1_PART4
		(part,srno1,srno2,it_desc,hsncode,level1,taxable_amt
		,taxamt,taxamt1
		,cheq_no,date,bank_nm,u_bsrcode)
		values
		(3,'2','A','','',0,0
		,@taxamt,0
		,'','','','') --It Should be Set-off Entry.
		--
		set @taxamt=0
		insert into #tn_CST_FORM1_PART4
		(part,srno1,srno2,it_desc,hsncode,level1,taxable_amt
		,taxamt,taxamt1
		,cheq_no,date,bank_nm,u_bsrcode)
		values
		(3,'2','B','','',0,0
		,0,0
		,'','','','') 
		--
		set @taxamt=0
		insert into #tn_CST_FORM1_PART4
		(part,srno1,srno2,it_desc,hsncode,level1,taxable_amt
		,taxamt,taxamt1
		,cheq_no,date,bank_nm,u_bsrcode)
		values
		(3,'2','C','','',0,0
		,@taxamt,0
		,'','','','') 
		--
		set @taxamt=0
		select @taxamt=0
		select @taxamt =sum(taxamt) from #tn_CST_FORM1_PART4 where part=3 and srno1='2' and srno2 in ('A','B','C')

		insert into #tn_CST_FORM1_PART4
		(part,srno1,srno2,it_desc,hsncode,level1,taxable_amt
		,taxamt,taxamt1
		,cheq_no,date,bank_nm,u_bsrcode)
		values
		(3,'2','D','','',0,0
		,0,@taxamt
		,'','','','') 
		--
		set @taxamt=0
		set @taxamt=0
		select @taxamt=0
		select @taxamt =sum(case when srno1='1' then taxamt1 else -taxamt1 end ) from #tn_CST_FORM1_PART4 where part=3 and ((srno1='1') or (srno1='2' and srno2='D'))
		insert into #tn_CST_FORM1_PART4
		(part,srno1,srno2,it_desc,hsncode,level1,taxable_amt
		,taxamt,taxamt1
		,cheq_no,date,bank_nm,u_bsrcode)
		values
		(3,'3','0','','',0,0
		,0,@taxamt
		,'','','','')
		--
		set @taxamt=0
		insert into #tn_CST_FORM1_PART4
		(part,srno1,srno2,it_desc,hsncode,level1,taxable_amt
		,taxamt,taxamt1
		,cheq_no,date,bank_nm,u_bsrcode)
		values
		(4,'0','0','','',0,0
		,0,0
		,'','','','') --It Should be Set-off Entry.
		--
		set @taxamt=0
		insert into #tn_CST_FORM1_PART4
		(part,srno1,srno2,srno3,it_desc,hsncode,level1,taxable_amt
		,taxamt,taxamt1
		,cheq_no,date,bank_nm,u_bsrcode)

		select 4,'1','','','',0,0
		,taxamt=0,amount=Sum(ac.amount)
		,taxamt1=0
		,m.cheq_no,m.date,m.bank_nm,m.u_bsrcode
		from bpmain m
		inner join bpacdet ac on(m.tran_cd=ac.tran_cd and m.dbname=ac.dbname)
		inner join ac_mast a on (a.ac_id=ac.ac_id and a.dbname = ac.dbname)
		where a.ac_name ='SALES TAX A/C.' and (m.date between @sdate and @edate) and ac.amt_ty='Dr'
		group by  m.cheq_no,m.date,m.bank_nm,m.u_bsrcode
		having Sum(ac.amount)<>0
		union
		select 4,'1','','','',0,0
		,taxamt=0,amount=Sum(ac.amount)
		,taxamt1=0
		,m.cheq_no,m.date,m.bank_nm,m.u_bsrcode
		from cpmain m
		inner join cpacdet ac on(m.tran_cd=ac.tran_cd and m.dbname = ac.dbname)
		inner join ac_mast a on (a.ac_id=ac.ac_id and a.dbname = ac.dbname)
		where a.ac_name ='SALES TAX A/C.' and (m.date between @sdate and @edate) and ac.amt_ty='Dr'
		group by  m.cheq_no,m.date,m.bank_nm,m.u_bsrcode
		having Sum(ac.amount)<>0

		if not exists(select * from #tn_CST_FORM1_PART4 where part=4)
		begin
			insert into #tn_CST_FORM1_PART4
			(part,srno1,it_desc,hsncode,level1,taxable_amt
			,taxamt,taxamt1
			,cheq_no,date,bank_nm,u_bsrcode)
			values
			(4,'1','','',0,0
			,0,0
			,'','','','')
		end
		--<--Part-3
	End
Else
	Begin	------Fetch Records from Multi Co. Data
		Set @MultiCo = 'NO'

		if not exists(select * from #tn_CST_FORM1_PART4 where part=1)
		begin
			insert into #tn_CST_FORM1_PART4
			(part,srno1,it_desc,hsncode,level1,taxable_amt
			,taxamt,taxamt1
			,cheq_no,date,bank_nm,u_bsrcode)
			values
			(1,'','','',0,0
			,0,0
			,'','','','')
		end
		-->part-2
		execute usp_rep_Taxable_Amount_Itemwise 'ST','i',@fld_list =@fld_list OUTPUT
		set @fld_list=rtrim(@fld_list)
		set @sqlcommand='insert into #tn_CST_FORM1_PART4 select part=2,srno1='+'''0'''+',srno2=space(1),srno3=space(1),it_desc=m.cate,itm.hsncode,st.level1'
		set @sqlcommand=@sqlcommand+' '+',taxable_amt=isnull(sum(i.gro_amt'+@fld_list+'),0)'
		set @sqlcommand=@sqlcommand+' '+',taxamt=isnull(sum(i.taxamt),0),taxamt1=isnull(sum(i.taxamt),0)'
		set @sqlcommand=@sqlcommand+' '+',cheq_no=space(1),date='+''''''+',bank_nm=space(1),u_bsrcode=space(1)'
		set @sqlcommand=@sqlcommand+' '+'from stitem i '
		set @sqlcommand=@sqlcommand+' '+'inner join stmain m on (m.entry_ty=i.entry_ty and m.tran_cd=i.tran_cd)'
		set @sqlcommand=@sqlcommand+' '+'inner join ac_mast acm on (i.ac_id=acm.ac_id)'
		set @sqlcommand=@sqlcommand+' '+'inner join it_mast itm on (i.it_code=itm.it_code)'
		set @sqlcommand=@sqlcommand+' '+'inner join stax_mas st on (st.tax_name=i.tax_name)'
		set @sqlcommand=@sqlcommand+' '+rtrim(@fcon)
		set @sqlcommand=@sqlcommand+' '+'and isnull(st.st_type,'''')='+'''out of state'''+' and i.taxamt<>0'
		set @sqlcommand=@sqlcommand+' '+'group by m.cate,itm.hsncode,st.level1'

--		print @sqlcommand
		execute sp_executesql @sqlcommand

		--<--Part-2
		-->Part-3
		--
		set @taxamt=0
		select @taxamt=sum(taxamt) from #tn_CST_FORM1_PART4 where part=2
		insert into #tn_CST_FORM1_PART4
		(part,srno1,srno2,it_desc,hsncode,level1,taxable_amt
		,taxamt,taxamt1
		,cheq_no,date,bank_nm,u_bsrcode)
		values
		(3,'1','0','','',0,0
		,0,@taxamt
		,'','','','')
		--
		set @taxamt=0
		insert into #tn_CST_FORM1_PART4
		(part,srno1,srno2,it_desc,hsncode,level1,taxable_amt
		,taxamt,taxamt1
		,cheq_no,date,bank_nm,u_bsrcode)
		values
		(3,'2','A','','',0,0
		,@taxamt,0
		,'','','','') --It Should be Set-off Entry.
		--
		set @taxamt=0
		insert into #tn_CST_FORM1_PART4
		(part,srno1,srno2,it_desc,hsncode,level1,taxable_amt
		,taxamt,taxamt1
		,cheq_no,date,bank_nm,u_bsrcode)
		values
		(3,'2','B','','',0,0
		,0,0
		,'','','','') 
		--
		set @taxamt=0
		insert into #tn_CST_FORM1_PART4
		(part,srno1,srno2,it_desc,hsncode,level1,taxable_amt
		,taxamt,taxamt1
		,cheq_no,date,bank_nm,u_bsrcode)
		values
		(3,'2','C','','',0,0
		,@taxamt,0
		,'','','','') 
		--
		set @taxamt=0
		select @taxamt=0
		select @taxamt =sum(taxamt) from #tn_CST_FORM1_PART4 where part=3 and srno1='2' and srno2 in ('A','B','C')

		insert into #tn_CST_FORM1_PART4
		(part,srno1,srno2,it_desc,hsncode,level1,taxable_amt
		,taxamt,taxamt1
		,cheq_no,date,bank_nm,u_bsrcode)
		values
		(3,'2','D','','',0,0
		,0,@taxamt
		,'','','','') 
		--
		set @taxamt=0
		set @taxamt=0
		select @taxamt=0
		select @taxamt =sum(case when srno1='1' then taxamt1 else -taxamt1 end ) from #tn_CST_FORM1_PART4 where part=3 and ((srno1='1') or (srno1='2' and srno2='D'))
		insert into #tn_CST_FORM1_PART4
		(part,srno1,srno2,it_desc,hsncode,level1,taxable_amt
		,taxamt,taxamt1
		,cheq_no,date,bank_nm,u_bsrcode)
		values
		(3,'3','0','','',0,0
		,0,@taxamt
		,'','','','')
		--
		set @taxamt=0
		insert into #tn_CST_FORM1_PART4
		(part,srno1,srno2,it_desc,hsncode,level1,taxable_amt
		,taxamt,taxamt1
		,cheq_no,date,bank_nm,u_bsrcode)
		values
		(4,'0','0','','',0,0
		,0,0
		,'','','','') --It Should be Set-off Entry.
		--
		set @taxamt=0
		insert into #tn_CST_FORM1_PART4
		(part,srno1,srno2,srno3,it_desc,hsncode,level1,taxable_amt
		,taxamt,taxamt1
		,cheq_no,date,bank_nm,u_bsrcode)
		select 4,'1','','','',0,0
		,taxamt=0,amount=Sum(ac.amount)
		,taxamt1=0
		,m.cheq_no,m.date,m.bank_nm,m.u_bsrcode
		from bpmain m
		inner join bpacdet ac on(m.tran_cd=ac.tran_cd)
		inner join ac_mast a on (a.ac_id=ac.ac_id)
		where a.ac_name ='SALES TAX A/C.' and (m.date between @sdate and @edate) and ac.amt_ty='Dr'
		group by  m.cheq_no,m.date,m.bank_nm,m.u_bsrcode
		having Sum(ac.amount)<>0
		union
		select 4,'1','','','',0,0
		,taxamt=0,amount=Sum(ac.amount)
		,taxamt1=0
		,m.cheq_no,m.date,m.bank_nm,m.u_bsrcode
		from cpmain m
		inner join cpacdet ac on(m.tran_cd=ac.tran_cd)
		inner join ac_mast a on (a.ac_id=ac.ac_id)
		where a.ac_name ='SALES TAX A/C.' and (m.date between @sdate and @edate) and ac.amt_ty='Dr'
		group by  m.cheq_no,m.date,m.bank_nm,m.u_bsrcode
		having Sum(ac.amount)<>0

		if not exists(select * from #tn_CST_FORM1_PART4 where part=4)
		begin
			insert into #tn_CST_FORM1_PART4
			(part,srno1,it_desc,hsncode,level1,taxable_amt
			,taxamt,taxamt1
			,cheq_no,date,bank_nm,u_bsrcode)
			values
			(4,'1','','',0,0
			,0,0
			,'','','','')
		end
		--<--Part-3
	End

Update #tn_CST_FORM1_PART4 set srno1=isnull(srno1,''),srno2=isnull(srno2,''),srno3=isnull(srno3,'')
select * from #tn_CST_FORM1_PART4
--Print 'TN CAPITAL APPENDIX'

