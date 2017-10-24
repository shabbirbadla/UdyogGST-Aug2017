set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


-- =============================================
-- Author:		Ruepesh Prajapati
-- Create date: 
-- Description:	This Stored procedure is useful in Account Selection in uereport.app.
-- Modify By/Date/Reason: Rupesh Prajapati. 19/02/2010 to Add It_Desc Column. TKT-110.
-- Modify By/Date/Reason: Shrikant S. 14/04/2010 for TKT-648.
-- Modify By/Date/Reason: Shrikant S. 12/05/2010 for TKT-648.
-- Remark:
-- =============================================
ALTER  procedure [dbo].[Usp_Acc_SubGroups]
@accountname as nvarchar(4000)=''
as
declare @reccount integer,@Sqlcommand Nvarchar(4000)

--Added by Shrikant S. on 14/04/2010 for TKT-648		&& Start
set @accountname=''''+replace(@accountname,',',''',''')+''''
select ac_group_name,[group] into #groups from ac_group_mast where 1=2  
set @Sqlcommand='insert into #groups select ac_group_name,[group] from ac_group_mast where ac_group_name in ('+@accountname+')' 
print @Sqlcommand														
Execute sp_Executesql @Sqlcommand										
--Added by Shrikant S. on 14/04/2010 for TKT-648		&& End

--charindex(rtrim(ac_group_name),@accountname,1)<>0 --Commented by Shrikant S. on 14/04/2010 for TKT-648
select ac_group_name,[group] into #group1 from #groups
set @reccount = 2
while @reccount>1
begin
	select ac_group_name,[group] into #group2 from ac_group_mast 
		where [group] in (select ac_group_name from #group1)
	insert into #groups select * from #group2
	delete from #group1
	insert into #group1 select ac_group_name,[group] from #group2
	drop table #group2
	set @reccount = (select count(ac_group_name) from #group1)
end
drop table #group1
select ac_name,[group],MailName from ac_mast where [group] in (select ac_group_name from #groups group by ac_group_name) order by ac_name
drop table #groups





