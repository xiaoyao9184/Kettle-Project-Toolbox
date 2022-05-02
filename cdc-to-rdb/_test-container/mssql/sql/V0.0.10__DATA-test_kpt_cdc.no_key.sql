USE [test_kpt_cdc]
GO

INSERT INTO [dbo].[no_key]
           ([not_key]
           ,[number])
     VALUES
           ('1'
           ,1)
GO

INSERT INTO [dbo].[no_key]
           ([not_key]
           ,[number])
     VALUES
           ('2'
           ,2)
GO
