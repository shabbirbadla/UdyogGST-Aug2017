set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[TestProc]
	 @TableName AS Varchar(10) = NULL,@SQLCOND AS VARCHAR(50) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @SQLCOMMAND NVARCHAR(4000)
	SET @SQLCOMMAND='SELECT * FROM '+@TABLENAME+' WHERE '+@SQLCOND
	EXECUTE SP_EXECUTESQL @SQLCOMMAND
END

