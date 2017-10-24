
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[UserHist_vw]
AS
SELECT     user_name, date, entry_ty, inv_no
FROM         dbo.ARMAIN
UNION ALL
SELECT     user_name, date, entry_ty, inv_no
FROM         dbo.BPMAIN
UNION ALL
SELECT     user_name, date, entry_ty, inv_no
FROM         dbo.BRMAIN
UNION ALL
SELECT     user_name, date, entry_ty, inv_no
FROM         dbo.CNMAIN
UNION ALL
SELECT     user_name, date, entry_ty, inv_no
FROM         dbo.CPMAIN
UNION ALL
SELECT     user_name, date, entry_ty, inv_no
FROM         dbo.CRMAIN
UNION ALL
SELECT     user_name, date, entry_ty, inv_no
FROM         dbo.DCMAIN
UNION ALL
SELECT     user_name, date, entry_ty, inv_no
FROM         dbo.DNMAIN
UNION ALL
SELECT     user_name, date, entry_ty, inv_no
FROM         dbo.EPMAIN
UNION ALL
SELECT     user_name, date, entry_ty, inv_no
FROM         dbo.EQMAIN
UNION ALL
SELECT     user_name, date, entry_ty, inv_no
FROM         dbo.ESMAIN
UNION ALL
SELECT     user_name, date, entry_ty, inv_no
FROM         dbo.IIMAIN
UNION ALL
SELECT     user_name, date, entry_ty, inv_no
FROM         dbo.IPMAIN
UNION ALL
SELECT     user_name, date, entry_ty, inv_no
FROM         dbo.IRMAIN
UNION ALL
SELECT     user_name, date, entry_ty, inv_no
FROM         dbo.JVMAIN
UNION ALL
SELECT     user_name, date, entry_ty, inv_no
FROM         dbo.OBMAIN
UNION ALL
SELECT     user_name, date, entry_ty, inv_no
FROM         dbo.OPMAIN
UNION ALL
SELECT     user_name, date, entry_ty, inv_no
FROM         dbo.PCMAIN
UNION ALL
SELECT     user_name, date, entry_ty, inv_no
FROM         dbo.POMAIN
UNION ALL
SELECT     user_name, date, entry_ty, inv_no
FROM         dbo.PTMAIN
UNION ALL
SELECT     user_name, date, entry_ty, inv_no
FROM         dbo.PRMAIN
UNION ALL
SELECT     user_name, date, entry_ty, inv_no
FROM         dbo.SOMAIN
UNION ALL
SELECT     user_name, date, entry_ty, inv_no
FROM         dbo.SQMAIN
UNION ALL
SELECT     user_name, date, entry_ty, inv_no
FROM         dbo.SRMAIN
UNION ALL
SELECT     user_name, date, entry_ty, inv_no
FROM         dbo.SSMAIN
UNION ALL
SELECT     user_name, date, entry_ty, inv_no
FROM         dbo.STMAIN
UNION ALL
SELECT     user_name, date, entry_ty, inv_no
FROM         dbo.SBMAIN
UNION ALL
SELECT     user_name, date, entry_ty, inv_no
FROM         dbo.TRMAIN
UNION ALL
SELECT     user_name, date, entry_ty, inv_no
FROM         dbo.OSMAIN
UNION ALL
SELECT     user_name, date, entry_ty, inv_no
FROM         dbo.MAIN
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

