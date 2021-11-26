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
