--
-- Create user `kpt`
--
CREATE USER 'kpt'@'%' IDENTIFIED WITH mysql_native_password BY 'kpt.123' PASSWORD EXPIRE DEFAULT;
GRANT USAGE ON *.* TO 'kpt'@'%'
WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'kpt'@'%';
