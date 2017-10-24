CREATE TABLE [dbo].[FileAttachMaster](
	[E_CODE] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HEAD_NM] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ATT_FILE] [bit] NULL,
	[SERIAL] [numeric](3, 0) NULL,
	[TYPE] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[dispOrd] [numeric](2, 0) NULL
) ON [PRIMARY]
