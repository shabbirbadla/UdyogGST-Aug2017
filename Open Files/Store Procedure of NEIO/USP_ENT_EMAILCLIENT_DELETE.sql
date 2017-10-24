/****** Object:  StoredProcedure [dbo].[USP_ENT_EMAILCLIENT_DELETE]    Script Date: 01/23/2014 17:17:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS(SELECT [NAME] FROM SYS.OBJECTS WHERE [NAME]='USP_ENT_EMAILCLIENT_DELETE' AND TYPE='P')
BEGIN
	DROP PROCEDURE [USP_ENT_EMAILCLIENT_DELETE]
END
GO
--===== Procedure to Delete Records from Email Client Table =====--
-- Created by/On/For : Sachin N. S. on 11/03/2014 for Bug-20211
--===============================================================--
Create Procedure [dbo].[USP_ENT_EMAILCLIENT_DELETE]
@id varchar(20)
As
Begin
	Delete From eMailClient Where id=@id
End

