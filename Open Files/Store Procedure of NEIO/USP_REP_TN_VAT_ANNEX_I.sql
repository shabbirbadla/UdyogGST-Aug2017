IF EXISTS(SELECT XTYPE,NAME FROM SYSOBJECTS WHERE XTYPE='P' AND name='USP_REP_TN_VAT_ANNEX_I')
BEGIN
	DROP PROCEDURE USP_REP_TN_VAT_ANNEX_I
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--
-- =============================================
-- Description:	This Stored procedure is useful to generate Tamilnadu VAT Form I- AnnexureI
-- Modify date: 19/05/2015 - For the bug-26171 by GAURAV R. TANNA
-- Remark:
---Modify Date : 21-12-2015 -For the bug-27444 by Suraj K.
-- =============================================
/*
EXECUTE USP_REP_TN_VAT_ANNEX_I '','','','04/01/2015','03/31/2016','','','','',0,0,'','','','','','','','','2011-2012',''
*/

CREATE Procedure [dbo].[USP_REP_TN_VAT_ANNEX_I]
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
Declare @FCON as NVARCHAR(2000),@fld_list NVARCHAR(2000)
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
,@VMAINFILE='M',@VITFILE=Null,@VACFILE='i'
,@VDTFLD ='DATE'
,@VLYN=Null
,@VEXPARA=@EXPARA
,@VFCON =@FCON OUTPUT

DECLARE @TAXABLE_AMT NUMERIC(14,2),@taxamt numeric(14,2)
set @FCON=rtrim(@FCON)
select part=1,srno1=3, it_desc=m.cate,acm.ac_name,acm.s_tax,commodity_code=space(100)
----,taxable_amt=i.gro_amt+i.BCDAMT+i.U_CESSAMT+i.U_HCESAMT+i.EXAMT+i.U_CVDAMT ---for Bug-27444
,taxable_amt=m.net_amt ---for Bug-27444
,taxamt=i.taxamt
,st.tax_name
,st.level1 ,st.st_type ,m.u_imporm
--,INV_NO=M.INV_NO
into #tn_vat_Annexure
from ptitem i  
inner join ptmain m on (m.entry_ty=i.entry_ty and m.tran_cd=i.tran_cd) 
inner join ac_mast acm on (i.ac_id=acm.ac_id) 
inner join it_mast itm on (i.it_code=itm.it_code) 
inner join stax_mas st on (st.tax_name=i.tax_name)
where 1=2

-->Purchase
execute usp_rep_Taxable_Amount_Itemwise 'PT','i',@fld_list =@fld_list OUTPUT
set @fld_list=rtrim(@fld_list)
declare @sqlcommand nvarchar(4000)

Declare @MultiCo	VarChar(3)
Declare @MCON as NVARCHAR(2000)
IF Exists(Select A.ID From SysObjects A Inner Join SysColumns B On(A.ID = B.ID) Where A.[Name] = 'STMAIN' And B.[Name] = 'DBNAME')
	Begin	------Fetch Records from Multi Co. Data
		Set @MultiCo = 'YES'

		
	End
Else
	Begin	------Fetch Records from Single Co. Data
		Set @MultiCo = 'NO'
		PRINT 'ST 1'		
		-->Purchase
		
		set @sqlcommand='insert into #tn_vat_Annexure select part=1,srno1=1'
		set @sqlcommand=@sqlcommand+' '+',cate=case when itm.vatcap=1 then ''Capital Goods'' else '''' end,acm.ac_name,acm.s_tax,itm.hsncode' --m.cate CMT by suraj k. for bug-24589 
		set @sqlcommand=@sqlcommand+' '+',taxable_amt= isnull(sum(round((I.u_asseamt+I.EXAMT+I.U_CESSAMT+I.U_HCESAMT+I.tot_add+I.TOT_DEDUC),2)),0)' --sum(i.GRO_AMT-(i.TAXAMT+i.ADDLVAT1))' --,taxable_amt=sum(i.gro_amt'+@fld_list+')' --cmt by suraj for bug-24589 on 15-11-2014 add u_asseamt as per discuss with sadhan sir
		set @sqlcommand=@sqlcommand+' '+',taxamt=isnull(sum(round(i.taxamt,2)),0)'		
		set @sqlcommand=@sqlcommand+' '+',tax_name=i.tax_name,level1 =ISNULL(st.level1,0.00),st_type=isnull(st.st_type,''''),u_imporm=isnull(m.u_imporm,'''')' --,tax_name=isnull(st.tax_name,'''')
		--,st.st_type ,m.u_imporm'
		set @sqlcommand=@sqlcommand+' '+'from ptitem i '
		set @sqlcommand=@sqlcommand+' '+'inner join ptmain m on (m.entry_ty=i.entry_ty and m.tran_cd=i.tran_cd)'
		set @sqlcommand=@sqlcommand+' '+'inner join ac_mast acm on (i.ac_id=acm.ac_id)'
		set @sqlcommand=@sqlcommand+' '+'inner join it_mast itm on (i.it_code=itm.it_code)'
		set @sqlcommand=@sqlcommand+' '+'left outer  join stax_mas st on (st.tax_name=i.tax_name And St.Entry_ty = I.Entry_Ty)'
		set @sqlcommand=@sqlcommand+' '+rtrim(@fcon)
		--set @sqlcommand=@sqlcommand+' '+'and isnull(m.tax_name,'''')<>''''' --CMT BY SURAJ FOR BUG-24589
		--set @sqlcommand=@sqlcommand+' '+'group by m.cate,acm.ac_name,acm.s_tax,itm.hsncode,st.tax_name,st.level1,st.st_type,st.st_type ,m.u_imporm,acm.s_tax' --CMT BY SURAJ FOR BUG-24589

		set @sqlcommand=@sqlcommand+' '+'group by acm.ac_name,acm.s_tax,st.st_type,itm.hsncode,itm.vatcap,i.tax_name,st.level1,m.u_imporm'
		set @sqlcommand=@sqlcommand+' '+'order by acm.ac_name,acm.s_tax,st.st_type,itm.hsncode,itm.vatcap,i.tax_name,st.level1,m.u_imporm'
		
		print @sqlcommand
		execute sp_executesql @sqlcommand
		
		--ADDED BY SURAJ K.ON 18-11-2014 START
		
		--SET @sqlcommand = ''
		--SET @sqlcommand=RTRIM(@sqlcommand)+' '+' insert into #tn_vat_Annexure  SELECT  PART=1,srno1=1,M.CATE,Ac_Name=case when isNull(AC.MailName,'''') = '''' then AC.Ac_Name else AC.MailName end,AC.S_TAX,it.hsncode,taxable_amt= CASE WHEN Lc.STAX_ITEM=1 THEN round(d.u_asseamt+D.EXAMT+D.U_CESSAMT+D.U_HCESAMT+d.tot_add+D.TOT_DEDUC,2) else round(((M.gro_amt+M.tot_add+M.tot_tax)-M.tot_deduc),2) end,TAXAMT= CASE WHEN Lc.STAX_ITEM=1 THEN D.TAXAMT ELSE M.TAXAMT END,LEVEL1=ISNULL(STM.LEVEL1,0)'
		--SET @sqlcommand=RTRIM(@sqlcommand)+' '+'  FROM pTMAIN M '
		--SET @sqlcommand=RTRIM(@sqlcommand)+' '+' INNER JOIN PTITEM D ON (M.ENTRY_TY=D.ENTRY_TY AND M.TRAN_CD=D.TRAN_CD )'
		--SET @sqlcommand=RTRIM(@sqlcommand)+' '+' INNER JOIN AC_MAST AC ON (M.AC_ID=AC.AC_ID)'
		--SET @sqlcommand=RTRIM(@sqlcommand)+' '+' LEFT OUTER JOIN STAX_MAS STM ON (D.TAX_NAME=STM.TAX_NAME And STM.Entry_ty = D.Entry_ty)'
		--SET @sqlcommand=RTRIM(@sqlcommand)+' '+' INNER JOIN IT_MAST IT  ON (D.IT_CODE=IT.IT_CODE)'
		--SET @sqlcommand=RTRIM(@sqlcommand)+' '+' INNER JOIN LCODE lc  ON (lc.ENTRY_TY=D.ENTRY_TY)'
		--set @sqlcommand=@sqlcommand+' '+rtrim(@fcon)
		--PRINT @sqlcommand
		--execute sp_executesql @sqlcommand
		
		--ADDED BY SURAJ K.ON 18-11-2014 END
		
		--<--purchase
		-->Purchase Return
		-----commnet SURAJ K. ON 20-11-2014 FOR BUG-24589 START 
		--execute usp_rep_Taxable_Amount_Itemwise 'PR','i',@fld_list =@fld_list OUTPUT
		--set @fld_list=rtrim(@fld_list)
		--set @sqlcommand='insert into #tn_vat_Annexure select part=1,srno1=2'
		--set @sqlcommand=@sqlcommand+' '+',cate=space(20),acm.ac_name,acm.s_tax,itm.hsncode' --m.cate suraj k. for bug-24589
		--set @sqlcommand=@sqlcommand+' '+',taxable_amt=isnull(sum(round(((I.QTY* I.RATE)+I.EXAMT+I.U_CESSAMT+I.U_HCESAMT+I.tot_add+I.TOT_DEDUC),2)),0)'--sum(i.GRO_AMT-(i.TAXAMT+i.ADDLVAT1))' --,taxable_amt=sum(i.gro_amt'+@fld_list+')' --cmt by suraj k. on 15-11-2014 for bug-24589  as per discuss with sadhan sir
		--set @sqlcommand=@sqlcommand+' '+',taxamt=isnull(sum(round(i.taxamt,2)),0)'		
		--set @sqlcommand=@sqlcommand+' '+',tax_name=space(20),level1=isnull(st.level1,0.00), st_type=space(20) ,u_imporm=space(20)'--,tax_name=isnull(st.tax_name,''''),st_type=isnull(st.st_type,'''') ,u_imporm=space(1)'  --cmt by suraj k. on 18-11-2014 for bug-24589
		----set @sqlcommand=@sqlcommand+' '+',M.INV_NO '
		--set @sqlcommand=@sqlcommand+' '+'from pritem i '
		--set @sqlcommand=@sqlcommand+' '+'inner join prmain m on (m.entry_ty=i.entry_ty and m.tran_cd=i.tran_cd)'
		--set @sqlcommand=@sqlcommand+' '+'inner join ac_mast acm on (i.ac_id=acm.ac_id)'
		--set @sqlcommand=@sqlcommand+' '+'inner join it_mast itm on (i.it_code=itm.it_code)'
		--set @sqlcommand=@sqlcommand+' '+'left outer join  stax_mas st on (st.tax_name=i.tax_name And St.Entry_ty = I.Entry_Ty)'
		--set @sqlcommand=@sqlcommand+' '+rtrim(@fcon)
		----set @sqlcommand=@sqlcommand+' '+'and isnull(m.tax_name,'''')<>'''''
		----set @sqlcommand=@sqlcommand+' '+'group by m.cate,acm.ac_name,acm.s_tax,itm.hsncode,st.tax_name,st.level1,st.st_type,acm.s_tax' --cmt by sura k. on 18-11-2014 for bug-24589
		--set @sqlcommand=@sqlcommand+' '+'group by acm.ac_name,acm.s_tax,itm.hsncode,st.level1,m.cate'
		--set @sqlcommand=@sqlcommand+' '+'order by acm.ac_name,acm.s_tax,itm.hsncode,st.level1'
		--print @sqlcommand
		--execute sp_executesql @sqlcommand
	-----commnet SURAJ K. ON 20-11-2014 FOR BUG-24589 END
--		execute usp_rep_Taxable_Amount_Itemwise 'ST','i',@fld_list =@fld_list OUTPUT
--		set @fld_list=rtrim(@fld_list)
--		set @sqlcommand='insert into #tn_vat_Annexure select part=1,srno1=2'
--		set @sqlcommand=@sqlcommand+' '+',m.cate,acm.ac_name,acm.s_tax,itm.hsncode'
--		set @sqlcommand=@sqlcommand+' '+',taxable_amt=sum(i.gro_amt'+@fld_list+')'
--		set @sqlcommand=@sqlcommand+' '+',taxamt=isnull(sum(i.taxamt),0)'
--		set @sqlcommand=@sqlcommand+' '+',st.tax_name,st.level1,st.st_type ,m.u_imporm'
--		set @sqlcommand=@sqlcommand+' '+'from stitem i '
--		set @sqlcommand=@sqlcommand+' '+'inner join stmain m on (m.entry_ty=i.entry_ty and m.tran_cd=i.tran_cd)'
--		set @sqlcommand=@sqlcommand+' '+'inner join ac_mast acm on (i.ac_id=acm.ac_id)'
--		set @sqlcommand=@sqlcommand+' '+'inner join it_mast itm on (i.it_code=itm.it_code)'
--		set @sqlcommand=@sqlcommand+' '+'inner join stax_mas st on (st.tax_name=i.tax_name) And St.Entry_ty = I.Entry_Ty'
--		set @sqlcommand=@sqlcommand+' '+rtrim(@fcon)
--		set @sqlcommand=@sqlcommand+' '+'and isnull(m.tax_name,'''')<>''''' +' and m.u_imporm in('+'''Purchase Return'''+')'
--		set @sqlcommand=@sqlcommand+' '+'group by m.cate,acm.ac_name,acm.s_tax,itm.hsncode,st.tax_name,st.level1,st.st_type,m.u_imporm,acm.s_tax'
--		set @sqlcommand=@sqlcommand+' '+'order by st.st_type'
--		print @sqlcommand
--		execute sp_executesql @sqlcommand
		--<--Purchase Return
		-->Net Purchase
		
		select 
		@taxamt=sum(case when srno1=1 then taxamt else -taxamt end)
		,@taxable_amt=sum(case when srno1=1 then taxable_amt else -taxable_amt end)
		from #tn_vat_Annexure 
		where (part=1) and srno1 in (1,2)
		
		--cmt by SURAJ FOR BUG-24589  START
		--insert into #tn_vat_Annexure 
		--(part,srno1,it_desc,ac_name,s_tax,commodity_code,st.st_type ,m.u_imporm
		--,taxable_amt 
		--,tax_name,taxamt,level1)
		--values
		--(1,3,'','','','','',''
		--,@taxable_amt
		--,'',@taxamt,0)
		-- BY SURAJ FOR BUG-24589 END
		--ADD BY SURAJ FOR BUG-24589 START
		
		--insert into #tn_vat_Annexure 
		--(part,srno1,it_desc,ac_name,s_tax,commodity_code,taxable_amt ,taxamt,level1,tax_name)
		--values(1,3,'','','','',@taxable_amt,@taxamt,0,'')

		--<--Net Purchase
	End
select  * from #tn_vat_Annexure  order by srno1  --part,srno1,LEVEL1,IT_DESC,COMMODITY_CODE
-----select  grpby=(rtrim(ac_name)+rtrim(s_tax)+rtrim(st_type)+rtrim(level1)+rtrim(srno1)),* from #tn_vat_Annexure order by part,srno1,LEVEL1,IT_DESC,COMMODITY_CODE   --ADDED BY SURAJ K. ON 15-11-2014 FOR BUG-24589 END








