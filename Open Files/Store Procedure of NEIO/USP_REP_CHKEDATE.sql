set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER     PROCEDURE [dbo].[USP_REP_CHKEDATE] 
@MONTH INT,@YEAR INT, @RVAL INT OUTPUT
AS

PRINT 'A'+STR(@YEAR)
IF @MONTH  IN (1,3,5,7,8,10,12 ) BEGIN
	SET @RVAL= 31
END
IF @MONTH IN (2 ) BEGIN
	---IF ( @YEAR%4=0 AND @YEAR%100<>0) or (@YEAR % 400=0)
	IF(@YEAR % 4 = 0) OR (@YEAR % 4 = 0 AND @YEAR % 100 = 0 AND @YEAR % 400 = 0)
	BEGIN
		SET @RVAL =29
	END
	ELSE
	BEGIN
		SET @RVAL =28
	END
END
IF @MONTH IN (4,6,9,11 ) BEGIN
	SET @RVAL =30
END

PRINT 'B'+STR(@RVAL)


