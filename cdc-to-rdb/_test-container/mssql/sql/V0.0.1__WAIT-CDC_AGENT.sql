DECLARE @agent NVARCHAR(512);

SELECT @agent = COALESCE(N'SQLAgent$' + CONVERT(SYSNAME, SERVERPROPERTY('InstanceName')), N'SQLServerAgent');

DECLARE @t TABLE (status VARCHAR(100))
INSERT @t (status)
EXEC master.dbo.xp_servicecontrol 'QueryState', @agent;

select status from @t;

DECLARE @status AS NVARCHAR(50)
SELECT @status = status
FROM @t;

select @status;

DECLARE @Counter INT 
SET @Counter=1
WHILE ( @Counter <= 10)
BEGIN
  PRINT 'The counter value is = ' + CONVERT(VARCHAR,@Counter)
  IF @status <= 'Running.'
  BEGIN
  BREAK
  END
    SET @Counter  = @Counter  + 1
END