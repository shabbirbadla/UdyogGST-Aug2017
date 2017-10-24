
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER view [dbo].[EntDet_vw]
as
SELECT     Tran_cd, entry_ty, inv_no, date, l_yn, user_name, Sysdate, inv_sr, cate, dept, Print_flag, apgen, apgenby, Apled, Apledby, Apledtime, 
                      Ac_id
FROM         dbo.ARMAIN
UNION ALL
SELECT     Tran_cd, entry_ty, inv_no, date, l_yn, user_name, Sysdate, inv_sr, cate, dept, Print_flag, apgen, apgenby, Apled, Apledby, Apledtime, 
                      Ac_id
FROM         dbo.BPMAIN
UNION ALL
SELECT     Tran_cd, entry_ty, inv_no, date, l_yn, user_name, Sysdate, inv_sr, cate, dept, Print_flag, apgen, apgenby, Apled, Apledby, Apledtime, 
                      Ac_id
FROM         dbo.BRMAIN
UNION ALL
SELECT     Tran_cd, entry_ty, inv_no, date, l_yn, user_name, Sysdate, inv_sr, cate, dept, Print_flag, apgen, apgenby, Apled, Apledby, Apledtime, 
                      Ac_id
FROM         dbo.CNMAIN
UNION ALL
SELECT     Tran_cd, entry_ty, inv_no, date, l_yn, user_name, Sysdate, inv_sr, cate, dept, Print_flag, apgen, apgenby, Apled, Apledby, Apledtime, 
                      Ac_id
FROM         dbo.CPMAIN
UNION ALL
SELECT     Tran_cd, entry_ty, inv_no, date, l_yn, user_name, Sysdate, inv_sr, cate, dept, Print_flag, apgen, apgenby, Apled, Apledby, Apledtime, 
                      Ac_id
FROM         dbo.CRMAIN
UNION ALL
SELECT     Tran_cd, entry_ty, inv_no, date, l_yn, user_name, Sysdate, inv_sr, cate, dept, Print_flag, apgen, apgenby, Apled, Apledby, Apledtime, 
                      Ac_id
FROM         dbo.DCMAIN
UNION ALL
SELECT     Tran_cd, entry_ty, inv_no, date, l_yn, user_name, Sysdate, inv_sr, cate, dept, Print_flag, apgen, apgenby, Apled, Apledby, Apledtime, 
                      Ac_id
FROM         dbo.DNMAIN
UNION ALL
SELECT     Tran_cd, entry_ty, inv_no, date, l_yn, user_name, Sysdate, inv_sr, cate, dept, Print_flag, apgen, apgenby, Apled, Apledby, Apledtime, 
                      Ac_id
FROM         dbo.EPMAIN
UNION ALL
SELECT     Tran_cd, entry_ty, inv_no, date, l_yn, user_name, Sysdate, inv_sr, cate, dept, Print_flag, apgen, apgenby, Apled, Apledby, Apledtime, 
                      Ac_id
FROM         dbo.EQMAIN
UNION ALL
SELECT     Tran_cd, entry_ty, inv_no, date, l_yn, user_name, Sysdate, inv_sr, cate, dept, Print_flag, apgen, apgenby, Apled, Apledby, Apledtime, 
                      Ac_id
FROM         dbo.ESMAIN
UNION ALL
SELECT     Tran_cd, entry_ty, inv_no, date, l_yn, user_name, Sysdate, inv_sr, cate, dept, Print_flag, apgen, apgenby, Apled, Apledby, Apledtime, 
                      Ac_id
FROM         dbo.IIMAIN
UNION ALL
SELECT     Tran_cd, entry_ty, inv_no, date, l_yn, user_name, Sysdate, inv_sr, cate, dept, Print_flag, apgen, apgenby, Apled, Apledby, Apledtime, 
                      Ac_id
FROM         dbo.IPMAIN
UNION ALL
SELECT     Tran_cd, entry_ty, inv_no, date, l_yn, user_name, Sysdate, inv_sr, cate, dept, Print_flag, apgen, apgenby, Apled, Apledby, Apledtime, 
                      Ac_id
FROM         dbo.IRMAIN
UNION ALL
SELECT     Tran_cd, entry_ty, inv_no, date, l_yn, user_name, Sysdate, inv_sr, cate, dept, Print_flag, apgen, apgenby, Apled, Apledby, Apledtime, 
                      Ac_id
FROM         dbo.JVMAIN
UNION ALL
SELECT     Tran_cd, entry_ty, inv_no, date, l_yn, user_name, Sysdate, inv_sr, cate, dept, Print_flag, apgen, apgenby, Apled, Apledby, Apledtime, 
                      Ac_id
FROM         dbo.OBMAIN
UNION ALL
SELECT     Tran_cd, entry_ty, inv_no, date, l_yn, user_name, Sysdate, inv_sr, cate, dept, Print_flag, apgen, apgenby, Apled, Apledby, Apledtime, 
                      Ac_id
FROM         dbo.OPMAIN
UNION ALL
SELECT     Tran_cd, entry_ty, inv_no, date, l_yn, user_name, Sysdate, inv_sr, cate, dept, Print_flag, apgen, apgenby, Apled, Apledby, Apledtime, 
                      Ac_id
FROM         dbo.PCMAIN
UNION ALL
SELECT     Tran_cd, entry_ty, inv_no, date, l_yn, user_name, Sysdate, inv_sr, cate, dept, Print_flag, apgen, apgenby, Apled, Apledby, Apledtime, 
                      Ac_id
FROM         dbo.POMAIN
UNION ALL
SELECT     Tran_cd, entry_ty, inv_no, date, l_yn, user_name, Sysdate, inv_sr, cate, dept, Print_flag, apgen, apgenby, Apled, Apledby, Apledtime, 
                      Ac_id
FROM         dbo.PTMAIN
UNION ALL
SELECT     Tran_cd, entry_ty, inv_no, date, l_yn, user_name, Sysdate, inv_sr, cate, dept, Print_flag, apgen, apgenby, Apled, Apledby, Apledtime, 
                      Ac_id
FROM         dbo.PRMAIN
UNION ALL
SELECT     Tran_cd, entry_ty, inv_no, date, l_yn, user_name, Sysdate, inv_sr, cate, dept, Print_flag, apgen, apgenby, Apled, Apledby, Apledtime, 
                      Ac_id
FROM         dbo.SOMAIN
UNION ALL
SELECT     Tran_cd, entry_ty, inv_no, date, l_yn, user_name, Sysdate, inv_sr, cate, dept, Print_flag, apgen, apgenby, Apled, Apledby, Apledtime, 
                      Ac_id
FROM         dbo.SQMAIN
UNION ALL
SELECT     Tran_cd, entry_ty, inv_no, date, l_yn, user_name, Sysdate, inv_sr, cate, dept, Print_flag, apgen, apgenby, Apled, Apledby, Apledtime, 
                      Ac_id
FROM         dbo.SRMAIN
UNION ALL
SELECT     Tran_cd, entry_ty, inv_no, date, l_yn, user_name, Sysdate, inv_sr, cate, dept, Print_flag, apgen, apgenby, Apled, Apledby, Apledtime, 
                      Ac_id
FROM         dbo.SSMAIN
UNION ALL
SELECT     Tran_cd, entry_ty, inv_no, date, l_yn, user_name, Sysdate, inv_sr, cate, dept, Print_flag, apgen, apgenby, Apled, Apledby, Apledtime, 
                      Ac_id
FROM         dbo.STMAIN
UNION ALL
SELECT     Tran_cd, entry_ty, inv_no, date, l_yn, user_name, Sysdate, inv_sr, cate, dept, Print_flag, apgen, apgenby, Apled, Apledby, Apledtime, 
                      Ac_id
FROM         dbo.SBMAIN
UNION ALL
SELECT     Tran_cd, entry_ty, inv_no, date, l_yn, user_name, Sysdate, inv_sr, cate, dept, Print_flag, apgen, apgenby, Apled, Apledby, Apledtime, 
                      Ac_id
FROM         dbo.TRMAIN
UNION ALL
SELECT     Tran_cd, entry_ty, inv_no, date, l_yn, user_name, Sysdate, inv_sr, cate, dept, Print_flag, apgen, apgenby, Apled, Apledby, Apledtime, 
                      Ac_id
FROM         dbo.MAIN
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

