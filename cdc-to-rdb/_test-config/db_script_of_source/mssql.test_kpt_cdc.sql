USE [master]
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [kpt]    Script Date: 2021/9/11 11:06:13 ******/
CREATE LOGIN [kpt] WITH PASSWORD=N'kpt.123', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

ALTER LOGIN [kpt] ENABLE
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [kpt]
GO

/****** Object:  Database [test_kpt_cdc]    Script Date: 2021/9/7 16:25:11 ******/
CREATE DATABASE [test_kpt_cdc]
GO

USE [test_kpt_cdc]
GO

CREATE USER [kpt] FOR LOGIN [kpt]
GO

ALTER ROLE [db_owner] ADD MEMBER [kpt]
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



-- ================================
-- Enable Database for CDC Template
-- ================================
USE [test_kpt_cdc]
GO

EXEC sys.sp_cdc_enable_db
GO


-- ===============================================
-- Enable All Tables of a Database Schema Template
-- ===============================================
USE [test_kpt_cdc]
GO

DECLARE @source_schema sysname, @source_name sysname
SET @source_schema = N'dbo'
DECLARE #hinstance CURSOR LOCAL fast_forward
FOR
	SELECT name  
	FROM [sys].[tables]
	WHERE SCHEMA_NAME(schema_id) = @source_schema
	AND is_ms_shipped = 0
    
OPEN #hinstance
FETCH #hinstance INTO @source_name
	
WHILE (@@fetch_status <> -1)
BEGIN
	EXEC [sys].[sp_cdc_enable_table]
		@source_schema
		,@source_name
		,@role_name = NULL
		,@supports_net_changes = 1
			
	FETCH #hinstance INTO @source_name
END
	
CLOSE #hinstance
DEALLOCATE #hinstance
GO


USE [test_kpt_cdc]
GO

INSERT INTO [dbo].[debezium_types]
           ([_id]
           ,[BIT]
           ,[TINYINT]
           ,[SMALLINT]
           ,[INT]
           ,[BIGINT]
           ,[REAL]
           ,[FLOAT]
           ,[CHAR]
           ,[VARCHAR]
           ,[TEXT]
           ,[NCHAR]
           ,[NVARCHAR]
           ,[NTEXT]
           ,[XML]
           ,[DATETIMEOFFSET]
           ,[DATE]
           ,[TIME_3]
           ,[TIME_6]
           ,[TIME_7]
           ,[DATETIME]
           ,[SMALLDATETIME]
           ,[DATETIME2_3]
           ,[DATETIME2_6]
           ,[DATETIME2_7]
           ,[NUMERIC]
           ,[DECIMAL]
           ,[SMALLMONEY]
           ,[MONEY])
     VALUES
           (1
           ,'0'
           ,1
           ,2
           ,3
           ,4
           ,5.5
           ,6.6
           ,'7'
           ,'8'
           ,'9'
           ,'10'
           ,'11'
        ,'12'
         ,N'<?xml version="1.0" encoding="utf-16" standalone="yes"?><!--This is a test XML file--><filemeta filetype="Audio"><Comments /><AlbumTitle /><TrackNumber /><ArtistName /><Year /><Genre /><TrackTitle /></filemeta>'
           ,'2021-09-07 06:26:20.6220000 +08:00'
           ,'2021-09-07'
           ,'06:26:20.6220000'
           ,'06:26:20.6220000'
           ,'06:26:20.6220000'
           ,'2021-09-07 06:26:20.623'
           ,'2021-09-07 06:26:00'
           ,'2021-09-07 06:26:20.6220000'
           ,'2021-09-07 06:26:20.6220000'
           ,'2021-09-07 06:26:20.6220000'
           ,24.1
           ,25.12
           ,26.1234
           ,27.1234)
GO

USE [test_kpt_cdc]
GO

INSERT INTO [dbo].[debezium_types]
           ([_id]
           ,[BIT]
           ,[TINYINT]
           ,[SMALLINT]
           ,[INT]
           ,[BIGINT]
           ,[REAL]
           ,[FLOAT]
           ,[CHAR]
           ,[VARCHAR]
           ,[TEXT]
           ,[NCHAR]
           ,[NVARCHAR]
           ,[NTEXT]
           ,[XML]
           ,[DATETIMEOFFSET]
           ,[DATE]
           ,[TIME_3]
           ,[TIME_6]
           ,[TIME_7]
           ,[DATETIME]
           ,[SMALLDATETIME]
           ,[DATETIME2_3]
           ,[DATETIME2_6]
           ,[DATETIME2_7]
           ,[NUMERIC]
           ,[DECIMAL]
           ,[SMALLMONEY]
           ,[MONEY])
     VALUES
           (2
           ,'1'
           ,1
           ,NULL
           ,3
           ,4
           ,5.5
           ,6.6
           ,'7'
           ,'8'
           ,NULL
           ,'10'
           ,'11'
           ,'12'
           ,NULL
           ,'2021-09-07 06:26:20.6220000 +08:00'
           ,'2021-09-07'
           ,'06:26:20.6220000'
           ,NULL
           ,'06:26:20.6220000'
           ,'2021-09-07 06:26:20.623'
           ,'2021-09-07 06:26:00'
           ,'2021-09-07 06:26:20.6220000'
           ,NULL
           ,'2021-09-07 06:26:20.6220000'
           ,NULL
           ,25.12
           ,26.1234
           ,27.1234)
GO


