IF EXISTS(SELECT * FROM SYS.OBJECTS WHERE [NAME]='usp_Ent_Emp_Leave_Maintenance')
BEGIN
DROP PROCEDURE usp_Ent_Emp_Leave_Maintenance
END
GO

-- =============================================
-- Author     :		
-- Create date: 
-- Description:	
-- =============================================

Create procedure [dbo].[usp_Ent_Emp_Leave_Maintenance]
@Pay_Year varchar(60),@Pay_Month int,@Loc_Nm varchar(100),@Dept varchar(30),@Cate Varchar(30),  @EmpNm varchar(100),@Action varchar(20)
as
begin
	print ''
	Declare @SqlCommand nvarchar(4000)
	Declare @Lv_Code varchar(3)
	--Select e.EmployeeName,e.EmployeeCode From EmployeeMast e
	--select * from Emp_Leave_Maintenance
	Set @SqlCommand='select Sel=cast(0 as bit),Pay_Year=isnull(L.Pay_Year,0),Id=isnull(L.Id,0),Pay_Month=isnull(L.Pay_Month,0),isnull(datename(month,dateadd(month, Pay_Month - 1, 0)),'''') as cMonth,e.EmployeeName,e.EmployeeCode'
	select @SqlCommand=rtrim(@SqlCommand)+''+',e.Department,e.Category,Loc_Code=isnull(Lc.Loc_Code,''''),Loc_Desc=isnull(Lc.Loc_Desc,'''')'
	Declare cur_lv cursor for select Distinct att_Code From Emp_Attendance_Setting where isLeave=1 and ldeactive=0
	Open cur_lv
	Fetch Next From cur_lv into @Lv_Code
	While (@@Fetch_Status=0)
	Begin
		select @SqlCommand=rtrim(@SqlCommand)+',isNull(L.'+case
							when @action='opening' then @Lv_Code+'_OpBal'
							when @action='credit' then @Lv_Code+'_Credit'
							else @Lv_Code+'_EnCash' end
							+',0) as '+ @Lv_Code
		Fetch Next From cur_lv into @Lv_Code
	End
	Close cur_lv
	DeAllocate cur_lv
	print @SqlCommand

	Declare @Lv_Codebal varchar(30),@SortOrdbal int  /*Ramya for leave balance*/

	Declare cur_lvbal cursor for select Distinct att_Code,SortOrd From Emp_Attendance_Setting where isleave=1 and LDeactive=0 order by SortOrd
	Open cur_lvbal
	Fetch Next From cur_lvbal into @Lv_Codebal,@SortOrdbal
	While (@@Fetch_Status=0)
	Begin
		select @SqlCommand=rtrim(@SqlCommand)+',isNull(L.'+@Lv_Codebal+'_Balance'+',0) as ['+ @Lv_Codebal+'_Balance]'
		Fetch Next From cur_lvbal into @Lv_Codebal,@SortOrdbal
	End
	Close cur_lvbal
	DeAllocate cur_lvbal                          /*Ramya for leave balance*/

	Set @SqlCommand=rtrim(@SqlCommand)+' '+'From EmployeeMast e '
	set @SqlCommand=rtrim(@SqlCommand)+' '+'Left Join Emp_Leave_Maintenance L on (e.EmployeeCode=L.EmployeeCode)'
	set @SqlCommand=rtrim(@SqlCommand)+' '+'Left Join Loc_Master Lc on (Lc.Loc_Code=E.Loc_Code)'
	set @SqlCommand=rtrim(@SqlCommand)+' '+' where 1=1'



	if isnull(@Pay_Year,'')<>''
	Begin
		set @SqlCommand=rtrim(@SqlCommand)+' '+' and L.Pay_Year='+char(39)+@Pay_Year+char(39)
	end
	if isnull(@Pay_Month,0)<>0
	Begin
		set @SqlCommand=rtrim(@SqlCommand)+' '+' and L.Pay_Month='+cast(@Pay_Month as varchar)
	end
	if isnull(@Loc_Nm,'')<>''
	Begin
		set @SqlCommand=rtrim(@SqlCommand)+' '+' and Lc.Loc_Desc='+Char(39)+@Loc_Nm+Char(39)
	end

	if isnull(@Dept,'')<>''
	Begin
		set @SqlCommand=rtrim(@SqlCommand)+' '+' and E.Department='+Char(39)+@Dept+Char(39)
	end
	if isnull(@Cate,'')<>''
	Begin
		set @SqlCommand=rtrim(@SqlCommand)+' '+' and E.Category='+Char(39)+@Cate+Char(39)
	end
	if isnull(@EmpNm,'')<>''
	Begin
		set @SqlCommand=rtrim(@SqlCommand)+' '+' and E.EmployeeName='+Char(39)+@EmpNm+Char(39)
	end
	Print @SqlCommand
	Execute Sp_ExecuteSql @SqlCommand
end




