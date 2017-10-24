
/****** Object:  StoredProcedure [dbo].[USP_GETEMAILDETAILS]    Script Date: 01/23/2014 17:20:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS(SELECT [NAME] FROM SYS.OBJECTS WHERE [NAME]='USP_GETEMAILDETAILS' AND TYPE='P')
BEGIN
	DROP PROCEDURE [USP_GETEMAILDETAILS]
END
GO

--===== Procedure for Get Email-Ids from Account Master =====--
-- Created by/On/For : Sachin N. S. on 11/03/2014 for Bug-20211
--===========================================================--
Create PROCEDURE [dbo].[USP_GETEMAILDETAILS]
@ACID INT,
@ACNAME VARCHAR(100)
AS
SELECT rtrim(EMAIL) as Email FROM AC_MAST WHERE AC_NAME=@ACNAME

