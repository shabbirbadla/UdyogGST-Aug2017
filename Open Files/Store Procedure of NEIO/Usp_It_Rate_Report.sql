set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go









ALTER procedure [dbo].[Usp_It_Rate_Report]
as 
	SELECT  a.it_name,
		a.rateunit,
		a.rateper,
		c.Ac_Name
		FROM IT_MAST A,It_rate b,Ac_Mast c
	        where a.It_Code = b.It_Code
		And b.Ac_id = C.Ac_Id








