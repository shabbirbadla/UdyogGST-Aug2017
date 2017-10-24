IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_ENT_SerTax_GAR7_DETAILS]') AND type in (N'P', N'PC'))
Begin
DROP PROCEDURE [dbo].[USP_ENT_SerTax_GAR7_DETAILS]
end
Go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Ruepesh Prajapati
-- Create date: 18/06/2009
-- Description:	This Stored procedure is useful in Auto Service Tax BILL Selection for GAR-7  project uesertaxpayment.app.
-- Modified By\Date\Reason: Rup 01/06/2011 TKT-7412. 
-- Remark:
/*
Modification By : Vasant
Modification On : 25-02-2013
Bug Details		: Bug-6092 ( Required "Service Tax REVERSE CHARGE MECHANISM" in our Default Products.)
Search for		: BUG6092
*/
--Modification By : Shrikant 
--Modification On : 17/11/2015
--Bug Details		: Bug-27242 ( Required Swachh Bharat Cess )
--Modification By : Shrikant 
--Modification On : 27/05/2016
--Bug Details		: Bug-28132 ( Required Krishi Kalyan Cess )
-- =============================================
create procedure [dbo].[USP_ENT_SerTax_GAR7_DETAILS]
@entry_ty varchar(2),@tran_cd int ,@date smalldatetime
as
begin
	declare @sqlcommand nvarchar(4000),@whcon nvarchar(1000)
	set @whcon=''
	
	select entry_all,main_tran,acseri_all,new_all=sum(new_all) 
	into #mall 
	from mainall_vw 
	inner join ac_mast a on (a.ac_id=mainall_vw.ac_id)
	where ( entry_ty+rtrim(cast(tran_cd as varchar)) ) <> ( @entry_ty+rtrim(cast(@tran_cd as varchar)) )
	/*and a.typ in ('Service Tax Payable','Service Tax Payable-Ecess','Service Tax Payable-Hcess','GTA Service Tax Payable','GTA Service Tax Payable-Ecess','GTA Service Tax Payable-Hcess') TKT-7412 Rup 01/06/2011*/ 
	--and a.typ in ('GTA Service Tax Payable','GTA Service Tax Payable-Ecess','GTA Service Tax Payable-Hcess','Service Tax Payable','Service Tax Payable-Ecess','Service Tax Payable-Hcess')	--BUG6092			--Commented by Shrikant S. on 17/11/2015 for Bug-27242
	--and a.typ in ('GTA Service Tax Payable','GTA Service Tax Payable-Ecess','GTA Service Tax Payable-Hcess','Service Tax Payable','Service Tax Payable-Ecess','Service Tax Payable-Hcess','Swachh Bharat Cess Payable')	--Added by Shrikant S. on 17/11/2015 for Bug-27242
	and a.typ in ('GTA Service Tax Payable','GTA Service Tax Payable-Ecess','GTA Service Tax Payable-Hcess','Service Tax Payable','Service Tax Payable-Ecess','Service Tax Payable-Hcess','Swachh Bharat Cess Payable','Krishi Kalyan Cess Payable')	--Added by Shrikant S. on 27/05/2016 for Bug-28132
	group by entry_all,main_tran,acseri_all

	/*select sel=cast(0 as bit),ac.entry_ty,ac.tran_cd,ac.acserial,a.ac_name,ac.amount,new_all=ac.amount,ac.amt_ty,a.typ
	,ac.Serty,party_nm=a.ac_name,m.inv_no,m.date,tpayment=cast(0 as decimal(17,2)),m.l_yn,ac.ac_id,m.inv_sr,isused=3,m.net_amt,compid=999
	into #SerTaxDetails
	from SerTAxAcDet_vw ac 
	inner join ac_mast a on (a.ac_id=ac.ac_id)
	inner join lmain_vw m on (ac.entry_ty=m.entry_ty and ac.tran_cd=m.tran_cd)
	where 1=2*/
	
	/*Insert into #SerTaxDetails
	(sel,entry_ty,tran_cd,acserial,ac_name,amount,new_all,amt_ty,typ
	,Serty,party_nm,inv_no,date,tpayment,l_yn,ac_id,inv_sr,isused,net_amt,compid)*/

	select sel=cast(0 as bit),m.entry_ty,m.tran_cd,ac.acserial,a.ac_name,ac.amount,new_all=isnull(mall.new_all,0),ac.amt_ty,a.typ
	,ac.Serty,party_nm=ac_mast.mailName,m.inv_no,m.date,tpayment=cast(0 as decimal(17,2)),m.l_yn,ac.ac_id,m.inv_sr,isused=0,m.net_amt,compid=0
	,TrnType=l.code_nm
	from SerTaxMain_vw m
	INNER JOIN SerTaxAcDet_vw ac on (m.entry_ty=ac.entry_ty and m.tran_cd=ac.tran_cd)
	inner join ac_mast on (ac_mast.ac_id=m.ac_id)
	inner join ac_mast a on (a.ac_id=ac.ac_id)
	left join #mall mall on(ac.entry_ty=mall.entry_all and ac.tran_cd=main_tran and ac.acserial=acseri_all)
	inner join lcode l on (l.entry_ty=m.entry_ty)
	--where a.typ in ('GTA Service Tax Payable','GTA Service Tax Payable-Ecess','GTA Service Tax Payable-Hcess','Service Tax Payable','Service Tax Payable-Ecess','Service Tax Payable-Hcess')	--BUG6092		--Commented by Shrikant S on 17/11/2015 for Bug-27242
	--where a.typ in ('GTA Service Tax Payable','GTA Service Tax Payable-Ecess','GTA Service Tax Payable-Hcess','Service Tax Payable','Service Tax Payable-Ecess','Service Tax Payable-Hcess','Service Tax Payable-SBcess')	--Added by Shrikant S on 17/11/2015 for Bug-27242	
	where a.typ in ('GTA Service Tax Payable','GTA Service Tax Payable-Ecess','GTA Service Tax Payable-Hcess','Service Tax Payable','Service Tax Payable-Ecess','Service Tax Payable-Hcess','Service Tax Payable-SBcess','Krishi Kalyan Cess Payable')	--Added by Shrikant S on 27/05/2016 for Bug-28132
	and ac.amt_ty='CR'
	and ac.amount<>isnull(mall.new_all,0)
	and ac.date<=@date
	and (l.entry_ty in ('BP','CP','B1','C1','IF','OF') or l.bcode_nm in ('BP','CP','B1','C1','IF','OF')) --BUG6092
	order by m.date,inv_no
	/*select * from #SerTaxDetails order by date,inv_no*/
	/*drop table #SerTaxDetails*/
end
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

