If Exists(Select [Name] from Sysobjects where xType='P' and Id=Object_Id(N'Usp_Gen_Inv_Updation'))
Begin
	Drop Procedure Usp_Gen_Inv_Updation
End
Go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


-- =============================================
-- Author:Rupesh Prajapati		
-- Create date: 22/11/2011
-- Description:	This Stored procedure is useful to renumbering doc_no field.
-- =============================================


create   PROCEDURE [dbo].[Usp_Gen_Inv_Updation]
@Entry_ty varchar(2),@FinYear varchar(9)
AS
BEGIN
	Print 'Entry Ty = '+@Entry_ty
	--DECLARE @DT DATETIME,@INVNO varchar(20),@INV_ARR INT,@DOCNO INT,@DOC INT,@tran_cd numeric(10),@tblName varchar(10),@tblName1 varchar(10),@Entry_ty1 varchar(2),@tmpTable varchar(20),@SqlCommand nvarchar(4000)
	DECLARE @SqlCommand nvarchar(4000),@SeriesMaxValue varchar(10),@SeriesValue varchar(10),@SeriesDate datetime
	DECLARE @tblName varchar(10),@SeriesName varchar(20),@SeriesPfx varchar(10),@SeriesSfx varchar(10)
	set @SeriesPfx=''
	set @SeriesSfx=''
	set @SeriesName=''
	set @SeriesMaxValue=''
	set @SeriesValue=''
	select @tblName=(case when ext_vou=0 then Entry_Ty else bCode_Nm end)+'Main' from lcode where entry_ty=@Entry_ty

	set @SqlCommand='declare currSeries cursor for select distinct inv_sr from '+@tblName +' where l_yn='+char(39)+@FinYear+char(39)
	print @SqlCommand
	execute sp_ExecuteSql @SqlCommand
	open currSeries
	fetch next from currSeries into @SeriesName
	while (@@fetch_status=0)
	begin
		print 'Series Name : '+@SeriesName+'  :End'
		
--		set @SqlCommand='select i_prefix,i_suffix,inv_sr into ##Series_vw  from series where inv_sr='+char(39)+rtrim(@SeriesName)+char(39)
		set @SqlCommand='select @SeriesPfx=i_prefix,@SeriesSfx=i_suffix from series where inv_sr='+char(39)+rtrim(@SeriesName)+char(39)
		print @SqlCommand
--		execute sp_ExecuteSql @SqlCommand
		execute sp_ExecuteSql @SqlCommand,N'@SeriesPfx varchar(10) output,@SeriesSfx varchar(10) output',@SeriesPfx=@SeriesPfx output,@SeriesSfx=@SeriesSfx output
--		select @SeriesPfx=i_prefix from ##Series_vw
--		select @SeriesSfx=i_suffix from ##Series_vw

		print 'Prefix : '+@SeriesPfx
		print 'Suffix : '+@SeriesSfx
		if (len(@SeriesPfx)>0)
		begin
			set @SqlCommand='select inv_no,substring(inv_no,len(replace(@SeriesPfx,char(39),''''))+1,len(inv_no)-len(replace(@SeriesPfx,char(39),''''))) from '+@tblName+' where inv_sr='+char(39)+rtrim(@SeriesName)+char(39)+' and l_yn='+char(39)+@FinYear+char(39)
			set @SqlCommand='select @SeriesValue=inv_no,@SeriesDate=date,@oSeriesMaxValue=max(substring(inv_no,len(replace(@SeriesPfx,char(39),''''))+1,len(inv_no)-len(replace(@SeriesPfx,char(39),'''')))) from '+@tblName+' where inv_sr='+char(39)+Rtrim(@SeriesName)+char(39)+' and l_yn='+char(39)+@FinYear+char(39)+' group by inv_no,date'
			print @SqlCommand
			--execute sp_ExecuteSql @SqlCommand
			execute sp_ExecuteSql @SqlCommand,N'@SeriesPfx varchar(10),@oSeriesMaxValue varchar(10) output,@SeriesValue varchar(10) output,@SeriesDate datetime output',@SeriesPfx=@SeriesPfx,@oSeriesMaxValue=@SeriesMaxValue output,@SeriesValue=@SeriesValue output,@SeriesDate=@SeriesDate output
			Print 'SeriesMaxValue : '+@SeriesMaxValue
			Print 'SeriesValue : '+@SeriesValue
			Print 'SeriesValue : '+convert(varchar(10),@SeriesDate,103)
----Gen_Inv
			if exists (select * from gen_inv where entry_ty=@entry_ty and inv_sr=@SeriesName and l_yn=@FinYear)
			begin
				update gen_inv set inv_no=@SeriesMaxValue,inv_dt=@SeriesDate where entry_ty=@entry_ty and inv_sr=@SeriesName and l_yn=@FinYear
			Print 'Status : Updated'
			end 
			else
			begin
				insert gen_inv values(@entry_ty,@SeriesName,isnull(@SeriesMaxValue,0),@finYear,@SeriesDate,0)
				Print 'Status : Inserted'
			end
		end
		fetch next from currSeries into @SeriesName
--		drop table ##Series_vw
		end 
	CLOSE currSeries
	DEALLOCATE currSeries
END






