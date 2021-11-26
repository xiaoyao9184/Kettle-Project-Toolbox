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
