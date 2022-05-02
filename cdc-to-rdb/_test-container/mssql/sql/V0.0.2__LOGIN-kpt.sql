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
