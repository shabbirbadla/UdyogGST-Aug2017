IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Usp_Ent_Get_Column_Description]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Usp_Ent_Get_Column_Description]
Go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

-- =============================================
-- Author:		Amrendra Kumar Singh
-- Create date: 07/06/2012
-- Description:	This Stored procedure is useful to get Column Description From SQL Table MetaData 
-- Modification Date/By/Reason: 
-- Remark:
-- =============================================

Create Procedure [dbo].[Usp_Ent_Get_Column_Description]
@TableName varchar(60)--,@uniqueCol varchar(60)
as
Begin

	--Set @TableName='EmployeeMast'
	Select [objName],[Value] into #ColList From fn_ListExtendedProperty (null,'SCHEMA','dbo','TABLE',@TableName,'Column',null)
	Declare @Col varchar(60),@SqlCommand nvarchar(4000),@Col_Desc varchar(60) ,@Value varchar(60)
	Declare cur_col cursor for Select c.[Name] From Syscolumns c  inner join sysobjects o on (c.id=o.id) where o.[name]=@TableName
	open cur_col
	set @SqlCommand=''
--	set @SqlCommand=rtrim(@uniqueCol)+' as uniqueCol'

	Fetch next From cur_col into @Col
	while(@@fetch_status=0)
	begin
		set @SqlCommand=rtrim(@SqlCommand)+',['+rtrim(@Col)+']'
		Fetch next From cur_col into @Col
	end
	close cur_col
	DeAllocate cur_col

	Declare cur_col cursor for Select [objName],cast([Value] as varchar(60)) From #ColList
	open cur_col

	Fetch next From cur_col into @col,@Value
	while(@@fetch_status=0)
	begin
		set @SqlCommand=replace( @SqlCommand,'['+@Col+']',@Col+':'+@Value)
		Fetch next From cur_col into @col,@Value
	end
	close cur_col
	DeAllocate cur_col

	drop table #ColList
	set @SqlCommand=substring(@SqlCommand,2,len(@SqlCommand)-1)
	--set @SqlCommand='Select '+rtrim(@SqlCommand)+' From '+@TableName
	--execute sp_executeSql @SqlCommand 
	select @SqlCommand as colfilt
	print 'f1 '+@SqlCommand
end


