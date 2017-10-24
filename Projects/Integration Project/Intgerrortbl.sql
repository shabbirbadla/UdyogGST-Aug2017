USE [Vudyog]
GO
/****** Object:  Table [dbo].[intgerrortbl]    Script Date: 01/21/2008 12:52:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[intgerrortbl](
	[errno] [varchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[errdesc] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF