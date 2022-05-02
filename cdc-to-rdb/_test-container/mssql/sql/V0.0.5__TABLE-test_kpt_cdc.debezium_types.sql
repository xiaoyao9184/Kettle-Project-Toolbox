USE [test_kpt_cdc]
GO


/****** Object:  Table [dbo].[debezium_types]    Script Date: 2021/9/7 15:15:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[debezium_types](
	[_id] [varchar](50),
	[BIT] [bit] NULL,
	[TINYINT] [tinyint] NULL,
	[SMALLINT] [smallint] NULL,
	[INT] [int] NULL,
	[BIGINT] [bigint] NULL,
	[REAL] [real] NULL,
	[FLOAT] [float] NULL,
	[CHAR] [char](10) NULL,
	[VARCHAR] [varchar](50) NULL,
	[TEXT] [text] NULL,
	[NCHAR] [nchar](10) NULL,
	[NVARCHAR] [nvarchar](50) NULL,
	[NTEXT] [ntext] NULL,
	[XML] [xml] NULL,
	[DATETIMEOFFSET] [datetimeoffset](7) NULL,
	[DATE] [date] NULL,
	[TIME_3] [time](3) NULL,
	[TIME_6] [time](6) NULL,
	[TIME_7] [time](7) NULL,
	[DATETIME] [datetime] NULL,
	[SMALLDATETIME] [smalldatetime] NULL,
	[DATETIME2_3] [datetime2](3) NULL,
	[DATETIME2_6] [datetime2](6) NULL,
	[DATETIME2_7] [datetime2](7) NULL,
	[NUMERIC] [numeric](18, 1) NULL,
	[DECIMAL] [decimal](18, 2) NULL,
	[SMALLMONEY] [smallmoney] NULL,
	[MONEY] [money] NULL,
 CONSTRAINT [PK_debezium_types] PRIMARY KEY CLUSTERED 
(
	[_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

