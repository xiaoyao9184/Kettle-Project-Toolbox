USE [test_kpt_cdc]
GO


/****** Object:  Table [dbo].[no_key]    Script Date: 2021/11/26 19:38:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[no_key](
	[not_key] [varchar](50),
	[number] [int] NULL,
) ON [PRIMARY]
GO

