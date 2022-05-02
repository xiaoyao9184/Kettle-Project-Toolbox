USE [test_kpt_cdc]
GO

CREATE USER [kpt] FOR LOGIN [kpt]
GO

ALTER ROLE [db_owner] ADD MEMBER [kpt]
GO
