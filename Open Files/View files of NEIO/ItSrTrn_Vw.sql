-- Added by Sachin N. S. on 14/05/2014 for Bug-21381
-- Created a new View for getting the combined query output from the Serialize Inventory Transaction and Stock Reservation table
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[itSrTrn_vw]
AS
SELECT     Entry_ty, Date, Tran_cd, inv_no, Itserial, It_code, Qty, REntry_ty, RDate, RTran_cd, Rinv_no, RItserial, Rqty, Dc_No, iTran_cd, pmKey, WARE_NM, WARE_NMFR
FROM         dbo.it_SrTrn
UNION ALL
SELECT     Entry_ty, Date, Tran_cd, inv_no, Itserial, It_code, Qty, REntry_ty, RDate, RTran_cd, Rinv_no, RItserial, Rqty, Dc_No, iTran_cd, pmKey, WARE_NM, WARE_NMFR
FROM         dbo.StkResrvSrTrn

