/****** Object:  StoredProcedure [dbo].[USP_ENT_EMAILCLIENT_SELECT_SEARCH]    Script Date: 01/23/2014 17:15:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS(SELECT [NAME] FROM SYS.OBJECTS WHERE [NAME]='USP_ENT_EMAILCLIENT_SELECT_SEARCH' AND TYPE='P')
BEGIN
	DROP PROCEDURE [USP_ENT_EMAILCLIENT_SELECT_SEARCH]
END
GO

--===== Procedure for Populating Records from Email Client table =====--
-- Created by/On/For : Sachin N. S. on 11/03/2014 for Bug-20211
--====================================================================--

Create Procedure [dbo].[USP_ENT_EMAILCLIENT_SELECT_SEARCH]
As
Begin
	Select * From eMailClient
End
