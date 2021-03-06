/****** Object:  Table [dbo].[imp_master]    Script Date: 12/13/2011 14:33:14 ******/
IF  not EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ImpDataTableUpdate]') AND type in (N'U'))
begin
	CREATE TABLE [dbo].[ImpDataTableUpdate](
		[Code] [varchar](3) ,
		[TableName] [varchar](60) ,
		[UpdateStmt] [varchar](1000),
		[FilterCondition] [varchar](1000) ,
		[updOrder] [int] 
	) ON [PRIMARY]
end 
IF  not EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[imp_master]') AND type in (N'U'))
begin
	CREATE TABLE [dbo].[imp_master](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[Code] [varchar](3) ,
		[Description] [varchar](30) ,
		[Category] [varchar](20) ,
		[Tables] [varchar](1000) ,
		[ImpLocDet] [varchar](30) ,
		[Import] [bit] ,
		[sortOrd] [int] NULL default 0 ,
		[LImpUserNm] [varchar](30) ,
		[LastImpDate] [datetime] ,
		[ImpNote] [varchar](4000) ,		
		[Sp_Name] [varchar](30) ,
	) ON [PRIMARY]
END
IF NOT EXISTS(SELECT [Code] FROM imp_master WHERE Code = 'IT')BEGIN 	INSERT INTO imp_master([CODE],[DESCRIPTION],[CATEGORY],[TABLES],[IMPLOCDET],[IMPORT],[SORTORD],[LIMPUSERNM],[LASTIMPDATE],[IMPNOTE],[SP_NAME]) 	VALUES ('IT','ITEM and Group Master','Master','<<ITEM_GROUP##KeyFld<IT_GROUP_NAME>##ExcludeFld<itgrid,CompId,DataImport>##FName<ITEM_GROUP>>><<IT_MAST##KeyFld<IT_Name>##ExcludeFld<ittyid,itgrid,it_code,CompId,DataImport>##FName<IT_MAST>>>','<<AV1##<IM>>>',1,2,'','01/01/1900 12:00:00 AM','','Usp_DataImport_ITEM_Master')END 
IF NOT EXISTS(SELECT [Code] FROM imp_master WHERE Code = 'AG')BEGIN	INSERT INTO imp_master([CODE],[DESCRIPTION],[CATEGORY],[TABLES],[IMPLOCDET],[IMPORT],[SORTORD],[LIMPUSERNM],[LASTIMPDATE],[IMPNOTE],[SP_NAME]) 	VALUES ('AG','Account Group Master','Master','<<Ac_Group_Mast##ExcludeFld<ac_group_id,gac_id,DataImport>>>','',1,1,'','01/01/1900 12:00:00 AM','','Usp_DataImport_Ac_Group_Master') END IF NOT EXISTS(SELECT [Code] FROM imp_master WHERE Code = 'AM')BEGIN 	INSERT INTO imp_master([CODE],[DESCRIPTION],[CATEGORY],[TABLES],[IMPLOCDET],[IMPORT],[SORTORD],[LIMPUSERNM],[LASTIMPDATE],[IMPNOTE],[SP_NAME]) 	VALUES ('AM','Account_Master','Master','<<Ac_Mast##KeyFld<AC_Name>##ExcludeFld<Ac_group_id,Ac_Id,State_Id,City_Id,Country_Id,Ac_type_id,CompId,DataImport>##FName<AC_MAST>>><<shipto##KeyFld<Mail_Name,Location_ID>##ExcludeFld<state_id,city_id,country_id,ac_id,shipto_id,Ac_type_id,CompId,DataImport>##FName<ShipTo>>>','<<AV1##<IM>>>',1,2,'','01/01/1900 12:00:00 AM','','Usp_DataImport_Account_Master')END IF NOT EXISTS(SELECT [Code] FROM imp_master WHERE Code = 'AS')BEGIN 	INSERT INTO imp_master([CODE],[DESCRIPTION],[CATEGORY],[TABLES],[IMPLOCDET],[IMPORT],[SORTORD],[LIMPUSERNM],[LASTIMPDATE],[IMPNOTE],[SP_NAME]) 	VALUES ('AS','Series_Master','Master','<<Series##KeyFld<Inv_Sr>##ExcludeFld<DataImport>##FName<Series>>>','<<AV1##<IM>>>',1,2,'','01/01/1900 12:00:00 AM','','Usp_DataImport_Series_Master')END IF NOT EXISTS(SELECT [Code] FROM imp_master WHERE Code = 'AR')BEGIN 	INSERT INTO imp_master([CODE],[DESCRIPTION],[CATEGORY],[TABLES],[IMPLOCDET],[IMPORT],[SORTORD],[LIMPUSERNM],[LASTIMPDATE],[IMPNOTE],[SP_NAME]) 	VALUES ('AR','Goods Receipt','Transaction','<<ARMAIN##ExcludeFld<Tran_Cd,Ac_Id,Cons_Id,Scons_Id,DataImport>>><<ARITEM##ExcludeFld<Tran_Cd,DataImport>>><<MANU_DET##ExcludeFld<DataImport>>><<GEN_SRNO##ExcludeFld<DataImport>>>','',1,3,'',' ','','Usp_DataImport_AR') END IF NOT EXISTS(SELECT [Code] FROM imp_master WHERE Code = 'DC')BEGIN 	INSERT INTO imp_master([CODE],[DESCRIPTION],[CATEGORY],[TABLES],[IMPLOCDET],[IMPORT],[SORTORD],[LIMPUSERNM],[LASTIMPDATE],[IMPNOTE],[SP_NAME]) 	VALUES ('DC','Delivery Challan','Transaction','<<DCMAIN##ExcludeFld<Tran_Cd,Ac_Id,Cons_Id,Scons_Id,DataImport>>><<DCITEM##ExcludeFld<Tran_Cd,DataImport>>><<LItemAll##ExcludeFld<DataImport>>>','',1,4,'',' ','','Usp_DataImport_DC') END 
exec add_columns 'ITEM_GROUP','DataImport Varchar(200) default '''' with values'
exec add_columns 'IT_MAST','DataImport Varchar(200) default '''' with values'exec add_columns 'ARMAIN','DataImport Varchar(200) default '''' with values'
exec add_columns 'ARITEM','DataImport Varchar(200) default '''' with values'
exec add_columns 'MANU_DET','DataImport Varchar(200) default '''' with values'
exec add_columns 'AC_Group_Mast','DataImport Varchar(200) default '''' with values'
exec add_columns 'AC_Mast','DataImport Varchar(200) default '''' with values'
exec add_columns 'Series','DataImport Varchar(200) default '''' with values'
exec add_columns 'ShipTO','DataImport Varchar(200) default '''' with values'
exec add_columns 'LITEMALL','DataImport Varchar(200) default '''' with values'
exec add_columns 'DCMAIN','DataImport Varchar(200) default '''' with values'
exec add_columns 'DCITEM','DataImport Varchar(200) default '''' with values'
exec add_columns 'GEN_SRNO','DataImport Varchar(200) default '''' with values'

exec add_columns 'ITEM_GROUP','DataExport Varchar(200) default '''' with values'
exec add_columns 'IT_MAST','DataExport Varchar(200) default '''' with values'exec add_columns 'ARMAIN','DataExport Varchar(200) default '''' with values'
exec add_columns 'ARITEM','DataExport Varchar(200) default '''' with values'
exec add_columns 'MANU_DET','DataExport Varchar(200) default '''' with values'
exec add_columns 'AC_Group_Mast','DataExport Varchar(200) default '''' with values'
exec add_columns 'AC_Mast','DataExport Varchar(200) default '''' with values'
exec add_columns 'Series','DataExport Varchar(200) default '''' with values'
exec add_columns 'ShipTO','DataExport Varchar(200) default '''' with values'
exec add_columns 'LITEMALL','DataExport Varchar(200) default '''' with values'
exec add_columns 'DCMAIN','DataExport Varchar(200) default '''' with values'
exec add_columns 'DCITEM','DataExport Varchar(200) default '''' with values'
exec add_columns 'GEN_SRNO','DataExport Varchar(200) default '''' with values'

use vudyog
exec add_columns 'co_mast','IE_LOCCODE Varchar(3) default '''' with values'

