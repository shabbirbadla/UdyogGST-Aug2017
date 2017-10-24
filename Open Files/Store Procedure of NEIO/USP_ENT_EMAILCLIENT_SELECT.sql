set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


IF EXISTS(SELECT [NAME] FROM SYS.OBJECTS WHERE [NAME]='USP_ENT_EMAILCLIENT_SELECT' AND TYPE='P')
BEGIN
	DROP PROCEDURE [USP_ENT_EMAILCLIENT_SELECT]
END
GO 

--===== Procedure for Populating Records from Masters =====--
-- Created by/On/For : Sachin N. S. on 11/03/2014 for Bug-20211
--=========================================================--
CREATE Procedure [dbo].[USP_ENT_EMAILCLIENT_SELECT]
@action varchar(20),
@id varchar(20)='',
@custnm varchar(100)=''
As
Begin
	--print @action
	If rtrim(upper(@action)) = 'SELECT'
	Begin
--		Select * From eMailClient Where id=@id
		Select a.*,b.Qtable,B.spWhat,b.SQLQuery From eMailClient a
			inner join r_status b on a.RepGroup=b.[group] and a.RepDesc=b.[Desc] and a.RepRep_nm=b.[Rep_nm]
			Where id=@id		-- Changed by Sachin N. S. on 20/01/2014 for Bug-20211
	End
	
	If rtrim(upper(@action)) = 'AC_MAST'
	Begin
	if @custnm <> '*'
	Begin
		Select Mailname,Email From Ac_Mast 
		Where rtrim(Mailname) like '%' + @custnm +'%'
		and [group] in ('SUNDRY CREDITORS','SUNDRY DEBTORS')
		Order by Mailname
	End
	Else
	Begin
		Select Mailname,Email From Ac_Mast 
		Where [group] IN ('SUNDRY CREDITORS','SUNDRY DEBTORS')
		Order by Mailname
	End
	End

	-- Added by Sachin N. S. on 14/01/2014 for Bug-20211 -- Start
	If rtrim(upper(@action)) = 'REPORTWIZARD'
	Begin
		Select REPGROUP=[GROUP], REPDESC=[DESC],REPREP_NM=REP_NM,SQLQUERY,SPWHAT,QTABLE From R_STATUS WHERE AUTOEMAIL=1 ORDER BY [DESC]
	End
	-- Added by Sachin N. S. on 14/01/2014 for Bug-20211 -- End
End



