set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER  Procedure [dbo].[usp_Generate_ISdAllocation]
as

/*BP Against Bill--->*/
insert into isdallocation (entry_ty,tran_cd,serbamt,sercamt,serhamt,aentry_ty,atran_cd,serty,amount,staxable)
select 
mall.Entry_ty,mall.Tran_Cd
,serbamt=sum(case when a.ac_name='Input Service Tax' then mall.tds else 0 end)
,sercamt=sum(case when a.ac_name='Edu. Cess on Input Service Tax' then mall.tds else 0 end)
,serhamt=sum(case when a.ac_name='S & H Cess on Input Service Tax' then mall.tds else 0 end)
,aentry_ty=mall.entry_all,atran_cd=main_tran,m.serty,amount=m.gro_amt,staxable=m.gro_amt
from bpmall mall
inner join bpmain m on (m.entry_ty=mall.entry_ty and m.tran_cd=mall.tran_cd)
inner join bpacdet ac on (mall.entry_ty=ac.entry_ty and mall.tran_cd=ac.tran_cd and mall.acserial=ac.acserial)
inner join ac_mast a on (a.ac_id=ac.ac_id)
where mall.tds<>0 and tdspaytype<>2
and isnull(m.serty,'')<>''
and m.entry_ty+cast(m.tran_cd as varchar) not in (select distinct entry_ty+cast(tran_cd as varchar) from isdallocation)
group by mall.entry_ty,mall.Tran_Cd,mall.entry_all,main_tran,m.serty,m.gro_amt
/*<---BP Against Bill*/

/*CP Against Bill--->*/
insert into isdallocation (entry_ty,tran_cd,serbamt,sercamt,serhamt,aentry_ty,atran_cd,serty,amount,staxable)
select 
mall.Entry_ty,mall.Tran_Cd
,serbamt=sum(case when a.ac_name='Input Service Tax' then mall.tds else 0 end)
,sercamt=sum(case when a.ac_name='Edu. Cess on Input Service Tax' then mall.tds else 0 end)
,serhamt=sum(case when a.ac_name='S & H Cess on Input Service Tax' then mall.tds else 0 end)
,aentry_ty=mall.entry_all,atran_cd=main_tran,m.serty,amount=m.gro_amt,staxable=m.gro_amt
from cpmall mall
inner join cpmain m on (m.entry_ty=mall.entry_ty and m.tran_cd=mall.tran_cd)
inner join cpacdet ac on (mall.entry_ty=ac.entry_ty and mall.tran_cd=ac.tran_cd and mall.acserial=ac.acserial)
inner join ac_mast a on (a.ac_id=ac.ac_id)
where mall.tds<>0 and tdspaytype<>2
and isnull(m.serty,'')<>''
and m.entry_ty+cast(m.tran_cd as varchar) not in (select distinct entry_ty+cast(tran_cd as varchar) from isdallocation)
group by mall.entry_ty,mall.Tran_Cd,mall.entry_all,main_tran,m.serty,m.gro_amt
/*<---CP Against Bill*/

/*BR Against Bill--->*/
insert into isdallocation (entry_ty,tran_cd,serbamt,sercamt,serhamt,aentry_ty,atran_cd,serty,amount,staxable)
select 
mall.Entry_ty,mall.Tran_Cd
,serbamt=sum(case when a.ac_name='Output Service Tax' then mall.tds else 0 end)
,sercamt=sum(case when a.ac_name='Edu. Cess on Output Service Tax' then mall.tds else 0 end)
,serhamt=sum(case when a.ac_name='S & H Cess on OutPut Service Tax' then mall.tds else 0 end)
,aentry_ty=mall.entry_all,atran_cd=main_tran,m.serty,amount=m.gro_amt,staxable=m.gro_amt
from BRmall mall
inner join BRmain m on (m.entry_ty=mall.entry_ty and m.tran_cd=mall.tran_cd)
inner join BRacdet ac on (mall.entry_ty=ac.entry_ty and mall.tran_cd=ac.tran_cd and mall.acserial=ac.acserial)
inner join ac_mast a on (a.ac_id=ac.ac_id)
where mall.tds<>0 and tdspaytype<>2
and isnull(m.serty,'')<>''
and m.entry_ty+cast(m.tran_cd as varchar) not in (select distinct entry_ty+cast(tran_cd as varchar) from isdallocation)
group by mall.entry_ty,mall.Tran_Cd,mall.entry_all,main_tran,m.serty,m.gro_amt
/*<---BR Against Bill*/

/*CR Against Bill--->*/
insert into isdallocation (entry_ty,tran_cd,serbamt,sercamt,serhamt,aentry_ty,atran_cd,serty,amount,staxable)
select 
mall.Entry_ty,mall.Tran_Cd
,serbamt=sum(case when a.ac_name='Output Service Tax' then mall.tds else 0 end)
,sercamt=sum(case when a.ac_name='Edu. Cess on Output Service Tax' then mall.tds else 0 end)
,serhamt=sum(case when a.ac_name='S & H Cess on OutPut Service Tax' then mall.tds else 0 end)
,aentry_ty=mall.entry_all,atran_cd=main_tran,m.serty,amount=m.gro_amt,staxable=m.gro_amt
from crmall mall
inner join crmain m on (m.entry_ty=mall.entry_ty and m.tran_cd=mall.tran_cd)
inner join cpacdet ac on (mall.entry_ty=ac.entry_ty and mall.tran_cd=ac.tran_cd and mall.acserial=ac.acserial)
inner join ac_mast a on (a.ac_id=ac.ac_id)
where mall.tds<>0 and tdspaytype<>2
and isnull(m.serty,'')<>''
and m.entry_ty+cast(m.tran_cd as varchar) not in (select distinct entry_ty+cast(tran_cd as varchar) from isdallocation)
group by mall.entry_ty,mall.Tran_Cd,mall.entry_all,main_tran,m.serty,m.gro_amt
/*<---CR Against Bill*/


select distinct mall.entry_ty,tran_cd,entry_all,main_tran,new_all 
into #bp1 
from mainall_vw mall
inner join lcode l on (l.entry_ty=mall.entry_ty)
where new_all<>0 and mall.entry_ty+cast(tran_cd as varchar) in (select distinct entry_ty+cast(tran_cd as varchar) from isdallocation)
and (l.entry_ty in ('BP') or l.bcode_nm in ('BP','CP','BR','CR') )
order by mall.tran_cd

update a set a.amount=b.new_all-(a.serbamt+a.sercamt+a.serhamt) from isdallocation a inner join #bp1 b on (a.entry_ty=b.entry_ty and a.tran_cd=b.tran_Cd and a.aentry_ty=b.entry_all and a.atran_cd=b.main_tran)

update m set m.staxable=(m1.serbamt*(m1.gro_amt-m1.sabtamt))/(m.serbamt) from isdallocation m inner join sertaxmain_vw m1 on (m1.entry_ty=m.aentry_ty and m1.tran_cd=m.atran_cd) where m.serbamt<>0

--select * from isdallocation










